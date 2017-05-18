clear;
close all;
clc;

%% A1:实现梯度下降法，并通过二次函数测试
initial_theta = [1; 2];
max_iter = 120;
X = [3, 4];
y = 0;
alpha = 0.01;
[optimal_theta, J_history] = myfminuncA1 ( @(theta)defaultCostFunction(theta,X,y), initial_theta, alpha, max_iter);
fprintf('A1: optimal_theta=[%f,%f]\n',optimal_theta);
figure;
plot(J_history);
title('A1 J\_history');

%% TODO: 实现costFunctionA2.m, costFunctionB4.m

%% demo:Signal数据集实验。你不需要使用这个数据集进行实验。
% 读取数据和标签,取前80%为训练集，后20%为测试集
    signal = load('../data/Signal/signal.mat');
    m_total = size(signal.X, 1);%总样本的个数
    n = size(signal.X,2);%样本维度
    m_train = floor( m_total*0.8 );%训练样本个数
    X_train = signal.X(1:m_train, :);%取前80%做训练数据
    y_train = signal.y(1:m_train, :);%训练标签
    X_test = signal.X(m_train+1:end, :);%取后20%做测试数据
    y_test = signal.y(m_train+1:end, :);%测试标签

    %设定参数
    initial_theta = zeros(n + 1,1);
    max_iter = 100000;
    alpha = 0.001;
    lambda = 1;

    % 训练demo模型
    [optimal_theta, J_history] = myfminuncA1 ( @(theta)lrCostFunction(theta,X_train,y_train,lambda), initial_theta, alpha, max_iter);
    figure,plot(J_history),title('A2 J\_history');

    % 计算训练错误率
    y_train_hat = lrHypothesis(X_train, optimal_theta) >= 0.5;
    train_error_rate = mean(y_train_hat ~= y_train);
    fprintf('demo:train_error_rate=%f\n',train_error_rate);
    % 计算测试错误率
    y_test_hat = lrHypothesis(X_test, optimal_theta) >= 0.5;
    test_error_rate = mean(y_test_hat ~= y_test);
    fprintf('demo:test_error_rate=%f\n',test_error_rate);
    %将训练结果W1,b1,W2,b2和alpha、lambda、s2等参数存盘到output下，在报告中写明存盘文件的含义。
    mkdir('../output/demo/');
    save('../output/demo/theta.mat','optimal_theta');
    save('../output/demo/param.mat','initial_theta','max_iter','alpha','lambda');%demo没有s2参数


%% TODO:A3实验
%% TODO:B2实验
%% TODO:B3实验
%% TODO:B1比较不同的s2,alpha,lambda等参数对实验的影响


%% TODO:实现C1任务，在MNIST数据集上进行实验
