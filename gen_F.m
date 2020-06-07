function F = gen_F(N, Fext)
    % legger F p� topp noder (top i Z)

    % finner max Z verdi p� kropp
    maxZ = max(N(:,3));
    F = zeros(length(N),3); 

    % legger p� krefter

    for i=1:length(N)
        if N(i,3) == maxZ % er i en topp node
            F(i,:) = Fext;
        else
            F(i,:) = [0 0 0]; 
        end   
    end
end
