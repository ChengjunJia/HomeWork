%% TODO:B4ʵ��
%% Read the data of mnist
signal = load('../data/MNIST/mnist.mat');
m_total = size(signal.X, 1);%�������ĸ���
n = size(signal.X,2);%����ά��
m_train = floor( m_total*0.8 );%ѵ����������
loc = randperm(m_total);
trainloc = loc(1:m_train);
testloc = loc(m_train+1:end);
X = signal.X;
Y = signal.y>5;
X_train = X(trainloc, :);%ȡǰ80%��ѵ������
y_train = Y(trainloc, :);%ѵ����ǩ
X_test = X(testloc, :);%ȡ��20%����������
y_test = Y(testloc, :);%���Ա�ǩ

%% �趨����
Hiddensize = 50;
initial_theta = normrnd( 0,0.01, n*Hiddensize+Hiddensize*2+1,1);
max_iter = 15000;
alpha = 0.01;
lambda = 1;
%% Train
tic
[optimal_theta, J_history] = myfminuncA1 ( @(theta)costFunctionB4(theta,X_train,y_train,lambda), initial_theta, alpha, max_iter);
toc
figure,plot(J_history),title('B4 J\_history');

%% ����ѵ��������
y_train_hat = hypothesisB4(X_train, optimal_theta) >= 0.5;
train_error_rate = mean(y_train_hat ~= y_train);
fprintf('B4:train_error_rate=%f\n',train_error_rate);
% ������Դ�����
y_test_hat = hypothesisB4(X_test, optimal_theta) >= 0.5;
test_error_rate = mean(y_test_hat ~= y_test);
fprintf('B4:test_error_rate=%f\n',test_error_rate);
%��ѵ�����W1,b1,W2,b2��alpha��lambda��s2�Ȳ������̵�output�£��ڱ�����д�������ļ��ĺ��塣
mkdir('../output/B4/');
save('../output/B4/theta.mat','optimal_theta');
save('../output/B4/param.mat','initial_theta','max_iter','alpha','lambda');%demoû��s2����

%% Test costFunction
signal = load('../data/Signal/signal.mat');
m_total = size(signal.X, 1);%�������ĸ���
n = size(signal.X,2);%����ά��
m_train = floor( m_total*0.8 );%ѵ����������
X_train = signal.X(1:m_train, :);%ȡǰ80%��ѵ������
y_train = signal.y(1:m_train, :);%ѵ����ǩ
X_test = signal.X(m_train+1:end, :);%ȡ��20%����������
y_test = signal.y(m_train+1:end, :);%���Ա�ǩ
[~,gradJ] = costFunctionB4(initial_theta,X_train,y_train,lambda);
numgradJ = computeNumericalGradient(@(theta)costFunctionB4(theta,X_train,y_train,lambda),initial_theta,1e-5);
disp(norm(numgradJ-gradJ)/norm(numgradJ+gradJ));