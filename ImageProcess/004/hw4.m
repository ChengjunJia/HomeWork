%%
%小作业4——图像去模糊
%2016-11-17
%
%%读入图片并处理
%定义一个函数——用于彩色图像的中值滤波
%function [ OutIm ] = UserJFilter3( InIm,B )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    % OutIm = InIm;
    % for i = 1:3
        % OutIm(:,:,i) = medfilt2(InIm(:,:,i),B);
    % end
% end
clear all;close all;clc;
I = imread('image.jpg');
for i = 1:3
	I(:,:,i) = medfilt2(I(:,:,i),[3 3]);
end
%中值滤波处理
Ig = rgb2gray(I);
Igd = im2double(Ig);

%构造高斯频域低通滤波器
D0 = 20;
[P Q] = size(Ig);
lowPF3 = zeros(P,Q);  
for i = 1:P  
    for j =1:Q  
        lowPFGuass(i,j) = exp(-((i-P/2)^2+(j-Q/2)^2)/(2*D0^2));  
    end  
end

%进行傅里叶变换
IgrayFFT = fftshift( fft2( Igd ) );

%进行高频提升
G = I;
for i = 1:3
	fftI = fftshift( fft2( I(:,:,i) ) ) .* lowPF3;
	G(:,:,i) = real(ifft2(ifftshift(fftI)));
end
R = uint8( 2*double(I)-double(G) );

%输出原图信息
figure;
subplot(221), imshow(I),	title('原图');
subplot(222), imshow(Ig),	title('转为灰度图');
subplot(223), imshow(log(1+abs(IgrayFFT)),[]), title('频域幅值信息')
subplot(224), imshow(I),	title('高频提升后的图像');

%进行拉普拉斯滤波
H = fspecial('laplacian',0);
IgrayLap = imfilter(Igd,H,'replicate');

%进行自相关，估计PSF



%计算聚焦不准带来的PSF
a = 50;
d = 7;
PSF = zeros(d,d);
D = 0.001;
for i = 1:d
	for j = 1:d
		D = sqrt( (i-d/2-1/2)^2+(j-d/2-1/2)^2 );
		if( D*pi/a>1/2 ) PSF(i,j) = 0; end
		if( D*pi/a == 1/2 ) PSF(i,j) =10* pi/a^2; end
		if( D*pi/a < 1/2 ) PSF(i,j) = 10*2*pi/a^2; end
	end
end

%使用盲解卷积方法，迭代Nums次
Nums = 25;
INITPSF = PSF;
result = I;
for i = 1:3
	Itemp = I(:,:,i);
	[J P] = deconvblind(Itemp,INITPSF,Nums);
	result(:,:,i) = J;
end
PSFJudge = P;
G = I;
for i = 1:3
	fftI = fftshift( fft2( result(:,:,i) ) ) .* lowPF3;
	G(:,:,i) = real(ifft2(ifftshift(fftI)));
end
R = uint8( 1.1*double(result)-double(G) );
%R1 = UserJFilter3(R,[3 3]);
%R1 = UserJFilter3(R1,[3 3]);
result1 = result;

figure
subplot(221), imshow(I),	title('原图');
subplot(222), imshow(result1),title('盲解卷积结果');
subplot(223), imshow(R),	title('再进行高频提升');
%subplot(224), imshow(R1),	title('再进行中值滤波');

%使用Lucy-Richardson滤波法
INITPSF = PSFJudge;
result = I;
for i = 1:3
	Itemp = I(:,:,i);
	J = deconvlucy(Itemp,INITPSF,5);
	result(:,:,i) = J;
end
G = I;
for i = 1:3
	fftI = fftshift( fft2( result(:,:,i) ) ) .* lowPF3;
	G(:,:,i) = real(ifft2(ifftshift(fftI)));
end
R = uint8( 1.1*double(result)-double(G) );
%R1 = UserJFilter3(R,[3 3]);
%R1 = UserJFilter3(R1,[3 3]);

figure
subplot(221), imshow(I),	title('原图');
subplot(222), imshow(result),title('LR解卷积结果');
subplot(223), imshow(R),	title('再进行高频提升');
%subplot(224), imshow(R1),	title('再进行中值滤波');
figure,imshow(uint8((uint16(result)+uint16(result1))/2)),title('LR和盲反卷积进行平均');