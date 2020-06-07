function vec = unpad(w)
    %   Takes a row vector, removes all zeros at the beginning of the vector,
    %   and returns the remaining elements of the vector
    index = find(~w);
    vec = w(1:index-1);
end
