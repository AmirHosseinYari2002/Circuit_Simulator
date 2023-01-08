clear; clc; close all;

syms w;
syms s;
syms t;


% AC or DC
analysis_type = input('Analysis Type (AC,DC,Time) = ');
if strcmpi(analysis_type,'AC')
    start_freq = input('Start frequency = ');
    steps = input('Steps = ');
    end_freq = input('End frequency = ');
    freq = linspace(start_freq , end_freq , steps);
elseif strcmpi(analysis_type,'DC')
    freq = 0;
elseif strcmpi(analysis_type,'Time')
    end_time = input('End time = ');
    steps = input('Steps = ');
    time = linspace(0 , end_time , steps);
end

element_number = input('number of elements = ');
disp(' ');

%get elements information

% for i=1:element_number
%     
%     element(i).id = i;
%     element(i).type = input('type of element = ');
%     element(i).posnode = input('node number that connected to the positive head = ');
%     element(i).negnode = input('node number that connected to the negative head = ');
%     element(i).V_s = 0;
%     element(i).J_s = 0;
%     
%     if (strcmpi(element(i).type,'V') || strcmpi(element(i).type,'I')) && strcmpi(analysis_type,'Time')
%         if strcmpi(element(i).type,'V')
%         element(i).ampl = input('Amplitude[V] = ');
%         elseif strcmpi(element(i).type,'I')
%         element(i).ampl = input('Amplitude[A] = ');  
%         end
%         element(i).frequency = input('Frequency[Hz] = ');
%         element(i).phase = input('Phase[degree] = ');
%         element(i).value = laplace_source(element,s);
%     end
%     
%     element(i).M = 0;
%     element(i).CoupledWith = 0;
%     
%     if strcmp(element(i).type,'C') && strcmpi(analysis_type,'Time')
%         element(i).J_s = -element(i).value * input('initial voltage [V] = ');
%     end
%     
%      if strcmp(element(i).type,'L') && strcmpi(analysis_type,'Time')
%         element(i).J_s = -element(i).value * input('initial current [A] = ');
%      end
%     
%     if strcmp(element(i).type,'L')  
%         element(i).M = input('M (Cross Inductance) = ');
%         if (element(i).M ~= 0)
%             element(i).CoupledWith = input('Coupled With (Inductor ID) = ');
%         end
%     end
%     
%     if strcmpi(element(i).type,'T')
%         element(i).n = input('n = ');
%         element(i).value = 1000000*(element(i).n^2);
%         for j=1:j<i
%             if strcmpi(element(j).type , 'T')
%                 element(i).M = 1000000*element(j).n*element(i).n;
%                 element(j).M = element(i).M;
%                 element(i).CoupledWith = j;
%                 element(j).CoupledWith = i;
%                 break;
%             end
%         end
%     end
%     
%     if strcmpi(element(i).type,'Vd') || strcmpi(element(i).type,'Id')
%         element(i).dependency = input('Depended to (element id) = ');
%         element(i).dependency_parameter = input('dependency parameter  (V , I) =');
%         element(i).gain = input('gain of source = ');
%         element(i).value = 0;
%     end
%     
%     if (strcmpi(element(i).type,'Vd') || strcmpi(element(i).type,'Id'))
%         element(i).value = 0;
%     elseif ~((strcmpi(element(i).type,'I') || strcmpi(element(i).type,'V')) && strcmpi(analysis_type,'Time'))
%         element(i).value = input('value of element = ');
%     end
%     
%     if strcmpi(analysis_type,'DC') || strcmpi(analysis_type,'AC')
%         element(i).Z = getImpedance(element(i),w,s,'Phasor');
%     elseif strcmpi(analysis_type,'Time')
%         element(i).Z = getImpedance(element(i),w,s,'Time');
%     end
%     
%     disp('THE INFORMATION OF THIS ELEMENT WAS COMPLETED');
%     disp(' ');
% end


% ============ Test Cases ============

