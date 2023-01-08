function output = create_Vs(element,element_number)
    output = sym(zeros(element_number,1));
    for i=1:element_number
         output(i,1) = element(i).V_s;
    end
end