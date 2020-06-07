function [crit, sharp_angles] = fdm_angles(EL, N, scale, i)

    % This function sets a criteria true if:
    % the angle between the normal of the XY-plane,
    % and the vector edges of a given node,
    % is less than 45 degrees.
  
    z = [0 0 1] - [0 0 0]; % Normal on the XY-plane
    crit = true; % Check
    list = EL(:, i);
    sharp_angles = [];
   
    
    for x=1:length(list)
      
        if list(x) == 0
            % Break at end of list
            break;
        else
            % End oordinate
            N_x = N(list(x), :);
            
            if (N_x(3) == scale) && (N(i,3) == scale)
                continue; % Horizontal ground beam
            end
            
            vect = N_x - N(i, :);
            angle = atan2d(norm(cross(vect,z)),dot(vect,z));
            
            if angle >= 90
                angle = 180 - angle;
            end
            
            if angle > 45 
                sharp_angles = [sharp_angles, angle];
                crit = false;
                return % deactivate if full angle scope is needed
            end
        end
    end
end
