#include "BLL.h"

#define SUCKBACK_TIME  4500   // 回吸时长 ms
#define IC_PowerOnDelay 10     //触摸按键IC上电延时

uint16_t DelayTimeCnt = 0;  //触摸按键上电计数




enum FSM_InjectProcess_t FSM_InjectProcess = InjectIC_PowerOn;

/**
* @name   : Inject_BLL
* @brief  : 注射与回吸
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Inject_BLL()
{
    static uint16_t susCnt_Inject;  // 注射速度时长计数 
    static uint8_t  sucFlag_Injecting;  // 启动注射时置位 
    float usTemp = 0.0f; // 临时变量
	
	static uint16_t susCnt_InjDi;  // 注射“滴”提醒
	
    static uint16_t susCnt_SuckBack;
    static uint8_t  sucFlag_SuckBackFinish;
	static uint16_t susCnt_NoSuckBack_Show;  // 回吸无效显示画面停留
	static uint16_t susCnt_NoSuckBack_DiDi;  // 回吸无效时间隔3s滴滴
	
    static uint16_t susCnt_PressureProtection;      // 压力保护“滴滴”响计数值	
    static uint16_t susCnt_PressureProtection_Show; // 压力保护显示画面停留

    static uint16_t susCnt_ErrNoEncoder;       // 编码丢失“滴滴”响计数值		
	static uint16_t susCnt_ErrNoEncoder_Show;  // 编码丢失E3显示画面停留
    
    static uint8_t PDLOver_ResistanceCnt=0; ///*新增PDL模式的过扭力计数20240826*/
    
    static uint32_t PDLOver_ResistanceDelayCnt=0; ///*新增PDL模式的过扭力延时判断计数20240826*/
    
    static uint8_t  OldStage_Injecting;  /*新增PDL模式的过扭力跳转后原注射阶段20240826*/
	
    static uint16_t  OldStage_InjectingCnt;  /*新增PDL模式的过扭力跳转后原注射阶段计数20240826*/
    
    static uint8_t  Over_Resistance_InjectingFlag;  /*新增PDL模式的进入过扭力后标志位20240826*/
    
	static uint8_t sucAbs_Limit;

    static uint8_t sucFlag_SuckBackDisable;     // 回程不够时失能标志
	
	static uint8_t sucCnt_TouchFiltrate;       // 触摸开关过滤

	static uint8_t sucFlag_TouchFiltrate;   // 触摸开关过滤标志
    
    static uint32_t UI_Flash_Cnt;  //UI刷新计数 500ms刷新一次
    
    static uint32_t ResetDelayCnt;  //药物耗尽后显示弹窗时间
    
    static uint8_t ResetFlag; //复位标志位，该位置1的时候不允许任何操作，除了关机
    
    static uint8_t Reset_pop_up = 0;        //即将复位弹窗出现延时
    