% current source
element(1).id = 1; % element ID number
element(1).posnode = 2; % node ID connected to the element positive terminal
element(1).negnode = 1; % node ID connected to the element negative terminal
element(1).type = 'I'; % can be R (resistor), C (capacitor), L (inductor), V (independent voltage source), I (independent current source)
element(1).value = 1+1i; % value is a real number for R, L, and C elements and is a complex phasor for independent sources
element(1).volres = []; % a complex vector which is filled by element voltage frequency response
element(1).curres = []; % a complex vector which is filled by element current frequency response
element(1).Z = getImpedance(element(1),w,s,'Phasor');
element(1).V_s = 0;
element(1).M = 0;

% resistor
element(2).id = 2; % element ID number
element(2).posnode = 1; % node ID connected to the element positive terminal
element(2).negnode = 2; % node ID connected to the element negative terminal
element(2).type = 'R'; % can be R (resistor), C (capacitor), L (inductor), V (independent voltage source), I (independent current source)
element(2).value = 20; % value is a real number for R, L, and C elements and is a complex phasor for independent sources
element(2).volres = []; % a complex vector which is filled by element voltage frequency response
element(2).curres = []; % a complex vector which is filled by element current frequency response
element(2).Z = getImpedance(element(2),w,s,'Phasor');
element(2).V_s = 0;
element(2).M = 0;

% inductor
element(4).id = 4; % element ID number
element(4).posnode = 3; % node ID connected to the element positive terminal
element(4).negnode = 2; % node ID connected to the element negative terminal
element(4).type = 'L'; % can be R (resistor), C (capacitor), L (inductor), V (independent voltage source), I (independent current source)
element(4).value = 0.001; % value is a real number for R, L, and C elements and is a complex phasor for independent sources
element(4).volres = []; % a complex vector which is filled by element voltage frequency response
element(4).curres = []; % a complex vector which is filled by element current frequency response
element(4).Z = getImpedance(element(4),w,s,'Phasor');
element(4).V_s = 0;
element(4).M = 0;

% capacitor
element(3).id = 3; % element ID number
element(3).posnode = 3; % node ID connected to the element positive terminal
element(3).negnode = 2; % node ID connected to the element negative terminal
element(3).type = 'C'; % can be R (resistor), C (capacitor), L (inductor), V (independent voltage source), I (independent current source)
element(3).value = 0.001; % value is a real number for R, L, and C elements and is a complex phasor for independent sources
element(3).volres = []; % a complex vector which is filled by element voltage frequency response
element(3).curres = []; % a complex vector which is filled by element current frequency response
element(3).Z = getImpedance(element(3),w,s,'Phasor');
element(3).V_s = 0;
element(3).M = 0;


% voltage source
element(5).id = 5; % element ID number
element(5).posnode = 3; % node ID connected to the element positive terminal
element(5).negnode = 1; % node ID connected to the element negative terminal
element(5).type = 'V'; % can be R (resistor), C (capacitor), L (inductor), V (independent voltage source), I (independent current source)
element(5).value = 2; % value is a real number for R, L, and C elements and is a complex phasor for independent sources
element(5).volres = []; % a complex vector which is filled by element voltage frequency response
element(5).curres = []; % a complex vector which is filled by element current frequency response
element(5).Z = getImpedance(element(5),w,s,'Phasor');
element(5).V_s = 0;
element(5).M = 0;



% %test case a             RLC Parallel
% 
% % current source
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'I';
% element(1).value = 1+1i;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % resistor
% element(2).id = 2; 
% element(2).posnode = 1; 
% element(2).negnode = 2;
% element(2).type = 'R'; 
% element(2).value = 20; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % inductor
% element(3).id = 3;
% element(3).posnode = 1;
% element(3).negnode = 2; 
% element(3).type = 'L'; 
% element(3).value = 0.001;
% element(3).volres = []; 
% element(3).curres = [];
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;
% 
% % capacitor
% element(4).id = 4;
% element(4).posnode = 1; 
% element(4).negnode = 2;
% element(4).type = 'C';
% element(4).value = 0.001; 
% element(4).volres = []; 
% element(4).curres = [];
% element(4).Z = getImpedance(element(4),w,s,'Phasor');
% element(4).V_s = 0;
% element(4).M = 0;

