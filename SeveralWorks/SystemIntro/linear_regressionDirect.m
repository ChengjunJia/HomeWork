function [beta,beta0,Interval] = linear_regressionDirect ( Y,X,alpha )
%Liner Regression
%   Y: 1*N
%	X: n*N, First column is not one
%	alpha:reliable variable
%	
%	beta: Y  beta * X

	nFeature = size(X,1);
	nSample = size(X,2);

	% Data changed to the standard
	meanX = mean(X'); meanY = mean(Y');
	varX = sqrt(var(X')); varY = sqrt(var(Y'));
	Xnew = (( X'-meanX ) ./ (varX))';	
	Ynew = (( Y'-meanY ) ./ (varY))';
	
	%Regression
	Xnn = [ones(1,nSample);Xnew];
	BetaAll = inv(Xnn*Xnn') *Xnn*Ynew';
	Beta0 = BetaAll(1);
	Beta = BetaAll(2:end);
	beta = (Beta' ./ varX)' * varY;
	beta0 = varY * ( Beta0 - sum(Beta' .* meanX ./ varX))+meanY;
	
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
			str = [str,'  ',num2str(beta(m))];
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