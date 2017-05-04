figure;
[mu10,sigma10] = plotpdf('Normal',10);
hold on;
[mu100,sigma100] = plotpdf('Normal',100);
[mu1000,sigma1000] = plotpdf('Normal',1000);
plotnormal(0,1,1);
legend('Bayes-10','Bayes-100','Bayes-1000','Normal-0,1');

figure,
[muU,sigmaU] = plotpdf('Uniform',100);

function [mu,sigma] = plotpdf(RandModule,size)
	variable1 = 0;variable2 = 1;
	X = random(RandModule,variable1,variable2,[size,1]);
	[mu sigma] = BayesianEstimationNormalDistribute(X);
	plotnormal(mu,sigma,0.5);
end

function [] = plotnormal(mu,sigma,linewidth)
	pd = makedist('Normal','mu',mu,'sigma',sigma);
	x_values = -5:0.1:5;
	y_values = pdf(pd,x_values);
	plot(x_values,y_values,'LineWidth',linewidth);
end

function [mu,sigma] = BayesianEstimationNormalDistribute( X )
 if size(X,2) ~= 1
  disp('Matrix Size is Worry! Should be n*1');
  return;
 end
 mu = mean(X);
 sigma_2 = var(X)/(size(X,1)-1)*size(X,1);
 sigma = sqrt(sigma_2);
end
