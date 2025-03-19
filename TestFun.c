#include "BLL.h"

enum TestFunList_t TestFunList = TestFunList_Aging;
void TestFun_BLL(void);

// 老化
void TestFun_Aging(void);

// 校准
uint8_t TestFun_ResetCal_Flag = 0;
uint16_t TempHomingOffset = 0;
enum ResetCalProc_t FSM_ResetCalProc = ResetCalProc_Init;
void TestFun_Calibrate(void);

// 转矩和推力
float TestFun_TAT_MaxPV = 0;
uint16_t TestFun_TAT_MaxPWM = 0;
uint16_t TestFun_TAT_MaxI = 0;
uint8_t  TestFun_TAT_OPPFlag = 0;
void TestFun_TorqueAndThrust(void);

// 单次1.8mL
uint8_t TestFun_Once18mL_Flag = 0;
extern void TestFun_Once18mL(void);

// 出厂设置
uint8_t DefaultParam_Flag = 0;
void TestFun_DefaultParam(void);

// 触摸测试
uint8_t TestFun_Touch_Flag = 0;
void TestFun_Touch();

// 限力设置
void TestFun_OPP_SET(void);

// 按键压力测试
void TestFun_KeyPress(void);

// 往复
uint8_t TestFun_Reciprocate_Music_Flag = 0;
uint8_t TestFun_Reciprocate_LowPowerFlag = 0;
uint8_t TestFun_Reciprocate_Flag = 0;
uint8_t TestFun_Reciprocate_Homing_OverFlag = 0;
uint8_t TestFun_Reciprocate_Homing_RunningFlag = 0;
void TestFun_Reciprocate(void);
void TestFun_Reciprocate_Homing(void);
// 音乐

void TestFun_Music(void);
// UI调试
enum UIList_t UIList = UIList_Work;
void TestFun_UI(void);

/**
* @name   : TestFun_TorqueAndThrust
* @brief  : 转矩和推力
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_BLL(void)
{
	static uint8_t sucCnt_Refresh;
	
	switch( TestFunList )
	{
	
	// 老化
	case TestFunList_Aging:
		//TestFun_Aging();
		TestFun_Reciprocate();
		break;
	
	// 校准
	case TestFunList_Calibrate:
		TestFun_Calibrate();
		break;		
	
	// 扭矩和推力测试
	case TestFunList_TorqueAndThrust:
		TestFun_TorqueAndThrust();
		break;

	// 单次行走1.8mL
    case TestFunList_Once18mL:
		TestFun_Once18mL();
		break;
		
	// 恢复出厂默认参数
	case TestFunList_DefaultParam:
		TestFun_DefaultParam();
		break;
	
	// 触摸测试
	case TestFunList_Touch:
		Key_Start(&TKEY);
		TestFun_Touch();	
		break;	

	// 压力保护设置
	case TestFunList_OPP_SET:
		TestFun_OPP_SET();
		break;
	
	// 按键压力测试
	case TestFunList_KeyPress:
		TestFun_KeyPress();
		break;
	
	// 往复运动
	case TestFunList_Reciprocate:
		TestFun_Reciprocate();
		break;
	
	// 音乐调试
	case TestFunList_Music:
		TestFun_Music();
		break;
	
	// UI测试
	case TestFunList_UI:
		TestFun_UI();
		break;
	
	default: break;
	}	
}



/**
* @name   : TestFun_Aging
* @brief  : 老化测试
* @param  : None
* @retval : None
* @note   : 来回往返
*/
void TestFun_Aging(void)
{


}

