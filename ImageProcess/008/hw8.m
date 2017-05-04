%%hw8

%读取图片
I = imread('hw8.tif');
Id = im2double(I);
[row col] = size(I);
allnum = row*col;

%进行种子区域、待选点、判断条件的初始化操作

%time = 1;
aimRegion = false(row,col);
near = false(row,col);
GivenT = 10.0/255;
aimRegion(120,120) = 1;
loc = find(aimRegion == 1);
near(loc+1)=1;	near(loc-1)=1;
near(loc+row)=1;near(loc-row)=1;
average = Id(loc);

while(true)
	%找到目标点的坐标，计算其灰度差
	bxloc = find(near(:));
	bxvalue = abs(Id(bxloc)-average);
	
	%寻找灰度差最小值点，判断是否终止生长
	[C,loc] = min(bxvalue);
	if( C > GivenT ) break; end
	
	%更新种子区域、待选点、灰度平均值
	aimloc = bxloc(loc(1));
	aimRegion(aimloc) = 1;
	near(aimloc)=0;
	if(aimloc+1<=allnum && ~aimRegion(aimloc+1) ) near(aimloc+1)=1; end
	if(aimloc+row<=allnum && ~aimRegion(aimloc+row) ) near(aimloc+row) = 1; end
	if(aimloc-1>0 && ~aimRegion(aimloc-1) ) near(aimloc-1)=1; end
	if(aimloc-row>0 && ~aimRegion(aimloc-row) ) near(aimloc-row) = 1; end	
	average = (average*time+double(Id(aimloc)))/(time+1);
	%time = time+1;
end

figure,imshow(aimRegion),title('Background');
figure,imshow(double(~aimRegion) .* Id),title('Aim Area');

%for m = 1:size(bxloc,1)
		% loc = bxloc(m);
		% if( loc-1>0 && aimRegion(loc-1) ) bxvalue(m) = abs( Id(loc) - Id(loc-1) ); else bxvalue(m) = 1; end
		% if( loc+1<=allnum && aimRegion(loc+1) ) bxvalue(m) = min(bxvalue(m),abs( Id(loc)-Id(loc+1))); end
		% if( loc-row>0 && aimRegion(loc-row) ) bxvalue(m) = min(bxvalue(m),abs( Id(loc)-Id(loc-row) )); end
		% if( loc+row<=allnum && aimRegion(loc+row) ) bxvalue(m) = min(bxvalue(m),abs( Id(loc)-Id(loc+row) )); end
% end
	% min1 = min(bxvalue);
	
	