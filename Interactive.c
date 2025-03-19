#include "BLL.h"

/* 静态函数 --------------------------------------------------------------*/

static void cb_TKEY_PRESS_DOWN_Handler();      // 触摸按键 按下事件
static void cb_TKEY_SINGLE_CLICK_Handler();    // 触摸按键 单击事件
static void cb_TKEY_DOUBLE_CLICK_Handler();    // 触摸按键 双击事件
static void cb_TKEY_LONG_PRESS_HOLD_Handler(); // 触摸按键 长按事件
static void cb_TKEY_PRESS_UP_Handler();        // 触摸按键 弹起事件

static void cb_KEY1_PRESS_DOWN_Handler();       // 按键1 按下事件
static void cb_KEY1_SINGLE_CLICK_Handler();     // 按键1 单击事件
static void cb_KEY1_LONG_PRESS_HOLD_Handler();  // 按键1 连按保持事件
static void cb_KEY1_LONG_PRESS_START_Handler(); // 按键1 长按触发事件
static void cb_KEY1_PRESS_UP_Handler();         // 按键1 弹起事件
static void cb_KEY1_DOUBLE_CLICK_Handler();     // 按键1 双击事件

static void cb_KEY2_PRESS_DOWN_Handler();       // 按键2 按下事件
static void cb_KEY2_SINGLE_CLICK_Handler();     // 按键2 单击事件
static void cb_KEY2_LONG_PRESS_HOLD_Handler();  // 按键2 连按保持事件
static void cb_KEY2_LONG_PRESS_START_Handler(); // 按键2 长按触发事件
static void cb_KEY2_PRESS_UP_Handler();         // 按键2 弹起事件
uint8_t KEY2_SingleClied_Flag = 0;
uint8_t KEY2_PressHold_Flag = 0;

static void cb_KEY3_PRESS_DOWN_Handler();       // 按键3 按下事件
static void cb_KEY3_SINGLE_CLICK_Handler();     // 按键3 单击事件
static void cb_KEY3_LONG_PRESS_HOLD_Handler();  // 按键3 连按保持事件
static void cb_KEY3_LONG_PRESS_START_Handler(); // 按键3 长按触发事件
static void cb_KEY3_PRESS_UP_Handler();         // 按键3 弹起事件
uint8_t KEY3_SingleClied_Flag = 0;
uint8_t KEY3_PressHold_Flag = 0;

static void cb_PKEY_PRESS_DOWN_Handler();       // 电源按键 按下事件
static void cb_PKEY_SINGLE_CLICK_Handler();     // 电源按键 单击事件
static void cb_PKEY_PRESS_UP_Handler();         // 电源按键 弹起事件
static void cb_PKEY_LONG_PRESS_START_Handler(); // 电源按键 长按事件

static void ESD_OLED(void);

struct Key_t TKEY;
struct Key_t KEY1;
struct Key_t KEY2;
struct Key_t KEY3;
struct Key_t PKEY;


uint8_t LoudLevel_ChangeFlag = 0;

uint8_t ErrorClockedFlag = 0;  //异常关锁标志位

/**
 * @name   : Interactive_BLL
 * @brief  : 交互
 * @param  : None
 * @retval : None
 * @note   : 1ms轮询
 */
