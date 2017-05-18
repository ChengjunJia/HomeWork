function [J,grad] = costFunctionA2(theta, X, y, s2, lambda)
        
    %% �Ѵ��Ż��Ĳ�������theta����Ϊ�����������е�W1,b1,W2,b2
    [m,n] = size(X);
    W1 = reshape(theta(1:n*s2), n, s2);
    b1 = reshape(theta(n*s2+1:(n+1)*s2), 1, s2);
    W2 = reshape(theta((n+1)*s2+1:(n+1)*s2+s2), 1, s2);
    b2 = reshape(theta((n+1)*s2+s2:(n+1)*s2+s2+1), 1, 1);    
    %% ���㵱ǰtheta�µ�Ŀ�꺯��ֵ    
    h = hypothesisA2(X, theta); %ע�⣬����h���ص���һ��m*1����������ÿ��Ԫ�ض�Ӧһ������
    J = mean( - y .* log(h) - (1 - y) .* log( 1 - h)) + lambda / 2 / m * (sum(sum(W1) + sum(sum(W2))));
    %% TODO: ���㵱ǰtheta�µ�Ŀ�꺯���ݶ�
    grad_W1 = zeros(n, s2);
    grad_b1 = zeros(1, s2);
    grad_W2 = zeros(s2, 1);
    grad_b2 = zeros(1, 1);
    



    %% ��W1,b1,W2,b2��ƫ�������г��ݶ�������grad
    grad = [grad_W1(:), grad_b1(:), grad_W2(:), grad_b2(:)];    
end