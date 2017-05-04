%
%%小作业5：去红眼
%%创建日期：2016-11-27
%%
I = imread('红眼.jpg');
Id = double(I)/255;
IRed = double( I(:,:,1) )/255 ;
IGreen = double( I(:,:,2) )/255 ;
IBlue = double( I(:,:,3) )/255 ;

hsv= rgb2hsv(Id);
IH = hsv(:,:,1);
IS = hsv(:,:,2);
IV = hsv(:,:,3);

% figure,
% subplot(221),imshow(I),title('原图');
% subplot(222),imshow(IRed,[]),title('红色分量');
% subplot(223),imshow(IGreen,[]),title('绿色分量');
% subplot(224),imshow(IBlue,[]),title('蓝色分量');
% figure,
% subplot(221),imshow(IH),title('H分量-色调');
% subplot(222),imshow(IS,[]),title('S分量-饱和度');
% subplot(223),imshow(IV,[]),title('V分量-强度');

%T = ginput(2);
% 通过手动选点，选择眼睛所在的大致位置
T = [170.5,325.25;571,443.75];
rmin = uint16( T(1,2) );
cmin = uint16( T(1,1) );
rmax = uint16( T(2,2) );
cmax = uint16( T(2,1) );
loc2 = ones( (cmax-cmin)*(rmax-rmin),2 );
ctotal = cmax-cmin+1;
for m = rmin:rmax
	for n = cmin:cmax
		loc2( (m-rmin)*ctotal+n-cmin+1,1 )=m;
		loc2( (m-rmin)*ctotal+n-cmin+1,2 )=n;
	end
end
loc = sub2ind(size(IH),loc2(:,1),loc2(:,2));

% 确定红眼的像素位置并进行处理——S域取0
row = size(IH,1); col=size(IH,2);
ns = IS;
Judge = ( IH(loc)<0.25 | IH(loc)>0.75 ) & (IS(loc) >0.3 );
ns(loc) = ns(loc) .* (~Judge);
nv = IV;
nv(loc) = (IRed(loc)+IGreen(loc)+IBlue(loc))/3;

%反变换会原图像，并显示处理结果与原图像之差
nhsv = hsv;
nhsv(:,:,2) = ns;
In = hsv2rgb(nhsv);
figure,imshow(In),title('去红眼结果');
Icha = ( In - hsv2rgb(hsv) )*1e15*255;
figure,imshow(Icha),title('结果与原图之差');

nhsv(:,:,3) = nv;
In2 = hsv2rgb(nhsv);
figure,imshow(In2),title('去红眼结果');
Icha = ( In2 - hsv2rgb(hsv) )*1e15*255;
figure,imshow(Icha),title('结果与原图之差');