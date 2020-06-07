clear;

N = readtable('N.xls');
E = readtable('E.xls');
N = N{:,:};
E = E{:,:};

% MSAA Hyperparameters 
tmp = 10;       % Temperature
stp  = 1;       % Step size  
s = 100;        % Scale
p = 2;          % Parpool size
FDM = 1;        % Support-Free

N = {N};
E = {E};

% Start parpool on local
delete(gcp('nocreate'));
parpool('local',p); 
warning('off'); 
clc;

parfor i = 1:2
    directory = sprintf('temp_%i_stepsize_%i_run_%i', tmp, stp, i);
    mkdir(directory);
    [N_a, E_a] = msaa(FDM, N, E, tmp, stp, s, directory);
end


