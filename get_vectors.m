function[vectors] = get_vectors(N, list)

   a = size(list);   
   vectors = cell(length(list),1);

   for x=1:a(1)
       if list(x, 2) == 0
            break;
       else
            vectors{x} = [N(list(x,1), 1)  N(list(x,2), 1); N(list(x,1), 2)  N(list(x,2), 2); N(list(x, 1), 3)  N(list(x,2), 3)];
       end
   end
end