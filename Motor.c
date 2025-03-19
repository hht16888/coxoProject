/**
  ******************************************************************************
  * @file           : Motor.c
  * @brief          : 
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "Motor.h"

/* 函数声明 -----------------------------------------------------------*/
static void Init(void);
static void Work(void);
static void SetDir(uint8_t dir);
static void SetSpeed_Motor(uint32_t val);
static void SetSpeed_Gear(float val);
static void SetSpeed_Dose(float val);
static void GetSpeed_Motor(void);
static void GetInjDistance(void);

/* 函数声明 ----------------------------------------------------------------*/
static void Start(void);
static void Stop(void);
static void Shutdown(void);
static void GetCurrent(void);
static uint8_t Read_Hall(void);

/* 结构体类型定义 ------------------------------------------------------*/
Motor_t Motor=
{
    .State                   = MOTOR_STATE_STOP,
	.Dir                     = MOTOR_DIR_FORWARD,
	.Blocked                 = MOTOR_BLOCKED_NO,
					         
	.MotorSpeed_SV           = 0,
	.MotorSpeed_PV           = 0,	
	
	.GearSpeed_SV            = 0,
	.GearSpeed_PV            = 0,
	
    .DoseSpeed_SV            = 0,
	.DoseSpeed_PV            = 0,
	
	.Current_AD              = 0,
	.Current_mA              = 0,
					         
	.FBpulseCnt              = 0,
	.FBpulseCnt_Show         = 0,
					         
	.PWM                     = 0,
	.Duty                    = 0,
					         
	.Err                     = 0,
	
	.Flag_UniformSpeed       = 0,
					    		         
	.Init                    = Init,
	.Work                    = Work,
	.SetDir                  = SetDir,
	.SetSpeed_Motor          = SetSpeed_Motor,
	.SetSpeed_Gear           = SetSpeed_Gear,
	.SetSpeed_Dose           = SetSpeed_Dose,
	.Start                   = Start,
	.Stop                    = Stop,
	.Shutdown                = Shutdown,
	.GetSpeed_Motor          = GetSpeed_Motor,
	.GetInjDistance          = GetInjDistance,
	.GetCurrent              = GetCurrent,
	.Read_Hall               = Read_Hall
};


/* 函数体 --------------------------------------------------------------*/

/**----------------------------------------------
  * @name   : Motor_Init
  * @brief  : 马达初始化
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void Init(void)
{
    Motor.Stop();
    Motor.SetSpeed_Motor(0);
}



/**----------------------------------------------
  * @name   : Work
  * @brief  : 马达工作
  * @param  : None
  * @retval : None
  * @note   : 1ms 轮询
  *----------------------------------------------
  */
static void Work(void)
{
    Motor.GetCurrent();  // 读取电机电流
}


/**----------------------------------------------
  * @name   : SetDir
  * @brief  : 马达设定方向
  * @param  : None
  * @retval : None
  * @note   : 只能在停止状态下设定方向
  *----------------------------------------------
  */
static void SetDir(uint8_t dir)
{
	if( (dir == MOTOR_DIR_FORWARD || dir == MOTOR_DIR_BACK) \
		 && Motor.State == MOTOR_STATE_STOP )
	{
	    Motor.Dir = dir;	
	}
}


/**----------------------------------------------
  * @name   : SetSpeed_Motor
  * @brief  : 电机设定速度
  * @param  : val -> 给定电机速度 
  * @retval : None
  * @note   : 0 -- 17500rpm 减速箱最大70rpm，减速比（REDUCTION_RATIO）250
  *----------------------------------------------
  */
static void SetSpeed_Motor(uint32_t val)
{
	uint32_t temp1;
	
	if( val > 17500 ) return;
	Motor.MotorSpeed_SV = val;
	
	temp1 = (val * 100 / REDUCTION_RATIO +5) / 10;
	Motor.GearSpeed_SV = (float)(temp1 / 10);   
	
	temp1 = val * 1000 / REDUCTION_RATIO *243 / 1000000;
	Motor.DoseSpeed_SV = (float)(temp1 / 10);          
}

