function [a b] = linear_regression1( data, alpha )
%Liner Regression
%   Data:N*2 matrix, [Y X]
%	alpha:reliable variable
%	
	
	Y = data(:,1);	% Get the data
	X = data(:,2);
	xbar = mean(X);	
	ybar = mean(Y);
	
	%Calculate the Lxx,Lyy,Lxy
	Xn = X - xbar;	
	Yn = Y - ybar;
	Lxy = sum( Xn .* Yn );
	Lxx = sum( Xn .* Xn );
	Lyy = sum( Yn .* Yn );
	
	%Regression
	b = Lxy / Lxx;
	a = ybar - b*xbar;
	Ypredict = a + b .* X;
	
	%Show the result
	disp( (string('y=')+string(b)+string('*x+')+string(a)) );
	
	%Calculate the Confidence
	N = size(data,1);
	ESS = sum( (Ypredict-ybar) .^2 );
	RSS = sum( (Y-Ypredict) .^2 );
	r2 = ESS/(ESS+RSS);
	Fresult = (N-2)* ESS / RSS;
	Faim = finv(1-alpha,1,N-2);
	
	if Fresult <= Faim
		disp('The data is not linear well.');
		return;
	end
	
	% Confidence Interval
	Sdelta = sqrt( (1-r2)*Lyy/(N-2) );
	Zalpha = norminv(alpha/2,0,1);
	Interval = -Zalpha*Sdelta;
	disp('Interval:');
	disp(['[' num2str(a-Interval) ',' num2str(a+Interval) ']']);
	
	%Show the result
	figure, scatter(X,Y,'h');
	hold on;
	
	Xeg = min(X):0.01:max(X);
	Yeg = a+b*Xeg;
	plot(Xeg,Yeg,'-');
	plot(Xeg,Yeg-Interval,'--');
	plot(Xeg,Yeg+Interval,'--');
	legend('Origin','Regression','Low','High');
end