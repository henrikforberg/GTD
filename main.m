%  GENERATIVE TRUSS DESIGN             
%  FOR SUPPORT-FREE FDM     
%  * * * * * * * * * * * * 
%  Developed June 2020        
%  by Henrik S . Forberg    
%  henriksf@ifi.uio.no     
 
clear all;  

% Program parameters 
FDM = 1;        % Support-Free (0/1)
v   = 0;        % Visualize evolution
p   = 2;        % Specify parpool size 
mx  = 6;        % Number of saved candidates 
h   = 12;       % Model height 
s   = 100;      % Model scale

% NSGA-II Hyperparameters  
pop = 10000;    % Population size
sel = 1000;     % Selection number
gen = 200;      % Number of generations
e_m = 0.40;     % Edge-mutation rate
n_m = 0.10;     % Node-mutation rate
n_g = 0.40;     % Node-generation rate
crs = 0.10;     % Crossover rate 

% MSAA Hyperparameters 
tmp = 10;       % Temperature
stp  = tmp/10;  % Step size  

% * Initialize half-octahedron seed by matrices N and E

% N: Node coordinate array 
% n node indexes, n * [x, y, z] 
N = [4.5   4.5   1; 
     4.5  -4.5   1;  
    -4.5  -4.5   1; 
    -4.5   4.5   1; 
      0     0    h];
N = N.*s;   

% E: Edge array  
% represents beams (edges) by pairs of node indexes from N
E = [1 2 3 4   1 2 3 4 ;
     2 3 4 1   5 5 5 5];  

% Start parpool on local
delete(gcp('nocreate'));
parpool('local',p); 
warning('off'); 
clc;

% Start truss topology synthesis and shape optimization model 
[N_F, E_F, d_f] =  nsga_2(FDM, N, E, s, v,...
                          pop, gen, sel, e_m, n_m, n_g, crs, mx);
                      
[N_F, E_F] = msaa(FDM, N_F, E_F, tmp, stp, s, d_f);