/**
* @name   : SetSpeed_Gear
* @brief  : 减速箱设定速度
* @param  : val -> 给定减速箱速度*10
*           rang :　0　--　700
* @retval : None
* @note   : 0 -- 70 rpm  减速箱速度      
*/
static void SetSpeed_Gear(float val)
{
	uint32_t temp1;
    if( val > 70.0f ) return;
	Motor.GearSpeed_SV = val;
	
	Motor.MotorSpeed_SV = val * REDUCTION_RATIO;
	
	temp1 = (val * 243 + 5 ) / 1000;
	Motor.DoseSpeed_SV = (float)(temp1 / 10); 
}



/**
* @name   : SetSpeed_Dose
* @brief  : 注射设定速度
* @param  : val -> 给定注射速度*10
* @retval : None
* @note   : 0 -- 1.62 mL/min  注射速度      
*/
static void SetSpeed_Dose(float val)
{
	uint32_t temp1;
	uint8_t val_gain10;
	
    if( val > 1.7 ) return;
	
	Motor.DoseSpeed_SV = val;
	
	temp1 = val * 10  * REDUCTION_RATIO * 10000 / 243; 
	Motor.MotorSpeed_SV = temp1 / 10;
	
	
	temp1 = (Motor.MotorSpeed_SV * 100 / REDUCTION_RATIO +5 ) / 10;
	Motor.GearSpeed_SV = (float)(temp1 / 10); 
}
	

/**----------------------------------------------
  * @name   : Shutdown
  * @brief  : 停车
  * @param  : None
  * @retval : None
  * @note   : 刹车 
  *----------------------------------------------
  */
void Shutdown(void)
{

}


/**----------------------------------------------
  * @name   : GetSpeed_Motor
  * @brief  : 获取当前速度
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void GetSpeed_Motor(void)
{

}


/**----------------------------------------------
  * @name   : GetInjDistance
  * @brief  : 获取路程
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void GetInjDistance(void)
{

}


/**----------------------------------------------
  * @name   : Start
  * @brief  : 马达启动
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Start(void)
{
	
	if( Motor.Err == 0 )
	{
		if( Motor.PWM >= MOTOR_ARR ) Motor.PWM = MOTOR_ARR-1;
		if( Motor.Dir == MOTOR_DIR_FORWARD )
		{
			Motor.State = MOTOR_STATE_RUN_FORWARD;
			timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, MOTOR_ARR);
            //这个设定值是反的，初始值只看Motor.PWM，Motor.PWM是多少初始就是多少
			timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, MOTOR_ARR - Motor.PWM);
		
		//	timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, MOTOR_ARR);
		//	timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, MOTOR_ARR - Motor.PWM);			
		}
		else
		{
			Motor.State = MOTOR_STATE_RUN_BACK;
			timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, MOTOR_ARR);
			timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, MOTOR_ARR - Motor.PWM);	
		
		//	timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, MOTOR_ARR);
		//	timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, MOTOR_ARR - Motor.PWM);			
		}	
		timer_enable(TIMER15); // 调速	
	}
}


/**----------------------------------------------
  * @name   : Stop
  * @brief  : 马达停
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void Stop(void)
{
	Motor.State = MOTOR_STATE_STOP;
	Motor.PWM = 20;
    timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, MOTOR_ARR);
    timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, MOTOR_ARR);
	timer_disable(TIMER15);
}

/**----------------------------------------------
  * @name   : GetCurrent
  * @brief  : 读电流
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void GetCurrent(void)
{
	Motor.Current_AD = Motor_ADC.OutValue;
	Motor.Current_mA = Motor.Current_AD;  // 具体电流尚未转换
}

/**----------------------------------------------
  * @name   : Read_Hall
  * @brief  : 检测霍尔
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static uint8_t Read_Hall(void)
{
    return !(gpio_input_bit_get(GPIOA, GPIO_PIN_3));   
}
