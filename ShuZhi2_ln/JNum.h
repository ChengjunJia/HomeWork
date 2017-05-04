#ifndef JNUM_H
#define JNUM_H
#pragma once

#include<string>
using std::string;

enum SIGN_NUM
{//定义符号性质——正负；并没有用到、但是可以用于扩展
	POSTIVE = 0, NEGTIVE = 1
};

typedef unsigned int uint;

const int MININDEX = -500;

class JNum
{
	/*
	*自定义任意精度的10进制有理数存储与运算
	*/
	public:
		static int create;
		static int destory;
		JNum(  );
		JNum( long s );
		JNum( int s, int ind = 0);
		JNum( double s, uint dig = 20);
		JNum( uint dig,int ind,char* num,bool si );
		JNum( const JNum& a );//深拷贝
		~JNum();
		JNum Accuracy( uint acc );//输出精度为*的JNum
		void ToAccuracy( uint acc );//转换数据的精度

		//重定义加减乘除
		JNum operator+ ( JNum &other );
		//JNum operator+= ( JNum &other );
		JNum operator- ( JNum &other );
		JNum operator* ( JNum &other );
		JNum operator* ( int other );
		JNum operator* ( char other );//定义一个乘以数字为0-10的计算方法
		JNum operator/ ( JNum &other );
		JNum operator= ( JNum &other );	//重定义=
		bool operator> ( JNum &other ); 
		bool operator< ( JNum &other ); //重定义大小比较

		JNum Divide( JNum &other, uint acc );//定义除法，除法结果的精度为acc(防止除不尽的情况发生)

		string ToString();
		//ostream& operator<<( JNum& os );
		uint digit;//表示有效数字的位数——精度
		int index;//表示指数——数据存储为科学计数法:?.???*10^? 分别记录在numsave和index中
		char* numsave;//
		bool sign;//表示数据的符号,true := postive/zero
		static const uint div_acc = 30;//定义一般意义上的除法的保留精度
private:
	char Div_ShuZu( char* a,char* b, uint wei );//返回数组a除以数组b的商——并把a置为二者之差
	bool Cmp_ShuZu( char* a,char* b, uint wei );//比较两个数组之间的大小,a>=b返回true
	void Mul_ShuZu( char* a, uint wei, char mul );//a = a*mul，同时把除了a的最高位进行进位,要求mul小于10
	void Minus_ShuZu( char* a,char* b,uint wei );//a -= b
};
#endif