//    static uint8_t last_Presure_Level = 1;
    
    UI_Flash_Cnt++;
    
	
    // 0格电低电量警告
	if( Sys.LowPowerWarning == 1 )
	{
		Motor.Stop();
        OLED.ClearHorizonLine(7, 15, 96, 48);
        UI.Work_UI();
		FSM_InjectProcess = InjectProc_Init;
        Sys.SetInjectLock(LOCKED);
		SysFSM_State = SysFSM_Fault;  // 跳转到故障业务
		Voice.WriteData(AUDIO_ADDR_Mute);  // 音乐停止
		delay_1ms(1);
		return;
	}	
	

	// 返回待机
    if( Sys.InjectLock == LOCKED || Sys.HomingFlag == 1 && ResetFlag == 0 )
    {
        Motor.Stop();
        Key_Stop(&TKEY);            //将触摸按键失能
        Sys.InjDistance = 0;
        susCnt_Inject = 0;
        Sys.InjectingFlag = 0;  // 注射过程中关锁
        sucFlag_Injecting = 0;
        FSM_InjectProcess = InjectIC_PowerOn;   //触摸按键IC上电
        SysFSM_State = SysFSM_Standby;
		//UI.Work_UI();// 画面复原
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);		
        return;             
    }
	
	// 无编码反馈
	if( Sys.ErrorState == Err_NoEncoder )
	{
	//	Sys.ErrorState = NoError;
        if( FSM_InjectProcess != InjectProc_NoEncoderHandler ) 
		{
			susCnt_ErrNoEncoder_Show = 0;		
		    FSM_InjectProcess = InjectProc_ErrNoEncoder;
		}			
	}
	
	// 注射行程监测
	if( Sys.AbsPosition >= ENCODER_NUM_18ML && FSM_InjectProcess != InjectProc_Finished &&\
		Motor.State == MOTOR_STATE_RUN_FORWARD && Sys.SuckBackFlag != 1 && sucFlag_TouchFiltrate == 1 )
	{
        Motor.Stop();
		sucAbs_Limit = 1;
        FSM_InjectProcess = InjectProc_Finished;
	}
	
	// 压力监测
	if( Sys.PressureValue > 119 && FSM_InjectProcess != InjectProc_T1 )
	{
		FSM_InjectProcess = InjectProc_PressureProtection;
        susCnt_PressureProtection = 0;
		if( Sys.InjDistance > ENCODER_NUM_17ML )
		{
			Sys.InjDistance = ENCODER_NUM_18ML;
			sucAbs_Limit = 1;
            Motor.Stop();
            FSM_InjectProcess = InjectProc_Reset;
		}
	}
    
    
    if(Sys.InjectSpeed!=InjectSpeed_PDL && Sys.SuckBackFlag == 0 && UI_Flash_Cnt == 50 && FSM_InjectProcess != InjectProc_PressureProtection\
       && ResetFlag == 0 && FSM_InjectProcess != InjectProc_OPPHandler ) 
    {
        // 注射剂量
        UI.Icon_InjectDose(Sys.InjectDose);
        UI.Background_Char_mL();
    }
    
	
    // 注射中断(触摸按键抬起)
    if( sucFlag_Injecting == 1 && Sys.InjectingFlag == 0  && FSM_InjectProcess != InjectProc_OPPHandler && Sys.InjectLock == UNLOCKED )
    {
		Motor.Flag_UniformSpeed = 0;
        sucFlag_Injecting = 0;
		sucFlag_TouchFiltrate = 0;
		if( Sys.AbsPosition < ENCODER_NUM_18ML || FSM_InjectProcess != InjectProc_Finished && FSM_InjectProcess != InjectProc_PressureProtection ) 
		{
            if ( ErrorClockedFlag != 1 )
            {
                Voice.WriteData(AUDIO_ADDR_Mute);  // 无音乐
                //Voice.WriteData(AUDIO_ADDR_InjStart);  // 语音发出：开锁
                //ErrorClockedFlag = 0;  //异常关锁标志位
            }
            else
            {
                ErrorClockedFlag = 0;  //异常关锁标志位
            }
		}
        
        FSM_InjectProcess = InjectProc_Init;
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);//将注射箭头变成全空的样式
    }
    
    
    if(UI_Flash_Cnt > 500)
        UI_Flash_Cnt = 0;
    



	switch ( FSM_InjectProcess )
    {
    // 注射初始状态，已解锁但IC刚刚上电需要时间稳定电平
    case InjectIC_PowerOn:
        DelayTimeCnt++;
        if(DelayTimeCnt>IC_PowerOnDelay)
        {
            FSM_InjectProcess = InjectProc_Init;
            DelayTimeCnt = 0;
        }
        break;
     //注射初始状态，已触摸IC已稳定电平但注射键未按下
    case InjectProc_Init:
        sucFlag_Injecting = 0;
        Sys.InjDistance = 0;
		Motor.Flag_UniformSpeed = 0;
        Motor.PWM = 25;  // 初始PWM，提高启动速度
        Motor.Stop();
		sucAbs_Limit = 0;
		sucFlag_TouchFiltrate = 0;
		Key_Start(&TKEY);
		Key_Start(&PKEY);
		Key_Start(&KEY1);
		Key_Start(&KEY2);
		Key_Start(&KEY3);	
	
        if( Sys.InjectingFlag == 1 ) // 注射
        {
//            Key_Stop(&KEY1);//20240824修改逻辑，在注射过程中可以关闭注射锁
            FSM_InjectProcess = InjectProc_TouchFiltrate;
			Motor.SetDir(MOTOR_DIR_FORWARD);
            Motor.SetSpeed_Dose(0.15);
            Motor.Start();
			sucCnt_TouchFiltrate = 0;
			susCnt_InjDi = 0;
        }
        else if( Sys.InjectingFlag == 0 && Sys.SuckBackFlag == 0 && FSM_InjectProcess != InjectProc_PressureProtection\
            && FSM_InjectProcess != InjectProc_Reset && FSM_InjectProcess != InjectProc_ResetHandler && UI_Flash_Cnt == 150 ) //SuckBackFlag回吸标志位
        {
            /*20240806增加PDL模式非工作状态下显示注射剂量*/
            OLED.ClearHorizonLine(47,89,39,16);
            // 注射剂量
            UI.Icon_InjectDose(Sys.InjectDose);
            UI.Background_Char_mL();
        }
		else if( Sys.SuckBackFlag == 1 ) // 回吸
		{
            if( Sys.AbsPosition > 100 ) // 能够回吸   // 20230307改：小于0.1mL可以回吸
            {
 		        Key_Stop(&TKEY);
                Key_Stop(&KEY2);
                Key_Stop(&KEY3);
				Voice.WriteData(AUDIO_ADDR_Di);
                FSM_InjectProcess = InjectProc_SuckBack;
                Motor.SetDir(MOTOR_DIR_BACK);
				Motor.PWM = 40;  // 初始PWM，提高启动速度
                Motor.SetSpeed_Gear(60);
                susCnt_SuckBack = 0;
                sucFlag_SuckBackFinish = 0;	
            }
            else // 无法回吸
            {
                UI.Window_UI(WindownShow_NoSuckBack);// UI 显示 回吸无效
				Motor.Dir = MOTOR_DIR_FORWARD;
				Voice.WriteData(AUDIO_ADDR_DiDi);
				susCnt_NoSuckBack_DiDi = 0;
				susCnt_NoSuckBack_Show = 0;
			    FSM_InjectProcess = InjectProc_SuckBackDisable;
            }
		}

        break;

    // 回吸无效
    case InjectProc_SuckBackDisable:
		if( susCnt_NoSuckBack_Show > 2002 )
		{
			Motor.Dir = MOTOR_DIR_FORWARD;
			FSM_InjectProcess = InjectProc_Init;
			UI.Work_UI();// 画面复原
			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
			susCnt_NoSuckBack_DiDi = 0;	
            Sys.SuckBackFlag = 0;			
		}
		else susCnt_NoSuckBack_Show++;
		
		if( susCnt_NoSuckBack_DiDi++ > 2000 ) 
		{
			susCnt_NoSuckBack_DiDi = 0;
			Voice.WriteData(AUDIO_ADDR_DiDi);
		}
		

        break;  
	
	// 回吸
	case InjectProc_SuckBack:
        
		if( Sys.AbsPosition < 100 ) // 回吸限位
        {
            // 回吸完成
            sucFlag_SuckBackFinish = 1;
			Sys.SuckBackFlag = 0;
        }

		if( Sys.SuckBackFlag == 1 && sucFlag_SuckBackFinish == 0 ) 
		{
            // 回吸行程足够，开始回吸
			Motor.Start();
			if( susCnt_SuckBack++ > SUCKBACK_TIME )
			{
                // 回吸时长到
				susCnt_SuckBack = 0;
				sucFlag_SuckBackFinish = 1;
				Sys.SuckBackFlag = 0;
				UI.Icon_InjectArrow2(MOTOR_DIR_BACK, 0);
			}
		}
		else if( sucFlag_SuckBackFinish == 1 ) 
		{
			Motor.Stop();
			susCnt_SuckBack = 0;	
		}


		if( Sys.SuckBackFlag == 0 )  // 回吸中断
		{
			FSM_InjectProcess = InjectProc_Init;
			susCnt_SuckBack = 0;
			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
			Motor.Dir = MOTOR_DIR_FORWARD;
			
		}
		
		break;
	
	// 触摸按键开关过滤
	case InjectProc_TouchFiltrate:
		if( sucCnt_TouchFiltrate++ > 5 )
		{
			sucCnt_TouchFiltrate = 0;
			if( Sys.InjectingFlag == 1)
			{
				sucFlag_Injecting = 1;
				FSM_InjectProcess = InjectProc_T1;
				sucFlag_TouchFiltrate = 1;
			}
			else FSM_InjectProcess = InjectProc_Init;			
		}
		break;
			
    // 第一阶段注射 0-3s 速度从 0 -> 0.42mL/min    
    /*PDL模式直接到目标速度,没有加速过程*/
    case InjectProc_T1:
		Motor.Start();
		if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed!=InjectSpeed_PDL) Voice.WriteData(AUDIO_ADDR_Song);
		else if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed==InjectSpeed_PDL ) Voice.WriteData(AUDIO_ADDR_Song2);
    /*20240815增加PDL模式无加速过程以及减速跟停止判断*/
        if(Sys.InjectSpeed==InjectSpeed_PDL)
        {
            if( !Over_Resistance_InjectingFlag )
                Motor.SetSpeed_Dose(0.42);
            else
            {
                Motor.SetSpeed_Dose(0.22);
            }
            if(Sys.PressureValue<65)
            {
                if( Over_Resistance_InjectingFlag == 1 )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    Motor.SetSpeed_Dose(0.42);
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
            }
            else if(Sys.PressureValue>=65&&Sys.PressureValue<121)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
                Motor.SetSpeed_Dose(0.22);
            }
            else if(Sys.PressureValue>=121)
            {
                PDLOver_ResistanceDelayCnt=0;
                OldStage_Injecting = FSM_InjectProcess;//记录下原注射阶段
                FSM_InjectProcess = InjectProc_PressureProtection;                              
                OldStage_InjectingCnt = susCnt_Inject;//记录下原注射阶段计数
                susCnt_PressureProtection = 0;
                if( Sys.InjDistance > ENCODER_NUM_17ML )
                {
                    Sys.InjDistance = ENCODER_NUM_18ML;
                    sucAbs_Limit = 1;
                    Motor.Stop();
                    FSM_InjectProcess = InjectProc_Reset;  
                }
            }
        }
        else
        {
            Motor.SetSpeed_Dose(0.42);
        }
        if( susCnt_Inject++ > 3000 )
        {
            susCnt_Inject = 0;
            FSM_InjectProcess = InjectProc_T2;
        }
        if ( UI_Flash_Cnt % 100 == 0 )
            UI.PDL_Or_NOPDL(); //PDL模式与非PDL模式的UI显示差异
        break;

    // 第二阶段注射 3-10s 速度 0.42mL/min 匀速
    case InjectProc_T2:
		Motor.Start(); 
		if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed!=InjectSpeed_PDL) Voice.WriteData(AUDIO_ADDR_Song);
		else if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed==InjectSpeed_PDL ) Voice.WriteData(AUDIO_ADDR_Song2);
    /*20240815增加PDL模式无加速过程以及减速跟停止判断*/
        if(Sys.InjectSpeed==InjectSpeed_PDL)
        {
            if( !Over_Resistance_InjectingFlag )
                Motor.SetSpeed_Dose(0.42);
            else
            {
                Motor.SetSpeed_Dose(0.22);
                
            }
            if(Sys.PressureValue<65)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    Motor.SetSpeed_Dose(0.42);
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
            }
            else if(Sys.PressureValue>=65&&Sys.PressureValue<121)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
                Motor.SetSpeed_Dose(0.22);
            }
            else if(Sys.PressureValue>=121)
            {
                PDLOver_ResistanceDelayCnt=0;
                OldStage_Injecting = FSM_InjectProcess;//记录下原注射阶段
                FSM_InjectProcess = InjectProc_PressureProtection;                              
                OldStage_InjectingCnt = susCnt_Inject;//记录下原注射阶段计数
                susCnt_PressureProtection = 0;
                if( Sys.InjDistance > ENCODER_NUM_17ML )
                {
                    Sys.InjDistance = ENCODER_NUM_18ML;
                    sucAbs_Limit = 1;
                    Motor.Stop();
                    FSM_InjectProcess = InjectProc_Reset;  
                }
            }
        }
        else
        {
            Motor.SetSpeed_Dose(0.42);
        }
        
        if( susCnt_Inject++ > 7000 )
        {
            susCnt_Inject = 0;
            FSM_InjectProcess = InjectProc_T3; 
        }
        if ( UI_Flash_Cnt % 100 == 0 )
            UI.PDL_Or_NOPDL(); //PDL模式与非PDL模式的UI显示差异
        break;

    // 第三阶段注射 10-20s
    // 低速模式： 0.42 -> 0.42 mL/min
    // 中速模式： 0.42 -> 1.02 mL/min
    // 高速模式： 0.42 -> 1.62 mL/min        
    case InjectProc_T3:
		if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed!=InjectSpeed_PDL) Voice.WriteData(AUDIO_ADDR_Song);
		else if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed==InjectSpeed_PDL ) Voice.WriteData(AUDIO_ADDR_Song2);
		Motor.Start(); 
	
	// 查表法
        if( Sys.InjectSpeed == InjectSpeed_Low )
        {
			usTemp = LowSpeedDose_Table[susCnt_Inject/100];
            Motor.SetSpeed_Dose(usTemp);
        }
        else if( Sys.InjectSpeed == InjectSpeed_Mid )
        {
			usTemp = MidSpeedDose_Table[susCnt_Inject/100];
            Motor.SetSpeed_Dose(usTemp);
        }
        else if( Sys.InjectSpeed == InjectSpeed_High )
        {
			usTemp = HighSpeedDose_Table[susCnt_Inject/100];
            Motor.SetSpeed_Dose(usTemp);
        }
        else/*20240815增加PDL模式无加速过程以及减速跟停止判断*/
        {
            if( !Over_Resistance_InjectingFlag )
                Motor.SetSpeed_Dose(0.42);
            else
            {
                Motor.SetSpeed_Dose(0.22);
            }
            if(Sys.PressureValue<65)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    Motor.SetSpeed_Dose(0.42);
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
            }
            else if(Sys.PressureValue>=65&&Sys.PressureValue<121)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时1.5s判断阻力*/
                {
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
                Motor.SetSpeed_Dose(0.22);
            }
            else if(Sys.PressureValue>=121)
            {
                PDLOver_ResistanceDelayCnt=0;
                OldStage_Injecting = FSM_InjectProcess;//记录下原注射阶段
                FSM_InjectProcess = InjectProc_PressureProtection;                              
                OldStage_InjectingCnt = susCnt_Inject;//记录下原注射阶段计数
                susCnt_PressureProtection = 0;
                if( Sys.InjDistance > ENCODER_NUM_17ML )
                {
                    Sys.InjDistance = ENCODER_NUM_18ML;
                    sucAbs_Limit = 1;
                    Motor.Stop();
                    FSM_InjectProcess = InjectProc_Reset;  
                }
            }
        }
	
	
	/* 随时计算法
        if( Sys.InjectSpeed == InjectSpeed_Low )
        {
            usTemp = (27*susCnt_Inject + 10000 )/20000 + 15;
            Motor.SetSpeed_Dose(((float)usTemp)/100);
        }
        else if( Sys.InjectSpeed == InjectSpeed_Mid )
        {
            usTemp = (87*susCnt_Inject + 10000 ) /20000 + 15;
            Motor.SetSpeed_Dose(((float)usTemp)/100);
        }
        else if( Sys.InjectSpeed == InjectSpeed_High )
        {
            usTemp = (147*susCnt_Inject + 10000 )/20000 + 15;
            Motor.SetSpeed_Dose(((float)usTemp)/100);
        }
*/
        if( susCnt_Inject++ > 9999 )
        {
            susCnt_Inject = 0;
            FSM_InjectProcess = InjectProc_T4;
        }

        // 0.1mL注射量在第三阶段时结束
        if( Sys.InjectDose == InjectDose_01mL && Sys.InjDistance > ENCODER_NUM_01ML )
        {
            susCnt_Inject = 0;
            FSM_InjectProcess = InjectProc_Finished;
			
        }
        /*20241015增加在快速模式下0.3剂量注射完成判断*/
        else if( Sys.InjectDose == InjectDose_03mL && Sys.InjDistance > ENCODER_NUM_03ML )
        {
            susCnt_Inject = 0;
            FSM_InjectProcess = InjectProc_Finished;
			
        }
        if ( UI_Flash_Cnt % 100 == 0 )
            UI.PDL_Or_NOPDL(); //PDL模式与非PDL模式的UI显示差异
        break;  

    // 第四阶段注射 匀速
    case InjectProc_T4:
		if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed!=InjectSpeed_PDL) Voice.WriteData(AUDIO_ADDR_Song);
		else if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1&&Sys.InjectSpeed==InjectSpeed_PDL ) Voice.WriteData(AUDIO_ADDR_Song2);
		Motor.Start(); 
		Motor.Flag_UniformSpeed = 1;
        if( Sys.InjectSpeed == InjectSpeed_Low ) Motor.SetSpeed_Dose(0.42);
        else if( Sys.InjectSpeed == InjectSpeed_Mid ) Motor.SetSpeed_Dose(1.02);
        else if( Sys.InjectSpeed == InjectSpeed_High ) Motor.SetSpeed_Dose(1.62);
     /*20240815增加PDL模式无加速过程以及减速跟停止判断*/
        else if(Sys.InjectSpeed == InjectSpeed_PDL )
        {
            if( !Over_Resistance_InjectingFlag )
                Motor.SetSpeed_Dose(0.42);
            else
            {
                Motor.SetSpeed_Dose(0.22);
            }
            if(Sys.PressureValue<65)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时3s判断阻力*/
                {
                    Motor.SetSpeed_Dose(0.42);
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
            }
            else if(Sys.PressureValue>=65&&Sys.PressureValue<121)
            {
                if( Over_Resistance_InjectingFlag )
                    PDLOver_ResistanceDelayCnt++;
                if(PDLOver_ResistanceDelayCnt>8000)/*20240826在电机启动初期延时3s判断阻力*/
                {
                    PDLOver_ResistanceDelayCnt=0;
                    //PDLOver_ResistanceCnt=0;//将过扭力计数清零
                }
                Motor.SetSpeed_Dose(0.22);
            }
            else if(Sys.PressureValue>=121)
            {
                PDLOver_ResistanceDelayCnt=0;
                OldStage_Injecting = FSM_InjectProcess;//记录下原注射阶段
                FSM_InjectProcess = InjectProc_PressureProtection;
                OldStage_InjectingCnt = susCnt_Inject;//记录下原注射阶段计数
                susCnt_PressureProtection = 0;
                if( Sys.InjDistance > ENCODER_NUM_17ML )
                {
                    Sys.InjDistance = ENCODER_NUM_18ML;
                    sucAbs_Limit = 1;
                    Motor.Stop();
                    FSM_InjectProcess = InjectProc_Reset;  
                }
            }
        }
        if ( UI_Flash_Cnt % 100 == 0 )
        {
            UI.PDL_Or_NOPDL(); //PDL模式与非PDL模式的UI显示差异
        }
        // 等待注射完毕
        if( (Sys.InjectDose == InjectDose_01mL && Sys.InjDistance > ENCODER_NUM_01ML ) || \
            (Sys.InjectDose == InjectDose_03mL && Sys.InjDistance > ENCODER_NUM_03ML ) || \
            (Sys.InjectDose == InjectDose_06mL && Sys.InjDistance > ENCODER_NUM_06ML ) || \
            (Sys.InjectDose == InjectDose_09mL && Sys.InjDistance > ENCODER_NUM_09ML ) || \
            (Sys.InjectDose == InjectDose_17mL && Sys.InjDistance > ENCODER_NUM_17ML ) || \
            (Sys.InjectDose == InjectDose_18mL && Sys.InjDistance > ENCODER_NUM_18ML ) )
        {
            Motor.Stop();
            FSM_InjectProcess = InjectProc_Finished;
        }
        
        break;

    // 注射已完毕
    case InjectProc_Finished:
        Motor.Stop();
		sucFlag_Injecting = 0;
		Motor.Flag_UniformSpeed = 0;
		if( Sys.LowPowerWarning	!= 1)
		{
			if( Sys.InjectDose == InjectDose_01mL && sucAbs_Limit != 1)
            {
                Voice.WriteData(AUDIO_ADDR_SingleOver); 
            }
			else if( Sys.InjectDose == InjectDose_03mL && sucAbs_Limit != 1 )
            {
                Voice.WriteData(AUDIO_ADDR_SingleOver);
            }
			else if( Sys.InjectDose == InjectDose_06mL && sucAbs_Limit != 1 )
            {
                Voice.WriteData(AUDIO_ADDR_SingleOver);
            }
			else if( Sys.InjectDose == InjectDose_09mL && sucAbs_Limit != 1 )
            {
                Voice.WriteData(AUDIO_ADDR_SingleOver);
            }
            else if( Sys.InjectDose == InjectDose_17mL && sucAbs_Limit != 1 )
            {
                Voice.WriteData(AUDIO_ADDR_SingleOver);
            }
			else if( Sys.InjectDose == InjectDose_18mL || sucAbs_Limit == 1 )
            {
                Voice.WriteData(AUDIO_ADDR_AllOver);
                FSM_InjectProcess = InjectProc_Reset;
            }//药物耗尽   // 1.8mL			
		}
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
        
        if ( Sys.InjectDose != InjectDose_18mL && sucAbs_Limit != 1 )
        {
            FSM_InjectProcess = InjectProc_FinishedHandler;//非药物耗尽
        }
        else if ( Sys.InjectDose == InjectDose_18mL )
        {
            FSM_InjectProcess = InjectProc_Reset;//药物耗尽
        }
        