% % test case c         Problematic Source
% 
% % capacitor
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'C';
% element(1).value = 0.01;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % resistor1
% element(2).id = 2; 
% element(2).posnode = 2; 
% element(2).negnode = 1;
% element(2).type = 'R'; 
% element(2).value = 1; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % voltage source
% element(3).id = 3;
% element(3).posnode = 3;
% element(3).negnode = 2; 
% element(3).type = 'V'; 
% element(3).value = 2;
% element(3).volres = []; 
% element(3).curres = [];
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;
% 
% % inductor
% element(4).id = 4;
% element(4).posnode = 4; 
% element(4).negnode = 3;
% element(4).type = 'L';
% element(4).value = 0.1; 
% element(4).volres = []; 
% element(4).curres = [];
% element(4).Z = getImpedance(element(4),w,s,'Phasor');
% element(4).V_s = 0;
% element(4).M = 0;
% 
% % resistor2
% element(5).id = 5;
% element(5).posnode = 4; 
% element(5).negnode = 3;
% element(5).type = 'R';
% element(5).value = 2; 
% element(5).volres = []; 
% element(5).curres = [];
% element(5).Z = getImpedance(element(5),w,s,'Phasor');
% element(5).V_s = 0;
% element(5).M = 0;
% 
% % resistor3
% element(6).id = 6;
% element(6).posnode = 4; 
% element(6).negnode = 1;
% element(6).type = 'R';
% element(6).value = 1; 
% element(6).volres = []; 
% element(6).curres = [];
% element(6).Z = getImpedance(element(6),w,s,'Phasor');
% element(6).V_s = 0;
% element(6).M = 0;

% % test case e             RLC Series Phasor
% 
% % voltage source
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'V';
% element(1).value = 4;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % resistor
% element(2).id = 2; 
% element(2).posnode = 3; 
% element(2).negnode = 2;
% element(2).type = 'R'; 
% element(2).value = 5; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % inductor
% element(3).id = 3;
% element(3).posnode = 4;
% element(3).negnode = 3; 
% element(3).type = 'L'; 
% element(3).value = 0.03;
% element(3).volres = []; 
% element(3).curres = [];
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;
% 
% % capacitor
% element(4).id = 4;
% element(4).posnode = 1; 
% element(4).negnode = 4;
% element(4).type = 'C';
% element(4).value = 0.007; 
% element(4).volres = []; 
% element(4).curres = [];
% element(4).Z = getImpedance(element(4),w,s,'Phasor');
% element(4).V_s = 0;
% element(4).M = 0;

% %test case e             RLC Series Time
% 
% % current source
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'V';
% % element(1).value = 2;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Time');
% element(1).phase = 0;
% element(1).ampl = 1;
% element(1).frequency = 1;
% element(1).value = laplace_source(element(1),s);
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % resistor
% element(2).id = 2; 
% element(2).posnode = 3; 
% element(2).negnode = 2;
% element(2).type = 'R'; 
% element(2).value = 1; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Time');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % inductor
% element(3).id = 3;
% element(3).posnode = 4;
% element(3).negnode = 3; 
% element(3).type = 'L'; 
% element(3).value = 0.1;
% element(3).volres = []; 
% element(3).curres = [];
% element(3).Z = getImpedance(element(3),w,s,'Time');
% element(3).V_s = 0;
% element(3).M = 0;
% 
% % capacitor
% element(4).id = 4;
% element(4).posnode = 1; 
% element(4).negnode = 4;
% element(4).type = 'C';
% element(4).value = 0.01; 
% element(4).volres = []; 
% element(4).curres = [];
% element(4).Z = getImpedance(element(4),w,s,'Time');
% element(4).V_s = 0;
% element(4).M = 0;

% test case c         Coupled Circuit

% voltage source
element(1).id = 1;
element(1).posnode = 2; 
element(1).negnode = 1; 
element(1).type = 'V';
element(1).value = 3;
element(1).volres = [];
element(1).curres = [];
element(1).Z = getImpedance(element(1),w,s,'Phasor');
element(1).V_s = 0;
element(1).M = 0;

