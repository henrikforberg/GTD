function Node = random_node(bottom, top, scale) 
    x = randi([-6*scale 6*scale]);
    y = randi([-6*scale 6*scale]);
    z = randi([bottom (top-scale)]);

    if z < 2*scale
        z = scale;
    end
    
    Node = [x, y, z];
end