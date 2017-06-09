function [j, a, d] = decision_stump(X, y, w)
% �Ż�������׮�Ĳ���
% 
%
% ����
%     X : n * p ����, ÿһ����һ������
%     y : n * 1 ����, ÿһ����һ����ǩ
%     w : n * 1 ����, Ȩ��
%
% ���
%     j : ���ŵ�ά��
%     a : ���ŵ���ֵ
%     d : ���ŵ�d��-1����+1

% ��ע���Ż�����
%%% �벹ȫ���� %%%
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
%%% �벹ȫ���� %%%
end