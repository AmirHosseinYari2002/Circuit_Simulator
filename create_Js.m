function output = create_Js(element,element_number)
    output = sym(zeros(element_number,1));
    for i=1:element_number
        if strcmp(element(i).type,'I')
            output(i,1) = sym(element(i).value);
        end
    end
end