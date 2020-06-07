function B = gen_B(N)
    % låser alle bunn noder 

    % finner max Z verdi på kropp
    minZ = min(N(:,3));
    F = zeros(length(N),3); 

    for i=1:length(N)
        if N(i,3) == minZ % er i en topp node
            B(i,:) = [0 0 0]; % låser
        else
            B(i,:) = [1 1 1]; % fri
        end
    end
end