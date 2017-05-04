%% Function: Calculate the compressed data
% data  输入的原始数据矩阵，每一行对应一个数据点
% rerr  相对误差界限，即相对误差应当小于这个值，用于确定主成分个数

% pcs  各个主成分，每一列为一个主成分
% cprs_data  压缩后的数据，每一行对应一个数据点
% cprs_c 压缩时的一些常数，包括数据每一维的均值和方差等——第一行,均值；第二行,标准差。利用以上三个变量应当可以恢复出原始的数据
function [pcs, cprs_data, cprs_c] = pca_compress(data, rerr)
	
	% Data changed to the standard
	dataMean = mean(data);
	dataVar = sqrt(var(data));
	
	% dataNew: Every Column is one X = [x_1 x_2 ... x_N];
	dataNew = (( data-dataMean ) ./ dataVar)';	
	X = dataNew;
	
	% V:The feature vectors; D: The dialog similar matrix
	[V,D] = eig(X*X');
	
	% Find the required m
	[lamdaList,pos] = sort(max(abs(D)),'descend');
	Vn = V(:,pos);
	Dn = D(:,pos);
	SumD = cumsum(lamdaList);
	Err = 1 - SumD ./ max(SumD);
	len = find(Err<rerr,1,'first');
	L = Vn(:,1:len);
	cprs_data = X'*L;
	pcs = L;
	cprs_c = [dataMean;dataVar];
end