/**
* @name   : TestFun_UI
* @brief  : UI测试
* @param  : None
* @retval : None
* @note   : 切换所有UI
*/
void TestFun_UI(void)
{
	
	switch ( UIList )
	{
		case UIList_Null:
			OLED.Clear();
			break;
		
		case UIList_Work:
			UI.Work_UI();
			break;		
		
		case UIList_Homing:
			UI.Window_UI(WindownShow_Reset);
			break;	

		case UIList_HomingFinish:
			UI.Window_UI(WindownShow_ResetFinish);
			break;	

		case UIList_OPP:
			UI.Window_UI(WindownShow_OPP);	
			break;	
		
		case UIList_NoSuckBack:
			UI.Window_UI(WindownShow_NoSuckBack);	
			break;	
		
		case UIList_LowPower:
			UI.Window_UI(WindownShow_LowPower);
			break;	

		case UIList_E1:
			UI.Window_UI(WindownShow_E1);
			break;	

		case UIList_E2:
			UI.Window_UI(WindownShow_E2);
			break;	

		case UIList_E3:
			UI.Window_UI(WindownShow_E3);
			break;	
	
		default:
			break;
	}
}


/**
* @name   : TestFun_DefaultParam
* @brief  : 恢复出厂设置参数
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_DefaultParam()
{
	static uint8_t sucCnt_Refresh;
	static uint8_t sucStep;
	static uint16_t susCnt;
	if( sucCnt_Refresh++ > 100  )
	{

	}		
	Sys.SetInjectSpeed( InjectSpeed_Low );
	Sys.SetLoudLevel(1); 
	delay_1ms(1);
	Sys.SetInjectDose(InjectDose_01mL); 
	Sys.SetMusicStyle(1);
	Voice.WriteData(AUDIO_ADDR_Di);
	delay_1ms(1);
	//Sys.OPP_Value = 75;
	DefaultParam_Flag = 1;
	Sys.HomingFlag = 1;
	SysFSM_State = SysFSM_Homing;

}

/**
* @name   : TestFun_Once18mL
* @brief  : 单次行走1.8mL 
* @param  : None
* @retval : None
* @note   : 1ms轮询，在原点时才能触发
*/
uint16_t susFlash;
volatile uint8_t suc18mLStep;
void TestFun_Once18mL()
{
	static uint8_t sucCnt_Refresh;
	static uint16_t susCnt;


		sucCnt_Refresh = 0;
		OLED.ShowString(0,0,"%3dV", Sys.Battery_V );
        if( Sys.AbsPosition < ENCODER_NUM_18ML + 1000  ) OLED.ShowString(1, 0, "     %2.1f mL", (float)(Sys.AbsPosition/ENCODER_NUM_01ML)/10);
	    if( suc18mLStep == 2  ) OLED.ShowString(3, 0, "  <----------   ");
	    else OLED.ShowString(3, 0, "   -----------  ");		

	
	// 控制流程
	switch ( suc18mLStep )
	{
		case 0:
			if( TestFun_Once18mL_Flag == 1 )
			{
				suc18mLStep = 1;
				Motor.Stop();
			}
			break;
			
		case 1:
			if( Sys.AbsPosition == 0 )
			{
				suc18mLStep = 2;
				Motor.Stop();
				Motor.SetDir(MOTOR_DIR_FORWARD);
				Motor.SetSpeed_Gear(60);
				Voice.WriteData(AUDIO_ADDR_Di);
			}
			else
			{
				Motor.Stop();
				TestFun_Once18mL_Flag = 0;
				suc18mLStep = 0;
			}
			break;
			
		case 2:
			Motor.Start();
		    if( Sys.AbsPosition >= ENCODER_NUM_17ML ) Motor.SetSpeed_Gear(40);
				
			if( Sys.AbsPosition >= ENCODER_NUM_18ML || TestFun_Once18mL_Flag == 0 )
			{
				Motor.Stop();
				TestFun_Once18mL_Flag = 0;
				suc18mLStep = 0;
				Voice.WriteData(AUDIO_ADDR_Di);
			}
			
			
			if( Sys.PressureValue > 120 )
			{
				if( susCnt++ > 1000 )
				{
					susCnt = 0;
					Motor.Stop();	
				    TestFun_Once18mL_Flag = 0;
					Voice.WriteData(AUDIO_ADDR_DiDi);
					suc18mLStep = 4;					
					OLED_WriteREG(0xA6);  
					susFlash = 0;
				}
		    }
			else susCnt = 0;	
		    break;
			
	    case 4:
			if( susFlash++ > 1000  ) 
			{
				susFlash = 0;
			}

			
		    if( susFlash == 2 ) 
			{
				OLED_WriteREG(0xA6);  
			}
		    else if( susFlash == 500 ) 
			{
				OLED_WriteREG(0xA7); 
			}
		    break;
			
		default: break;
	}
	
}


