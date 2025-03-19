/**
  ******************************************************************************
  * @file           : Voice.c
  * @brief          : 
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "Voice.h"

/* Private variables----------------------------------------------------------*/
static void Voice_Init(void);
static void Voice_Work(void);
static void Voice_WriteData(uint8_t data);
static void Voice_SendData(void);
static void Voice_Programmer(void);


/* Public variables-----------------------------------------------------------*/
Voice_t Voice=
{
	.Data = 0xff,
	.State = 0,
	.SendStepx = Voice_SendStep1,
	.Init = Voice_Init,
	.Work = Voice_Work,
	.WriteData = Voice_WriteData,
	.SendData = Voice_SendData,
	.Programmer = Voice_Programmer
};

/* Private function prototypes------------------------------------------------*/      

/**
  *----------------------------------------------
  * @name   : Voice_Init
  * @brief  : 初始化函数
  * @param  : None
  * @retval : None
  * @note   : 1ms轮询
  *----------------------------------------------
  */
static void Voice_Init(void)
{
    Voice.WriteData(AUDIO_ADDR_LoudLeveL_H);  // 开机滴一定要大声
}

/**
  *----------------------------------------------
  * @name   : Voice_Work
  * @brief  : 工作函数
  * @param  : None
  * @retval : None
  * @note   : 1ms轮询
  *----------------------------------------------
  */
static void Voice_Work(void)
{

}


/**
  *----------------------------------------------
  * @name   : Voice_WriteData
  * @brief  : 将指令写入发送区并播放
  * @param  : None
  * @retval : None
  * @note   : 1ms轮询
  *----------------------------------------------
  */
static void Voice_WriteData(uint8_t data)
{	
	//return;
    gpio_output_options_set(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_12);
    gpio_output_options_set(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_15); 
    Voice.Data = data;
	timer_enable(TIMER5);
}


/**
  *----------------------------------------------
  * @name   : Voice_SendData
  * @brief  : 将指令发送
  * @param  : None
  * @retval : None
  * @note   : 500us = 0.5ms轮询
  *           CLK拉低 -> 写DATA -> 延时 
  *           -> CLK拉高 -> 延时
  *----------------------------------------------
  */
static void Voice_SendData(void)
{
	static uint8_t data;
	static uint8_t cnt;
    if( Voice.Data != 0xFF && Voice.SendStepx == Voice_SendStep1)
	{
		Voice.State = 1;  // 置忙
		VOICE_CLK(0);     // 时钟线低
		VOICE_DATA(0);    // 数据线高
		
		if( cnt < 10 )  //　延时5ms　
		{
			cnt ++;
		}
		else 
		{
			cnt = 0;
			data = Voice.Data; 
		    Voice.SendStepx = Voice_SendStep2;
		}
	}
	if( Voice.SendStepx >= Voice_SendStep2  )
	{
		switch ( Voice.SendStepx )
	   {
		case Voice_SendStep2 : 
			VOICE_CLK(0);
	        VOICE_DATA(data&0x01);
	        Voice.SendStepx = Voice_SendStep3;
			break;
		case Voice_SendStep3 : 
			VOICE_CLK(1);
		    Voice.SendStepx = Voice_SendStep4;  // 发送第0位
			break;	
		case Voice_SendStep4 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>1)&0x01 );
		    Voice.SendStepx = Voice_SendStep5;  
			break;
		case Voice_SendStep5 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep6;  // 发送第1位
			break;			
		case Voice_SendStep6 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>2)&0x01 );
	        Voice.SendStepx = Voice_SendStep7;  
			break;
		case Voice_SendStep7 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep8;  // 发送第2位
			break;			
		case Voice_SendStep8 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>3)&0x01 );     
	        Voice.SendStepx = Voice_SendStep9;
			break;
		case Voice_SendStep9 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep10;  // 发送第3位
			break;			
		case Voice_SendStep10 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>4)&0x01 );     
	        Voice.SendStepx = Voice_SendStep11;
			break;
		case Voice_SendStep11 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep12;  // 发送第4位
			break;	
		case Voice_SendStep12 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>5)&0x01 );     
	        Voice.SendStepx = Voice_SendStep13;
			break;
		case Voice_SendStep13 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep14;  // 发送第5位
			break;	
		case Voice_SendStep14 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>6)&0x01 );     
	        Voice.SendStepx = Voice_SendStep15;
			break;
		case Voice_SendStep15 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep16;  // 发送弟6位
			break;	
		case Voice_SendStep16 : 
			VOICE_CLK(0);
	        VOICE_DATA( (data>>7)&0x01 );     
	        Voice.SendStepx = Voice_SendStep17;
			break;
		case Voice_SendStep17 : 
			VOICE_CLK(1);
	        Voice.SendStepx = Voice_SendStep18;  // 发送弟7位		
			break;		
		default:		
			VOICE_CLK(1);
			VOICE_DATA(1);
			data = 0;
			Voice.Data = 0xff;
		    Voice.State = 0; 	
			Voice.SendStepx = Voice_SendStep1;
	        timer_disable(TIMER5);
		    break;
	    }
	}
}


/**
  *----------------------------------------------
  * @name   : Voice_Programmer
  * @brief  : 烧录模式
  * @param  : None
  * @retval : None
  * @note   : 将相关IO口开漏
  *----------------------------------------------
  */
static void Voice_Programmer(void)
{
	gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_12);	
	gpio_output_options_set(GPIOA, GPIO_OTYPE_OD, GPIO_OSPEED_50MHZ, GPIO_PIN_12); 
	gpio_bit_set(GPIOA, GPIO_PIN_12);	
		
        // DATA PA15    
	gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_15);	
	gpio_output_options_set(GPIOA, GPIO_OTYPE_OD, GPIO_OSPEED_50MHZ, GPIO_PIN_15);		
	gpio_bit_set(GPIOA, GPIO_PIN_15);	
}

/********************************************************
  End Of File
********************************************************/


