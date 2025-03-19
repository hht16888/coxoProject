#include "BLL.h"


/**
* @name   : Fault_BLL
* @brief  : 故障诊断
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Fault_BLL(void)
{
	static uint16_t susCnt_Refresh;
	static uint16_t susCnt_Arrow;
	static uint16_t sucArrow;	
	static uint16_t susCnt_Delay;

/*	
	// 用于静电测试
	if( susCnt_Refresh ++ > 20 )
	{
		susCnt_Refresh = 0;
		OLED.Refresh();
	}

	// 非匀速状态，每500ms箭头流动
	if( susCnt_Arrow++ > 500 )
	{
		susCnt_Arrow = 0;
		UI.Icon_InjectArrow2(Motor.Dir, sucArrow++);
		if( sucArrow == 5 ) sucArrow = 1;			
	}
	// 用于静电测试
*/	
	
/*	// 开机读取数据错误
	if( Sys.Err_Code == 1 && Sys.HomingFlag == 1 )
	{
		SysFSM_State = SysFSM_Homing;
	}
*/

	// 0格电低电量警告
	if( Sys.LowPowerWarning == 1 ) 
	{
		if( susCnt_Delay++ > 3 )
		{
			susCnt_Delay = 0;
			SysFSM_State = SysFSM_LowPower;
			
		}	
		return;		
	}
	
	

    // 错误：MemoryDataError 开机读取记忆数据错误，自动回退
	if( Sys.MemoryDataErrorFlag == 1 && Sys.ErrorState == NoError )
	{
		Sys.HomingFlag = 1;
		SysFSM_State = SysFSM_Homing;
		return;
	}
	else if( Sys.ErrorState == Err_HomingBlocking )
	{
		// 错误：Err_HomingBlocking 复位阻塞,只能关机消除
		Motor.Stop();
	}
    
    // 错误：Err_HomingIdling 复位空转
	if( Sys.ErrorState == Err_HomingIdling )
	{
		Motor.Stop();
	}
	else if( Sys.ErrorState == Err_NoEncoder ) // 编码丢失
	{
		Motor.Stop();
	}



	
}


