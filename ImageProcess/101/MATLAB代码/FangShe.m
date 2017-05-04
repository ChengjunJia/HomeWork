%%
%*****拼接图片
tic
disp('程序开始...');
%读取图片至im1a-im3a,计算图像大小至row、col
im1a = imread('1.jpg');
im2a = imread('2.jpg');
im3a = imread('3.jpg');
[row,col,o] = size(im1a);
disp('图像读取完成...');
toc

%生成最终的图像存储目标——3倍高度、3倍长度，生成高斯滤波函数，并对原来各个图形滤波和大小重塑，输出到im1b-im3b
tic
imfinal = uint8(zeros(3*row,col*3,o));
sigma = 1;
gausFilter = fspecial('gaussian',[5,5],sigma);
im1b = imfilter( im1a,gausFilter,'replicate');
im1b = [zeros(row,col,3);im1b;zeros(row,col,3)];
im2b = imfilter( im2a,gausFilter,'replicate');
im2b = [zeros(row,col,3);im2b;zeros(row,col,3)];
im3b = imfilter( im3a,gausFilter,'replicate');
im3b = [zeros(row,col,3);im3b;  zeros(row,col,3)];
disp('图像滤波初始化处理完成...');
toc


% I12 = [2622.150000	2920.690000	3080.400000	2796.790000	2926.660000	2770.500000	2102.700000	2275.850000	2522.140000	2234.050000	2538.420000	2238.530000	2886.353659	3135.631707	3252.060976	732.661000	719.227000	460.993000	947.607000	1193.900000	1322.500000	843.120000	907.305000	944.622000	1222.260000	1287.180000	1561.100000	2114.885366	2004.426829	2004.426829	528.083000	845.976000	1119.020000	739.876000	833.915000	682.500000	35.329300	199.524000	427.905000	135.339000	417.456000	124.890000	386.299726	696.000000	794.000000	672.291000	682.739000	453.529000	884.915000	1111.800000	1230.500000	740.124000	816.251000	865.510000	1116.280000	1190.910000	1314.810000	1948.340878	1847.000000	1846.000000	];
 % I32 = [ 1075.729268	872.724390	956.314634	1190.665854	993.631707	623.446341	317.446341	593.751029	204.220165	421.934146	180.340878	280.129268	574.187805	742.860976	859.290244	681.805898	935.523320	774.456098	1059.558537	1105.831707	1173.002439	1373.021951	744.602439	895.363415	1039.435528	1125.997942	1235.695122	1506.574074	1661.109756	1446.163415	1211.812195	1311.821951	2028.933471	2049.827846	2811.719512	2638.414952	2813.032236	3093.613855	2877.397561	2350.480488	2035.524390	2341.416324	1941.438272	2178.821951	1950.393004	2072.841463	2354.958537	2505.719512	2646.031707	2923.670732	3163.992683	444.573171	808.104938	864.818244	933.471193	1180.465854	453.529268	650.563415	799.150206	918.546639	1032.690244	1340.911523	1510.348780	1267.041463	992.387805	1107.324390	1919.343902	1950.690244	];

%%
%读取配置点并转换图像并存储
I12 = [
	2999.00		2119.25		2403.25		2776.25 ...
	758.00		879.75		1520.25		1160.25 ...
	915.50		48.25		276.75		705.75 ...
	720.00		776.75		1403.75		1076.75	];
I32 = [
	1272.250	959.750		969.750		750.250	...
	1045.750	1450.750	1033.750	1280.250 ...
	3180.250	2843.750	2817.750	2519.250 ...
	774.750		1270.750	776.250		1073.250 ];
	
tic
I12 = reshape(I12,[],4);
I1 = [ I12(:,1) 	I12(:,2)+row];
I2 = [ I12(:,3)+col I12(:,4)+row];
tform12 = fitgeotrans(I1,I2,'Affine');
im1Change = imwarp(im1b,tform12,'OutputView',imref2d(size(imfinal)));
disp('图像I1仿射变换完成...');
toc

tic
I32 = reshape(I32,[],4);
I3 = [ I32(:,1)		I32(:,2)+row];
I2 = [ I32(:,3)+col I32(:,4)+row];
tform32 = fitgeotrans(I3,I2,'Affine');
im3Change = imwarp(im3b,tform32,'OutputView',imref2d(size(imfinal)));
disp('图像I3仿射变换完成...');
toc

%%
%合并图像——其中重合部分取加权平均,分为RGB三色分别计算
tic
im1cgray = rgb2gray(im1Change);
im2cgray = rgb2gray(im3Change);
%寻找I1、I2两张图重合部分的坐标
[rc12r,rc12c,v] = find(im1cgray(:,col+1:col*2)~=0);
rc12c = rc12c + col;
dis12max = max(rc12c)-col;
%寻找I3、I2两张图重合部分的坐标
[rc32r,rc32c,v] = find(im2cgray(:,col+1:col*2)~=0);
rc32c = rc32c + col;
dis32max = 2*col - min(rc32c);
%进行基本的拼接
imfinal(:,1:col,:)= im1Change(:,1:col,:);
imfinal(:,col+1:2*col,:) = im2b;
imfinal(:,2*col+1:3*col,:) = im3Change(:,2*col+1:3*col,:);
disp('图像的基本拼接完成');
toc
%进行边缘的处理——加权平均
tic
for i = 1:o
	for j = 1:size(rc12r,1)
		imfinal(rc12r(j),rc12c(j),i) = ( double(imfinal(rc12r(j),rc12c(j),i))*(rc12c(j)-col) + double ( im1Change(rc12r(j),rc12c(j),i) ) * (dis12max+col-rc12c(j)) ) /dis12max;
	end
	for j = 1:size(rc32r,1)
		imfinal(rc32r(j),rc32c(j),i) = ( double(imfinal(rc32r(j),rc32c(j),i))*(2*col-rc32c(j)) + double ( im3Change(rc32r(j),rc32c(j),i) ) * (dis32max-2*col+rc32c(j)) ) /dis32max;
	end
end
disp('图像的边缘加权处理完成');
toc
%%
%找到最终图片的实际大小——去除边缘全为0的部分
imfinalgray = rgb2gray(imfinal);

rowmin = max( find( max(imfinalgray(1:row,:),[],2) == 0) );
rowmax = min( find( max(imfinalgray(row*2+1:3*row,:),[],2) == 0) )+2*row;
colmin = max( find( max(imfinalgray(:,1:col),[],1) == 0) );
colmax = min( find( max(imfinalgray(:,col*2+1:3*col),[],1) == 0) )+2*col;

imfinall = imfinal(rowmin:rowmax,colmin:colmax,:);
%最终滤波——中值滤波和高斯滤波
tic
for i = 1:o
	imfinall(:,:,i) = medfilt2(imfinall(:,:,i),[3,3]);
	imfinall(:,:,i) = medfilt2(imfinall(:,:,i),[3,3]);
end
imfinall = imfilter( imfinall,gausFilter,'replicate');
disp('图像最终滤波完成');
toc

figure, imshow( imfinall,'InitialMagnification','fit');
