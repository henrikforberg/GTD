function E = switch_edge(E, EL, num_nodes)
    
    % Switch edge connection
    % Strategy: "Ta fra de rike og gi til de fattige" 
    
    over  = []; % Nodes that can deposit one or more edges
    under = []; % Nodes that can not deposit any edges 
    full  = []; % Nodes that are connected to all other nodes
    
    for i = 1:num_nodes
        
        % Find node connections
        neighbor_nodes = unpad(EL(:, i));
        if length(neighbor_nodes) > 3
            if length(neighbor_nodes) < (num_nodes-2)
                over = [over, i]; % can deposit one edge
            else  
                full = [full, i]; % is on full capacity
            end
        else
            under = [under, i]; % has no edges to deposit
        end
    end
    
    % Determine node to lose an edge: loser
    if (isempty(under) || length(under)==1) && isempty(over) 
        return % Full capacity
    elseif not(isempty(full)) 
        loser = full(randi(length(full)));  
    else
        loser = over(randi(length(over))); 
        over(over == loser) = [];
    end
    
    % Find loser-node's connected nodes
    candidate_winners_ = unpad(EL(:, loser));
    % Filter away nodes with full capacity
    candidate_winners = setdiff(candidate_winners_, full);
    
    % Find possible connections
    idx=find(ismember(candidate_winners, [under, over]));
  
    % Determine connection: winner
    winner = candidate_winners(idx(randi(length(idx))));     
    
    x = (1:num_nodes);
    y = [unpad(EL(:,winner)); winner];
    z = setdiff(x,y); % Possible edges
    
    if length(z) > 1
        new_connection = z(randi(length(z)));
    else
        new_connection = z(1);
    end


    E = E.';
    [r, p] = ismember([winner loser], E, 'rows');
    [s, t] = ismember([loser winner], E, 'rows');

    if r
        E(p, :) = [winner new_connection];
    elseif s
        E(t, :) = [new_connection winner];
    end 
    E = E.';
end
