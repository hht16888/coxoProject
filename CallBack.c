/**
  ******************************************************************************
  * @file           : CallBack.c
  * @brief          : All callback functions
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/	
#include "AppInclude.h"

/* Private define-------------------------------------------------------------*/

/* Private variables----------------------------------------------------------*/

/* Public variables-----------------------------------------------------------*/




/* Private function prototypes------------------------------------------------*/      

/**
  *----------------------------------------------
  * @name   : DMA_Channel0_IRQHandler
  * @brief  : ADC DMA传输完成中断
  * @param  : 	
  * @retval : 
  * @note   : DMA连续转换
  *----------------------------------------------
  */
void DMA_Channel0_IRQHandler()
{
	static unsigned char sucCount0;		
	static unsigned char sucCount1;
	static unsigned char sucCount2;
	static uint16_t ADC_Vrefint;
	
	if(SET == dma_interrupt_flag_get(DMA_CH0, DMA_INT_FLAG_FTF))
	{
		Power_ADC.Value = ADCDMA_Buf[0]&0xFFF;
		if( Power_ADC.Value - Power_ADC.LastValue > Power_ADC.Range ||\
			Power_ADC.LastValue - Power_ADC.Value < Power_ADC.Range   )  // 允许浮动范围外
		{
			Power_ADC.ValueBuf[sucCount0] = Power_ADC.Value;
		}
		else // 浮动范围内
		{
			// 一阶数字滤波
			Power_ADC.ValueBuf[sucCount0] = ( Power_ADC.Value*Power_ADC.Coefficient + Power_ADC.LastValue*(10-Power_ADC.Coefficient))/10;
		}
		Power_ADC.LastValue = Power_ADC.Value;
		Power_ADC.MaxValue = (Power_ADC.ValueBuf[sucCount0] > Power_ADC.MaxValue) ? Power_ADC.ValueBuf[sucCount0] : Power_ADC.MaxValue;
		Power_ADC.MinValue = (Power_ADC.ValueBuf[sucCount0] < Power_ADC.MinValue) ? Power_ADC.ValueBuf[sucCount0] : Power_ADC.MinValue;	
		Power_ADC.Sum += Power_ADC.Value;
		sucCount0++ ;		
		if( sucCount0 > Power_ADC.SampleCnt - 1 )
		{
			Power_ADC.OutValue = (uint16_t)( Power_ADC.Sum - Power_ADC.MaxValue -  Power_ADC.MinValue)/(Power_ADC.SampleCnt - 2);
			Power_ADC.MaxValue = 0;
			Power_ADC.MinValue =4095; 
			Power_ADC.Sum = 0;
			sucCount0 = 0;
		}
		
		
		Motor_ADC.Value = ADCDMA_Buf[2]&0xFFF;
		if( Motor_ADC.Value - Motor_ADC.LastValue > Motor_ADC.Range ||
			Motor_ADC.LastValue - Motor_ADC.Value < Motor_ADC.Range   )  // 允许浮动范围外
		{
			Motor_ADC.ValueBuf[sucCount1] = Motor_ADC.Value;
		}
		else // 浮动范围内
		{
			// 一阶数字滤波
			Motor_ADC.ValueBuf[sucCount1] = ( Motor_ADC.Value*Motor_ADC.Coefficient + Motor_ADC.LastValue*(10-Motor_ADC.Coefficient))/10;
		}
		Motor_ADC.LastValue = Motor_ADC.Value;
		Motor_ADC.MaxValue = (Motor_ADC.ValueBuf[sucCount1] > Motor_ADC.MaxValue) ? Motor_ADC.ValueBuf[sucCount1] : Motor_ADC.MaxValue;
		Motor_ADC.MinValue = (Motor_ADC.ValueBuf[sucCount1] < Motor_ADC.MinValue) ? Motor_ADC.ValueBuf[sucCount1] : Motor_ADC.MinValue;	
		Motor_ADC.Sum +=Motor_ADC.Value;
		sucCount1++ ;		
		if( sucCount1 > Motor_ADC.SampleCnt - 1 )
		{
			Motor_ADC.OutValue = (uint16_t)( Motor_ADC.Sum - Motor_ADC.MaxValue -  Motor_ADC.MinValue)/(Motor_ADC.SampleCnt - 2);
			Motor_ADC.MaxValue = 0;
			Motor_ADC.MinValue =4095; 
			Motor_ADC.Sum = 0;
			sucCount1 = 0;
			Motor.Current_AD = Motor_ADC.OutValue;
		}
		
		
		Hall_ADC.Value = ADCDMA_Buf[1]&0xFFF;	
		if( Hall_ADC.Value - Hall_ADC.LastValue > Hall_ADC.Range ||
			Hall_ADC.LastValue - Hall_ADC.Value < Hall_ADC.Range   )  // 允许浮动范围外
		{
			Hall_ADC.ValueBuf[sucCount2] = Hall_ADC.Value;
		}
		else // 浮动范围内
		{
			// 一阶数字滤波
			Hall_ADC.ValueBuf[sucCount2] = ( Hall_ADC.Value*Hall_ADC.Coefficient + Hall_ADC.LastValue*(10-Hall_ADC.Coefficient))/10;
		}
		Hall_ADC.LastValue = Hall_ADC.Value;
		Hall_ADC.MaxValue = (Hall_ADC.ValueBuf[sucCount2] > Hall_ADC.MaxValue) ? Hall_ADC.ValueBuf[sucCount2] : Hall_ADC.MaxValue;
		Hall_ADC.MinValue = (Hall_ADC.ValueBuf[sucCount2] < Hall_ADC.MinValue) ? Hall_ADC.ValueBuf[sucCount2] : Hall_ADC.MinValue;	
		Hall_ADC.Sum +=Hall_ADC.Value;
		sucCount2++ ;		
		if( sucCount2 > Hall_ADC.SampleCnt - 1 )
		{
			Hall_ADC.OutValue = (uint16_t)( Hall_ADC.Sum - Hall_ADC.MaxValue -  Hall_ADC.MinValue)/(Hall_ADC.SampleCnt - 2);
			Hall_ADC.MaxValue = 0;
			Hall_ADC.MinValue =4095; 
			Hall_ADC.Sum = 0;
			sucCount2 = 0;
			Sys.LineHall_Val = Hall_ADC.OutValue/20*2;
		}		
		
		
		ADC_Vrefint = ADCDMA_Buf[3]&0xFFF;
		Sys.Vrefint_Bias = ADC_Vrefint;	
		dma_interrupt_flag_clear(DMA_CH0, DMA_INT_FLAG_FTF);
	
	}
}



