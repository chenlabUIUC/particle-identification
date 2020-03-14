%%  identify the positions of the particles inside one frame
function imgPara = imageProcessAnalysis(imgPara_old)
    imgPara = imgPara_old;
    imgPara.I = double(imread(imgPara.Iname));
    imgPara.I_enhance = imageEnhaceHighPass(imgPara.I,imgPara.lnoise,imgPara.lobject);
    list_temp = imgPara.I_enhance < imgPara.intensity_cut;
    imgPara.I_enhance(list_temp) = 0;
    [centers, radii] = imfindcircles(imgPara.I_enhance, imgPara.range, ...
        'ObjectPolarity', 'bright',...
        'EdgeThreshold',imgPara.threshold,'Sensitivity',imgPara.sensitivity);
    y = centers(:,2);[~,I] = sort(y);centers = centers(I,:);radii = radii(I);
    [centers, radii] = imageDeleteParticlesRadiusIntensity(centers,radii,imgPara.delete,imgPara.I_enhance);
    imgPara.x = centers(:,1);imgPara.y = centers(:,2);imgPara.radii = radii;
end
function [ pos_new, r_new ] = imageDeleteParticlesRadiusIntensity( pos_old, r_old, cut, Im )
% NAME:  imageDeleteParticlesRadiusIntensity.m
% PURPOSE:
%   Delete particle positions and radius based on their local intensity.
%   First need to use the image method to get the postion of the particle
%   and then use imcirclefind to match the particle position and radius.
% INCLUDE: none.
% INPUT:pos_old:original positions, n_particle x 2 matrix.
%           pos_old(:,1): x position
%           pos_old(:,2): y position
%       r_old:  original radius
%       cut:    the nearest possible neighbour distance. Get from the
%           first minimum from radial distribution function to get rid of
%           the first peak due to misidentified particles.
%       Im:     the image with intensity used to check which position has
%           higher intensity. Use this value to determine which particle is
%           more possible to be the real position.
% OUTPUT:pos_new:    new positions array
%           pos_new(:,1): x position
%           pos_new(:,2): y position
%           r_new:      new radius array
%HISTORY:   zihao, 20150906 written based imageDeleteParticles
%           zihao, 20151122 modified, notes added
[n_particle,~] = size(pos_old);
pos_new = pos_old; r_new = r_old;
% get the dist_matrix using the built-in function dist.
dist_matrix = dist(pos_old');
% Loop over all distance pairs and find the particles.
% Use count_i and count_j to tell the position of distance pair with
% count_j < count_i to avoid double count.
count_i = 2;
% imagesc(Im); colormap('gray'); hold on;
% scatter(pos_old(:,1),pos_old(:,2),50,'go','filled');
while count_i <= n_particle
    count_j = 1;
    while (count_j < count_i) && (count_i <= n_particle)
%         judge if the particles are within the pair distance threshold.
        if dist_matrix(count_i,count_j) < cut
%       if too near, identify the particle with higher intensity as real
            Ii = Im(round(pos_new(count_i,2)),round(pos_new(count_i,1)));
            Ij = Im(round(pos_new(count_j,2)),round(pos_new(count_j,1)));
%             text(pos_new(count_i,1),pos_new(count_i,2),num2str(Ii),'Color','red');
%             text(pos_new(count_j,1),pos_new(count_j,2),num2str(Ij),'Color','blue');
            if Ii > Ij
%                 delete particle with label count_j. As count_j <
%                 count_i, when it is deleted from distance matrix, count_i 
%                 will reduce one and count_j keeps unchanged.
                pos_new(count_j,:) = [];    r_new(count_j,:) = [];
                dist_matrix(count_j,:) = [];dist_matrix(:,count_j) = [];
                count_i = count_i - 1;
            else
%                 delete particle with label count_i. As count_j <
%                 count_i, when it is deleted from distance matrix, count_i
%                 keep unchanged while count_j restart from one.
                pos_new(count_i,:) = [];    r_new(count_i,:) = [];
                dist_matrix(count_i,:) = [];dist_matrix(:,count_i) = [];
                count_j  = 1;
            end
%           particle numberj reduce by 1
            n_particle = n_particle - 1;
        else
            count_j = count_j + 1;
        end      
    end
    count_i = count_i + 1;
end
end