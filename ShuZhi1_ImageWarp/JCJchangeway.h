#ifndef JCJchangeway
#define JCJchangeway

#define _USE_MATH_DEFINES

#include <vector>
#include <opencv.hpp>
#include <cmath>
#include <algorithm>

using namespace std;
using namespace cv;

typedef struct PointToPoint {
	double oldx,oldy;
	uint newx,newy;
	PointToPoint ( double x1,double y1, uint x2, uint y2 ){
		oldx = x1; oldy = y1; newx = x2; newy = y2;
	}
	PointToPoint () { }
} PointToPoint;

typedef vector<PointToPoint> P2PVec;

enum Interpolation 
{//定义插值使用的方法:双线性,最近邻
	LINER = 0,
	NEAREST = 1
};
enum DistortType 
{//定义使用的扭曲变形方法:向内还是向外扭曲
	Inner = 0,
	Outer = 1
};

bool DistortMat ( P2PVec &JPM, const uint CenterX, const uint CenterY, const double SitaMax, DistortType distype );
bool RorateMat (P2PVec &JPM,const uint CenterX, const uint CenterY, const double Irow,const double Isita);
Mat CalNewIm ( Mat oldIm, P2PVec const &PVold, Interpolation interpole );
bool TPSMat ( P2PVec &JPM, const P2PVec ChoosePoint );

#endif