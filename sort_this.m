function[selected_n, selected_e, selected_f] = sort_this(gen_n, gen_e, sn, population)
    len = length(sn);   
    selected_n = cell(len);
    selected_e = cell(len);
    selected_f = cell(len);

    for i=1:len
        selected_n{i} = gen_n{sn(i)};
        selected_e{i} = gen_e{sn(i)};
        selected_f{i} = [population(sn(i), 1), population(sn(i), 2), population(sn(i), 3)];
    end
end