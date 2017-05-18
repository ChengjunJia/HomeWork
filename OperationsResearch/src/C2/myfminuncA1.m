% Reviewer: ChengjunJia
% Record:
%	2017-5-1： Write the right code
function [optimal_theta, J_history] = myfminuncA1( costFunction, initial_theta, alpha, max_iter)
    J_history = zeros(max_iter, 1);
    theta = initial_theta;
    shownum = 20;
	once = max_iter/shownum;
    for m = 1:shownum
        alphaNew = alpha *(1-m/(shownum+1));
		for i = (once*(m-1)+1):(once*m)
			[J, grad] = costFunction(theta);
			J_history(i) = J;
			%你应该改写为正确的梯度下降法实现
			theta = theta - grad .* alphaNew;          
		end
		fprintf('%d%%  ',m*100/shownum);
    end	
    optimal_theta = theta;    
end