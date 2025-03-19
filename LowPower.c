#include "BLL.h"


/**
* @name   : LowPower_BLL
* @brief  : 低电量
* @param  : None
* @retval : None
* @note   : 1ms轮询；
*/
void LowPower_BLL(void)
{
	static uint16_t susCnt_Delay;
	
	static uint8_t  sucMutex_Voice;
	
	static uint16_t susCnt_DiDi;
	
	static uint8_t  susFlag_ShutDown;
    
    static uint16_t susCnt_Pop = 0;
    
    static uint8_t Pop_HandoffFlag = 0; //20241105修改，低电量弹窗闪烁标志位，电量不足跟即将复位交替闪烁
    
    static uint8_t AutoHomingCnt = 0;   //20241105修改，低电量自动复位计数，在计数到5的时候自动复位，两秒加一次
	
	Key_Stop(&TKEY);
	Key_Stop(&KEY1);	
	Key_Stop(&KEY2);	
	Key_Stop(&KEY3);	
	Motor.Stop();
	
	// 低电量警告，此时按关机键自动复位
	if( Sys.LowPowerWarning == 1 && Sys.LowPowerFlag == 0 )
	{
		Motor.Stop();
		sucMutex_Voice = 0;
		
        
        if( AutoHomingCnt < 5 && susCnt_Pop == 0 )
        {
            Pop_HandoffFlag = !Pop_HandoffFlag;
            if( Pop_HandoffFlag )
                UI.Window_UI(WindownShow_PowerLow);
            else
                UI.Window_UI(WindownShow_willReturn);
            AutoHomingCnt++;
        }
        else if( AutoHomingCnt == 5 )
        {
            AutoHomingCnt = 0;
            Sys.HomingFlag = 1;
        }
        
        if( susCnt_DiDi > 2000 )
		{
			susCnt_DiDi = 0;
            susCnt_Pop = 0;
			Voice.WriteData(AUDIO_ADDR_DiDi);
		}
		else
        {            
            susCnt_DiDi++;
            susCnt_Pop++;
        }
        		
		if( Sys.HomingFlag == 1 )
		{
            AutoHomingCnt = 0;
			UI.Window_UI(WindownShow_LowPower);
			susCnt_DiDi = 0;
			SysFSM_State = SysFSM_Homing;
		}
        
        
	}
	else if( Sys.LowPowerFlag == 1 && sucMutex_Voice == 0 )
	{
		sucMutex_Voice = 1;
		Voice.WriteData(AUDIO_ADDR_DiDi);
		susCnt_Delay = 0;
	}
	else if( Sys.LowPowerFlag == 0 && Sys.LowPowerWarning == 0 )
	{
		susCnt_DiDi = 0;
		SysFSM_State = SysFSM_Standby;
		UI.Work_UI();		
	}
    

	// 3s后关机  20241105修改，低电量自动复位之后关机
//	if( sucMutex_Voice == 1 )
//	{
//		if( susCnt_Delay++ > 3500 )
//		{
//			susCnt_Delay = 0;
//			SysFSM_State = SysFSM_Shutdown;
//		}		
//	}
}