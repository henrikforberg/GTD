function [F_N, F_E, directory] = nsga_2(FDM, N, E, scale, viz, pop, gen, sel, e_mut, n_mut, n_gen, crs, mx)    
    
    % * NSGA-II * 
    % Returns Pareto front of truss structures:
    % F_N: Node-matrices
    % E_N: Edge-matrices
    % directory: directory to folder
    
    % Create directory
    directory = sprintf('POP_%i_GEN_%i_SEL_%i', pop, gen, sel);
    mkdir(directory);
    
    % Initialize population
    [gen_n, gen_e] = initialize_population(N, E, pop, e_mut, n_mut, scale);
    selected_f = cell(pop,1);
    
    % Initialize statistics diagram
    diagram = zeros(gen, 7);
    
    % Evolution starts here:
    fprintf("-> Starting NSGA-II. ");
    
    for i=1:gen
        
        % Initialize population matrices
        population = zeros(pop,4);
        best_n = cell(pop,1);
        best_e = cell(pop,1);
        
        % Initialize infromation array 
        add_info = zeros(pop, 3);
        tic; % Start generation timer
            
        % Next generation
        parfor j=1:pop

            % Parents 
            if j<=sel && i > 1
                cand = j;
                f_d_b = selected_f{cand};
                population(j,:) = [f_d_b(1), f_d_b(2), f_d_b(3), j];
                add_info(j,:)   = [f_d_b(1), f_d_b(2), f_d_b(3)];
                
                best_n{j} = gen_n{j};
                best_e{j} = gen_e{j};
                continue;
            end
            
            % Offspring 
            %fprintf("\nSJEKK1");
            EL = edge_list(gen_e{j}, length(gen_n{j}));
            
            % Find beam intersections in candidate
            if length(gen_e{j}) > 8
                check_int = 1;
                counter = 1;
                while check_int
                    [N_Final, E_Final, check_int, ~] = find_intersection(gen_n{j}, gen_e{j}, EL);
                    gen_n{j} = N_Final;
                    gen_e{j} = E_Final;  
                    %fprintf("\nSJEKK2");
                    EL = edge_list(gen_e{j}, length(gen_n{j}));
                    counter = counter+1;
                   
                    % Break longer search
                    if counter > 5
                        break;
                    end
                end
            end
            
            % Check for printable angles
            c = 1;
            c_beams = 1;
            len = length(gen_n{j});
          
            for x=1:len  
                if FDM % Optimize for FDM
                    [check,  ~] = fdm_angles(EL, gen_n{j}, scale, x);
                else % Do not optimize for DM on FDM
                    check = 1;
                end
                
                % Check whether truss satisfies FEM constraints
                [check_beams, ~] = fem_angles(EL, gen_n{j}, x);
                
                if not(check) % FDM constraint was not satisfied 
                    c = 0;
                    break;
                elseif ~check_beams % FEM constraint was not satisfied 
                    c_beams = 0;
                    break;
                end
            end

            % Penalize structures if constraints are not satisfied
            % Evaluate structure otherwise
            if (~c) || (~c_beams)
                displacement = 10000;
                L = 30000;
                weight = 30000;
            else
                % Evaluate structure
                [U, L, weight] = fem(gen_n{j}, gen_e{j});
                displacement = optimization_metric(U);
            
                % Structure still contains simulation errors
                if isnan(displacement) || displacement < 0 
                    displacement = 10000;
                    L = 10000;
                end
            end

            penalty = 0;
            
            % Max weight 33000, or approx 40 g
            if weight > 33000 || displacement > 1100
                penalty = 10000;
            end
            
            % Store population matrix
            population(j,:) = [displacement+penalty, L+penalty, weight, j];
            
            % Store candidate matrices
            best_n{j} = gen_n{j};
            best_e{j} = gen_e{j};
            
            % Store info about candidate
            add_info(j,:) = [displacement, L, weight];
        end
        
        % Sort the last population
        [fr_1, fr_2, fr_3, fr_4] = fast_sort(population);
        [selected_n, selected_e, selected_f] = nsga_selection(best_n, best_e, sel, fr_1, fr_2, fr_3, fr_4, population);
        [gen_n, gen_e] = new_population(selected_n, selected_e, pop, e_mut, n_mut, n_gen, crs, scale);
        
        % Save pareto front
        final_front = [fr_1(:,1), fr_1(:,2)];
        pos = find(fr_1(:,1) == (min(fr_1(:,1))));
        pos_2 = find(fr_1(:,2) == (min(fr_1(:,2))));
       
        if viz %plot
            % Visualize pareto front
            figure(1);
            scatter(final_front(:,1), final_front(:,2))
        
            % Visualize F_d optimum
            viz_struct(best_n{fr_1(pos(1),3)}./10, best_e{fr_1(pos(1),3)}, 2, 2);
        
            % Visualize F_b optimum
            viz_struct(best_n{fr_1(pos_2(1),3)}./10, best_e{fr_1(pos_2(1),3)}, 2, 3);
            
            [a, ~, ~] = fem(best_n{fr_1(pos(1),3)}, best_e{fr_1(pos(1),3)});
            plot_displacements(best_n{fr_1(pos(1),3)}, best_e{fr_1(pos(1),3)}, a, scale)
        end

        % Save diagram matrix
        top_obj_1 = [fr_1(pos(1), 1), fr_1(pos(1), 2)];
        top_obj_2 = [fr_1(pos_2(1), 1), fr_1(pos_2(1), 2)];
        front_length = length(fr_1(:,3));
        info = zeros(3,1);

        for x = 1:front_length
            info(1) = info(1) + (add_info(fr_1(x,3),1)/front_length);
            info(2) = info(2) + (add_info(fr_1(x,3),2)/front_length);
            info(3) = info(3) + (add_info(fr_1(x,3),3)/front_length);
        end

        elapsed_time = toc;
        diagram(i,:) = [i, elapsed_time, round(top_obj_1(1)), round(top_obj_2(2)), info(1), info(2), info(3)];
        
        clc;
        fprintf("-> NSGA-II:\n> Generation: %i/%i, time: %i Seconds \n> Min: F_d = %i\t(F_b = %i)\n> Min: F_b = %i\t(F_d = %i)", i, gen, round(elapsed_time), round(top_obj_1(1)),  round(top_obj_1(2)), round(top_obj_2(2)),  round(top_obj_2(1)));
    end

    % Save Pareto Front
    len_fr = size(fr_1);
    
    if len_fr(1) > mx % Save mx amount of candidates   
        len_fr = mx;

        [F_N, F_E, F_F] = sort_this(best_n, best_e, crowding_operator(fr_1, mx), population);
        F_N = F_N(:,1);
        F_E = F_E(:,1);
        F_F = F_F(:,1);

        for i=1:mx   
            struct_dir = sprintf('%s/%i', directory, i);
            mkdir(struct_dir);
            f_d_b = F_F{i};
            save_stl(F_N{i}./10, F_E{i,1}, f_d_b(1), f_d_b(2), struct_dir);
            dir_N = sprintf('%s/N.xls', struct_dir);
            dir_E = sprintf('%s/E.xls', struct_dir);
            writematrix(F_N{i}, dir_N);
            writematrix(F_E{i}, dir_E);
            
            [a, b, w] = fem(F_N{i},F_E{i,1});
            disp = optimization_metric(a);
            if not(round(f_d_b(1)) == round(disp))
                i
                fprintf("WUps");
                f_d_b(1)
                disp
            end
        end
    else
        for i=1:len_fr % Save the entire pareto front  
            struct_dir = sprintf('%s/%i', directory, i);
            mkdir(struct_dir);
            save_stl(best_n{fr_1(i,3)}./10, best_e{fr_1(i,3)}, fr_1(i,1), fr_1(i,2), struct_dir);
            dir_N = sprintf('%s/N.xls', struct_dir);
            dir_E = sprintf('%s/E.xls', struct_dir);
            writematrix(best_n{fr_1(i,3)}, dir_N);
            writematrix(best_e{fr_1(i,3)}, dir_E);
        end
        F_N = best_n(fr_1(:,3));
        F_E = best_e(fr_1(:,3));
    end
    
    % Save statistics and metadata for the evolution trial
    f = fullfile(directory, 'p_front.dat');
    fid = fopen(f, 'w');
    fprintf(fid, '%f %f\n', final_front.');
    fclose(fid);
    
    d = fullfile(directory, 'nsga_diagram.dat');
    fid_2 = fopen(d, 'w');
    fprintf(fid_2, '%i %.2f %.2f %.2f %.2f %.2f %.2f\n', diagram.'); 
    fclose(fid_2);

    m = fullfile(directory, 'nsga_meta.dat');
    fid_3 = fopen(m, 'w');
    fprintf(fid_3, '%i %i %.2f %i %.2f %.2f %.2f %.2f', [pop, gen, sum(diagram(:,2)), sel, e_mut, n_mut, n_gen, crs].'); 
    fclose(fid_3); 
    
    %clc;
    fprintf("-> NSGA-II:\n> Saved %i candidates.\n", len_fr);
end