/**
* @name   : TestFun_Calibrate
* @brief  : 自校准
* @param  : None
* @retval : None
* @note   : 1ms轮询,复位校准在不错误下可触发,校准霍尔定位
*/
void TestFun_Calibrate(void)
{
	static uint16_t susCnt_Refresh;
	static uint16_t susCnt_Delay;
	static uint16_t susCnt;	
	static uint16_t susHallLoc;
    static uint8_t  sucLastHallState;	
    static uint32_t sulLastHomingLoc;	
    static uint16_t susCnt_Position;
	
	static uint16_t susHall_IntVal;   // 霍尔初始值
	static uint16_t susHall_ReadVal;  // 霍尔实时值
	static uint16_t susHall_MaxVal;   // 霍尔最大值
	static uint16_t susHall_MinVal;   // 霍尔最小值
	static uint32_t suiHall_PeakHomingLoc;   // 峰值时的复位位置
	
		
	if( susCnt_Refresh++ > 200  )
	{
		susCnt_Refresh = 0;
		OLED.Refresh();
		OLED.ShowString(0,0,"Loc:%-7d", Sys.HomingLoc);
		OLED.ShowString(1,0,"State: %d _ %3d", TestFun_ResetCal_Flag, Sys.LineHall_Val);
		OLED.ShowString(2,0,"HallLoc: %-7d", suiHall_PeakHomingLoc);		
	}	

	if( TestFun_ResetCal_Flag == 0 )
	{
		Motor.Stop();
		FSM_ResetCalProc = ResetCalProc_Init;
	}
	
	// 校准流程
	switch ( FSM_ResetCalProc )
	{
	// 校准初始化
	case ResetCalProc_Init:
		susCnt = 0;
		susCnt_Delay = 0;
		Sys.HomingLoc = 0;
		Motor.Stop();
        Motor.SetSpeed_Gear((float)50);    // 设定初始速度
        Motor.PWM = 20;                // 给定初始PWM，加快启动		
		if( TestFun_ResetCal_Flag == 1 )
		{
			OLED.ShowString(3,0,"Value:%-4d   --", Sys.HomingOffset);				
			if( Sys.BatteryLevel >= 1 )  // 电池要两个电以上才能校准
			{
				if( Sys.AbsPosition > ENCODER_NUM_03ML)  // 大于0.3mL则直接后退
				{				
					FSM_ResetCalProc = ResetCalProc_Back;
				}
				else 
				{
					FSM_ResetCalProc = ResetCalProc_Forward;
					susCnt_Delay = 0; 
				}
			}
			else TestFun_ResetCal_Flag = 0;
		}
				
		break;
		
	// 后退空间不够，先前进
	case ResetCalProc_Forward:
		if( Sys.AbsPosition > ENCODER_NUM_03ML )
		{
			FSM_ResetCalProc = ResetCalProc_SpeedDown;   // 减速
			susCnt_Delay = 0;
		}
		else
		{
			Motor.Start();
			Motor.SetDir(MOTOR_DIR_FORWARD);   //　以40的速度前进
		}
		
		break;
	
	
	case ResetCalProc_SpeedDown:
		if( susCnt_Delay++ < 2000 )
		{
			Motor.SetSpeed_Gear((float)0);    // 设定速度
			Motor.Start();
		}
		else
		{
			Motor.Stop();
			Motor.PWM = 40; 
			Motor.SetSpeed_Gear((float)50);    // 设定初始速度				
			FSM_ResetCalProc = ResetCalProc_Back;
	
			// 霍尔检测初始化
			susHall_IntVal = Sys.LineHall_Val;   // 初始值
			susHall_MaxVal = 0;
			susHall_MinVal = 4095;
			suiHall_PeakHomingLoc = 0;			
		}
	
		break;
		
	// 	可以后退
	case ResetCalProc_Back:

	    Motor.SetDir(MOTOR_DIR_BACK); // 设定推杆运行方向		
		Motor.Start();
	
		susHall_ReadVal = Sys.LineHall_Val;
	
		// 记录霍尔 装配在第四个孔位 范围 208 - 292 - 216      208 - 127 - 208
		if( susHall_ReadVal >= susHall_MaxVal && susHall_ReadVal > susHall_IntVal + 15 )  // 最大值
		{
			susHall_MaxVal = susHall_ReadVal;
			suiHall_PeakHomingLoc = Sys.HomingLoc;
			Motor.SetSpeed_Gear((float)20);
		}
		else if( susHall_ReadVal <= susHall_MinVal && susHall_ReadVal < susHall_IntVal - 15 )
		{
			susHall_MinVal = susHall_ReadVal;
			suiHall_PeakHomingLoc = Sys.HomingLoc;	
			Motor.SetSpeed_Gear((float)20);	
		}
		
        // 判断到达原点的条件
        if( sulLastHomingLoc == Sys.HomingLoc / 5 )
        {
            if( susCnt++ > 80  || Motor.Current_mA > 600 )
            {
                // 堵转100ms
                susCnt = 0;
                Motor.Stop();
				suiHall_PeakHomingLoc = Sys.HomingLoc - suiHall_PeakHomingLoc; // 记录机械原点和峰值点距离
                FSM_ResetCalProc = ResetCalProc_Delay; 
            }
            sulLastHomingLoc = Sys.HomingLoc / 5;
        }
        else
        {
            sulLastHomingLoc = Sys.HomingLoc / 5;
            susCnt = 0;
        }		
		
	// 延时	
	case ResetCalProc_Delay:
        if( susCnt++ > 100 )
        {
            susCnt = 0;
			Sys.HomingLoc = 0;
            susCnt_Position = 0;
            Motor.SetDir(MOTOR_DIR_FORWARD);
            Motor.PWM = 20;
            Motor.SetSpeed_Gear(10);
			FSM_ResetCalProc = ResetCalProc_Position;
        }		
		break;
	
	// 定位，向前走150个码
	case ResetCalProc_Position:
		Motor.Start();
        if( Sys.HomingLoc > 150 )  // 向前走150个码 同 POSITION_LENGTH( Homing.c )
		{
		    Motor.Stop();
			FSM_ResetCalProc = ResetCalProc_Finish;
		}
		
        if( susCnt_Position++ > 3000 )
        {
            // 前进定位时间大于3s，判定为阻塞
            Motor.Stop();
            susCnt_Position = 0;
			susCnt = 0;    
            FSM_ResetCalProc = ResetCalProc_Fault;           
        }		
		break;
		
		
	case ResetCalProc_Fault:
		Motor.Stop();	
		FSM_ResetCalProc = ResetCalProc_Init;
		TestFun_ResetCal_Flag = 0;
		break;
	
	case ResetCalProc_Finish:
		Sys.AbsPosition = 0;
		Motor.Stop();
		TempHomingOffset = suiHall_PeakHomingLoc;
		FSM_ResetCalProc = ResetCalProc_Init;
		TestFun_ResetCal_Flag = 0;		
		// 将复位校准点更新
		if( TempHomingOffset > 3500 && TempHomingOffset < 6000 ) 
		{
			Sys.HomingOffset = TempHomingOffset;
			OLED.ShowString(3,0,"Value:%-4d   OK", Sys.HomingOffset);				
		}
		else
		{
			Sys.HomingOffset = TempHomingOffset;
			OLED.ShowString(3,0,"Value:%-4d   NG", TempHomingOffset);			
		}
		break;
	}

}