void Interactive_BLL(void)
{
	uint32_t ulInjectedDose;
	static uint8_t sucBars_Num;
	static uint8_t suclastBars_Num;
	
	uint8_t ucRestDose;
	static uint8_t suclastRestDose;
	
	static uint16_t susCnt_Arrow;
	static uint8_t  sucArrow = 1;
	static uint8_t  sucMutex_UniformSpeed;
	
	static uint8_t  sucCnt_Key;
	
	if( sucCnt_Key++ > 5 )
	{
		sucCnt_Key = 0;
		if( SysFSM_State != SysFSM_PowerON ) Key_Ticks(); // 按键轮询
	}
	
	
	if( SysFSM_State == SysFSM_TestFun || SysFSM_State == SysFSM_EnumSelet ) return;
    if( FSM_InjectProcess == InjectProc_NoEncoderHandler) return;
    if( Sys.ErrorState == Err_NoEncoder ) return;
	
//	// 已注射剂量、进度条显示
	ucRestDose = Sys.AbsPosition / ENCODER_NUM_01ML;
	
		if( Motor.Dir == MOTOR_DIR_FORWARD )
		{
			if( ucRestDose > 18 ) ucRestDose = 18;
			UI.Icon_RestDose( ucRestDose );
			UI.Icon_InjectedBars( ucRestDose );  // 进度条同步
		}
		else
		{
			if( ucRestDose < 18 )
			{
				if( ucRestDose == 0 && Sys.SuckBackFlag != 1) UI.Icon_RestDose(1);
				else UI.Icon_RestDose( ucRestDose);
				UI.Icon_InjectedBars( ucRestDose ); // 进度条同步
			}
			else if( ucRestDose >= 18) 
			{
				UI.Icon_RestDose(18);
				UI.Icon_InjectedBars( 18 );
			}
		}
		suclastRestDose = ucRestDose;

	
	// 注射箭头
	if( Motor.State != MOTOR_STATE_STOP )
	{
		// 每500ms箭头流动
		if( susCnt_Arrow++ > 500 )
		{
			susCnt_Arrow = 0;
			UI.Icon_InjectArrow2(Motor.Dir, sucArrow++);
			if( sucArrow == 6 ) sucArrow = 1;			
		}
        
	}
	else sucArrow = 1;
	

        
	
	
	
	
	// 进度条 指示总药量
//	ulInjectedDose = Sys.AbsPosition/10;		
//	ulInjectedDose = ulInjectedDose *100;		
//	sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_01ML;
//	if( sucBars_Num != suclastBars_Num  ) 
//	{
//		UI.Icon_InjectedBars( sucBars_Num );
//		suclastBars_Num = sucBars_Num;	
//	}			

/* 以下2022-12-08之前 */	
//	// 注射进度条 指示单次设定药量
//	if( SysFSM_State == SysFSM_Inject )
//	{
//		ulInjectedDose = Sys.InjDistance/10;  // 松手消失版本			
//		ulInjectedDose = ulInjectedDose *100;
//		if( Sys.InjectDose == InjectDose_01mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_01ML;
//		else if( Sys.InjectDose == InjectDose_03mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_03ML;
//		else if( Sys.InjectDose == InjectDose_06mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_06ML;
//		else if( Sys.InjectDose == InjectDose_09mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_09ML;
////		else if( Sys.InjectDose == InjectDose_17mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_17ML;			
//		else if( Sys.InjectDose == InjectDose_18mL ) sucBars_Num = (ulInjectedDose+101)/ENCODER_NUM_18ML;			
//		if( sucBars_Num != suclastBars_Num  ) 
//		{
//			UI.Icon_InjectedBars( sucBars_Num );
//			suclastBars_Num = sucBars_Num;	
//		}		
//	}
//	

//	
//	// 注射箭头
//	if( Motor.State != MOTOR_STATE_STOP && Motor.Flag_UniformSpeed == 0 )
//	{
//		// 非匀速状态，每500ms箭头流动
//		if( susCnt_Arrow++ > 500 )
//		{
//			susCnt_Arrow = 0;
//			UI.Icon_InjectArrow2(Motor.Dir, sucArrow++);
//			if( sucArrow == 5 ) sucArrow = 1;			
//		}
//	}
//	else if( Motor.Flag_UniformSpeed == 1 && Motor.State != MOTOR_STATE_STOP )
//	{
//		// 匀速状态，每500ms箭头闪烁
//		if( susCnt_Arrow > 1000 ) susCnt_Arrow = 0;
//		else susCnt_Arrow++;
//		if( susCnt_Arrow < 500 && sucMutex_UniformSpeed == 0 )
//		{
//			sucMutex_UniformSpeed = 1;
//			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);	
//		}
//		else if( susCnt_Arrow >= 500 && sucMutex_UniformSpeed == 1 )
//		{
//			sucMutex_UniformSpeed = 0;
//			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 5);			
//		}
//	}
	
	
}

/* 函数体 --------------------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : Key_Config
 * @brief  : 按键配置
 * @param  : None
 * @retval : None
 * @note   : 调用库MicroKey
 *----------------------------------------------
 */
