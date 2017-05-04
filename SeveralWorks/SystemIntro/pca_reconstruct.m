%% Function: Feedback the compressed data
% pcs  各个主成分，每一列为一个主成分
% cprs_data  压缩后的数据，每一行对应一个数据点
% cprs_c 压缩时的一些常数，包括数据每一维的均值和方差等。利用以上三个变量应当可以恢复出原始的数据

% data  输入的原始数据矩阵，每一行对应一个数据点
function recon_data = pca_reconstruct(pcs, cprs_data, cprs_c)
	recoverdate1 = cprs_data * pcs';
	recon_data = recoverdate1 .* cprs_c(2,:) + cprs_c(1,:);
end