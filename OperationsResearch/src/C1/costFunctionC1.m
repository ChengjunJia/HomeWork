function [J, grad,net] = costFunctionC1( theta, X, y, lambda, L, Sig )
%	Author: ChengjunJia
%	Date: 2017-5-4
%	Coding: UTF-8(Unix(LF))
%	Calculate the costFunctionC1 and the grad
%	Input:  X, N*n-- N samples
%			theta, m*1
%			y, N*1
%			L, L(1)--Number node of the Layer1,L(2)...
%			!!input layer means layer0!!
%			Sig, 1 means the function is sigmoid, 0 means it is relu; the same size as L
%	Review: 2017-5-10, Multi Layers and ReLu、Sigmoid
	
	% Read the Structure and Reshape it
	clear net;
	N = length(y);
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
	y = y';
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
	net_out = net.layer{length(L)}.out;
	
	% Calculate the loss: J-Function
	sumW = 0;
	for m = 1:NetDeep
		sumW = sumW + sum( net.layer{m}.W(:) .^ 2);
	end
	J = sum(- y .* log(net_out) - ( 1-y ) .* log ( 1 - net_out) ) /N + lambda / 2 / N * sumW;
	
	% Back Forward to calculate the grad--delta and grad
	if Sig(NetDeep) == 1
		net.layer{NetDeep}.delta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* net_out .* (1-net_out);
	else
		net.layer{NetDeep}.delta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* ( net.layer{NetDeep}.in >0 );
	end
	
	net.layer{NetDeep}.gradb = mean(net.layer{NetDeep}.delta,2);
	net.layer{NetDeep}.gradW = ( net.layer{NetDeep}.delta * net.layer{NetDeep-1}.out' ) ./N + lambda .* net.layer{NetDeep}.W ./N;
	
	for m = (NetDeep-1):(-1):2
		if Sig(m) == 1
			net.layer{m}.delta = ( net.layer{m+1}.W' * net.layer{m+1}.delta ) .* net.layer{m}.out .* (1-net.layer{m}.out);
		else
			net.layer{m}.delta = ( net.layer{m+1}.W' * net.layer{m+1}.delta ) .* ( net.layer{m}.in > 0  );
		end
		net.layer{m}.gradb = mean( net.layer{m}.delta,2 );
		net.layer{m}.gradW = ( net.layer{m}.delta * net.layer{m-1}.out' ) ./ N + lambda .* net.layer{m}.W ./ N;
	end
	m = 1;
	if Sig(m) == 1
		net.layer{m}.delta = ( net.layer{m+1}.W' * net.layer{m+1}.delta ) .* net.layer{m}.out .* (1-net.layer{m}.out);
	else
		net.layer{m}.delta = ( net.layer{m+1}.W' * net.layer{m+1}.delta ) .* ( net.layer{m}.in > 0  );
	end
	net.layer{m}.gradb = mean( net.layer{m}.delta,2 );
	net.layer{m}.gradW = ( net.layer{m}.delta * X' ) ./ N + lambda .* net.layer{m}.W ./ N;
	
	% Reshape grad into theta
	grad = theta;
	tmp = 0;
	grad( (tmp+1):(tmp+L(1)*nInput) ) =  net.layer{1}.gradW(:);
	tmp = tmp+L(1)*nInput;
	grad( (tmp+1):(tmp+L(1)) ) = net.layer{1}.gradb(:);
	tmp = tmp+L(1);
	for m = 2:NetDeep
		grad( (tmp+1):(tmp+L(m-1)*L(m)) ) = net.layer{m}.gradW(:);
		tmp = tmp+L(m-1)*L(m);
		grad( (tmp+1):(tmp+L(m)) ) = net.layer{m}.gradb(:);
		tmp = tmp+L(m);
	end
end