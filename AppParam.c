/**
  ******************************************************************************
  * @file           : AppParam.c
  * @brief          : 
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "AppParam.h"

/* Private define-------------------------------------------------------------*/


/* Private variables----------------------------------------------------------*/

static void SetInjectLock(uint8_t param);
static void SetLoudLevel(uint8_t param);
static void SetMusicSwitch(uint8_t param);
static void SetMusicStyle(uint8_t param);
static void SetInjectDose(uint8_t param);
static void SetInjectSpeed(uint8_t param);
static void Power_ON(void);
static void Power_OFF(void);

/* Public variables-----------------------------------------------------------*/


enum SysFSM_State_t SysFSM_State = SysFSM_PowerON;

Sys_t Sys=
{
    .Basetime = 0,
    .Language = 1, //中文
    .BlockedForwardFlag = 0,
    .LimitForwardFlag = 0,
	
	.Motor_Regulation_Flag = 0,

    .Battery_AD = 0,
    .Battery_V = 0,
	
	.Vrefint_Bias = 0,
    
	.LineHall_Val = 0,
	
    .NoOperationShutdownCnt = 0,
    
    .ErrorState = NoError,
    .MemoryDataErrorFlag = 0,
	
	.UI_Show_Mode = 0,
	
    .InjDistance = 0,
    .AbsPosition = 0,
    .HomingLoc = 0,
	.HomingOffset = 0,

	.PressureValue = 0,
	.OPP_Value = 90,  ///<20241203将微调值修改为95，原75
	
	.LowPowerFlag = 0,
	.LowPowerWarning = 0,
	
    // 显示参数
    .BatteryLevel = 1,
    .InjectLock = 0,
    .LoudLevel = 1,
    .MusicSwitch = 1,
	.MusicStyle = 1,
    .InjectDose = InjectDose_01mL,
    .InjectSpeed = InjectSpeed_Low,

    .SuckBackFlag = 0,
    .SuckBackLimitFlag = 0,
    .SuckBackFinishFlag = 0,

    .InjectingFlag = 0,
    .HomingFlag = 0,

    .Homing_HallB_1_Loc = 0,
    .Homing_HallB_2_Loc = 0,

    .SetInjectLock = SetInjectLock,
    .SetLoudLevel = SetLoudLevel,
    .SetMusicSwitch = SetMusicSwitch,
	.SetMusicStyle = SetMusicStyle,
    .SetInjectDose = SetInjectDose,
    .SetInjectSpeed = SetInjectSpeed,
    .Power_ON = Power_ON,
    .Power_OFF = Power_OFF,
};
/* Private function prototypes------------------------------------------------*/      





/**
* @name   : SetInjectLock
* @brief  : 设置注射锁
* @param  : param -> LOCKED 锁  UNLOCKED 开
* @retval : None
* @note   : None
*/
static void SetInjectLock(uint8_t param)
{
    if( param == LOCKED )
    {
        Sys.InjectLock = LOCKED;
        UI.Icon_InjectLock(LOCKED);
    }
    else if( param == UNLOCKED )
    {
        Sys.InjectLock = UNLOCKED;
        UI.Icon_InjectLock(UNLOCKED);	
    }
}


/**
* @name   : SetLoudLevel
* @brief  : 设置音量高低
* @param  : param -> 0低 1高
* @retval : None
* @note   : None
*/
static void SetLoudLevel(uint8_t param)
{
    if( param == 0 )
    {
        Sys.LoudLevel = 0;
        UI.Icon_SoundVolume(Sys.LoudLevel);
        Voice.WriteData(AUDIO_ADDR_LoudLeveL_L);
    }
    else if( param == 1  )
    {
        Sys.LoudLevel = 1;
        UI.Icon_SoundVolume(Sys.LoudLevel);	
        Voice.WriteData(AUDIO_ADDR_LoudLeveL_H);		
    }
}


/**
* @name   : SetMusicSwitch
* @brief  : 设置音乐开关
* @param  : param -> 0关 1开
* @retval : None
* @note   : 更新音乐图标
*/
static void SetMusicSwitch(uint8_t param)
{
    if( param == 0 )
    {
      Sys.MusicSwitch = 0;
      UI.Icon_MusicSwitch(0);
    }
    else if( param == 1 )
    {
      Sys.MusicSwitch = 1;
      UI.Icon_MusicSwitch(1);
    }  
}


