%%
%����ҵ2��ͼƬȥ�������
%2016-11-17������2016-11-24����༭
% ���Ĵ��벿����Ϊ�˽��и��ֲ���ѡ����ʹ�õĵ�������
% ����ʾͼƬ�������Ϣ��ֱ��ͼͳ����Ϣ��
% ��������Ҫ���ú���JTongTai����Ϊ̬ͬ�˲�����,�����������£�

% function [ output ] = JTongTai( inputIm,H )
% %��inputIm��̬ͬ�˲���Ƶ����̬ͬ�˲�ϵ������ΪH
% %   output�������ͼ��
% %   inputIm��������ͼ��
% %   H����ʹ�õ�ϵ������

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

%%�����Ƶ��������Ƶ������H
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

%��ͼ�������ֵ�任Ϊ0-1ͼ�񣻸��������ߵ��������ȥ����Χ
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
%����ÿ��Ϊ0����ֵ��ȷ�������������򡪡��������򶼷�ֵΪ1������Ϊ��Ĥ
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
figure,imshow(result),title('�����');
saveas(gcf,[fs(1:length(fs)-4) '_���.png'])
figure,
subplot(221),imshow(Id),title('ԭͼ');
subplot(222),imshow(result),title('�����');
subplot(223),imshow(Id-result1),title('����֮��');
saveas(gcf,[fs(1:length(fs)-4) '_�ԱȽ��.png'])


% figure, subplot(121),imshow(resultIm);title('HSV��Sͨ���˲�')
% subplot(122),imshow(I),title('ԭͼ');
% figure,imshow(Id-resultIm),title('�˳���ͼ�񲿷�');

%%��ʾͼƬ�ĸ�����������Ϣ
% figure,
% subplot(221),imshow(I),title('ԭͼ');
% subplot(222),imshow(IRed,[]),title('��ɫ����');
% subplot(223),imshow(IGreen,[]),title('��ɫ����');
% subplot(224),imshow(IBlue,[]),title('��ɫ����');
% figure,
% subplot(221),imshow(IH),title('H����-ɫ��');
% subplot(222),imshow(IS,[]),title('S����-���Ͷ�');
% subplot(223),imshow(IV,[]),title('V����-ǿ��');
% subplot(224),imshow(Ilight,[]),title('I����-��ɫƽ��');

% %%��ʾ���벿�ֵ�ͼ������ȷ��ȥ�������ķ�������ѡ��ʹ��Bͨ����ȡ128��Ϊ��ֵ(����ͼ�ν��)
% Irr = IRed(:,floor(col/2));
% Irb = IBlue(:,floor(col/2));
% Irg = IGreen(:,floor(col/2));
% Irh = IH(:,floor(col/2));
% Irs = IS(:,floor(col/2));
% Irv = IV(:,floor(col/2));
% Ir = 1:row;
% figure,
% subplot(321),plot(Ir,Irr,'r'),title('ͼ���������R');
% subplot(323),plot(Ir,Irg,'g'),title('ͼ���������G');
% subplot(325),plot(Ir,Irb,'b'),title('ͼ���������B');
% subplot(322),plot(Ir,Irh,'r'),title('ͼ���������H');
% subplot(324),plot(Ir,Irs,'g'),title('ͼ���������S');
% subplot(326),plot(Ir,Irv,'b'),title('ͼ���������V');

% Icr = IRed(floor(row/2),:);
% Icb = IBlue(floor(row/2),:);
% Icg = IGreen(floor(row/2),:);
% Ich = IH(floor(row/2),:);
% Ics = IS(floor(row/2),:);
% Icv = IV(floor(row/2),:);
% Ic = 1:col;
% figure,
% subplot(321),plot(Ic,Icr,'r'),title('ͼ����������R');
% subplot(323),plot(Ic,Icg,'g'),title('ͼ����������G');
% subplot(325),plot(Ic,Icb,'b'),title('ͼ����������B');
% subplot(322),plot(Ic,Ich,'r'),title('ͼ����������H');
% subplot(324),plot(Ic,Ics,'g'),title('ͼ����������S');
% subplot(326),plot(Ic,Icv,'b'),title('ͼ����������V');




%%����RGB��ƽ��ֵ����I���д���
% IlightLv = JTongTai(Ilight,h);
% figure,
% subplot(121),imshow(IlightLv,[]),title('Light�仯');
% subplot(122),imshow( Ilight-IlightLv,[] ),title('�Ա�');

% Inew1 = I;
% Inew1(:,:,1) = IRed .* ( IlightLv ./ Ilight );
% Inew1(:,:,2) = IGreen .* ( IlightLv ./ Ilight );
% Inew1(:,:,3) = IBlue .* ( IlightLv ./ Ilight );
% figure,
% subplot(121),imshow(Inew1),title('ʹ��ƽ�������˲�');
% subplot(122),imshow(I-Inew1),title('�˳��Ĳ���');

%���и�Ƶ��ǿ������Ե�񻯡�ʹ��Laplace����
% H = [0 1 0; 1 -4 1; 0 1 0];
% rg = rgb2gray(result);
% J = conv2(double(rg),H,'same');
% K = double(rg)-J;
% figure,imshow(K,[]),title('Laplace��Ƶ��ǿ');