% capacitor1
element(2).id = 2; 
element(2).posnode = 3; 
element(2).negnode = 2;
element(2).type = 'C'; 
element(2).value = 0.01; 
element(2).volres = []; 
element(2).curres = []; 
element(2).Z = getImpedance(element(2),w,s,'Phasor');
element(2).V_s = 0;
element(2).M = 0;

% resistor1
element(3).id = 3;
element(3).posnode = 4;
element(3).negnode = 3; 
element(3).type = 'R'; 
element(3).value = 1;
element(3).volres = []; 
element(3).curres = [];
element(3).Z = getImpedance(element(3),w,s,'Phasor');
element(3).V_s = 0;
element(3).M = 0;

% inductor1
element(4).id = 4;
element(4).posnode = 4; 
element(4).negnode = 1;
element(4).type = 'L';
element(4).value = 0.2; 
element(4).volres = []; 
element(4).curres = [];
element(4).Z = getImpedance(element(4),w,s,'Phasor');
element(4).V_s = 0;
element(4).M = 0.1;
element(4).CoupledWith = 5; 

% inductor2
element(5).id = 5;
element(5).posnode = 5; 
element(5).negnode = 1;
element(5).type = 'L';
element(5).value = 0.3; 
element(5).volres = []; 
element(5).curres = [];
element(5).Z = getImpedance(element(5),w,s,'Phasor');
element(5).V_s = 0;
element(5).M = 0.1;
element(5).CoupledWith = 4; 

% capacitor2
element(6).id = 6;
element(6).posnode = 6; 
element(6).negnode = 1;
element(6).type = 'C';
element(6).value = 0.01; 
element(6).volres = []; 
element(6).curres = [];
element(6).Z = getImpedance(element(6),w,s,'Phasor');
element(6).V_s = 0;
element(6).M = 0;

% resistor2
element(7).id = 7;
element(7).posnode = 5; 
element(7).negnode = 6;
element(7).type = 'R';
element(7).value = 1; 
element(7).volres = []; 
element(7).curres = [];
element(7).Z = getImpedance(element(7),w,s,'Phasor');
element(7).V_s = 0;
element(7).M = 0;

% %test case           Dependent Current Source
% 
% % dependent current source
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'Id';
% element(1).dependency = 3;
% element(1).dependency_parameter = 'V';
% element(1).gain = 6;
% element(1).value = 0;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % resistor
% element(2).id = 2; 
% element(2).posnode = 2; 
% element(2).negnode = 1;
% element(2).type = 'R'; 
% element(2).value = 0.5; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % resistor
% element(3).id = 3;
% element(3).posnode = 4;
% element(3).negnode = 3; 
% element(3).type = 'R'; 
% element(3).value = 0.2;
% element(3).volres = []; 
% element(3).curres = [];
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;
% 
% % capacitor
% element(4).id = 4;
% element(4).posnode = 3; 
% element(4).negnode = 5;
% element(4).type = 'C';
% element(4).value = 0.01; 
% element(4).volres = []; 
% element(4).curres = [];
% element(4).Z = getImpedance(element(4),w,s,'Phasor');
% element(4).V_s = 0;
% element(4).M = 0;
% 
% % voltage source
% element(5).id = 5;
% element(5).posnode = 4; 
% element(5).negnode = 5;
% element(5).type = 'V';
% element(5).value = 6; 
% element(5).volres = []; 
% element(5).curres = [];
% element(5).Z = getImpedance(element(5),w,s,'Phasor');
% element(5).V_s = 0;
% element(5).M = 0;


%test case f             Parallel Voltage Sources

% % voltage source 1
% element(1).id = 1;
% element(1).posnode = 1; 
% element(1).negnode = 2; 
% element(1).type = 'V';
% element(1).value = 2;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % voltage source 2
% element(2).id = 2; 
% element(2).posnode = 1; 
% element(2).negnode = 2;
% element(2).type = 'V'; 
% element(2).value = 2; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % voltage source 3
% element(3).id = 3; 
% element(3).posnode = 2; 
% element(3).negnode = 1;
% element(3).type = 'V'; 
% element(3).value = 2; 
% element(3).volres = []; 
% element(3).curres = []; 
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;

