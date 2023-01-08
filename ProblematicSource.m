function output = ProblematicSource(element,element_number,number)
    % Convert voltage source
    for i=1:element_number
        if element(number).posnode == element(i).posnode
            element(i).V_s = -element(number).value;
        end
        if element(number).posnode == element(i).negnode
            element(i).V_s = element(number).value;
        end
    end
    % Change the number of nodes
    if element(number).negnode > element(number).posnode
        for i=1:element_number
            if element(number).negnode == element(i).posnode
                element(i).posnode = element(number).posnode;
            end
            if element(number).negnode == element(i).negnode
                element(i).negnode = element(number).posnode;
            end
            if element(i).posnode > element(number).negnode 
                element(i).posnode = element(i).posnode -1;
            end
            if element(i).negnode > element(number).negnode 
                element(i).negnode = element(i).negnode -1;
            end
        end
    elseif element(number).negnode < element(number).posnode
        for i=1:element_number
            if element(number).posnode == element(i).posnode
                element(i).posnode = element(number).negnode;
            end
            if element(number).posnode == element(i).negnode
                element(i).negnode = element(number).negnode;
            end
            if element(i).posnode > element(number).posnode 
                element(i).posnode = element(i).posnode -1;
            end
            if element(i).negnode > element(number).posnode 
                element(i).negnode = element(i).negnode -1;
            end
        end
    end
            
    % remove element
    element(number) = [];
    
    output = element;
end