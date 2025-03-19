#include "BLL.h"

#define WORK_PRESSURE_DELAY   500



// 压力Buf 在3.9V的情况下测
uint16_t const Pressure_Buf[6]=
{
  //  100N	
  2100,  // 10rpm     3400 // 原始值，后来改为可调，先减去1000，最多可调1300
  2200,  // 20rpm     3300
  2200,  // 30rpm     3800
  2000,  // 40rpm     3600
  1900,  // 50rpm     3000
  1800   // 60rpm     3000
};
	
/*	
//0N   10N   20N   30N   40N   50N   60N   70N   80N  90N
 {0,  1195, 2229, 2990, 3277, 3778, 4684, 4477, 4477, 4477},   // 10 rpm
 {0,  1797, 2214, 2478, 2721, 3480, 3954, 4687, 4688, 6000},   // 20 rpm
 {0,  1721, 2201, 2635, 2904, 3618, 2770, 4617, 4875, 6000},   // 30 rpm
 {0,  1587, 1963, 2526, 2775, 3479, 4192, 4680, 4880, 6000},   // 40 rpm
 {0,  1589, 2149, 2805, 2973, 3650, 4183, 4303, 4130, 6000},   // 50 rpm
 {0,  1579, 2035, 2824, 3166, 3745, 4121, 4229, 4303, 6000},   // 60 rpm
 {0,  1518, 1778, 2400, 3159, 3656, 3757, 4100, 4150, 6000},   // 70 rpm
};
*/



uint8_t Check_BatteryVoltage(void);

uint8_t sucLevel = 3; 
uint8_t sucLast_Level= 4;

