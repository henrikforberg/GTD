function [N, E] = msaa(FDM, N, E, temperature, step, scale, directory)

    % * MSAA * 
    % Returns shape-optimized truss structures:
    % N: Node-matrices
    % E: Edge-matrices

    fprintf("-> Starting MSAA. \n");
    len = length(N(:,1));
    
    % Initialize statistics diagram
    diagram = zeros(len, 3);
    
    for a = 1:len  % Parallel optimize all candidates %par
        
        N_i = N{a,1};
        E_i = E{a,1};
        
        % First evaluation
        [U, L, ~] = fem(N_i, E_i);
        
        % Parameters
        fitness = optimization_metric(U);
        compare_fitness = fitness;
        L_fitness = L;
        check = true;
        alpha = temperature;
        
        % Temporary parameters
        temp_fitness = fitness;
        temp_L = L;

        % Star timing
        tic;
        
        while true
            
            % Optimize this candidate
        
            if check == false || (round(compare_fitness) == round(fitness))
                alpha = alpha-step; 
                if alpha < 1
                    break;
                end
            end
           
            compare_fitness = fitness;
            
            % Update shape 
            EL = edge_list(E_i, length(N_i));
            for i=1:length(N_i)-1
                [check_i, sharp_i] = fdm_angles(EL, N_i, scale, i);
                [check_fdm, check_fitness, N_i, E_i, EL, fitness, L_fitness] = msaa_optimize(FDM, N_i, E_i, EL, check_i, sharp_i, fitness, L_fitness, scale, alpha, i);
               
                if (fitness < temp_fitness && L_fitness <= temp_L) || (fitness <= temp_fitness && L_fitness < temp_L)
                    N{a,1} = N_i;
                    E{a,1} = E_i;
                    temp_fitness = fitness;
                    temp_L = L_fitness;
                end

                if ~(check_i || check_fdm)
                    check = true;
                    break;
                elseif check_fitness
                    check = true;
                end
            end
        end
        
        % Save candidate statistics
        diagram(a,:) = [temp_fitness, temp_L, toc];
        fprintf('> Candidate truss: %i f_d = %d\n', a, round(temp_fitness));
    end
    
    fprintf('> MSAA completed with %i candidates after %i seconds.\n', length(N(:,1)), round(sum(diagram(:,3))));
    
    % Save structures
    for x=1:len
        struct_dir = sprintf('%s/%i/%s', directory, x, 'MSAA');
        mkdir(struct_dir)
        save_stl(N{x,1}./10, E{x,1}, round(diagram(x,1)), round(diagram(x,2)), struct_dir);
    end
    
    % Save statistics diagram
    d = fullfile(directory, 'msaa_diagram.dat');
    fid_4 = fopen(d, 'w');
    fprintf(fid_4, '%.2f %.2f %i\n', diagram.'); 
    fclose(fid_4);
end
