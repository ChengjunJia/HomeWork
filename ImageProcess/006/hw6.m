%%Homework 6
%% Split the noise and calculate the number of the circus

I = imread('figure.jpg');
Id = im2double(I);
Idfft = fftshift(fft2(Id));
[row col] = size(Id);

%%显示原图信息
% figure,
% subplot(1,2,1),imshow(I),title('Origin Image');
% subplot(1,2,2),imshow(log(1+abs(Idfft)),[]),title('Origin FFT');

%%手动去除渐变噪声——效果不好
% Indfft = Idfft;
% k = 0.3;
% Indfft(row/2+1,1:col/2) = Indfft(row/2+1,1:col/2) * k;
% Indfft(row/2+1,2+col/2:col) = Indfft(row/2+1,2+col/2:col) * k;
% Indfft(1:row/2,col/2+1) = Indfft(1:row/2,col/2+1) * k;
% Indfft(row/2+2:row,1+col/2) = Indfft(row/2+2:row,1+col/2) * k;
% figure,imshow(log(1+abs(Indfft)),[]);
% Ind = ifft2(ifftshift(Indfft));
% figure,imshow(real(Ind));

%维纳自适应滤波——低通寻找渐变噪声，去除——分块二值化
%IW = wiener2(Id,[7 7]);
IW = Id;%medfilt2(Id,[13 13]);
%IW = medfilt2(IW,[13 13]);
% figure,temp = IW;
% subplot(1,2,1),imshow(temp),title('Wiener Filt');
% subplot(1,2,2),imshow(log(1+abs(fftshift(fft2(temp)))),[]),title('FFT');

h1 = fspecial('average',[row/2 col/2]);
temp1 = IW;
temp2 = imfilter(temp1,h1,'replicate');
%%显示去掉的背景
% figure,
% subplot(1,2,1),imshow(temp2),title('Average Filt');
% subplot(1,2,2),imshow(log(1+abs(fftshift(fft2(temp2)))),[]),title('FFT');

%%图像归一化
result = temp1-temp2;
result = (result - min(result(:)))/(max(result(:))-min(result(:)));
%%显示去噪的结果
figure,
subplot(1,2,1),imshow(result),title('Result-Background');
subplot(1,2,2),imshow(log(1+abs(fftshift(fft2(result)))),[]),title('FFT');

%%进行中值滤波——去除散点；然后转换为二值图并滤波
result2 = 1 - medfilt2(1-result,[13 13]);
%figure,imshow(result2),title('Result');
r_bw = im2bw(result2,0.63);
%figure,imshow(r_bw),title('BW-result');
rr = 1-medfilt2(1-r_bw,[31 31]);
figure,imshow(rr),title('result');

%%把图像反转——目标连通域为1，使用MATLAB函数计算连通域个数
r = ~rr;
[L num] = bwlabel(r);

%%使用四连通的结构元素进行膨胀操作来计算连通域个数
se = strel('disk',1,4);
k = zeros(row,col);
tongyu = 0;
while(any(r(:)))
	xuhao = find(r,1,'first');
	k1 = k;
	k1(xuhao) = 1;
	k2 = imdilate(k1,se)&r;
	while(any(any(xor(k1,k2))))
		k1=k2;
		k2= imdilate(k1,se)&r;
	end
	tongyu = tongyu+1;
	r = xor(k1,r);
end