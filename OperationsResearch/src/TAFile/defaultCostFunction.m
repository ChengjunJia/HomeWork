function [J,grad] = defaultCostFunction(theta, X, y)
    J = X * theta.^2+ y;
    grad = 2 * X' .* theta;
end