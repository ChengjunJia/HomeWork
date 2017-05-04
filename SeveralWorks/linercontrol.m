%% Homework: Liner Control System

Q = [10^(-5) 0; 0 10^(-5)];
R = 10^(-1);
A = [1 1;0 1];
C = [1 0];
xstart = [0 pi/32];
P0 = [1 0;0 1];

num = 500;

Xrecord = zeros(num,2);
Precord = zeros(num,4,1);
Xreal = zeros(num,2);
Yreal = zeros(num,1);
Xreal(1,:) = xstart;
Yreal(1,1) = C*Xreal(1,:)'+random('norm',0,R,1,1);

Xrecord(1,:) = xstart; 
Precord(1,:,:) = reshape(P0,1,4,1);

for m = 1:num-1
    Xreal(m+1,:) = (A*Xreal(m,:)' + random('norm',0,10^(-5),2,1) )';
    Yreal(m+1,1) = C*Xreal(m+1,:)'+random('norm',0,R,1,1);
end

for m = 1:num-1
    xk1 = A*Xrecord(m,:)';
    Mk1 = A*P0 *A'+Q;
    Kk1 = Mk1*C'/(C*Mk1*C'+R);
    Xrecord(m+1,:) = (xk1+Kk1*(Yreal(m+1,1) - C*xk1))';
    P1 = Mk1-Kk1*C*Mk1;
    Precord(m+1,:,:) = reshape(P1,1,4,1);
    P0 = P1;
end

figure,
for m = 1:num
	clf;
	plot(cos(Xreal(m,1)),sin(Xreal(m,1)),'ro');
	hold on;
	plot(cos(Yreal(m,1)),sin(Yreal(m,1)),'go');
	hold on;
	plot(cos(Xrecord(m,1)),sin(Xrecord(m,1)),'b*');
	axis([-1,1,-1,1]);
	legend('Real','Observe','Kalman','Location','best');
	M(m) = getframe;
	pause(1);
end