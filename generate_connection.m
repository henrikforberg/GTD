function [N, E] = generate_connection(N, E, new_Node, num)

    num_nodes = length(N);
    E=E';
    scale = 100;
    
    % Top node rises
    E(E==num_nodes) = num_nodes+1;
    new_connections = [];

    if new_Node(3) == scale
        Y = datasample(1:num_nodes, num, 'Replace', false);
        for i=1:num
            if Y(i) == num_nodes
                connection = [Y(i)+1, num_nodes];
            else
                connection = [Y(i), num_nodes];
            end
            new_connections = [new_connections; connection];
        end
    else
        z = N(:,3);
        [over, ~] = find(z>new_Node(3));
        [under, ~] = find(z<new_Node(3));
        
        ant_under = randi(num-1);
        ant_over = 1 + num-ant_under;
        len_over = length(over);
        
        if ant_over > len_over
            ant_under = ant_under + (ant_over - len_over);
            ant_over = len_over;
        end
        
        Y_under = datasample(under, ant_under, 'Replace', false);
        
        for i = 1:ant_under
            if Y_under(i) == num_nodes
                connection = [Y_under(i)+1, num_nodes];
            else
                connection = [Y_under(i), num_nodes];
            end
            new_connections = [new_connections; connection];
        end
        
        Y_over = datasample(over, ant_over, 'Replace', false);
        for i = 1:ant_over
            if Y_over(i) == num_nodes
                connection = [Y_over(i)+1, num_nodes];
            else
                connection = [Y_over(i), num_nodes];
            end
            new_connections = [new_connections; connection];
        end
    end
    
    E = [E; new_connections]';
    N = [N(1:num_nodes-1, :); new_Node; N(num_nodes, :)];
end
