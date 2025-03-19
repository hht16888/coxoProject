#include "BLL.h"

/*-----------------------------------------------
关机流程：
    0. OLED熄屏
    1. 设备停止
    2. 存入Flash
    3. 断电
    4. 关机完成
-----------------------------------------------*/
/**
* @name   : Shutdown_BLL
* @brief  : 关机
* @param  : None
* @retval : None
* @note   : 1ms轮询
*/
void Shutdown_BLL(void)
{
    static uint8_t sucStep;
    if( sucStep == 0 && Sys.MemoryDataErrorFlag == 0 )
    {
        OLED.ScreenDark();
     // OLED_RES(0);
        Motor.Stop();
	    Key_Stop(&TKEY);
        Key_Stop(&KEY1);
        Key_Stop(&KEY2);
        Key_Stop(&KEY3);
        Key_Stop(&PKEY);
		FlashWriteData.data_valid_flag = 0xF1;
        FlashWriteData.F_WR_flag = 0x01;
		FlashWriteData.F_LoudLevel = Sys.LoudLevel;
		FlashWriteData.F_MusicStyle = Sys.MusicStyle;
		FlashWriteData.F_AbsPosition = Sys.AbsPosition;
		FlashWriteData.F_InjectDose = Sys.InjectDose;
		FlashWriteData.F_InjectSpeed = Sys.InjectSpeed;
		FlashWriteData.F_OPP_Value = Sys.OPP_Value;
		FlashWriteData.F_Language = Sys.Language;
		FlashWriteData.F_HomingOffset = Sys.HomingOffset;
		FlashWriteData.F_BatteyLevel = Sys.BatteryLevel;
        FlashWriteData.F_MusicSwitch = Sys.MusicSwitch;
		FlashTool.Write(&FlashWriteData);
        delay_1ms(5);
		sucStep = 1;
        Sys.Power_OFF();
    }
	
	if( Sys.MemoryDataErrorFlag == 1 ) Sys.Power_OFF();


}