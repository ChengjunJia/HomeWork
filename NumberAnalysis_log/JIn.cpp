#include "JIn.h"
#include <iostream>
#include <time.h>

using namespace std;
//#define JInDebug
#define JInShow
JNum JIn::InCal( const JNum a, WAY_CAL way, uint acc )
{
	switch( way )
	{
	case WAY_CAL::Taylor:
		return InTaylor(a,acc);
		break;
	case WAY_CAL::Intergral:
		return InIntergral(a,acc);
		break;
	case WAY_CAL::Other:
		return InOther1(a,acc);
		break;
	default:
		return InTaylor(a,acc);
		break;
	}
}

JNum JIn::InTaylor( JNum a, uint acc )
{//a: [1,100]
#ifdef JInShow
	cout<<"************************"<<endl;
	cout<<"With Taylor to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
	clock_t start,finish;
	start = clock();
#endif
	if( !a.sign ) return JNum(0);
	JNum s = a;
	uint temp = 0;
	JNum k = JNum(15,-1);
	while( s > k )
	{
		temp++;
		s = s.Divide( k,acc+3 );
	}
	JNum result;
	if( temp !=0 ) {
#ifdef JInDebug
		cout<<temp<<endl;
		cout<<s.ToString()<<endl;
		cout<<InTaylor_2(s,acc+3).ToString()<<endl;
		cout<<InTaylor_2(k,acc+3).ToString()<<endl;
#endif
		if( JInTalyor1_5.numsave == NULL ) {
			JInTalyor1_5 = InTaylor_2(k,30);
		}
		result = InTaylor_2(s,acc+3) + (JNum(temp,0)*JInTalyor1_5);
	} else {
		result = InTaylor_2(s,acc+3);
	}
	result.ToAccuracy(acc);
#ifdef JInShow
	finish = clock();
	cout<<"Taylor用时："<<finish-start<<"ms"<<endl;
	cout<<"************************"<<endl<<endl;
#endif

	return result;

}

JNum JIn::InTaylor_2( JNum a, uint acc )
{
	JNum MAXERROR = JNum(5,-(int)acc-1);
	JNum result(0);
	uint time=1;
	a.ToAccuracy(acc);

#ifdef JInShow
	cout<<"=========================="<<endl;
	cout<<"With Taylor to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
#endif

	JNum x = a - JNum(10,-1);
	JNum fx = x;
	JNum temp;
	while( (temp = fx.Divide( JNum(time,0),acc+3 )) > MAXERROR )
	{
#ifdef JInDebug
		cout<<"time="<<time<<endl;
		cout<<"fx/time = "<< (fx/JNum(time,0)).ToString() <<endl;
#endif
		if( time%2 == 1){
			result = result + temp;
		} else{
			result = result - temp;
		}
		time++;
		fx = fx*x;
		fx.ToAccuracy(acc+3);
	}
	result.ToAccuracy(acc);

	Taytimes += time;

#ifdef JInShow
	cout<<"Result:"<<endl<<"\t"<<time<<"次展开,"<<result.ToString()<<endl;
	cout<<"=========================="<<endl;
#endif
	return result;
}


JNum JIn::InRomberg( JNum a )
{//龙贝格求积算法
	JNum num1 = JNum(10,-1);
	JNum num2 = JNum(20,-1);
	JNum h = a-num1;
	uint n = 0,k=0,m=0;
	JNum T[100][100];//[m][k]
	JNum MAXERROR = JNum(5,-21);
	T[0][0] = (num1.Divide(num1,30) + num1.Divide(a,30))*h.Divide(num2,30);
	for(uint k =1; k<100;k++ )
	{
		T[0][k] = T[0][k-1].Divide(num2,30);
	}
	return NULL;
}

JNum JIn::InIntergral( JNum a, uint acc )
{//a的小数位数小于11位
#ifdef JInShow
	cout<<"************************"<<endl;
	cout<<"With Intergral to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
	clock_t start,finish;
	start = clock();
#endif
	if( !a.sign ) return JNum(0);
	JNum s = a;
	uint temp = 0;
	JNum k = JNum(50,-1);
	while( s > k )
	{
		temp++;
		s = s.Divide( k,acc+3 );
	}
	JNum result;
	if( temp != 0 ) {
		s.ToAccuracy(6);

#ifdef JInDebug
		cout<<temp<<endl;
		cout<<s.ToString()<<endl;
		cout<<InIntergral_2(s,acc+3).ToString()<<endl;
		cout<<InIntergral_2(k,acc+3).ToString()<<endl;
#endif
		if( JIntergral5.numsave == NULL ) {
			JIntergral5 = InIntergral_2(k,acc+3);
		}
		result = InIntergral_2(s,acc+3)+JNum(temp,0)*JIntergral5;
	} else {
		result = InIntergral_2(s,acc+3);
	}
	result.ToAccuracy(acc);
#ifdef JInShow
	finish = clock();
	cout<<"Intergral用时："<<finish-start<<"ms"<<endl;
	cout<<"************************"<<endl;
#endif
	return result;

}

