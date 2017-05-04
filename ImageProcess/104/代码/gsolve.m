%
% gsolve.m: Solve for imaging system response function
% 
% Based On:  (Reference) Debevec, Paul E., and Jitendra Malik. "Recovering high dynamic range radiance maps from photographs."
% Author: ChengJun`Jia 
% Create on 2017-01-07
% 
% Assumes:
%
% Zmin = 0
% Zmax = 255
%
% Arguments:
%
% Z(i,j) is the pixel values of pixel location number i in image j
% t(j) is the log delta t, or log shutter speed, for image j
% l is the constant that determines the amount of smoothness
% w(z) is the weighting function value for pixel value z
%
% Returns:
%
% g(z) is the log exposure corresponding to pixel value z
% lE(i) is the log film irradiance at pixel location i
%
% Left to complete: solve the equation with SVD --> QR/Least-Multi
function [g,lE] = gsolve(Z,t,l,w)
	ColorNum = 256;
	PixelNum = size(Z,1); % Num of the pixel
	ImageNum = size(Z,2); % Num of the image
	A = zeros( PixelNum*ImageNum+ColorNum+1,PixelNum+ColorNum );
	b = zeros( size(A,1),1 );
	k = 1;
	
	% Each Pixel
	for m = 1:PixelNum
		for n = 1:ImageNum
			Wz = w(Z(m,n)+1); % weighting value
			A(k,Z(m,n)+1) = Wz;
			A(k,ColorNum+m) = -Wz;
			b(k,1) = Wz*t(n);
			k = k+1;
		end
	end

	% Force the middle color 129 -> 0
	A(k,129) = 1;
	k = k+1;

	k = k+1;
	% Each smoothness
	for m = 2:ColorNum-1
		Wz = w(m);
		A(k,m-1) = l*Wz;
		A(k,m) = -2*l*Wz;
		A(k,m+1) = l*Wz;
		k = k+1;
	end

	x = A\b;
	g = x(1:ColorNum);
	lE = x(ColorNum+1:size(x,1));

end
