function plot_mesh(N, E, varargin)
    % 'minMax','fig','hold','Clf','tekst','co','col','noder'
    % Enkel edge plotter, E er edgelist, N er nodelist

    %%%%%%%%%%%%%%%%%%%%% START VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%
    minZ = -1; % for plotting - økt speed
    maxZ = 9999;
    minY = -1;
    maxY = 9999;
    minX = -1;
    maxX = 9999;
    figNr = 1;
    Clf = 1; % clearer ut fig før plotting
    holdOn = 1; % holder gammelt plott før plotting
    tekst = 0; % plotter nodenummer - treg
    co = 0; % plotter origo - dette kan forskyve fig
    col = [1 0.8 0.8]; % farge på plott
    noder = 0; % plott node sirkler - treg


    while ~isempty(varargin)
        switch varargin{1}
            case 'minMax'
                minMax = varargin{2};
                minX = minMax(1);
                maxX = minMax(2);
                minY = minMax(3);
                maxY = minMax(4);  
                minZ = minMax(5);
                maxZ = minMax(6);              
            case 'fig'
                figNr = varargin{2};
            case 'hold'
                holdOn = varargin{2};
            case 'Clf'
                Clf = varargin{2};
            case 'tekst'
                tekst = varargin{2};
            case 'co'
                co = varargin{2};
            case 'col'
                col = varargin{2};
            case 'noder'
                noder = varargin{2};
            otherwise
                error(['Unexpected option: ' varargin{1}]);
        end
        varargin(1:2) = [];
    end

    figure(figNr); 

    if Clf == 1
        clf;
    end

    %%%%%%%%%%%%%%%%%%%%% END VARARGIN %%%%%%%%%%%%%%%%%%%%%%%%%%

    % XX = [N(E(1,:),1) N(E(2,:),1)]';
    % YY = [N(E(1,:),2) N(E(2,:),2)]';
    % ZZ = [N(E(1,:),3) N(E(2,:),3)]';
    %line(XX,YY,ZZ);

    X=N(:,1);
    Y=N(:,2);
    Z=N(:,3);

    axis equal;axis off;grid off;
    set(gcf,'color',[1 1 1]);
    set(gca,'Projection','perspective','view',[30 30]);

    if noder == 1
        for i=1:length(E)
            line([X(E(1,i)) X(E(2,i))], [Y(E(1,i)) Y(E(2,i))], [Z(E(1,i)) Z(E(2,i))], 'Color',col, 'Marker','.','MarkerSize', 8);
        end
    else
        for i=1:length(E)
            if Z(E(1,i)) > minZ && Z(E(1,i)) < maxZ && Y(E(1,i)) > minY && Y(E(1,i)) < maxY && X(E(1,i)) > minX && X(E(1,i)) < maxX
                line([X(E(1,i)) X(E(2,i))], [Y(E(1,i)) Y(E(2,i))], [Z(E(1,i)) Z(E(2,i))], 'Color',col);  
            end
        end
    end

    if tekst == 1
        hold on;
    
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
    
        for ii=1:length(N)
            t = text( N(ii,1), N(ii,2), N(ii,3), num2str(ii) );
            set(t,'Color','b');
        end
    end

    if co == 1
        %coord
        hold on;
        line([0 1],[0 0],[0 0],'Color','r','Marker','.','MarkerSize', 1);
        line([0 0],[0 1],[0 0],'Color','r','Marker','.','MarkerSize', 1);
        line([0 0],[0 0],[0 1],'Color','b','Marker','.','MarkerSize', 1);
    end
end