%test case f             Series Current Sources

% % current source 1
% element(1).id = 1;
% element(1).posnode = 2; 
% element(1).negnode = 1; 
% element(1).type = 'I';
% element(1).value = 2;
% element(1).volres = [];
% element(1).curres = [];
% element(1).Z = getImpedance(element(1),w,s,'Phasor');
% element(1).V_s = 0;
% element(1).M = 0;
% 
% % current source 2
% element(2).id = 2; 
% element(2).posnode = 2; 
% element(2).negnode = 3;
% element(2).type = 'I'; 
% element(2).value = 2; 
% element(2).volres = []; 
% element(2).curres = []; 
% element(2).Z = getImpedance(element(2),w,s,'Phasor');
% element(2).V_s = 0;
% element(2).M = 0;
% 
% % current source 3
% element(3).id = 3; 
% element(3).posnode = 1; 
% element(3).negnode = 3;
% element(3).type = 'I'; 
% element(3).value = 2; 
% element(3).volres = []; 
% element(3).curres = []; 
% element(3).Z = getImpedance(element(3),w,s,'Phasor');
% element(3).V_s = 0;
% element(3).M = 0;


% define branch number
branch_number = element_number;
% define node number(The last node is the base node. For this reason, the initial value is -1)
node_number = -1;
for i=1:element_number
    if element(i).posnode > node_number
        node_number = element(i).posnode;
    end
    if element(i).negnode > node_number
        node_number = element(i).negnode;
    end
end
for i=1:element_number
    if strcmpi(element(i).type,'V')
        node_number = node_number - 1;
    end
end
% find voltages and currents of all branch
[V,J,element_number,branch_number,element,stopsim] = simulator(element,element_number,branch_number,node_number,w,s,analysis_type);
%  disp(stopsim)
if ~stopsim
% fill volres and curres
    for i=1:element_number

        if strcmpi(analysis_type,'Time')
            element(i).volres = vpa(subs(ilaplace(V(i)),t,time));
            element(i).curres = vpa(subs(ilaplace(J(i)),t,time));
            %plot
            name = strcat(element(i).type,' Time Domain');
            figure('Name',name);
            subplot(2,1,1);
            plot(time,element(i).volres,'m','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Voltage$','Interpreter','latex','FontSize',12);
            grid on
            grid minor
            subplot(2,1,2);
            plot(time,element(i).curres,'c','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Current$','Interpreter','latex','FontSize',12);
            grid on
            grid minor

        elseif strcmpi(analysis_type,'AC') || strcmpi(analysis_type,'DC')
            element(i).volres = double(subs(V(i),w,2*pi*freq));
            element(i).curres = double(subs(J(i),w,2*pi*freq));
        if strcmpi(analysis_type,'AC')
            % plot
            name = strcat(element(i).type,' Bode Diagrams');
            figure('Name',name);
            subplot(2,2,1);
            plot(freq,abs(element(i).volres),'m','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Voltage$ $Abs$','Interpreter','latex','FontSize',12);
            grid on
            grid minor
            subplot(2,2,2);
            plot(freq,angle(element(i).volres),'m','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Voltage$ $Phase$','Interpreter','latex','FontSize',12);
            grid on
            grid minor
            subplot(2,2,3);
            plot(freq,abs(element(i).curres),'c','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Current$ $Abs$','Interpreter','latex','FontSize',12);
            grid on
            grid minor
            subplot(2,2,4);
            plot(freq,angle(element(i).volres),'c','linewidth',2);
            title(['element ID : ',int2str(element(i).id)],'FontSize',10);
            xlabel('$frequency$','Interpreter','latex','FontSize',12);
            ylabel('$Current$ $Phase$','Interpreter','latex','FontSize',12);
            grid on
            grid minor
        elseif strcmpi(analysis_type,'DC')
            disp('element ID : '); 
            disp(element(i).id);
            disp('voltage = ');
            disp(element(i).volres);
            disp('current = ');
            disp(element(i).curres);
            disp(' ');
        end
    end
end
end
    

