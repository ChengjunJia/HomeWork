%%
%大作业2：图片去反光程序
%2016-11-17创建，2016-11-24最近编辑
% 最后的代码部分是为了进行各种参数选定而使用的调整代码
% 会显示图片的相关信息、直方图统计信息等
% 本程序需要调用函数JTongTai，作为同态滤波方法,函数代码如下：

% function [ output ] = JTongTai( inputIm,H )
% %对inputIm做同态滤波，频域内同态滤波系数矩阵为H
% %   output——输出图像
% %   inputIm——输入图像
% %   H——使用的系数矩阵

    % Ifft = fftshift( fft2( log(1 + inputIm) ) );
    % resultfft =  Ifft .* H ;
    % output = exp( real( ifft2 ( ifftshift( resultfft) ) ))-1;

% end

%
%%
close all;clear all;
fs = 'p0.jpg';
I = imread(fs);
Id = double(I)/255;
IRed = double( I(:,:,1) )/255 ;
IGreen = double( I(:,:,2) )/255 ;
IBlue = double( I(:,:,3) )/255 ;

hsv= rgb2hsv(I);
IH = hsv(:,:,1);
IS = hsv(:,:,2);
IV = hsv(:,:,3);
Ilight = (IRed+IGreen+IBlue) ./3;

Ig = rgb2gray(I);
[row,col] = size(Ig);
IgFFT = fftshift(fft2(Ig));

%%构造高频提升、低频削弱的H
d0=10;r1=0.95;rh=1.05;c=2;
n1=floor((row+1)/2);n2=floor((col+1)/2);
h = double(IgFFT);
for m = 1:row
    for n = 1:col
        d = sqrt(( m-n1)^2+( n-n2)^2);
        h( m,n ) = (rh-r1)*(1-exp(-c*(d.^2/d0.^2)))+r1;
    end
end

nhsv = hsv;
nhsv(:,:,3) = JTongTai(hsv(:,:,3),h);
for m= 1:20
	nhsv(:,:,3) = JTongTai(nhsv(:,:,3),h);
end

resultIm = hsv2rgb(nhsv);
for m = 1:3
	temp = resultIm(:,:,m);
	resultIm(:,:,m) = ( temp-min(min(temp)) )/( max(max(temp))-min(min(temp)) );  
end

%将图像根据阈值变换为0-1图像；根据中心线的像素情况去除外围
IBlue1 = I(:,:,3)/255;
IBlue1 = medfilt2(double(IBlue1),[7 7]);
Irb = IBlue1(:,floor(col/2));
Icb = IBlue1(floor(row/2),:);
loc = find( Irb(:)~=1 );
rb = loc(5)-5;
re = loc(size(loc,1)-5)+5;
loc = find( Icb(:)~=1 );
cb = loc(5)-5;
ce = loc(size(loc,1)-5)+5;
IFilt = ones(size(IBlue1));
IFilt(rb:re,cb:ce) = IBlue1(rb:re,cb:ce);
%根据每列为0的最值处确定工件真正区域——真正区域都幅值为1——作为掩膜
for m = rb:re
	A = IFilt(m,:);
	loc = find(A==0);
	IFilt(m,min(loc):max(loc))=0;
end
IFilt = 1-IFilt;

result = zeros( size(resultIm) );
result1 =result;
for m = 1:3
	result1(:,:,m) = resultIm(:,:,m) .* IFilt;
	result(:,:,m) =  result1(:,:,m) + 255*(1-IFilt) ;
end
figure,imshow(result),title('最后结果');
saveas(gcf,[fs(1:length(fs)-4) '_结果.png'])
figure,
subplot(221),imshow(Id),title('原图');
subplot(222),imshow(result),title('最后结果');
subplot(223),imshow(Id-result1),title('二者之差');
saveas(gcf,[fs(1:length(fs)-4) '_对比结果.png'])


% figure, subplot(121),imshow(resultIm);title('HSV中S通道滤波')
% subplot(122),imshow(I),title('原图');
% figure,imshow(Id-resultIm),title('滤除的图像部分');

%%显示图片的各个分量的信息
% figure,
% subplot(221),imshow(I),title('原图');
% subplot(222),imshow(IRed,[]),title('红色分量');
% subplot(223),imshow(IGreen,[]),title('绿色分量');
% subplot(224),imshow(IBlue,[]),title('蓝色分量');
% figure,
% subplot(221),imshow(IH),title('H分量-色调');
% subplot(222),imshow(IS,[]),title('S分量-饱和度');
% subplot(223),imshow(IV,[]),title('V分量-强度');
% subplot(224),imshow(Ilight,[]),title('I分量-三色平均');

% %%显示中央部分的图像走向，确定去除背景的方案——选定使用B通道，取128作为阈值(根据图形结果)
% Irr = IRed(:,floor(col/2));
% Irb = IBlue(:,floor(col/2));
% Irg = IGreen(:,floor(col/2));
% Irh = IH(:,floor(col/2));
% Irs = IS(:,floor(col/2));
% Irv = IV(:,floor(col/2));
% Ir = 1:row;
% figure,
% subplot(321),plot(Ir,Irr,'r'),title('图像横向中央R');
% subplot(323),plot(Ir,Irg,'g'),title('图像横向中央G');
% subplot(325),plot(Ir,Irb,'b'),title('图像横向中央B');
% subplot(322),plot(Ir,Irh,'r'),title('图像横向中央H');
% subplot(324),plot(Ir,Irs,'g'),title('图像横向中央S');
% subplot(326),plot(Ir,Irv,'b'),title('图像横向中央V');

% Icr = IRed(floor(row/2),:);
% Icb = IBlue(floor(row/2),:);
% Icg = IGreen(floor(row/2),:);
% Ich = IH(floor(row/2),:);
% Ics = IS(floor(row/2),:);
% Icv = IV(floor(row/2),:);
% Ic = 1:col;
% figure,
% subplot(321),plot(Ic,Icr,'r'),title('图像纵向中央R');
% subplot(323),plot(Ic,Icg,'g'),title('图像纵向中央G');
% subplot(325),plot(Ic,Icb,'b'),title('图像纵向中央B');
% subplot(322),plot(Ic,Ich,'r'),title('图像纵向中央H');
% subplot(324),plot(Ic,Ics,'g'),title('图像纵向中央S');
% subplot(326),plot(Ic,Icv,'b'),title('图像纵向中央V');




%%根据RGB的平均值——I进行处理
% IlightLv = JTongTai(Ilight,h);
% figure,
% subplot(121),imshow(IlightLv,[]),title('Light变化');
% subplot(122),imshow( Ilight-IlightLv,[] ),title('对比');

% Inew1 = I;
% Inew1(:,:,1) = IRed .* ( IlightLv ./ Ilight );
% Inew1(:,:,2) = IGreen .* ( IlightLv ./ Ilight );
% Inew1(:,:,3) = IBlue .* ( IlightLv ./ Ilight );
% figure,
% subplot(121),imshow(Inew1),title('使用平均进行滤波');
% subplot(122),imshow(I-Inew1),title('滤除的部分');

%进行高频增强——边缘锐化、使用Laplace算子
% H = [0 1 0; 1 -4 1; 0 1 0];
% rg = rgb2gray(result);
% J = conv2(double(rg),H,'same');
% K = double(rg)-J;
% figure,imshow(K,[]),title('Laplace高频增强');