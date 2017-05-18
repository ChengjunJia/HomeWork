%% Read the data of mnist
signal = load('../../data/MNIST/mnist.mat');
m_total = size(signal.X, 1);%总样本的个数
m_train = floor( m_total*0.8 );%训练样本个数
loc = randperm(m_total);
trainloc = loc(1:m_train);
testloc = loc(m_train+1:end);
X = signal.X;
X = X./max(X(:));
Y = signal.y>5;
X = reshape(X',20,20,5000);
Y = Y';
X_train = X(:,:,trainloc);%取前80%做训练数据
y_train = Y(trainloc);%训练标签
X_test = X(:,:,testloc);%取后20%做测试数据
y_test = Y(testloc);%测试标签

alpha = 0.1;
lambda = 0.01;
max_iter = 15000;
%% Train
net = cnnsetup([3 3 3 3],X);
[y,net_n] = cnnff(X,net);
cnnbf(X,net_n,Y,y);
tic
toc
% figure,plot(J_history),title('C1 J\_history');
%%
% 计算训练错误率
y_train_hat = hypothesisC1(X_train, optimal_theta,L,Sig) >= 0.5;
train_error_rate = mean(y_train_hat ~= y_train);
fprintf('C1:train_error_rate=%f\n',train_error_rate);
% 计算测试错误率
y_test_hat = hypothesisC1(X_test, optimal_theta,L,Sig) >= 0.5;
test_error_rate = mean(y_test_hat ~= y_test);
fprintf('C1:test_error_rate=%f\n',test_error_rate);
%将训练结果W1,b1,W2,b2和alpha、lambda、s2等参数存盘到output下，在报告中写明存盘文件的含义。
mkdir('../output/C1/');
save('../output/C1/theta.mat','optimal_theta');
save('../output/C1/param.mat','initial_theta','max_iter','alpha','lambda');
%%
signal = load('../data/Signal/signal.mat');
m_total = size(signal.X, 1);%总样本的个数
n = size(signal.X,2);%样本维度
m_train = floor( m_total*0.8 );%训练样本个数
X_train = signal.X(1:m_train, :);%取前80%做训练数据
y_train = signal.y(1:m_train, :);%训练标签
X_test = signal.X(m_train+1:end, :);%取后20%做测试数据
y_test = signal.y(m_train+1:end, :);%测试标签

L = [50 5 1];
Sig = [1 0 1];
alpha = 0.01;
lambda = 1;
initial_theta = Rand_Init(X_train,L);
max_iter = 15000;

[~,gradJ] = costFunctionC1(initial_theta,X_train,y_train,lambda,L,Sig);
numgradJ = computeNumericalGradient(@(theta)costFunctionC1(theta,X_train,y_train,lambda,L,Sig),initial_theta,1e-5);
disp(norm(numgradJ-gradJ)/norm(numgradJ+gradJ));