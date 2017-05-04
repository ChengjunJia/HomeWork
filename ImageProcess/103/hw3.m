%%=========================
%HW3
%%=========================

I = imread('fog.jpg'); Id = im2double(I);
Ir = I(:,:,1); Ig = I(:,:,2); Ib = I(:,:,3);
Idr = Id(:,:,1); Idg = Id(:,:,2); Idb = Id(:,:,3);
Idhsv = rgb2hsv(Id);
Idh = Idhsv(:,:,1); Ids = Idhsv(:,:,2); Idv = Idhsv(:,:,3);
[row,col] = size(Ir);
%ShowRGB(Id);

%%First Way: Histeq
tic
temp = Id;
Result1 = temp;
n = 32;
for ind = 1:3
	Result1(:,:,ind) = histeq( temp(:,:,ind),n );
end
toc
figure, 
	imshow(Result1),title('Histeq');
figure,
	subplot(221),imshow(temp),title('Origin');
	subplot(222),imshow(Result1),title('Histeq');
	subplot(223),imshow(temp-Result1,[]),title('Origin-Histeq');

%%Second Way: TongTai
%构造高频提升、低频削弱的系数矩阵
tic
	d0 = 5; r1=0.5; rh=1.5; c=2;
	n1=floor((row+1)/2);n2=floor((col+1)/2);
	h = zeros( row,col );
	for m = 1:row
		for n = 1:col
			d = sqrt(( m-n1)^2+( n-n2)^2);
			h( m,n ) = (rh-r1)*(1-exp(-c*(d.^2/d0.^2)))+r1;
		end
	end
%进行同态滤波
H = h;
Result2 = Id;
for ind = 1:3
	inputIm = Id(:,:,ind);
	Ifft = fftshift( fft2( log(1 + double( inputIm ) ) ) );
    resultfft =  Ifft .* H ;
    output = exp( real( ifft2 ( ifftshift( resultfft) ) ) )-1;
	Result2(:,:,ind) = output;
end

%归一化
Result2_eq = Result2;
for ind = 1:3
	output = Result2(:,:,ind);
	output = ( output - min(output(:)) )/(max(output(:))-min(output(:)) );
	Result2_eq(:,:,ind) = output;
end
toc

%直方图均衡化
Result2_histeq = Result2;
temp = zeros(row,col);
for ind = 1:3
	output = Result2_eq(:,:,ind);
	temp = floor(output*255);
	temp = histeq(uint8(temp));
	Result2_histeq(:,:,ind) = im2double(temp) ;
end

figure,
	imshow(Result2),title('TongTai');
figure, 
	imshow(Result2_histeq),title('TongTai&&Histeq');
figure,
	subplot(221),imshow(Id),title('Origin');
	subplot(222),imshow(Result2),title('TongTai');
	subplot(223),imshow(Id-Result2,[]),title('Origin-TongTai');
figure,
	subplot(221),imshow(Id),title('Origin');
	subplot(222),imshow(Result2),title('TongTai');
	subplot(223),imshow(Result2_eq,[]),title('Im2double:0-1');
	subplot(224),imshow(Result2_histeq,[]),title('Histeq');

Result3 = Result2_histeq;
figure,imshow((Result1+Result2)/2),title('(r1+r2)/2');
figure,imshow((Result1+Result3)/2),title('(r1+r3)/2');


%%
tic
h1 = fspecial('average',[row col]);
%%大面积窗滤波
result = Id;
for ind = 1:3
	temp1 = Id(:,:,ind);
	temp2 = imfilter(temp1,h1,'replicate');
	result(:,:,ind) = temp2;
end

%%归一化
temp1 = Id - result;
for ind = 1:3
	temp = temp1(:,:,ind);
	temp = (temp-min(temp(:)))/(max(temp(:))-min(temp(:)));
	temp1(:,:,ind) = temp;
end
toc
result4 = temp1;
figure,imshow(result4),title('Large Windows');

%%Third Way: Dark Channel
tic
radius = 15;
%计算原图的暗通道
	Imin = min(min(Idr,Idg),Idb);
	Idark = ordfilt2(Imin,1,ones( radius,radius) );
%暗通道排序
JDark = reshape( Idark, row*col, 1);
JDark = sort(JDark);
numpx = floor( row*col/1000 );
Idarkloc = ( Idark >= JDark(row*col-numpx) );
Ar = max( max(Idr .* Idarkloc) );
Ag = max( max(Idg .* Idarkloc) );
Ab = max( max(Idb .* Idarkloc) );
Inr = Idr /Ar;
Ing = Idg /Ag;
Inb = Idb /Ab;
Inmin = min( min(Inr,Ing),Inb );
Indark = ordfilt2(Inmin,1,ones( radius,radius) );
omiga = 0.95;
Tx = 1-omiga*Indark;
In = Id;
In(:,:,1) = ( Inr - Ar ) ./ max(Tx,0.1)+Ar;
In(:,:,2) = ( Ing - Ag ) ./ max(Tx,0.1)+Ag;
In(:,:,3) = ( Inb - Ab ) ./ max(Tx,0.1)+Ab;

Inn = In;
toc
for ind = 1:3
	Inn(:,:,ind) = histeq(In(:,:,ind));
end
figure,imshow(Inn);

Rhsv = rgb2hsv(In);
Rhsv(:,:,1) = histeq(Rhsv(:,:,1));
result = hsv2rgb(Rhsv);
figure,imshow(result);