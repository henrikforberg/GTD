function [selected] = crowding_operator(front, num)

    % Find first instance of a worse rank after position num
    init = 1;
    f = front(:,4);

    if f(1) == f(end)
        % All candidates have the same rank
        selected = crowding_distance_sort(front, num);
    elseif f(1) == f(num)
        % Find rank larger than rank in position num
        init = find(f > front(num, 4), 1);
        % Sort candidates of the best rank
        selected = sorting_alg(front, 1, init, num); 
    else
        % Find the worst rank inside the range (1:num)
        while 1
            if not(front(init, 4) == front(num, 4))
                % Find next rank
                init = find(f > front(init, 4), 1); 
            else
                % Find the position of the *next* rank
                next = find(f > front(init, 4), 1);
                selected = sorting_alg(front, init, next, num);
                return;
            end
        end 
    end
end
    
    
function [selected] = sorting_alg(front, from, to, num)   

    % Allocate selected candidates
    selected = zeros(num, 1);   
    
    % if from is larger than 1
    if from > 1 && from < num-1
        % From is between 2 and selcetion num
        selected(1:from) = front(1:from,3);
        selected(from+1:num) = crowding_distance_sort(front(from+1:to,1:3), num-from);
    elseif to == num || from == num || from == (num-1)
        % To is equal to selection num
        selected(1:num) = front(1:num,3);
        return
    elseif to > num
        selected(1:num) = crowding_distance_sort(front(from:to,1:3), num);
        return
    else
        fprintf("wtf");
    end
end

function [selected] = crowding_distance_sort(front, num)

    sorted = sortrows(front, 1);
    len = length(sorted(:,3));
    
    best_obj_1 = sorted(1,1);
    worst_obj_1 = sorted(len, 1);
    dif_obj_1 = abs(best_obj_1-worst_obj_1);
    
    if dif_obj_1 == 0
        dif_obj_1 = 1/intmax;
    end
    
    best_obj_2 = sorted(len,2);
    worst_obj_2 = sorted(1, 2);
    dif_obj_2 = abs(best_obj_2-worst_obj_2);
    
    if dif_obj_2 == 0
        dif_obj_2 = 1/intmax;
    end
    
    % Initialize distances matrix
    distances = zeros(len,2);
    distances(1,1) = intmax;
    distances(1,2) = sorted(1,3);
    distances(len,1) = intmax;
    distances(len,2) = sorted(len,3);
    
    for x = 2:len-1
        dist_a = (sorted(x+1,1) - sorted(x-1,1))/dif_obj_1;
        dist_b = (sorted(x+1,2) - sorted(x-1,2))/dif_obj_2;
        distances(x,1) = dist_a + dist_b;
        distances(x,2) = sorted(x,3);
    end
   
    a = size(distances);
    
    if a(1) > 2
        selected = sortrows(distances,1, 'descend');
        selected = selected(1:num,2);
    else
        selected = distances;
    end
end


