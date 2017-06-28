%%HW6
%% testResult
CoarseGaussRes = trainedClassifierCoarseGauss.predictFcn(TestX);
CubeRes = trainedClassifierCube.predictFcn(TestX);
FineGaussRes = trainedClassifierFineGaussian.predictFcn(TestX);
LinearRes = trainedClassifierLinear.predictFcn(TestX);
MediumGaussRes = trainedClassifierMediumGauss.predictFcn(TestX);
QuadraticRes = trainedClassifierQuadratic.predictFcn(TestX);

%% Compare the accuracy
PredictRes = [LinearRes QuadraticRes CubeRes FineGaussRes MediumGaussRes CoarseGaussRes];
RealRes = TestY.*2-1;
Err = PredictRes - RealRes;
totalWorry = sum(abs(Err)) ./ 2;
totalRate = totalWorry ./ 1991;

%% Find the false Postive and Negative
FalsePos = zeros(6,1);
FalseNeg = zeros(6,1);
for m = 1:6
   err = Err(:,m);
   FalsePos(m) = size(find(err>0),1);
   FalseNeg(m) = size(find(err<0),1);
end