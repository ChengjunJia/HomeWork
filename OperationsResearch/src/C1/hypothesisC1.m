function [y_hat,net] = hypothesisC1( X, theta,L,Sig )
%	Author: ChengjunJia
%	Data: 2-17-5-4
%	Coding: UTF-8 Unix
%	Calculate the result of neutral output
%	Input:  X, N*n-- N sample
%			theta, m*1

	% the parameter, which show the network
    % Read the Structure and Reshape it
	clear net;
	N = size(X,1);
	nInput = size(X,2);
	tmp = 0;
	net.layer{1}.W = reshape(theta((tmp+1):(tmp+L(1)*nInput)),L(1),nInput);
	tmp = tmp+L(1)*nInput;
	net.layer{1}.b = reshape(theta((tmp+1):(tmp+L(1))),L(1),1);
	tmp = tmp+L(1);
	NetDeep = length(L);
	for m = 2:NetDeep
		net.layer{m}.W = reshape(theta((tmp+1):(tmp+L(m-1)*L(m))),L(m),L(m-1));
		tmp = tmp+L(m-1)*L(m);
		net.layer{m}.b = reshape(theta((tmp+1):(tmp+L(m))),L(m),1);
		tmp = tmp+L(m);
	end
	
	% Forward Broadcast to calculate the result
	X = X';
	net.layer{1}.in = net.layer{1}.W * X + net.layer{1}.b;
	if Sig(1) == 1
		net.layer{1}.out = sigmoid(net.layer{1}.in);
	else
		net.layer{1}.out = relu(net.layer{1}.in);
	end
	
	for m = 2:NetDeep
		net.layer{m}.in = net.layer{m}.W * net.layer{m-1}.out + net.layer{m}.b;
		if Sig(m) == 1
			net.layer{m}.out = sigmoid(net.layer{m}.in);
		else
			net.layer{m}.out = relu(net.layer{m}.in);
		end
	end
	y_hat = net.layer{length(L)}.out';
	
end