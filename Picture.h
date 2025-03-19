/**
  ******************************************************************************
  * @file           : Picture.h
  * @brief          :                 
  ******************************************************************************
  * @attention
  * 
  *
  ******************************************************************************
  */

#ifndef __PICTURE_H__
#define __PICTURE_H__

#include "AppInclude.h"

// 字符点阵
extern const unsigned char ASCII_32[16];/*" "*/
extern const unsigned char ASCII_33[16];/*"!"*/
extern const unsigned char ASCII_34[16];/*"""*/
extern const unsigned char ASCII_35[16];/*"#"*/
extern const unsigned char ASCII_36[16];/*"$"*/
extern const unsigned char ASCII_37[16];/*"%"*/
extern const unsigned char ASCII_38[16];/*"&"*/
extern const unsigned char ASCII_39[16];/*","*/
extern const unsigned char ASCII_40[16];/*"("*/
extern const unsigned char ASCII_41[16];/*")"*/
extern const unsigned char ASCII_42[16];/*"*"*/
extern const unsigned char ASCII_43[16];/*"+"*/
extern const unsigned char ASCII_44[16];/*","*/
extern const unsigned char ASCII_45[16];/*"-"*/
extern const unsigned char ASCII_46[16];/*"."*/
extern const unsigned char ASCII_47[16];/*"/"*/
extern const unsigned char ASCII_48[16];/*"0"*/
extern const unsigned char ASCII_49[16];/*"1"*/
extern const unsigned char ASCII_50[16];/*"2"*/
extern const unsigned char ASCII_51[16];/*"3"*/
extern const unsigned char ASCII_52[16];/*"4"*/
extern const unsigned char ASCII_53[16];/*"5"*/
extern const unsigned char ASCII_54[16];/*"6"*/
extern const unsigned char ASCII_55[16];/*"7"*/
extern const unsigned char ASCII_56[16];/*"8"*/
extern const unsigned char ASCII_57[16];/*"9"*/
extern const unsigned char ASCII_58[16];/*":"*/
extern const unsigned char ASCII_59[16];/*";"*/
extern const unsigned char ASCII_60[16];/*"<"*/
extern const unsigned char ASCII_61[16];/*"="*/
extern const unsigned char ASCII_62[16];/*">"*/
extern const unsigned char ASCII_63[16];/*"?"*/
extern const unsigned char ASCII_64[16];/*"@"*/
extern const unsigned char ASCII_65[16];/*"A"*/
extern const unsigned char ASCII_66[16];/*"B"*/
extern const unsigned char ASCII_67[16];/*"C"*/
extern const unsigned char ASCII_68[16];/*"D"*/
extern const unsigned char ASCII_69[16];/*"E"*/
extern const unsigned char ASCII_70[16];/*"F"*/
extern const unsigned char ASCII_71[16];/*"G"*/
extern const unsigned char ASCII_72[16];/*"H"*/
extern const unsigned char ASCII_73[16];/*"I"*/
extern const unsigned char ASCII_74[16];/*"J"*/
extern const unsigned char ASCII_75[16];/*"K"*/
extern const unsigned char ASCII_76[16];/*"L"*/
extern const unsigned char ASCII_77[16];/*"M"*/
extern const unsigned char ASCII_78[16];/*"N"*/
extern const unsigned char ASCII_79[16];/*"O"*/
extern const unsigned char ASCII_80[16];/*"P"*/
extern const unsigned char ASCII_81[16];/*"Q"*/
extern const unsigned char ASCII_82[16];/*"R"*/
extern const unsigned char ASCII_83[16];/*"S"*/
extern const unsigned char ASCII_84[16];/*"T"*/
extern const unsigned char ASCII_85[16];/*"U"*/
extern const unsigned char ASCII_86[16];/*"V"*/
extern const unsigned char ASCII_87[16];/*"W"*/
extern const unsigned char ASCII_88[16];/*"X"*/
extern const unsigned char ASCII_89[16];/*"Y"*/
extern const unsigned char ASCII_90[16];/*"Z"*/
extern const unsigned char ASCII_91[16];/*"["*/
extern const unsigned char ASCII_92[16];/*"/"*/
extern const unsigned char ASCII_93[16];/*"]"*/
extern const unsigned char ASCII_94[16];/*"~"*/
extern const unsigned char ASCII_95[16];/*"_"*/
extern const unsigned char ASCII_96[16];/*"、"*/ 
extern const unsigned char ASCII_97[16];/*"a"*/
extern const unsigned char ASCII_98[16];/*"b"*/
extern const unsigned char ASCII_99[16];/*"c"*/
extern const unsigned char ASCII_100[16];/*"d"*/
extern const unsigned char ASCII_101[16];/*"e"*/
extern const unsigned char ASCII_102[16];/*"f"*/
extern const unsigned char ASCII_103[16];/*"g"*/
extern const unsigned char ASCII_104[16];/*"h"*/
extern const unsigned char ASCII_105[16];/*"i"*/
extern const unsigned char ASCII_106[16];/*"j"*/
extern const unsigned char ASCII_107[16];/*"k"*/
extern const unsigned char ASCII_108[16];/*"l"*/
extern const unsigned char ASCII_109[16];/*"m"*/
extern const unsigned char ASCII_110[16];/*"n"*/
extern const unsigned char ASCII_111[16];/*"o"*/
extern const unsigned char ASCII_112[16];/*"p"*/
extern const unsigned char ASCII_113[16];/*"q"*/
extern const unsigned char ASCII_114[16];/*"r"*/
extern const unsigned char ASCII_115[16];/*"s"*/
extern const unsigned char ASCII_116[16];/*"t"*/
extern const unsigned char ASCII_117[16];/*"u"*/
extern const unsigned char ASCII_118[16];/*"v"*/
extern const unsigned char ASCII_119[16];/*"w"*/
extern const unsigned char ASCII_120[16];/*"x"*/
extern const unsigned char ASCII_121[16];/*"y"*/
extern const unsigned char ASCII_122[16];/*"z"*/
extern const unsigned char ASCII_123[16];/*"{"*/
extern const unsigned char ASCII_124[16];/*"|"*/
extern const unsigned char ASCII_125[16];/*"}"*/
extern const unsigned char ASCII_126[16];/*"'"*/
 
//字符索引
extern const unsigned char *ASCII_ptr[94];


// 开机动画 COXO logo
extern const unsigned char Logo_COXO[1024];


// 复位完成  96*48
extern const unsigned char gImage_HomingFinish[576]; 

// 复位中...  96*48
extern const unsigned char gImage_Homing[576];

// 回吸无效  96*48
extern const unsigned char gImage_NoSuckBack[576];

// 阻力过大 96*48
extern const unsigned char gImage_OPP[576];

// E1 128*64
extern const unsigned char gImage_E1[1024];

// E2 128*64
extern const unsigned char gImage_E2[1024];

// E3 128*64
extern const unsigned char gImage_E3[1024];

// 电量低 自动复位
extern const unsigned char gImage_LowPower[1024];

// 音乐1 16*16
extern const unsigned char gImage_Music1[32];

// 音乐2 16*16
extern const unsigned char gImage_Music2[32];

//药物吸收中 96*48
extern const unsigned char gImage_Drug_absorption[576];

//电量不足96*48
extern const unsigned char gImage_PowerLow[576];

//即将复位96*48
extern const unsigned char gImage_willReturn[576];

#endif

