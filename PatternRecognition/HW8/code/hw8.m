% HW8
% ——ChengjunJia,2007-5-30
% Pattern Recognize
%% HW1
Distance = [	0  1.75  4.25  6  15.50  3.66  12.75  6.35
				1.75  0  2.5  3.25  8.33  8.15  16.07  8.25
				4.25  2.5  0  11.75  5.57  15.75  27.1  12
				6  3.25  11.75  0  17  16.75  24.33  17.07
				15.50  8.33  5.57  17  0  9.66  11  14.9
				3.66  8.15  15.75  16.75  9.66  0  6.15  8.7
				12.75  16.07  27.1  24.33  11  6.15  0  11
				6.35  8.25  12  17.07  14.9  8.7  11  0];
% MDS By ChengJunJia            
[nSamples,nFeatures] = size(Distance);
J = eye(nSamples) - 1/nSamples*ones(nSamples,nSamples);
B = -1/2*(J*Distance.^2*J);
[U,Delta] = eig(B);
[Delta,loc] = sort(sum(Delta),'descend');
U = U(:,loc);
Deltan = diag(Delta(1:2));
Un = U(:,1:2);
Xn2 = Un*sqrt(Deltan);
Xn = Xn2;
figure,plot(Xn(:,1),-Xn(:,2),'o-');
name = {'武汉','郑州','北京','周口','运城','十堰','汉中','重庆'};
text(Xn(:,1)+0.1,-Xn(:,2),name);
title('Write By Self,MDS');
% MDS By MATLAB
OutX = mdscale(Distance,2);
Xn = OutX;
figure,plot(-Xn(:,1),Xn(:,2),'o-');
name = {'武汉','郑州','北京','周口','运城','十堰','汉中','重庆'};
text(-Xn(:,1)+0.1,Xn(:,2),name);
title('MATLAB Function,MDS');
%% HW2
load('Data2.mat');
%Data Normalize
testX = reshape(testX,size(testX,1),[]);
trainX = reshape(trainX, size(trainX,1),[]);
% PCA
[COEFF,SCORE,lantent] = pca(trainX);
pcaData = SCORE(:,1:2);
figure,gscatter(pcaData(:,1),pcaData(:,2),trainY),title('PCA');
%% TSNE
no_dims = 2;
initial_dims = 50;
perplexity = 30;
% loc = randperm(size(trainX,1));
% loc = loc(1:1000);
TXn = trainX;
TYn = trainY;
mappedX = tsne(TXn,[],no_dims,initial_dims,perplexity);
figure,gscatter(mappedX(:,1),mappedX(:,2),TYn),title('T-SNE');
%% LLE
lleX = lle(TXn',60,2);
figure,gscatter(lleX(1,:),lleX(2,:),TYn),title('LLE');


%% C
X = [trainX;testX];
Y = [trainY;testY];
[coff,score,lan] = pca(X);
loc = find(cumsum(lan)./sum(lan)>0.99,1);
pcaX = score(:,1:loc);
lleX = lle(X',60,296);
lleX = lleX';
tsneX = tsne(X,[],no_dims,initial_dims,perplexity);
%%
Yn = zeros(size(Y,1),5);
for m = 0:4
   loc = (Y==m);
   Yn(loc,m+1) = 1;
end
%%
trainNum = size(trainX,1);
testNum = size(testX,1);
tempX = pcaX;
TrainX = tempX(1:trainNum,:);
TestX = tempX((trainNum+1):end,:);
TrainY = Yn(1:trainNum,:);
TestY = Yn((trainNum+1):end,:);
%% HW3
load('Data3.mat');
X = featureselectionX;
Y = featureselectionY;
svmStruct = fitcsvm(X,Y,'CrossVal','on');%,'Standardize',true);%,'KernelFunction','rbf','KernelScale','auto');
classLoss = kfoldLoss(svmStruct,'lossfun','classiferror');
ErrOut = zeros(size(X,2),1);
for m = 1:size(X,2)
    svmStruct = fitcsvm(X(:,m),Y,'CrossVal','on');
    ErrOut(m) = kfoldLoss(svmStruct);
end

%%
[ErrNew,loc] = sort(ErrOut);
for m = 1:8
    svmStruct = fitcsvm(X(:,loc(1:m)),Y,'CrossVal','on');
    ErrNewOut(m) = kfoldLoss(svmStruct);
end

%% 
tic
AimNum = 3;
locN = [48;917;5;220;323;129;315;630;19;9];
ErrIn = ones(8,size(X,2));
for m = 1:AimNum
    for n = 1:size(X,2)
        if find( locN==n )
            continue;
        else
            tmp = [locN;n];
            svmStruct = fitcsvm(X(:,tmp),Y,'CrossVal','on');
            ErrIn(m,n) = kfoldLoss(svmStruct);
        end
    end
[~,locAdd] = min(ErrIn(m,:));
locN = [locN;locAdd];
end
toc
%% 
for m = 1:size(locN,1)
    svmStruct = fitcsvm(X(:,locN(1:m)),Y,'CrossVal','on');
    Err(m) = kfoldLoss(svmStruct);
end