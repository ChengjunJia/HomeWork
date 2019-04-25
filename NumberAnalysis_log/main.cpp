#include "JIn.h"
#include<iostream>
#include<time.h>
#include <cstdlib>

using namespace std;
#define BUFF 50

//补全——四舍五入的精度取值

int JNum::create = 0;
int	JNum::destory = 0;


int main()
{
	JInTalyor1_5 = JNum();
	JIntergral5 = JNum();
	JExp = JNum();
	while(true)
	{
		cout<<"Input the num of Calculate:(输入q退出)"<<endl;
		char in_num[BUFF];
		cin>>in_num;
		//cout<<in_num<<endl;
		int loc = 0; char c; uint numin = 0;//loc--point location 
		bool point = false; bool input = true;
		if( in_num[0] == 'q' ) break;
		for( int i=0;(c=in_num[i]) != '\0' && i< BUFF; i++ )
		{
			if( c >= '0' && c <= '9' ) {
				numin = numin*10+c-'0';
				if( point ) {
					loc++;
				}
			} else if ( c == '.' ) {
				if( !point ) {
					point = true;
				} else {// . occure two times
					input = false;
					break;
				}
			} else {
				input = false;
				break;
			}
		}
		if( !input ) {
			cout<<"Input False"<<endl;
			continue;
		}
		{
		JNum num1(numin,0-loc);
		cout<<"input:\t"<< num1.ToString() <<endl;
		
		clock_t st1,st2,st3,fi1,fi2,fi3;
		/*测评四则运算的计算速度
		uint time0 = 0;
		uint MAX = 1000000000;
		srand(unsigned(time(0)));
		for( int i =0 ;i<1000;i++)
		{
			int num = (((double)rand()) /RAND_MAX)*MAX;
			JNum num2 = JNum(num,-10);
			num = (((double)rand()) /RAND_MAX)*MAX;
			num2 = num2 + JNum(num,-20);
			num = (((double)rand()) /RAND_MAX)*MAX;
			num2 = num2 + JNum(num,-30);

			num = (((double)rand()) /RAND_MAX)*MAX;
			num1 = JNum(num,-10);
			num = (((double)rand()) /RAND_MAX)*MAX;
			num1 = num1 + JNum(num,-20);
			num = (((double)rand()) /RAND_MAX)*MAX;
			num1 = num1 + JNum(num,-30);
			
			st1 = clock();
			for( int i =0 ;i<10000;i++){
				num1.Divide(num2,30);
			}
			st2 = clock();
			time0 = st2-st1;
			cout<<time0<<endl;
		}*/
		
		
		st1 = clock();
		JNum r1;
		r1 = JIn::InTaylor(num1,25);
		r1.ToAccuracy(20+r1.index);
		fi1 = clock();

		st3 = clock();
		JNum r3;
		r3 = JIn::InOther1(num1,30);
		r3.ToAccuracy(20+r3.index);
		fi3 = clock();
		
		st2 = clock();
		JNum r2;
		r2= JIn::InIntergral(num1,25);
		r2.ToAccuracy(20+r2.index);
		fi2 = clock();

		cout<<"泰勒结果："<< r1.ToString() <<"\t"<<fi1-st1<<"ms"<<endl;
		cout<<"其他结果："<< r3.ToString() <<"\t"<<fi3-st3<<"ms"<<endl;
		cout<<"积分结果："<< r2.ToString() <<"\t"<<fi2-st2<<"ms"<<endl;
		
		}
	}
	return 0;
}