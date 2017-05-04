%读取文件
FileX = 'X.txt';
FileY = 'Y.txt';
load(FileX),load(FileY);
x0 = [ones(size(X,1),1) X];
y0 = Y;
%进行回归和预测
variable = regress(y0,x0);
variable
[1 110 3 1]*variable
%计算决定系数
yp = x0 * variable;
ybar = mean(y0);
corr1 = sum( (yp-ybar) .^2)/sum( (y0-ybar) .^2);
%考虑交叉项
x3 = [ones(size(X,1),1) X X(:,1).*X(:,2)];
var3 = regress(y0,x3);
yp3 = x3 * var3;
corr3 = sum( (yp3-ybar) .^2)/sum( (y0-ybar) .^2);
[1 110 3 1 110*3] * var3
%去掉一些项
x4 = [ones(size(X,1),1) X(:,2) X(:,3) X(:,1).*X(:,2) X(:,1).*X(:,3)];
var4 = regress(y0,x4);
yp4 = x4 * var4;
corr4 = sum( (yp4-ybar) .^2)/sum( (y0-ybar) .^2);
[1 3 1 110*3 110*1] * var4
