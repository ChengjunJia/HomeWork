clear;
close all;
clc;

%% A1:ʵ���ݶ��½�������ͨ�����κ�������
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

%% TODO: ʵ��costFunctionA2.m, costFunctionB4.m

%% demo:Signal���ݼ�ʵ�顣�㲻��Ҫʹ��������ݼ�����ʵ�顣
% ��ȡ���ݺͱ�ǩ,ȡǰ80%Ϊѵ��������20%Ϊ���Լ�
    signal = load('../data/Signal/signal.mat');
    m_total = size(signal.X, 1);%�������ĸ���
    n = size(signal.X,2);%����ά��
    m_train = floor( m_total*0.8 );%ѵ����������
    X_train = signal.X(1:m_train, :);%ȡǰ80%��ѵ������
    y_train = signal.y(1:m_train, :);%ѵ����ǩ
    X_test = signal.X(m_train+1:end, :);%ȡ��20%����������
    y_test = signal.y(m_train+1:end, :);%���Ա�ǩ

    %�趨����
    initial_theta = zeros(n + 1,1);
    max_iter = 100000;
    alpha = 0.001;
    lambda = 1;

    % ѵ��demoģ��
    [optimal_theta, J_history] = myfminuncA1 ( @(theta)lrCostFunction(theta,X_train,y_train,lambda), initial_theta, alpha, max_iter);
    figure,plot(J_history),title('A2 J\_history');

    % ����ѵ��������
    y_train_hat = lrHypothesis(X_train, optimal_theta) >= 0.5;
    train_error_rate = mean(y_train_hat ~= y_train);
    fprintf('demo:train_error_rate=%f\n',train_error_rate);
    % ������Դ�����
    y_test_hat = lrHypothesis(X_test, optimal_theta) >= 0.5;
    test_error_rate = mean(y_test_hat ~= y_test);
    fprintf('demo:test_error_rate=%f\n',test_error_rate);
    %��ѵ�����W1,b1,W2,b2��alpha��lambda��s2�Ȳ������̵�output�£��ڱ�����д�������ļ��ĺ��塣
    mkdir('../output/demo/');
    save('../output/demo/theta.mat','optimal_theta');
    save('../output/demo/param.mat','initial_theta','max_iter','alpha','lambda');%demoû��s2����


%% TODO:A3ʵ��
%% TODO:B2ʵ��
%% TODO:B3ʵ��
%% TODO:B1�Ƚϲ�ͬ��s2,alpha,lambda�Ȳ�����ʵ���Ӱ��


%% TODO:ʵ��C1������MNIST���ݼ��Ͻ���ʵ��
