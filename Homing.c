#include "BLL.h"
 
#define UNLOCK_LENGTH         100       // 解堵长度
#define UNLOCK_FAULT_CURRENT  400      // 解堵失败电流AD
#define BLOCK_LOC_DIFF        10        // 撞位判断         
#define BLOCK_LOC_DIFF_TIME   50       // 撞位时长 
#define ARRIVE_DELAY          20      // 到位延迟时长
#define POSITION_LENGTH       400      // 到位后向前走的长度
#define SLOWDOWN_SPEED        15       // 减速后退时的速度(单位：rpm)

/*-----------------------------------------------
复位启动时可能的情景：
    前堵状态，此时需要解堵且解堵电流会较大；
    正常状态，正常复位；
    后堵状态，已经顶到后限位;   
    故障状态，位置不明确;
           
复位流程：
  
-----------------------------------------------*/

enum FSM_HomingProcess_t FSM_HomingProcess;  // 复位流程枚举
uint8_t Homing_Key2TriggerFlag = 0;
uint8_t Homing_Key2LongFlag = 0;
uint8_t Homing_Key3TriggerFlag = 0;
uint8_t Homing_Key3LongFlag = 0;

/**
* @name   : Homing_BLL
* @brief  : 复位
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
 uint16_t susHall_IntVal;          // 霍尔初始值
 uint16_t susHall_ReadVal;         // 霍尔实时值
 uint16_t susHall_MaxVal;          // 霍尔最大值
 uint16_t susHall_MinVal;          // 霍尔最小值
 uint32_t suiHall_PeakHomingLoc;   // 峰值时的复位位置	
void Homing_BLL(void)
{
    static uint16_t susCnt; 
    static uint8_t  sucLastHallState;
    static uint32_t sulLastHomingLoc;

    static uint16_t susCnt_Unblock;       // 解堵定位计时，防卡死
    static uint16_t susCnt_Position;      // 前进定位计时，防卡死
    static uint16_t susCnt_Finished_Show;
	
	static uint8_t sucFlag_HallTrigger;
	
	static uint32_t susHallPosition;
	
	// 打断复位
	if( Sys.HomingFlag == 0 )
	{
		susCnt = 0;
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
		FSM_HomingProcess = HomingProc_Init;
		SysFSM_State = SysFSM_Standby;
		Motor.Stop();
		UI.Work_UI();
		return;
	}

    // 复位行程检测
    if( FSM_HomingProcess != HomingProc_Init && (Sys.HomingLoc > ENCODER_NUM_18ML + ENCODER_NUM_01ML ) )
    {
        susCnt = 0;
 		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
		FSM_HomingProcess = HoningProc_Fault; 
        Sys.ErrorState = Err_HomingIdling;  // 复位空转
    }
	
	// 复位电流过大保护
	if( Motor.Current_AD > 2000 && FSM_HomingProcess != HomingProc_Running )
	{
		
	
	}
	
	// 临时 无杆运行
	/*	Key_Start(&KEY1);
		Key_Start(&KEY2);
		Key_Start(&KEY3);
		Key_Start(&PKEY); 
		BackDoor();	
	*/
	
	
    // 复位流程
    switch (FSM_HomingProcess)
    {
    // 复位初始化
    case HomingProc_Init:
		sucFlag_HallTrigger = 0;
        susCnt = 0;
        Sys.HomingLoc = 0;  // 复位行程清零，此变量不分方向
	    susHallPosition = 0;
		Key_Stop(&TKEY);
		Key_Start(&KEY1);
		Key_Stop(&KEY2);
		Key_Stop(&KEY3);
        Sys.SetInjectLock(LOCKED);               // 复位时自动上锁
        sucLastHallState = Motor.Read_Hall();    // 记录当前霍尔状态
	    Motor.SetDir(MOTOR_DIR_BACK);            // 设定推杆运行方向
        Motor.SetSpeed_Gear((float)20);          // 设定初始速度
        Motor.PWM = 20;                          // 给定初始PWM，加快启动
        Motor.Stop();   
        susCnt_Unblock = 0;
        if( Sys.AbsPosition == 0 && Sys.MemoryDataErrorFlag == 0 && Sys.ErrorState == NoError ) 
        {
            // 判断已经在原点了
            FSM_HomingProcess = HomingProc_Finished;
        }
        else 
		{
			FSM_HomingProcess = HomingProc_UnblockBack;
			if( Sys.LowPowerWarning != 1 ) UI.Window_UI(WindownShow_Reset);// 显示“复位中”
			else UI.Window_UI(WindownShow_LowPower);
			
			if( Sys.MemoryDataErrorFlag == 1 ) 
			{
				UI.Work_UI();
				UI.Window_UI(WindownShow_Reset);// 显示“复位中”
			}
		}
        break;
    
    // 向后解堵，检测推杆是否卡住
    case HomingProc_UnblockBack:
		susCnt_Unblock ++;
		if( susCnt_Unblock < 5100 )
		{
			Motor.Start();
			Motor.SetDir(MOTOR_DIR_BACK);
			if( Sys.HomingLoc > UNLOCK_LENGTH )
			{
				// 复位行程大于解堵行程，判定为已成功解堵
				if( Sys.AbsPosition > 0 && Sys.AbsPosition < ENCODER_NUM_01ML && Sys.MemoryDataErrorFlag == 0 ) Motor.SetSpeed_Gear((float)20); 
				else Motor.SetSpeed_Gear((float)60); 
				susCnt_Unblock = 0;
				FSM_HomingProcess = HomingProc_Running;
				
				// 霍尔检测初始化
				susHall_IntVal = 208;   // 初始值
				susHall_MaxVal = 0;
				susHall_MinVal = 4095;
				suiHall_PeakHomingLoc = 0;				
			}			
		}
        else // 向后解堵超时4.1s,向前走一段
        {
            Motor.Stop();
			Sys.HomingLoc = 0;
			susCnt = 0;    
			if( susCnt_Unblock > 3200 ) 
			{
				FSM_HomingProcess = HomingProc_UnblockForward;
				Motor.SetDir(MOTOR_DIR_FORWARD);				
				susCnt_Unblock = 0;
			}
        }
        break;

	// 先前走一段再后退
	case HomingProc_UnblockForward:
		susCnt_Unblock ++;
		if( susCnt_Unblock < 4000 )
		{
			Motor.Start();
			if( Sys.HomingLoc > UNLOCK_LENGTH*2 )
			{
				// 复位行程大于解堵行程，判定为已成功解堵
				Motor.Stop();				
				Motor.SetSpeed_Gear((float)70); 
				if( susCnt_Unblock > 2200 )
				{
					susCnt_Unblock = 0;					
					FSM_HomingProcess = HomingProc_Running;
					Motor.SetDir(MOTOR_DIR_BACK);
					
					// 霍尔检测初始化
					susHall_IntVal = 208;   // 初始值
					susHall_MaxVal = 0;
					susHall_MinVal = 4095;
					suiHall_PeakHomingLoc = 0;
								
				}
			}			
		}
        else // 向前解堵超过4s，报错
        {
            Motor.Stop();
            susCnt_Unblock = 0;
			susCnt = 0;
			Sys.ErrorState = Err_HomingBlocking;     
			FSM_HomingProcess = HoningProc_Fault;	
        }	
	
		break;
	
    // 全速后退
    case HomingProc_Running:
		Motor.Start();
		// 霍尔感应 装配在第四个孔位 范围 208 - 292 - 216      208 - 127 - 208
		susHall_ReadVal = Sys.LineHall_Val;
		if( susHall_ReadVal >= susHall_MaxVal && susHall_ReadVal > susHall_IntVal + 30 )  // 极性1
		{
			susHall_MaxVal = susHall_ReadVal;  // 更新极值
			suiHall_PeakHomingLoc = Sys.HomingLoc;  // 记录峰值
			Motor.SetSpeed_Gear((float)20); 
		}
		else if( susHall_ReadVal <= susHall_MinVal && susHall_ReadVal < susHall_IntVal - 30 )  // 极性2
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
		if( Sys.HomingLoc > (suiHall_PeakHomingLoc + Sys.HomingOffset - POSITION_LENGTH) &&\
			Sys.MemoryDataErrorFlag != 1 && sucFlag_HallTrigger == 1  )
		{
			susCnt = 0;
			Motor.Stop();
			susHallPosition = 0;
			sucFlag_HallTrigger = 0;
			FSM_HomingProcess = HomingProc_Finished; 			
		}
		

        // 判断到达原点的条件：堵转定位
        if( sulLastHomingLoc == Sys.HomingLoc / BLOCK_LOC_DIFF )
        {
            if( susCnt++ > BLOCK_LOC_DIFF_TIME )
            {
                // 堵转100ms
                susCnt = 0;
                Motor.Stop();

				if( Sys.MemoryDataErrorFlag != 1 && Sys.AbsPosition < ENCODER_NUM_01ML )  FSM_HomingProcess = HomingProc_Delay; 
				else if( Sys.MemoryDataErrorFlag != 1 && ( Sys.AbsPosition >= ENCODER_NUM_01ML && Sys.AbsPosition < ENCODER_NUM_18ML + 200) )
				{
					Sys.ErrorState = Err_HomingBlocking;     
					FSM_HomingProcess = HoningProc_Fault;					
				}
				else if( Sys.MemoryDataErrorFlag == 1 ) FSM_HomingProcess = HomingProc_Delay;
				else FSM_HomingProcess = HomingProc_Delay;
            }
            sulLastHomingLoc = Sys.HomingLoc / BLOCK_LOC_DIFF;
        }
        else 
        {
            sulLastHomingLoc = Sys.HomingLoc / BLOCK_LOC_DIFF;
            susCnt = 0;
        }

        break;

    // 延时
    case HomingProc_Delay:
        if( susCnt++ > ARRIVE_DELAY )
        {
            susCnt = 0;
			Sys.HomingLoc = 0;
            susCnt_Position = 0;
            Motor.SetDir(MOTOR_DIR_FORWARD);
            Motor.PWM = 20;
            Motor.SetSpeed_Gear(10);
			FSM_HomingProcess = HomingProc_Position;
        }
        break;

    // 定位，往前走一小段，方便下次启动
    case HomingProc_Position:
		Motor.Start();
        if( Sys.HomingLoc > POSITION_LENGTH )  // 向前走POSITION_LENGTH个码
		{
		    Motor.Stop();
			FSM_HomingProcess = HomingProc_Finished;
			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
		}
        if( susCnt_Position++ > 3000 )
        {
            // 前进定位时间大于3s，判定为阻塞
            Motor.Stop();
            susCnt_Position = 0;
			susCnt = 0;
			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
            Sys.ErrorState = Err_HomingBlocking;     
            FSM_HomingProcess = HoningProc_Fault;           
        }
        break;

    // 故障，复位阻塞(解堵失败)、已复位、推杆松脱
    case HoningProc_Fault:
        Motor.Stop();
		Sys.HomingFlag = 0;	
        if( Sys.ErrorState == Err_HomingBlocking )  // 复位解堵失败(复位阻塞)
        {
			FSM_HomingProcess = HomingProc_Init;
            SysFSM_State = SysFSM_Fault;
            UI.Window_UI(WindownShow_E2);// UI显示 E2
        }
        else if( Sys.ErrorState == Err_HomingIdling ) // 复位空转
        {
 			FSM_HomingProcess = HomingProc_Init;
            SysFSM_State = SysFSM_Fault;
            UI.Window_UI(WindownShow_E1);// UI显示 E1
        }
		else if( Sys.ErrorState == Err_NoEncoder )  // 推杆松脱编码丢失
		{
 			FSM_HomingProcess = HomingProc_Init;
            SysFSM_State = SysFSM_Fault;
            UI.Window_UI(WindownShow_E1);// UI显示 E1		
		}
		
        break;

    // 复位完成，画面显示“复位完成”
    case HomingProc_Finished:
        Sys.HomingLoc = 0;
        Sys.AbsPosition = 0;
		UI.Icon_RestDose( 0 );
		Motor.SetDir(MOTOR_DIR_FORWARD);  // 20230206 增加，解决复位完成后显示0.1mL的问题
        FSM_HomingProcess = HomingProc_Finished_Show;
		UI.Work_UI();
        UI.Window_UI(WindownShow_ResetFinish);// UI 显示
		susCnt_Finished_Show = 0;	
        break;

    // 提醒停留，而后返回待机状态
    case HomingProc_Finished_Show:
        if( susCnt_Finished_Show++ > 1500 )
        {
            susCnt_Finished_Show = 0;
			Sys.HomingFlag = 0;				
            SysFSM_State = SysFSM_Standby;
            FSM_HomingProcess = HomingProc_Init;
            Sys.MemoryDataErrorFlag = 0; // 复位完成，消除开机记忆错误
			Sys.UI_Show_Mode = 0;
			UI.Work_UI();
			// 复位完成后，若低电量则自动关机
			if( Sys.LowPowerWarning == 1 || Sys.LowPowerFlag == 1 ) SysFSM_State = SysFSM_Shutdown;
			if( DefaultParam_Flag == 1 ) SysFSM_State = SysFSM_Shutdown;
        }
        break;

    default:
        break;
    }
}


/**
* @name   : Homing_TriggerDetect
* @brief  : 复位触发检测
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Homing_TriggerDetect(void)
{
	if( Homing_Key2LongFlag == 1 && Homing_Key3LongFlag == 1 )
	{
		Homing_Key2LongFlag = 0;
		Homing_Key3LongFlag = 0;
		
		if( SysFSM_State == SysFSM_Inject && FSM_InjectProcess == InjectProc_Init )
		{
			Sys.SetInjectLock(LOCKED); // 锁定状态
			Sys.HomingFlag = 1;
		}		
		else if(SysFSM_State == SysFSM_Fault)
		{
			Sys.HomingFlag = 1;
		}
		else if( SysFSM_State == SysFSM_Standby )
		{
			Sys.HomingFlag = 1;
		}
	}
}

