function w_update = update_weights(X, y, j, a, d, w, c)
% 更新权值
% 
% 输入
%     X        : n * p 矩阵，每一行是一个训练样本
%     y        : n * 1 向量，每一行是一个训练标签
%     j        : 所选择的特征维度
%     a        : 所选阈值
%     d        : 1 或 -1
%     w        : n * 1 向量, 原来的权值
%     c        : 上一个分类器的alpha_t
%
% Output
%     w_update : n * 1 向量, 更新过后的权值

%%% 请补全代码 %%%
	TreeOut = d*(double(X(:,j) <= a)*2-1);
	IsWorry = (TreeOut~=y);
	wn = w .* exp(c*IsWorry);
	w_update = wn ./ sum(wn);

%%% 请补全代码 %%%
end