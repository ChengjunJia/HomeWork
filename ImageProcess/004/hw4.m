%%
%С��ҵ4����ͼ��ȥģ��
%2016-11-17
%
%%����ͼƬ������
%����һ�������������ڲ�ɫͼ�����ֵ�˲�
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
%��ֵ�˲�����
Ig = rgb2gray(I);
Igd = im2double(Ig);

%�����˹Ƶ���ͨ�˲���
D0 = 20;
[P Q] = size(Ig);
lowPF3 = zeros(P,Q);  
for i = 1:P  
    for j =1:Q  
        lowPFGuass(i,j) = exp(-((i-P/2)^2+(j-Q/2)^2)/(2*D0^2));  
    end  
end

%���и���Ҷ�任
IgrayFFT = fftshift( fft2( Igd ) );

%���и�Ƶ����
G = I;
for i = 1:3
	fftI = fftshift( fft2( I(:,:,i) ) ) .* lowPF3;
	G(:,:,i) = real(ifft2(ifftshift(fftI)));
end
R = uint8( 2*double(I)-double(G) );

%���ԭͼ��Ϣ
figure;
subplot(221), imshow(I),	title('ԭͼ');
subplot(222), imshow(Ig),	title('תΪ�Ҷ�ͼ');
subplot(223), imshow(log(1+abs(IgrayFFT)),[]), title('Ƶ���ֵ��Ϣ')
subplot(224), imshow(I),	title('��Ƶ�������ͼ��');

%����������˹�˲�
H = fspecial('laplacian',0);
IgrayLap = imfilter(Igd,H,'replicate');

%��������أ�����PSF



%����۽���׼������PSF
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

%ʹ��ä��������������Nums��
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
subplot(221), imshow(I),	title('ԭͼ');
subplot(222), imshow(result1),title('ä�������');
subplot(223), imshow(R),	title('�ٽ��и�Ƶ����');
%subplot(224), imshow(R1),	title('�ٽ�����ֵ�˲�');

%ʹ��Lucy-Richardson�˲���
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
subplot(221), imshow(I),	title('ԭͼ');
subplot(222), imshow(result),title('LR�������');
subplot(223), imshow(R),	title('�ٽ��и�Ƶ����');
%subplot(224), imshow(R1),	title('�ٽ�����ֵ�˲�');
figure,imshow(uint8((uint16(result)+uint16(result1))/2)),title('LR��ä���������ƽ��');