%% Pattern Recognize ---- Neural Pattern Recognize 
load('MNIST.mat');

%Data Normalize
testX1 = reshape(testX,size(testX,1),[]) ./255;
trainX1 = reshape(trainX, size(trainX,1),[]) ./255;
im_side = 28;

%% Show the image
% figure,
% for m = 1:10
	% loc = find(trainY(:,m));
	% aimX = trainX(loc,:,:);
	% loc2 = find( max(reshape(aimX,[],im_side*im_side),[],2) >=150,1);
	% subplot(2,5,m),
	% image = reshape( aimX(loc2,:,:),im_side,im_side );
	% imshow(image);
% end

%% Choose the '4' and '9', do the classify, '4'->0, '9'->1
testX4 = testX1( testY(:,5)==1,: );
testX9 = testX1( testY(:,10)==1,: );
trainX4 = trainX1( trainY(:,5)==1,: );
trainX9 = trainX1( trainY(:,10)==1,: ); 

TrainX = [ trainX4; trainX9 ];
TrainY = [ zeros(size(trainX4,1),1); ones(size(trainX9,1),1) ];
TestX = [ testX4; testX9 ];
TestY = [ zeros(size(testX4,1),1); ones(size(testX9,1),1) ];

%logistic Regression
tic
nFeature = im_side ^2;
w0 = rand(nFeature+1,1);
LogisticW = logisticRegressionWeights( TrainX, TrainY,w0,1000,0.1 );
LogisticRes = logisticRegressionClassify( TestX,LogisticW );
LogisticErr = sum( abs(LogisticRes - TestY) );
LogisticPercent = LogisticErr /size(TestX,1);
disp(string('Worry:')+string(LogisticPercent));
sum(LogisticRes>TestY)
sum(LogisticRes<TestY)
toc
%Fisher Regression
tic
[FisherW,FisherW0] = Fisher(TrainX,TrainY);
FisherRes = TestX*FisherW+FisherW0 > 0;
FisherErr = sum( abs(FisherRes-TestY) ); 
FisherPercent = FisherErr/size(TestX,1);
toc
%%%--Fisher Function to Calculate the w (with inv(S_w) )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Fisher.m
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w,w0] = Fisher(xT,yT)
% ybar=w'*x+w0, ybar>0 ==> x<-w1,y=0
% 
    logic0 = (yT == 0 );
    logic1 = (yT == 1 );
    x0 = xT(logic0,:);
    x1 = xT(logic1,:);
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
	w = w/sqrt( sum(w .^2) );
	w0 = -1/2*(m0+m1)*w;
	if m0*w+w0 >0
		w = -w;
		w0 = -w0;
	end
end

%%%--Logistic Regression Packets---
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     logisticRegressionWeights.m
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [w] = logisticRegressionWeights( XTrain, yTrain, w0, maxIter, learningRate)

    [nSamples, nFeature] = size(XTrain);
    w = w0;
    precost = 0;
    for j = 1:maxIter
        temp = zeros(nFeature + 1,1);
		Xreal = [ones(nSamples,1) XTrain];
%%Change to Matrix		
        % for k = 1:nSamples
            % temp = temp + (sigmoid( Xreal(k,:)* w) - yTrain(k)) * Xreal(k,:)';
        % end
		sig = sigmoid( Xreal*w ) - yTrain;
		sig2 = repmat(sig,size(1,nSamples+1));
		sig2 = sig2 .* Xreal;
		temp = sum(sig2)';
		w = w - learningRate * temp;
        cost = CostFunc(XTrain, yTrain, w);
        if j~=0 && abs(cost - precost) / cost <= 0.0001
            break;
        end
        precost = cost;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     logisticRegressionClassify.m
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ res ] = logisticRegressionClassify( XTest, w )

    nTest = size(XTest,1);
    res = zeros(nTest,1);
	res = sigmoid( [ones(nTest,1) XTest] *w ) >= 0.5;
	res = double(res);
    % for i = 1:nTest
        % sigm = sigmoid([1.0 XTest(i,:)] * w);
        % if sigm >= 0.5
            % res(i) = 1;
        % else
            % res(i) = 0;
        % end
    % end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     sigmoid.m
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Change the function to Matrix Calculate
% ChengjunJia 2017-4-2
function [ output ] = sigmoid( input )
    %output = tanh(input);
    output = ones(size(input)) ./ (1 + exp(- input));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     CostFunc.m
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ J ] = CostFunc( XTrain, yTrain, w )

    [nSamples, nFeature] = size(XTrain);
    temp = 0.0;
	logic1 = (yTrain == 1);
	hXtemp = sigmoid( [ones(nSamples,1) XTrain] *w);
	hx1 = hXtemp(logic1);
	hx2 = hXtemp(~logic1);
	temp = sum(log(hx1))+sum(log(1-hx2));
    %%Change to the matrix
	% for m = 1:nSamples
        % hx = sigmoid([1.0 XTrain(m,:)] * w);
        % if yTrain(m) == 1
            % temp = temp + log(hx);
        % else
            % temp = temp + log(1 - hx);
        % end
    % end
    J = temp / (-nSamples);

end