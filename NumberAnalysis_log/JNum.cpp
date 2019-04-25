#include"JNum.h"
//#define J_DEBUG
/*
*Author:贾成君; Created on 2016-11-29
*留待解决的问题：
缺乏对于0的判断，以及除0抛出错误的处理
没有 使用字符串进行的构造函数
没有 在使用各项运算符之前进行数据的检查——是否数字不存在
时间：2016年12月1日 9点
*
*/
#include<cmath>
#include<iostream>
static JNum JNum_zero( 0,MININDEX );

using namespace std;
JNum::JNum(  )
{
	digit = 0;index = 0; numsave = NULL;sign = true;
#ifdef J_DEBUG
	cout<<"使用默认的构造功能:"<<create++<<"个"<<endl;
#endif
}

JNum::JNum( uint dig,int ind,char* num,bool si )
{
	this->digit = dig;
	this->index = ind;
	this->sign = si;
	this->numsave = new char[digit];
	for( uint i=0; i<digit; i++ )
	{
		this->numsave[i]=num[i];
	}
#ifdef J_DEBUG
	cout<<"使用构造功能1:"<<create++<<"个"<<endl;
#endif
}

JNum::JNum( long s )
{
	sign = ( s>=0 );//大于等于0归为true
	s = abs(s);
	if( s == 0 )
	{
		index = 0; digit = 1;
		numsave = new char[1];
		numsave[0] = 0;
		return ;
	}
	index = int( ceil( log10( s ) ))-1;
	digit = index+1;
	numsave = new char[digit];
	for( int i=digit-1; i>=0 ;i-- )
	{
		numsave[i] = s%10;
		s /= 10;
	}
#ifdef J_DEBUG
	cout<<"使用构造功能2:"<<create++<<"个"<<endl;
#endif
}

JNum::JNum( int s ,int ind )
{
	sign = ( s>=0 );//大于等于0归为true
	s = abs(s);
	if( s == 0 )
	{
		index = 0; digit = 1;
		numsave = new char[1];
		numsave[0] = 0;
		return ;
	}
	index = int( floor( log10( s ) ));
	digit = index+1;
	numsave = new char[digit];
	for( int i=digit-1; i>=0 ;i-- )
	{
		numsave[i] = s%10;
		s /= 10;
	}
	index += ind;
#ifdef J_DEBUG
	cout<<"使用构造功能3:"<<create++<<"个"<<endl;
#endif
}

JNum::JNum( double s,uint dig )
{
	this->digit = dig;
	this->sign = ( s>=0 );//大于等于0归为true
	if( s == 0 )
	{
		index = 0; digit = 1;
		numsave = new char[1];
		numsave[0] = 0;
		return ;
	}
	this->numsave = new char[dig];
	this->index = int( floor( log10( abs(s) ) ));
	double s_n = abs(s)/pow( 10,this->index );
	for( uint i=0; i<dig ;i++ )
	{
		numsave[i] = uint( floor(s_n) );
		s_n -= numsave[i];
		s_n *= 10.0;
	}
#ifdef J_DEBUG
	cout<<"使用构造功能4"<<create++<<"个"<<endl;
#endif
}

JNum::JNum( const JNum& a )
{
	digit = a.digit;
	index = a.index;
	sign = a.sign;
	//numsave = a.numsave;
	//if( numsave != NULL ){
		//delete[] numsave;
	//}
	this->numsave = new char[digit];
	memcpy_s( this->numsave,digit,a.numsave,digit );
#ifdef J_DEBUG
	cout<<"调用了深拷贝函数："<<create++<<"个"<<endl;
#endif
}

JNum::~JNum()
{
	if( numsave!=NULL)
	{
		delete[] numsave;
	}
	numsave = NULL;
#ifdef J_DEBUG
	cout<<"调用了析构函数:"<<destory++<<"个"<<endl;
#endif
}

JNum JNum::Accuracy( uint acc )
{//把精度为acc后结果
	JNum result(*this);
	result.ToAccuracy( acc );
	return result;
}