/**
* @name   : SetMusicStyle
* @brief  : 设置音乐风格
* @param  : param -> 1:风格1  2:风格2
* @retval : None
* @note   : 切换音乐风格，并更新图标
*/
static void SetMusicStyle(uint8_t param)
{
    if( param == 1 ) 
    {
		Sys.MusicStyle = 1;
		UI.Icon_MusicStyle(1);
    }
    else if( param == 2 )
    {
		Sys.MusicStyle = 2;
		UI.Icon_MusicStyle(2);
    }  
}

/**
* @name   : SetInjectDose
* @brief  : 设置注射剂量
* @param  : param -> InjectDose_01mL \ InjectDose_03mL                   
*                    InjectDose_06mL \ InjectDose_09mL
*                    InjectDose_17mL \ InjectDose_18mL                
* @retval : None
* @note   : 更改注射量，更新UI，语音提示
*/
static void SetInjectDose(uint8_t param)
{
    if( param == InjectDose_01mL )
    {
      Sys.InjectDose = InjectDose_01mL;
      UI.Icon_InjectDose(Sys.InjectDose);	
	  Voice.WriteData(AUDIO_ADDR_ZeroOne);
    }
    else if( param == InjectDose_03mL )
    {
      Sys.InjectDose = InjectDose_03mL;
      UI.Icon_InjectDose(Sys.InjectDose);
	  Voice.WriteData(AUDIO_ADDR_ZeroThree);		
    }
    else if( param == InjectDose_06mL )
    {
      Sys.InjectDose = InjectDose_06mL;
      UI.Icon_InjectDose(Sys.InjectDose);
	  Voice.WriteData(AUDIO_ADDR_ZeroSix);		
    }
    else if( param == InjectDose_09mL )
    {
      Sys.InjectDose = InjectDose_09mL;
      UI.Icon_InjectDose(Sys.InjectDose);
	  Voice.WriteData(AUDIO_ADDR_ZeroNine);			
    }
    else if( param == InjectDose_17mL )
    {
      Sys.InjectDose = InjectDose_17mL;
      UI.Icon_InjectDose(Sys.InjectDose);
	  Voice.WriteData(AUDIO_ADDR_OnePotSeven);			
    }	
    else if( param == InjectDose_18mL )
    {
      Sys.InjectDose = InjectDose_18mL;
      UI.Icon_InjectDose(Sys.InjectDose);
	  Voice.WriteData(AUDIO_ADDR_OnePotEight);			
    }	
}


/**
* @name   : SetInjectSpeed
* @brief  : 设置注射速度
* @param  : param -> InjectSpeed_Low
*                    InjectSpeed_Mid
*                    InjectSpeed_High
* @retval : None
* @note   : 更改注射速度，更新UI，语音提示
*/
static void SetInjectSpeed(uint8_t param)
{
    if( param == InjectSpeed_Low )
    {
		Voice.WriteData(AUDIO_ADDR_Low);
		Sys.InjectSpeed = InjectSpeed_Low;
		UI.Icon_InjectSpeed(Sys.InjectSpeed);
        UI.PDL_Or_NOPDL();
    }
    else if( param == InjectSpeed_Mid )
    {
		Voice.WriteData(AUDIO_ADDR_Mid);		
		Sys.InjectSpeed = InjectSpeed_Mid;
		UI.Icon_InjectSpeed(Sys.InjectSpeed);	
    }
    else if( param == InjectSpeed_High )
    {
		Voice.WriteData(AUDIO_ADDR_High);			
		Sys.InjectSpeed = InjectSpeed_High;
		UI.Icon_InjectSpeed(Sys.InjectSpeed);	
    }
    else if( param == InjectSpeed_PDL )
    {
		Voice.WriteData(AUDIO_ADDR_PDL);			
		Sys.InjectSpeed = InjectSpeed_PDL;
		UI.Icon_InjectSpeed(Sys.InjectSpeed);
               
    }
}


/**
* @name   : Power_ON
* @brief  : 打开电源
* @param  : None
* @retval : None
* @note   : None
*/
static void Power_ON(void)
{
    POWER_CRTL(1);
}

/**
* @name   : Power_OFF
* @brief  : 关闭电源
* @param  : None
* @retval : None
* @note   : None
*/
static void Power_OFF(void)
{
    POWER_CRTL(0);
}

/********************************************************
  End Of File
********************************************************/