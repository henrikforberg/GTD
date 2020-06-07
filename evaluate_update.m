function [check_fem, check_fdm, sharp, fitness, L, N, E, EL] = evaluate_update(FDM, N, E, EL, xyz, alpha, scale, i)
    
    % Initialize uppdate
    N_1 = N;
    N_2 = N;
    E_1 = E;
    E_2 = E;
    
    % Create candidates
    N_1(i, xyz) = N(i, xyz) + alpha;
    N_2(i, xyz) = N(i, xyz) - alpha;
    
    
    check_1 = 1;
    check_2 = 1;
    weight_1 = 0;
    weight_2 = 0;
    c = 1;
    
    % Update candidates
    while check_1
        [N_1, E_1, check_1, ~] = find_intersection(N_1, E_1, EL);
        c = c + 1;
        if c>7
            break;
        end
    end
    
    c = 1;
    
    while check_2
        [N_2, E_2, check_2, ~] = find_intersection(N_2, E_2, EL);
        c = c + 1;
        if c>5
            break;
        end
    end
    
    EL_1 = edge_list(E_1, length(N_1));
    EL_2 = edge_list(E_2, length(N_2));
    
    % Intialize return values
    fitness = intmax;
    L = intmax;
    check_fem = 1;
    check_fdm = 1;
    sharp = [];
    
    % Initialize temporary values
    fitness_1 = intmax;
    fitness_2 = intmax;
    L_1 = intmax;
    L_2 = intmax;
    check_1 = true;
    check_2 = true;
    
    if FDM
        % Check for overhang-free structures
        [check_1, sharp_1] = fdm_angles(EL_1, N_1, scale, i); 
        [check_2, sharp_2] = fdm_angles(EL_2, N_2, scale, i);
        
        % Both solution were overhang-bound
        if ~(check_1 || check_2) %nor
            check_beams_1 = 1;
            for i = 1:length(N_1)
                [c_b_1, ~] = fem_angles(EL_1, N_1, i);
                if ~c_b_1
                    check_beams_1 = 0;
                    break;
                end
            end
            
            check_beams_2 = 1;
            
            for i = 1:length(N_2)
                [c_b_2, ~] = fem_angles(EL_2, N_2, i);
                if ~c_b_2
                    check_beams_2 = 0;
                    break;
                end
            end
            
            % Determine whether solutions are legal
            if ~(check_beams_1 || check_beams_2) %nor
                check_fem = 0;
                return
            elseif ~check_beams_2
                N = N_1;
                E = E_1;
                EL = EL_1;
                sharp = sharp_1;
            elseif ~check_beams_1
                N = N_2;
                E = E_2;
                EL = EL_2;
                sharp = sharp_2;
            else
                if length(sharp_1) <= length(sharp_2)
                    N = N_1;
                    E = E_1;
                    EL = EL_1;
                    sharp = sharp_1;
                else
                    N = N_2;
                    E = E_2;
                    EL = EL_2;
                    sharp = sharp_2;
                end
            end
            check_fdm = false;
            return
        end
    end
    
    % Determine whether both soultions are worth exploring
    if (~check_1) && check_2
        
        check_beams_2 = 1;
            
        for i = 1:length(N_2)
            [c_b_2, ~] = fem_angles(EL_2, N_2, i);
            if ~c_b_2
                check_beams_2 = 0;
                break;
            end
        end
        
        % Determine if solution is legal
        if ~check_beams_2 
            check_fem = 0;
            return
        else
            [U, L_2, weight_2] = fem(N_2, E_2);
            fitness_2 = optimization_metric(U);
        end
    elseif (~check_2) && check_1
        check_beams_1 = 1;
        
        for i = 1:length(N_1)
            [c_b_1, ~] = fem_angles(EL_1, N_1, i);
            if ~c_b_1
                check_beams_1 = 0;
                break;
            end
        end
        
        % Determine if solution is legal
        if ~check_beams_1
            check_fem = 0;
            return
        else
            [U, L_1, weight_1] = fem(N_1, E_1);
            fitness_1 = optimization_metric(U);
        end
    else
        check_beams_1 = 1;
        for i = 1:length(N_1)
            [c_b_1, ~] = fem_angles(EL_1, N_1, i);
            if ~c_b_1
                check_beams_1 = 0;
                break;
            end
        end
            
        check_beams_2 = 1;
            
        for i = 1:length(N_2)
            [c_b_2, ~] = fem_angles(EL_2, N_2, i);
            if ~c_b_2
                check_beams_2 = 0;
                break;
            end
        end
        
        % Determine whether solutions are legal
        if ~(check_beams_1 || check_beams_2)
            check_fem = 0;
            return
        elseif ~check_beams_1
            [U, L_2, weight_2] = fem(N_2, E_2);
            fitness_2 = optimization_metric(U);
        elseif ~check_beams_2
            [U, L_1, weight_1] = fem(N_1, E_1);
            fitness_1 = optimization_metric(U);
        else
            [U, L_1, weight_1] = fem(N_1, E_1);
            fitness_1 = optimization_metric(U);
            [U, L_2, weight_2] = fem(N_2, E_2);
            fitness_2 = optimization_metric(U); 
        end
    end
    
    if weight_1 > 33000
        fitness_1 = fitness_1+10000;
    end
    
    if weight_2 > 33000
        fitness_2 = fitness_2+10000;
    end
    
    % Return feasible/optimal candidate
        
    if fitness_1 < fitness_2 && L_1 <= L_2
        fitness = fitness_1;
        L = L_1;
        N = N_1;
        E = E_1;
        EL = EL_1;
    else
        fitness = fitness_2;
        L = L_2;
        N = N_2;
        E = E_2;
        EL = EL_2;
    end    
end