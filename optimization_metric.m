function fitness = optimization_metric(U) 
    position = length(U);
    fitness = U(position); 
    
    if abs(U(position-1)) > 300 && not(U(position) < 0)
        fitness = abs(fitness) + abs(U(position-1));
    end
    
    if abs(U(position-2)) > 300 && not(U(position) < 0)
        fitness = abs(fitness) + abs(U(position-2));
    end   
   
    c = U(1:position-3);
    c = abs(c);
    penalty = sum(c(:)>=300);
    
    if penalty > 0
        fitness = abs(fitness) + penalty*301;
    end      
end