void JNum::ToAccuracy( uint acc )
{//把自己的精度转化为acc
	if( digit == acc ){
		return;
	} else if( digit >acc )
	{//精度削弱，直接改变acc即可
		digit = acc;
		if( numsave[acc] >= 5 )
		{//四舍五入
			bool temp = true;
			int loc = acc-1;
			while( temp && loc >= 0)
			{
				if( numsave[loc] == 9 )
				{
					numsave[loc] = 0; loc--; 
				} else {
					numsave[loc]++; temp = false;
				}
			}
			if( temp ) {
				char* numNew = new char[acc];
				memcpy_s(numNew+1,acc-1,numsave,acc-1);
				numNew[0] = 1;
				index++;
				delete[] numsave;
				numsave = numNew;
			} else {
				char* numNew = new char[acc];
				memcpy_s(numNew,acc,numsave,acc);
				delete[] numsave;
				numsave = numNew;
			}
		}
	} 
	else
	{//精度增强，后面置0
		char *num_n = new char[acc];
		memcpy_s(num_n,acc,numsave,digit );
		memset( num_n+digit,0,(acc-digit)*sizeof(char) );
		digit = acc;
		delete[] numsave;
		numsave = num_n;
	}
#ifdef J_DEBUG
	cout<<"使用精度转换功能"<<endl;
#endif
}

JNum JNum::operator+ ( JNum &other )
{
	JNum result;
	if( numsave[0] == 0 ){
		return other;
	} else if( other.numsave[0] == 0 ) {
		return *this;
	}

	if( this->sign == other.sign )
	{//如果加数同号
		result.sign = this->sign;
		JNum Jn1,Jn2;
		//把数量级较大的数存储在Jn1中

		if( this->index >=other.index ){
			Jn1 = *this; Jn2 = other;
		} else {
			Jn1 = other; Jn2 = *this;
		}
		char *num1,*num2;//存储精度对齐后的结果——使用补零的方法
		uint acc_r;//计算结果对应的精度情况——两个加数位数对齐
		acc_r = Jn1.digit>(Jn1.index-Jn2.index+Jn2.digit)?Jn1.digit:(Jn1.index-Jn2.index+Jn2.digit);
		num1 = new char[acc_r];
		num2 = new char[acc_r];
		memcpy_s ( num1,acc_r,Jn1.numsave,Jn1.digit);
		memset(num1+Jn1.digit,0,(acc_r-Jn1.digit)*sizeof(char));
		memcpy_s(num2+Jn1.index-Jn2.index,acc_r,Jn2.numsave,Jn2.digit);
		memset(num2,0,(Jn1.index-Jn2.index)*sizeof(char));
		memset(num2+Jn1.index-Jn2.index+Jn2.digit,0,acc_r-(Jn1.index-Jn2.index+Jn2.digit)*sizeof(char));
		char temp=0;
		for( int i = acc_r-1; i>=0; i-- )
		{//从低位开始累加——结果存在num1中，进位存储在temp中
			num1[i] +=(num2[i]+temp);
			if( num1[i] >9 )
			{
				temp = 1;
				num1[i] = num1[i] -10;
			} else
			{
				temp = 0;
			}/*可以进行修改来提高效率*/
		}
		if(temp == 1 )
		{//如果最高位存在进位，则进行指数和存储位数的修正
			acc_r ++;
			delete[] num2; 
			num2 = new char[acc_r];
			memcpy_s( num2+1,acc_r-1,num1,acc_r-1 );
			num2[0] = 1;
			delete[] num1;
			num1 = new char[acc_r];
			memcpy_s( num1, acc_r, num2, acc_r );
		}
		int temp1=0;
		while( num1[0] == 0 && acc_r > 1)
		{//如果最高位为0，则进行指数和存储位数的修正
			acc_r --;
			temp1--;
			num1++;//指针向后移动了temp位
		}
		//把结果保存到result中
		result.digit = acc_r;
		result.numsave = new char[acc_r];
		memcpy_s( result.numsave,acc_r,num1,acc_r);
		result.index = Jn1.index + temp + temp1;
		delete[] (num1+temp1);
		delete[] num2;
	}
	else
	{//如果不同号
		JNum Jn1(*this),Jn2(other);
		Jn1.sign = true; Jn2.sign = true;
		result.sign = ( Jn1>Jn2 )?this->sign:other.sign;//确定符号位为较大数的符号位
		
		if( Jn2>Jn1 )
		{//Jn2绝对值较大时，交换二者的位置，使得Jn1>Jn2
			JNum temp = Jn1;
			Jn1 = Jn2;
			Jn2 = temp;
		}
		char *num1,*num2;//存储精度对齐后的结果——使用补零的方法
		uint acc_r;//计算结果对应的精度情况——两个加数位数对齐
		acc_r = Jn1.digit>(Jn1.index-Jn2.index+Jn2.digit)?Jn1.digit:(Jn1.index-Jn2.index+Jn2.digit);
		num1 = new char[acc_r];
		num2 = new char[acc_r];
		memcpy_s ( num1,acc_r,Jn1.numsave,Jn1.digit);
		memset(num1+Jn1.digit,0,(acc_r-Jn1.digit)*sizeof(char));
		memcpy_s(num2+Jn1.index-Jn2.index,Jn2.digit,Jn2.numsave,Jn2.digit);
		memset(num2,0,(Jn1.index-Jn2.index)*sizeof(char));
		memset(num2+Jn1.index-Jn2.index+Jn2.digit,0,acc_r-(Jn1.index-Jn2.index+Jn2.digit)*sizeof(char));
		char temp=0;
		for( int i = acc_r-1; i>=0; i-- )
		{//从低位开始累减——结果存在num1中，借位存储在temp中
			if( num1[i] < num2[i] + temp )
			{//出现了借位
				num1[i] = 10 + num1[i] - ( num2[i] + temp );
				temp = 1;
			} else
			{
				num1[i] -= ( num2[i] + temp );
				temp = 0;
			}
		}
		temp = 0;//使用temp记录位数的变化
		while( num1[0] == 0 && acc_r > 1)
		{//如果最高位为0，则进行指数和存储位数的修正
			acc_r --;
			temp++;
			num1++;//指针向后移动了temp位
		}
		//把结果保存到result中
		result.digit = acc_r;
		result.numsave = new char[acc_r];
		memcpy_s( result.numsave,acc_r,num1,acc_r);
		result.index = Jn1.index - temp;//位数向后变动了temp位
		delete[] (num1-temp);
		delete[] num2;

	}
	if( result.numsave[0] == 0 )
	{//如果计算结果为0
		result.index = MININDEX;
		result.digit = 1;
		result.sign = true;
	}
	//cout<<"加法完成"<<endl;
	return result;
}

