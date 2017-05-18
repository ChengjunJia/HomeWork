%% Read the data of mnist
clc,clear
signal = load('../../data/MNIST/mnist.mat');
m_total = size(signal.X, 1);%�������ĸ���
m_train = floor( m_total*0.8 );%ѵ����������
loc = randperm(m_total);
trainloc = loc(1:m_train);
testloc = loc(m_train+1:end);
X = signal.X./max(signal.X(:));
Y = signal.y>5;
X_train = X(trainloc, :);%ȡǰ80%��ѵ������
y_train = Y(trainloc, :);%ѵ����ǩ
X_test = X(testloc, :);%ȡ��20%����������
y_test = Y(testloc, :);%���Ա�ǩ

net.L = [400 380 5 1];
net.Sig = [1 0 1 1];
net.Conv = [0 21 0 0];
alpha = 0.1;
net.lambda = 0;
initial_theta = RandInit(X,net.L,net.Conv);
max_iter = 7000;
% [J,grad]  =costFunctionC1(initial_theta,X_train,y_train,net.lambda,net.L,net.Sig,net.Conv);

%% Train
% tic
% [optimal_theta, J_history] = calBest(X_train,y_train,initial_theta,net);
% toc
% figure,plot(J_history),title('C1 J\_history');
tic
[optimal_theta, J_history] = myfminuncA1 ( @(theta)costFunctionC1(theta,X_train,y_train,net.lambda,net.L,net.Sig,net.Conv), initial_theta, alpha, max_iter);
toc
figure,plot(J_history),title('C1 J\_history');

%%
% ����ѵ��������
y_train_hat = hypothesisC1(X_train, optimal_theta,net.L,net.Sig,net.Conv) >= 0.5;
train_error_rate = mean(y_train_hat ~= y_train);
fprintf('C1:train_error_rate=%f\n',train_error_rate);
% ������Դ�����
y_test_hat = hypothesisC1(X_test, optimal_theta,net.L,net.Sig,net.Conv) >= 0.5;
test_error_rate = mean(y_test_hat ~= y_test);
fprintf('C1:test_error_rate=%f\n',test_error_rate);
%��ѵ�����W1,b1,W2,b2��alpha��lambda��s2�Ȳ������̵�output�£��ڱ�����д�������ļ��ĺ��塣
mkdir('../output/C1/');
save('../output/C1/theta.mat','optimal_theta');
save('../output/C1/param.mat','initial_theta','max_iter','alpha','lambda');
%%
clc,clear
signal = load('../../data/Signal/signal.mat');
m_total = size(signal.X, 1);%�������ĸ���
n = size(signal.X,2);%����ά��
m_train = floor( m_total*0.8 );%ѵ����������
X_train = signal.X(1:m_train, :);%ȡǰ80%��ѵ������
y_train = signal.y(1:m_train, :);%ѵ����ǩ
X_test = signal.X(m_train+1:end, :);%ȡ��20%����������
y_test = signal.y(m_train+1:end, :);%���Ա�ǩ
%% 
L = [20 20 5 1];
Sig = [1 1 0 1];
Conv = [0 0 0 0];
alpha = 0.01;
lambda = 0;
initial_theta = RandInit(X_train,L,Conv);
max_iter = 1500;
Ny = hypothesisC1(X_test, initial_theta,L,Sig,Conv);
[NJ,NgradJ,Nnet] = costFunctionC1(initial_theta,X_train,y_train,lambda,L,Sig,Conv);
NnumgradJ = computeNumericalGradient(@(theta)costFunctionC1(theta,X_train,y_train,lambda,L,Sig,Conv),initial_theta,1e-2);
disp(norm(NnumgradJ-NgradJ)/norm(NnumgradJ+NgradJ));
err = abs((NnumgradJ-NgradJ)./NnumgradJ);
[nerr,loc] = sort(err,'descend');
[loc(1:10) nerr(1:10)]
disp(nerr(1)<1e-2);