% Reviewer: ChengjunJia
% Record:
%	2017-5-1： Write the right code
function [optimal_theta, J_history] = myfminuncA1( costFunction, initial_theta, alpha, max_iter)
    J_history = zeros(max_iter, 1);
    theta = initial_theta;
	once = max_iter/10;
    for m = 1:10
		for i = (once*(m-1)+1):(once*m)
			[J, grad] = costFunction(theta);
			J_history(i) = J;
			%你应该改写为正确的梯度下降法实现
			theta = theta - grad .* alpha;          
		end
		fprintf('%d%%  ',m*10);
    end
    optimal_theta = theta;    
end