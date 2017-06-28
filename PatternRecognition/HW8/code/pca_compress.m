%% Function: Calculate the compressed data
% UTF-8-BOM
% data  输入的原始数据矩阵，每一行对应一个数据点
% rerr  相对误差界限，即相对误差应当小于这个值，用于确定主成分个�?

% pcs  各个主成分，每一列为�?��主成�?
% cprs_data  压缩后的数据，每�?��对应�?��数据�?
% cprs_c 压缩时的�?��常数，包括数据每�?��的均值和方差等�?第一�?均�??；第二行,标准差�?
function [pcs, cprs_data] = pca_compress(data)
	X = data;
	
	% V:The feature vectors; D: The dialog similar matrix
	[V,D] = eig(X*X');
	[~,pos] = sort(abs(sum(D)),'descend');
	% Find the required m
	Vn = V(:,pos);
	len = 2;
%len = 9;
    L = Vn(:,1:len);
	cprs_data = X'*L;
	pcs = L;
end