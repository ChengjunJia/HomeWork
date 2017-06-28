function [trainErr, testErr] = adaboost(Xtrain, ytrain, Xtest, ytest, M)
% adaboost: ѵ���ܹ�M����������AdaBoost
%
% ���� 
%     Xtrain : n * p ����, ѵ������
%     ytrain : n * 1 ����, ѵ����ǩ
%     Xtest  : nt * p ����, ��������
%     ytest  : nt * 1 ����, ���Ա�ǩ
%     M : ����������Ŀ
%
% ���
%     e_train : M * 1 ����, ѵ�����ݵĴ�����
%     e_test  : M * 1 ����, �������ݵĴ�����


w = (1 / size(ytrain, 1)) * ones(size(ytrain)); % ��ʼ��Ȩֵ

j = zeros(M, 1);
a = zeros(M, 1);
d = zeros(M, 1);
c = zeros(M, 1);

trainErr = zeros(M, 1);
testErr = zeros(M, 1);
for m = 1: M
    [j(m), a(m), d(m)] = decision_stump(Xtrain, ytrain, w);
    fprintf( '�ҵ��ľ�����׮ j:%d a:%d, d:%d\n', j(m), a(m), d(m));
    
    e = decision_stump_error(Xtrain, ytrain, j(m), a(m), d(m), w);
    c(m) = log((1 - e) / e);
    w = update_weights(Xtrain, ytrain, j(m), a(m), d(m), w, c(m));
    
    trainErr(m) = adaboost_error(Xtrain, ytrain, j, a, d, c);
    testErr(m) = adaboost_error(Xtest, ytest, j, a, d, c);
    fprintf( '������׮�Ĵ�����: %f\nAdaBoost��ѵ��������: %f\n���Դ�����: %f\n\n', e, trainErr(m), testErr(m));
end

end