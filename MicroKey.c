/**
  ******************************************************************************
  * @file           : MicroKey.c
  * @brief          : 
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "MicroKey.h"

#ifndef NULL
	#define NULL ((void *)0)
#endif


#define EVENT_CB(ev)   if(handle->cb[ev]) handle->cb[ev]((Key_t*)handle)  // 执行回调函数
	
static struct Key_t* head_handle = NULL;


/**
  *----------------------------------------------
  * @name   : Key_Init
  * @brief  : 初始化按键结构体句柄
  * @param  : handle       -> 按键结构体句柄
  *           pin_level    -> 读取(接入)按键IO电平 
  *           active_level -> 按下时的电平
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
void Key_Init(struct Key_t* handle, uint8_t(*pin_level)(void), uint8_t active_level)
{
    memset(handle, 0, sizeof(struct Key_t));     // 反初始化
    handle->event = (uint8_t)KEY_NONE_PRESS;     // 设定初始时间(未按下)
    handle->hal_key_level = pin_level;           // 接入硬件驱动
    handle->key_level = handle->hal_key_level(); // 当前电平
    handle->active_level = active_level;         // 触发电平
}



/**
  *----------------------------------------------
  * @name   : Key_Attach
  * @brief  : 添加按键事件回调函数
  * @param  : handle -> 按键结构体句柄
  *           event  -> 触发事件类型
  *           cb     -> 回调函数
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void Key_Attach(struct Key_t* handle, PressEvent event, KeyCallback cb)
{
    handle->cb[event] = cb;
}



/**
  *----------------------------------------------
  * @name   : Get_Key_Event
  * @brief  : 获取按键事件
  * @param  : handle -> 按键结构体句柄
  * @retval : 按键事件
  * @note   : 
  *----------------------------------------------
  */
PressEvent Get_Key_Event(struct Key_t* handle)
{
    return (PressEvent)(handle->event);
}



/**
  *----------------------------------------------
  * @name   : Key_Start
  * @brief  : 启动按键工作，将句柄添加进工作表
  * @param  : handle -> 按键结构体句柄
  * @retval : None
  * @note   : 0  ->  成功
  *           -1 -> 已经存在
  *----------------------------------------------
  */
int Key_Start(struct Key_t* handle)
{
    struct Key_t* target = head_handle;
    while(target)
	{
	    if(target == handle ) return -1;   // 已经存在
		target = target -> next;
	}		
    handle -> next = head_handle;
  	head_handle = handle;
	  return 0;
}

