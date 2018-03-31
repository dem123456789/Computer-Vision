clc
clear
close all

setPATH

imageNames = {'graffiti_viewpoint_frames_1_2','graffiti_viewpoint_frames_1_4','graffiti_viewpoint_frames_1_5'};


Noise = 0;
noiseSigmaInPixels = 0;
GPMparams.byPercentileAverage = 1;
minimalSiftThreshold = 1.24;