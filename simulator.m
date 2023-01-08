function [V,J,element_number,branch_number,element,stopsim] = simulator(element,element_number,branch_number,node_number,w,s,analysis_type)
    % KVL Violation
   
    KVL_violation = 0;
    KCL_violation = 0;
    stopsim = 0;
    
    vsource_num = 0;
    all_vsource = 0;
    all_isource = 0;
    same_polarity = 1;
    in_one_direction = 1;
    all_equal = 1;
    
    for i=1:element_number
        if strcmpi(element(i).type,'V')
            vsource_num = vsource_num + 1;
        end
    end
    
    % Series current sources
    
    if ~strcmpi(analysis_type,'Time')
    
    for i=1:element_number
        for j=1:element_number
            if ~strcmp(element(j).type , 'I')
                all_isource = 0;
                break;
            else
                all_isource = 1;
            end
        end
        for j=1:element_number
            if (j ~= i) && (element(j).posnode == element(i).posnode)
                in_one_direction = 0;
            end
        end
        for j=1:element_number
            if (j ~= i) && (element(j).value ~= element(i).value)
                all_equal = 0;
            end
        end
    end
    if all_isource && in_one_direction && all_equal
        KCL_violation = 0;
        stopsim = 1;
        disp('The solution of this cicrcuit is not unique! (Series equal current sources)');
    elseif all_isource
        KCL_violation = 1;
        stopsim = 1;
        disp('KCL has been violated!! Please correct the circuit.');
    end
    
    
    for i=1:element_number
            for j=1:element_number
                if ~strcmpi(element(j).type , 'V')
                    all_vsource = 0;
                    break;
                else
                    all_vsource = 1;
                end
            end
        for j=1:element_number
            if (j ~= i) && (element(j).posnode == element(i).negnode)
                same_polarity = 0;
            end
        end
        for j=1:element_number
            if (j ~= i) && (element(j).value ~= element(i).value)
                all_equal = 0;
            end
        end
        end
        if all_vsource && same_polarity && all_equal
            KVL_violation = 0;
            stopsim = 1;
            disp('The solution of this cicrcuit is not unique! (Parallel equal voltage sources)');
        elseif all_vsource
            KVL_violation = 1;
            stopsim = 1;
            disp('KVL has been violated!! Please correct the circuit.');
        end
    end
    
    if ~stopsim
        
    for i=1:element_number
        if strcmpi(element(i).type,'V')
            element = ProblematicSource(element,element_number,i); 
            branch_number = branch_number - 1;
            break;
        end
    end
    element_number = branch_number;
    
    % Create A
    A = sym(zeros(node_number,branch_number));
    for i=1:branch_number
       A(element(i).posnode,i) = sym(1); 
       A(element(i).negnode,i) = sym(-1); 
    end
    
    % Create Y_b
    
    Y_b = sym(zeros(branch_number,branch_number));
    
    for i=1:branch_number
       if (Y_b(i,i) == 0)
           Y_b(i,i) = sym(1/element(i).Z);
       end
       % check Coupled Inductor
       if element(i).M ~= 0
          
          CoupledWith = element(i).CoupledWith-vsource_num;
          if i < CoupledWith
          M = element(i).M;
          L = [element(i).value M ; M element(CoupledWith).value];
          Gamma = inv(L);
          if strcmpi(analysis_type , 'Time')
              Y_b(i,i) = Gamma(1,1)/s;
              Y_b(CoupledWith,CoupledWith) = Gamma(2,2)/s;
              Y_b(i,CoupledWith) = Gamma(1,2)/s;
              Y_b(CoupledWith,i) = Gamma(2,1)/s;
          elseif strcmpi(analysis_type , 'AC') || strcmpi(analysis_type , 'DC')
              Y_b(i,i) = Gamma(1,1)/(1i*w);
              Y_b(CoupledWith,CoupledWith) = Gamma(2,2)/(1i*w);
              Y_b(i,CoupledWith) = Gamma(1,2)/(1i*w);
              Y_b(CoupledWith,i) = Gamma(2,1)/(1i*w);
          end
          end
       end
       
       % check dependent sources
    
       % I -> V
       
        if strcmpi(element(i).type,'Id') && strcmpi(element(i).dependency_parameter,'V') 
%             disp('C')
            ed = element(i).dependency;
            epn = element(i).posnode;
            enn = element(i).negnode;
            for j=1:branch_number
                if (epn == element(j).posnode) && (enn == element(j).negnode) && (j ~= i)
                    Y_b(j , ed) = element(i).gain;
                elseif (epn == element(j).negnode) && (enn == element(j).posnode) 
                    Y_b(j , ed) = -element(i).gain;
                end
            end
%             disp(Y_b)
        end
        
        % I -> I
        
        if strcmpi(element(i).type,'Id') && strcmpi(element(i).dependency_parameter,'I') 
            ed = element(i).dependency;
            epn = element(i).posnode;
            enn = element(i).negnode;
            for j=1:branch_number
                if (epn == element(j).posnode) && (enn == element(j).negnode) && (j ~= i)
                    Y_b(j , ed) = element(i).gain * Y_b(ed , ed);
                elseif (epn == element(j).negnode) && (enn == element(j).posnode)
                    Y_b(j , ed) = -element(i).gain * Y_b(ed , ed);
                end
            end
        end
        
        % V -> V
        
        if strcmpi(element(i).type,'Vd') && strcmpi(element(i).dependency_parameter,'V') 
            ed = element(i).dependency;
            epn = element(i).posnode;
            enn = element(i).negnode;
            for j=1:branch_number
                if (epn == element(j).posnode) && (j ~= i) 
                    Y_b(j , ed) = element(i).gain * Y_b(j , j) ;
                elseif (epn == element(j).negnode) && (enn == element(j).posnode)
                    Y_b(j , ed) = -element(i).gain * Y_b(j , j);
                end
            end
        end
         
        % V -> I
        
        if strcmp(element(i).type,'Vd') && strcmp(element(i).dependency_parameter,'I') 
            ed = element(i).dependency;
            epn = element(i).posnode;
            enn = element(i).negnode;
            for j=1:branch_number
                if (epn == element(j).posnode) && (j ~= i) 
                    Y_b(j , ed) = element(i).gain * Y_b(j , j) * Y_b(ed , ed);
                elseif (epn == element(j).negnode) && (enn == element(j).posnode)
                    Y_b(j , ed) = -element(i).gain * Y_b(j , j) * Y_b(ed , ed);
                end
            end
        end
%         if (i == branch_number)
%             disp(Y_b);
%         end
    end
        
%     disp(Y_b)
    
    % Create Y_n
    Y_n = A*Y_b*transpose(A);
    % Create V_s
    V_s = create_Vs(element,element_number);
    % Create J_s
    J_s = create_Js(element,element_number);
    % Create I_s
    I_s = A * (Y_b * V_s - J_s);
    % find E
    E = linsolve(Y_n,I_s);
    % find V
    V = transpose(A) * E;
    % find J
    J = Y_b * V + J_s - Y_b * V_s;
    
    if simplify(A*J) ~= 0
        KCL_violation = 0;
        disp('KCL has been violated!! Please correct the circuit.');
    end
    
    else 
        V = [];
        J = [];
    end
%     disp(Y_b)
%     disp(A)
% disp(stopsim)
end
        
        
        
        
        
        
        
        
        
      

        
        
        
        
        