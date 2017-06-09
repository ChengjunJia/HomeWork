function e = adaboost_error(X, y, j, a, d, c)
% adaboost_error: ����AdaBoost�������Ĵ�����
% 
% ����
%     X     : n * p ����,ÿһ����һ������
%     y     : n * 1 ������ÿһ����һ����ǩ
%     j     : M * 1 ����, ��ѡ������ά��
%     a     : M * 1 ����, ��ѡ����ֵ
%     d     : M * 1 ����, 1 �� -1
%     c     : M * 1 ����,������������Ȩ��
%
% ���
%     e     : ������      

%%% �벹ȫ���� %%%
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
%%% �벹ȫ���� %%%
end