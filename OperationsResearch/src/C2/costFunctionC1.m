function [J, grad,net] = costFunctionC1( theta, X, y, lambda, L, Sig, Conv )
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
	net.layer{1}.in = X';
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
	netout = net.layer{NetDeep}.out;
	
	net_out = netout;
	y = y';
	% Calculate the loss: J-Function
	sumW = 0;
	for m = 2:NetDeep
		if Conv(m) == 0
			sumW = sumW + sum( net.layer{m}.W(:) .^ 2);
		else
			sumW = sumW + sum( net.layer{m}.kernal(:) .^2 );
		end
	end
	J = sum(- y .* log(net_out) - ( 1-y ) .* log ( 1 - net_out) ) /N + lambda / 2 / N * sumW;
	
	% Back Forward to calculate the grad--delta and grad
	if Sig(NetDeep) == 1
		net.layer{NetDeep}.delta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* net_out .* (1-net_out);
	else
		net.layer{NetDeep}.delta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* ( net_out >0 );
	end
	
	for m = (NetDeep-1):(-1):2
		if Sig(m) == 1
			net.layer{m}.delta = net.layer{m}.out .* (1-net.layer{m}.out);
		else
			net.layer{m}.delta = double( net.layer{m}.out > 0 ) ;
		end
		
		if Conv(m+1) == 0
			net.layer{m}.delta = ( net.layer{m+1}.W' * net.layer{m+1}.delta ) .* net.layer{m}.delta;
		else
			net.layer{m}.delta = (convn(net.layer{m+1}.delta, flip( net.layer{m+1}.kernal ) ,'full') ).* net.layer{m}.delta; 
		end
	end

	for m = 2:NetDeep
		if Conv(m) == 0
			net.layer{m}.gradb = mean( net.layer{m}.delta,2 );
			net.layer{m}.gradW = ( net.layer{m}.delta * net.layer{m-1}.out' ) ./ N + lambda .* net.layer{m}.W ./ N;
		else
			% tmp = zeros(size(net.layer{m}.kernal));
			% for n = 1:N
				% tmp = tmp + conv(flip(net.layer{m-1}.out(:,n)),net.layer{m}.delta(:,)
			% end
			net.layer{m}.gradkernal = convn( flip( net.layer{m-1}.out,1 ), flip(net.layer{m}.delta,2),'valid') ./N + lambda .* net.layer{m}.kernal ./ N;
		end
	end
	% net.layer{NetDeep}.gradb
	% Reshape grad into theta
	grad = theta;
	tmp = 0;
	for m = 2:NetDeep
		if Conv(m) == 0
			grad((tmp+1):(tmp+L(m-1)*L(m))) = net.layer{m}.gradW(:);
			tmp = tmp+L(m-1)*L(m);
			grad((tmp+1):(tmp+L(m))) = net.layer{m}.gradb(:);
			tmp = tmp+L(m);
		else
			grad((tmp+1):(tmp+Conv(m))) = net.layer{m}.gradkernal(:);
			tmp = tmp+Conv(m);
		end
	end
end