JNum JNum::operator- ( JNum &other )
{
	JNum a(other);
	a.sign = !a.sign;
	return this->operator+(a);
}

JNum JNum::operator* ( int other )
{
	JNum result,JNum_temp;
	char mouwei;
	if( other<0 ){
		result.sign = !sign;
	} else if( other >0 ) {
		result.sign = sign;
	} else {
		return JNum_zero;
	}
	result = JNum_zero;
	uint chengshu = abs(other);
	for( ;chengshu!=0; chengshu /= 10 )
	{
		/*弃疗的代码.....有空再补2016-12-01**/
	}
	return result;
}

JNum JNum::operator* ( char other )
{
	JNum result;
	if( other == 0 )
	{
		result = JNum(0,MININDEX);
	}
	else if( other < 10 )
	{
		result = *this;
		Mul_ShuZu( result.numsave,digit,other );
		if( result.numsave[0] >= 10 )
		{
			char* result_char = result.numsave;
			result.digit += 1;
			result.numsave = new char[result.digit];
			memcpy_s( result.numsave,result.digit,result_char,result.digit-1);
			result.index = result.index +1;
			result.numsave[0] = 1;
			result.numsave[1] -= 10;
			delete[] result_char;
		}
	}
	else
	{
		result = this->operator* ( (int&) other );
	}
	return result;
}

