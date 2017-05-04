%***�ֶ�ѡȡƥ�����򡪡�ʹ��cpselect����
%**********************************************

%Ѱ��I1-I2��Ե㡪��ԭ���洢����Ե�ΪI12-1�ļ����Ѹ��ĺ���ļ��洢��I12�ļ���
disp('��ʼ����I1->I2��ƥ���...');
im1 = imread('1.jpg');
im2 = imread('2.jpg');
im3 = imread('3.jpg');
flag = 1;
if flag == 1,
    load I12-1;
    I12 = reshape(I12_1,[],4);
    I1 = I12(:,1:2);
    I2 = I12(:,3:4);
    disp('I1->I2��ƥ���ԭ�����ȡ���...');
    [movingPoints,fixedPoints] = cpselect(im1,im2,I1,I2,'Wait',true);
    I12new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I12','w');
    fprintf(fnow,'%f\t',I12new);
    fclose(fnow);
    disp('I1->I2��ƥ���������...');
    cpselect(im1,im2,movingPoints,fixedPoints);
    %Ѱ��I2-I3��Ե㡪��ԭ���洢����Ե�ΪI32-1�ļ����Ѹ��ĺ���ļ��洢��I32�ļ���
    disp('��ʼ����I3->I2��ƥ���');    
    load I32-1;
    I32 = reshape(I32_1,[],4);
    I3 = I32(:,1:2);
    I2 = I32(:,3:4);
    disp('I3->I2��ƥ���ԭ�����ȡ���...');
    [movingPoints,fixedPoints] = cpselect(im3,im2,I3,I2,'Wait',true);
    I32new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I32','w');
    fprintf(fnow,'%f\t',I32new);
    fclose(fnow);
    disp('I3->I2��ƥ���������...');
    cpselect(im3,im2,movingPoints,fixedPoints);
else
    [movingPoints,fixedPoints] = cpselect(im1,im2,'Wait',true);
    I12new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I12','w');
    fprintf(fnow,'%f\t',I12new);
    fclose(fnow);
    disp('I1->I2��ƥ���������...');
    cpselect(im1,im2,movingPoints,fixedPoints);
    [movingPoints,fixedPoints] = cpselect(im3,im2,'Wait',true);
    I32new = [movingPoints fixedPoints];
    fnow = fopen('E:\MATLAB\I32','w');
    fprintf(fnow,'%f\t',I32new);
    fclose(fnow);
    disp('I3->I2��ƥ���������...');
    cpselect(im3,im2,movingPoints,fixedPoints);
end
