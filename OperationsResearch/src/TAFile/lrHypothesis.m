function y_hat = lrHypothesis(X, optimal_theta)
    m = size(X,1);
    y_hat = [ones(m,1) X] * optimal_theta;
end