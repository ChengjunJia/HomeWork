% Reviewer: ChengjunJia
% Record:
%	2017-5-1�� Write the right code
function [optimal_theta, J_history] = myfminuncA1( costFunction, initial_theta, alpha, max_iter)
    J_history = zeros(max_iter, 1);
    theta = initial_theta;
	once = max_iter/10;
    for m = 1:10
		for i = (once*(m-1)+1):(once*m)
			[J, grad] = costFunction(theta);
			J_history(i) = J;
			%��Ӧ�ø�дΪ��ȷ���ݶ��½���ʵ��
			theta = theta - grad .* alpha;          
		end
		fprintf('%d%%  ',m*10);
    end
    optimal_theta = theta;    
end