function F = gen_F(N, Fext)
    % legger F på topp noder (top i Z)

    % finner max Z verdi på kropp
    maxZ = max(N(:,3));
    F = zeros(length(N),3); 

    % legger på krefter

    for i=1:length(N)
        if N(i,3) == maxZ % er i en topp node
            F(i,:) = Fext;
        else
            F(i,:) = [0 0 0]; 
        end   
    end
end
