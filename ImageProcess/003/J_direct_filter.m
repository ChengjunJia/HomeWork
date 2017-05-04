%%********************
%CopyRight 贾成君(jcj14@mails.tsinghua.edu.cn)
%All rights Reserved
%Filename: J_direct_filter.m
%Summary: Use the FFT to reduce the background
%Last Time:
%%******************
close all; clear all;
I = imread('HW3.jpg');
centerX = (size(I,2)+1)/2;
centerY = (size(I,1)+1)/2;
%进行高频增强
h1=[0 -1 0, -1 5 -1, 0 -1 0];
% I = conv2(im2double(I),h1,'same');

%% 计算的原来表格中的背景的线方向——选点-计算斜率
% figure, imshow( I ), axis on;
% [x y] = ginput(3);
% x = [ 48.0000; 546.0000; 44.0000 ]; y =[ 129; 122;463 ];
% newx = [194.00; 437.00; 514.00]; newy = [139.00;82.0000;118.00];
% k1 = (y(2)-y(1))/(x(2)-x(1));
% k2 = (y(3)-y(1))/(x(3)-x(1));
% k3 = [ -1.4170; -0.6712; 0.7921];
% fftk1 = -1/k1;
% fftk2 = -1/k2;
% 计算的直线斜率结果直接赋值，不再执行上述的算法
fftk1 = 71.142857142857140; fftk2 = 0.011976047904192;
%此时k1对应的角度为 0.99*pi/2 rad;k2对应角度为 0.012 rad--可以近似为垂直和水平

%%计算要去除的线
draw_x = 1:size(I,2);
draw_y1 = fftk1*( draw_x-centerX ) + centerY;
draw_y2 = fftk2*( draw_x-centerX ) + centerY;
% 画出要去除的线
I_fft_shift = fftshift( fft2(I) );
Range_I = log( 1 + abs( I_fft_shift ) );
figure, imshow( Range_I, [] ), title('原始图像-标记要去除的部分'), axis on;
hold on; plot( draw_x, draw_y1 ), plot( draw_x, draw_y2 );

%%选出每个方向上需要滤去的范围（从哪里向外）-根据对称性，截取一部分即可
% [edge_x edge_y] = ginput(4);
% edge_x = [489;156;321.00;326.00];
% edge_y = [244.00;238.00;98.00;427];
% 上述的点为选择出来的目测合适的滤波位置——经过实际的调参数后的结果如下：
edge_x = [345;305;321.00;326.00];
edge_y = [244.00;238.00;220.00;260];

%%使用长条覆盖原来的点，长条的宽度设置为 $length 个像素
result_fft = I_fft_shift;
length = 10;
result_fft( (edge_y(1)-length):(edge_y(1)+length), edge_x(1):size(I,2) ) = 0;
result_fft( (edge_y(2)-length):(edge_y(2)+length), 1:edge_x(2) ) = 0;
result_fft( 1:edge_y(3),(edge_x(3)-length):(edge_x(3)+length) ) = 0;
result_fft( edge_y(4):size(I,1),(edge_x(4)-length):(edge_x(4)+length) ) = 0;
%显示结果,结果存储在result
result_im = ifft2( ifftshift(result_fft) );
result = uint8( real(result_im) );
figure, 
subplot(2,2,1),imshow(I),title('原来图像');
subplot(2,2,2),imshow(result), title('处理后图像');
subplot(2,2,3),imshow(Range_I,[]),title('原来频域');
subplot(2,2,4),imshow( log( 1+ abs(result_fft) ),[] ), title('处理后频域');

%%使用倾斜区域覆盖，覆盖从r起，覆盖角度设置为 正负15°(klimit)
result_fft2 = I_fft_shift;
r = 1;
klimit = tan(15/90*pi/2);
%参数设置：10，5->10,10; 可以置为0，也可以设置成log、二分之一
for i = 1:size(I,1)
	for j = 1:size(I,2)
		if ( i == centerY && abs(j-centerX) > r )
			result_fft2(i,j) = 0; break;
		end 
		if ( j == centerX && abs(i-centerY) > r )
			result_fft2(i,j) = 0; break;
		end 
		if ( abs( (i-centerY)/(j-centerX) ) < klimit || abs( (j-centerX)/(i-centerY) ) <klimit )
			if( abs( i-centerY ) + abs( j-centerX ) > r ) 
				result_fft2(i,j) = 0;
			end
		end
	end
end
result_im = ifft2( ifftshift(result_fft2) );
result2 = uint8( real(result_im) );
figure, 
subplot(2,2,1),imshow( Range_I,[] ),title('原来频域');
subplot(2,2,2),imshow( log( 1+ abs(result_fft2) ),[] ),title('处理后频域');
subplot(2,2,3),imshow( I ),title('原来图像');
subplot(2,2,4),imshow( result2 ), title('处理后图像');

%%对图像进行进一步处理——使用中值滤波
figure, 
subplot(2,2,1), imshow( result2 ),title('处理结果');
subplot(2,2,2), imshow( I - result2),title('去除的网格情况');

K1 = medfilt2(result2,[3,3]);
subplot(2,2,3), imshow( K1 ),title('[3,3]窗口中值滤波');
subplot(2,2,4), imshow( I - K1);

figure
K2 = medfilt2(result2,[10,10]);
subplot(2,2,1), imshow( K2 ),title('[10,10]窗口中值滤波');
subplot(2,2,2), imshow( I - K2);

K3 = conv2(result2,h1,'same');
K3 = uint8(K3);
subplot(2,2,3), imshow( K3 ),title('高频处理');
subplot(2,2,4), imshow( I - K3 );

figure
K4 = medfilt2( K3,[10,10] );
subplot(2,2,1), imshow( K4 ),title('高频处理后[10,10]中值');
subplot(2,2,2), imshow( I - K4 );