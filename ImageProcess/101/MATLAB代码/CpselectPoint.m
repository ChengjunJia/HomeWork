%***手动选取匹配点程序——使用cpselect函数
%**********************************************

%寻找I1-I2配对点——原来存储的配对点为I12-1文件，把更改后的文件存储到I12文件中
disp('开始修正I1->I2的匹配点...');
im1 = imread('1.jpg');
im2 = imread('2.jpg');
im3 = imread('3.jpg');
flag = 1;
if flag == 1,
    load I12-1;
    I12 = reshape(I12_1,[],4);
    I1 = I12(:,1:2);
    I2 = I12(:,3:4);
    disp('I1->I2的匹配点原来点读取完毕...');
    [movingPoints,fixedPoints] = cpselect(im1,im2,I1,I2,'Wait',true);
    I12new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I12','w');
    fprintf(fnow,'%f\t',I12new);
    fclose(fnow);
    disp('I1->I2的匹配点存入完毕...');
    cpselect(im1,im2,movingPoints,fixedPoints);
    %寻找I2-I3配对点——原来存储的配对点为I32-1文件，把更改后的文件存储到I32文件中
    disp('开始修正I3->I2的匹配点');    
    load I32-1;
    I32 = reshape(I32_1,[],4);
    I3 = I32(:,1:2);
    I2 = I32(:,3:4);
    disp('I3->I2的匹配点原来点读取完毕...');
    [movingPoints,fixedPoints] = cpselect(im3,im2,I3,I2,'Wait',true);
    I32new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I32','w');
    fprintf(fnow,'%f\t',I32new);
    fclose(fnow);
    disp('I3->I2的匹配点存入完毕...');
    cpselect(im3,im2,movingPoints,fixedPoints);
else
    [movingPoints,fixedPoints] = cpselect(im1,im2,'Wait',true);
    I12new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I12','w');
    fprintf(fnow,'%f\t',I12new);
    fclose(fnow);
    disp('I1->I2的匹配点存入完毕...');
    cpselect(im1,im2,movingPoints,fixedPoints);
    [movingPoints,fixedPoints] = cpselect(im3,im2,'Wait',true);
    I32new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I32','w');
    fprintf(fnow,'%f\t',I32new);
    fclose(fnow);
    disp('I3->I2的匹配点存入完毕...');
    cpselect(im3,im2,movingPoints,fixedPoints);
end
