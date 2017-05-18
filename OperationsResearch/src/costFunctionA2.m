function [J,grad] = costFunctionA2(theta, X, y, s2, lambda)
        
    %% 把待优化的参数向量theta解释为三层神经网络中的W1,b1,W2,b2
    [m,n] = size(X);
    W1 = reshape(theta(1:n*s2), n, s2);
    b1 = reshape(theta(n*s2+1:(n+1)*s2), 1, s2);
    W2 = reshape(theta((n+1)*s2+1:(n+1)*s2+s2), 1, s2);
    b2 = reshape(theta((n+1)*s2+s2:(n+1)*s2+s2+1), 1, 1);    
    %% 计算当前theta下的目标函数值    
    h = hypothesisA2(X, theta); %注意，这里h返回的是一个m*1的列向量，每个元素对应一个样本
    J = mean( - y .* log(h) - (1 - y) .* log( 1 - h)) + lambda / 2 / m * (sum(sum(W1) + sum(sum(W2))));
    %% TODO: 计算当前theta下的目标函数梯度
    grad_W1 = zeros(n, s2);
    grad_b1 = zeros(1, s2);
    grad_W2 = zeros(s2, 1);
    grad_b2 = zeros(1, 1);
    



    %% 把W1,b1,W2,b2的偏导数排列成梯度列向量grad
    grad = [grad_W1(:), grad_b1(:), grad_W2(:), grad_b2(:)];    
end