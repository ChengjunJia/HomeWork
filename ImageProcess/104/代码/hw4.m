% 贾成君 2017-1-13
    file1 = '0.jpg'; file2 = '1.jpg';
    file3 = '2.jpg'; file4 = '3.jpg';
    file5 = '4.jpg'; file6 = '5.jpg';

    I1 = imread(file1); I2 = imread(file2);
    I3 = imread(file3); I4 = imread(file4);
    I5 = imread(file5); I6 = imread(file6);

%%取出通道
	ColInd = 1;
	im1 = I1(:,:,ColInd); im2 = I2(:,:,ColInd);
	im3 = I3(:,:,ColInd); im4 = I4(:,:,ColInd);
	im5 = I5(:,:,ColInd); im6 = I6(:,:,ColInd);
	Imtotal = [ im1(:) im2(:) im3(:) im4(:) im5(:) im6(:) ];
	
%%按空间均匀取点，取点个数：AimPNum；取点的坐标：ChoicePixel
	PixelNum = size(I1,1)*size(I1,2);
	AimPNum = 100;
	ChoicePixel = uint32(zeros(AimPNum,1));
	AimNum = AimPNum;
	Length = PixelNum/AimNum;
	k = 1;
	ChoicePixel(k) = Length/2;
	for k = 2:AimNum
		ChoicePixel(k) = ChoicePixel(k-1)+Length;
	end

%   Show the Choosed Point
	% figure, imshow(I1(:,:,1)), hold on, axis on,
	% plot(mod(ChoicePixel,size(I1,2)),ChoicePixel/size(I1,2),'*'), title('Show the Choosed Point');

%%根据目标DestPixel，确定曝光度之比
	DestPixel = 128;
	proportion = zeros(5,1);
	for m = 1:5
		imaim = Imtotal(:,m);
		imdest = Imtotal(:,m+1);
		Loc = find(imaim == DestPixel);
		DestByaim = sum(imdest(Loc))/(DestPixel*size(Loc,1));
		proportion(m) = DestByaim;
	end
	%proportion = double(ones(5,1))*1.5;
	Light = zeros(6,1);
	Light(1) = 2*mean(Imtotal(:,1));
	for m = 1:5
		Light(m+1) = Light(m)*proportion(m);
	end
	Tlog = log(Light);

% Using 100 pixel to solve the film response function

	Z = zeros(AimPNum,6);
	Z = Imtotal(ChoicePixel,:);
	
	%权值w、参数lamdba
	w = 1:256;
	w = min(w,257-w);
	lamdba = 30;
tic;
	[g, IE] = gsolve(Z,Tlog,lamdba,w);
Tgsolve = toc;
	% figure,axis on;
	% plot(g,'*'),title('Response Curve');
tic;
	InE = zeros(size(Imtotal,1),1);
	for m = 1:size(Imtotal,1)
		sumw = 0;
		sumE = 0;
		for n = 1:6
			Z = Imtotal(m,n)+1;
			sumE = sumE + w(Z)*( g(Z)-Tlog(n) );
			sumw = sumw + w(Z);
		end
		InE(m,1) = sumE/sumw;
	end
TE = toc;
	E = exp(InE);
	% figure,imshow(reshape(E,size(im1)),[]),title('HDR');
	% figure,imshow(reshape(InE,size(im1)),[]),title('Log-HDR');