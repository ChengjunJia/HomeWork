function e = decision_stump_error(X, y, j, a, d, w)
% ����������׮�ͷ��ش�����
%
% Input
%     X : n * p ����, ÿһ�ж���һ������
%     y : n * 1 ����, ÿһ����һ����ǩ
%     j : ��ѡ����
%     a : ��ѡ��ֵ
%     d : 1 ���� -1
%
% ���
%     e : ������׮Ԥ����� 

p = ((X(:, j) <= a) - 0.5) * 2 * d; % predicted label
e = sum((p ~= y) .* w);

end