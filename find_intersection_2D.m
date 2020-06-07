function check = find_intersection_2D(a, b) 
    check = 0;
    v1 = ccw(a(:,1), a(:,2), b(:,1))*ccw(a(:,1), a(:,2), b(:,2));
    v2 = ccw(b(:,1), b(:,2), a(:,1))*ccw(b(:,1), b(:,2), a(:,2));
    
    if (v1 <= 0) && (v2 <= 0)
        check = 1;
    end
end