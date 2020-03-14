function imgPara = imgInitialization()
% NAME:  imgInitialization.m
% PURPOSE:  This function includes all parameters used in tracking.
% HISTORY:  Edited by zihao, 2020/3/6, package the code together
%%
% parameters related to image input
imgPara.file_name = 'SAMPLE';
imgPara.frames = 1; %
imgPara.path_image = '';
imgPara.path_position = '';
% parameters for ploting
imgPara.x_min = 180;    imgPara.x_max = 900;
imgPara.y_min = 100;    imgPara.y_max = 820;
% parameters for image processing
imgPara.lnoise = 3;
imgPara.lobject = 25;
imgPara.intensity_cut = 15;
% parameters for circle finding
imgPara.range = [6,15];
imgPara.threshold = 0.03;
imgPara.sensitivity = 0.9;
% closest distance to delete particles
imgPara.delete = 27.02;
end