function [cost,grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, ...
                                             lambda, sparsityParam, beta, data)

% visibleSize: the number of input units (probably 64) 
% hiddenSize: the number of hidden units (probably 25) 
% lambda: weight decay parameter
% sparsityParam: The desired average activation for the hidden units (denoted in the lecture
%                           notes by the greek alphabet rho, which looks like a lower-case "p").
% beta: weight of sparsity penalty term
% data: Our 64x10000 matrix containing the training data.  So, data(:,i) is the i-th training example. 
  
% The input theta is a vector (because minFunc expects the parameters to be a vector). 
% We first convert theta to the (W1, W2, w1, w2) matrix/vector format, so that this 
% follows the notation convention of the lecture notes. 

W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
W2 = reshape(theta(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
w1 = theta(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
w2 = theta(2*hiddenSize*visibleSize+hiddenSize+1:end);

% Cost and gradient variables (your code needs to compute these values). 
% Here, we initialize them to zeros. 
cost = 0;
W1grad = zeros(size(W1)); 
W2grad = zeros(size(W2));
w1grad = zeros(size(w1)); 
w2grad = zeros(size(w2));
%---------------------MY NOTE,By JCJ----------------------------
% In Fact, The following code about W1grad... is excess, and should be removed
%---------------------------------------------------------------


%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost/optimization objective J_sparse(W,b) for the Sparse Autoencoder,
%                and the corresponding gradients W1grad, W2grad, w1grad, w2grad.
%
% W1grad, W2grad, w1grad and w2grad should be computed using backpropagation.
% Note that W1grad has the same dimensions as W1, w1grad has the same dimensions
% as w1, etc.  Your code should set W1grad to be the partial derivative of J_sparse(W,b) with
% respect to W1.  I.e., W1grad(i,j) should be the partial derivative of J_sparse(W,b) 
% with respect to the input parameter W1(i,j).  Thus, W1grad should be equal to the term 
% [(1/m) \Delta W^{(1)} + \lambda W^{(1)}] in the last block of pseudo-code in Section 2.2 
% of the lecture notes (and similarly for W2grad, w1grad, w2grad).
% 
% Stated differently, if we were using batch gradient descent to optimize the parameters,
% the gradient descent update to W1 would be W1 := W1 - alpha * W1grad, and similarly for W2, w1, w2. 
% 

%|---------------------MY NOTE,By chengjunJia-----------------------------------------------|
%|%%%%%%%%%%%%%%%%!!!!Attention! Following only support R2016b!!!!!!!!%%%%%%%%%%%%%%%%%%%%% |
%|%%%%%%%%%%%%%%%%!!!!If not,please modify code with these Things !!!!%%%%%%%%%%%%%%%%%%%%% |
%| In fact, in the [R2016b] or later, '+' equals bsxfun(@plus,A,B) and so on                |
%| To make the programme more understandable,I use the +,-.* ...                            |
%| The not in below the code is about how to act in the MATLAB 2015b or before              |
%| If you want to make the file to support different release,you can use the following code |
%| to judge whether the version of MATLAB is R2016b:                                        |
%| L = ver;                                                                                 |
%| VersionInofo = L.Release;                                                                |
%| Is16v = strcmp(VersionInofo,'(R2016b)');                                                 |
%| if Is16v                                                                                 |
%| 		*****                                                                               |
%| else                                                                                     |
%| 		*****                                                                               |
%| end                                                                                      |
%|------------------------------------------------------------------------------------------|

layer1out = sigmoid(W1*data+w1);
layer2out = sigmoid(W2*layer1out+w2);
% R2015b
% layer1out = sigmoid(bsxfun(@plus,W1*data,w1));
% layer2out = sigmoid(bsxfun(@plus,W2*data,w2));

err = layer2out-data;

R = (sum(sum(W1 .^2))+sum(sum(W2 .^2)))* lambda/2;
rho = mean(layer1out,2);
S = beta*sum(sparsityParam .* log(sparsityParam ./ rho)+(1-sparsityParam) .* log((1-sparsityParam)./(1-rho)));

cost = sum( mean(err .^2,2) ) /2 +R+S;

Samplew2grad = err .* (layer2out .*(1-layer2out));
w2grad = mean(Samplew2grad,2);

nsamples = size(data,2);
W2grad = (Samplew2grad*layer1out' ./nsamples) +W2 .*lambda;

Samplew1grad = ( W2' * Samplew2grad + beta*(-sparsityParam ./rho +(1-sparsityParam)./(1-rho) )) .* layer1out .*(1-layer1out);
% R2015b
% Samplew1grad = bsxfun(@plus, W2' * Samplew2grad , beta*(-sparsityParam ./rho +(1-sparsityParam)./(1-rho) )) .* layer1out .*(1-layer1out);
w1grad = mean(Samplew1grad,2);

W1grad = (Samplew1grad*data' ./ nsamples)+W1 .* lambda;

%-------------------------------------------------------------------
% After computing the cost and gradient, we will convert the gradients back
% to a vector format (suitable for minFunc).  Specifically, we will unroll
% your gradient matrices into a vector.

grad = [W1grad(:) ; W2grad(:) ; w1grad(:) ; w2grad(:)];

end

%-------------------------------------------------------------------
% Here's an implementation of the sigmoid function, which you may find useful
% in your computation of the costs and the gradients.  This inputs a (row or
% column) vector (say (z1, z2, z3)) and returns (f(z1), f(z2), f(z3)). 

function sigm = sigmoid(x)
  
    sigm = 1 ./ (1 + exp(-x));
end

