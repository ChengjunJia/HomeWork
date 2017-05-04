function [beta,beta0,Interval] = linear_regression2 ( Y,X,alpha )
%Liner Regression
%   Y: 1*N
%	X: n*N, First column is not zero
%	alpha:reliable variable
%	
%	beta: Y  beta * X

	threshold = 0.3;	%Threshold: the threshold for the multicollinearity
	nFeature = size(X,1);
	nSample = size(X,2);

	% Data changed to the standard
	meanX = mean(X'); meanY = mean(Y');
	varX = sqrt(var(X')); varY = sqrt(var(Y'));
	Xnew = (( X'-meanX ) ./ (varX))';	
	Ynew = (( Y'-meanY ) ./ (varY))';
	
	%Regression
	Xnn = [ones(1,nSample);Xnew];
	S = Xnn*Xnn';
	[V,D] = eig(S);
	[c,pos] = sort(max(abs(D)));
	Vn = V(:,pos);
	Dn = D(:,pos);
	sumDn = cumsum(c);
	beginpos = find(sumDn >= threshold,1,'first');
	Qm = Vn(:,size(Vn,2):(-1):beginpos);
	Z = Qm' * Xnn;
	Cnew = Qm*inv(Z*Z')*Z*Ynew';
	
	%Calculate the original Beta
	beta = Cnew(2:(nFeature+1));
	varXn = varX';
	beta0 = ( Cnew(1)-sum( (beta .* meanX') ./ varXn ))*varY+meanY;
	beta = (beta ./ varXn )*varY;
	
	%Calculate the Confidence
	Ypredict = beta' * X + beta0;
	err = Ypredict - Y;
	ESS = sum((Ypredict-meanY) .^2);
	RSS = sum((Y-Ypredict) .^2);
	Fout = (nSample-nFeature-1)*ESS/(nFeature*RSS);
	faim = finv(1-alpha,nFeature,nSample-nFeature-1);
	if Fout < faim
		disp('No Liner!');
	else
		str = '\beta=';
		for m = 1:size(beta)
			str = [str '  ' num2str(beta(m))];
		end
		disp(str);
		disp(['beta0=  ' num2str(beta0)]);
	end
	
	% Confidence Interval
	Sa = sqrt(RSS/(nSample-nFeature-1));
	Zalpha = norminv(alpha/2,0,1);
	Interval = -Zalpha*Sa;
	
	%Show the result
	disp('Interval:');
	disp(['[' num2str(beta0-Interval) ',' num2str(beta0+Interval) ']']);

end