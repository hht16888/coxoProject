#include "AppInclude.h"

//#define Debug


#define Vioce_Enable
#define AutoPowerOff

void SysFSM_Run(void);	 // 系统运行，1ms轮询
void Motor_Regulation(void);   // 电机调速
/**
  ***********************************************
  * @name   : main
  * @brief  : 主函数
  * @param  : None
  * @retval : None
  * @note   : 
  ***********************************************/
int main(void)
{
	static uint16_t susCnt_Refresh;

	systick_config();     // 72M主频,滴答定时器1ms中断
    delay_1ms(1);        
    IO_Config();   // IO、外设配置
    delay_1ms(1);    	
	Sys.Power_ON();	// 短按开机
	NVIC_Config();
	DMA_Init();	
	ADC_Init();	
	SPI0_Init();
#ifdef SPI0_DMA_CH2
	dma_channel_enable(DMA_CH2);
	spi_dma_enable(SPI0, SPI_DMA_TRANSMIT);
#endif


#ifdef Vioce_Enable	
	TIMER5_Init(360-1, 100-1);   // 语音模块 500us定时中断  f = 72 000 000 / 360 / 100 = 2000Hz = 0.5ms = 500 us
#endif	
    delay_1ms(2); 	
	Voice.Init();

    while(1)
	{	
		if( Sys.Basetime >= 1 )  // 1ms定时
		{
			adc_software_trigger_enable(ADC_REGULAR_CHANNEL);  //ADC软件触发使能
			Sys.Basetime = 0;
			Monitor_BLL();  // 监测
			Homing_TriggerDetect();
            Interactive_BLL();  // 交互
			SysFSM_Run();	 // 运行，1ms轮询
			Motor_Regulation();  // 电机调速
			if( susCnt_Refresh++ > 50 )
			{
				susCnt_Refresh = 0;
				OLED.Refresh();
			}
		}
    }
}

/**
* @name   : SysFSM_Run
* @brief  : 系统状态机
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void SysFSM_Run(void)
{
	static uint16_t susCnt_Delay;
	static uint8_t  sucCnt_RefreshOnce;
	
	switch ( SysFSM_State )
	{
	// 上电
	case SysFSM_PowerON:
		PowerON_BLL();
		break;

	// 待机
	case SysFSM_Standby:
		if( Sys.MemoryDataErrorFlag == 1 ) break;
		Key_Start(&KEY1);
		Key_Start(&KEY2);
		Key_Start(&KEY3);
		Key_Start(&PKEY); 
		BackDoor();	
		if( Sys.LowPowerWarning == 1 ) // 低电量
		{
			SysFSM_State = SysFSM_LowPower;
            
			Voice.WriteData(AUDIO_ADDR_DiDi);
		}
		else if( Sys.InjectLock == UNLOCKED )  //　解锁
        {
			sucCnt_RefreshOnce = 0;
            SysFSM_State = SysFSM_Inject;
        }
        else if( Sys.HomingFlag == 1 ) // 复位
        {
			sucCnt_RefreshOnce = 0;
            SysFSM_State = SysFSM_Homing;
        }

        if( sucCnt_RefreshOnce < 50 )
		{
			sucCnt_RefreshOnce++;
			if( sucCnt_RefreshOnce > 20 ) 
			{
				sucCnt_RefreshOnce = 100;
			    UI.Work_UI();
			}
		}			
		
		break;

	// 注射
	case SysFSM_Inject:	
		Inject_BLL();
		break;
    
	// EMC
	case SysFSM_EMC:	
		if( VOICE_BUSY == 0 && Sys.MusicSwitch == 1 ) Voice.WriteData(AUDIO_ADDR_Song);
		if( (Sys.AbsPosition < ENCODER_NUM_18ML && Motor.Dir == MOTOR_DIR_FORWARD) || \
			(Sys.AbsPosition > (2*ENCODER_NUM_01ML) && Motor.Dir == MOTOR_DIR_BACK)  ) 
		{
			Motor.Start();
		}
		else 
		{
			Motor.Stop();
			Voice.WriteData(AUDIO_ADDR_Mute);  // 音乐停止
			SysFSM_State = SysFSM_Standby;			
		}

		break;
	
    // 复位
    case SysFSM_Homing:
        Homing_BLL();
        break;
	
    // 低电量
    case SysFSM_LowPower:
		LowPower_BLL();
		break;
	
	// 故障
	case SysFSM_Fault:
		Key_Start(&KEY1);
		Key_Start(&KEY2);
		Key_Start(&KEY3);
		Key_Start(&PKEY);
		BackDoor();	
		Fault_BLL();
		
		break;		

    // 关机
	case SysFSM_Shutdown:
		Shutdown_BLL();	
		break;

	// 菜单选项
	case SysFSM_EnumSelet:
		MenuSelet_BLL();
		break;
	
	// 功能测试
	case SysFSM_TestFun:
		TestFun_BLL();
	
		break;
	
	
	default:
		break;
	}

}


/**
* @name   : Motor_Regulation
* @brief  : 电机调速
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Motor_Regulation(void)
{
    static uint8_t sucCnt_AdjPWM;
    uint16_t usSpeedErrValue = 0;	
	
	if( Sys.Motor_Regulation_Flag == 1 )
	{
		Sys.Motor_Regulation_Flag = 0;
		
       Motor.FBpulseCnt_Show = Motor.FBpulseCnt;
        Motor.MotorSpeed_PV = Motor.FBpulseCnt *100;  // 电机速度rpm
        Motor.GearSpeed_PV = (float)Motor.MotorSpeed_PV / REDUCTION_RATIO;
        Motor.FBpulseCnt = 0;

        // 速度调节
        if( Motor.Start != MOTOR_STATE_STOP && Motor.Err == 0 )
        {
            if( Motor.MotorSpeed_PV < Motor.MotorSpeed_SV && Motor.PWM < MOTOR_ARR )
            {
                // 速度小于设定值且输出未达到最大
                usSpeedErrValue = Motor.MotorSpeed_SV - Motor.MotorSpeed_PV;
                if( usSpeedErrValue > 1030 ) Motor.PWM = Motor.PWM + 10;  // 速度误差大于 0.1  mL/min
                else if( usSpeedErrValue > 300 )  Motor.PWM = Motor.PWM + 1; // 速度误差小于 0.03 mL/min

                if( Motor.PWM >= MOTOR_ARR ) Motor.PWM = MOTOR_ARR-1; // 限幅
            }
            else if( Motor.MotorSpeed_PV > Motor.MotorSpeed_SV && Motor.PWM > 0 )
            {
                // 速度大于设定值且输出未达到最小
                usSpeedErrValue = Motor.MotorSpeed_PV - Motor.MotorSpeed_SV; 
                if( usSpeedErrValue > 1030 )  // 速度误差大于 0.1  mL/min
                {
                    if( Motor.PWM > 10  ) Motor.PWM = Motor.PWM - 10; 
                    else Motor.PWM = Motor.PWM - 1; 
                }
                else if( usSpeedErrValue > 300 )  Motor.PWM = Motor.PWM - 1; // 速度误差小于 0.03 mL/min             
            }
        }
        Motor.Duty = Motor.PWM/2;  // 占空比换算
    }		
}







