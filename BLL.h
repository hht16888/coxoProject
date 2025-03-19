/**
  ******************************************************************************
  * @file           : BLL.h
  * @brief          : Business Logic Layer 业务逻辑层
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
	
#ifndef __BLL_H__
#define __BLL_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"

/* structure type-------------------------------------------------------------*/


/* extern variables-----------------------------------------------------------*/
extern uint8_t PownON_Judge;

/* extern function prototypes-------------------------------------------------*/

extern uint8_t PowerON_OverFlag;
extern void PowerON_BLL(void);      // 上电

extern void LowPower_BLL(void);    // 低电量保护

extern void BackDoor(void);

/*  交互业务 Begin  */
extern uint8_t KEY2_SingleClied_Flag;
extern uint8_t KEY3_SingleClied_Flag;
extern uint8_t KEY2_PressHold_Flag;
extern uint8_t KEY3_PressHold_Flag;
extern uint8_t LoudLevel_ChangeFlag;
extern void Interactive_BLL(void);
/*  交互业务 End   */

extern void Standby_BLL(void);  // 待机


/*  注射业务 Begin  */
enum FSM_InjectProcess_t  // 注射过程枚举
{
    InjectIC_PowerOn,
    InjectProc_Init,
	InjectProc_SuckBack,
    InjectProc_SuckBackDisable,
	InjectProc_TouchFiltrate,
    InjectProc_T1,
    InjectProc_T2,   
    InjectProc_T3,
    InjectProc_T4,
	InjectProc_PressureProtection,
    InjectProc_OPPHandler,
	InjectProc_ErrNoEncoder,
	InjectProc_NoEncoderHandler,
    InjectProc_Finished,
	InjectProc_FinishedHandler,
    InjectProc_Reset,
    InjectProc_ResetHandler,
};
extern float LowSpeedDose_Table[100];
extern float MidSpeedDose_Table[100];
extern float HighSpeedDose_Table[100];
extern void  SpeedDoseTable_Init(void);
extern enum  FSM_InjectProcess_t FSM_InjectProcess;
extern void  Inject_BLL(void);
/*  注射业务 End  */

/*  复位业务 Begin  */
enum FSM_HomingProcess_t // 复位过程枚举
{
    HomingProc_Init,           // 初始状态
    HomingProc_UnblockBack,    // 向后解堵
	HomingProc_UnblockForward, // 向前解堵
    HomingProc_Running,        // 全速后退
    HomingProc_Slowdown,       // 减速
    HomingProc_Delay,          // 延时
    HomingProc_Position,       // 定位
    HomingProc_Finished,       // 完成
    HomingProc_Finished_Show,  // 完成时显示停留
    HoningProc_Fault,          // 故障
    HomingProc_End             // 结束
};
extern enum FSM_HomingProcess_t FSM_HomingProcess;
extern uint8_t Homing_Key2TriggerFlag;
extern uint8_t Homing_Key2LongFlag;
extern uint8_t Homing_Key3TriggerFlag;
extern uint8_t Homing_Key3LongFlag;
extern void Homing_TriggerDetect(void);
extern void Homing_BLL(void);
/*  复位业务 End  */


extern void Fault_BLL(void);

extern void Debug_BLL(void);

extern void Memory_BLL(void);

extern void Shutdown_BLL(void);

extern uint8_t sucLevel; 
extern uint8_t sucLast_Level;
extern void Monitor_BLL(void);  // 监测



extern uint8_t Check_BatteryVoltage(void);



// 菜单选择列表
enum MenuList_t
{
	MenuList_Aging,            // 老化
    MenuList_Calibrate,	       // 校准
    MenuList_TorqueAndThrust,  // 扭矩	
	MenuList_Once18mL,         // 一次性走1.8mL
	MenuList_DefaultParam,     // 恢复出厂
    MenuList_OPP_SET,	
//	MenuList_Reciprocate,      
//	MenuList_KeyPress,
//  MenuList_touch,	
//	MenuList_WPT,
	MenuList_number_of_List,	
};
extern enum MenuList_t MenuList;
extern void MenuSelet_BLL(void);


// 测试项目列表
enum TestFunList_t
{
	TestFunList_Aging,
    TestFunList_Calibrate,	
    TestFunList_TorqueAndThrust,
	TestFunList_Once18mL,
	TestFunList_DefaultParam,
	TestFunList_number_of_List,	
    TestFunList_Touch,
    TestFunList_OPP_SET,	
	TestFunList_KeyPress,
	TestFunList_Reciprocate,
	TestFunList_Music,
	TestFunList_UI,

};
extern enum TestFunList_t TestFunList;
extern void TestFun_BLL(void);


// 转矩和推力
extern float TestFun_TAT_MaxPV;
extern uint16_t TestFun_TAT_MaxPWM;
extern uint16_t TestFun_TAT_MaxI;
extern uint8_t  TestFun_TAT_OPPFlag;
extern void TestFun_TorqueAndThrust(void);

// 单次1.8mL
extern uint8_t TestFun_Once18mL_Flag;
extern void TestFun_Once18mL(void);

// 出厂模式参数
extern uint8_t DefaultParam_Flag;
extern void TestFun_DefaultParam(void);

// 触摸测试
extern uint8_t TestFun_Touch_Flag;
extern void TestFun_Touch();

// 复位校准
enum ResetCalProc_t
{
	ResetCalProc_Init,
	ResetCalProc_Back,
	ResetCalProc_Forward,
	ResetCalProc_Delay,
	ResetCalProc_SpeedDown,	
	ResetCalProc_Position,
	ResetCalProc_Fault,
	ResetCalProc_Finish

};
extern enum ResetCalProc_t FSM_ResetCalProc;
extern uint8_t  TestFun_ResetCal_Flag;
extern uint16_t TempHomingOffset;
extern void TestFun_ResetCal(void);

// 限力设置
extern void TestFun_OPP_SET(void);

// 按键压力测试
extern void TestFun_KeyPress(void);

// 往复
extern uint8_t TestFun_Reciprocate_Music_Flag;
extern uint8_t TestFun_Reciprocate_Flag;
extern uint8_t TestFun_Reciprocate_Homing_OverFlag;
extern uint8_t TestFun_Reciprocate_Homing_RunningFlag;
extern void TestFun_Reciprocate(void);
extern void TestFun_Reciprocate_Homing(void);

// 音乐调试
extern void TestFun_Music(void);

// UI测试
enum UIList_t
{
	UIList_Null,
	UIList_Work,
	UIList_Homing,
	UIList_HomingFinish,
	UIList_OPP,
	UIList_NoSuckBack,	
	UIList_LowPower,
	UIList_E1,
	UIList_E2,
	UIList_E3,
	UIList_num_of_list
};
extern enum UIList_t UIList;
extern void TestFun_UI(void);

extern uint8_t ErrorClockedFlag;  //异常关锁标志位
#endif
/********************************************************
  End Of File
********************************************************/