/**
  *----------------------------------------------
  * @name   : TIMER0_Channel_IRQHandler
  * @brief  : 定时器0中断服务函数
  * @param  : None
  * @retval : None
  * @note   : 编码计数中断
  *----------------------------------------------
  */
void TIMER0_Channel_IRQHandler(void)
{
    if(SET == timer_interrupt_flag_get(TIMER0, TIMER_INT_FLAG_CH1))
	{
        timer_interrupt_flag_clear(TIMER0, TIMER_INT_FLAG_CH1);

        Motor.FBpulseCnt ++;  // 电机编码器反馈计数

        if( Motor.State != MOTOR_STATE_STOP ) // 电机处于运行状态
        {
            if( Motor.Dir == MOTOR_DIR_FORWARD ) // 电机在前进
            {
                Sys.AbsPosition ++;                                     // 电机前进，绝对位置累加
                if( SysFSM_State == SysFSM_Inject) Sys.InjDistance ++;  // 注射时，注射行程累加
            }
            else // 后退
            {
                Sys.AbsPosition --;                                     // 电机后退，绝对位置减少
                if( SysFSM_State == SysFSM_Inject ) Sys.InjDistance --;              
            }
			if( SysFSM_State == SysFSM_Homing ) Sys.HomingLoc ++;       // 复位时，电机动则复位行程增加
			if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Aging \
				&& TestFun_Reciprocate_Homing_RunningFlag == 1) Sys.HomingLoc++;
			if( SysFSM_State == SysFSM_TestFun && TestFunList ==  TestFunList_Calibrate ) Sys.HomingLoc++;
        }
    }

    // 同上
    if(SET == timer_interrupt_flag_get(TIMER0, TIMER_INT_FLAG_CH2))
	{
        timer_interrupt_flag_clear(TIMER0, TIMER_INT_FLAG_CH2);
        
        Motor.FBpulseCnt ++;

        if( Motor.State != MOTOR_STATE_STOP )
        {
            if( Motor.Dir == MOTOR_DIR_FORWARD )
            {
                Sys.AbsPosition ++;
                if( SysFSM_State == SysFSM_Inject) Sys.InjDistance ++;
            }
            else // 后退
            {
                Sys.AbsPosition --;
                if( SysFSM_State == SysFSM_Inject ) Sys.InjDistance --;              
            }
			if( SysFSM_State == SysFSM_Homing ) Sys.HomingLoc ++;	
			if( SysFSM_State == SysFSM_TestFun && TestFunList == TestFunList_Aging \
				&& TestFun_Reciprocate_Homing_RunningFlag == 1) Sys.HomingLoc++;	
			if( SysFSM_State == SysFSM_TestFun && TestFunList ==  TestFunList_Calibrate ) Sys.HomingLoc++;			
        }        
    }    
}

