function [N, E, check_update] = update_NE(vec, p1, N, E, EL, x, y)
    
    check_update = 0;
    check = 1;
    Y = round(N);
    place = 0;
    mid_point = p1+(vec./2);    
    
    for a = 1:length(N)
        if abs(norm(mid_point - N(a,:))) <= 80
            temp = N(a,:);
            place = a;
            check = 0;
            break;
        end
    end

    % New node on intersectionpoint
    if check 
        temp = round(mid_point);
        Lia = ismember(Y, temp, 'rows');
        
        if nnz(Lia)   
            N = Y;
            return
        end

        temp_E = E';
        num_nodes = length(N);
        update_check = 0;
        x(x==num_nodes) = num_nodes+1;
        y(y==num_nodes) = num_nodes+1;
        temp_E(temp_E==num_nodes) = num_nodes+1;

        [tf, index_x] = ismember(x, temp_E, 'rows');
    
        if ~tf
            [tf, index_x] = ismember(flip(x), temp_E, 'rows');
        end
        
        if tf
            x_2 = x(2);
            temp_E(index_x,2) = num_nodes;
            temp_E = [temp_E; [num_nodes x_2]];
            update_check = 1;
            %else
            %viz_struct(N./10, E, 2, 2);
            %fprintf("HM");
        end
        
        [tf, index_y] = ismember(y, temp_E, 'rows');
    
        if ~tf
            [tf, index_y] = ismember(flip(y), temp_E, 'rows');
        end
        
        if tf
            y_2 = y(2);
            temp_E(index_y,2) = num_nodes;
            temp_E = [temp_E; [num_nodes y_2]];
            update_check = 1;
            %else
            %viz_struct(N./10, E, 2, 2);
            %fprintf("HM");
        end

        if update_check
            temp_E = temp_E';
            E = temp_E;
            % Insert new node as the second to last node
            temp = [N(1:num_nodes-1, :); mid_point; N(num_nodes, :)];
            N = temp;
            check_update = 1;
        end 
    else % connect to closest node
        E = E';
        if (place == x(1)) || (place == x(2)) && (place == y(1)) || (place == y(2))
            E = E';
        elseif (place == x(1)) || (place == x(2))
            % Find index of y-connection
            [tf, index] = ismember(y, E, 'rows');
            
            if ~tf
                [tf, index] = ismember(flip(y), E, 'rows');
                if ~tf
                    E = E';
                    return
                end
            end
            
            % Found connection index
            connection = E(index, :); 
            
            connection_1 = [connection(1) place]; % new connection
            [tf_1, ~] = ismember(connection_1, E, 'rows'); %        x_y
            [tf_2, ~] = ismember(flip(connection_1), E, 'rows'); %  y_x    

            if ~(tf_1 || tf_2) % Not previously connected
                E(index, :) = connection_1;
            end

            connection_2 = [connection(2) place];
            [tf_1, ~] = ismember(connection_2, E, 'rows');
            [tf_2, ~] = ismember(flip(connection_2), E, 'rows');

            if ~(tf_1 || tf_2)
                E = [E; connection_2];
            end
            check_update = 1;
            E = E';
        elseif place == y(1) || place == y(2)
            % Find index of x-connection
            [tf, index] = ismember(x, E, 'rows');
            
            if ~tf
                [tf, index] = ismember(flip(x), E, 'rows');
                if ~tf
                    E = E';
                    return
                end
            end
            
            % Found connection index
            connection = E(index, :); 
            
            connection_1 = [connection(1) place]; % new connection
            [tf_1, ~] = ismember(connection_1, E, 'rows'); %        x_y
            [tf_2, ~] = ismember(flip(connection_1), E, 'rows'); %  y_x    

            if ~(tf_1 || tf_2) % Not previously connected
                E(index, :) = connection_1;
            end
            
            connection_2 = [connection(2) place];
            [tf_1, ~] = ismember(connection_2, E, 'rows');
            [tf_2, ~] = ismember(flip(connection_2), E, 'rows');
            
            if ~(tf_1 || tf_2)
                E = [E; connection_2];
            end
            check_update = 1;
            E = E';
        else
            % Remove y-connection
            [tf, index_y] = ismember(y, E, 'rows');
            
            if ~tf
                [tf, index_y] = ismember(flip(y), E, 'rows');
            end
            
            if tf
                E(index_y,:) = [];
            end
            
            % Remove x-connection
            [tf, index_x] = ismember(x, E, 'rows');
           
            if ~tf
                [tf, index_x] = ismember(flip(x), E, 'rows');
            end
            
            if tf
                E(index_x,:) = [];
            end
            check_update = 1;
            E = E';
        end
    end
end