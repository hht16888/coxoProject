/**
  ******************************************************************************
  * @file           : OLED.h
  * @brief          : Header for OLED.c file.                 
  ******************************************************************************
  * @attention
  * 模块信息：
  * 厂商:  东莞市合享实业有限公司
  * Part Name:  OEL Display Module
  * Part ID:  QG-6428TSWKG01
  * Number of Pixels 64*128
  * 横向显示，排线在左
  * Pixel 行*列=128*64，16列*4行（横向16个字符，纵向4个字符）
  *
  *       0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  *     ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
  *   0 │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
  *   1 │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
  *   2 │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
  *   3 │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │
  *     └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
  * Power up Sequence:
  *     1. VDD 
  *     2. Send Display off command
  *     3. Initialization
  *     4. Clear Screen
  *     5. Power up VPP
  *     6. Delay 100ms ( When VPP is stable )
  *     7. Send Display on command
  * 
  * Power down Sequence:
  *     1. Send Display off command
  *     2. Power down VPP
  *     3. Delay 100ms
  *     4. Power down VDD
  ******************************************************************************
  */
#ifndef __OLED_H__
#define __OLED_H__

#include "AppInclude.h"

/* 宏定义 --------------------------------------------------------*/
#define OLED_A0(x)      gpio_bit_write(GPIOB, GPIO_PIN_4, x)    // 数据1/寄存器0
#define OLED_CTRL(x)    gpio_bit_write(GPIOF, GPIO_PIN_0, x)    // 电源开关 开1/关0
#define OLED_CS(x)      gpio_bit_write(GPIOB, GPIO_PIN_6, x)    // 片选信号
#define OLED_RES(x)     gpio_bit_write(GPIOF, GPIO_PIN_1, x)    // 复位引脚 先0后1

#define OLED_DISPLAY_OFF                 0xAE  // 显示关闭
#define OLED_DISPLAY_ON                  0xAF  // 显示打开
#define OLED_LOW_COLUMN_ADDRESS          0x00  // 高列地址
#define OLED_HIGH_COLUMN_ADDRESS         0x10  // 低列地址
#define OLED_PAGE_ADDRESS                0xB0  // 页地址
#define OLED_DISPLAY_STARTLINE_A         0xDC  // 起始线
#define OLED_DISPLAY_STARTLINE_B         0x00  // 起始线
#define OLED_CONTRACT_CONTROL            0x81  
#define OLED_128                         0x2F
#define OLED_MEMORY_ADDRESS_MODE         0x21  // 寻址模式
#define OLED_SEGMENT_REMAP               0xA1  // 区段重映射
#define OLED_SCAN_DIRECTION              0xC0  // 扫描方向
#define OLED_DISABLE_ENTIRE_DISPLAY_ON   0xA4  
#define OLED_BACKGROUND_COLOR            0xA7  // 0xA6:黑底白字  0xA7:白底黑字
#define OLED_MULTIPLEX_RATIO_A           0xA8  
#define OLED_MULTIPLEX_RATIO_B           0x3F
#define OLED_DISPLAY_OFFSET_A            0xD3  // 偏移量
#define OLED_DISPLAY_OFFSET_B            0x60  // 偏移量
#define OLED_OSC_DIVISION_A              0xD5  // 分频
#define OLED_OSC_DIVISION_B              0x51  // 分频
#define OLED_PRE_CHARGE_PERIOD_A         0xD9  // 预充电周期
#define OLED_PRE_CHARGE_PERIOD_B         0x22  // 预充电周期
#define OLED_SET_VCOMH_A                 0xDB  // 设置电平阈值
#define OLED_SET_VCOMH_B                 0x35  // 设置电平阈值
#define OLED_CHARGE_PUMP_ENABLE          0xad  // 电荷泵使能
#define OLED_DCDC_ENABLE                 0x81  // DCDC使能


/* 结构体类型 ------------------------------------------------------*/
typedef struct 
{
  unsigned char DisplayBuf[64][16];  // 显示数据区, 64行 16列
  void (*Init)(void);                // 初始化
  void (*ShowString)( uint8_t x, uint8_t y, char *format, ...  );
	void (*Clear)(void);               // 清除屏幕
	void (*Fill)(void);                // 填充屏幕
	void (*Refresh)(void);             // 更新显示
	void (*ScreenDark)(void);          // 屏幕熄灭
  void (*ScreenBright)(void);        // 屏幕点亮
	void (*ESD_Init)(void);          
//  void (*InsertAreaBMP_4Byte_16Byte)(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp );
//	void (*InsertAreaBMP_64Pix_16Byte)(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp );
	void (*InsertAreaBMP_64Pix_128Pix)(uint8_t x0, uint8_t y0, uint8_t *bmp, uint8_t Y, uint8_t X); 
	void (*DrawHorizonLine)(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
	void (*DrawVerticalLine)(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
	void (*ClearHorizonLine)(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
	void (*Drawchar_num)(uint8_t num, uint8_t x, uint8_t y);	
	
}OLED_t;

/* 外部变量 --------------------------------------------------------*/
extern OLED_t OLED;
extern void OLED_WriteREG(uint8_t data);
extern char OLED_Line0[16];
extern char OLED_Line1[16];
extern char OLED_Line2[16];
extern char OLED_Line3[16];


#endif


	