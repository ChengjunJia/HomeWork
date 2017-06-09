%% Data
trainXin = reshape(trainX,60000,28*28);
testXin = reshape(testX,10000,28*28);
LocTrain4 = find(trainY(:,4));
LocTrain9 = find(trainY(:,9));
trainX4 = trainXin(LocTrain4,:);
trainX9 = trainXin(LocTrain9,:);

LocTest4 = find(testY(:,4));
LocTest9 = find(testY(:,9));
testX4 = testXin(LocTest4,:);
testX9 = testXin(LocTest9,:);

TrainX = [trainX4;trainX9];
TrainY = [ones(size(trainX4,1),1);(-1)*ones(size(trainX9,1),1)];

TestX = [testX4;testX9];
TestY = [ones(size(testX4,1),1);(-1)*ones(size(testX9,1),1)];

loc = randperm(size(TrainY,1));
inloc = loc(1:500);
TrainInX = TrainX(inloc,:);
TrainInY = TrainY(inloc,:);

TrainAll = [TrainInY TrainInX];
TrainUse = TrainAll(1:400,:);
TestUse = TrainAll(401:500,:);

%% train adaboost
[trainErr,testErr] = adaboost(TrainInX,TrainInY,TestX,TestY,200);