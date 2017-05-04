clc
close all
clear all
I = imread('hw2.jpg');

%ͳ�Ƴ�I�������� �Լ� �ܵ�������%
[row,col]=size(I);
sizeim = row*col;

%����ֱ��ͼ
num = 1:256;
I1 = reshape(I,1,[]);
histnum = zeros(1,256);
for i = num
    [row,histnum(1,i)] = size(find(I1(:,:)==i-1));
    %ͳ��0-255��ÿһ������ֵ������Ŀ
end
figure
subplot(2,2,1);
imshow(I);
title('Origin Image');
subplot(2,2,2);
bar(histnum);
title('Hist of the Origin');

%�����µ�ӳ���ϵ
sum_im = zeros(1,256);
sum_im(1,1) = histnum(1,1);
num = 2:256;
for i = num
    sum_im(1,i) = sum_im(1,i-1)+histnum(1,i);  
end
reset = uint8(sum_im/(sizeim/256));

%������ͼ��
newIm = I;
num = 1:256;
for i = num
    A = find(I(:,:) == i-1);
    newIm(A) = reset(1,i);
end
subplot(2,2,3);
imshow(newIm);
title('Modified Image');
subplot(2,2,4);
hist(double(reshape(newIm,1,[])));
title('Hist of the Modified');

%�����µ�������ǿͼ��
figure
subplot(2,2,1);
imshow(newIm);
title('Origin Image');
Ilight = uint8(newIm + 10);
subplot(2,2,2);
imshow(Ilight);
title('newImage = Origin + 10');
Ilight = uint8(newIm + 50);
subplot(2,2,3);
imshow(Ilight);
title('newImage = Origin + 50');
Ilight = uint8(sqrt(double(newIm)*255));
subplot(2,2,4);
imshow(Ilight);
title('newImage = Sqrt(Origin*255)');

%���㷭תͼ
DiffIm = 255 - newIm;
figure
subplot(1,2,1);
imshow(newIm);
title('Image');
subplot(1,2,2);
imshow(DiffIm);
title('Invert Image');