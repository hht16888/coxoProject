#include "BLL.h"

/*-----------------------------------------------
上电流程：
    0. OLED初始化，未亮屏
    1. 读取Flash数据
    2. OLED内容绘制
    3. OLED亮屏 + 部分外设初始化
    4. 开机完成
      4.1 无错误 跳转至待机状态
      4.2 有错误 跳转至故障状态
-----------------------------------------------*/
uint8_t PownON_Judge;
uint8_t PowerON_OverFlag = 0;
/**
* @name   : PowerON_BLL
* @brief  : 上电开机
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void PowerON_BLL(void)
{
	static uint8_t sucStep = 0;
	static uint8_t sucCnt_PKEY;
    if( sucStep == 0 )  // 初始化OLED
    {
		OLED.Init();
	
		sucStep = 1;
    }
    else if( sucStep == 1 )  // 判断数据的有效性
    {
        if( 0 == FlashTool.Read(&FlashReadData) || 0 == FlashTool.isAvaliable() || \
			0x01 != FlashReadData.F_WR_flag )
        {
			Sys.MemoryDataErrorFlag = 1;  // 记忆数据标记读取失败
		}
		sucStep = 2; // 数据读取
     }
	else if( sucStep == 2 )  // 数据读取
    {
        // 读取数据
		Sys.LoudLevel = FlashReadData.F_LoudLevel;
		Sys.MusicStyle = FlashReadData.F_MusicStyle;
		Sys.AbsPosition = FlashReadData.F_AbsPosition;
		Sys.InjectDose = FlashReadData.F_InjectDose;
		Sys.InjectSpeed = FlashReadData.F_InjectSpeed;
		Sys.Language = FlashReadData.F_Language;
		Sys.OPP_Value =	FlashReadData.F_OPP_Value;
		Sys.HomingOffset = FlashReadData.F_HomingOffset;
		Sys.BatteryLevel = FlashReadData.F_BatteyLevel;
        Sys.MusicSwitch = FlashReadData.F_MusicSwitch;
		// 数据有效性判断
		if( Sys.LoudLevel != 0 && Sys.LoudLevel != 1 ) Sys.LoudLevel = 1;
		if( Sys.MusicStyle != 1 && Sys.MusicStyle != 2  ) Sys.MusicStyle = 1;            
		if( Sys.AbsPosition > ENCODER_NUM_18ML + 100 ) 
		{
			Sys.AbsPosition = ENCODER_NUM_18ML;
			Sys.MemoryDataErrorFlag = 1;  // 记忆数据标记读取失败
		}
		if( Sys.InjectDose != InjectDose_18mL  && \
			Sys.InjectDose != InjectDose_09mL && Sys.InjectDose != InjectDose_06mL && \
			Sys.InjectDose != InjectDose_03mL && Sys.InjectDose != InjectDose_01mL  )
		{
			Sys.InjectDose = InjectDose_18mL;
		}
		if( Sys.InjectSpeed != InjectSpeed_Low && Sys.InjectSpeed != InjectSpeed_Mid && \
			Sys.InjectSpeed != InjectSpeed_High && Sys.InjectSpeed != InjectSpeed_PDL)    
		{
			Sys.InjectSpeed = InjectSpeed_Low;
		} 
		if( Sys.OPP_Value > 180 || Sys.OPP_Value == 0 ) Sys.OPP_Value = 90;
		if( Sys.Language != 1 && Sys.Language != 0  ) Sys.Language = 0;   
		if( Sys.HomingOffset > 5500 ||  Sys.HomingOffset < 3500 ) 
		{
			Sys.HomingOffset = 4760;
			Sys.MemoryDataErrorFlag = 1;  // 记忆数据标记读取失败
		}
		if( Sys.BatteryLevel > 3 ) Sys.BatteryLevel = 1;
        if( Sys.MusicSwitch != 0 && Sys.MusicSwitch != 1 ) Sys.MusicSwitch = 1;
		
		// 写回去
		FlashWriteData.data_valid_flag = 0xF1;
		FlashWriteData.F_WR_flag = 0x00;
		FlashWriteData.F_LoudLevel = Sys.LoudLevel;			
		FlashWriteData.F_MusicStyle = Sys.MusicStyle;			
		FlashWriteData.F_AbsPosition = Sys.AbsPosition;
		FlashWriteData.F_InjectDose = Sys.InjectDose;
		FlashWriteData.F_InjectSpeed = Sys.InjectSpeed;
		FlashWriteData.F_Language = Sys.Language;
		FlashWriteData.F_OPP_Value = Sys.OPP_Value;
		FlashWriteData.F_HomingOffset = Sys.HomingOffset;	
		FlashWriteData.F_BatteyLevel = Sys.BatteryLevel;
        FlashWriteData.F_MusicSwitch = Sys.MusicSwitch;
		FlashTool.Write(&FlashWriteData);
		delay_1ms(10);
		sucStep = 4;
		
		sucLevel = Sys.BatteryLevel;  // 电池格数，可消抖
		if( sucLevel == 0 ) sucLevel = 1;
	}
    else if (sucStep == 4)  // OLED内容绘制
    {
		Sys.UI_Show_Mode = 0;
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
		//UI.Icon_BatteryLevel(0);
        // 注射锁
        UI.BG_InjectLock();
        // 音乐view 
		Sys.SetMusicStyle(Sys.MusicStyle);
        // 音量view
        UI.Icon_SoundVolume(Sys.LoudLevel);
        // 锁view
		Sys.InjectLock = LOCKED;
        UI.Icon_InjectLock(Sys.InjectLock);
        Sys.SetInjectLock(Sys.InjectLock);
        // 已注射剂量
        UI.Icon_RestDose(Sys.AbsPosition/ENCODER_NUM_01ML);
		UI.Icon_InjectedBars( Sys.AbsPosition/ENCODER_NUM_01ML );  // 进度条同步
        // 字符 mL
        UI.Background_Char_mL();
        // 注射剂量
        UI.Icon_InjectDose(Sys.InjectDose);
        // 注射速度
        UI.Icon_InjectSpeed(Sys.InjectSpeed);
        // 注射箭头
        UI.Icon_InjectArrow2(0, 0);

        sucStep = 5;
		
    }
    else if( sucStep == 5 )  // OLED亮屏 + 部分外设初始化
    {
		FWDGT_Config();  // 开启看门狗
        Motor.Init();			
        TIMER0_Init();               // 霍尔AB外部中断
        TIMER15_Init(7200-1, 100-1);     // 定时读编码数，100Hz
        TIMER13_Init(7200-1, 10000-1);   // 无操作关机 1Hz计数
        TIMER2_Init( MOTOR_PCS-1, MOTOR_ARR-1 );  // 电机PWM驱动 f = 72 000 000 / 18 / 200 = 20 000 Hz	
		delay_1ms(3);
		sucCnt_PKEY = 0;		
        sucStep = 6;
		SpeedDoseTable_Init(); // 初始化速度表		
    }
	else if( sucStep == 6 )  // 电源键开机处理
	{
		sucStep = 7;
	}
    else if( sucStep == 7 ) //　开机完成
    {
		if( read_PKEY_pin() )
        {
            if( sucCnt_PKEY < 200 ) sucCnt_PKEY++;
			if( sucCnt_PKEY == 100 )
			{
				sucCnt_PKEY = 250;
				Key_Config();  // 按键初始化						
				PowerON_OverFlag = 1;
				if(Sys.LowPowerFlag != 1 && Sys.LowPowerWarning != 1 ) 
				{
					Voice.WriteData(AUDIO_ADDR_Di);
				}
				else Voice.WriteData(AUDIO_ADDR_DiDi);
	
				delay_1ms(1);
				OLED.ScreenBright();  // 屏幕点亮					
				if( Sys.MemoryDataErrorFlag == 1 )  // 记忆数据读取错误，推杆将自己复位
                {
                    sucCnt_PKEY = 0;
					SysFSM_State = SysFSM_Fault;        // 读存取失败						
					UI.Work_UI();
                }
                else 
                {	
                    SysFSM_State = SysFSM_Standby;   // 开机 成功				
					sucCnt_PKEY = 0;
                    UI.Icon_BatteryLevel( Sys.BatteryLevel );				
                }
			}
        }
		else sucCnt_PKEY = 0;
    }
}

