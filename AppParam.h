/**
  ******************************************************************************
  * @file           : AppParam.h
  * @brief          : Header for AppParam.c file.
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
	
#ifndef __APPPARAM_H__
#define __APPPARAM_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"


#define LOCKED       0      // 上锁
#define UNLOCKED     1      // 解锁

#define ENCODER_NUM_01ML    5834    //6176
#define ENCODER_NUM_03ML    17502   //18528
#define ENCODER_NUM_06ML    35004   //37056
#define ENCODER_NUM_09ML    52506   //55584
#define ENCODER_NUM_17ML    100000  //105000
#define ENCODER_NUM_18ML    105012  //105000

#define PRESSURE_ZERO_COMP     30
#define PRESSURE_ZERO_15RPM    (193-PRESSURE_ZERO_COMP)
#define PRESSURE_ZERO_25RPM    (250-PRESSURE_ZERO_COMP)
#define PRESSURE_ZERO_35RPM    (337-PRESSURE_ZERO_COMP)
#define PRESSURE_ZERO_45RPM    (426-PRESSURE_ZERO_COMP)
#define PRESSURE_ZERO_55RPM    (526-PRESSURE_ZERO_COMP)
#define PRESSURE_ZERO_65RPM    (627-PRESSURE_ZERO_COMP)

#define STANDBY_TO_POWEROFF_SEC 180


/* enum type -----------------------------------------------------------------*/
// 状态枚举
enum SysFSM_State_t
{
    SysFSM_PowerON = 0,   // 开机
    SysFSM_Standby,       // 待机
    SysFSM_Inject,        // 注射
    SysFSM_Homing,        // 复位
    SysFSM_Fault,         // 故障
    SysFSM_Debug,         // 调试
    SysFSM_Memory,        // 存取
	SysFSM_LowPower,      // 低电量
    SysFSM_Shutdown,      // 关机
	SysFSM_WorkState,     // 以上是工作状态
	SysFSM_EMC,
	SysFSM_EnumSelet,     // 设置菜单选择
	SysFSM_TestFun        // 测试功能
};

/* 注射速度枚举 */
enum InjectSpeed_t
{
    InjectSpeed_Low = 0,     // 低速注射
	InjectSpeed_Mid,         // 中速注射
	InjectSpeed_High,        // 高速注射
    InjectSpeed_PDL          //PDL模式 /*20240805*/
};

/* 剂量枚举 */
enum InjectDose_t
{
	InjectDose_01mL = 0,    
	InjectDose_03mL,
	InjectDose_06mL,
	InjectDose_09mL,
	InjectDose_17mL,
	InjectDose_18mL
}; 

/*错误代码枚举*/
enum ErrorState_t
{
	NoError          = 0,   // 无错误
	Err_HomingBlocking,     // 复位阻塞
    Err_HomingIdling,       // 复位空转
	Err_NoEncoder,          // 无编码反馈
};

/* structure type-------------------------------------------------------------*/
// 运行参数
typedef struct 
{									         
	uint8_t                  Basetime;	                    /* 轮询时基 */
	uint8_t                  Language;                      /* 语言 0英文1中文 */
	uint8_t                  BlockedForwardFlag;            /* 限力标志 */
	uint8_t                  LimitForwardFlag;              /* 前限位标志 */
	
	uint8_t                  Motor_Regulation_Flag;         /* 电机调速标志位 */
				            						         
    uint32_t                 Battery_AD;                    /* 电池AD值*/
	uint32_t                 Battery_V;                     /* 电池电压值*/
	
	int16_t                  Vrefint_Bias;                  /* ADC参考电压偏差 */

	uint16_t                 LineHall_Val;                  /* 线性霍尔的AD值 */
	
	volatile uint8_t         NoOperationShutdownCnt;        /* 无操作自动关机计计数值 */
	
	enum  ErrorState_t       ErrorState;                    /* 错误代码 */

	uint8_t                  MemoryDataErrorFlag;           /* 记忆数据错误 */
	
	uint8_t                  UI_Show_Mode;                  /* 画面显示模式 0：正常   1：弹窗 */

	uint32_t                 InjDistance;                   /* 注射行程 */
	uint32_t                 AbsPosition;                   /* 推杆绝对位置 */
	uint32_t                 HomingLoc;                     /* 复位位置行程 */
	uint16_t                 HomingOffset;                  /* 电子原点与机械原点的差距 */
	
	uint16_t                 PressureValue;                 /* 推杆压力 */
	uint8_t                  OPP_Value;                     /* 压力限定值 */

	uint8_t                  LowPowerFlag;                  /* 低电量标志 */
	uint8_t                  LowPowerWarning;               /* 低电量警告 */	
	
                 
	// 显示参数
	uint8_t                  BatteryLevel;                  /* 电量格数 */
	uint8_t                  InjectLock;                    /* 注射锁   0关1开 */
	uint8_t                  LoudLevel;                     /* 音量格数 0低1高 */
	uint8_t                  MusicSwitch;                   /* 音乐开关 0关1开 */	
	uint8_t                  MusicStyle;                    /* 音乐风格12 */
	enum InjectDose_t        InjectDose;                    /* 注射剂量枚举 */
	enum InjectSpeed_t       InjectSpeed;                   /* 注射速度枚举 */	 
	
	uint8_t                  SuckBackFlag;                  /* 回吸标志 */
	uint8_t                  SuckBackFinishFlag;            /* 回吸完成标志 */
	uint8_t                  SuckBackLimitFlag;             /* 回吸限位 */
				            						         
	uint8_t                  InjectingFlag;                 /* 注射中，相当于注射标志位 */

    uint8_t                  HomingFlag;                    /* 复位标志位 */	
    
	uint32_t                 Homing_HallB_1_Loc;            /* 复位 霍尔前端触发的位置数值 */
	uint32_t                 Homing_HallB_2_Loc;            /* 复位 霍尔后端触发的位置数值 */

	void  (*SetInjectLock)(uint8_t param);   /* 设置注射锁   */
	void  (*SetLoudLevel)(uint8_t param);    /* 设置音量高低 */
	void  (*SetMusicSwitch)(uint8_t param);  /* 设置音乐开关 */
	void  (*SetMusicStyle)(uint8_t parm);    /* 设置音乐风格 */
	void  (*SetInjectDose)(uint8_t param);   /* 设置注射剂量 */	
	void  (*SetInjectSpeed)(uint8_t param);  /* 设置注射速度 */
	void  (*Power_ON)(void);                 /* 打开总电源 */
	void  (*Power_OFF)(void);                /* 关闭总电源 */
	void  (*EnterSetup)(void);               // 设置页面

}Sys_t;



/* extern variables-----------------------------------------------------------*/
extern enum SysFSM_State_t SysFSM_State;
extern Sys_t Sys;


/* extern function prototypes-------------------------------------------------*/


#endif
/********************************************************
  End Of File
********************************************************/

