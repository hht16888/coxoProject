/**
  ******************************************************************************
  * @file           : FlashSave.h
  * @brief          : Header for FlashSave.c file.
  ******************************************************************************
  * @attention
  *
  * GD32 flash读写操作
  ******************************************************************************
  */
  
 #ifndef __FLASHSAVE_H__
 #define __FLASHSAVE_H__
 
 /* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"

#define FMC_PAGE_SIZE              ((uint16_t)0x400U)         // 每一页存储1024个字节
#define FMC_WRITE_START_ADDR       ((uint32_t)0x0800FC00U)     // Page63的开始地址
#define FMC_WRITE_END_ADDR         ((uint32_t)0x0800FFFFU)     // Page63的结束地址

typedef struct 
{
	uint8_t  data_valid_flag;        // 数据有效标志 0xF1 有效 其余无效
	uint8_t  F_WR_flag;              // 历史读写标志位 0上次没写入 1上次有写入
    uint8_t  F_LoudLevel;            // 音量等级 
    uint8_t  F_MusicStyle;           // 音乐风格  
    uint32_t F_AbsPosition;          // 推杆的绝对位置 
    uint8_t  F_InjectDose;           // 注射设定剂量
    uint8_t  F_InjectSpeed;          // 注射速度
	uint8_t  F_OPP_Value;            // 限力保护
	uint8_t  F_Language;             // 语言
	uint16_t F_HomingOffset;         // 霍尔定位
	uint8_t  F_BatteyLevel;          // 电量等级
    uint8_t  F_MusicSwitch;          //音乐开关
}FlashData_t;

typedef union
{
    FlashData_t FlashData;
	uint32_t data[30];
}FlashData_union;

typedef struct
{
	int (*Write)(FlashData_t *params);	
	int (*Read)(FlashData_t *ReadData);
	int (*isAvaliable)(void);
}FlashTool_t;



extern int Load_Config_Params(void);
extern FlashData_t *Get_Config_Params(void);
extern int is_Config_Params_Avaliable(void);
extern int Save_Config_Params(FlashData_t *params);

extern FlashData_t FlashWriteData;
extern FlashData_t FlashReadData;
extern FlashTool_t FlashTool;

#endif
 
 