/**
  *----------------------------------------------
  * @name   : Key_Stop
  * @brief  : 停止按键工作，将句柄移出工作表
  * @param  : handle -> 按键结构体句柄
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void Key_Stop(struct Key_t* handle)
{
    struct Key_t** curr;
	for( curr = &head_handle; *curr;)
	{
	    struct Key_t* entry = *curr;
		if( entry == handle)
		{
			*curr = entry->next;
			return;
		}
		else
			curr = &entry -> next;
	}



}

/**
  *----------------------------------------------
  * @name   : Key_Ticks
  * @brief  : 按键驱动心跳，每 TICKS_INTERVAL 跳一次
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void Key_Ticks(void)
{
    struct Key_t* target;
	for(target = head_handle; target; target = target->next)
	{
	    Key_Handler(target);
	}
}




/**
  *----------------------------------------------
  * @name   : Key_Handler
  * @brief  : 按键驱动
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void Key_Handler(struct Key_t* handle)
{
    uint8_t read_gpio_level = handle->hal_key_level();   // 读取当前电平
	
	if( (handle->state)>0 ) handle->ticks++;
	
	/*----------- 按键消抖处理 --------------*/	
	if( read_gpio_level != handle->key_level )   // 当前电平不等于上一次的电平
	{
	  if( ++(handle->debounce_cnt) >= DEBOUNCE_TICKS )  // DEBOUNCE_TICKS个周期消抖
	  {
	      handle->key_level = read_gpio_level;  // 更新电平
		  handle->debounce_cnt = 0;
	  }
	}
	else
	{
	    handle->debounce_cnt = 0;
	}
	
	/*------------- 状态机 ----------------*/	
	switch (handle->state)
	{
	    // 初始状态，等待按键按下
        case 0:
                if( handle->key_level == handle->active_level)  // 按下按键
				{
                    handle->event = (uint8_t)KEY_PRESS_DOWN;  // 事件标志  
					EVENT_CB(KEY_PRESS_DOWN);     // 触发按下事件 
					handle->ticks = 0;
					handle->repeat = 1;           // 记录按下1次  
					handle->state = 1;
				}
				else
				{
				    handle->event = (uint8_t)KEY_NONE_PRESS;    // 未按下
				}
	            break;
				
        case 1:
                if( handle->key_level != handle->active_level)  // 松开按键
				{
                    handle->event = (uint8_t)KEY_PRESS_UP;   
					EVENT_CB(KEY_PRESS_UP);
					handle->ticks = 0;
					handle->state = 2;
				}					
				else if( handle->ticks > LONG_TICKS )          // 按下的时间大于LONG_TICKS
				{
				    handle->event = (uint8_t)KEY_LONG_PRESS_START;  
					EVENT_CB(KEY_LONG_PRESS_START);   // 触发长按事件
					handle->state = 4;
				}
				break;
		case 2:
			    if( handle->key_level == handle->active_level )
				{
				    handle->event = (uint8_t)KEY_PRESS_DOWN;
					EVENT_CB(KEY_PRESS_DOWN);
					handle->repeat++;
					EVENT_CB(KEY_PRESS_REPEAT);
					handle->ticks = 0;
					handle->state = 3;
				}
				else if(handle->ticks > SHORT_TICKS )
				{
				    if(handle->repeat == 1)     // 单击
					{
					    handle->event = (uint8_t)KEY_SINGLE_CLICK;    
						EVENT_CB(KEY_SINGLE_CLICK);
					}
				    handle->state = 0;
				}
				break;
			
		case 3:
			    if(handle->key_level != handle->active_level )
				{
				    handle->event = (uint8_t)KEY_PRESS_UP;
				    EVENT_CB(KEY_PRESS_UP);
					handle->ticks = 0;
					handle->state = 2;
					if( handle->ticks < SHORT_TICKS )
					{
						handle->ticks = 0;
						handle->state = 2;
					}
					else handle->state = 0;
				}
				else if(handle->ticks > SHORT_TICKS)
				{
				    handle->state = 0;
				}
			    break;
				
		case 4:
			    if(handle->key_level == handle->active_level )
				{
				    handle->event = (uint8_t)KEY_LONG_PRESS_HOLD;
					EVENT_CB(KEY_LONG_PRESS_HOLD);
				}
				else
				{
				    handle->event = (uint8_t)KEY_PRESS_UP;
					EVENT_CB(KEY_PRESS_UP);
					handle->state = 0;
				}
				break;
				
	    default: handle->state = 0;
				break;
	}
}








/* 以下用户实例 --------------------------------------------------------*/
uint8_t read_TKEY_pin(void);  // 读取TKEY电平
uint8_t read_KEY1_pin(void);  // 读取KEY1电平
uint8_t read_KEY2_pin(void);  // 读取KEY2电平
uint8_t read_KEY3_pin(void);  // 读取KEY3电平
uint8_t read_PKEY_pin(void);  // 读取PKEY电平

/*------------------------------------------- 按键底层 -----------------------------------------------------*/
/**
  *----------------------------------------------
  * @name   : read_TKEY_pin
  * @brief  : 读取按键端口电平
  * @param  : None
  * @retval : 按下 --> 0
              松开 --> 1
  * @note   : None
  *----------------------------------------------
  */
uint8_t read_TKEY_pin(void)
{
    return gpio_input_bit_get(GPIOA, GPIO_PIN_0);
}

/**
  *----------------------------------------------
  * @name   : read_KEY1_pin
  * @brief  : 读取按键端口电平
  * @param  : None
  * @retval : 按下 --> 0
              松开 --> 1
  * @note   : None
  *----------------------------------------------
  */
uint8_t read_KEY1_pin(void)
{
    return gpio_input_bit_get(GPIOA, GPIO_PIN_1);
}

/**
  *----------------------------------------------
  * @name   : read_KEY2_pin
  * @brief  : 读取按键端口电平
  * @param  : None
  * @retval : 按下 --> 0
              松开 --> 1
  * @note   : None
  *----------------------------------------------
  */
uint8_t read_KEY2_pin(void)
{
	return gpio_input_bit_get(GPIOB, GPIO_PIN_7);
}


/**
  *----------------------------------------------
  * @name   : read_KEY3_pin
  * @brief  : 读取按键端口电平
  * @param  : None
  * @retval : 按下 --> 0
  *           松开 --> 1
  * @note   : None
  *----------------------------------------------
  */
uint8_t read_KEY3_pin(void)
{
    return gpio_input_bit_get(GPIOA, GPIO_PIN_7);
}

/**
  *----------------------------------------------
  * @name   : read_PKEY_pin
  * @brief  : 读取按键端口电平
  * @param  : None
  * @retval : 按下 --> 0
              松开 --> 1
  * @note   : None
  *----------------------------------------------
  */
uint8_t read_PKEY_pin(void)
{
    return gpio_input_bit_get(GPIOA, GPIO_PIN_4);
}




/********************************************************
  End Of File
********************************************************/

