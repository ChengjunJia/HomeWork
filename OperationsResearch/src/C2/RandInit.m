function theta = RandInit( X,L,Conv )
	% X, input; the row means the size of the input
	thetaSize = 0;
	for m = 2:length(L)
		if Conv(m) == 0
			thetaSize = thetaSize+L(m-1)*L(m)+L(m);
		else
			thetaSize = thetaSize+Conv(m);
		end
	end
	theta = normrnd(0,0.02,thetaSize,1) ;
end