function E = generate_edge(symmetry, E, N, num)

    possible = [];
    connect = cell(num);
    
    E_1 = E(1,:);
    E_2 = E(2,:);
    
    for x=1:num
        
        a = ismember(E_1, x);
        b = ismember(E_2, x);
        
        if (sum(a)+sum(b)) < num-1
            possible = [possible, x];
            temp_1 = E_2(a == 1);
            temp_2 = E_1(b == 1);
            connect(x) = {[temp_1 temp_2]};
        end
    end
    
    y = possible(randi(length(possible)));
    z = connect{y,1};
    candidates = setdiff(1:num, [y z]);
    new_connection = candidates(randi(length(candidates)));
    E = [E, [y; new_connection]];
    
    if symmetry
        [~, index]= ismember(N, [-N(y,1) -N(y,2) N(y,3)], 'rows');
        y_mirror = find(index == 1);
        
        [~, index]= ismember(N, [-N(new_connection,1) -N(new_connection,2) N(new_connection,3)], 'rows');
        new_connection_mirror = find(index == 1);
        E = [E, [y_mirror; new_connection_mirror]];
    end
end