function[fr_1, fr_2, fr_3, fr_4] = fast_sort(population)

    num_fronts = 4;
    len = length(population(:,1));

    % Allocating Fronts
    F_i = cell(num_fronts,1);
    
    fr_1 = [];
    fr_2 = [];
    fr_3 = [];
    fr_4 = [];

    f_pop = [];

    for i=1:len
        n = 0;  %domination count
        S = []; %empty set
    
        for j=1:len
            if ((population(i, 1) < population(j, 1)) && (population(i, 2) < population(j, 2))) || ((population(i, 1) == population(j, 1)) && (population(i, 2) < population(j, 2))) || ((population(i, 1) < population(j, 1)) && (population(i, 2) == population(j, 2)))
                S = [S, j];
            elseif ((population(i, 1) > population(j, 1) && (population(i, 2) > population(j, 2))) || (population(i, 1) == population(j, 1)) && (population(i, 2) > population(j, 2))) || ((population(i, 1) > population(j, 1)) && (population(i, 2) == population(j, 2))) 
                n = n + 1;
            end
        end
    
        % This candidate with fitness 1, fitness 2, and number i
        candidate = [population(i, 1), population(i, 2), i];
    
        if n == 0  
            fr_1 = [fr_1; candidate 1];
        else
            f_pop = [f_pop; [candidate n]];
        end
    end
  
    % Find remaining fronts
    for i = 2:num_fronts
        % Initialize next front 

        temp_pop = f_pop;
        
        % Last front
        if i == num_fronts
            fr_2 = F_i{2,1};
            fr_3 = F_i{3,1};
            fr_4 = sortrows(temp_pop, 4);
            if isempty(fr_1)
                fr_1 = fr_2;
                fr_2 = fr_3;
                fr_3 = fr_4;
            end
            return;
        end
        
        % n-array of 
        n = temp_pop(:,4);
        minimum = min(n);
        temp_front = n == minimum; 
        F_i{i,1} = temp_pop(temp_front, :);
        f_pop(temp_front, :) = [];
    end 
end
