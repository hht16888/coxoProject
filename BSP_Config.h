 /**
  ******************************************************************************
  * @file           : IO_Config.h
  * @brief          : Header for IO_Config.c file.
  ******************************************************************************
  * @attention
  * 应用于板: 2201_T3 20220729  
  ******************************************************************************
  */
	
#ifndef __IO_CONF_H__
#define __IO_CONF_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"

/* Public define--------------------------------------------------------------*/
#define POWER_CRTL(x)    gpio_bit_write(GPIOA, GPIO_PIN_6, x)   // 电源控制1开0关
#define GET_PKEY_STA     gpio_input_bit_get(GPIOA, GPIO_PIN_6)

/* Private define-------------------------------------------------------------*/
#define SPI0_DMA_CH2    // OLED的SPI使用DMA模式

/* extern variables-----------------------------------------------------------*/
extern uint8_t spi0_send_array[1];

typedef struct
{
	uint8_t  SampleCnt;        // 样本数
	uint16_t MaxValue;         // 最大值
	uint16_t MinValue;         // 最小值
	uint16_t Range;            // 浮动范围
	uint16_t Value;            // 单次值
	uint16_t LastValue;        // 上次值
	uint16_t OutValue;         // 最终输出值
	uint8_t  Coefficient;      // 系数(n/10) 0-10
	uint32_t Sum;              // 累计值
	uint16_t ValueBuf[32];     // AD值缓存
}ADC_t;

extern ADC_t Motor_ADC;
extern ADC_t Power_ADC;
extern ADC_t Hall_ADC;

extern uint16_t ADCDMA_Buf[4];

/* extern function prototypes ------------------------------------------------*/
extern void IO_Config(void);
extern void NVIC_Config(void);
extern void SPI0_Init(void);
extern void TIMER0_Init(void);
extern void TIMER2_Init(uint16_t psc, uint16_t arr);
extern void TIMER5_Init(uint16_t psc, uint16_t arr);
extern void TIMER13_Init(uint16_t psc, uint16_t arr);
extern void TIMER15_Init(uint16_t psc, uint16_t arr);
extern void DMA_Init(void);
extern void ADC_Init(void);
extern void FWDGT_Config(void);



#endif
/********************************************************
  End Of File
********************************************************/