/**
  *----------------------------------------------
  * @name   : TIMER5_IRQHandler
  * @brief  : 定时器5定时中断服务函数
  * @param  : None
  * @retval : None
  * @note   : 500us 中断
  *----------------------------------------------
  */
void TIMER5_IRQHandler(void)
{
    if(SET == timer_interrupt_flag_get(TIMER5, TIMER_INT_FLAG_UP))
	{
        timer_interrupt_flag_clear(TIMER5, TIMER_INT_FLAG_UP);	
		
		Voice.SendData();
    }
}




/**
  *----------------------------------------------
  * @name   : TIMER5_IRQHandler
  * @brief  : 定时器13定时中断服务函数
  * @param  : None
  * @retval : None
  * @note   : 无操作时间大于STANDBY_TO_POWEROFF_SEC则自动关机
  *----------------------------------------------
  */
void TIMER13_IRQHandler(void)
{
    if(SET == timer_interrupt_flag_get(TIMER13, TIMER_INT_FLAG_UP))
	{
        timer_interrupt_flag_clear(TIMER13, TIMER_INT_FLAG_UP);	
		
		if( SysFSM_State == SysFSM_Standby || SysFSM_State == SysFSM_Inject || \
			SysFSM_State == SysFSM_Fault || SysFSM_State == SysFSM_LowPower )
		{
			Sys.NoOperationShutdownCnt ++;
			if( Sys.NoOperationShutdownCnt > STANDBY_TO_POWEROFF_SEC  )
			{
                  SysFSM_State = SysFSM_Shutdown;
			}
		}
		else Sys.NoOperationShutdownCnt = 0;
    }
}


/**
  *----------------------------------------------
  * @name   : TIMER15_IRQHandler
  * @brief  : 定时器15定时中断服务函数
  * @param  : None
  * @retval : None
  * @note   : 10ms 中断调速 (100Hz)
  *----------------------------------------------
  */
void TIMER15_IRQHandler(void)
{
    static uint8_t sucCnt_ReadFBpluse;    

    if(SET != timer_interrupt_flag_get(TIMER15, TIMER_INT_FLAG_UP)) return;
	timer_interrupt_flag_clear(TIMER15, TIMER_INT_FLAG_UP);

    // 100ms调节一次
    if( ++sucCnt_ReadFBpluse >= 11 )    
    {
        // 编码反馈周期
        sucCnt_ReadFBpluse = 0;
		Sys.Motor_Regulation_Flag = 1;
	}
}




/********************************************************
  End Of File
********************************************************/

