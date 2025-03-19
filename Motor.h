/**
  ******************************************************************************
  * @file           : Motor.h
  * @brief          : Header for Motor.c file.
  ******************************************************************************
  * @attention
  * 模块信息：
  * Name: DC Gear Motor 
  * ID: GM12-N20VA
  * Gear Motor Technical Data：
  *   Reduction ratio：     250
  *   Rated voltage(VDC):   2.4V
  *   No-load speed(rpm):   58
  *   Rated speed(rpm):     48
  *   Rated torque(kg.cm):  0.37
  *
  * Motor Technical Data:
  *   Motor model: TFF-N20VA-13110
  *   Rated voltage(VDC):   2.4V
  *   No-load speed(rpm):   14800
  *   No-load current(mA):  60    
  *   Rated speed(rpm):     12100
  *   Rated torque(g.cm):   2.5
  *   Rated current(mA):    260
  *   Rated power(W):       0.31
  *   Stall torque(g.cm):   14
  *   Stall current(A):     1.20
      
  ******************************************************************************
  */
	
#ifndef __MOTOR_H__
#define __MOTOR_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"

/* Public define -------------------------------------------------------------*/
#define REDUCTION_RATIO  250    // 减速比

#define MOTOR_PCS      15     // 72M主频， 预分频值
#define MOTOR_ARR      200    // 占满空比，重装载值

/* Private define ------------------------------------------------------------*/


/* enum type -----------------------------------------------------------------*/

// 马达方向
enum MOTOR_Dir
{
	MOTOR_DIR_FORWARD = 0,       // 前进
	MOTOR_DIR_BACK               // 后退
};

// 马达状态
enum MOTOR_State
{  
	MOTOR_STATE_STOP = 0,        // 静止        
	MOTOR_STATE_RUN_FORWARD,     // 前进
	MOTOR_STATE_RUN_BACK         // 后退
};

// 堵转状态
enum MOTOR_Blocked
{
	MOTOR_BLOCKED_NO = 0,       // 不堵
    MOTOR_BLOCKED_FORWARD,      // 前堵
	MOTOR_BLOCKED_BACK          // 后堵
};


/* structure type ------------------------------------------------------------*/
typedef struct 
{
	enum MOTOR_State    State;             // 状态
    enum MOTOR_Dir      Dir;               // 运行方向
	enum MOTOR_Blocked  Blocked;           // 堵转方向   
	
	volatile uint16_t   MotorSpeed_SV;     // 设定速度(单电机速度) SV:Set Value
	volatile uint16_t   MotorSpeed_PV;     // 测量速度(单电机速度) PV:Process Value
	void (*SetSpeed_Motor)(uint32_t val);  // 设定速度_电机 rpm	
	
    float               GearSpeed_SV;      // 设定速度(减速箱)
	float               GearSpeed_PV;	   // 测量速度(减速箱)
	void (*SetSpeed_Gear)(float val);      // 设定速度_减速箱 rpm

	float               DoseSpeed_SV;      // 设定速度(剂量mL)
	float               DoseSpeed_PV;      // 测量速度(剂量mL)
	void (*SetSpeed_Dose)(float val);      // 设定速度_剂量 mL/min

	uint16_t            Current_AD;        // 电流AD值
	uint16_t            Current_mA;        // 电流物理值
	
	volatile uint32_t   FBpulseCnt;        // 反馈脉冲计数
	uint32_t            FBpulseCnt_Show;   // 脉冲数副本
	
	volatile uint8_t    PWM;               // 输出的PWM，脉宽
	volatile uint8_t    Duty;              // 占空比
	
    uint8_t             Err; 	           // 错误代码
	
	uint8_t             Flag_UniformSpeed; // 匀速标志位
	

	void (*Init)(void);                    // 初始化
	
	void (*Work)(void);                    // 轮询
	
  	void (*SetDir)(uint8_t dir);           // 设定方向

	void (*Start)(void);	               // 启动电机
	
	void (*Stop)(void);                    // 停止电机
	
	void (*Shutdown)(void);                // 刹车电机
	
	void (*GetSpeed_Motor)(void);          // 获取电机速度 rpm
	
	void (*GetInjDistance)(void);          // 获取注射位置
	
    void (*GetCurrent)(void);              // 获取电机电流
	
	uint8_t (*Read_Hall)(void);            // 读取霍尔信号
	 
}Motor_t;


/* 外部变量声明  -------------------------------------------------------------*/
extern Motor_t Motor;

/* extern function prototypes-------------------------------------------------*/

#endif
/********************************************************
  End Of File
********************************************************/