//        if (Sys.AbsPosition > ENCODER_NUM_17ML)
//        {
//            Voice.WriteData(AUDIO_ADDR_AllOver);
//            Sys.InjDistance = ENCODER_NUM_18ML;
//            FSM_InjectProcess = InjectProc_Reset;//药物耗尽
//        }
		
        break;
	
	// 压力保护
    case InjectProc_PressureProtection:
		Motor.Stop();
		sucFlag_Injecting = 0;
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
		FSM_InjectProcess = InjectProc_OPPHandler;
        susCnt_PressureProtection_Show = 0;
        if(Sys.InjectSpeed != InjectSpeed_PDL)
        {
            UI.Window_UI(WindownShow_OPP); // 显示 阻力过大
            Voice.WriteData(AUDIO_ADDR_DiDiDi);
        }
        else /*20240826新增PDL模式的过阻力判断*/
        {           
            PDLOver_ResistanceCnt++;/*过扭力计数*/
            Over_Resistance_InjectingFlag = 1;//过扭力标志位置1
            Voice.WriteData(AUDIO_ADDR_Mute);  // 无音乐
            OLED.ClearHorizonLine(47,89,39,16);
            UI.Resistance_Feedback(Sys.PressureValue);
            UI.Window_UI(WindownShow_Drug_absorption); // 显示药物吸收中
        }
		break;

	//　过压保护处理
    case InjectProc_OPPHandler:
        Motor.Stop();
        if(Sys.InjectSpeed != InjectSpeed_PDL)//当模式不是PDL模式的时候
        {
            if( susCnt_PressureProtection_Show > 1000 )
            {
                // 等待触摸松开，返回初始状态
                if( Sys.InjectingFlag == 0 )
                {
                    FSM_InjectProcess = InjectProc_Init;
                    susCnt_PressureProtection = 0;
                    susCnt_PressureProtection_Show = 0;
                    Sys.UI_Show_Mode = 0;
                    sucFlag_TouchFiltrate = 0;
                    UI.Work_UI();
                }    
                else
                {
                    // 阻力过大时，触摸键未松开，持续间隔3s“滴滴”；
                    if( susCnt_PressureProtection ++ > 3000 )
                    {
                        susCnt_PressureProtection = 0;
                        if( VOICE_BUSY == 0 ) Voice.WriteData(AUDIO_ADDR_DiDiDi);
                    }
                 }
            }
            else susCnt_PressureProtection_Show++;
        }
        else /*20240826新增PDL模式的过阻力判断*/
        {
            if( susCnt_PressureProtection_Show > 1000 )
            {
                // 等待触摸松开，返回初始状态
                if( Sys.InjectingFlag == 0 ) 
                {
                    Over_Resistance_InjectingFlag = 0;//过扭力标志位清0
                    PDLOver_ResistanceCnt=0;
                    FSM_InjectProcess = InjectProc_Init;
                    susCnt_PressureProtection = 0;
                    susCnt_PressureProtection_Show = 0;
                    Sys.UI_Show_Mode = 0;
                    sucFlag_TouchFiltrate = 0;
                    UI.Work_UI();
                }
                else
                {
                    if( PDLOver_ResistanceCnt<5 )
                    {
                        if( susCnt_PressureProtection ++ > 5000 ) //5秒之后再启动电机
                        {
                            susCnt_PressureProtection=0;
                            sucFlag_Injecting = 1;
                            FSM_InjectProcess = OldStage_Injecting;//记录下原注射阶段
                            susCnt_Inject = OldStage_InjectingCnt;//记录下原注射阶段计数
                            UI.Work_UI();
                        }
                    }
                    else
                    {
                        // 阻力过大时且连续判断大于95N的次数大于五次，触摸键未松开，持续间隔3s“滴滴”,电机停转不再启动
                        UI.Window_UI(WindownShow_OPP); // 显示 阻力过大
                        if( susCnt_PressureProtection ++ > 3000 )
                        {
                            susCnt_PressureProtection = 0;
                            Voice.WriteData(AUDIO_ADDR_DiDiDi);
                        }
                    }
                 }
            }
            else susCnt_PressureProtection_Show++; 
        }
		break;
		
	// 编码反馈丢失错误	
	case InjectProc_ErrNoEncoder:
		Motor.Stop();
		sucFlag_Injecting = 0;
		UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
		susCnt_ErrNoEncoder_Show = 0;
		FSM_InjectProcess = InjectProc_NoEncoderHandler;
        Voice.WriteData(AUDIO_ADDR_DiDi);
        UI.Window_UI(WindownShow_E3); // 全屏显示E3(阻力过大弹窗)
		break;
		
	case InjectProc_NoEncoderHandler:
        Motor.Stop();		
		if( susCnt_ErrNoEncoder_Show > 1000 )
		{
            // 等待触摸松开，返回初始状态
            if( Sys.InjectingFlag == 0 ) 
            {
                FSM_InjectProcess = InjectProc_Init;
                susCnt_ErrNoEncoder = 0;
                susCnt_ErrNoEncoder_Show = 0;
                Sys.UI_Show_Mode = 0;
                sucFlag_TouchFiltrate = 0;
                SysFSM_State = SysFSM_Fault;   // 跳转到故障业务				
            }    
            else
            {
                // 编码丢失时，触摸键未松开，持续间隔3s“滴滴”
                if( susCnt_ErrNoEncoder++ > 3000 )
                {
                    susCnt_ErrNoEncoder = 0;
                    if( VOICE_BUSY == 0 ) Voice.WriteData(AUDIO_ADDR_DiDi);
                }
            }
		}
		else susCnt_ErrNoEncoder_Show++ ;
		break;

	//　注射结束
    case InjectProc_FinishedHandler:
        // 等待触摸松开，返回初始状态
        if( Sys.InjectingFlag == 0 )
        {
            FSM_InjectProcess = InjectProc_Init;
			UI.Icon_InjectArrow2(MOTOR_DIR_FORWARD, 0);
        }
        if( Sys.InjectSpeed == InjectSpeed_PDL && UI_Flash_Cnt == 400 )
        {
            OLED.ClearHorizonLine(47,89,39,16);
            // 注射剂量
            UI.Icon_InjectDose(Sys.InjectDose);
            UI.Background_Char_mL();
        }
        
        break;
        
    case InjectProc_Reset:
        //显示即将复位弹窗
        ResetFlag = 1;
        Reset_pop_up++;
        Key_Stop(&TKEY);    //将触摸按键失能
        Key_Stop(&KEY1);	//将按键1失能
        Key_Stop(&KEY2);	//将按键2失能
        Key_Stop(&KEY3);    //将按键3失能
        if ( Reset_pop_up > 100 )
        {
            Reset_pop_up = 0;
            UI.Window_UI(WindownShow_willReturn);
            FSM_InjectProcess = InjectProc_ResetHandler;
        }
        break;
    
    case InjectProc_ResetHandler:
        //开始计数，十秒后复位
        if(ResetDelayCnt++>10000) //十秒
        {
            ResetFlag = 0;
            ResetDelayCnt = 0;
            Sys.SetInjectLock(LOCKED); // 锁定状态
            Sys.HomingFlag = 1;
            ErrorClockedFlag = 1;
            FSM_InjectProcess = InjectProc_Init;
        }
        break;
        
    default:
        break;
    }
}



/**
* @name   : SpeedDoseTable_Init
* @brief  : 速度表初始化
* @param  : None
* @retval : None
* @note   : 单次执行
*/
float LowSpeedDose_Table[100];
float MidSpeedDose_Table[100];
float HighSpeedDose_Table[100];

void SpeedDoseTable_Init(void)
{
	uint16_t i = 0;
    float j = 0.42;
	for( i = 0; i < 100; i++ )
	{
//		LowSpeedDose_Table[i]  = (float)((27*i+100)/100+15)/100;
        LowSpeedDose_Table[i]  = j;
		MidSpeedDose_Table[i]  = (float)(60*(i+1)/100+42)/100;
		HighSpeedDose_Table[i] = (float)(120*(i+1)/100+42)/100;
	}
}