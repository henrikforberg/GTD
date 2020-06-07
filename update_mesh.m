function [New_Q] = update_mesh(Q_all, N)
    New_Q = [];
    for i=1:length(N)
        New_Q = [New_Q; [Q_all((i*6)-2) Q_all((i*6)-1) Q_all((i*6))]];
    end
    New_Q = N-New_Q;
end