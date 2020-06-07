function[check_fdm, check_fitness, N, E, EL, fitness, L_fitness] = msaa_optimize(FDM, N, E, EL, check_i, sharp_i, fitness, L_fitness, scale, alpha, i)
    
    check_fitness = false;
    check_fdm = check_i;
    
    % Search in x-direction
    [fem_check_x, fdm_check_x, sharp_x, fitness_x, L_x, N_x, E_x, EL_x] = evaluate_update(FDM, N, E, EL, 1, alpha, scale, i);

    if fem_check_x
        if ((fdm_check_x && check_i) || fdm_check_x) && (length(sharp_x) < length(sharp_i))
            sharp_i = sharp_x;
            fitness = fitness_x;
            N = N_x;
            E = E_x;
            EL = EL_x;
            check_fitness = true;
            check_fdm = true;
        elseif ((fitness > fitness_x) && (L_fitness >= L_x)) || ((fitness >= fitness_x) && (L_fitness > L_x)) || imsaa_prob(abs(fitness_x-fitness), alpha)
            fitness = fitness_x;
            L_fitness = L_x;
            N = N_x;
            E = E_x;
            EL = EL_x;
            check_i = true;
            check_fitness = true;
        end
    end
    
    % Search in y-direction
    [fem_check_y, fdm_check_y, sharp_y, fitness_y, L_y, N_y, E_y, EL_y] = evaluate_update(FDM, N, E, EL, 2, alpha, scale, i);

    if fem_check_y
        if ((fdm_check_y && check_i) || fdm_check_y) && (length(sharp_y) < length(sharp_i))
            sharp_i = sharp_y;
            fitness = fitness_y;
            N = N_y;
            E = E_y;
            EL = EL_y;
            check_fitness = true;
            check_fdm = true;
        elseif ((fitness > fitness_y) && (L_fitness >= L_y)) || ((fitness >= fitness_y) && (L_fitness > L_y)) || imsaa_prob(abs(fitness-fitness_y), alpha)
            fitness = fitness_y;
            L_fitness = L_y;
            N = N_y;
            E = E_y;
            EL = EL_y;
            check_i = true;
            check_fitness = true;
        end
    end

    if N(i,3) < scale
        N(i,3) = scale;
    elseif N(i,3) > scale 
       % Search in z-direction
       
       [fem_check_z, fdm_check_z, sharp_z, fitness_z, L_z, N_z, E_z, EL_z] = evaluate_update(FDM, N, E, EL, 3, alpha, scale, i);

        if fem_check_z
            if ((fdm_check_z && check_i) || fdm_check_z) && (length(sharp_z) < length(sharp_i))
                fitness = fitness_z;
                N = N_z;
                E = E_z;
                EL = EL_z;
                check_fitness = true;
                check_fdm = true;
            elseif ((fitness > fitness_z) && (L_fitness >= L_z)) || ((fitness >= fitness_z) && (L_fitness > L_z)) || imsaa_prob(abs(fitness-fitness_z), alpha)
                fitness = fitness_z;
                L_fitness = L_z;
                N = N_z;
                E = E_z;
                EL = EL_z;
                check_fitness = true;
            end
        end
    end
end
