function theta = Rand_Init( X,L )
	% X, input; the row means the size of the input
		Ninput = size(X,2);
	thetaSize = Ninput*L(1)+L(1);
	for m = 2:length(L)
		thetaSize = thetaSize+L(m-1)*L(m)+L(m);
	end
	theta = normrnd(0,0.02,thetaSize,1);
end