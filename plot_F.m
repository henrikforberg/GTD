function plot_F(N,F, s, varargin)
    % Enkel F plotter
    % N er nodelist, skalerer vektorer med s

    %%%%%%%%%%%%%%%%%%%%% START VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%
    figNr = 1;

    while ~isempty(varargin)
        switch varargin{1}
            case 'figNr'
                figNr = varargin{2};
                figure(figNr);
            otherwise
                error(['Unexpected option: ' varargin{1}]);
        end
        varargin(1:2) = [];
    end

    %%%%%%%%%%%%%%%%%%%%% END VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%%

    [dimX, dimY] = size(F);

    hold on;

    for n=1:dimX
        if F(n,1) ~= 0 || F(n,2) ~= 0 || F(n,3) ~= 0
            quiver3(N(n,1), N(n,2), N(n,3), 0, 0, -N(n,3)+F(n,3), 0.35,'Color', [0 1 0]);
        end
    end
end