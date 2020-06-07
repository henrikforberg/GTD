function[crit, sharp_angles] = fem_angles(EdgeList, N, i)

    % This function sets a criteria false if:
    % the angles between two beams,
    % are less than 20 degrees.
    
    %Threshold angle
    T = 20;
    
    crit = 1; % Check
    list = EdgeList(:, i);
    sharp_angles = [];
    
    temp = [0 0];
    
    % Iterate through node's edgelist
    for x=1:length(list)
        if list(x) == 0
            break; % Break on end
        else
            % Define beam vectors
            z = N(list(x), :) - N(i, :);
            
            for y=2:length(list)
                a = not(ismember([list(x) list(y)], temp, 'rows'));
                b = not(list(y) == 0);
                c = not(y==x); 
                if a && b && c
                    vect = N(list(y), :) - N(i, :);
                    angle = atan2d(norm(cross(vect,z)),dot(vect,z));
            
                    if angle < T || ((360-T) < angle)
                        sharp_angles = [sharp_angles; angle];
                        crit = false;
                    end
                    temp = [temp; [list(y) list(x)]];
                end
            end
        end
    end
end
