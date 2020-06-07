function [Nstl,Fstl] = edge_to_tube(h,radi)

    Nstl = zeros(20002,3);
    Fstl = zeros(40000,3); % 3 noder i en face

    antNperRev = 200;
    dA = 2*pi/antNperRev;
    antKulerunder = antNperRev/4 - 1;

    i = 1;
    j = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cyl
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

    % Face ring i 2 deler
    for n = 1 : antNperRev
        % tri 2 noder nede
        Fstl(j,2) = n;
        Fstl(j,1) = mod(n,antNperRev) + 1; % samme høyde, +1 utenfor mod pga å unngå 0
        Fstl(j,3) = n + antNperRev; % rett over
        j = j + 1;
    
        % tri to noder oppe
        Fstl(j,2) = Fstl(j-1,1);
        Fstl(j,1) = Fstl(j-1,1) + antNperRev; % rett over og litt forran
        Fstl(j,3) = Fstl(j-1,2) + antNperRev; % rett over
        j = j + 1;    
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kule øverst
    aV = 0;
    for c = 1:antKulerunder
        r = cos(aV+dA);
        z = h + radi*sin(aV+dA);
        aV = aV + dA;   
    
        % nodering
        a = 0;
        for n = 1 : antNperRev
            a = a + dA;
            Nstl(i,1) = r*radi*sin(a);
            Nstl(i,2) = r*radi*cos(a);
            Nstl(i,3) = z;
            i = i + 1;
        end
    
        % Face ring i 2 deler - går direkte fra siste ring
        for n = 1 : antNperRev
            % tri 2 noder nede
            Fstl(j,2) = n + i-1-antNperRev*2;
            Fstl(j,1) = mod(n,antNperRev) + 1 + i-1-antNperRev*2;
            Fstl(j,3) = n + i-1 - antNperRev;
            j = j + 1;        
        
            % tri to noder oppe
            Fstl(j,2) = Fstl(j-1,1);
            Fstl(j,1) = Fstl(j-1,1) + antNperRev; % rett over og litt forran
            Fstl(j,3) = Fstl(j-1,2) + antNperRev; % rett over
            j = j + 1;
        end   
    end

    % topp Node
    Nstl(i,1) = 0;
    Nstl(i,2) = 0;
    Nstl(i,3) = h + radi;
    i = i + 1;

    c = c +1;
    % Face ring topplokk;
    for f = 1 : antNperRev
        Fstl(j,2) = f +antNperRev*c;
        Fstl(j,1) = mod(f,antNperRev) + 1 +antNperRev*c;
        Fstl(j,3) = i - 1;
        j = j + 1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kule øverst slutt
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kule nederst
    aV = 0;
    % runde nr 1
    r = cos(aV+dA);
    z = -radi*sin(aV+dA);
    aV = aV + dA;

    % nodering
    a = 0;
    for n = 1 : antNperRev
        a = a + dA;
        Nstl(i,1) = r*radi*sin(a);
        Nstl(i,2) = r*radi*cos(a);
        Nstl(i,3) = z;
        i = i + 1;
    end  
    
    % Face ring i 2 deler
    for n = 1 : antNperRev
        % tri 2 noder nede
        Fstl(j,1) = n;
        Fstl(j,2) = mod(n,antNperRev) + 1; % samme høyde, +1 utenfor mod pga å unngå 0
        Fstl(j,3) = n + (i-1) - antNperRev; % rett under (ny)
        j = j + 1;
    
        % tri to noder oppe
        Fstl(j,1) = mod(n,antNperRev)+ 1; % samme høyde, +1 utenfor mod pga å unngå 0
        Fstl(j,2) = mod(n,antNperRev) + 1 - antNperRev  + (i-1); 
        Fstl(j,3) = n + 0 - antNperRev + (i-1); 
        j = j + 1;
    end
    
    % runde nr 1 ferdig
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for c = 2:antKulerunder
        r = cos(aV+dA);
        z = -radi*sin(aV+dA);
        aV = aV + dA;   
    
        % nodering
        a = 0;
        
        for n = 1 : antNperRev
            a = a + dA;
            Nstl(i,1) = r*radi*sin(a);
            Nstl(i,2) = r*radi*cos(a);
            Nstl(i,3) = z;
            i = i + 1;
        end
    
        % Face ring i 2 deler - går direkte fra siste ring
        for n = 1 : antNperRev
            % tri 2 noder nede
            Fstl(j,1) = n + i-1-antNperRev*2;
            Fstl(j,2) = mod(n,antNperRev) + 1 + i-1-antNperRev*2;
            Fstl(j,3) = n + i-1 - antNperRev;
            j = j + 1;        
        
            % tri to noder oppe
            Fstl(j,1) = Fstl(j-1,2);
            Fstl(j,2) = Fstl(j-1,2) + antNperRev; % rett over og litt forran
            Fstl(j,3) = Fstl(j-1,1) + antNperRev; % rett over
            j = j + 1;
        end   
    end

    % bunn Node
    Nstl(i,1) = 0;
    Nstl(i,2) = 0;
    Nstl(i,3) = -radi;
    i = i + 1;

    c = c +1;
    % Face ring bunnlokk;
    for n = 1 : antNperRev
        Fstl(j,2) = mod(n,antNperRev) +1 -antNperRev -1 + (i-1);
        Fstl(j,1) = n                    -antNperRev -1 + (i-1);
        Fstl(j,3) = (i-1);
        j = j + 1;
    end
end