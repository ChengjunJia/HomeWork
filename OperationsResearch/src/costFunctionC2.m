function [J, grad] = costFunctionC2( theta, X, y, lambda,param )
%	Author: ChengjunJia
%	Date: 2017-5-10
%	Coding: UTF-8(Unix(LF))
%	Calculate the costFunctionC2 and the grad
%	Aim: conv result to diff the MNIST
%	Input:  X, N*(row*column)- N samples, n can reshape into an image
%			theta, m*1
%			y, N*1

	% Read the Structure and Reshape it
	clear net;
	[nSamples] = size(X,1);
	for m = 1:nSamples
		net.layer{1}.out{m} = X(m,:,:);
	end
	net.layer{1}.outMaps = nSamples;
	
	
	for m = 2:numel(net.layer)
		if strcmp( net.layer{m}.type,'c' )
		% Conv: last layer has m picture
			
			net.layer{m-1}.
		elseif strcmp( net.layer{m}.type,'p')
		% Pool and downsample
		
		elseif strcmp( net.layer{m}.type,'d')
		% Connect all
		
		end
	end
	
	
	
end

function net = ReadCNN( theta,param )
	net.layer{1}
	
	
	
end