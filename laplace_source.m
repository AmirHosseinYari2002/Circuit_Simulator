function output = laplace_source(element,s)
phase = element.phase*(pi/180);
ampl = element.ampl;
frequency = element.frequency*2*pi;
output = ampl*(s*cos(phase) - frequency*sin(phase))/(s^2+frequency^2);
end