void Key_Config(void)
{
    // 配置触摸按键 TKEY
    Key_Init(&TKEY, read_TKEY_pin, 0);
    Key_Attach(&TKEY, KEY_SINGLE_CLICK, cb_TKEY_SINGLE_CLICK_Handler);
    Key_Attach(&TKEY, KEY_DOUBLE_CLICK, cb_TKEY_DOUBLE_CLICK_Handler);
    Key_Attach(&TKEY, KEY_PRESS_DOWN, cb_TKEY_PRESS_DOWN_Handler);
    Key_Attach(&TKEY, KEY_LONG_PRESS_HOLD, cb_TKEY_LONG_PRESS_HOLD_Handler);
    Key_Attach(&TKEY, KEY_PRESS_UP, cb_TKEY_PRESS_UP_Handler);

    // 配置实体按键1 KEY1
    Key_Init(&KEY1, read_KEY1_pin, 0);
    Key_Attach(&KEY1, KEY_PRESS_DOWN, cb_KEY1_PRESS_DOWN_Handler); 	           // 按下事件
    Key_Attach(&KEY1, KEY_SINGLE_CLICK, cb_KEY1_SINGLE_CLICK_Handler);         // 单击事件
    Key_Attach(&KEY1, KEY_LONG_PRESS_HOLD, cb_KEY1_LONG_PRESS_HOLD_Handler);   // 连按保持事件
    Key_Attach(&KEY1, KEY_LONG_PRESS_START, cb_KEY1_LONG_PRESS_START_Handler); // 长按触发事件
    Key_Attach(&KEY1, KEY_PRESS_UP, cb_KEY1_PRESS_UP_Handler);                 // 弹起事件
    Key_Attach(&KEY1, KEY_DOUBLE_CLICK, cb_KEY1_DOUBLE_CLICK_Handler);         // 双击事件

    // 配置实体按键2 KEY2
    Key_Init(&KEY2, read_KEY2_pin, 0);
    Key_Attach(&KEY2, KEY_PRESS_DOWN, cb_KEY2_PRESS_DOWN_Handler); 	           // 按下事件	
    Key_Attach(&KEY2, KEY_SINGLE_CLICK, cb_KEY2_SINGLE_CLICK_Handler);         // 单击事件
    Key_Attach(&KEY2, KEY_LONG_PRESS_HOLD, cb_KEY2_LONG_PRESS_HOLD_Handler);   // 连按保持事件
    Key_Attach(&KEY2, KEY_LONG_PRESS_START, cb_KEY2_LONG_PRESS_START_Handler); // 长按触发事件
    Key_Attach(&KEY2, KEY_PRESS_UP, cb_KEY2_PRESS_UP_Handler);         // 弹起事件
	
    // 配置实体按键3 KEY3
    Key_Init(&KEY3, read_KEY3_pin, 0);
    Key_Attach(&KEY3, KEY_PRESS_DOWN, cb_KEY3_PRESS_DOWN_Handler); 	           // 按下事件	
    Key_Attach(&KEY3, KEY_SINGLE_CLICK, cb_KEY3_SINGLE_CLICK_Handler);         // 单击事件
    Key_Attach(&KEY3, KEY_LONG_PRESS_HOLD, cb_KEY3_LONG_PRESS_HOLD_Handler);   // 连按保持事件
    Key_Attach(&KEY3, KEY_LONG_PRESS_START, cb_KEY3_LONG_PRESS_START_Handler); // 长按触发事件
    Key_Attach(&KEY3, KEY_PRESS_UP, cb_KEY3_PRESS_UP_Handler);                 // 弹起事件
	
    // 配置电源按键 PKEY
    Key_Init(&PKEY, read_PKEY_pin, 0);
    Key_Attach(&PKEY, KEY_PRESS_DOWN, cb_PKEY_PRESS_DOWN_Handler);             // 按下事件
    Key_Attach(&PKEY, KEY_SINGLE_CLICK, cb_PKEY_SINGLE_CLICK_Handler);         // 单击事件
    Key_Attach(&PKEY, KEY_PRESS_UP, cb_PKEY_PRESS_UP_Handler);                 // 弹起事件
    Key_Attach(&PKEY, KEY_LONG_PRESS_START, cb_PKEY_LONG_PRESS_START_Handler); // 长按事件
	
	Key_Stop(&TKEY);
	Key_Stop(&KEY1);
	Key_Stop(&KEY2);
	Key_Stop(&KEY3);
	Key_Start(&PKEY);
}

/*------------------------------------------- 触摸按键 -----------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : cb_TKEY_PRESS_DOWN_Handler
 * @brief  : 触摸按键按下响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_TKEY_PRESS_DOWN_Handler()
{
	// 启动注射推进
	if( SysFSM_State == SysFSM_Inject )
	{
        Sys.NoOperationShutdownCnt = 0;
		Sys.InjectingFlag = 1;
	}
    
    if (SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET)
    {
        TestFun_Touch_Flag = 1;
        if( VOICE_BUSY == 0 ) Voice.WriteData(AUDIO_ADDR_Song);
    }    
	
	// 触摸测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Touch )
	{
		TestFun_Touch_Flag = 1;
		Voice.WriteData(AUDIO_ADDR_Di);
	}
}

/**
 *----------------------------------------------
 * @name   : cb_TKEY_LONG_PRESS_HOLD_Handler
 * @brief  : 触摸按键连续触发事件
 * @param  : None
 * @retval : None
 * @note   : 连续响应
 *----------------------------------------------
 */
