/**
  ******************************************************************************
  * @file           : MicroKey.h
  * @brief          : Header for MicroKey.c file.
  ******************************************************************************
  * @attention
  * Example：
  * 1.申请一个按键结构体
  *   struct Key_t KEY0;
  *  
  * 2.初始化按键对象,绑定按键的GPIO电平读取接口,设置有效触发电平
  *   Key_Init(&KEY0, read_key_pin, 0);
  *  
  * 3.注册按键事件
  *  Key_Attach(&KEY0, KEY_SINGLE_CLICK, Callback_SINGLE_CLICK_Handler);
  *	                       按键事件                用户函数
  *	4.启动按键
  *   Key_Start(&KEY0);	
  *	  
  *	5.设置TICKS_INTERVAL周期轮询处理
  *	  while(1)
  *	  {
  *	      if( timer_ticks ==  TICKS_INTERVAL )
  *		  {
  *		      timer_ticks= 0;
  *			  Key_Ticks();
  *		  }
  *	  }
  *	
  ******************************************************************************
  */
	
#ifndef __MICROKEY_H__
#define __MICROKEY_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"
#include <stdint.h>
#include <string.h>


/* 宏定义 --------------------------------------------------------*/
#define TICKS_INTERVAL      5    // 心跳周期 ms
#define DEBOUNCE_TICKS      6    // 消抖 
#define SHORT_TICKS         (80/TICKS_INTERVAL)      // 短按 
#define LONG_TICKS          (650/TICKS_INTERVAL)     // 长按 

typedef void (*KeyCallback)();

typedef enum{
    KEY_PRESS_DOWN = 0,    // 按键按下，每次按下触发一次
	KEY_PRESS_UP,          // 按键弹起，每次弹起触发一次
	KEY_PRESS_REPEAT,      // 重复按下触发，变量repeat计数连击次数
	KEY_SINGLE_CLICK,      // 单击
	KEY_DOUBLE_CLICK,      // 双击
	KEY_TRIPLE_CLICK,      // 三击
	KEY_LONG_PRESS_START,  // 达到长按阈值触发一次
	KEY_LONG_PRESS_HOLD,   // 长按一直触发
	KEY_number_of_event,   // 以上事件类型的数量
	KEY_NONE_PRESS         // 未按下
}PressEvent;


typedef struct Key_t
{
    uint16_t ticks;         // 心跳计数
	uint8_t  repeat;        // 连击次数
	uint8_t  event;         // 事件类型
	uint8_t  state;         // 状态
	uint8_t  debounce_cnt;  //
	uint8_t  active_level;  // 有效电平
	uint8_t  key_level;     // 接入的按键电平
	uint8_t (*hal_key_level)(void);
	KeyCallback cb[KEY_number_of_event];
	struct Key_t* next;
}Key_t;



void Key_Init(struct Key_t* handle, uint8_t(*pin_level)(void), uint8_t active_level);
void Key_Attach(struct Key_t* handle, PressEvent event, KeyCallback cb);
PressEvent Get_Key_Event(struct Key_t* handle);
int Key_Start(struct Key_t* handle);
void Key_Stop(struct Key_t* handle);
void Key_Ticks(void);
void Key_Handler(struct Key_t* handle);



/* 以下用户实例 --------------------------------------------------------*/


extern uint8_t read_TKEY_pin(void);  // 读取TKEY电平
extern uint8_t read_KEY1_pin(void);  // 读取KEY1电平
extern uint8_t read_KEY2_pin(void);  // 读取KEY2电平
extern uint8_t read_KEY3_pin(void);  // 读取KEY3电平
extern uint8_t read_PKEY_pin(void);  // 读取PKEY电平
extern struct Key_t TKEY;
extern struct Key_t KEY1;
extern struct Key_t KEY2;
extern struct Key_t KEY3;
extern struct Key_t PKEY;

extern void Key_Config(void);


#endif
/********************************************************
  End Of File
********************************************************/