/**
* @name   : Monitor_BLL
* @brief  : 系统监测
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Monitor_BLL(void)
{
    static uint16_t susCnt_NoEncoder;	
	
    static uint16_t sucCnt_Bat = 350;
	static uint8_t sucMutex_Bat;
    static uint8_t sucLast_BatLevel = 4;
	static uint8_t sucCnt_GetBatteryVoltage;
	
	static uint8_t  sucCnt_Pressure;
	static uint16_t susCnt_PressureDelay;
	static int16_t susTemp_PressureValue;  // 计算压力值
	static uint8_t  susCnt_OPP;    // 过压计数值
	uint16_t usTemp_CurrentDivDuty;   // 电流除以占空比
	static uint16_t OPP_AdjValue;     // 过力保护补偿值 
	
	static uint8_t susCnt_LoudLevel;
	static uint16_t susCnt_PowerON;	
	
	
	// 监控编码线信号是否正常
	if( Motor.Duty > 97 && Motor.MotorSpeed_PV == 0 )
	{
		if( susCnt_NoEncoder++ > 8000 )
		{
			susCnt_NoEncoder = 0;
			Sys.ErrorState = Err_NoEncoder;
		}
	}
	else susCnt_NoEncoder = 0;
	

	
	// 霍尔检测
	
	
	// 音量大小改变，同步大滴小滴
	if( LoudLevel_ChangeFlag == 1)
	{
		if( susCnt_LoudLevel++ > 80 )
		{
			susCnt_LoudLevel = 0;
			LoudLevel_ChangeFlag = 0;
			if( VOICE_BUSY == 0 ) Voice.WriteData(AUDIO_ADDR_Di);
		}
	}
	
	// 开机大声滴处理
	if( PowerON_OverFlag == 1 )
	{
		if( susCnt_PowerON++ > 500 )
		{
			susCnt_PowerON = 0;
			PowerON_OverFlag = 0;
		
			if( Sys.LoudLevel == 0 )
			{
				Sys.LoudLevel = 0;
				Voice.WriteData(AUDIO_ADDR_LoudLeveL_L);
				Voice.Programmer();
			}
			else if( Sys.LoudLevel == 1  )
			{
				Sys.LoudLevel = 1;
				Voice.WriteData(AUDIO_ADDR_LoudLeveL_H);
				delay_1ms(1);
				Voice.Programmer();
			}			
			
		}	
	}
	else susCnt_PowerON = 0;
			
	
	// 电量监控并刷新UI
	if(1)  // SysFSM_State != SysFSM_PowerON
	{
		if( sucCnt_GetBatteryVoltage++ > 5 )  // 100ms读一次电池电压
		{
			sucCnt_GetBatteryVoltage = 0;
			Sys.BatteryLevel = Check_BatteryVoltage();				
		}
	
		if( sucCnt_Bat++ > 500 ) //500ms 改变一次电池图标　
		{
			sucCnt_Bat = 0;
			if( (Sys.BatteryLevel != sucLast_BatLevel)  && Sys.LowPowerFlag == 0 )
			{
				sucLast_BatLevel = Sys.BatteryLevel;
				UI.Icon_BatteryLevel( Sys.BatteryLevel );
				UI.BG_BatteryLevel( 1 );
			}
			else if( Sys.LowPowerFlag == 1 )  // 低电量，电池框闪烁
			{
				UI.Icon_BatteryLevel( 0 );
				if( sucMutex_Bat == 0 )
				{
					sucMutex_Bat = 1;
					UI.BG_BatteryLevel( 1 );
				}
				else
				{
					sucMutex_Bat = 0;
					UI.BG_BatteryLevel( 0 );			
				}
			}
		}
	}
	else sucCnt_Bat = 0;
	
	
	// 压力计算，电机运行时计算
	if( Motor.State != MOTOR_STATE_STOP )
	{
		if( susCnt_PressureDelay < 16000 ) susCnt_PressureDelay++;
	}		
	else
	{
		sucCnt_Pressure = 0;
		susCnt_PressureDelay = 0;
		Sys.PressureValue = 0;
		susCnt_OPP = 0;
//        if( Sys.InjectSpeed != InjectSpeed_PDL )
            susTemp_PressureValue = 0;
	}
	
	if( susCnt_PressureDelay > 2000 )
	{
        if( Sys.InjectSpeed != InjectSpeed_PDL )
        {
            if( sucCnt_Pressure++ > 50 )  // 100ms计算一次压力值
            {
                sucCnt_Pressure = 0;
                OPP_AdjValue = Sys.OPP_Value * 10; //OPP_AdjValue=750
                usTemp_CurrentDivDuty = Motor.Current_AD*100 / Motor.Duty;
                if( Motor.GearSpeed_PV <= 15 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[0] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }
                else if( Motor.GearSpeed_PV > 15 && Motor.GearSpeed_PV <= 25 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[1] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }			
                else if( Motor.GearSpeed_PV > 25 && Motor.GearSpeed_PV <= 35 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[2] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }
                else if( Motor.GearSpeed_PV > 35 && Motor.GearSpeed_PV <= 45 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[3] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }
                else if( Motor.GearSpeed_PV > 45 && Motor.GearSpeed_PV <= 55 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[4] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }
                else if( Motor.GearSpeed_PV > 55 )
                {
                    if( usTemp_CurrentDivDuty > Pressure_Buf[5] + OPP_AdjValue ) susTemp_PressureValue = 121;
                    //else susTemp_PressureValue = 0;
                }
                if( Motor.Current_mA > 4000 ) susTemp_PressureValue = 101;
                
                if( susTemp_PressureValue == 121 )
                {
                    susCnt_OPP++;
                    if( susCnt_OPP > 6 ) Sys.PressureValue = 121;
                }
                else susCnt_OPP = 0;
            }
        }
			
        else if(Sys.InjectSpeed==InjectSpeed_PDL)
        {
            if( Motor.GearSpeed_PV <= 18 )
            {
                susTemp_PressureValue = ( Motor.Current_AD  / Motor.Duty ) * 4.6 - (Sys.OPP_Value-55);
            }
            else if( Motor.GearSpeed_PV > 18 && Motor.GearSpeed_PV <= 28 )
            {
                susTemp_PressureValue = ( Motor.Current_AD / Motor.Duty ) * 3.8 - (Sys.OPP_Value-55);
            }
            else if( Motor.GearSpeed_PV > 28 && Motor.GearSpeed_PV <= 38 )
            {
                susTemp_PressureValue = ( Motor.Current_AD / Motor.Duty ) * 3.4 - (Sys.OPP_Value-60);
            }			
            else if( Motor.GearSpeed_PV > 38 && Motor.GearSpeed_PV <= 48 )
            {
                susTemp_PressureValue = ( Motor.Current_AD / Motor.Duty ) * 2.9 - (Sys.OPP_Value/7);
            }				
            else if( Motor.GearSpeed_PV > 48 )
            {
                susTemp_PressureValue = ( Motor.Current_AD / Motor.Duty ) * 2.8 - (Sys.OPP_Value/9);
            }	
            
            
            if( susTemp_PressureValue > 0 && susTemp_PressureValue <= 120 )
            {                
                Sys.PressureValue = susTemp_PressureValue;
            }
            else if( susTemp_PressureValue > 120 )
            {
                susCnt_OPP++;
                if(susCnt_OPP>6)
                {
                    Sys.PressureValue = 121;
                    susCnt_OPP = 0;
                }
            }
            else
            {
                susTemp_PressureValue = 0;
            }
        }
			
	}
	
}


/**
* @name   : Check_BatteryVoltage
* @brief  : 检测电池状态
* @param  : None
* @retval : 电量等级 0 1 2 3
* @note   : None
*/
uint8_t Check_BatteryVoltage(void)
{
	static uint8_t sucTemp_Level = 3;
	static uint8_t sucTemp_LastLevel = 3;	
	static uint8_t sucCnt_Level;
	
    Sys.Battery_AD = Power_ADC.OutValue;
	Sys.Battery_V  = Sys.Battery_AD*600/4095;

    if( sucLevel == 0 && Sys.Battery_V < 340 && Sys.LowPowerFlag == 0 && Motor.State == MOTOR_STATE_STOP ) 
	{
		Sys.LowPowerFlag = 1;
	}
	else if( sucLevel == 0 && Sys.Battery_V < 335 && Sys.LowPowerFlag == 0 && Motor.State != MOTOR_STATE_STOP )	
	{
		Sys.LowPowerFlag = 1;
	}
	
	if( Motor.State == MOTOR_STATE_STOP )
	{
		if( Sys.Battery_V>390  || ((sucLevel>2)&&(Sys.Battery_V>385)))	sucTemp_Level=3;
		else if( Sys.Battery_V>370 || ((sucLevel>1)&&(Sys.Battery_V>360))) sucTemp_Level=2;
		else if( Sys.Battery_V>355 || ((sucLevel>0)&&(Sys.Battery_V>350))) sucTemp_Level=1;
		else sucTemp_Level=0;
	}
	else
	{
		if( sucLevel == 3 && Sys.Battery_V < 380  ) sucTemp_Level = 2;
		else if( sucLevel == 2 && Sys.Battery_V <= 355  ) sucTemp_Level = 1;	
		else if( sucLevel == 1 && Sys.Battery_V <= 345  ) sucTemp_Level = 0;
	}
	
	// 电池格数显示滤波
	if( sucTemp_LastLevel != sucTemp_Level )
	{
		sucCnt_Level = 0;
		sucTemp_LastLevel  = sucTemp_Level;
	}
	else if( sucTemp_LastLevel == sucTemp_Level )
	{
		if( sucCnt_Level++ > 4 ) // 4*50ms = 200ms
		{
			sucCnt_Level = 0;
			sucLevel = sucTemp_Level;
			if( sucLevel > 0 ) Sys.LowPowerFlag = 0;
			if( sucLevel == 0 ) {Sys.LowPowerWarning = 1;}
			else Sys.LowPowerWarning = 0;			
		}
	}

	return sucLevel;
}

