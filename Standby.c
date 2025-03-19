#include "BLL.h"


void BackDoor();


/**
* @name   : BackDoor
* @brief  : 进入后门
* @param  : None
* @retval : None
* @note   : 1ms轮询，
*           1、按住KEY2的时候连按5下KEY3
*           1、按住KEY3的时候连按5下KEY2
*/
void BackDoor()
{
	static uint8_t sucStep;
	static uint8_t sucCnt;
	
	switch( sucStep )
	{
		case 0:
			sucCnt = 0;
			if( KEY2_PressHold_Flag == 1 ) sucStep = 1;

			break;
		
		case 1:
			if( KEY2_PressHold_Flag == 1 )
			{				
				if( KEY3_SingleClied_Flag == 1 )
				{
					KEY3_SingleClied_Flag = 0;
					sucCnt++;
				}				
			}
			else 
			{
				if( sucCnt > 4 )
				{
					sucCnt = 0;
					sucStep = 4;
				}
				else sucStep = 0;
			}
			break;		

		case 2:
			sucCnt = 0;
			if( KEY3_PressHold_Flag == 1 ) sucStep = 3;
			else if( KEY2_PressHold_Flag == 1 ) sucStep = 0;
			break;
		
		case 3:
			if( KEY3_PressHold_Flag == 1 )
			{				
				if( KEY2_SingleClied_Flag == 1 )
				{
					KEY2_SingleClied_Flag = 0;
					sucCnt++;
				}				
			}
			else 
			{
				if( sucCnt > 4 )
				{
					sucCnt = 0;
					sucStep = 4;
				}
				else sucStep = 0;
			}			
		break;		

		case 4:
			sucStep = 0;
			OLED.Clear();	
			OLED.Refresh();
			SysFSM_State = SysFSM_EnumSelet;
			MenuList = MenuList_Aging;
			Voice.Programmer();	
			break;
		default: break;
	}

}