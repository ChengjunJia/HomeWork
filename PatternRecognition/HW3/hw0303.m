%HW3
allerr = zeros(50,4);
load('Breast_Cancer_Wisconsin_data.txt');
InData = Breast_Cancer_Wisconsin_data;
XAll = InData(:,2:10); 
YAll = (InData(:,11)-2) ./2;%0:Benign/gentle,1:Malignant
nAll = size(XAll,1);
nTest = uint32(0.7*nAll);
Choice = randperm(nAll);

XTrain = XAll(Choice(1:nTest),:);
YTrain = YAll(Choice(1:nTest),:);
XTest = XAll(Choice( (nTest+1):nAll),:);
YTest = YAll(Choice( (nTest+1):nAll),:);

%% Fisher
Fisherw = Fisher(XTrain,YTrain);
XFisherTrain = XTrain*Fisherw;
Fisherw = Fisherw / sqrt( sum(Fisherw .^2 ) );% ||w||_2 = 1
XSamplew0 = XFisherTrain( find(YTrain==0) );%Samples belong to Y=0
XSamplew1 = XFisherTrain( find(YTrain==1) );%Samples belong to Y=1
P0 = size(XSamplew0)/size(XFisherTrain);
P1 = size(XSamplew1)/size(XFisherTrain);

XFisherTest = XTest*Fisherw;
PFisherTestw0 = XFisherTest;
PFisherTestw1 = XFisherTest;
for m = 1:size(XFisherTest)
	PFisherTestw0(m) = KernalP(XFisherTest(m),XSamplew0);
	PFisherTestw1(m) = KernalP(XFisherTest(m),XSamplew1);
end

disp(['Test Sample:',num2str(size(YTest,1)) ]),

YMW = log( PFisherTestw0 ./ PFisherTestw1 ) < log(1);
disp('P(w_0)=P(w_1):'),
disp( ['	 All:', num2str(sum(abs(YMW-YTest))) ] ),
disp( ['	 False Postive:', num2str(sum(YMW-YTest>0)) ] ),

YMW2 = log( PFisherTestw0 ./ PFisherTestw1 ) < log(size(XSamplew1,1)/size(XSamplew0,1));
disp('P(w_0),P(w_1) From the Sample:'),
disp( ['	 All:', num2str(sum(abs(YMW2-YTest)) )] ),
disp( ['	 False Postive:', num2str(sum(YMW2-YTest>0)) ] ),


YLL = log( PFisherTestw0 ./ PFisherTestw1 ) < log(10/1);
disp('P(w_0)=P(w_1),Least Loss:'),
disp( ['	 All:', num2str(sum(abs(YLL-YTest))) ] ),
disp( ['	 False Postive:', num2str(sum(YLL-YTest>0)) ] )

YLL2 = log( PFisherTestw0 ./ PFisherTestw1 ) < log(10/1*size(XSamplew1,1)/size(XSamplew0,1));
disp('P(w_0),P(w_1)From the Sample,Least Loss:'),
disp( ['	 All:', num2str(sum(abs(YLL2-YTest))) ] ),
disp( ['	 False Postive:', num2str(sum(YLL2-YTest>0)) ] ),

%Calculate the plot of two lines(possibilty of the x|w0)
test = -5:0.001:5;
py0 = test; py1 = test;
for m = 1:size(test,2)
 py0(m) = KernalP(test(m),XSamplew0);
 py1(m) = KernalP(test(m),XSamplew1);
end
figure,plot(test,py0),
hold on;plot(test,py1),
legend('Y=0','Y=1');

%Calculate the plot of two lines(possibilty of the x|w0)
test = -1:0.0001:1;
py0 = test; py1 = test;
for m = 1:size(test,2)
 py0(m) = KernalP(test(m),XSamplew0);
 py1(m) = KernalP(test(m),XSamplew1);
end
figure,plot(test,py0),
hold on;plot(test,py1),
legend('Y=0','Y=1');


%%Kernal Density
function [poss] = KernalP(x,XSample)
	sigma = 1;
	poss = mean( 1/(sqrt(2*pi)*sigma)*exp(-(x-XSample) .^2/(2*sigma^2)) );
end

%%  Fisher Function to Calculate the w (with inv(S_w) )
function [w] = Fisher(xT,yT)
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
end
