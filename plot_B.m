function plot_B(N,B,siz, varargin)
    % Enkel bounday B plotter, siz>0 er diam pÂ plottringer for meshplot
    % hvis siz = -1 plottes linjer for vokselplott

    %%%%%%%%%%%%%%%%%%%%% START VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%
    figNr = 1;
    
    while ~isempty(varargin)
        switch varargin{1}
            case 'figNr'
                figNr = varargin{2};
            otherwise
                error(['Unexpected option: ' varargin{1}]);
        end
        varargin(1:2) = [];
    end

    figure(figNr);  
    %%%%%%%%%%%%%%%%%%%%% END VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%%

    [dimX, dimY] = size(B);

    % fjerner rader som ikke er 0 0 0 da de ikke er lÂste
    M = N;
    for n=dimX:-1:1
        if B(n,1) ~= 0 || B(n,2) ~= 0 || B(n,3) ~= 0
            M(n,:) = [];
        end
    end

    % plotter laaste rader
    X=M(:,1);
    Y=M(:,2);
    Z=M(:,3);

    hold on;

    if siz>0 % mesh
        scatter3(X,Y,Z,siz,'filled');
    else % voxel
        for i=1:length(X)
            line([X(i) X(i)], [Y(i) Y(i)], [Z(i) Z(i)-2], 'Color',[0 0 1],'Marker','.','MarkerSize', 8);
        end
    end
end

