function e = adaboost_error(X, y, j, a, d, c)
% adaboost_error: 返回AdaBoost分类器的错误率
% 
% 输入
%     X     : n * p 矩阵,每一行是一个样本
%     y     : n * 1 向量，每一行是一个标签
%     j     : M * 1 向量, 所选的特征维度
%     a     : M * 1 向量, 所选的阈值
%     d     : M * 1 向量, 1 或 -1
%     c     : M * 1 向量,各个分类器的权重
%
% 输出
%     e     : 错误率      

%%% 请补全代码 %%%
n = length(y);
loc = find(c);
M = length(loc);
jR = j(loc);
aR = a(loc);
dR = d(loc);
cR = c(loc);
TreeOut = zeros(size(y));
for m = 1:M
	TreeOut = TreeOut + ( ( (X(:,jR(m)) <= aR(m))*2-1 ) .* dR(m) )*cR(m);
end
RealOut = double(TreeOut>=0)*2-1;
e = sum(RealOut~=y) / n;
%%% 请补全代码 %%%
end