JNum JNum::operator* ( JNum &other )
{
	JNum result;
	result.sign = (sign == other.sign);
	char *result_char = new char[ digit + other.digit ];
	memset(result_char,0,(digit + other.digit)*sizeof(char));
	for( int i = other.digit-1; i>=0; i-- )
	{
		char a = other.numsave[i];
		for( int j= digit-1; j>=0; j-- )
		{
			result_char[i+j+1] += a*numsave[j];
			result_char[i+j] += result_char[i+j+1]/10;
			result_char[i+j+1] = result_char[i+j+1]%10;
		}
	}
	if( result_char[0] == 0 )
	{//最高位为0时,修正结果,并拷贝到result中
		result.digit = digit+other.digit-1;
		result.numsave = new char[result.digit];
		memcpy_s( result.numsave,result.digit,result_char+1,result.digit);
		result.index = index + other.index;
		delete[] result_char;
	}
	else
	{//最高位非0时,拷贝结果
		result.digit = digit+other.digit;
		result.numsave = new char[result.digit];
		memcpy_s( result.numsave,result.digit,result_char,result.digit);
		result.index = index + other.index+1;
		delete[] result_char;
	}
	if( result.numsave[0] == 0 )
	{//如果计算结果为0
		result.index = MININDEX;
		result.digit = 1;
		result.sign = true;
	}
	return result;
}

JNum JNum::operator/ ( JNum &other )
{
	return Divide(other,div_acc);
}

JNum JNum::Divide( JNum &other, uint acc )
{//把除数为0的结果定义为0
	JNum result(0,MININDEX);
	if( other.numsave[0] == '\0' || numsave[0] == '\0' )
	{//首位为0，证明该数字就是0
		return result;
	}
	else
	{
		result.sign = ( sign == other.sign );
		result.digit = acc;

		uint acc_r = other.digit + acc+5;
		char *DivideTo = new char[acc_r];//被除数进行规范
		char *result_char = new char[acc+2];//最后的结果进行规范
		if( acc_r > digit )
		{//被除数位数不够时，向后补零
			memcpy_s( DivideTo,acc_r,numsave,digit );
			memset( DivideTo+digit,0,acc_r - digit );
		}
		else
		{//被除数位数多时，截取前面几位即可
			memcpy_s( DivideTo,acc_r,numsave,acc_r );
		}

		//从高到低依次进行除法运算
		for( uint i = 0; i<acc+2; i++ )
		{
			result_char[i] = Div_ShuZu( DivideTo+i, other.numsave, other.digit );
			DivideTo[i+1] += 10*DivideTo[i];
		}
		delete[] DivideTo;
		//计算index:最高位为0，表示需要进位
		if( result_char[0] == 0 )
		{
			result.index = index-other.index-1;
			//首位为0时，把result_char向后移动一位
			char* temp = new char[acc];
			memcpy_s( temp,acc,result_char+1,acc );
			delete[] result_char;
			result_char = temp;
		}
		else
		{
			result.index = index-other.index;
		}
		//末位进行四舍五入
		if( result_char[acc] > 4 )
		{
			for( int i=acc-1; i>=0;i-- )
			{//从低到高，依次计算是否有进位以及进位后的结果
				//result_char[i]++;//下面有进位，加1
				if( result_char[i] !=9 ){
					//不再向上进位，停止计算 
					break;
				}else{
					//还有进位，去除进位后继续计算
					result_char[i] = 0;
				}
			}
			//最高位由于进位出现0
			if( result_char[0] == 0 )
			{
				char* temp = new char[acc];
				temp[0] = 1;
				memcpy_s( temp+1,acc-1,result_char,acc-1 );
				delete[] result_char;
				result_char = temp;
			}
		}
		if( result.numsave != NULL ) {
			delete[] result.numsave;
		}
		result.numsave = result_char;
	}
	return result;
}

JNum JNum::operator= ( JNum &a )
{
	this->digit = a.digit;
	this->index = a.index;
	this->sign = a.sign;
	if( numsave != NULL )
	{
		delete[] numsave;
	}
	this->numsave = new char[digit];
	memcpy_s( this->numsave,digit,a.numsave,digit );
#ifdef J_DEBUG
	cout<<"调用了=函数："<<create++<<"个"<<endl;
#endif
	return *this;
}

