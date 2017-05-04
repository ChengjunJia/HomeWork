#include"JNum.h"
//#define J_DEBUG
/*
*Author:�ֳɾ�; Created on 2016-11-29
*������������⣺
ȱ������0���жϣ��Լ���0�׳�����Ĵ���
û�� ʹ���ַ������еĹ��캯��
û�� ��ʹ�ø��������֮ǰ�������ݵļ�顪���Ƿ����ֲ�����
ʱ�䣺2016��12��1�� 9��
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
	cout<<"ʹ��Ĭ�ϵĹ��칦��:"<<create++<<"��"<<endl;
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
	cout<<"ʹ�ù��칦��1:"<<create++<<"��"<<endl;
#endif
}

JNum::JNum( long s )
{
	sign = ( s>=0 );//���ڵ���0��Ϊtrue
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
	cout<<"ʹ�ù��칦��2:"<<create++<<"��"<<endl;
#endif
}

JNum::JNum( int s ,int ind )
{
	sign = ( s>=0 );//���ڵ���0��Ϊtrue
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
	cout<<"ʹ�ù��칦��3:"<<create++<<"��"<<endl;
#endif
}

JNum::JNum( double s,uint dig )
{
	this->digit = dig;
	this->sign = ( s>=0 );//���ڵ���0��Ϊtrue
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
	cout<<"ʹ�ù��칦��4"<<create++<<"��"<<endl;
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
	cout<<"���������������"<<create++<<"��"<<endl;
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
	cout<<"��������������:"<<destory++<<"��"<<endl;
#endif
}

JNum JNum::Accuracy( uint acc )
{//�Ѿ���Ϊacc����
	JNum result(*this);
	result.ToAccuracy( acc );
	return result;
}

void JNum::ToAccuracy( uint acc )
{//���Լ��ľ���ת��Ϊacc
	if( digit == acc ){
		return;
	} else if( digit >acc )
	{//����������ֱ�Ӹı�acc����
		digit = acc;
		if( numsave[acc] >= 5 )
		{//��������
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
	{//������ǿ��������0
		char *num_n = new char[acc];
		memcpy_s(num_n,acc,numsave,digit );
		memset( num_n+digit,0,(acc-digit)*sizeof(char) );
		digit = acc;
		delete[] numsave;
		numsave = num_n;
	}
#ifdef J_DEBUG
	cout<<"ʹ�þ���ת������"<<endl;
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
	{//�������ͬ��
		result.sign = this->sign;
		JNum Jn1,Jn2;
		//���������ϴ�����洢��Jn1��

		if( this->index >=other.index ){
			Jn1 = *this; Jn2 = other;
		} else {
			Jn1 = other; Jn2 = *this;
		}
		char *num1,*num2;//�洢���ȶ����Ľ������ʹ�ò���ķ���
		uint acc_r;//��������Ӧ�ľ������������������λ������
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
		{//�ӵ�λ��ʼ�ۼӡ����������num1�У���λ�洢��temp��
			num1[i] +=(num2[i]+temp);
			if( num1[i] >9 )
			{
				temp = 1;
				num1[i] = num1[i] -10;
			} else
			{
				temp = 0;
			}/*���Խ����޸������Ч��*/
		}
		if(temp == 1 )
		{//������λ���ڽ�λ�������ָ���ʹ洢λ��������
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
		{//������λΪ0�������ָ���ʹ洢λ��������
			acc_r --;
			temp1--;
			num1++;//ָ������ƶ���tempλ
		}
		//�ѽ�����浽result��
		result.digit = acc_r;
		result.numsave = new char[acc_r];
		memcpy_s( result.numsave,acc_r,num1,acc_r);
		result.index = Jn1.index + temp + temp1;
		delete[] (num1+temp1);
		delete[] num2;
	}
	else
	{//�����ͬ��
		JNum Jn1(*this),Jn2(other);
		Jn1.sign = true; Jn2.sign = true;
		result.sign = ( Jn1>Jn2 )?this->sign:other.sign;//ȷ������λΪ�ϴ����ķ���λ
		
		if( Jn2>Jn1 )
		{//Jn2����ֵ�ϴ�ʱ���������ߵ�λ�ã�ʹ��Jn1>Jn2
			JNum temp = Jn1;
			Jn1 = Jn2;
			Jn2 = temp;
		}
		char *num1,*num2;//�洢���ȶ����Ľ������ʹ�ò���ķ���
		uint acc_r;//��������Ӧ�ľ������������������λ������
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
		{//�ӵ�λ��ʼ�ۼ������������num1�У���λ�洢��temp��
			if( num1[i] < num2[i] + temp )
			{//�����˽�λ
				num1[i] = 10 + num1[i] - ( num2[i] + temp );
				temp = 1;
			} else
			{
				num1[i] -= ( num2[i] + temp );
				temp = 0;
			}
		}
		temp = 0;//ʹ��temp��¼λ���ı仯
		while( num1[0] == 0 && acc_r > 1)
		{//������λΪ0�������ָ���ʹ洢λ��������
			acc_r --;
			temp++;
			num1++;//ָ������ƶ���tempλ
		}
		//�ѽ�����浽result��
		result.digit = acc_r;
		result.numsave = new char[acc_r];
		memcpy_s( result.numsave,acc_r,num1,acc_r);
		result.index = Jn1.index - temp;//λ�����䶯��tempλ
		delete[] (num1-temp);
		delete[] num2;

	}
	if( result.numsave[0] == 0 )
	{//���������Ϊ0
		result.index = MININDEX;
		result.digit = 1;
		result.sign = true;
	}
	//cout<<"�ӷ����"<<endl;
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
		/*���ƵĴ���.....�п��ٲ�2016-12-01**/
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
	{//���λΪ0ʱ,�������,��������result��
		result.digit = digit+other.digit-1;
		result.numsave = new char[result.digit];
		memcpy_s( result.numsave,result.digit,result_char+1,result.digit);
		result.index = index + other.index;
		delete[] result_char;
	}
	else
	{//���λ��0ʱ,�������
		result.digit = digit+other.digit;
		result.numsave = new char[result.digit];
		memcpy_s( result.numsave,result.digit,result_char,result.digit);
		result.index = index + other.index+1;
		delete[] result_char;
	}
	if( result.numsave[0] == 0 )
	{//���������Ϊ0
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
{//�ѳ���Ϊ0�Ľ������Ϊ0
	JNum result(0,MININDEX);
	if( other.numsave[0] == '\0' || numsave[0] == '\0' )
	{//��λΪ0��֤�������־���0
		return result;
	}
	else
	{
		result.sign = ( sign == other.sign );
		result.digit = acc;

		uint acc_r = other.digit + acc+5;
		char *DivideTo = new char[acc_r];//���������й淶
		char *result_char = new char[acc+2];//���Ľ�����й淶
		if( acc_r > digit )
		{//������λ������ʱ�������
			memcpy_s( DivideTo,acc_r,numsave,digit );
			memset( DivideTo+digit,0,acc_r - digit );
		}
		else
		{//������λ����ʱ����ȡǰ�漸λ����
			memcpy_s( DivideTo,acc_r,numsave,acc_r );
		}

		//�Ӹߵ������ν��г�������
		for( uint i = 0; i<acc+2; i++ )
		{
			result_char[i] = Div_ShuZu( DivideTo+i, other.numsave, other.digit );
			DivideTo[i+1] += 10*DivideTo[i];
		}
		delete[] DivideTo;
		//����index:���λΪ0����ʾ��Ҫ��λ
		if( result_char[0] == 0 )
		{
			result.index = index-other.index-1;
			//��λΪ0ʱ����result_char����ƶ�һλ
			char* temp = new char[acc];
			memcpy_s( temp,acc,result_char+1,acc );
			delete[] result_char;
			result_char = temp;
		}
		else
		{
			result.index = index-other.index;
		}
		//ĩλ������������
		if( result_char[acc] > 4 )
		{
			for( int i=acc-1; i>=0;i-- )
			{//�ӵ͵��ߣ����μ����Ƿ��н�λ�Լ���λ��Ľ��
				//result_char[i]++;//�����н�λ����1
				if( result_char[i] !=9 ){
					//�������Ͻ�λ��ֹͣ���� 
					break;
				}else{
					//���н�λ��ȥ����λ���������
					result_char[i] = 0;
				}
			}
			//���λ���ڽ�λ����0
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
	cout<<"������=������"<<create++<<"��"<<endl;
#endif
	return *this;
}

bool JNum::operator> ( JNum &other )
{
	if( sign != other.sign )
	{//�б����,��ͬ��ʱ�����signһ��
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
		{//�б����λ�������ʱ����С��������һ��ʱ������������ڣ�������С��
			return (index>other.index)==sign;
		} 
		else 
		{
			uint ind = (digit>other.digit)? other.digit:digit;//ȡ��С�ľ��ȱȽ�
			for ( uint i=0;i<ind;i++ )
			{//�Ӹ�λ���αȽϴ�С
				if( numsave[i] != other.numsave[i] )
				{//���ֲ�ͬλ��ʱ��,���رȽϽ��
					return (numsave[i]>other.numsave[i])==sign;
				}
			}
			//��λ�������ͬʱ���Ƚϲ����Ĳ��֡���û�еĲ���
			if( digit == other.digit )
			{//ͬ������ʱ��������ȣ�����false
				return false;
			}
			else
			{//����λ����ģ�����ֵ�ϴ�
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
	{//С��ʱ��ֱ�ӷ���ԭ�����������̼���0
		return 0;
	}
	else
	{
		char* temp = new char[wei];
		char hi = 10,low = 1;//[low,hi)���ַ�������
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
	{//�����λ��ʼ�����αȽϣ��ҵ���һ������ȵ�λ�����ڷ���true��С�ڷ���false
		if( a[i] > b[i] ) {
			return true;
		} else if ( a[i] < b[i] ) {
			return false;
		} else {
			continue;
		}
	}
	return true;//�Ƚ���0:wei-1����Ȼû�в�����������ȣ�����true
}

void JNum::Mul_ShuZu( char* a, uint wei, char mul )
{
	for( uint i = 0; i<wei;i++ )
	{//ÿһλ�����Գ���
		a[i] *= mul;
	}
	for( int i= wei-1; i>=1;i-- )
	{//�ӵ͵��ߣ����ν�λ
		a[i-1] += a[i]/10;
		a[i] = a[i]%10;
	}
}

void JNum::Minus_ShuZu( char* a,char* b,uint wei )
{//û��ȷ��a>b������ֱ�ӽ����˼�������
	char temp = 0;
	for( int i = wei-1; i>=0; i-- )
	{//�ӵ�λ��ʼ�ۼ������������a�У���λ�洢��temp��
		if( a[i] < b[i] + temp )
		{//�����˽�λ
			a[i] += 10 - ( b[i] + temp );
			temp = 1;
		} else
		{
			a[i] -= ( b[i] + temp );
			temp = 0;
		}
	}
}