function net = cnnbf(net,y)
	nlayers = net.layerNum;
	% the error--delta of
	net_out = net.layer.out;
	net.Jcost = sum(- y .* log(net_out) - ( 1-y ) .* log ( 1 - net_out) ) /length(y);
	if strcmp( net.connect.AllActive,'sigmoid')
		net.layer.Alldelta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* net_out .* (1-net_out);
	elseif strcmp( net.connect.AllActive,'relu')
		net.layer.Alldelta = ( (1-y) ./ (1-net_out) - y ./ net_out ) .* ( net.layer.Allout >0 );
	end
	
	sa = size(net.layer{nlayers}.out{1});
    fvnum = sa(1) * sa(2);
    for m = 1 : net.connect{nlayers-1}.outNum
        net.layer{n}.delta{m} = reshape(net.layer.Alldelta(((m - 1) * fvnum + 1) : m * fvnum, :), sa(1), sa(2), sa(3));
    end
	
	for Nolayer = nlayers-1:(-1):1
		Transfer = net.connect{Nolayer};
		if strcmp( Transfer.type,'conv' )
			for NoIn = 1:Transfer.inNum
				z = zeros(net.layer{Nolayer}.in{NoIn});
				for NoOut = 1:Transfer.outNum
					z = z+convn(net.layer{Nolayer}.delta{NoOut}, rot180(Transfer.kernal{NoOut}{NoIn}),'full' );
				end
				if strcmp( Transfer,Active,'sigmoid'	)
					net.layer{Nolayer}.delta{inNum} = z .* net.layer{Nolayer}.in{inNum} .* (1-net.layer{Nolayer}.in{inNum});
				elseif
					net.layer{Nolayer}.delta{inNum} = z .* (net.layer{Nolayer}.in{inNum}>0);
				end
			end
			
		elseif strcmp( Transfer.type,'pool' )
			for NoIn = 1:Transfer.inNum
                net.layer{Nolayer}.delta{NoIn} = (expand(net.layers{Nolayer + 1}.detla{NoIn}, [Transfer.scale Transfer.scale 1]) / Transfer.scale ^ 2);
            end
			
		end
	end
	
	for Nolayer = 1 : nlayers-1
		Transfer = net.connect{Nolayer}; 
        if strcmp(Transfer.type, 'conv')
            for NoOut = 1 : Transfer.outNum
                for NoIn = 1 : Transfer.inNum
                    Transfer.dk{NoOut}{NoIn} = convn(flipall( net.layer{Nolayer}. ), net.layer{Nolayer}.d{j}, 'valid') / size(net.layers{l}.d{j}, 3);
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 3);
            end
        end
    end
    net.dffW = net.od * (net.fv)' / size(net.od, 2);
    net.dffb = mean(net.od, 2);
	
end

function X = rot180(X)
	X = flipdim(flipdim(X,1),2);
end

function B = expand(A, S)
% Author: Matt Fig
% Date: 6/20/2009
% Contact:  popkenai@yahoo.com

if nargin < 2
    error('Size vector must be provided.  See help.');
end

SA = size(A);  % Get the size (and number of dimensions) of input.

if length(SA) ~= length(S)
   error('Length of size vector must equal ndims(A).  See help.')
elseif any(S ~= floor(S))
   error('The size vector must contain integers only.  See help.')
end

T = cell(length(SA), 1);
for ii = length(SA) : -1 : 1
    H = zeros(SA(ii) * S(ii), 1);   %  One index vector into A for each dim.
    H(1 : S(ii) : SA(ii) * S(ii)) = 1;   %  Put ones in correct places.
    T{ii} = cumsum(H);   %  Cumsumming creates the correct order.
end

B = A(T{:});   %  Feed the indices into A.
end

function X=flipall(X)
    for i=1:ndims(X)
        X = flipdim(X,i);
    end
end