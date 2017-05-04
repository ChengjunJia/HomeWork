#include "JCJchangeway.h"

//定义整个图形的数据
uint Imrows;
uint Imcols;
uint Imchannels;

int main(){
	String sfilename = "1.png";
	Mat imgOrg = imread(sfilename,CV_LOAD_IMAGE_COLOR);
	Imrows = imgOrg.rows;
	Imcols = imgOrg.cols;
	Imchannels = imgOrg.channels();
	
	Mat newImg = imgOrg.clone();

	int CenterX = Imrows/2, CenterY = Imcols/2;
	double Irow = Imrows;
	double Isita =M_PI;
	P2PVec JPM;
	DistortMat(JPM,CenterX,CenterY,M_PI_2*0.6,DistortType::Inner);
	
	P2PVec TPSP2P;
	TPSP2P.push_back(PointToPoint(1,2,3,4));
	TPSP2P.push_back(PointToPoint(5,6,7,8));
	TPSMat(JPM,TPSP2P);
	newImg=CalNewIm(imgOrg,JPM,LINER);
	
	imshow("[Origin]",imgOrg);
	imshow("[New]",newImg);
	
	cvWaitKey(0);
}

double TPS_U ( Point2d p1, Point2d p2 )
{
	double r_2 = pow( p1.x-p2.x,2 ) +pow( p1.y-p2.y,2 );
	return r_2*log(r_2);
}

bool TPSMat ( P2PVec &JPM, const P2PVec ChoosePoint )
{/***************************

****************************/
	uint n = ChoosePoint.size();

	Mat K(n+3,n+3,CV_64F);
	for ( int i=0; i<n+3; i++ )
	{
		K.at<double>(i,i) = 0;
		for ( int j = i+1; j < n+3; j++)
		{
			if ( i>=n ) {
				K.at<double>(i,j) = K.at<double>(j,i) = 0;
			} else {
				if( j < n ) {
					K.at<double>(i,j) = K.at<double>(j,i)
						= TPS_U(Point2d(ChoosePoint.at(i).newx,ChoosePoint.at(i).newy),
								Point2d(ChoosePoint.at(j).newx,ChoosePoint.at(j).newy) );
				} else if ( j == n ) {
					K.at<double>(i,j) = K.at<double>(j,i) = 1;
				} else if ( j == n+1 ) {
					K.at<double>(i,j) = K.at<double>(j,i) = ChoosePoint.at(i).newx;
				} else if ( j == n+2 ) {
					K.at<double>(i,j) = K.at<double>(j,i) = ChoosePoint.at(i).newy;
				}
			}
		}
	}
	//cout<<"K="<<endl<<K<<endl;
	Mat Y(n+3,2,CV_64F);
	for( int i =0; i<n+3;i++ )
	{
		if ( i>=n ){
			Y.at<double>(i,1) = Y.at<double>(i,0) = 0;
		} else {
			Y.at<double>(i,0) = ChoosePoint.at(i).oldx;
			Y.at<double>(i,1) = ChoosePoint.at(i).oldy;
		}
	}
	//cout<<"Y="<<endl<<Y<<endl;
	Mat W(n+3,2,CV_64F);
	solve(K,Y,W,DECOMP_SVD);
	//cout<<"W="<<endl<<W<<endl;
	double tempx,tempy;
	JPM.clear();
	JPM.reserve((Imrows+1)*(Imcols+1));
	for ( uint i=0; i<Imrows; i++ )
	{
		for ( uint j=0; j<Imcols; j++ )
		{
			tempx = 0;
			tempy = 0;
			for ( uint k=0; k<n; k++ )
			{
				tempx += W.at<double>(k,0)*TPS_U ( Point2d(ChoosePoint.at(k).newx,ChoosePoint.at(k).newy),
											Point2d( i,j ) );
				tempy += W.at<double>(k,1)*TPS_U ( Point2d(ChoosePoint.at(k).newx,ChoosePoint.at(k).newy),
											Point2d( i,j ) );
			}
			tempx += W.at<double>(n,0) + W.at<double>(n+1,0)*i + W.at<double>(n+2,0)*j;
			tempy += W.at<double>(n,1) + W.at<double>(n+1,1)*i + W.at<double>(n+2,1)*j;
			PointToPoint tempPoint2;
			tempPoint2.oldx = tempx;
			tempPoint2.oldy = tempy;
			tempPoint2.newx = i;
			tempPoint2.newy = j;
			JPM.push_back(tempPoint2);
		}
	}
	return true;
}

