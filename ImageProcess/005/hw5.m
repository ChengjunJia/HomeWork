%
%%С��ҵ5��ȥ����
%%�������ڣ�2016-11-27
%%
I = imread('����.jpg');
Id = double(I)/255;
IRed = double( I(:,:,1) )/255 ;
IGreen = double( I(:,:,2) )/255 ;
IBlue = double( I(:,:,3) )/255 ;

hsv= rgb2hsv(Id);
IH = hsv(:,:,1);
IS = hsv(:,:,2);
IV = hsv(:,:,3);

% figure,
% subplot(221),imshow(I),title('ԭͼ');
% subplot(222),imshow(IRed,[]),title('��ɫ����');
% subplot(223),imshow(IGreen,[]),title('��ɫ����');
% subplot(224),imshow(IBlue,[]),title('��ɫ����');
% figure,
% subplot(221),imshow(IH),title('H����-ɫ��');
% subplot(222),imshow(IS,[]),title('S����-���Ͷ�');
% subplot(223),imshow(IV,[]),title('V����-ǿ��');

%T = ginput(2);
% ͨ���ֶ�ѡ�㣬ѡ���۾����ڵĴ���λ��
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

% ȷ�����۵�����λ�ò����д�����S��ȡ0
row = size(IH,1); col=size(IH,2);
ns = IS;
Judge = ( IH(loc)<0.25 | IH(loc)>0.75 ) & (IS(loc) >0.3 );
ns(loc) = ns(loc) .* (~Judge);
nv = IV;
nv(loc) = (IRed(loc)+IGreen(loc)+IBlue(loc))/3;

%���任��ԭͼ�񣬲���ʾ��������ԭͼ��֮��
nhsv = hsv;
nhsv(:,:,2) = ns;
In = hsv2rgb(nhsv);
figure,imshow(In),title('ȥ���۽��');
Icha = ( In - hsv2rgb(hsv) )*1e15*255;
figure,imshow(Icha),title('�����ԭͼ֮��');

nhsv(:,:,3) = nv;
In2 = hsv2rgb(nhsv);
figure,imshow(In2),title('ȥ���۽��');
Icha = ( In2 - hsv2rgb(hsv) )*1e15*255;
figure,imshow(Icha),title('�����ԭͼ֮��');