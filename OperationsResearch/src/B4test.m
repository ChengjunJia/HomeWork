%% TODO:B4实验
%% Read the data of mnist
signal = load('../data/MNIST/mnist.mat');
m_total = size(signal.X, 1);%总样本的个数
n = size(signal.X,2);%样本维度
m_train = floor( m_total*0.8 );%训练样本个数
loc = randperm(m_total);
trainloc = loc(1:m_train);
testloc = loc(m_train+1:end);
X = signal.X;
Y = signal.y>5;
X_train = X(trainloc, :);%取前80%做训练数据
y_train = Y(trainloc, :);%训练标签
X_test = X(testloc, :);%取后20%做测试数据
y_test = Y(testloc, :);%测试标签

%% 设定参数
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

%% 计算训练错误率
y_train_hat = hypothesisB4(X_train, optimal_theta) >= 0.5;
train_error_rate = mean(y_train_hat ~= y_train);
fprintf('B4:train_error_rate=%f\n',train_error_rate);
% 计算测试错误率
y_test_hat = hypothesisB4(X_test, optimal_theta) >= 0.5;
test_error_rate = mean(y_test_hat ~= y_test);
fprintf('B4:test_error_rate=%f\n',test_error_rate);
%将训练结果W1,b1,W2,b2和alpha、lambda、s2等参数存盘到output下，在报告中写明存盘文件的含义。
mkdir('../output/B4/');
save('../output/B4/theta.mat','optimal_theta');
save('../output/B4/param.mat','initial_theta','max_iter','alpha','lambda');%demo没有s2参数

%% Test costFunction
signal = load('../data/Signal/signal.mat');
m_total = size(signal.X, 1);%总样本的个数
n = size(signal.X,2);%样本维度
m_train = floor( m_total*0.8 );%训练样本个数
X_train = signal.X(1:m_train, :);%取前80%做训练数据
y_train = signal.y(1:m_train, :);%训练标签
X_test = signal.X(m_train+1:end, :);%取后20%做测试数据
y_test = signal.y(m_train+1:end, :);%测试标签
[~,gradJ] = costFunctionB4(initial_theta,X_train,y_train,lambda);
numgradJ = computeNumericalGradient(@(theta)costFunctionB4(theta,X_train,y_train,lambda),initial_theta,1e-5);
disp(norm(numgradJ-gradJ)/norm(numgradJ+gradJ));