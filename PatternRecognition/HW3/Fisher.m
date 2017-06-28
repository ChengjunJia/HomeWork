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
	w = w/sum(w .^2);
	w0 = -1/2*(m0+m1)*w;
	if m0*w+w0 >0
		w = -w;
		w0 = -w0;
	end
end