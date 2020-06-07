function check = intersect_2D(vec_1, vec_2)

    % Returns 1 if the lines intersect 
    % in minimum one out of three planes
    % Returns 0 otherwise
    check = 0;

    xy_1 = [vec_1(1:2,1), vec_1(1:2,2)];
    xy_2 = [vec_2(1:2,1), vec_2(1:2,2)];
    
    xz_1 = [vec_1(1,1), vec_1(3,1); vec_1(1,2), vec_1(3,2)];
    xz_2 = [vec_2(1,1), vec_2(3,1); vec_2(1,2), vec_2(3,2)];
    
    yz_1 = [vec_1(2:3,1), vec_1(2:3,2)];
    yz_2 = [vec_2(2:3,1), vec_2(2:3,2)];
    
    a = {xy_1; xz_1; yz_1};
    b = {xy_2; xz_2; yz_2};
    
    for x = 1:3
        a_temp = a{x};
        b_temp = b{x};
        if isequal(a_temp, b_temp)
            continue
        elseif isequal(a_temp(:, 1), a_temp(:, 2)) || isequal(b_temp(:,1), b_temp(:,2))
            continue
        elseif find_intersection_2D(a_temp, b_temp)
            check = 1;
            return 
        end
    end
end