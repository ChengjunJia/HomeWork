function [J, grad] = costFunctionB4( theta, X, y, lambda )
%	Author: ChengjunJia
%	Date: 2017-5-4
%	Coding: UTF-8(Unix(LF))
%	Calculate the costFunctionB4 and the grad
%	Input:  X, N*n-- N samples
%			theta, m*1
%			y, N*1
	
	% the parameter, which show the network's structure
	% Read the W and b from the theta 
	N = length(y);
	nInput = size(X,2);
	nLayer2 = (size(theta,1)-1)/(nInput+2);
	W1 = reshape(theta(1:nInput*nLayer2), nLayer2,nInput);
	tmpStart = nInput*nLayer2;
	b1 = reshape(theta((tmpStart+1):(tmpStart+1*nLayer2)),nLayer2,1);
	tmpStart = tmpStart+1*nLayer2;
	W2 = reshape(theta((tmpStart+1):(tmpStart+nLayer2*1)),1,nLayer2);
	tmpStart = tmpStart+nLayer2*1;
	b2 = theta(tmpStart+1);

	% Calculate cost function J
	X = X';
	y = y';
	layer2in = W1*X+b1;
	layer2out = relu(layer2in);
	layer3out = sigmoid(W2*layer2out+b2);
	J = sum(- y .* log(layer3out) - ( 1-y ) .* log ( 1-layer3out) ) /N + lambda / 2 / N * (sum(W1(:) .^2)+sum(W2(:) .^2));
	
	% BP to update the weight
	delta3 = ( (1-y) ./ (1-layer3out) - y ./ layer3out ) .* layer3out .* (1-layer3out);
	grad_b2 = mean( delta3,2 );
	grad_W2 = ( delta3 * layer2out' ) ./N + lambda .* W2 ./ N;
	delta2 = W2' .* delta3 .* ( layer2in > 0 );
	grad_b1 = mean(delta2,2);
	grad_W1 = ( delta2 * X' ) ./ N + lambda .* W1 ./ N;
	grad = [ grad_W1(:); grad_b1(:); grad_W2(:); grad_b2(:) ];
end