function [Nstl,Fstl] = edge_to_tube(h,radi)

    Nstl = zeros(20002,3);
    Fstl = zeros(40000,3); % 3 nodes in 1 face

    antNperRev = 200;
    dA = 2*pi/antNperRev;
    antKulerunder = antNperRev/4 - 1;

    i = 1;
    j = 1;

    % node ring 1
    a = 0;
    for n = 1 : antNperRev
        a = a + dA;
        Nstl(i,1) = radi*sin(a);
        Nstl(i,2) = radi*cos(a);
        Nstl(i,3) = 0;
        i = i + 1;
    end

    % node ring 2
    a = 0;
    for n = 1 : antNperRev
        a = a + dA;
        Nstl(i,1) = radi*sin(a);
        Nstl(i,2) = radi*cos(a);
        Nstl(i,3) = h;
        i = i + 1;
    end

    % Face ring in 2 parts
    for n = 1 : antNperRev
        % tri 2 nodes down
        Fstl(j,2) = n;
        Fstl(j,1) = mod(n,antNperRev) + 1; % +1 avoids 0
        Fstl(j,3) = n + antNperRev; 
        j = j + 1;
    
        % tri 2 nodes up
        Fstl(j,2) = Fstl(j-1,1);
        Fstl(j,1) = Fstl(j-1,1) + antNperRev; 
        Fstl(j,3) = Fstl(j-1,2) + antNperRev; 
        j = j + 1;    
    end

    aV = 0;
    for c = 1:antKulerunder
        r = cos(aV+dA);
        z = h + radi*sin(aV+dA);
        aV = aV + dA;   
    
        % node ring
        a = 0;
        for n = 1 : antNperRev
            a = a + dA;
            Nstl(i,1) = r*radi*sin(a);
            Nstl(i,2) = r*radi*cos(a);
            Nstl(i,3) = z;
            i = i + 1;
        end
    
        % Face ring in 2 parts 
        for n = 1 : antNperRev
            % tri 2 nodes down
            Fstl(j,2) = n + i-1-antNperRev*2;
            Fstl(j,1) = mod(n,antNperRev) + 1 + i-1-antNperRev*2;
            Fstl(j,3) = n + i-1 - antNperRev;
            j = j + 1;        
        
            % tri 2 nodes up
            Fstl(j,2) = Fstl(j-1,1);
            Fstl(j,1) = Fstl(j-1,1) + antNperRev; % rett over og litt forran
            Fstl(j,3) = Fstl(j-1,2) + antNperRev; % rett over
            j = j + 1;
        end   
    end

    % topp node
    Nstl(i,1) = 0;
    Nstl(i,2) = 0;
    Nstl(i,3) = h + radi;
    i = i + 1;

    c = c +1;
    % Face ring top;
    for f = 1 : antNperRev
        Fstl(j,2) = f +antNperRev*c;
        Fstl(j,1) = mod(f,antNperRev) + 1 +antNperRev*c;
        Fstl(j,3) = i - 1;
        j = j + 1;
    end

    aV = 0;
    r = cos(aV+dA);
    z = -radi*sin(aV+dA);
    aV = aV + dA;

    % node ring
    a = 0;
    for n = 1 : antNperRev
        a = a + dA;
        Nstl(i,1) = r*radi*sin(a);
        Nstl(i,2) = r*radi*cos(a);
        Nstl(i,3) = z;
        i = i + 1;
    end  
    
    % Face ring in 2 parts
    for n = 1 : antNperRev
        % tri 2 nodes down
        Fstl(j,1) = n;
        Fstl(j,2) = mod(n,antNperRev) + 1; % samme høyde, +1 utenfor mod pga å unngå 0
        Fstl(j,3) = n + (i-1) - antNperRev; % rett under (ny)
        j = j + 1;
    
        % tri 2 nodes up
        Fstl(j,1) = mod(n,antNperRev)+ 1; % +1 avoids 0
        Fstl(j,2) = mod(n,antNperRev) + 1 - antNperRev  + (i-1); 
        Fstl(j,3) = n + 0 - antNperRev + (i-1); 
        j = j + 1;
    end
    
    for c = 2:antKulerunder
        r = cos(aV+dA);
        z = -radi*sin(aV+dA);
        aV = aV + dA;   
    
        % node ring
        a = 0;
        
        for n = 1 : antNperRev
            a = a + dA;
            Nstl(i,1) = r*radi*sin(a);
            Nstl(i,2) = r*radi*cos(a);
            Nstl(i,3) = z;
            i = i + 1;
        end
    
        % Face ring in 2 parts 
        for n = 1 : antNperRev
            % tri 2 nodes down
            Fstl(j,1) = n + i-1-antNperRev*2;
            Fstl(j,2) = mod(n,antNperRev) + 1 + i-1-antNperRev*2;
            Fstl(j,3) = n + i-1 - antNperRev;
            j = j + 1;        
        
            % tri 2 nodes up
            Fstl(j,1) = Fstl(j-1,2);
            Fstl(j,2) = Fstl(j-1,2) + antNperRev; % rett over og litt forran
            Fstl(j,3) = Fstl(j-1,1) + antNperRev; % rett over
            j = j + 1;
        end   
    end

    % bottom node
    Nstl(i,1) = 0;
    Nstl(i,2) = 0;
    Nstl(i,3) = -radi;
    i = i + 1;

    c = c +1;
    % face ring bottom;
    for n = 1 : antNperRev
        Fstl(j,2) = mod(n,antNperRev) +1 -antNperRev -1 + (i-1);
        Fstl(j,1) = n                    -antNperRev -1 + (i-1);
        Fstl(j,3) = (i-1);
        j = j + 1;
    end
end
