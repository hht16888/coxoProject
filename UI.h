/**
  ******************************************************************************
  * @file           : BLL_UI.h
  * @brief          : Header for BLL_UI.c file.
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
	
#ifndef __BLL_UI_H__
#define __BLL_UI_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"


/* structure type-------------------------------------------------------------*/


enum WindownShow_t
{
	WindownShow_Null,
	WindownShow_Reset,
	WindownShow_E1,
	WindownShow_E2,
	WindownShow_E3,
	WindownShow_ResetFinish,
	WindownShow_OPP,
	WindownShow_LowPower,
	WindownShow_NoSuckBack,
    WindownShow_Drug_absorption,/*20240826增加药物吸收中弹窗*/
    WindownShow_PowerLow,/*20241102增加电量不足弹窗*/
    WindownShow_willReturn,/*20241102增加即将复位弹窗*/
};


typedef struct 
{
    void (*Work_Refresh)(void);                             // 工作页面定时刷新
    
    uint8_t (*StartupCartoon)(void);                        // 开机动画
    void (*ShutdownCartoon)(void);                          // 关机动画

    void (*Work_UI)(void);                                  // 工作画面UI
    void (*Window_UI)(uint8_t param);                       // 全屏弹窗UI

    void (*DrawBackground)(void);                           // 画背景
    void (*Background_Char_mL)(void);
	
    void (*BG_BatteryLevel)(uint8_t pram);                  // 电池框 Background
	  void (*BG_BatterLevel_Toggle)(void);                  // 电池框闪烁
    void (*Icon_BatteryLevel)(uint8_t level);               // 电池格数Icon
	
    void (*BG_MusicSwitch)(void);                           // 音乐图标背景
    void (*Icon_MusicSwitch)(uint8_t sta);                  // 音乐开关Icon
	void (*Icon_MusicStyle)(uint8_t param);                 // 音乐风格图标
 
    void (*BG_InjectLock)(void);                            // 注射锁背景
    void (*Icon_InjectLock)(uint8_t sta);                   // 注射锁Icon
	
    void (*BG_SoundVolume)(void);                           // 音量图标背景
    void (*Icon_SoundVolume)(uint8_t sta);                  // 音量大小Icon
	
    void (*BG_InjectBars)(void);                            // 进度条框
    void (*Icon_InjectedBars)(uint8_t n);                   // 注射进度条Icon
    
    /*2024730*/
    void (*Resistance_Feedback)(uint16_t Pressure);     //PDL模式阻力反馈UI
    void (*PDL_Or_NOPDL)();                       //PDL模式与非PDL模式的UI显示差异
	
    void (*Icon_InjectDose)(uint8_t val);                   // 设定注射剂量Icon
	
    void (*Icon_InjectSpeed)(uint8_t  val);                 // 设定注射速度Icon
	
    void (*Icon_InjectArrow)(uint8_t dir,uint8_t num );     // 注射图标指示Icon
	
    void (*Icon_InjectArrow2)(uint8_t dir,uint8_t num );

    void (*Icon_RestDose)(uint8_t num);                     // 剩余药量
    
    
	
}UI_t;

/* extern variables-----------------------------------------------------------*/
extern UI_t UI;
extern enum WindownShow_t WindownShow;
/* extern function prototypes-------------------------------------------------*/


#endif
/********************************************************
  End Of File
********************************************************/

