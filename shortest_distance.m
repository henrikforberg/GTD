function [distance, check, outV, point_1, point_2]= shortest_distance(A, B)

    p1 = A(:, 1).';
    p2 = A(:, 2).';
    p3 = B(:, 1).';
    p4 = B(:, 2).';

    u = p1 - p2;
    v = p3 - p4;
    w = p2 - p4;
    
    a = dot(u,u);
    b = dot(u,v);
    c = dot(v,v);
    d = dot(u,w);
    e = dot(v,w);
    
    D = a*c - b*b;
    sD = D;
    tD = D;
    
    SMALL_NUM = 0.0000001;
    check = 0;
    
    % compute the line parameters of the two closest points
    if (D < SMALL_NUM)  % the lines are almost parallel
        sN = 0.0;       % force using point P0 on segment S1
        sD = 1.0;       % to prevent possible division by 0.0 later
        tN = e;
        tD = c;
        check = 1;
    else                % get the closest points on the infinite lines
        sN = (b*e - c*d);
        tN = (a*e - b*d);
        if (sN < 0.0)   % sc < 0 => the s=0 edge is visible       
            sN = 0.0;
            tN = e;
            tD = c;
        elseif (sN > sD)% sc > 1 => the s=1 edge is visible
            sN = sD;
            tN = e + b;
            tD = c;
        end
    end
    
    if (tN < 0.0)            % tc < 0 => the t=0 edge is visible
        tN = 0.0;
        % recompute sc for this edge
        if (-d < 0.0)
            sN = 0.0;
        elseif (-d > a)
            sN = sD;
        else
            sN = -d;
            sD = a;
        end
    elseif (tN > tD)       % tc > 1 => the t=1 edge is visible
        tN = tD;
        % recompute sc for this edge
        if ((-d + b) < 0.0)
            sN = 0;
        elseif ((-d + b) > a)
            sN = sD;
        else 
            sN = (-d + b);
            sD = a;
        end
    end
    
    % finally do the division to get sc and tc
    if(abs(sN) < SMALL_NUM)
        sc = 0.0;
    else
        sc = sN / sD;
    end
    
    if(abs(tN) < SMALL_NUM)
        tc = 0.0;
    else
        tc = tN / tD;
    end
    
    % get the difference of the two closest points
    dP = w + (sc.* u) - (tc.*v); 
    distance = norm(dP);
    outV = dP;

    point_1 = p2+sc.*u;
    point_2 = p4+tc.*v;
end