function[selected_n, selected_e, selected_f] = nsga_selection(gen_n, gen_e, s_num, fr_1, fr_2, fr_3, fr_4, population)
    
    % Initialize matrices 
    selected_n = cell(s_num,1);
    selected_e = cell(s_num,1);
    selected_f = cell(s_num,1);
    
    % front 1
    sn_1 = fr_1(:,3);

    % front 2
    if isempty(fr_2) && not(isempty(fr_3))
        fr_2 = fr_3;
        sn_2 = fr_2(:,3);
    elseif isempty(fr_2) && isempty(fr_3)
        fr_2 = fr_4;
        sn_2 = fr_2(:,3);
        fr_3 = fr_4;
    else
        sn_2 = fr_2(:,3);
    end
       
    % front 3
    if isempty(fr_3) && not(isempty(fr_4))
        fr_3 = fr_4;
        sn_3 = fr_3(:,3);
    else
        sn_3 = fr_3(:,3);
    end
    
    if length(sn_1) >= s_num
        [sel_n, sel_e, sel_f] =  sort_this(gen_n, gen_e, crowding_operator(fr_1, s_num), population);
        selected_n = sel_n(1:s_num);
        selected_e = sel_e(1:s_num);
        selected_f = sel_f(1:s_num);
    elseif (length(sn_1)+length(sn_2)) >= s_num
        len = length(sn_1);
        
        %first part
        [sel_n, sel_e, sel_f] = sort_this(gen_n, gen_e, sn_1, population);
        selected_n(1:len) = sel_n(1:len);
        selected_e(1:len) = sel_e(1:len);
        selected_f(1:len) = sel_f(1:len);

        %second part
        temp = s_num-len;
        [sele_n, sele_e, sele_f] =  sort_this(gen_n, gen_e, crowding_operator(fr_2, temp), population);
        selected_n(len+1:s_num) = sele_n(1:temp);
        selected_e(len+1:s_num) = sele_e(1:temp);
        selected_f(len+1:s_num) = sele_f(1:temp);
    elseif (length(sn_1)+length(sn_2)+length(sn_3)) >= s_num        
        len_1 = length(sn_1);
        len_2 = length(sn_2);
        
        %first part
        [sel_n, sel_e, sel_f] = sort_this(gen_n, gen_e, sn_1, population);
        selected_n(1:len_1) = sel_n(1:len_1);
        selected_e(1:len_1) = sel_e(1:len_1);
        selected_f(1:len_1) = sel_f(1:len_1);
        
        % second part
        [sele_n, sele_e, sele_f] = sort_this(gen_n, gen_e, sn_2, population);
        selected_n(len_1+1:len_1+len_2) = sele_n(1:len_2);
        selected_e(len_1+1:len_1+len_2) = sele_e(1:len_2);
        selected_f(len_1+1:len_1+len_2) = sele_f(1:len_2);
        
        % third part
        temp = s_num-(len_1+len_2);
        [selec_n, selec_e, selec_f] = sort_this(gen_n, gen_e, crowding_operator(fr_3, temp), population);
        selected_n(len_1+len_2+1:s_num) = selec_n(1:temp);
        selected_e(len_1+len_2+1:s_num) = selec_e(1:temp);
        selected_f(len_1+len_2+1:s_num) = selec_f(1:temp);
    else            
        len_1 = length(sn_1);
        len_2 = length(sn_2);
        len_3 = length(sn_3);
        
        % first part
        [sel_n, sel_e, sel_f] = sort_this(gen_n, gen_e, sn_1, population);
        selected_n(1:len_1) = sel_n(1:len_1);
        selected_e(1:len_1) = sel_e(1:len_1);
        selected_f(1:len_1) = sel_f(1:len_1);
        
        % second part
        [sele_n, sele_e, sele_f] = sort_this(gen_n, gen_e, sn_2, population);
        selected_n(len_1+1:len_1+len_2) = sele_n(1:len_2);
        selected_e(len_1+1:len_1+len_2) = sele_e(1:len_2);
        selected_f(len_1+1:len_1+len_2) = sele_f(1:len_2);
        
        % third part
        [selec_n, selec_e, selec_f] = sort_this(gen_n, gen_e, sn_3, population);
        selected_n(len_1+len_2+1:len_1+len_2+len_3) = selec_n(1:len_3);
        selected_e(len_1+len_2+1:len_1+len_2+len_3) = selec_e(1:len_3);
        selected_f(len_1+len_2+1:len_1+len_2+len_3) = selec_f(1:len_3);
        
        % fourth part
        temp = s_num-(len_1+len_2+len_3);
        [select_n, select_e, select_f] =  sort_this(gen_n, gen_e, crowding_operator(fr_4, temp), population);
        selected_n(len_1+len_2+len_3+1:s_num) = select_n(1:temp);
        selected_e(len_1+len_2+len_3+1:s_num) = select_e(1:temp);
        selected_f(len_1+len_2+len_3+1:s_num) = select_f(1:temp);
    end
end