void cb_TKEY_LONG_PRESS_HOLD_Handler()
{
	// 启动注射推进	
	if( SysFSM_State == SysFSM_Inject )
	{
        Sys.NoOperationShutdownCnt = 0;
		Sys.InjectingFlag = 1;
	}

	// 触摸测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Touch )
	{
		TestFun_Touch_Flag = 1;
	}
    
    if (SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET)
    {
        TestFun_Touch_Flag = 1;
        if( VOICE_BUSY == 0 ) Voice.WriteData(AUDIO_ADDR_Song);
    }
    
    
    
    
}

/**
 *----------------------------------------------
 * @name   : cb_TKEY_PRESS_UP_Handler
 * @brief  : 触摸按键弹起响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
void cb_TKEY_PRESS_UP_Handler()
{
	
	// 停止注射推进
	if( SysFSM_State == SysFSM_Inject || SysFSM_State == SysFSM_Fault )
	{
        Sys.NoOperationShutdownCnt = 0;	
		Sys.InjectingFlag = 0;
        OLED.Refresh();
	}	
	
	// 触摸测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Touch )
	{
		TestFun_Touch_Flag = 0;
	}	
	
    if (SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET)
    {
        TestFun_Touch_Flag = 0;
        Voice.WriteData(AUDIO_ADDR_Mute);
    }
    
    
}

/**
 *----------------------------------------------
 * @name   : cb_TKEY_SINGLE_CLICK_Handler
 * @brief  : 触摸按键单击响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
void cb_TKEY_SINGLE_CLICK_Handler()
{
	// 按键压力测试下关机
    if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_KeyPress)
    {
        SysFSM_State = SysFSM_Shutdown;
    }	
}

/**
 *----------------------------------------------
 * @name   : cb_TKEY_DOUBLE_CLICK_Handler
 * @brief  : 触摸按键双击响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
void cb_TKEY_DOUBLE_CLICK_Handler()
{
    
}


/*------------------------------------------- 按键 1 -----------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : cb_KEY1_PRESS_DOWN_Handler
 * @brief  : 按键1按下响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY1_PRESS_DOWN_Handler()
{
	// 按键按压测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_KeyPress )
	{
		Voice.WriteData(AUDIO_ADDR_Di);
	}	
}


/**
 *----------------------------------------------
 * @name   : cb_KEY1_SINGLE_CLICK_Handler
 * @brief  : 按键1短按响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY1_SINGLE_CLICK_Handler()
{
	Sys.NoOperationShutdownCnt = 0;
    //注射锁开关
    if( SysFSM_State == SysFSM_Standby  )
    {
        if( Sys.InjectLock == LOCKED )
        {
            gpio_bit_write(GPIOB, GPIO_PIN_8, 0); //将触摸IC上电
			Sys.SetInjectLock(UNLOCKED); // 解锁状态
			Voice.WriteData(AUDIO_ADDR_InjStart);  // 语音发出：开锁
        }
    }
    else if( SysFSM_State == SysFSM_Inject )
    {
        if( Sys.InjectLock == UNLOCKED )
        {
            Sys.SetInjectLock(LOCKED); // 锁定状态
            if ( Sys.InjectingFlag == 1 ) //在电机在运行过程中关锁的情况下
            {
                gpio_bit_write(GPIOB, GPIO_PIN_8, 1); //将触摸IC下电
                ErrorClockedFlag = 1;  //异常关锁标志位
            }
            else
            {
                gpio_bit_write(GPIOB, GPIO_PIN_8, 0); //触摸芯片不下电
            }
//			gpio_bit_write(GPIOB, GPIO_PIN_8, 0);
			Voice.WriteData(AUDIO_ADDR_InjClose); // 语音发出：关锁	
			Sys.SuckBackFlag = 0;
            if(Sys.InjectingFlag)/*20240824增加*/
            {
//                Sys.InjectingFlag = 0;  // 注射过程中关锁
                OLED.ClearHorizonLine(47,89,39,16);
            }
        }        
    }
	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( Motor.Dir == MOTOR_DIR_FORWARD ) Motor.SetDir(MOTOR_DIR_BACK);
		else Motor.SetDir(MOTOR_DIR_FORWARD);
	}
	
	// 往复运动
/*	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Reciprocate )
	{
		if( TestFun_Reciprocate_Flag == 0 ) TestFun_Reciprocate_Flag = 1;
		else TestFun_Reciprocate_Flag = 0;
	}*/
	// 老化
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Aging )
	{
		if( TestFun_Reciprocate_Flag == 0 ) TestFun_Reciprocate_Flag = 1;
		else TestFun_Reciprocate_Flag = 0;
	}
	
	// 校准
	if( SysFSM_State== SysFSM_TestFun && TestFunList == TestFunList_Calibrate )
	{
		TestFun_ResetCal_Flag = TestFun_ResetCal_Flag == 0 ? 1: 0;
	}
	
	// 单次1.8mL
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Once18mL ) 
	{
		if( TestFun_Once18mL_Flag == 1 ) TestFun_Once18mL_Flag = 0;
		else TestFun_Once18mL_Flag = 1;
	}
}

