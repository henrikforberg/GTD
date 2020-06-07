function v = ccw(p1, p2, p3)
    v = 0;
    dx1 = p2(1)-p1(1);
    dy1 = p2(2)-p1(2);
    dx2 = p3(1)-p1(1);
    dy2 = p3(2)-p1(2);
    
    if dx1*dy2 > dy1*dx2
        v = 1;
    elseif dx1*dy2 < dy1*dx2
        v = -1;
    elseif dx1*dx2 < 0 || (dy1*dy2) < 0
        v = -1;
    elseif (dx1*dx1 + dy1*dy1) < (dx2*dx2 + dy2*dy2)
        v = 1;
    end     
end
