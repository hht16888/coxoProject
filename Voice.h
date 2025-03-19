/**
  ******************************************************************************
  * @file           : Voice.h
  * @brief          : Header for Voice.c file.
  ******************************************************************************
  * @attention
  * 模块信息：
  * 厂商：深圳唯创知音电子有限公司（广州唯创电子有限公司）
  * 型号：WT588F02B-8S SOP8
  *  
  *						    -------
  *		忙信号输出  BUSY   |1*	  8|  GND   电源负极
  *		两线时钟线	CLK	   |2     7|  PWMP  信号输出
  *		两线数据线	DATA   |3     6|  VDD   电源正极
  *				   烧录口  |4     5|  PWMN  信号输出
  *						    -------
  *  烧录的时候需将相关的IO口设置成高阻或浮空，以免影响烧录；
  *  正常使用设置回推挽输出。
  *
  *  二线控制模式，使用500us定时器作为时序延时；
  *  Voice.WriteData写入数据后自动开启定时器发送数据，发送完后关闭定时器。
  * 
  *  语音地址对应关系：
  *        数据(十六进制)         功能
  *            00H             播放第0段语音
  *            01H             播放第1段语音
  *            02H             播放第2段语音
  *            ...
  *            DFH             播放第223段语音
  *          
  *  E0H — EFH 16级音量调节    在语音播放结束、播放过程中可发送
  *            F1H             无缝衔接循环播放指令
  *            F2H             循环播放当前语音-
  *            F3H             连码播放
  *            FEH             停止播放当前语音
  *
  ******************************************************************************
  */
	
/*******************************************************************************
  * @语音内容
  * 
  * 0x00    歌
  * 0x01    1-滴
  * 0x02    1-滴x2
  * 0x03    慢速模式  
  * 0x04    中速模式  
  * 0x05    快速模式
  * 0x06    牙周膜注射模式
  * 0x07    注射开始
  * 0x08    注射关闭
  * 0x09    音乐开
  * 0x0A    音乐关
  * 0x0B    药物耗尽
  * 0x0C    注射完成
  * 0x0D    零点一
  * 0x0E    零点三
  * 0x0F    零点六
  * 0x10    零点九
  * 0x11    一点七
  * 0x12    一点八
  * 0x13    零点五毫升
  * 0x14    一毫升
  * 0x15    一点五毫升
  * 0x16    已解锁
  * 0x17    已关锁
  * 0x18    旧歌 
  ****************************************************************************
  */
#ifndef __VOICE_H__
#define __VOICE_H__

/* Includes ------------------------------------------------------------------*/
#include "AppInclude.h"

/* Public define--------------------------------------------------------------*/
#define VOICE_CLK(x)      gpio_bit_write(GPIOA, GPIO_PIN_12, x)
#define VOICE_DATA(x)     gpio_bit_write(GPIOA, GPIO_PIN_15, x)
#define VOICE_BUSY        gpio_input_bit_get(GPIOA, GPIO_PIN_11)

/* Private define-------------------------------------------------------------*/

#define  AUDIO_ADDR_Song             0x08     // 歌曲
//#define  AUDIO_ADDR_Song2            0x08     // 歌曲3
#define  AUDIO_ADDR_Song2            0x07     // 歌曲2
#define  AUDIO_ADDR_Di               0x01     // 滴 
#define  AUDIO_ADDR_DiDi             0x02     // 滴滴
#define  AUDIO_ADDR_DiDiDi           0x09     // 滴滴滴

#ifdef VER_CN   
#define  AUDIO_ADDR_Low              0x03     // 慢速模式
#define  AUDIO_ADDR_Mid              0x04     // 中速模式
#define  AUDIO_ADDR_High             0x05     // 快速模式
#define  AUDIO_ADDR_PDL              0x06     // 牙周膜注射模式
#define  AUDIO_ADDR_PDL2             0x27     // 牙周膜注射模式
#define  AUDIO_ADDR_MusicOpen        0x01      // 音乐开
#define  AUDIO_ADDR_MusicClose       0x0A      // 音乐关
#define  AUDIO_ADDR_AllOver          0x0B     // 药物耗尽
#define  AUDIO_ADDR_SingleOver       0x0C     // 注射完成
#define  AUDIO_ADDR_ZeroOne          0x0D     // 零点一
#define  AUDIO_ADDR_ZeroThree        0x0E     // 零点三
#define  AUDIO_ADDR_ZeroSix          0x0F     // 零点六
#define  AUDIO_ADDR_ZeroNine         0x10     // 零点九
#define  AUDIO_ADDR_OnePotSeven      0x11     // 一点七
#define  AUDIO_ADDR_OnePotEight      0x12     // 一点八
#define  AUDIO_ADDR_InjStart         0x16     // 开锁
#define  AUDIO_ADDR_InjClose         0x17     // 关锁