/**
 *----------------------------------------------
 * @name   : cb_KEY1_LONG_PRESS_START_Handler
 * @brief  : 按键1长按触发时间
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY1_LONG_PRESS_START_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
    // 回吸
    if( SysFSM_State == SysFSM_Inject )
    {
        Sys.SuckBackFlag = 1;
    }
		
	// 设置菜单
	if( SysFSM_State == SysFSM_EnumSelet  )
	{
		KEY2_SingleClied_Flag = 0;
		OLED.Clear();
		OLED.Refresh();
		Sys.SetLoudLevel(1);
		Sys.SetMusicSwitch(1);
		Motor.SetDir(MOTOR_DIR_FORWARD);
		OLED.Clear();
		SysFSM_State = SysFSM_TestFun;
		Key_Start(&TKEY);
	}
	
	// 将复位校准点更新
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Calibrate )
	{
		if( TempHomingOffset > 4000 && TempHomingOffset < 5500 ) Sys.HomingOffset = TempHomingOffset;
	}
}

/**
 *----------------------------------------------
 * @name   : cb_KEY1_LONG_PRESS_HOLD_Handler
 * @brief  : 按键1连按保持事件
 * @param  : None
 * @retval : None
 * @note   : 连续触发
 *----------------------------------------------
 */
static void cb_KEY1_LONG_PRESS_HOLD_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
	
	// 回吸 20230414 回吸改为单次触发，无需长按保持
/*    if( SysFSM_State == SysFSM_Inject  )
    {
        Sys.SuckBackFlag = 1;       
    }*/
	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( Sys.PressureValue > 200)  TestFun_TAT_OPPFlag = 1;
		if( TestFun_TAT_OPPFlag == 0 ) Motor.Start();
		else Motor.Stop();
	}		
}

/**
 *----------------------------------------------
 * @name   : cb_KEY1_DOUBLE_CLICK_Handler
 * @brief  : 按键1双击
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY1_DOUBLE_CLICK_Handler()
{

	
}

/**
 *----------------------------------------------
 * @name   : cb_KEY1_PRESS_UP_Handler
 * @brief  : 按键1弹起事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY1_PRESS_UP_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
	
	// 回吸 20230414 回吸改为单次触发，无需长按保持
/*	if( SysFSM_State == SysFSM_Inject  )
	{
        Sys.SuckBackFlag = 0;       
    }  
*/	
	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		TestFun_TAT_MaxPV = Motor.GearSpeed_PV;
		TestFun_TAT_MaxI = Motor.Current_AD;
		TestFun_TAT_MaxPWM = Motor.Duty;
		TestFun_TAT_OPPFlag = 0;
		Motor.Stop();
		Motor.PWM = 0;
		Motor.Duty = 0;
		Motor.GearSpeed_PV = 0;
	}		
}

/*------------------------------------------- 按键 2 -----------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : cb_KEY2_PRESS_DOWN_Handler
 * @brief  : 按键2按下响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY2_PRESS_DOWN_Handler()
{
	Homing_Key2TriggerFlag = 1;
	// 按键按压测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_KeyPress )
	{
		Voice.WriteData(AUDIO_ADDR_Di);
	}	
}


/**
 *----------------------------------------------
 * @name   : cb_KEY2_SINGLE_CLICK_Handler
 * @brief  : 按键2短按响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY2_SINGLE_CLICK_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
	KEY2_SingleClied_Flag = 1;	

	// 按键3触发时无效
	if( Homing_Key3TriggerFlag == 1 ) return;	
	
    // 切换速度
    if( SysFSM_State == SysFSM_Standby || SysFSM_State == SysFSM_Inject  )
    {
		if (Sys.InjectSpeed == InjectSpeed_PDL) Sys.SetInjectSpeed( InjectSpeed_Low );
		else if( Sys.InjectSpeed == InjectSpeed_Low  ) Sys.SetInjectSpeed( InjectSpeed_Mid );
		else if( Sys.InjectSpeed == InjectSpeed_Mid ) Sys.SetInjectSpeed( InjectSpeed_High );
        else if( Sys.InjectSpeed == InjectSpeed_High ) Sys.SetInjectSpeed( InjectSpeed_PDL );/*20240806增加PDL模式*/
    } 
	//20240815更新注射速度绑定音乐，PDL模式用音乐2，其他模式用音乐1
    OLED.ClearHorizonLine(9, 114, 12, 12); //清除区块
    if(Sys.InjectSpeed != InjectSpeed_PDL)
        OLED.Drawchar_num(1, 3+6, 105+9); //写音乐下标1
    else
        OLED.Drawchar_num(2, 3+6, 105+10); //写音乐下标2

	// 设置菜单
	if( SysFSM_State == SysFSM_EnumSelet )
	{
		if( MenuList > 0  ) MenuList -- ;
	}
	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( Motor.GearSpeed_SV < 70 ) Motor.GearSpeed_SV++;
		Motor.SetSpeed_Gear(Motor.GearSpeed_SV);
	}	
	
	// 压力保护值设定
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET )
	{
		if( Sys.OPP_Value < 180 )   Sys.OPP_Value ++;
	}
	
	// UI测试，切换UI
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_UI )
	{
		UIList++;
		if( UIList == UIList_num_of_list ) UIList = UIList_Null;
	}
	
	// 老化模式下开音乐
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Aging  )
	{
	    if( TestFun_Reciprocate_Music_Flag == 0 )
		{
            TestFun_Reciprocate_Music_Flag = 1;
		}
		else 
		{
			TestFun_Reciprocate_Music_Flag = 0;
			Voice.WriteData(AUDIO_ADDR_Mute);  // 音乐停止	
		}
	}	
	
	
	
}

