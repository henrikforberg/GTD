function [displacements, longest, weight] = fem(N, E)
    % MATLAB codes for Finite Element Analysis
    % antonio ferreira 2008
    
    warning('off');
    % Mod; modulus of elasticity
    % I: second moments of area
    % J: polar moment of inertia
    % G: shear modulus
    % L: length of bar
    
    E = E'; 
    Mod=210e6; 
    A= 0.02; %20*ones(1,length(E)); %
    Iy=10e-5; 
    Iz=20e-5; 
    J=5e-5; 
    G=84e6;
    
    % for structure:
    % displacements: displacement vector
    % force : force vector
    % stiffness: stiffness matrix
    % GDof: global (number of) degrees of freedom
    
    GDof=6*size(N,1);
    force=zeros(GDof,1);
    force(length(force)) = 150000; %1500000;

    % calculation of the system stiffness matrix
    % and force vector
    [stiffness, longest, weight, check] = frame_3D(GDof, size(E,1), E, N, Mod, A, Iz, Iy, G, J);

    prescribedDof = [1:sum(N(:,3) == 100)*6];
    
    % solution
    displacements = get_displacements(GDof, prescribedDof, stiffness, force);
    %displacements = -displacements;
    
    if check
        displacements=displacements+10000;
        longest = 10000;
    end
end