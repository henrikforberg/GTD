function [N, E] = crossover(dom, sub, far_E, mor_E)   

    % Uniform node-coordinate crossover operator
    
    if length(dom) < 6 || length(sub) < 6
        N = dom;
        E = far_E;
        return 
    end
    
    dom_len = length(dom)-1;
    sub_len = length(sub)-1;
    
    if sub_len > dom_len
        num = randi(dom_len);
        sub_len = dom_len;
        temp = dom;
        dom = sub;
        sub = temp;
        far_E = mor_E;
    else
        num = randi(sub_len);
    end
    
    positions = randperm(sub_len, num);

    for i = 1:num
        dom(positions(i), :) = sub(positions(i), :);
    end
    
    N = dom;
    E = far_E;
end