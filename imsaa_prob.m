function P = imsaa_prob(delta_f, temperature)

    if delta_f > 100 % FEM Error
        P = 0;
        return;
    end
    
    % Probability P:
    p = 1/(1+(2*(exp(delta_f/temperature))));
    P = randi(1000) < ((1000*p)/3);
end