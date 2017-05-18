function [y_hat,net] = hypothesisC1( X,theta,L,Sig,Conv )
%	Author: ChengjunJia
%	Data: 2-17-5-4
%	Coding: UTF-8 Unix
%	Calculate the result of neutral output
%	Input:  X, N*n-- N sample
%			theta, m*1
%			L(1) = 1 means input layer, number of nodes
%			Sig: the active function is sigmoid or relu?
%			Conv: the conv kernal num,0 means there is no conv	
	% the parameter, which show the network
    % Read the Structure and Reshape it
	clear net;
	N = size(X,1);
	nInput = size(X,2);
	tmp = 0;
	NetDeep = length(L);
	
	for m = 2:NetDeep
		if Conv(m) == 0
			net.layer{m}.W = reshape(theta((tmp+1):(tmp+L(m-1)*L(m))),L(m),L(m-1));
			tmp = tmp+L(m-1)*L(m);
			net.layer{m}.b = reshape(theta((tmp+1):(tmp+L(m))),L(m),1);
			tmp = tmp+L(m);
		else
			net.layer{m}.kernal = theta((tmp+1):(tmp+Conv(m)));
			tmp = tmp + Conv(m);
		end
	end
	
	% Forward Broadcast to calculate the result
	net.layer{1}.out = X';
	for m = 2:NetDeep
		if Conv(m) == 0
			net.layer{m}.in = net.layer{m}.W * net.layer{m-1}.out + net.layer{m}.b;	
		else
			net.layer{m}.in = convn(net.layer{m-1}.out,net.layer{m}.kernal,'valid');
		end
		
		if Sig(m) == 1
			net.layer{m}.out = sigmoid(net.layer{m}.in);
		else
			net.layer{m}.out = relu(net.layer{m}.in);
		end
	end
	y_hat = net.layer{NetDeep}.out';
	
end