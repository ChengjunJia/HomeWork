function [ output ] = JTongTai( inputIm,H )
%��inputIm��̬ͬ�˲���Ƶ����̬ͬ�˲�ϵ������ΪH
%   output�������ͼ��
%   inputIm��������ͼ��
%   H����ʹ�õ�ϵ������

    Ifft = fftshift( fft2( log(1 + inputIm) ) );
    resultfft =  Ifft .* H ;
    output = exp( real( ifft2 ( ifftshift( resultfft) ) ))-1;

end