#else
#define  AUDIO_ADDR_Low              0x18     // 慢速模式       low speed
#define  AUDIO_ADDR_Mid              0x19     // 中速模式       middle speed
#define  AUDIO_ADDR_High             0x1A     // 快速模式       high speed
#define  AUDIO_ADDR_PDL              0x27     // 牙周膜注射模式  PDL mode
#define  AUDIO_ADDR_MusicOpen        0x01      // 音乐开
#define  AUDIO_ADDR_MusicClose       0x0A      // 音乐关
#define  AUDIO_ADDR_AllOver          0x1C     // 药物耗尽    Anesthetic exhausted
#define  AUDIO_ADDR_SingleOver       0x1B     // 注射完成    Injection completed
#define  AUDIO_ADDR_ZeroOne          0x1D     // 零点一      Zero point one
#define  AUDIO_ADDR_ZeroThree        0x1E     // 零点三      Zero point three
#define  AUDIO_ADDR_ZeroSix          0x1F     // 零点六      Zero point six
#define  AUDIO_ADDR_ZeroNine         0x20     // 零点九      Zero point nine
#define  AUDIO_ADDR_OnePotSeven      0x11     // 一点七
#define  AUDIO_ADDR_OnePotEight      0x21     // 一点八      One point eighth
#define  AUDIO_ADDR_InjStart         0x23     // 开锁        lock
#define  AUDIO_ADDR_InjClose         0x22     // 关锁        unlock

#endif
/*
//#define  AUDIO_ADDR_InjStart         0x07     // 注射开始
//#define  AUDIO_ADDR_InjClose         0x08     // 注射关闭
#define  AUDIO_ADDR_InjStart         0x16     // 已解锁
#define  AUDIO_ADDR_InjClose         0x17     // 已关锁
#define  AUDIO_ADDR_MusicOpen        0x09      // 音乐开
#define  AUDIO_ADDR_MusicClose       0x0A      // 音乐关
#define  AUDIO_ADDR_AllOver          0x0B     // 药物耗尽
#define  AUDIO_ADDR_SingleOver       0x0C     // 注射完成
#define  AUDIO_ADDR_ZeroOne          0x0D     // 零点一
#define  AUDIO_ADDR_ZeroThree        0x0E     // 零点三
#define  AUDIO_ADDR_ZeroSix          0x0F     // 零点六
#define  AUDIO_ADDR_ZeroNine         0x10     // 零点九
#define  AUDIO_ADDR_OnePotSeven      0x11     // 一点七
#define  AUDIO_ADDR_OnePotEight      0x12     // 一点八
#define  AUDIO_ADDR_ZeroFiveML       0x13     // 零点五毫升
#define  AUDIO_ADDR_OneML            0x14     // 一毫升
#define  AUDIO_ADDR_OnePotFiveML     0x15     // 一点五毫升
*/


// 0x16 已解锁
// 0x17 已关锁
#define AUDIO_ADDR_Mute           0xFE     // 停止播放当前语音
#define AUDIO_ADDR_LoudLeveL_H    0xEE     // 音量高
#define AUDIO_ADDR_LoudLeveL_L    0xE8     // 音量低


/* enum type --------------------------------------------------------*/
enum Voice_SendStep
{ 
	Voice_SendStep1 = 1,
	Voice_SendStep2,
	Voice_SendStep3,
	Voice_SendStep4,
	Voice_SendStep5,
	Voice_SendStep6,
	Voice_SendStep7,
	Voice_SendStep8,
	Voice_SendStep9,
	Voice_SendStep10,
	Voice_SendStep11,
	Voice_SendStep12,
	Voice_SendStep13,
	Voice_SendStep14,
	Voice_SendStep15,
	Voice_SendStep16,
	Voice_SendStep17,
	Voice_SendStep18,
	Voice_SendStep19,
	Voice_SendStep20,
	Voice_SendStep21,
	Voice_SendStep22,
	Voice_SendStep23,
	Voice_SendStep24,
	Voice_SendStep25
};



/* structure type-------------------------------------------------------------*/
typedef struct 
{
    uint8_t Data;
	uint8_t State;          //  0: 空闲, 其它：发送中      
    uint8_t SendStepx;      //  发送步骤	
    void (*Init)(void);
	void (*Work)(void);
	void (*WriteData)(uint8_t data);
	void (*SendData)(void);
	void (*Programmer)(void);
}Voice_t;

/* extern variables-----------------------------------------------------------*/
extern Voice_t Voice;

/* extern function prototypes-------------------------------------------------*/


#endif
/********************************************************
  End Of File
********************************************************/

