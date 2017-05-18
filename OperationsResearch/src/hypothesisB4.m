function y_hat = hypothesisB4(X, optimal_theta)
%	Author: ChengjunJia
%	Data: 2-17-5-4
%	Coding: UTF-8 Unix
%	Calculate the result of neutral output
%	Input:  X, N*n-- N sample
%			optimal_theta, m*1
%	Explanation: Layer1-input, Layer2-hidden, Layer3-output

	%% the parameter, which show the network
    nInput = size(X,2);
	nLayer2 = (size(optimal_theta,1)-1)/(nInput+2);
	W1 = reshape(optimal_theta(1:nInput*nLayer2), nLayer2,nInput);
	tmpStart = nInput*nLayer2;
	b1 = reshape(optimal_theta((tmpStart+1):(tmpStart+1*nLayer2)),nLayer2,1);
	tmpStart = tmpStart+1*nLayer2;
	W2 = reshape(optimal_theta((tmpStart+1):(tmpStart+nLayer2*1)),1,nLayer2);
	tmpStart = tmpStart+nLayer2*1;
	b2 = optimal_theta(tmpStart+1);
	
	y_hat = sigmoid(W2*relu(W1*X'+b1)+b2)';
end