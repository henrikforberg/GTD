function N = morph(N, scale, top, bottom)
    temp_N = N;
    num_nodes = length(temp_N);
    
    for j = 1:num_nodes-1
        mov = [0 1 0];
        movement = mov(randperm(3));
             
        if j < 5
             movement(3) = 0;
        end
        
        if (movement(3) == 1) && ((scale/4) + temp_N(j, 3) > top-(scale/4))
            temp_N(j, 3) =  N(j, 3) - (scale/4);
        elseif movement(3) == 1 && N(j, 3) < (bottom + scale/4)
            temp_N(j, 3) =  scale;
        else
            temp_N(j, 1) =  temp_N(j, 1) + movement(1)*randi([-2*scale 2*scale]);
            temp_N(j, 2) =  temp_N(j, 2) + movement(2)*randi([-2*scale 2*scale]);
            temp = movement(3)*randi([-2*scale 2*scale]);
                    
            if (temp_N(j, 3) + temp) < (top-scale) && ((temp_N(j, 3) + temp) > bottom)
                temp_N(j, 3) =  temp_N(j, 3) + temp;                       
            end
        end
    end
    N = temp_N;
end