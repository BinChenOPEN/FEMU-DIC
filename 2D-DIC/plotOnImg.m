function [] = plotOnImg(Params, ImDef,comptPoints, Disp, strain, varible)

h1 = subplot(1,2,2);
cla(h1);
imagesc(repmat(ImDef,1,1,3));

x      = reshape(comptPoints(:,1)+Disp(:,1),Params.Lx,Params.Ly);
y      = reshape(comptPoints(:,2)+Disp(:,2),Params.Lx,Params.Ly);


cLevel = 32;

hold on,
switch varible
    case 'u'
        plot_variable = Disp(:,1);
    case 'v'
        plot_variable = Disp(:,2);
    case 'exx'
        plot_variable = strain(:,1);
    case 'eyy'
        plot_variable = strain(:,2);
    case 'exy'
        plot_variable = strain(:,3);
end

indx_nan = find(plot_variable == -1);
indx_not_nan = find(plot_variable ~= -1);

plot_variable(indx_nan) = nan;
variable_sort = sort(plot_variable(indx_not_nan));
plot_variable(find(plot_variable<variable_sort(ceil(1/100*length(variable_sort))))) = variable_sort(ceil(1/100*length(variable_sort)));
plot_variable(find(plot_variable>variable_sort(floor(99/100*length(variable_sort(:))))))= variable_sort(floor(99/100*length(variable_sort(:))));
plot_variable(find(abs(plot_variable)<1e-10)) = 0;

surf(y,x,reshape(plot_variable,Params.Lx,Params.Ly),'FaceColor','flat','FaceAlpha',0.5,'EdgeAlpha',0.5,'EdgeColor','none');
shading interp;

%% new colorbar
cmap_sparse = [162,20,47;
        255,0,41;
        255,0,0;
        255,128,0;
        255,255,0;
        0,255,0;
        0,255,255;
        0,0,255;
        128,0,255;
        255,0,255;
        255,0,192]/255;
cmap_sparse = cmap_sparse(end:-1:1,:);
[x_c,y_c] = ndgrid(1:size(cmap_sparse,1),1:3);
[x_q,y_q] = ndgrid(linspace(1,size(cmap_sparse,1),256),1:3);
Vq = interpn(x_c,y_c,cmap_sparse,x_q(:),y_q(:));

cmap = reshape(Vq,256,3);
colormap(cmap);
c = colorbar('eastoutside');

c.Color = [1,0,0];
c.Box = 'off';
c.FontSize = 16;
axis('equal');axis('tight'); 
set(gca,'YDir','reverse'); 
axis off
drawnow,