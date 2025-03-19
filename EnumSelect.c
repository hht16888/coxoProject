#include "BLL.h"

enum MenuList_t MenuList = MenuList_Aging;

void Test_TorqueAndThrust(void);

/**
* @name   : MenuSelet_BLL
* @brief  : 设置界面
* @param  : None
* @retval : None
* @note   : 1ms轮询
*           Torque_Thrust : 扭力与推力
*               Touch     : 触摸 
*             Calibrate   : 校准
*              OPP_SET    : 阻力保护
*             Key_Press   : 按键触发克数测试
*           Reciprocation : 往复老化
*/
void MenuSelet_BLL(void)
{
	static uint8_t sucPassword;
	static uint8_t sucCnt_Refresh;
	
	if( sucCnt_Refresh++ > 50 )
	{
		sucCnt_Refresh = 0;
		
		OLED.Refresh();
		Voice.Programmer();
	}
	
	
	switch( MenuList )
	{
		
	// 老化模式
	case MenuList_Aging:
		OLED.ShowString(0, 0, "1.laohua     <-");
		OLED.ShowString(1, 0, "2.jiaozhun     ");
		OLED.ShowString(2, 0, "3.Torque       ");
		OLED.ShowString(3, 0, "4.1.8mL        ");
		TestFunList = TestFunList_Aging;	
		break;
	
	// 校准模式	
	case MenuList_Calibrate:
		OLED.ShowString(0, 0, "1.laohua       ");
		OLED.ShowString(1, 0, "2.jiaozhun   <-");
		OLED.ShowString(2, 0, "3.Torque       ");
		OLED.ShowString(3, 0, "4.1.8mL        ");
		TestFunList = TestFunList_Calibrate;		
		break;	

	// 电机参数
	case MenuList_TorqueAndThrust:
		OLED.ShowString(0, 0, "1.laohua       ");
		OLED.ShowString(1, 0, "2.jiaozhun     ");
		OLED.ShowString(2, 0, "3.Torque     <-");
		OLED.ShowString(3, 0, "4.1.8mL        ");
		TestFunList = TestFunList_TorqueAndThrust;
		break;
	
	// 单次1.8mL
	case MenuList_Once18mL:
		OLED.ShowString(0, 0, "1.laohua       ");
		OLED.ShowString(1, 0, "2.jiaozhun     ");
		OLED.ShowString(2, 0, "3.Torque       ");
		OLED.ShowString(3, 0, "4.1.8mL      <-");
		TestFunList = TestFunList_Once18mL;
		break;	
	
	// 恢复出厂
	case MenuList_DefaultParam:
		OLED.ShowString(0, 0, "2.jiaozhun     ");
		OLED.ShowString(1, 0, "3.Torque       ");
		OLED.ShowString(2, 0, "4.1.8mL        ");
		OLED.ShowString(3, 0, "5.chuchang   <-");	
		TestFunList = TestFunList_DefaultParam;
		break;
	
	// 过力保护 
	case MenuList_OPP_SET:
		OLED.ShowString(0, 0, "3.Torque       ");
		OLED.ShowString(1, 0, "4.1.8mL        ");
		OLED.ShowString(2, 0, "5.chuchang     ");
		OLED.ShowString(3, 0, "6.OPP_SET    <-");	
		TestFunList = TestFunList_OPP_SET;		
		break;		
/*	
	case MenuList_KeyPress:
		OLED.ShowString(0, 0, "     Touch     ");
		OLED.ShowString(1, 0, "   Calibrate   ");
		OLED.ShowString(2, 0, "    OPP_SET    ");
		OLED.ShowString(3, 0, "-- Key_Press --");	
		TestFunList = TestFunList_KeyPress;		
		break;		
	

	case MenuList_WPT:
		OLED.ShowString(0, 0, "    OPP_SET    ");
		OLED.ShowString(1, 0, "   Key_Press   ");
		OLED.ShowString(2, 0, " Reciprocation ");		
		OLED.ShowString(3, 0, "--    WPT    --");		
		TestFunList =TestFunList_WPT;		
*/	
	default: break;

	}
}



