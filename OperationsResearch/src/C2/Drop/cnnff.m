function net = cnnff(net)
	nlayers = net.layerNum;
	for NoLayer = 2:nlayers
		% NoLayer-1 --> NoLayer
		NoBefore = NoLayer-1;
		NoNow = NoLayer;
		Transfer = net.connect{NoBefore};
		if strcmp(Transfer.type,'conv')
		% Convtional layers
			for NoMapOut = 1:Transfer.outNum
				z = zeros(Transfer.outSize);
				for NoMapIn = 1:Transfer.inNum
					z = z + convn(net.layer{NoBefore}.out{NoMapIn},Transfer.Kernal{NoMapOut}{NoMapIn},'valid');
				end
				z = z + Transfer.B{NoMapOut};
				net.layer{NoNow}.in{NoMapOut} = z;
				if strcmp(Transfer.Active,'sigmoid')
					net.layer{NoNow}.out{NoMapOut} = sigmoid(z);
				elseif strcmp(Transfer.Active,'relu')
					net.layer{NoNow}.out{NoMapOut} = relu(z);
				else
					net.layer{NoNow}.out{NoMapOut} = z;
				end
			end
			
		elseif strcmp(Transfer.type,'pool')
		% Pool layers, Average Pool
			poolScale = Transfer.scale;
			poolKernal = ones(poolScale)/(poolScale^2);
			for NoMapOut = 1:Transfer.outNum
				net.layer{NoNow}.in{NoMapOut} = net.layer{NoBefore}.out{NoMapOut};
				z = convn(net.layer{NoBefore}.out{NoMapOut},poolKernal,'valid');
				net.layer{NoNow}.out{NoMapOut} = z(1:poolScale:end,1:poolScale:end,:);
			end
			
		end
end
% Make these pixels into one row	
	temp = [];
	for NoIm = 1:Transfer.outNum
		sa = size(net.layer{nlayers}.out{NoIm});
		temp = [temp;reshape(net.layer{nlayers}.out{NoIm},sa(1)*sa(2),sa(3))];
	end
	net.layer.Allin = temp;
	
	% All Connect layer: commonly as the last layer
	z = net.connect.AllW * net.layer.Allout + net.connect.Allb;
	net.layer.Allout = z;		
	if strcmp(net.connect.AllActive,'sigmoid')
		net.layer.out = sigmoid(z);
	elseif strcmp(net.connect.AllActive,'relu')
		net.layer.out = relu(z);
	end
		
end