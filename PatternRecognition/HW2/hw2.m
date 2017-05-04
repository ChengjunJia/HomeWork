%HW2
allerr = zeros(50,4);
for m = 1:50
    allerr(m,:) = main();
end

function er = main()
    load('Breast_Cancer_Wisconsin_data.txt');
    InData = Breast_Cancer_Wisconsin_data;
    XAll = InData(:,2:10); 
    YAll = (InData(:,11)-2) ./2;
    nAll = size(XAll,1);
    nTest = uint32(0.7*nAll);
    Choice = randperm(nAll);
    XTrain = XAll(Choice(1:nTest),:);
    YTrain = YAll(Choice(1:nTest),:);
    XTest = XAll(Choice( (nTest+1):nAll),:);
    YTest = YAll(Choice( (nTest+1):nAll),:);

    %% logisticRegress
    w0 = rand(size(XTrain,2)+1,1);
    weight = logisticRegressionWeights( XTrain,YTrain,w0,1000,0.1);
    res = logisticRegressionClassify(XTest,weight);
    [temp1,per1] = ShowErr(YTest,res);
    
    %% Fisher
    [Fisherw,Fisherw0] = Fisher(XTrain,YTrain);
    res2 = FisherClassify(XTest,Fisherw,Fisherw0);
    [temp2,per2]= ShowErr(YTest,res2);
    er = [per1 per2 temp1 temp2];
end
%% Show the errors
function [err,percentage] = ShowErr(yReal,yCal)
    errors = abs(yReal-yCal);
    err = sum(errors);
    percentage = 1-err/size(yReal,1);
    disp('err='),disp(err);
    disp('percentage='),disp(percentage);
end

%% Fisher Calculate Function
function result = FisherClassify( xTest, w, w0 )
    res = w'*xTest'+w0;
    result = (res<0)';
end

%%  Fisher Function to Calculate the w and w0 (with inv(S_w) )
function [w,w0] = Fisher(xTest,yTest)
% ybar=w'*x+w0, ybar>0 ==> x<-w1,y=0
% 
    logic0 = (yTest == 0 );
    logic1 = (yTest == 1 );
    x0 = xTest(logic0,:);
    x1 = xTest(logic1,:);
    m0 = mean(x0);
    m1 = mean(x1);
    nFeature = size(m0',1);
    Sw = zeros(nFeature,nFeature);
    for m = 1:size(x0,1)
        temp = x0(m,:) -m0;
        Sw = Sw+temp' * temp;
    end
    for m = 1:size(x1,1)
        temp = x1(m,:)-m1;
        Sw = Sw+temp' * temp;
    end
    w = Sw\(m0-m1)';
    w0 = -1/2*(m0+m1)*w;%-log(size(x1,1)/size(x0,1));
end
