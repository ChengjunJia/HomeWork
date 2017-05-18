function [optimal_theta, J_history] = calBest(x,y,theta,net)
	opts.numepochs =200;
	opts.alpha = 1;
	opts.batchsize =1000;
	m = size(x, 1);
	traintime = 1;
	numbatches = m / opts.batchsize;
	J = zeros(opts.numepochs*numbatches,1);
	for i = 1 : opts.numepochs
        fprintf('epoch %d/',i);
		fprintf('%d \n',opts.numepochs);
        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize),:);
            batch_y = y(kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize),:);
			[J(traintime),grad] = costFunctionC1(theta,batch_x,batch_y,net.lambda,net.L,net.Sig,net.Conv);
			theta = theta - grad .* opts.alpha;
			traintime = traintime+1;
        end
    end
	optimal_theta = theta;
	J_history = J;
end