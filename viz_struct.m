function viz_struct(N,E,r, num)
    [dummy noEdg] = size(E); 

    Nx = [];
    Fx = [];

    for e = 1 : noEdg
        %r = r + 0.1;
        n1 = E(1,e);
        n2 = E(2,e);
        v1 = N(n1,:);
        v2 = N(n2,:);
        vImesh = v2-v1;
        L = norm(vImesh);
        [NN,FF] = edge_to_tube(L,r);
        vTempl = [0 0 L];
        if vImesh(1) == 0 && vImesh(2) == 0 
            vImesh = vImesh + 0.01;%[0 0 0.0001]; 
        end
        vCross = cross(vTempl,vImesh);
        ang = atan2(norm(cross(vTempl,vImesh)), dot(vTempl,vImesh));
        k = vCross/norm(vCross);
        K = [0 -k(3) k(2) ; k(3) 0 -k(1 ); -k(2) k(1) 0];
        R = eye(3) + (sin(ang))*K + (1-cos(ang))*K*K;
        NN = (R*NN')';
        NN = NN + v1;
        Nx = [Nx;NN]; 
        Fx = [Fx;FF+length(NN)*(e-1)];
    end

    figure(num)
    clf;
    axis equal;axis off;grid off;
    set(gcf,'color',[1 1 1]);
    set(gca,'Projection','perspective','view',[30 30]);
    patch('Faces',Fx,'Vertices',Nx,'FaceColor',[1 1 1],'EdgeColor','none');
    camlight('right');
end
