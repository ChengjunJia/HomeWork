%%HW7——自动求阈值
I = imread('hw.jpg');
Id = im2double(I);
%统计直方图信息
[hgram,x] = imhist(I);
%直方图不断平滑直到只有两个极大值
y = smooth(hgram,3);
while( size(findpeaks(y),1) ~=2 )
	y = smooth(y,3);
end
[pks,loc] = findpeaks(y);

%%取中值作为阈值
Th = (loc(1)+loc(2))/2;
result = im2bw(Id,double(Th)/255);
figure,imshow(result);title('(Mb+Mf)/2');

%%取谷底
aim = loc(1);
while(y(aim+1) <= y(aim) && aim<=loc(2) )
	aim = aim+1;
end
Th = aim;
result = im2bw(Id,double(Th)/255);
figure,imshow(result);title('T2--Min in the Peak');

%%中值——像素点总个数，累加到第一个比中值大的地方
Numall = size(I,1)*size(I,2);
s = cumsum(hgram);	%累计所有[1,m]内的像素点个数
aim = 1;	num = hgram(1);
while( s(aim) < Numall/2 && aim <= 255 )
	aim = aim + 1;
end
Th = aim;
result = im2bw(Id,double(Th)/255);
figure,imshow(result);title('Middle sum');

%%动量矩不变

L = (0:255)';
A = sum(hgram);
B = sum(hgram .* L);
C = sum(hgram .* L .*L );
D = sum(hgram .* L .*L .*L);
x2 = (A*D-B*C)/(A*C-B*B);
x1 = (B*D-C*C)/(A*C-B*B);
At = (A/2*(sqrt(x2*x2-4*x1)+x2)-B)/(sqrt(x2*x2-4*x1));
aim = 1;
while( s(aim) < At && aim <= 255 )
	aim = aim + 1;
end
Th = aim;
result = im2bw(Id,double(Th)/255);
figure,imshow(result);title('DongLiangJu');

%%平均值平均
t0 = uint8(128);
s1 = cumsum(hgram .* L);
t1 = uint8( ( s1(t0)/s(t0) + (B-s1(t0))/(A-s(t0)) )/2);
while( t0 ~= t1)
	t0 = t1;
	t1 = uint8( ( s1(t0)/s(t0) + (B-s1(t0))/(A-s(t0)) )/2);
end
Th = t0;
result = im2bw(Id,double(Th)/255);
figure,imshow(result);title('Average Aver');