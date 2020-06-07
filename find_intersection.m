function [N, E, check, check_FEM] = find_intersection(N, E, EL)
    
    % Find intersection between beams
    % Add new node on intersection
    % Update N and E
    % Set 'check' flag if intersection

    checked = [0 0 0 0];
    check = 0;
    check_FEM = 0;
    
    for x=1:length(N)
    
        % Find all vectors belonging to node x
        B = EL(:, x);
        A = x.* ones(length(B),1);
        list = cat(2,A,B);
        vectors = get_vectors(N, list);
    
        % Iterate through all vectors belonging to node x
        for v=1:length(list)
        
            % Break when the list is empty
            if list(v, 2) == 0
                break;
            end

            % Find all vectors that are not connected to THIS vector
            temp = sort_disconnected(EL, x, list(v,2));
        
            if isempty(temp)
                continue;
            end
        
            disconnected = get_vectors(N, temp);
            s = size(temp);
            
            for z = 1:s(1)
                % Check for intersections in 2D
                if ~(ismember([list(v,:) temp(z, :)], checked, 'rows'))
                    if intersect_2D(vectors{v}, disconnected{z})
                        [dist, par_check, vec, p1, ~] = shortest_distance(vectors{v}, disconnected{z});
                        if abs(dist) < 120 && par_check == 0
                            %bef_N = N;
                            %bef_E = E;
                            [N, E, check_update] = update_NE(vec, p1, N, E, EL, temp(z, :), list(v,:));
                            
                            if check_update %isequal(bef_N, N) && isequal(bef_E, E)
                                checked = [checked; [temp(z, :) list(v,:) ]];
                                continue;
                            end
                            
                            check = 1;
                            return
                        else
                            checked = [checked; [temp(z, :) list(v,:) ]];
                        end
                    end
                end
            end
        end   
    end   
end