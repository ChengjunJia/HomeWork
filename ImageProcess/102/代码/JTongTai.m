function [ output ] = JTongTai( inputIm,H )
%对inputIm做同态滤波，频域内同态滤波系数矩阵为H
%   output——输出图像
%   inputIm——输入图像
%   H——使用的系数矩阵

    Ifft = fftshift( fft2( log(1 + inputIm) ) );
    resultfft =  Ifft .* H ;
    output = exp( real( ifft2 ( ifftshift( resultfft) ) ))-1;

end