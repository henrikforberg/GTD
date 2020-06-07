function [gen_n, gen_e] = initialize_population(start_N, start_E, pop_size, edge_mut, node_mut, scale)

    % initialize vector with the population size
    vec_1 = zeros(1, pop_size);
    vec_2 = vec_1;

    % Find individes to be mutated
    positions = [pop_size - (pop_size*node_mut):pop_size];
    vec_1(positions) = 1;
    
    node_mutations = vec_1(randperm(pop_size)); 
    
    % Find individes to be edge-mutated
    positions = [pop_size - (pop_size*edge_mut):pop_size];
    vec_2(positions) = 1;
    
    edge_mutations = vec_2(randperm(pop_size)); 
    num_nodes = length(start_N);

    % Find top and ground
    top = start_N(num_nodes, 3);
    bottom = start_N(1, 3);
    
    % Initialize population
    gen_n = cell(pop_size,1); 
    gen_n{1} = start_N;
    
    gen_e = cell(pop_size,1);
    gen_e{1} = start_E;
    
    for i = 2: pop_size
        
        N = start_N;
        E = start_E;
        
        if node_mutations(i) == 1
            [N, E] = generate_connection(N, E, random_node(bottom, top, scale), 3);
        elseif edge_mutations(i) == 1
            EL = edge_list(E, num_nodes);
            E = switch_edge(E, EL, num_nodes);
        elseif num_nodes > 5
            for j = 1:num_nodes-1
                mov = [0 1 0];
                movement = mov(randperm(3));
                if j < 5
                    movement(3) = 0;
                end
                
                if (movement(3) == 1) && ((scale/4) + N(j, 3) > top-(scale/4))
                    N(j, 3) =  N(j, 3) - (scale/4);
                elseif movement(3) == 1 && N(j, 3) < (bottom + scale/4)
                    N(j, 3) =  scale;
                else
                    N(j, 1) =  N(j, 1) + movement(1)*randi([-2*scale 2*scale]);
                    N(j, 2) =  N(j, 2) + movement(2)*randi([-2*scale 2*scale]);
                    temp = movement(3)*randi([-2*scale 2*scale]);
                    
                    if (N(j, 3) + temp) < (top-scale) && ((N(j, 3) + temp) > bottom)
                        N(j, 3) =  N(j, 3) + temp;                       
                    end
                end
            end
        end
        
        gen_n{i} = N;
        gen_e{i} = E;
    end
end