/**
 *----------------------------------------------
 * @name   : cb_KEY2_LONG_PRESS_START_Handler
 * @brief  : 按键2长按触发时间
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY2_LONG_PRESS_START_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
	
	
	// 按键3触发时无效
	Homing_Key2LongFlag = 1;
	if( Homing_Key3TriggerFlag == 1 )  return;
	Homing_Key2LongFlag = 0;	
	LoudLevel_ChangeFlag = 1;
		
	
    // 切换音量大小
    if( SysFSM_State == SysFSM_Standby || SysFSM_State == SysFSM_Inject  )
    {
		Voice.WriteData(AUDIO_ADDR_Di);
		if( Sys.LoudLevel == 0)  Sys.SetLoudLevel(1); 
		else Sys.SetLoudLevel(0);
    }
	
	
}

/**
 *----------------------------------------------
 * @name   : cb_KEY2_LONG_PRESS_HOLD_Handler
 * @brief  : 按键2连按保持事件
 * @param  : None
 * @retval : None
 * @note   : 连续触发
 *----------------------------------------------
 */
static void cb_KEY2_LONG_PRESS_HOLD_Handler()
{
	static uint8_t sucCnt_Speed_Inc;
	static uint8_t sucCnt_OPP_Inc;
	KEY2_PressHold_Flag = 1;
	Sys.NoOperationShutdownCnt = 0;	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( sucCnt_Speed_Inc++ > 100  )
		{
			sucCnt_Speed_Inc = 0;
			if( Motor.GearSpeed_SV < 70 ) Motor.GearSpeed_SV += 5 ;
			if( Motor.GearSpeed_SV > 70 ) Motor.GearSpeed_SV = 70;
			Motor.SetSpeed_Gear(Motor.GearSpeed_SV);			
		}
	}	
	
	// 压力保护值设定
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET )
	{
		if( sucCnt_OPP_Inc++ > 100 )
		{
			sucCnt_OPP_Inc = 0;
			if( Sys.OPP_Value < 180 )   Sys.OPP_Value = Sys.OPP_Value + 5;
			if( Sys.OPP_Value > 180 )   Sys.OPP_Value = 180;
		
		}
	}		
}

