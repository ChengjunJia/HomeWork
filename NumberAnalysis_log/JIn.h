#ifndef JIN_H
#define JIN_H
#pragma once
#include "JNum.h"

enum WAY_CAL
{
	Taylor=0, Intergral =1, Other = 2
};

class JIn
{
public:
	static JNum InCal( JNum a, WAY_CAL way, uint acc );
	static JNum InTaylor( JNum a, uint acc );//a: [1,100]
	static JNum InTaylor_2( JNum a, uint acc );//a: [1,2]
	static JNum InIntergral( JNum a, uint acc );
	static JNum InIntergral_2( JNum a, uint acc );//a:[1,2]
	static JNum InOther1( JNum a, uint acc );
	static JNum Exp( JNum a);//a:[0,10]
	static JNum Exp_1( JNum a);//a:[0,1]
	static JNum InRomberg( JNum a );
};

static JNum JInTalyor1_5;
static JNum JIntergral5;
static JNum JExp;

static unsigned long Taytimes = 0;
static unsigned long Intertimes = 0;
static unsigned long Othertimes = 0;


#endif