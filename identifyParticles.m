% NAME:  identifyParticles.m
% PURPOSE:  This script is designed to select identify the center positions
%   of nanoparticles in a liquidphase TEM image based on circle finding.
% INCLUDE:
%   imgInitialization.m: all parameters values are initiated.
%   codes_identification: package for code used in tracking.
%       fileName.m: Name of files with time labels.
%       imageProcessAnalysis.m: process and identify the features.
%       imageEnhanceHighPass.m: filter for high noise image.
%       plotParticles.m: plot the position of columns over TEM image.
% INPUT:All paramters including file name are given in imgInitialization.m.
% OUTPUT?:
%   Matlab window showing the tracking overlaid onto TEM image.
%   SAMPLE_0001.txt: coordinates of columns in format of (time, x, y).
% REFERENCE: Z. Ou, et. al. Nat. Commun. (2020)
%   Supplementary Fig. 6. Automatic tracking protocol. 
% HISTORY:  written by zihao, 2016/12/19
%   edited by zihao, 2020/3/6, package the code together
%%
clc;clear;addpath('codes_identification');
imgPara = imgInitialization;
%%
for n_time = imgPara.frames
    disp(n_time);
    imgPara.Iname = fileName(fullfile(imgPara.path_image,imgPara.file_name),n_time,'.tif');
    imgPara = imageProcessAnalysis(imgPara);
    x = imgPara.x;    y = imgPara.y;    time = n_time * ones(size(x));
    [~,I] = sort(x); x = x(I); y = y(I); result = [time';x';y'];
    fName = fileName(fullfile(imgPara.path_position,imgPara.file_name),n_time,'.txt');
    fileID = fopen(fName,'w');
    fprintf(fileID,'%4d %9.3f %9.3f\n',result);
    fclose(fileID);
end
plotParticles(imgPara);