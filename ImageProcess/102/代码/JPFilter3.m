function [ OutIm ] = UserJFilter3( InIm,B )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    OutIm = InIm;
    for i = 1:3
        OutIm(:,:,i) = medfilt2(InIm(:,:,i),B);
    end
end