clc;
clear;
close all;
%% load image
A = imread('Artificial dataset0016.jpg');
figure;
imshow(A);
title('original Image')
%% CNN network
figure;
net = denoisingNetwork('dncnn');
denoisedA = denoiseImage(A,net);
imshow(denoisedA)
title('Denoised Image')
% getting binary image
binary = multithresh(denoisedA,2);
%% remove noise by threshold
seg_I = imquantize(denoisedA,binary);
seg_II=uint8(seg_I-1);
%% image without noise
detect_output = label2rgb(seg_I);
figure;

L = bwlabel(seg_II);
s  = regionprops(L, 'centroid');
XY=[s.Centroid];
hold on;
red=[255,0,0];
for i=1:size(XY,2)/2
    x=int8(XY(1,i*2-1));
    y=int8(XY(1,i*2));
    if(x>size(L ,1)-2 || y>size(L ,1)-2)
        continue;
    end
   
    pixbefore=5;
    pixafter=5;
    for K=1:3
        detect_output(y - pixbefore : y + pixafter, [x - pixbefore, x + pixafter], K) = red(K);  %left and right edge
        detect_output([y - pixbefore + 1, y + pixafter - 1], x - pixbefore : x + pixafter, K) = red(K);  %top and bottom edge
    end
    hold on;
end
imshow(detect_output)
title('Detection result')