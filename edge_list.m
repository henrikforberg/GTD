function[EdgeList] = edge_list(E, num)

    % Return the edgelist for matrix E
    
    EdgeList = [];
    TOP = E(1,:);
    BOTTOM = E(2,:);
    
    for i = 1:num     
       count = 1;
       T = find(TOP == i);
       B = find(BOTTOM == i);
       
       temp = zeros(num, 1);
       
       for j = 1:length(T)
           temp(count) = E(2,T(j));
           count = count+1;
       end
       
       for k = 1:length(B)
           temp(count) = E(1, B(k));
           count = count+1;
       end
       %jfk = EdgeList
       %mistersir = temp
       EdgeList = [EdgeList temp];
    end
end