/**
* @name   : TestFun_TorqueAndThrust
* @brief  : 转矩和推力
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_TorqueAndThrust(void)
{
	static uint8_t susCnt_Refresh;
		
	if( susCnt_Refresh++ > 100  )
	{
		susCnt_Refresh = 0;
		OLED.Refresh();
		OLED.ShowString(0,0,"%3dV%4dI%3d% 3d%", Sys.Battery_V, Motor.Current_AD, Motor.Duty, Sys.PressureValue ); //电池电压  电机电流  电机占空比  反馈的阻力
	}
	OLED.ShowString(1,0,"PV:%4.1f|PWM:%-3d%",Motor.GearSpeed_PV, TestFun_TAT_MaxPWM);
	OLED.ShowString(2,0,"SV:%4.1f|AD:%4d",Motor.GearSpeed_SV, TestFun_TAT_MaxI);
	if( Motor.Dir == MOTOR_DIR_FORWARD ) OLED.ShowString(3,0,"<<<%3dE|PV:%3.1f" ,Motor.FBpulseCnt_Show, TestFun_TAT_MaxPV);
	else OLED.ShowString(3,0,">>>%3dE|PV:%3.1f" ,Motor.FBpulseCnt_Show, TestFun_TAT_MaxPV);
}


/**
* @name   : TestFun_Touch
* @brief  : 触摸测试
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_Touch()
{
	static uint16_t susCnt;
	static uint8_t  sucFlag_Once;
	uint8_t ucFlag_1s = 0;
	static uint8_t sucLastState;
	static uint8_t sucHour, sucLastHour;
	static uint8_t sucMin, sucLastMin;
	static uint8_t sucSec, sucLastSec;
	static uint16_t susCnt_Refresh;
		
	if( susCnt_Refresh++ > 500  )
	{
		susCnt_Refresh = 0;
		OLED.Refresh();		
		OLED.ShowString(0, 0,"%-3dV K2*2 clear", Sys.Battery_V);		
	}	
	
	if( TestFun_Touch_Flag == 1 )
	{
		sucLastState = TestFun_Touch_Flag;
		if( susCnt < 1000 ) susCnt ++;
		else 
		{
			ucFlag_1s = 1;
			susCnt = 0;
		}		
	}
	else
	{	
		susCnt = 0;	
	}
		
	OLED.ShowString(1, 0,"State:%d  Flag:%d",TestFun_Touch_Flag, sucFlag_Once);	
	
	if( sucLastState != TestFun_Touch_Flag  && sucFlag_Once == 0)
	{
		sucLastState = TestFun_Touch_Flag;	
		sucFlag_Once = 1;
		sucLastSec = sucSec;
		sucLastMin = sucMin;
		sucLastHour = sucHour;
		Voice.WriteData(AUDIO_ADDR_DiDi);
	}
	OLED.ShowString(3, 0,"  %2d :%2d :%2d",sucLastHour, sucLastMin, sucLastSec );		
	
	if( KEY2_SingleClied_Flag == 1 )
	{
		KEY2_SingleClied_Flag = 0;			
		sucFlag_Once = 0;
		sucLastSec = 0;
		sucLastMin = 0;
		sucLastHour = 0;
		susCnt = 0;
		sucSec = 0;
		sucMin = 0;
		sucHour = 0;
		sucFlag_Once = 0;		
	}
	
	if( ucFlag_1s == 1 )
	{
		ucFlag_1s = 0;
		if( sucSec < 60  ) sucSec++;
	}
	if( sucSec == 60 )
	{
		sucSec = 0;
		Voice.WriteData(AUDIO_ADDR_Di);
		if( sucMin < 60 ) sucMin++;
	}
	if( sucMin == 60 )
	{
		sucHour++;
	}
	OLED.ShowString(2, 0,"  %2d :%2d :%2d",sucHour, sucMin, sucSec );
}


/**
* @name   : TestFun_OPP_SET
* @brief  : 限力设置
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_OPP_SET(void)
{
	static uint16_t sucCnt_Refresh;
    static float cnt;
    Key_Start(&TKEY);
    cnt++;
    if (TestFun_Touch_Flag == 0)
    {
        cnt = 0;
    }
    
	if( sucCnt_Refresh++ > 20  )
	{
		sucCnt_Refresh = 0;
		OLED.ShowString(0, 0," OPP: %3d    ",Sys.OPP_Value);
		OLED.ShowString(1, 0," TKEY: %d   ",TestFun_Touch_Flag);
		OLED.ShowString(2, 0," Time: %4.1f s",cnt/1000);
        OLED.ShowString(3, 0," Ver:1.0.14.1 ");            //当前版本号
		OLED.Refresh();
	}	

}

/**
* @name   : TestFun_KeyPress
* @brief  : 按键压力测试
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_KeyPress(void)
{
	static uint16_t sucCnt_Refresh;
	if( sucCnt_Refresh++ > 100  )
	{
		sucCnt_Refresh = 0;
		OLED.Refresh();
	}		
	OLED.ShowString(0, 0,"  KeyPress...  ");
}


/**
* @name   : TestFun_Reciprocate
* @brief  : 往复运动
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_Reciprocate(void)
{
	static uint8_t  sucStep;
	static uint16_t susCnt_Delay;
	static uint16_t sucCnt_Refresh;
	if( sucCnt_Refresh++ > 500  )
	{
		sucCnt_Refresh = 0;
		OLED.Refresh();
	}		
	
	if( Sys.BatteryLevel == 0 ) TestFun_Reciprocate_LowPowerFlag = 1;
	else TestFun_Reciprocate_LowPowerFlag = 0;
	
	if( TestFun_Reciprocate_Flag == 1 ) OLED.ShowString(0, 0, "%3dV%d Running..", Sys.Battery_V,Sys.BatteryLevel);	
	else OLED.ShowString(0, 0, "%3dV%d  Stop     ", Sys.Battery_V,Sys.BatteryLevel);
	OLED.ShowString(1, 0, "%2.1frpm  %ld",Motor.GearSpeed_PV,  Sys.AbsPosition);
	if(Sys.AbsPosition < ENCODER_NUM_17ML + 1000  ) OLED.ShowString(2, 0, "%2.1fmL     %3d_H", (float)(Sys.AbsPosition/ENCODER_NUM_01ML)/10, Sys.LineHall_Val);
	if( sucStep == 1  ) OLED.ShowString(3, 0, "  <----------   ");
	else if( sucStep == 3 ) OLED.ShowString(3, 0, "   ---------->  ");
	else if( sucStep == 4 || sucStep == 0 ) OLED.ShowString(3, 0, "   -----------  ");
	
	
	if( TestFun_Reciprocate_Music_Flag == 1  && VOICE_BUSY == 0) Voice.WriteData(AUDIO_ADDR_Song);
	
	
	switch( sucStep )
	{
		case 0:
			if( TestFun_Reciprocate_Flag == 1 && TestFun_Reciprocate_LowPowerFlag == 0 )
			{
				Motor.SetSpeed_Dose(1.62);
				sucStep = 1;
			//	Sys.AbsPosition  = 0;  无杆运行
			}
			else 
			{
			    TestFun_Reciprocate_Flag = 0;
			}
			break;
			
		case 1:
			if( Sys.AbsPosition < ENCODER_NUM_17ML && Motor.Current_AD < 2000 )
			{
				Motor.SetDir(MOTOR_DIR_FORWARD);
				Motor.Start();	
				if( TestFun_Reciprocate_LowPowerFlag == 1  ) 
				{
					// 前进过程中 电池剩0格，减速
					sucStep = 2;
					susCnt_Delay = 0;
					Motor.SetSpeed_Gear((float)0);
				}
			}
			else
			{
				sucStep = 2;
				susCnt_Delay = 0;
				Motor.SetSpeed_Gear((float)0);			
			}
			break;

		case 2:
			// 1s减速
			if( susCnt_Delay++ > 1000 )
			{
				susCnt_Delay = 0;
				Motor.Stop();
				sucStep = 3;
				TestFun_Reciprocate_Homing_OverFlag = 0;  // 清除复位完成标志
			}
			else Motor.Start();
			break;
	
		case 3:
			TestFun_Reciprocate_Homing();  // 复位运动
			if( TestFun_Reciprocate_Homing_OverFlag == 1 && Sys.AbsPosition == 0) 
			{
				sucStep = 4;  // 完成一次完成
				if( Sys.BatteryLevel == 0 ) SysFSM_State = SysFSM_Shutdown;
			}
			else if( TestFun_Reciprocate_Homing_OverFlag == 1  ) // 没有复位完成
			{
				sucStep = 6;  // 复位保护
				SysFSM_State = SysFSM_Shutdown;
			}

			break;	

		case 4:
			susCnt_Delay = 0;	
			Motor.Stop();
			sucStep = 5;
			break;
			
		case 5:		
			if( susCnt_Delay++ > 1000 )
			{
				susCnt_Delay = 0;
				sucStep = 6;
			}
			break;
			
		case 6:
			sucStep = 0;
			//if( TestFun_Reciprocate_LowPowerFlag == 1 ) SysFSM_State = SysFSM_Shutdown;	
			break;
		
		default: break;
	}
	
	if( TestFun_Reciprocate_Flag == 0  ) 
	{
		Motor.Stop();
		Motor.PWM = 20;
		sucStep = 0;
		susCnt_Delay = 0;
		TestFun_Reciprocate_Flag = 0;
		TestFun_Reciprocate_Homing_RunningFlag = 0;	
		TestFun_Reciprocate_Homing_OverFlag = 1;		
	}		
}

/**
* @name   : TestFun_Reciprocate_Homing
* @brief  : 往复运动下的复位
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_Reciprocate_Homing(void)
{
	static uint8_t  sucStep;
    static uint16_t susCnt; 
    static uint8_t  sucLastHallState;
    static uint32_t sulLastHomingLoc;

	static uint16_t susHall_IntVal;          // 霍尔初始值
	static uint16_t susHall_ReadVal;         // 霍尔实时值
	static uint16_t susHall_MaxVal;          // 霍尔最大值
	static uint16_t susHall_MinVal;          // 霍尔最小值
	static uint32_t suiHall_PeakHomingLoc;   // 峰值时的复位位置	
	
	static uint8_t  sucFlag_HallTrigger;
	// 打断复位
	if( TestFun_Reciprocate_Flag == 0 )
	{
		susCnt = 0;
		sucStep = 0;
		TestFun_Reciprocate_Homing_RunningFlag = 0;
		return;
	}
	
    switch (sucStep)
    {
    case 0:
        susCnt = 0;
        Sys.HomingLoc = 0;
		TestFun_Reciprocate_Homing_OverFlag = 0;
        sucLastHallState = Motor.Read_Hall();
        Motor.Stop();  	
	    Motor.SetDir(MOTOR_DIR_BACK);
        Motor.SetSpeed_Gear((float)60);
        Motor.PWM = 20;
        sucStep = 1;
        break;
    
    case 1:
		TestFun_Reciprocate_Homing_RunningFlag = 1;		
        Motor.Start();
	    Motor.SetDir(MOTOR_DIR_BACK);

		if( Sys.PressureValue > 120 )
		{
			if( susCnt++ > 6000 )
			{
				susCnt = 0;
				sucStep = 0;
				Motor.Stop();	
				TestFun_Reciprocate_Homing_OverFlag = 1;				
			}
		}
        else if( Sys.HomingLoc > 100 )
        {
			susCnt = 0;
            Motor.SetSpeed_Gear((float)60); 
            sucStep = 2;
			
			// 霍尔检测初始化
			susHall_IntVal = 208;   // 初始值
			susHall_MaxVal = 0;
			susHall_MinVal = 4095;
			suiHall_PeakHomingLoc = 0;
        }
		else susCnt = 0;

        break;

    case 2:
		Motor.Start();
		// 霍尔感应 装配在第四个孔位 范围 208 - 292 - 216      208 - 127 - 208
		susHall_ReadVal = Sys.LineHall_Val;
		if( susHall_ReadVal >= susHall_MaxVal && susHall_ReadVal > susHall_IntVal +10 )  // 极性1
		{
			susHall_MaxVal = susHall_ReadVal;  // 更新极值
			suiHall_PeakHomingLoc = Sys.HomingLoc;  // 记录峰值
			Motor.SetSpeed_Gear((float)20); 
		}
		else if( susHall_ReadVal <= susHall_MinVal && susHall_ReadVal < susHall_IntVal -10 )  // 极性2
		{
			susHall_MinVal = susHall_ReadVal;
			suiHall_PeakHomingLoc = Sys.HomingLoc;	
			Motor.SetSpeed_Gear((float)20);	
		}		
		
		// 过峰判断，极性兼容
		if( susHall_MaxVal > susHall_IntVal  ) // 极性1
		{
			if( susHall_ReadVal < susHall_MaxVal - ( susHall_MaxVal - susHall_IntVal)/4 )
			{
				sucFlag_HallTrigger = 1;
			}
		}
		else if( susHall_MinVal < susHall_IntVal  ) // 极性2
		{
			if( susHall_ReadVal > susHall_MinVal + ( susHall_IntVal - susHall_MinVal)/4 )
			{
				sucFlag_HallTrigger = 1;
			}
		}		

	
		// 判断到达原点的条件：霍尔定位
		if( Sys.HomingLoc > (suiHall_PeakHomingLoc + Sys.HomingOffset - 300) &&\
			Sys.MemoryDataErrorFlag != 1 && sucFlag_HallTrigger == 1  )
		{
			susCnt = 0;
			Motor.Stop();
			sucFlag_HallTrigger = 0;
			sucStep = 5; 			
		}
		
		// 判断到达原点条件：行程定位  无杆运行
/*		if( Sys.AbsPosition < ENCODER_NUM_01ML )
		{
			susCnt = 0;
			Motor.Stop();
			sucFlag_HallTrigger = 0;
			sucStep = 5; 			
		}
*/		
		

        // 判断到达原点的条件：堵转定位
        if( sulLastHomingLoc == Sys.HomingLoc / 10 )
        {
            if( susCnt++ > 100 )
            {
                // 堵转100ms
                susCnt = 0;
                Motor.Stop();
				sucStep = 3;
            }
            sulLastHomingLoc = Sys.HomingLoc / 10;
        }
        else 
        {
            sulLastHomingLoc = Sys.HomingLoc / 10;
            susCnt = 0;
        }
		
/*		复位过程中的过流保护
		if( Motor.Current_AD > 3800 ) 
		{
			susCnt = 0;
			Motor.Stop();
			sucStep = 3;			
		}
*/		
        break;

    case 3:
        if( susCnt++ > 100 )
        {
            susCnt = 0;
			Sys.HomingLoc = 0;
            Motor.SetDir(MOTOR_DIR_FORWARD);
            Motor.PWM = 20;
            Motor.SetSpeed_Gear(10);
			sucStep = 4;
        }
        break;

    case 4:
		Motor.Start();
        if( Sys.HomingLoc > 100 )  // 向前走POSITION_LENGTH个码
		{
		    Motor.Stop();
			sucStep = 5;
		}		        
        break;

    case 5:
        Sys.HomingLoc = 0;
        Sys.AbsPosition = 0;
		sucStep = 0;
		TestFun_Reciprocate_Homing_OverFlag = 1;
		TestFun_Reciprocate_Homing_RunningFlag = 0;	
        break;

    default:
        break;
    }
}

/**
* @name   : TestFun_Music
* @brief  : 音乐调试
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void TestFun_Music(void)
{

}