bool JNum::operator> ( JNum &other )
{
	if( sign != other.sign )
	{//判别符号,不同号时结果与sign一致
		return sign;
	} 
	else
	{
		if( numsave[0] == 0 ) {
			return !other.sign;
		} else if( other.numsave[0] == 0 ) {
			return sign;
		}
		if( index != other.index )
		{//判别最高位，不相等时，大小结果与符号一致时——正数则大于；负数则小于
			return (index>other.index)==sign;
		} 
		else 
		{
			uint ind = (digit>other.digit)? other.digit:digit;//取较小的精度比较
			for ( uint i=0;i<ind;i++ )
			{//从高位依次比较大小
				if( numsave[i] != other.numsave[i] )
				{//出现不同位的时候,返回比较结果
					return (numsave[i]>other.numsave[i])==sign;
				}
			}
			//高位结果都相同时，比较残留的部分——没有的补零
			if( digit == other.digit )
			{//同样精度时，二者相等，返回false
				return false;
			}
			else
			{//否则位数多的，绝对值较大
				return (digit>other.digit)==sign;
			}
		}
	}
}

bool JNum::operator< ( JNum &other )
{
	return other.operator>(*this);
}

string JNum::ToString ()
{
	string result;
	if( digit < 1 || numsave == NULL )
	{
		result += "This num is wrong!";
		return result;
	}
	result += sign?'+':'-';
	result += char(numsave[0]+0x30);
	result += '.';
	for( uint i = 1; i<digit; i++ )
	{
		result += char( numsave[i]+0x30 );
	}
	result += "\t*10^";
	char s_ind[25];
	_itoa_s(index,s_ind,10);
	result += s_ind;
	return result;
}

char JNum::Div_ShuZu( char* a,char* b, uint wei )
{
	char result=0;
	if( !Cmp_ShuZu(a,b,wei) )
	{//小于时，直接返回原来的数并把商记作0
		return 0;
	}
	else
	{
		char* temp = new char[wei];
		char hi = 10,low = 1;//[low,hi)二分法查找商
		while( low <hi-1 )
		{
			memcpy_s( temp, wei, b,wei );
			char mid = (low+hi)>>1;
			Mul_ShuZu( temp,wei,mid );
			Cmp_ShuZu(a,temp,wei)? (low = mid):(hi=mid);
		}
		memcpy_s( temp, wei, b,wei );
		Mul_ShuZu( temp,wei,low );
		Minus_ShuZu( a,temp,wei );
		delete[] temp;
		return low;
	}
	
}

bool JNum::Cmp_ShuZu( char* a,char* b, uint wei )
{
	for( uint i = 0; i<wei; i++ )
	{//从最高位开始，依次比较；找到第一个不相等的位：大于返回true，小于返回false
		if( a[i] > b[i] ) {
			return true;
		} else if ( a[i] < b[i] ) {
			return false;
		} else {
			continue;
		}
	}
	return true;//比较完0:wei-1，仍然没有不等项，则二者相等，返回true
}

void JNum::Mul_ShuZu( char* a, uint wei, char mul )
{
	for( uint i = 0; i<wei;i++ )
	{//每一位都乘以乘数
		a[i] *= mul;
	}
	for( int i= wei-1; i>=1;i-- )
	{//从低到高，依次进位
		a[i-1] += a[i]/10;
		a[i] = a[i]%10;
	}
}

void JNum::Minus_ShuZu( char* a,char* b,uint wei )
{//没有确保a>b，而是直接进行了减法操作
	char temp = 0;
	for( int i = wei-1; i>=0; i-- )
	{//从低位开始累减——结果存在a中，借位存储在temp中
		if( a[i] < b[i] + temp )
		{//出现了借位
			a[i] += 10 - ( b[i] + temp );
			temp = 1;
		} else
		{
			a[i] -= ( b[i] + temp );
			temp = 0;
		}
	}
}