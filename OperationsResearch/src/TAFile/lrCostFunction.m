function [J, grad] = lrCostFunction(theta, X, y, lambda)
%LRCOSTFUNCTION Compute cost and gradient for logistic regression with 
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

m = length(y); 
X_a = [ones(m,1) X];
z = X_a * theta;

J = sum(- y .* log(sigmoid(z)) - ( 1 - y ) .* log ( 1 - sigmoid(z))) / m + lambda / 2 / m * sum(theta(2:end) .^2);

grad = X_a' * (sigmoid(z) - y ) / m  + lambda / m * [0;theta(2:end)];




grad = grad(:);

end
