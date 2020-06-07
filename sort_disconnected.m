function [list] = sort_disconnected(EL, i, j)

    list = [0 0];
    
    for x = 1:length(EL)
       if (i == x) || (j == x) 
           continue;
       end
       
       temp = EL(:,x);
       
       for y = 1:length(temp)
           if temp(y) == 0
               break;
           end
           
           if (temp(y) == i) || (temp(y) == j)
               continue;
           elseif ~(ismember([temp(y) x], list, 'rows'))
               list = [list; [x temp(y)]];
           end
       end
    end
    list(1,:) = [];
end