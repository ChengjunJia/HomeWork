%ָ����������
theta1 = 3.5; theta0 = 6; sigma0 = 2; num = 100;
%����ѵ������
x = (randn(1,num))'; sigma = (randn(1,num)*sigma0)';
y = x*theta1+theta0+sigma;
%���Իع�
y0 = y;
x0 = [x ones(num,1)];
theta = regress(y0,x0);
t11 = theta(1);t10 = theta(2);
%һԪ���λع�
x0 = [x .^2 x0];
theta = regress(y0,x0);
t22 = theta(1); t21 = theta(2); t20 = theta(3);
%һԪ���λع�
x0 = [x .^3 x0];
theta = regress(y0,x0);
t33 = theta(1); t32 = theta(2); t31 = theta(3); t30 = theta(4);
%��ʾѵ����Ĳ���
disp('����[�Ӹߴε���]��'),
disp([t11 t10]),disp([t22 t21 t20]),disp([t33 t32 t31 t30])
%��ʾѵ�����
xin = x;
yin = y;
yout1 = t11*xin+t10;
yout2 = t22* xin .^2+t21*xin+t20;
yout3 = t33*xin .^3+t32*xin .^2+t31*xin+t30;
disp('ѵ��R^2'),
ybar = mean(yin); yall = sum( (ybar-yin) .^2);
disp(sum((ybar-yout1) .^2)/yall),
disp(sum((ybar-yout2) .^2)/yall),
disp(sum((ybar-yout3) .^2)/yall)
%��ʾѵ��ͼ��
figure,scatter(xin,yin),hold on,
xshow = min(x):0.01:max(x);
xin = xshow;
yout1 = t11*xin+t10;
yout2 = t22* xin .^2+t21*xin+t20;
yout3 = t33*xin .^3+t32*xin .^2+t31*xin+t30;
plot(xin,yout1),plot(xin,yout2),plot(xin,yout3),
title('ѵ��'),legend('ѵ������','һ�����','�������','�������','Location','southeast'),grid on;
%���ɲ�������
testx = randn(100,1);
testsigma = randn(100,1)*sigma0;
testy = testx*theta1+theta0+testsigma;
%�Ƚ�Ԥ������ʵ�ʽ��
xin = testx;
yin = testy;
yout1 = t11*xin+t10;
yout2 = t22* xin .^2+t21*xin+t20;
yout3 = t33*xin .^3+t32*xin .^2+t31*xin+t30;
disp('ʵ��R^2'),
ybar = mean(yin); yall = sum( (ybar-yin) .^2);
disp(sum((ybar-yout1) .^2)/yall),
disp(sum((ybar-yout2) .^2)/yall),
disp(sum((ybar-yout3) .^2)/yall)

figure,scatter(xin,yin),hold on,
xshow = min(testx):0.01:max(testx);
xin = xshow;
yout1 = t11*xin+t10;
yout2 = t22* xin .^2+t21*xin+t20;
yout3 = t33*xin .^3+t32*xin .^2+t31*xin+t30;
plot(xin,yout1),plot(xin,yout2),plot(xin,yout3),
title('����'),legend('��������','һ�����','�������','�������','Location','southeast'),grid on;