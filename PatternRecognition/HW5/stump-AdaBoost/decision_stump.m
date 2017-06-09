function [j, a, d] = decision_stump(X, y, w)
% 优化决策树桩的参数
% 
%
% 输入
%     X : n * p 矩阵, 每一行是一个样本
%     y : n * 1 向量, 每一行是一个标签
%     w : n * 1 向量, 权重
%
% 输出
%     j : 最优的维度
%     a : 最优的阈值
%     d : 最优的d，-1或者+1

% 请注意优化代码
%%% 请补全代码 %%%
	[nSamples,nFeatures] = size(X);
	FeatureBest = zeros(3,nFeatures); %Record each Feature's best Out,A,d
	Xinput = zeros(nSamples,1);
	for m = 1:nFeatures
		Xinput = X(:,m);
		AllThreshold = unique(Xinput) .';
		Pos1Out = double(Xinput-AllThreshold>0 )*(-2)+1; % d=1,the result of classfication
		ErrPosOut = w.' * (Pos1Out - y ~= 0); 
		NegD = (ErrPosOut > 0.5);
		ErrPosOut(NegD) = 1 - ErrPosOut(NegD);
		DOut = double(NegD)*(-2)+1;
		[OutMin,loc] = min(ErrPosOut);
		FeatureBest(:,m) = [OutMin;AllThreshold(loc);DOut(loc)];
	end
	[tmp,j] = min(FeatureBest(1,:));
	a = FeatureBest(2,j);
	d = FeatureBest(3,j);
%%% 请补全代码 %%%
end