function [N, E] = remove_connection(N, E)
    top = length(N(:,3));
    connection = randi([4 top-1], 1);
    
    N(connection,:) = [];
    row = [];
    
    for x = 1:length(E)
        if (E(1,x) == connection) || (E(2,x) == connection)
            row = [row, E(:,x)];
        elseif (E(1,x) > connection)  || (E(2,x) > connection)
            if (E(1,x) > connection)
                E(1,x) = E(1,x)-1;
            end
            if (E(2,x) > connection)
                E(2,x) = E(2,x)-1;
            end 
        end
    end
    E = setdiff(E.',row.', 'rows').'
end