JNum JIn::InIntergral_2( JNum a, uint acc )
{//使用复合辛普森公式求解[1,2]
#ifdef JInShow
	cout<<"=========================="<<endl;
	cout<<"With Intergral to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
#endif
	JNum MAXERROR = JNum(5,-(int)acc-2);
	JNum result(0,0);
	if( a <JNum(100001,-5) ) {
		return result;
	}
	JNum Num1(10,-1);
	JNum Num2(20,-1);
	JNum Num4(40,-1);
	JNum h(10,-6);
	JNum begin = Num1+h;
	int temp=1;
	for(JNum i = begin; i < a; i = i + h,temp++ )
	{
		if( temp%2 == 0 ) {
			result = result + Num2.Divide(i,acc+3);
		} else {
			result = result + Num4.Divide(i,acc+3);
		}
		result.ToAccuracy(33);
#ifdef JInShow
		if( temp%100000 ==0 ) cout<<"calculate:"<<temp<<"times;\n"<<endl;
#endif
	}
	result = result + Num1.Divide(a,acc+3) +Num1.Divide(Num1,acc+3);
	result = result * h;
	result = result / JNum(30,-1);
	result.ToAccuracy(acc);

	Intertimes += temp;

#ifdef JInShow
	cout<<"Result:"<<endl<<"\t"<<temp<<"次计算,"<<result.ToString()<<endl;
	cout<<"=========================="<<endl;
#endif
	return result;
}

JNum JIn::InOther1( JNum a, uint acc )
{
#ifdef JInShow
	cout<<"************************"<<endl;
	cout<<"With Other Way to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
	clock_t start,finish;
	start = clock();
#endif
	JNum MAXERROR = JNum(5,-28);
	JNum low(0,-50);
	JNum hi(10,0);
	low.ToAccuracy(30);
	hi.ToAccuracy(30);
	JNum aim = a.Accuracy(30);
	uint times = 0;
	while( (hi-low) > MAXERROR ){
		times++;
		JNum mid = (low+hi).Divide( JNum(20,-1),32);
		mid.ToAccuracy(30);
		if( Exp(mid) > aim ) {
			hi = mid;
		} else {
			low = mid;
		}
#ifdef JInOtherDebug
		cout<<"hi:"<<hi.ToString()<<endl;
		cout<<"low:"<<low.ToString()<<endl;
		cout<<"mid:"<<mid.ToString()<<endl;
		cout<<"中值对应的:"<<Exp(mid).ToString()<<endl<<endl;
#endif
	}
	Othertimes +=  times;
	hi.ToAccuracy(23);
#ifdef JInShow
	finish = clock();
	cout<<"Other用时："<<finish-start<<"ms"<<endl;
	cout<<"Other二分查找次数："<<times<<"次"<<endl;
	cout<<"************************"<<endl<<endl;
#endif
	return hi;
}

JNum JIn::Exp( JNum a)
{
	JNum Num1(10,-1);
	Num1.ToAccuracy(40);
	uint temp = 0;
	JNum s = a;
	while( s > Num1 )
	{
		temp++;
		s = s - Num1;
	}
	if( temp == 0 ) {
		return Exp_1(a);
	} else {
		//cout<<temp<<endl;
		//cout<<"计算的s"<<s.ToString()<<endl;
		JNum result = Exp_1(s);
		if( JExp.numsave == NULL ) {
			JExp = Exp_1(Num1);
		}
		while( temp >0 ){
			result = result*JExp;
			temp--;
		}
		result.ToAccuracy(30);
		return result;
	}
}

JNum JIn::Exp_1( JNum a)
{
#ifdef JInShowExp
	cout<<"=========================="<<endl;
	cout<<"Exp to calculate:"<<endl<<"\t"<<a.ToString()<<endl;
#endif
	JNum MAXERROR = JNum(5,-30);
	JNum result(0);
	JNum time(10,-1);
	JNum x = a;
	JNum fx = x;
	result = time;
	uint n = 2;
	JNum temp;
	while( (temp=fx/time) > MAXERROR )
	{
		result = result + temp;
		time = time*JNum(n++,0);
		fx = fx*x;
	}
	result.ToAccuracy(30);
#ifdef JInShowExp
	cout<<"Result:"<<endl<<"\t"<<--n<<"次展开,"<<result.ToString()<<endl;
	cout<<"=========================="<<endl;
#endif
	return result;
}