/**
 *----------------------------------------------
 * @name   : cb_KEY2_PRESS_UP_Handler
 * @brief  : 按键2弹起事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY2_PRESS_UP_Handler()
{
	KEY2_PressHold_Flag = 0;
	Homing_Key2TriggerFlag = 0;
	Homing_Key2LongFlag = 0;	
}

/*------------------------------------------- 按键 3 -----------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : cb_KEY3_PRESS_DOWN_Handler
 * @brief  : 按键3按下响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY3_PRESS_DOWN_Handler()
{
	Homing_Key3TriggerFlag = 1;	

	// 按键按压测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_KeyPress )
	{
		Voice.WriteData(AUDIO_ADDR_Di);
	}	
}



/**
 *----------------------------------------------
 * @name   : cb_KEY3_SINGLE_CLICK_Handler
 * @brief  : 按键3短按响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
void cb_KEY3_SINGLE_CLICK_Handler()
{
	Sys.NoOperationShutdownCnt = 0;	
	KEY3_SingleClied_Flag = 1;	

	// 复位双按
	// 按键2触发时无效
	if( Homing_Key2TriggerFlag == 1 ) return;
		
	
    // 切换设定药量
    if( SysFSM_State == SysFSM_Standby || SysFSM_State == SysFSM_Inject && \
		Motor.State == MOTOR_STATE_STOP && FSM_InjectProcess != InjectProc_OPPHandler && Sys.InjectingFlag == 0 )
    {
        if( Sys.InjectDose == InjectDose_01mL ) Sys.SetInjectDose(InjectDose_03mL);
        else if( Sys.InjectDose == InjectDose_03mL ) Sys.SetInjectDose(InjectDose_06mL);
        else if( Sys.InjectDose == InjectDose_06mL ) Sys.SetInjectDose(InjectDose_09mL);
        else if( Sys.InjectDose == InjectDose_09mL ) Sys.SetInjectDose(InjectDose_18mL);
//        else if( Sys.InjectDose == InjectDose_17mL ) Sys.SetInjectDose(InjectDose_18mL);
        else if( Sys.InjectDose == InjectDose_18mL ) Sys.SetInjectDose(InjectDose_01mL);  
    }  
		
//    // 音乐开关(注射中短按)
//    if( SysFSM_State == SysFSM_Inject && Sys.InjectingFlag == 1 )
//    {    
//    	if( Sys.MusicSwitch == 0 )  Sys.SetMusicSwitch(1);
//		else 
//		{
//			Sys.SetMusicSwitch(0);
//			Voice.WriteData(AUDIO_ADDR_Mute);			
//		}
//    }	
	// 设置菜单
	if( SysFSM_State == SysFSM_EnumSelet )
	{
		MenuList ++;
		if(  MenuList == MenuList_number_of_List  ) MenuList = 0;
	}

	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( Motor.GearSpeed_SV > 0 ) Motor.GearSpeed_SV--;
		Motor.SetSpeed_Gear(Motor.GearSpeed_SV);
	}

	// 压力保护值设定
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET )
	{
		if( Sys.OPP_Value > 20 )   Sys.OPP_Value --;
	}
	
	// UI测试，切换UI
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_UI )
	{
		UIList--;
		if( UIList == UIList_Null ) UIList = UIList_Work;
	}	

}

/**
 *----------------------------------------------
 * @name   : cb_KEY3_LONG_PRESS_START_Handler
 * @brief  : 按键3长按触发事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY3_LONG_PRESS_START_Handler()
{
	Sys.NoOperationShutdownCnt = 0;

	Homing_Key3LongFlag = 1;
	// 按键2触发时无效
	if( Homing_Key2TriggerFlag == 1 ) return;
	Homing_Key3LongFlag = 0;
	
    // 切换音乐风格
/*    if( SysFSM_State == SysFSM_Standby || ( SysFSM_State == SysFSM_Inject && Sys.InjectingFlag != 1 )  )
    {    
    	if( Sys.MusicStyle == 1 )  Sys.SetMusicStyle(2);
		else Sys.SetMusicStyle(1);
		Voice.WriteData(AUDIO_ADDR_Di);
    }*/
	
//    // 音乐开关
    if( SysFSM_State == SysFSM_Standby || ( SysFSM_State == SysFSM_Inject && Sys.InjectingFlag != 1 )  )
    {    
    	if( Sys.MusicSwitch == 0 )  
		{
			Sys.SetMusicSwitch(1);
            Voice.WriteData(AUDIO_ADDR_MusicOpen);
		}
		else 
		{
			Sys.SetMusicSwitch(0);
            Voice.WriteData(AUDIO_ADDR_MusicClose);
		}
    }
	
	

}

/**
 *----------------------------------------------
 * @name   : cb_KEY3_LONG_PRESS_HOLD_Handler
 * @brief  : 按键3连按保持事件
 * @param  : None
 * @retval : None
 * @note   : 连续触发
 *----------------------------------------------
 */
static void cb_KEY3_LONG_PRESS_HOLD_Handler()
{
    static uint8_t sucCnt_Speed_Dec;
	static uint8_t sucCnt_OPP_Dec;
	
	KEY3_PressHold_Flag = 1;
	
	// 扭矩推力测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_TorqueAndThrust )
	{
		if( sucCnt_Speed_Dec++ > 100 )
		{
			sucCnt_Speed_Dec = 0;	
			if( Motor.GearSpeed_SV > 0 ) Motor.GearSpeed_SV -= 5;
			if( Motor.GearSpeed_SV < 0 ) Motor.GearSpeed_SV = 0;
			Motor.SetSpeed_Gear(Motor.GearSpeed_SV);
		}
	}	

	// 压力保护值设定
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_OPP_SET )
	{
		if( sucCnt_OPP_Dec++ > 100 )
		{
			sucCnt_OPP_Dec = 0;
			if( Sys.OPP_Value > 20 )   Sys.OPP_Value = Sys.OPP_Value - 5;
			if( Sys.OPP_Value < 20 )   Sys.OPP_Value = 20;
		}
	}		
	
}

