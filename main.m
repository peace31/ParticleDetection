clc;
clear;
close all;
%% load image
A = imread('Artificial dataset0029.jpg');
imshow(A);
%% blur gaussian 
H = fspecial('average',5);
MotionBlur = imfilter(A,H,'replicate');
figure;
imshow(MotionBlur);
%% image gaussian filetr
B = imgaussfilt(MotionBlur,2);
imshow(B);
% threshod to remove noise
thresh = multithresh(B,2);
thresh(1)=thresh(1)+5;
thresh(2)=thresh(2)+5;
%% remove noise by threshold
seg_I = imquantize(B,thresh);
seg_II=uint8(seg_I-1);

%% image without noise
RGB = label2rgb(seg_I); 	 
figure;

L = bwlabel(seg_II);
s  = regionprops(L, 'centroid');
XY=[s.Centroid];
hold on;
red=[255,0,0]
for i=1:size(XY,2)/2
    x=int8(XY(1,i*2-1))
    y=int8(XY(1,i*2))
    if(x>size(L ,1)-2 || y>size(L ,1)-2)
        continue;
    end
   
    pixbefore=5;
    pixafter=5;
    for K=1:3
        RGB(y - pixbefore : y + pixafter, [x - pixbefore, x + pixafter], K) = red(K);  %left and right edge
        RGB([y - pixbefore + 1, y + pixafter - 1], x - pixbefore : x + pixafter, K) = red(K);  %top and bottom edge
    end
    hold on;
end
imshow(RGB)