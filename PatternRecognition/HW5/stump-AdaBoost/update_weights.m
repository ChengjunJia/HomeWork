function w_update = update_weights(X, y, j, a, d, w, c)
% ����Ȩֵ
% 
% ����
%     X        : n * p ����ÿһ����һ��ѵ������
%     y        : n * 1 ������ÿһ����һ��ѵ����ǩ
%     j        : ��ѡ�������ά��
%     a        : ��ѡ��ֵ
%     d        : 1 �� -1
%     w        : n * 1 ����, ԭ����Ȩֵ
%     c        : ��һ����������alpha_t
%
% Output
%     w_update : n * 1 ����, ���¹����Ȩֵ

%%% �벹ȫ���� %%%
	TreeOut = d*(double(X(:,j) <= a)*2-1);
	IsWorry = (TreeOut~=y);
	wn = w .* exp(c*IsWorry);
	w_update = wn ./ sum(wn);

%%% �벹ȫ���� %%%
end