/**
 *----------------------------------------------
 * @name   : cb_KEY3_PRESS_UP_Handler
 * @brief  : 按键3弹起事件
 * @param  : None
 * @retval : None
 * @note   : 单次触发
 *----------------------------------------------
 */
static void cb_KEY3_PRESS_UP_Handler()
{
	KEY3_PressHold_Flag = 0;
	Homing_Key3TriggerFlag = 0;	
	Homing_Key3LongFlag = 0;
}


/*------------------------------------------- 电源键 -----------------------------------------------------*/
/**
 *----------------------------------------------
 * @name   : cb_PKEY_PRESS_DOWN_Handler
 * @brief  : 电源键“按下”响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
static void cb_PKEY_PRESS_DOWN_Handler()
{
	
	// 按键按压测试
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_KeyPress )
	{
		Voice.WriteData(AUDIO_ADDR_Di);
	}		
}

/**
 *----------------------------------------------
 * @name   : cb_PKEY_SINGLE_CLICK_Handler
 * @brief  : 电源键“单击”响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
static void cb_PKEY_SINGLE_CLICK_Handler()
{

	
	//SysFSM_State = SysFSM_Shutdown; // 2022-11-16
}

/**
 *----------------------------------------------
 * @name   : cb_PKEY_PRESS_UP_Handler
 * @brief  : 电源键“弹起”响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
void cb_PKEY_PRESS_UP_Handler()
{
}

/**
 *----------------------------------------------
 * @name   : cb_PKEY_LONG_PRESS_START_Handler
 * @brief  : 电源键长按响应事件
 * @param  : None
 * @retval : None
 * @note   : 单次响应
 *----------------------------------------------
 */
void cb_PKEY_LONG_PRESS_START_Handler()
{
	//　注射中长按关机
	if( SysFSM_State == SysFSM_Inject && Sys.InjectingFlag == 1 )
    {
        SysFSM_State = SysFSM_Shutdown;
		return;
    }
	
	// 0格电时，按关机键自动复位
	if( SysFSM_State == SysFSM_LowPower ) 
	{
		Sys.HomingFlag = 1;
	}	
    else if( SysFSM_State != SysFSM_PowerON && SysFSM_State != SysFSM_TestFun && TestFunList != TestFunList_KeyPress && \
		Sys.InjectingFlag != 1)
    {
        SysFSM_State = SysFSM_Shutdown;
    }
	
	if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_UI )
    {
        SysFSM_State = SysFSM_Shutdown;
    }
	
	if( SysFSM_State == SysFSM_TestFun )
	{
		SysFSM_State = SysFSM_EnumSelet;
		MenuList = MenuList_TorqueAndThrust;
		SysFSM_State = SysFSM_Shutdown;		
	}
	
	if( SysFSM_State == SysFSM_EnumSelet  )
	{
		OLED.Clear();
        // 分割2横2竖
        OLED.DrawHorizonLine(21, 0, 128, 1);
        OLED.DrawHorizonLine(42, 0, 128, 1);
        OLED.DrawVerticalLine(42, 43, 21, 1);
        OLED.DrawVerticalLine(42, 84, 21, 1);
        // 进度条(框)view
        UI.Icon_InjectedBars(0);			 
        UI.BG_InjectBars();
        // 电池框view
        UI.BG_BatteryLevel(1);
		UI.Icon_BatteryLevel(2);
        // 注射锁
        UI.BG_InjectLock();
        // 音乐view 
		Sys.SetMusicStyle(Sys.MusicStyle);
        // 音量view
        UI.Icon_SoundVolume(Sys.LoudLevel);
        Sys.SetLoudLevel(Sys.LoudLevel);
        // 锁view
        UI.Icon_InjectLock(Sys.InjectLock);
        Sys.SetInjectLock(Sys.InjectLock);
        // 已注射剂量
        UI.Icon_RestDose(Sys.AbsPosition/ENCODER_NUM_01ML);
        // 字符 mL
        UI.Background_Char_mL();
        // 注射剂量
        UI.Icon_InjectDose(Sys.InjectDose);
        // 注射速度
        UI.Icon_InjectSpeed(Sys.InjectSpeed);
        // 注射箭头
        UI.Icon_InjectArrow2(0, 0);		
		SysFSM_State = SysFSM_Standby;
	}

}