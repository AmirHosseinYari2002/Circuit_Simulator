function output = getImpedance(element,w,s,analysis_type)

if strcmpi(analysis_type , 'Time')
    if strcmp(element.type,'C')
        % Z = 1/(jCw)
        output = 1/(element.value*s);
    elseif strcmp(element.type,'L') || strcmp(element.type,'T')
        % Z = jLw 
        output = element.value*s;
    elseif strcmp(element.type,'R')
        % Z = R
        output = element.value;
    elseif strcmp(element.type,'V') || strcmp(element.type,'Vd')
        % R = 0 => Z = 0
        output = 0;
    elseif strcmp(element.type,'I') || strcmp(element.type,'Id')
        % R = Inf => Z = Inf
        output = Inf;
    end
elseif strcmpi(analysis_type , 'Phasor')    
    if strcmp(element.type,'C')
        % Z = 1/(jCw)
        output = 1/(1i*element.value*w);
    elseif strcmp(element.type,'L')
        % Z = jLw 
        output = 1i*element.value*w;
    elseif strcmp(element.type,'R')
        % Z = R
        output = element.value;
    elseif strcmp(element.type,'V') || strcmp(element.type,'Vd')
        % R = 0 => Z = 0
        output = 0;
    elseif strcmp(element.type,'I') || strcmp(element.type,'Id')
        % R = Inf => Z = Inf
        output = Inf;
    end
end