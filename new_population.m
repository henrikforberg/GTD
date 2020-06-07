function [gen_n, gen_e] = new_population(parents_N, parents_E, pop_size, edge_mut, node_mut, node_gen, cross, scale)

    % Number of parents 
    num_parents = length(parents_N);
    
    % Number of individes to be node mutated
    node_mut_num = (pop_size-num_parents)*node_gen;
    node_mutated = randi([1,num_parents], node_mut_num, 1);
    
    % Number of individes to be edge mutated
    edge_mut_num = (pop_size-num_parents)*edge_mut;
    edge_mutated = randi([1,num_parents], edge_mut_num, 1);
    
    % Number of individes to be bred
    crossover_num = (pop_size-num_parents)*cross;
    breed = randi([1,num_parents], crossover_num, 1);
    
    % Number of remaining individes
    remaining_num = pop_size-(num_parents+node_mut_num+edge_mut_num+crossover_num);
    remainders = randi([1,num_parents], remaining_num, 1);
    
    % Initialize new population
    gen_n = cell([pop_size,1]); 
    gen_e = cell([pop_size,1]);
    
    for i=1:num_parents
        gen_n{i} = parents_N{i};
        gen_e{i} = parents_E{i};
    end

    % Huncho
    h = parents_N{1};
    top = h(length(h), 3);
    bottom = h(1, 3);
    
    % Save node-mutation results
    for a=1:node_mut_num
        n_length = length(parents_N{node_mutated(a)}(:,3));
        e_length = length(parents_E{node_mutated(a)}(1,:));
        
        if (n_length > 5) && (e_length==((n_length*(n_length+1)/2))) && (randi(1000) > (edge_mut*1000)) 
            [temp_N, temp_E] = remove_connection(parents_N{node_mutated(a)}, parents_E{node_mutated(a)});
        else
            r = random_node(bottom, top, scale);
            [temp_N, temp_E] = generate_connection(parents_N{node_mutated(a)}, parents_E{node_mutated(a)}, r, 3);
        end
        
        gen_n{num_parents+a} = temp_N;
        gen_e{num_parents+a} = temp_E;
    end
    
    % Save edge-mutation results
    for b=1:edge_mut_num
        temp_N = parents_N{edge_mutated(b)};
        temp_E = parents_E{edge_mutated(b)};
        
        temp_num = length(temp_N);
        EL = edge_list(temp_E, temp_num);
        
        if (sum(sum(EL>0)) < ((temp_num*(temp_num+1)/2))) && (randi(1000) > (edge_mut*1000)) 
            temp_E = generate_edge(0, temp_E, temp_N, temp_num);
        else
            temp_E = switch_edge(temp_E, EL, temp_num);
        end
        
        gen_n{num_parents+node_mut_num+b} = temp_N;
        gen_e{num_parents+node_mut_num+b} = temp_E;
    end
    
    % Save crossover results
    for c=1:crossover_num
        far = parents_N{breed(c)};
        
        mor = randi([1 num_parents]);
        if mor == breed(c), mor = 1; end
        
        [temp_N, temp_E] = crossover(far, parents_N{mor}, parents_E{breed(c)}, parents_E{mor}); % temp_N er far
        gen_n{num_parents+node_mut_num+edge_mut_num+c} = temp_N;
        gen_e{num_parents+node_mut_num+edge_mut_num+c} = temp_E;

    end
    
    % Save morphed results
    for d=1:remaining_num
        gen_n{num_parents+node_mut_num+edge_mut_num+crossover_num+d} = morph(parents_N{remainders(d)}, scale, top, bottom);
        gen_e{num_parents+node_mut_num+edge_mut_num+crossover_num+d} = parents_E{remainders(d)};
    end
end