bool DistortMat( P2PVec &JPM, const uint CenterX, const uint CenterY, const double SitaMax, DistortType distype ) 
{ /***********************************************
计算扭曲变形对应的映射矩阵，需要变量Imrows和Imcols提前知道
--输入:	中心点CenterX,CenterY
		扭曲度 SitaMax
		扭曲类型 distype(向内向外)
--输出:	JPM映射矩阵:表示新的点(newx,newy)和原来的点(x,y)的位置对应关系
--使用计算公式：newR = oldR*(1+D);其中D是扭曲度（使用的拟合公式为 （sita-TanSita）/TanSita )
***********************************************/
	JPM.clear();
	JPM.reserve((Imrows+1)*(Imcols+1));
	//清理并重置映射矩阵大小
	double r,sita,TanSita,D,RMax;//定义畸变率D,
	int polarX,polarY;
	
	uint Xmax = (CenterX > Imrows-1-CenterX)?CenterX:Imrows-1-CenterX;
	uint Ymax = (CenterY > Imcols-1-CenterY)?CenterY:Imcols-1-CenterY;
	RMax = sqrt( Xmax*Xmax + Ymax*Ymax );
	//计算RMax,用于计算变换
	
	for( uint i=0; i<Imrows; i++){
		for( uint j=0; j<Imcols; j++) {
			PointToPoint PointNewtemp;
			
			PointNewtemp.newx = i;
			PointNewtemp.newy = j;//原来的点定义在newx,newy内
			
			polarX = i-CenterX;
			polarY = j-CenterY;//计算在中心点下的新的坐标
			
			r = sqrt( polarX*polarX+ polarY*polarY);//计算新的坐标系下的r的大小
			
			TanSita = r*tan(SitaMax)/RMax;
			sita = atan(TanSita);
			D = ( sita-TanSita )/TanSita;//计算每一个点对应的畸变系数
			if( distype == Inner ) D = 0-D;
			PointNewtemp.oldx = polarX*(1+D)+CenterX;
			PointNewtemp.oldy = polarY*(1+D)+CenterY;
			JPM.push_back(PointNewtemp);
		}
	}
	return true;
}

bool RorateMat ( P2PVec &JPM,const uint CenterX, const uint CenterY, const double Irow,const double Isita) 
{
/***********************************************
计算旋转扭曲对应的映射矩阵，需要变量Imrows和Imcols提前知道
--输入:	旋转中心点CenterX,CenterY
		旋转的范围和角度:Irow,Isita
--输出:	JPM映射矩阵:表示新的点(newx,newy)和原来的点(x,y)的位置对应关系
--使用计算公式：Px = polarX*cos(m)+polarY*sin(m); Py = polarY*cos(m)-polarX*sin(m);
***********************************************/
	JPM.clear();
	JPM.reserve((Imrows+1)*(Imcols+1));	//清理并重置映射矩阵大小
	
	double Px,Py,r,m;
	int polarX,polarY;
	
	for( uint i=0; i<Imrows; i++){
		for( uint j=0; j<Imcols; j++){
			PointToPoint PointNewtemp;
			
			PointNewtemp.newx = i;
			PointNewtemp.newy = j;//原来的点定义在newx,newy内
			
			polarX = i-CenterX;
			polarY = j-CenterY;//计算在旋转中心点下的新的坐标
			
			r = sqrt( polarX*polarX+ polarY*polarY);//计算新的坐标系下的r的大小
			
			if( r<=Irow ){
				//在旋转的范围内,则计算新的对应点
				m = Isita *(Irow-r)/Irow;
				Px = polarX*cos(m)+polarY*sin(m);
				Py = polarY*cos(m)-polarX*sin(m);
				PointNewtemp.oldx = Px + CenterX;
				PointNewtemp.oldy = Py + CenterY;
			}else{
				//旋转范围外,则保持不变
				PointNewtemp.oldx = i;
				PointNewtemp.oldy = j;
			}
			JPM.push_back(PointNewtemp);
		}
	}
	return true;
}

Mat CalNewIm ( Mat oldIm, P2PVec const &PVold, Interpolation interpole ) 
{ /**********************************
使用插值方法计算变换后的图像像素值
--输入:	原来图像 oldIm
		变换矩阵 PVold(按照新图像的像素位置存储映射关系,便于查找)
		使用的差值方法 interpole
--输出:	新的图像 newIm
**************************************/
	double px,py;
	Vec3d f00,f01,f10,f11;
	
	uint Imrows = oldIm.rows;
	uint Imcols = oldIm.cols;
	Mat newIm = oldIm.clone();
	
	double u,v;
	for ( uint i =0 ;i<Imrows; i++) {
		Vec3b* data = newIm.ptr<Vec3b>(i);
		for ( uint j=0; j<Imcols; j++) 
		{
			px = PVold.at(i*Imrows+j).oldx;
			py = PVold.at(i*Imrows+j).oldy;//取出对应的原来点的坐标
			
			if( px<0 || px > Imrows-1 || py<0 || py> Imcols-1 )
			{
				data[j] = 0;//不落在插值区间，则置为0
			} else {
				//取小于px py的最大值
				uint x0 = floor(px);
				uint y0 = floor(py);
				
				if(x0 == px && y0==py ) 
				{//不需要进行插值
					data[j] = oldIm.at<Vec3b>(x0,y0);
				}else{
					//取出临近的点的函数值,并计算插值的u,v
					f00 = oldIm.at<Vec3b>(x0,y0);
					f01 = oldIm.at<Vec3b>(x0,y0+1);
					f10 = oldIm.at<Vec3b>(x0+1,y0);
					f11 = oldIm.at<Vec3b>(x0+1,y0+1);
					u = px-x0;
					v = py-y0;
					if( interpole == LINER )
					{//使用双线性插值
						data[j] = ((1-u)*f00+u*f10)*(1-v)+((1-u)*f01+u*f11)*v;
					}
					else if ( interpole == NEAREST ) {
						if (u<0.5){
							data[j] = (v<0.5)?f00:f01;
						} else {
							data[j] = (v<0.5)?f10:f11;
						}
					}
				}
			}
		}
	}
	return newIm;
}
