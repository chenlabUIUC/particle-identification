function fig = plotParticles(imgPara)
% PURPOSE:  this function plot particles.
I = imgPara.I;  [Ly,Lx] = size(I);
screensize = get( groot, 'Screensize' );
Sx = screensize(3);Sy = screensize(4);
if xor(Ly>=Sy,Lx>=Sx)
    Lx = Lx*(Sy-200)/Ly; Ly = Sy-200;
%     disp('IMPORTANT: image larger than screen.')
end
fig = figure(1);clf;
set(fig,'Position', [floor(Sx/2-Lx/2) floor(Sy/2-Ly/2) Lx Ly]);
imagesc(I),colormap('gray'),caxis([32768,32768+512]);
set(gca,'position',[0 0 1 1],'units','normalized');
hold on
scatter(imgPara.x,imgPara.y,50,'g','o','filled');
axis equal;axis off;
axis([imgPara.x_min, imgPara.x_max, imgPara.y_min, imgPara.y_max]);
hold off;
end