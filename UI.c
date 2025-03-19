
/* Includes ------------------------------------------------------------------*/
#include "UI.h"

/* Private variables----------------------------------------------------------*/
static void Work_Refresh(void);

static void Work_UI(void);
static void Window_UI(uint8_t param);

static void DrawBackground(void);

static uint8_t StartupCartoon(void);
static void ShutdownCartoon(void);

static void BG_BatteryLevel(uint8_t pram);
static void BG_BatterLevel_Toggle(void);
static void Icon_BatteryLevel(uint8_t level);

//static void BG_MusicSwitch(void);
static void Icon_MusicSwitch(uint8_t sta);
static void Icon_MusicStyle(uint8_t param);

static void BG_InjectLock(void);
static void Icon_InjectLock(uint8_t sta);

//static void BG_SoundVolume(void);
static void Icon_SoundVolume(uint8_t sta);

static void BG_InjectBars(void);
static void Icon_InjectedBars(uint8_t n);

static void Icon_InjectDose(uint8_t val);

static void Icon_InjectSpeed(uint8_t val);

static void Icon_InjectArrow(uint8_t dir,uint8_t num);
static void Icon_InjectArrow2(uint8_t dir,uint8_t num);

static void Background_Char_mL(void);

static void Icon_RestDose(uint8_t num);

static void HollowArrow(uint8_t dir, uint8_t i, uint8_t j);
static void SolidArrow(uint8_t dir, uint8_t i, uint8_t j);
static void SolidArrow2(uint8_t dir, uint8_t i, uint8_t j);
static void Resistance_Feedback(uint16_t Pressure);
static void PDL_Or_NOPDL();

enum WindownShow_t  WindownShow = WindownShow_Null;
/* Public variables-----------------------------------------------------------*/
UI_t UI=
{
	.Work_Refresh        = Work_Refresh,
	
    .DrawBackground      = DrawBackground,
	
	.ShutdownCartoon     = ShutdownCartoon,	
    .StartupCartoon      = StartupCartoon,
	
	.Work_UI             = Work_UI,
	.Window_UI           = Window_UI,


	.Background_Char_mL  = Background_Char_mL,
	
	.BG_BatteryLevel     = BG_BatteryLevel,
	.BG_BatterLevel_Toggle = BG_BatterLevel_Toggle,
	.Icon_BatteryLevel   = Icon_BatteryLevel,

 //   .BG_MusicSwitch      = BG_MusicSwitch,
	.Icon_MusicSwitch    = Icon_MusicSwitch,
	.Icon_MusicStyle     = Icon_MusicStyle,

    .BG_InjectLock       = BG_InjectLock,
	.Icon_InjectLock     = Icon_InjectLock,

 //   .BG_SoundVolume      = BG_SoundVolume,
	.Icon_SoundVolume    = Icon_SoundVolume,
    
    /*20240806*/
    .Resistance_Feedback = Resistance_Feedback,
    .PDL_Or_NOPDL = PDL_Or_NOPDL,
    
	.Icon_InjectDose     = Icon_InjectDose,

	.Icon_InjectSpeed    = Icon_InjectSpeed,

    .BG_InjectBars       = BG_InjectBars,

    .Icon_InjectedBars   = Icon_InjectedBars,

	.Icon_InjectArrow    = Icon_InjectArrow,
	.Icon_InjectArrow2   = Icon_InjectArrow2,
	
    .Icon_RestDose       = Icon_RestDose,
    
};


/* Private function prototypes------------------------------------------------*/      
/**
  *----------------------------------------------
  * @name   : Init
  * @brief  : UI初始化
  * @param  : None
  * @retval : None
  * @note   : UI单次执行
  *----------------------------------------------
  */

/**
  *----------------------------------------------
  * @name   : StartupCartoon
  * @brief  : 开机动画
  * @param  : None
  * @retval : 开机完成返回1；否则返回0
  * @note   : 
  *----------------------------------------------
  */
static uint8_t StartupCartoon(void)
{
	
 //   return 1;  // 无需开机动画
    const uint8_t ticks = 25; // 间隔
    static uint16_t i;
	static uint8_t k;
	if( k++ > ticks )
	{
        k = 0;
        i = i + 2;	
        if( i < 64 )
        {
            OLED.InsertAreaBMP_64Pix_128Pix(0, i, (uint8_t *)Logo_COXO+8*i, 64, 1);
            return 0;
        }
        else if(i>=64 && i<68) 
        {
            return 0;
        }
        else if(i>=67 && i<90)
	    {
            OLED.InsertAreaBMP_64Pix_128Pix(0, i, (uint8_t *)Logo_COXO, 64, 64);
            return 0;
        }
       else
	   {
	      return 1;
       }		
	}
	else
		return 0;
}




/**
  *----------------------------------------------
  * @name   : Work_Refresh
  * @brief  : 工作状态下的UI刷新
  * @param  : None
  * @retval : None
  * @note   : 1ms轮询
  *----------------------------------------------
  */
static void Work_Refresh(void)
{
	return;
}


/**
  *----------------------------------------------
  * @name   : PDL_ml_Display
  * @brief  : 只刷新已注射剂量的ml字样
  * @param  : None
  * @retval : None
  * @note   : 1ms轮询
  * @date   : 20241031新增
  *----------------------------------------------
  */
static void PDL_ml_Display(void)
{
    const uint8_t Start_Row = 30;    // 起始行
	const uint8_t Start_Col = 107;   // 起始列	
	const uint8_t Start_Row_2 = Start_Row - 3;    // 起始行
	const uint8_t Start_Col_2 = Start_Col + 11;   // 起始列	
    // 'm'
	OLED.DrawVerticalLine(Start_Row,   Start_Col,   6, 9);
	OLED.ClearHorizonLine(Start_Row,   Start_Col+1, 1, 1);
	OLED.ClearHorizonLine(Start_Row+2, Start_Col+1, 1, 4);
	OLED.ClearHorizonLine(Start_Row+1, Start_Col+2, 2, 5);
	OLED.ClearHorizonLine(Start_Row,   Start_Col+4, 2, 1);
	OLED.ClearHorizonLine(Start_Row+2, Start_Col+5, 1, 4);	
	OLED.ClearHorizonLine(Start_Row+1, Start_Col+6, 2, 5);		
	OLED.ClearHorizonLine(Start_Row,   Start_Col+8, 1, 1);	
	
	// 'L'
	OLED.DrawVerticalLine(Start_Row_2, Start_Col_2,   9, 5);
	OLED.ClearHorizonLine(Start_Row_2, Start_Col_2+1, 4, 8);
	return;
}


/**
  *----------------------------------------------
  * @name   : Work_UI
  * @brief  : 工作UI界面
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Work_UI(void)
{
    //if( Sys.UI_Show_Mode != 0 ) return;	
    Sys.UI_Show_Mode = 0;
    OLED.ClearHorizonLine(7, 15, 96, 48);
    OLED.ClearHorizonLine(47, 89,39, 16);
    //OLED.Clear(); // 立即清空界面
    // 分割2横2竖
    OLED.DrawHorizonLine(21, 0, 128, 1);
    OLED.DrawHorizonLine(42, 0, 128, 1);
    OLED.DrawVerticalLine(42, 43, 21, 1);
    OLED.DrawVerticalLine(42, 84, 21, 1);
    // 进度条(框)view
    UI.Icon_InjectedBars(0);			 
    UI.BG_InjectBars();
    // 电池框view
    UI.BG_BatteryLevel(1);
    UI.Icon_BatteryLevel(Sys.BatteryLevel);
    // 注射锁
    UI.BG_InjectLock();
    // 音乐view
    UI.Icon_MusicSwitch(Sys.MusicSwitch);
//    Sys.SetMusicStyle(Sys.MusicStyle);
    // 音量view
    UI.Icon_SoundVolume(Sys.LoudLevel);
    Sys.SetLoudLevel(Sys.LoudLevel);
    // 锁view
    UI.Icon_InjectLock(Sys.InjectLock);
    Sys.SetInjectLock(Sys.InjectLock);
    // 已注射剂量
    UI.Icon_RestDose(Sys.AbsPosition/ENCODER_NUM_01ML);
    if( Sys.InjectSpeed == InjectSpeed_PDL && Sys.InjectingFlag == 1 && Sys.LowPowerWarning != 1 )
    {
        //只刷新已注射剂量的ml字样
        PDL_ml_Display();
        //显示PDL模式的阻力反馈条
        UI.Resistance_Feedback(Sys.PressureValue);
    }
    else
    {
        // 注射剂量
        UI.Icon_InjectDose(Sys.InjectDose);
        // 字符 mL
        UI.Background_Char_mL();
    }
    
    // 注射速度
    UI.Icon_InjectSpeed(Sys.InjectSpeed);
    // 注射箭头
    UI.Icon_InjectArrow2(0, 0);
}

/**
  *----------------------------------------------
  * @name   : Window_UI
  * @brief  : 信息弹窗界面
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Window_UI(uint8_t param)
{
	Sys.UI_Show_Mode = 1;
	if( param == WindownShow_Reset )
	{
		// 复位图片
		OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_Homing, 96, 48 );
	}
	else if( param == WindownShow_E1 )
	{
		OLED.InsertAreaBMP_64Pix_128Pix(0, 0, (uint8_t*)gImage_E1, 128, 64 );
	}
	else if( param == WindownShow_E2 )
	{
		OLED.InsertAreaBMP_64Pix_128Pix(0, 0, (uint8_t*)gImage_E2, 128, 64 );
	}	
	else if( param == WindownShow_E3 )
	{
		OLED.InsertAreaBMP_64Pix_128Pix(0, 0, (uint8_t*)gImage_E3, 128, 64 );
	}	
	else if( param == WindownShow_ResetFinish )
	{
		OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_HomingFinish, 96, 48 );
	}
	else if( param == WindownShow_OPP )
	{
		OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_OPP, 96, 48 );
	}
	else if( param == WindownShow_LowPower )
	{
		OLED.InsertAreaBMP_64Pix_128Pix(0, 0, (uint8_t*)gImage_LowPower, 128, 64 );	
	}
	else if( param == WindownShow_NoSuckBack )
	{
		OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_NoSuckBack, 96, 48 );
	}
    else if( param == WindownShow_Drug_absorption )
    {
        OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_Drug_absorption, 96, 48 );
    }
    else if( param == WindownShow_PowerLow )
    {
        OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_PowerLow, 96, 48 );
    }
    else if( param == WindownShow_willReturn )
    {
        OLED.ClearHorizonLine(7, 15, 96, 48);
		OLED.InsertAreaBMP_64Pix_128Pix(7, 15, (uint8_t*)gImage_willReturn, 96, 48 );
    }
}


/**
  *----------------------------------------------
  * @name   : DrawBackground
  * @brief  : 背景
  * @param  : None
  * @retval : None
  * @note   : // 没用
  *----------------------------------------------
  */
static void DrawBackground(void)
{


}
/**
  *----------------------------------------------
  * @name   : BG_BatteryLevel
  * @brief  : 电池框
  * @param  : pram -> 0隐1显
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void BG_BatteryLevel(uint8_t pram)
{
    if( Sys.UI_Show_Mode != 0 ) return;
    const uint8_t Start_Row = 6;   // 起始行
    const uint8_t Start_Col = 5;   // 起始列
    if( pram == 0 ) OLED.ClearHorizonLine(Start_Row, Start_Col, 22, 8);
    else if( pram == 1 )
    {
        OLED.DrawVerticalLine(Start_Row+2, Start_Col+19, 4, 1);   
        OLED.DrawHorizonLine(Start_Row, Start_Col, 17, 1);  
        OLED.DrawHorizonLine(Start_Row+7, Start_Col, 17, 1); 
        OLED.DrawVerticalLine(Start_Row+1, Start_Col+17, 6, 1);  
        OLED.DrawVerticalLine(Start_Row, Start_Col, 7, 1); 		
    }
}

/**
  *----------------------------------------------
  * @name   : BG_BatterLevel_Toggle
  * @brief  : 电池框显示翻转
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void BG_BatterLevel_Toggle(void)
{
    if( Sys.UI_Show_Mode != 0 ) return;
    static uint8_t i;
    if( i == 0 ) 
    {
        i = 1;
        UI.BG_BatteryLevel(1);
    }
    else if( i == 1 )
    {
        i = 0;
        UI.BG_BatteryLevel(0);
    }
}
/**
  *----------------------------------------------
  * @name   : Icon_BatteryLevel
  * @brief  : 电量显示
  * @param  : level -> 电量格数 0-3
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
void Icon_BatteryLevel(uint8_t level)
{
	
	const uint8_t Start_Row = 8;   // 起始行
	const uint8_t Start_Col = 7;   // 起始列	
	
	if( Sys.UI_Show_Mode != 0 ) return;	
	if( level > 3 ) return;
	OLED.ClearHorizonLine(Start_Row, Start_Col,14,5);
	switch (level)
	{
		case 0: 
			OLED.ClearHorizonLine(Start_Row, Start_Col,14,5);	
			break;
		
		case 1:
			OLED.DrawVerticalLine(Start_Row,Start_Col,4,4);
			break;
		
		case 2:
			OLED.DrawVerticalLine(Start_Row,Start_Col,4,4);
		    OLED.DrawVerticalLine(Start_Row,Start_Col+5,4,4);	
			break;
		
		case 3:
			OLED.DrawVerticalLine(Start_Row,Start_Col,4,4);
		    OLED.DrawVerticalLine(Start_Row,Start_Col+5,4,4);
			OLED.DrawVerticalLine(Start_Row,Start_Col+10,4,4);		
			break;
		
		default: break;
	}
}

/**
  *----------------------------------------------
  * @name   : Icon_MusicSwitch
  * @brief  : 音乐图标
  * @param  : sta -> 0关1开
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Icon_MusicSwitch(uint8_t sta)
{
	if( Sys.UI_Show_Mode != 0 ) return;		
	const uint8_t Start_Row = 3;   // 起始行
	const uint8_t Start_Col = 105;   // 起始列
	OLED.ClearHorizonLine(Start_Row, Start_Col, 16, 16);
	OLED.DrawVerticalLine(Start_Row, Start_Col+6, 3, 5); 	
	OLED.DrawVerticalLine(Start_Row+3, Start_Col+6, 6, 1);
	OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 7, 1);
	OLED.DrawVerticalLine(Start_Row+9, Start_Col+1, 5, 4);
	OLED.DrawVerticalLine(Start_Row+10, Start_Col, 2, 1);	
	//return;
    if( sta == 1 )
	{
		// 音乐2
	//	OLED.InsertAreaBMP_64Pix_128Pix(Start_Row, Start_Col, gImage_Music2, 16, 16 );		
		 //音乐开
        //20240815更新注射速度绑定音乐，PDL模式用音乐2，其他模式用音乐1
        if(Sys.InjectSpeed!=InjectSpeed_PDL)
            OLED.Drawchar_num(1, Start_Row+6, Start_Col+9); //写音乐下标1
        else
            OLED.Drawchar_num(2, Start_Row+6, Start_Col+10); //写音乐下标2
		
	}
	else
	{
        //20240815更新注射速度绑定音乐，PDL模式用音乐2，其他模式用音乐1
		if(Sys.InjectSpeed!=InjectSpeed_PDL)
            OLED.Drawchar_num(1, Start_Row+6, Start_Col+9); //写音乐下标1
        else
            OLED.Drawchar_num(2, Start_Row+6, Start_Col+10); //写音乐下标2
		// 音乐1
	//	OLED.InsertAreaBMP_64Pix_128Pix(Start_Row, Start_Col, gImage_Music1, 16, 16 );
		
		/* 音乐关*/
		OLED.DrawVerticalLine(Start_Row, Start_Col+6, 3, 5); 	
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+6, 6, 1);
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 7, 1);
		OLED.DrawVerticalLine(Start_Row+9, Start_Col+1, 5, 4);
		OLED.DrawVerticalLine(Start_Row+10, Start_Col, 2, 1);
		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+2, 2, 1);
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+3, 1, 2);
        OLED.DrawVerticalLine(Start_Row+5, Start_Col+4, 1, 3);
        OLED.DrawVerticalLine(Start_Row+6, Start_Col+5, 2, 3);
        OLED.DrawVerticalLine(Start_Row+7, Start_Col+8, 1, 1);		
        OLED.DrawVerticalLine(Start_Row+8, Start_Col+8, 1, 1);
	}
	
}


/**
  *----------------------------------------------
  * @name   : Icon_MusicStyle
  * @brief  : 音乐风格
  * @param  : param -> 1，2
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Icon_MusicStyle(uint8_t param)
{
	if( Sys.UI_Show_Mode != 0 ) return;		
	const uint8_t Start_Row = 3;   // 起始行
	const uint8_t Start_Col = 105;   // 起始列
	OLED.ClearHorizonLine(Start_Row, Start_Col, 16, 16);
	OLED.DrawVerticalLine(Start_Row, Start_Col+6, 3, 5); 	
	OLED.DrawVerticalLine(Start_Row+3, Start_Col+6, 6, 1);
	OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 7, 1);
	OLED.DrawVerticalLine(Start_Row+9, Start_Col+1, 5, 4);
	OLED.DrawVerticalLine(Start_Row+10, Start_Col, 2, 1);	
    if( param == 1 ) OLED.Drawchar_num(1, Start_Row+6, Start_Col+9);
	else OLED.Drawchar_num(2, Start_Row+6, Start_Col+9);	
}

/**
  *----------------------------------------------
  * @name   : Icon_SoundVolume
  * @brief  : 音量大小
  * @param  : sta -> 0小 1大
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Icon_SoundVolume(uint8_t sta)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
	const uint8_t Start_Row = 3;    // 起始行
	const uint8_t Start_Col = 74;   // 起始列	
	OLED.ClearHorizonLine(Start_Row, Start_Col, 13, 13);
    if( sta == 1 )
	{
		OLED.DrawVerticalLine(Start_Row+4, Start_Col, 6, 3);		
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+4, 10, 1);
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+5, 12, 1);		
		OLED.DrawVerticalLine(Start_Row+0, Start_Col+6, 14, 1);
		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+8, 1, 1);
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+9, 6, 1);	
		OLED.DrawVerticalLine(Start_Row+10, Start_Col+8, 1, 1);
		
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+10, 1, 1);
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+11, 1, 1);
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+12, 8, 1);
		OLED.DrawVerticalLine(Start_Row+11, Start_Col+11,1, 1);
		OLED.DrawVerticalLine(Start_Row+12, Start_Col+10, 1, 1);

	}
	else if( sta == 0)
	{
		OLED.DrawVerticalLine(Start_Row+4, Start_Col, 6, 3);		
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+4, 10, 1);
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+5, 12, 1);		
		OLED.DrawVerticalLine(Start_Row+0, Start_Col+6, 14, 1);
		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+8, 1, 1);
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+9, 6, 1);	
		OLED.DrawVerticalLine(Start_Row+10, Start_Col+8, 1, 1);		
	}
	
}


/**
  *----------------------------------------------
  * @name   : BG_InjectLock
  * @brief  : 注射锁背景
  * @param  : None
  * @retval : None
  * @note   : 不被改变的部分
  *----------------------------------------------
  */
static void BG_InjectLock(void)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
	const uint8_t Start_Row = 3;   // 起始行
	const uint8_t Start_Col = 41;   // 起始列	
	OLED.ClearHorizonLine(Start_Row, Start_Col,  18, 7);	
    OLED.DrawVerticalLine(Start_Row+6, Start_Col,  8, 11);
    OLED.ClearHorizonLine(Start_Row+13, Start_Col,  1, 1);
    OLED.ClearHorizonLine(Start_Row+13, Start_Col+10, 1, 1);
}


/**
  *----------------------------------------------
  * @name   : Icon_InjectLock
  * @brief  : 注射锁
  * @param  : None
  * @retval : None
  * @note   : 被改变的部分
  *----------------------------------------------
  */
static void Icon_InjectLock(uint8_t sta)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
	const uint8_t Start_Row = 3;   // 起始行
	const uint8_t Start_Col = 41;   // 起始列
	OLED.ClearHorizonLine(Start_Row, Start_Col,  18, 6);
    if( sta == 0 )
	{
	    OLED.DrawVerticalLine(Start_Row+3,  Start_Col+1,  3, 1);	
	    OLED.DrawVerticalLine(Start_Row+1,  Start_Col+2,  5, 1);
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+3,  3, 1);	
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+4,  2, 3);
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+7,  3, 1);
	    OLED.DrawVerticalLine(Start_Row+1,  Start_Col+8,  5, 1);
	    OLED.DrawVerticalLine(Start_Row+3,  Start_Col+9,  3, 1);
	}
	else if( sta == 1)
	{
	    OLED.DrawVerticalLine(Start_Row+3,  Start_Col+1+7,  3, 1);	
	    OLED.DrawVerticalLine(Start_Row+1,  Start_Col+2+7,  5, 1);
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+3+7,  3, 1);	
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+4+7,  2, 3);
	    OLED.DrawVerticalLine(Start_Row+0,  Start_Col+7+7,  3, 1);
	    OLED.DrawVerticalLine(Start_Row+1,  Start_Col+8+7,  5, 1);
	    OLED.DrawVerticalLine(Start_Row+3,  Start_Col+9+7,  3, 1);	
	}
}

/**
  *----------------------------------------------
  * @name   : BG_InjectBars
  * @brief  : 注射进度条框
  * @param  : None
  * @retval : None
  * @note   : 背景，不刷新
  *----------------------------------------------
  */
void BG_InjectBars(void)
{
   	const uint8_t Start_Col = 5;      // 列起始量
	const uint8_t Start_Row = 27;     // 行起始量 
	const uint8_t Long = 80;          // 长度   
	const uint8_t wide = 10;          // 宽度
	
	OLED.DrawHorizonLine(Start_Row, Start_Col, Long, wide);
	OLED.ClearHorizonLine(Start_Row+1, Start_Col+1, Long-2, wide-2);
}
/**
  *----------------------------------------------
  * @name   : Icon_InjectedBars
  * @brief  : 注射进度条
  * @param  : num -> 已注射剂量
  * @retval : None
  * @note   : 总长76格, 10段，6 + 8 * 8 + 6 = 76格
  *           总长76格，18段，4 * 7 + 5 * 4 + 4 * 7 = 76    18 - 11 11 - 8 7 - 1
  *----------------------------------------------
  */
static void Icon_InjectedBars(uint8_t n)
{
	if( Sys.UI_Show_Mode != 0 ) return;
	if( n < 0 || n > 18 ) return;
	const uint8_t Start_Col = 83;  // 起始列  从右向左填充
    const uint8_t Start_Row = 29;  // 起始行
	const uint8_t Wide = 6;
	
	// 总长76格，18段，4 * 7 + 5 * 4 + 4 * 7 = 76
	OLED.ClearHorizonLine(Start_Row, Start_Col-76, 76, Wide );
	if( n == 0 )   OLED.ClearHorizonLine(Start_Row, Start_Col-76, 76, Wide );
	else if( n > 0 && n <= 7 )  OLED.DrawHorizonLine(Start_Row, Start_Col - (n*4), n*4, Wide);  // 前7个4格
	else if( n > 7 && n <= 11 ) OLED.DrawHorizonLine(Start_Row, Start_Col+7-5*n, 5*n-7, Wide);  // 中4个5格
	else if( n > 11 && n <= 18 ) OLED.DrawHorizonLine(Start_Row, Start_Col-4-4*n, 4*n+4, Wide); // 后7个4格

	
// 总长76格, 10段，6 + 8 * 8 + 6 = 76格
//    if( n < 0 || n > 10 ) return;
//    const uint8_t Start_Col = 83;  // 起始列  从右向左填充
//    const uint8_t Start_Row = 29;  // 起始行
//    const uint8_t Wide = 6;       
//    const uint8_t Start_Pix = 6;   // 起始像素 
//    const uint8_t Middle_Pix = 8;  // 中间像素 
//    const uint8_t End_Pix = 6;     // 结尾像素 Pix = 6 + 8*8 +6 = 76
//    if( n == 0 )   	OLED.ClearHorizonLine(Start_Row, Start_Col-76, 76, Wide );
//    else if( n ==1 )  OLED.DrawHorizonLine(Start_Row, Start_Col - Start_Pix,  Start_Pix, Wide);  
//    else if( n > 1 && n < 10 ) OLED.DrawHorizonLine(Start_Row, Start_Col - 6 - (n-1)*Middle_Pix, Middle_Pix, Wide);
//    else if( n == 10 ) OLED.DrawHorizonLine(Start_Row, Start_Col - 76, End_Pix, Wide);
}

/**
  *----------------------------------------------
  * @name   : Icon_RestDose
  * @brief  : 已注射药量
  * @param  : num -> 1:1:17
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Icon_RestDose(uint8_t num)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
   	const uint8_t Start_Col = 90;      // 列起始量
	const uint8_t Start_Row = 49-21;     // 行起始量 
    if( num <= 0 ) num = 0;
    else if( num >= 18 ) num = 18;
	OLED.ClearHorizonLine(Start_Row, Start_Col,17,9);
	// "."
	OLED.DrawVerticalLine(Start_Row+7, Start_Col+7, 1, 1);
    OLED.Drawchar_num(num/10%10, Start_Row, Start_Col);
    OLED.Drawchar_num(num%10, Start_Row, Start_Col+10);
}


/**
  *----------------------------------------------
  * @name   : Icon_InjectArrow
  * @brief  : 注射方向箭头动态图标
  * @param  : dir -> 方向（0前1后）  num -> 数值012
  * @retval : None
  * @note   : 精度2格，一个周期4段
  *----------------------------------------------
  */
static void Icon_InjectArrow(uint8_t dir, uint8_t num)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
	static uint8_t perNum = 10;
	perNum = num;
	OLED.ClearHorizonLine(48, 4, 35, 12);
	OLED.ClearHorizonLine(48, 4, 35, 12);
	if( dir == MOTOR_DIR_FORWARD  )    // 前进
	{
		if( num == 0 )  //　状态0
		{
			for( uint8_t i = 0; i < 4; i++)
			{
                OLED.DrawVerticalLine(53, 5+i*8,  1, 1);
                OLED.DrawVerticalLine(52, 6+i*8,  3, 1);
                OLED.DrawVerticalLine(52, 7+i*8,  3, 1);
                OLED.DrawVerticalLine(51, 8+i*8,  5, 1);
                OLED.DrawVerticalLine(51, 9+i*8,  5, 1);
                OLED.DrawVerticalLine(50, 10+i*8, 7, 1);
                OLED.DrawVerticalLine(50, 11+i*8, 7, 1);
                OLED.DrawVerticalLine(49, 12+i*8, 9, 1);			
			}
		}
		else if( num == 1) // 状态1 左移两格
		{
			for( uint8_t i = 0; i < 4; i++)
			{
                OLED.DrawVerticalLine(53, 5+i*8-2,  1, 1);
                OLED.DrawVerticalLine(52, 6+i*8-2,  3, 1);
                OLED.DrawVerticalLine(52, 7+i*8-2,  3, 1);
                OLED.DrawVerticalLine(51, 8+i*8-2,  5, 1);
                OLED.DrawVerticalLine(51, 9+i*8-2,  5, 1);
                OLED.DrawVerticalLine(50, 10+i*8-2, 7, 1);
                OLED.DrawVerticalLine(50, 11+i*8-2, 7, 1);
                OLED.DrawVerticalLine(49, 12+i*8-2, 9, 1);			
			}
            OLED.ClearHorizonLine(51, 3, 2, 5);	
            OLED.ClearHorizonLine(51, 3, 2, 5);				
		    OLED.DrawVerticalLine(53, 35, 1, 1);		
		    OLED.DrawVerticalLine(52, 36, 3, 1);		
		}
		else if( num == 2  ) // 状态2 左移4格
		{
			for( uint8_t i = 0; i < 4; i++)
			{
                OLED.DrawVerticalLine(53, 5+i*8-2-2,  1, 1);
                OLED.DrawVerticalLine(52, 6+i*8-2-2,  3, 1);
                OLED.DrawVerticalLine(52, 7+i*8-2-2,  3, 1);
                OLED.DrawVerticalLine(51, 8+i*8-2-2,  5, 1);
                OLED.DrawVerticalLine(51, 9+i*8-2-2,  5, 1);
                OLED.DrawVerticalLine(50, 10+i*8-2-2, 7, 1);
                OLED.DrawVerticalLine(50, 11+i*8-2-2, 7, 1);
                OLED.DrawVerticalLine(49, 12+i*8-2-2, 9, 1);			
			}
            OLED.ClearHorizonLine(51, 1, 4, 5);	
            OLED.ClearHorizonLine(51, 1, 4, 5);				
		    OLED.DrawVerticalLine(53, 33, 1, 1);		
		    OLED.DrawVerticalLine(52, 34, 3, 1);
		    OLED.DrawVerticalLine(52, 35, 3, 1);			           			
		    OLED.DrawVerticalLine(51, 36, 5, 1);		
		}	
		else if( num == 3  ) // 状态3 左移6格
		{
			for( uint8_t i = 0; i < 4; i++)
			{
                OLED.DrawVerticalLine(53, 7+i*8,  1, 1);
                OLED.DrawVerticalLine(52, 8+i*8,  3, 1);
                OLED.DrawVerticalLine(52, 9+i*8,  3, 1);
                OLED.DrawVerticalLine(51, 10+i*8,  5, 1);
                OLED.DrawVerticalLine(51, 11+i*8,  5, 1);
                OLED.DrawVerticalLine(50, 12+i*8,  7, 1);
                OLED.DrawVerticalLine(50, 13+i*8, 7, 1);
                OLED.DrawVerticalLine(49, 14+i*8, 9, 1);			
			}
			OLED.ClearHorizonLine(49, 37, 5,9);
			OLED.ClearHorizonLine(49, 37, 5,9);			
		    OLED.DrawVerticalLine(50, 5, 7, 1);	
		    OLED.DrawVerticalLine(49, 6, 9, 1);	
		}
	}
	else
	{
	    if( num == 0 )
		{
			for( uint8_t i = 0; i < 4; i++)
			{
			    OLED.DrawVerticalLine(49, 5+i*8,  9, 1);
                OLED.DrawVerticalLine(50, 6+i*8,  7, 1);
                OLED.DrawVerticalLine(50, 7+i*8,  7, 1);
                OLED.DrawVerticalLine(51, 8+i*8,  5, 1);
                OLED.DrawVerticalLine(51, 9+i*8,  5, 1);
                OLED.DrawVerticalLine(52, 10+i*8, 3, 1);
                OLED.DrawVerticalLine(52, 11+i*8, 3, 1);
                OLED.DrawVerticalLine(53, 12+i*8, 1, 1);			
			}			
		}
		else if( num == 1 )
		{
			for( uint8_t i = 0; i < 4; i++)
			{
			    OLED.DrawVerticalLine(49, 5+i*8+2,  9, 1);
                OLED.DrawVerticalLine(50, 6+i*8+2,  7, 1);
                OLED.DrawVerticalLine(50, 7+i*8+2,  7, 1);
                OLED.DrawVerticalLine(51, 8+i*8+2,  5, 1);
                OLED.DrawVerticalLine(51, 9+i*8+2,  5, 1);
                OLED.DrawVerticalLine(52, 10+i*8+2, 3, 1);
                OLED.DrawVerticalLine(52, 11+i*8+2, 3, 1);
                OLED.DrawVerticalLine(53, 12+i*8+2, 1, 1);			
			}	
            OLED.DrawVerticalLine(52, 5, 3, 1);
			OLED.DrawVerticalLine(53, 6, 1, 1);
			OLED.ClearHorizonLine(48, 36, 5,10);	
		    OLED.ClearHorizonLine(48, 36, 5,10);	
		}
		else if( num == 2 )
		{
			for( uint8_t i = 0; i < 4; i++)
			{
			    OLED.DrawVerticalLine(49, 9+i*8,  9, 1);
                OLED.DrawVerticalLine(50, 10+i*8, 7, 1);
                OLED.DrawVerticalLine(50, 11+i*8, 7, 1);
                OLED.DrawVerticalLine(51, 12+i*8, 5, 1);
                OLED.DrawVerticalLine(51, 13+i*8, 5, 1);
                OLED.DrawVerticalLine(52, 14+i*8, 3, 1);
                OLED.DrawVerticalLine(52, 15+i*8, 3, 1);
                OLED.DrawVerticalLine(53, 16+i*8, 1, 1);			
			}
			OLED.ClearHorizonLine(48, 37, 5, 12);
			OLED.ClearHorizonLine(48, 37, 5, 12);			
            OLED.DrawVerticalLine(51, 5, 5, 1);
            OLED.DrawVerticalLine(52, 6, 3, 1);
			OLED.DrawVerticalLine(52, 7, 3, 1);
			OLED.DrawVerticalLine(53, 8, 1, 1);			
		}
		else if( num == 3 )
		{
			for( uint8_t i = 0; i < 4; i++)
			{
			    OLED.DrawVerticalLine(49, 3+i*8,  9, 1);
                OLED.DrawVerticalLine(50, 4+i*8,  7, 1);
                OLED.DrawVerticalLine(50, 5+i*8,  7, 1);
                OLED.DrawVerticalLine(51, 6+i*8,  5, 1);
                OLED.DrawVerticalLine(51, 7+i*8,  5, 1);
                OLED.DrawVerticalLine(52, 8+i*8,  3, 1);
                OLED.DrawVerticalLine(52, 9+i*8,  3, 1);
                OLED.DrawVerticalLine(53, 10+i*8, 1, 1);			
			}
			OLED.ClearHorizonLine(48, 2, 3,12);			
			OLED.ClearHorizonLine(48, 2, 3,12);				
            OLED.DrawVerticalLine(49, 35, 9, 1);
            OLED.DrawVerticalLine(50, 36, 7, 1);
		}
			
	
	}
}

/**
  *----------------------------------------------
  * @name   : Icon_InjectArrow2
  * @brief  : 注射箭头样式2
  * @param  : dir -> 方向（0前1后）  num -> 数值01234 5到达匀速时显示，只有方向0时有效
  * @retval : None
  * @note   : 精度2格，一个周期4段
  *----------------------------------------------
  */
static void Icon_InjectArrow2(uint8_t dir, uint8_t num)
{
	if( Sys.UI_Show_Mode != 0 ) return;	
	const uint8_t Start_Row = 47;   // 起始行
	const uint8_t Start_Col = 6;   // 起始列	
	if( dir == 0 )
	{
		if( num == 1 )
		{
			SolidArrow(0, Start_Row, Start_Col+24 );
			HollowArrow(0, Start_Row, Start_Col+16 );
			HollowArrow(0, Start_Row, Start_Col+8 ); 
			HollowArrow(0, Start_Row, Start_Col );
		}		
		else if( num == 2 )
		{
			SolidArrow(0, Start_Row, Start_Col+24 );
			SolidArrow(0, Start_Row, Start_Col+16 );
			HollowArrow(0, Start_Row, Start_Col+8 );
			HollowArrow(0, Start_Row, Start_Col );
		}
		else if( num == 3 )
		{
			HollowArrow(0, Start_Row, Start_Col+24 ); 
			SolidArrow(0, Start_Row, Start_Col+16 ); 
			SolidArrow(0, Start_Row, Start_Col+8 );
			HollowArrow(0, Start_Row, Start_Col );			
		}
		else if( num == 4 )
		{
			HollowArrow(0, Start_Row, Start_Col+24 );
			HollowArrow(0, Start_Row, Start_Col+16 );
			SolidArrow(0, Start_Row, Start_Col+8 );
			SolidArrow(0, Start_Row, Start_Col );			
		}
		else if( num == 5 )
		{			
			HollowArrow(0, Start_Row, Start_Col+24 );
			HollowArrow(0, Start_Row, Start_Col+16 );
			HollowArrow(0, Start_Row, Start_Col+8 );
			SolidArrow(0, Start_Row, Start_Col );			
		}			
		else if( num == 6 )
		{			
			SolidArrow(0, Start_Row, Start_Col+24 );
			HollowArrow(0, Start_Row, Start_Col+16 );
			HollowArrow(0, Start_Row, Start_Col+8 );
			SolidArrow(0, Start_Row, Start_Col );			
		}	


		
		else if( num == 0 )
		{
			HollowArrow(0, Start_Row, Start_Col+24 );
			HollowArrow(0, Start_Row, Start_Col+16 );
			HollowArrow(0, Start_Row, Start_Col+8 );
			HollowArrow(0, Start_Row, Start_Col );			
		}
		else if( num == 7)  // 达到匀速时显示
		{
			SolidArrow(0, Start_Row, Start_Col+24 );
			SolidArrow(0, Start_Row, Start_Col+16 );
			SolidArrow(0, Start_Row, Start_Col+8 );
			SolidArrow(0, Start_Row, Start_Col );
		}
	}
	else if( dir == 1)
	{
		if( num == 1 )
		{
			HollowArrow(1, Start_Row, Start_Col+24 );
			HollowArrow(1, Start_Row, Start_Col+16 );
			HollowArrow(1, Start_Row, Start_Col+8 );
			SolidArrow(1, Start_Row, Start_Col );			
		}
		else if( num == 2 )
		{
			HollowArrow(1, Start_Row, Start_Col+24 );
			HollowArrow(1, Start_Row, Start_Col+16 );
			SolidArrow(1, Start_Row, Start_Col+8 );
			SolidArrow(1, Start_Row, Start_Col );			
		}
		else if( num == 3 )
		{
			HollowArrow(1, Start_Row, Start_Col+24 );
			SolidArrow(1, Start_Row, Start_Col+16 );
			SolidArrow(1, Start_Row, Start_Col+8 );
			HollowArrow(1, Start_Row, Start_Col );			
		}
		else if( num == 4 )
		{			
			SolidArrow(1, Start_Row, Start_Col+24 );
			SolidArrow(1, Start_Row, Start_Col+16 );
			HollowArrow(1, Start_Row, Start_Col+8 );
			HollowArrow(1, Start_Row, Start_Col );			
		}
		else if( num == 5 )
		{			
			SolidArrow(1, Start_Row, Start_Col+24 );
			HollowArrow(1, Start_Row, Start_Col+16 );
			HollowArrow(1, Start_Row, Start_Col+8 );
			HollowArrow(1, Start_Row, Start_Col );			
		}
		else if( num == 6 )
		{			
			HollowArrow(1, Start_Row, Start_Col+24 );
			HollowArrow(1, Start_Row, Start_Col+16 );
			HollowArrow(1, Start_Row, Start_Col+8 );
			SolidArrow(1, Start_Row, Start_Col );			
		}				
		else if( num == 0 )
		{			
			HollowArrow(1, Start_Row, Start_Col+24 );
			HollowArrow(1, Start_Row, Start_Col+16 );
			HollowArrow(1, Start_Row, Start_Col+8 );
			HollowArrow(1, Start_Row, Start_Col );			
		}			
	}
	
	
	
}

// 空心箭头
static void HollowArrow(uint8_t dir, uint8_t i, uint8_t j)
{
	const uint8_t Start_Row = i;   // 起始行
	const uint8_t Start_Col = j;   // 起始列	
	OLED.ClearHorizonLine(Start_Row, Start_Col, 7, 13);	
	if( dir == 0) // 前进
	{
		OLED.DrawVerticalLine(Start_Row+6, Start_Col, 1, 1);
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+1, 1, 1);
		OLED.DrawVerticalLine(Start_Row+7, Start_Col+1, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+2, 1, 1);
		OLED.DrawVerticalLine(Start_Row+8, Start_Col+2, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+3, 1, 1);
		OLED.DrawVerticalLine(Start_Row+9, Start_Col+3, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+4, 1, 1);
		OLED.DrawVerticalLine(Start_Row+10, Start_Col+4, 1, 1);			
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+5, 11, 1);
	}
	else if( dir == 1 )
	{
		OLED.DrawVerticalLine(Start_Row+6, Start_Col+6, 1, 1);
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 1, 1);
		OLED.DrawVerticalLine(Start_Row+7, Start_Col+5, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+4, 1, 1);
		OLED.DrawVerticalLine(Start_Row+8, Start_Col+4, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+3, 1, 1);
		OLED.DrawVerticalLine(Start_Row+9, Start_Col+3, 1, 1);		
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+2, 1, 1);
		OLED.DrawVerticalLine(Start_Row+10, Start_Col+2, 1, 1);			
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+1, 11, 1);		
	}
}

// 实心箭头
static void SolidArrow(uint8_t dir, uint8_t i, uint8_t j)
{
	const uint8_t Start_Row = i;   // 起始行
	const uint8_t Start_Col = j;   // 起始列	
	OLED.ClearHorizonLine(Start_Row, Start_Col, 7, 13);	
	if( dir == 0) // 前进
	{
		OLED.DrawVerticalLine(Start_Row+6, Start_Col, 1, 1);
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+1, 3, 1);	
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+2, 5, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+3, 7, 1);		
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+4, 9, 1);		
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+5, 11, 1);				
	}
	else if( dir == 1 )
	{
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+1, 11, 1);	
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+2, 9, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+3, 7, 1);		
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+4, 5, 1);		
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 3, 1);		
		OLED.DrawVerticalLine(Start_Row+6, Start_Col+6, 1, 1);			
	}
}

// 小实心箭头
static void SolidArrow2(uint8_t dir, uint8_t i, uint8_t j)
{
	const uint8_t Start_Row = i;   // 起始行
	const uint8_t Start_Col = j;   // 起始列	
	OLED.ClearHorizonLine(Start_Row, Start_Col, 7, 13);	
	if( dir == 0) // 前进
	{
		OLED.DrawVerticalLine(Start_Row+6, Start_Col+1, 1, 1);
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+2, 3, 1);	
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+3, 5, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+4, 7, 1);					
	}
	else if( dir == 1 )
	{
		OLED.DrawVerticalLine(Start_Row+1, Start_Col+1, 11, 1);	
		OLED.DrawVerticalLine(Start_Row+2, Start_Col+2, 9, 1);		
		OLED.DrawVerticalLine(Start_Row+3, Start_Col+3, 7, 1);		
		OLED.DrawVerticalLine(Start_Row+4, Start_Col+4, 5, 1);		
		OLED.DrawVerticalLine(Start_Row+5, Start_Col+5, 3, 1);		
		OLED.DrawVerticalLine(Start_Row+6, Start_Col+6, 1, 1);			
	}
}

/**
  *----------------------------------------------
  * @name   : Icon_InjectDose
  * @brief  : 设定的注射药量
  * @param  : num -> 档位
  * @retval : None
  * @note   : 0.1ml,0.3ml,0.6ml,0.9ml,1.7ml    
  *----------------------------------------------
  */
static void Icon_InjectDose(uint8_t val)
{
	const int8_t Start_Col = -2;     // 列偏移量
//	const int8_t Start_Row = 0;      // 行偏移量
	const int8_t Start_Row = 21;
	
	OLED.ClearHorizonLine(26+Start_Row,91+Start_Col,18,16);
    
	// "."
	OLED.DrawVerticalLine(35+Start_Row, 99+Start_Col, 1, 1);	
	
    if( val == InjectDose_01mL ){
		// "0"
		OLED.Drawchar_num(0, 28+Start_Row, 92+Start_Col);			
		// "1"
		OLED.Drawchar_num(1, 28+Start_Row, 102+Start_Col);
		
	}
	else if( val == InjectDose_03mL ){
		// "0"
		OLED.Drawchar_num(0, 28+Start_Row, 92+Start_Col);
        // "3"
		OLED.Drawchar_num(3, 28+Start_Row, 102+Start_Col);	
	}
	else if( val == InjectDose_06mL ){
		// "0"
		OLED.Drawchar_num(0, 28+Start_Row, 92+Start_Col);

        // "6"
		OLED.Drawchar_num(6, 28+Start_Row, 102+Start_Col);		
	}
	else if( val == InjectDose_09mL ){
		// "0"
		OLED.Drawchar_num(0, 28+Start_Row, 92+Start_Col);
		// "."
	//	OLED.DrawVerticalLine(67-10, 99, 1, 1);		
		// "9"
		OLED.Drawchar_num(9, 28+Start_Row, 102+Start_Col);
	}
	else if( val == InjectDose_17mL ){
		// "1"
		OLED.Drawchar_num(1, 28+Start_Row, 92+Start_Col);
        // "8"		
		OLED.Drawchar_num(7, 28+Start_Row, 102+Start_Col);		
	}
	else if( val == InjectDose_18mL ){
		// "1"
		OLED.Drawchar_num(1, 28+Start_Row, 92+Start_Col);
        // "8"		
		OLED.Drawchar_num(8, 28+Start_Row, 102+Start_Col);		
	}
}



/**
  *----------------------------------------------
  * @name   : Icon_InjectSpeed
  * @brief  : 设置注射速度
  * @param  : num -> 1低 2中 3高 4PDL 
  * @retval : None
  * @note   : 绘制 'High'  'Mid'  'Low' 'PDL'
            : 绘制   快 中 慢 PDL
  *----------------------------------------------
  */
static void Icon_InjectSpeed(uint8_t val)
{
	const uint8_t Start_Row = 43;    // 起始行
	const uint8_t Start_Col = 44;    // 起始列
	
	OLED.ClearHorizonLine(Start_Row, Start_Col, 40, 18);
	if( val == InjectSpeed_High ){

		
#ifdef VER_CN		
	  // 中文 “快”
		OLED.DrawVerticalLine(Start_Row+8-2, Start_Col+13, 4, 1);
		OLED.DrawVerticalLine(Start_Row+5-2, Start_Col+15, 12, 1);	
		OLED.DrawVerticalLine(Start_Row+8-2, Start_Col+16, 1, 1);		
		OLED.DrawHorizonLine(Start_Row+7-2, Start_Col+18, 6, 1);			
		OLED.DrawVerticalLine(Start_Row+5-2, Start_Col+20, 8, 1);
		OLED.DrawVerticalLine(Start_Row+7-2, Start_Col+23, 4, 1);
		OLED.DrawHorizonLine(Start_Row+11-2, Start_Col+17, 8, 1);		
		OLED.DrawVerticalLine(Start_Row+13-2, Start_Col+19, 2, 1);	
		OLED.DrawVerticalLine(Start_Row+13-2, Start_Col+21, 2, 1);
		OLED.DrawVerticalLine(Start_Row+15-2, Start_Col+18, 1, 1);
		OLED.DrawVerticalLine(Start_Row+15-2, Start_Col+22, 1, 1);
		OLED.DrawVerticalLine(Start_Row+16-2, Start_Col+17, 1, 1);
		OLED.DrawVerticalLine(Start_Row+16-2, Start_Col+23, 1, 2);	
#else
		// 'H'
        OLED.DrawHorizonLine(Start_Row+5-1, Start_Col-1+6, 3, 1);
        OLED.DrawHorizonLine(Start_Row+5-1, Start_Col-1+10, 3, 1);
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+6, 3, 1);
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+10, 3, 1);
        OLED.DrawHorizonLine(Start_Row+10-1, Start_Col-1+8, 3, 1);
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+7, 10, 1);	
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+11, 10, 1);
       
		// 'i'
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+16, 2, 1);	
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+15, 1, 2);		    
        OLED.DrawVerticalLine(Start_Row+10-1, Start_Col-1+16, 5, 1);	
        OLED.DrawVerticalLine(Start_Row+15-1, Start_Col-1+15, 1, 3);
		
		// 'g'
        OLED.DrawHorizonLine(Start_Row+8-1, Start_Col-1+22, 3, 1);
        OLED.DrawHorizonLine(Start_Row+8-1, Start_Col-1+26, 1, 1); 
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+21, 3, 1);	
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+25, 2, 1);	
        OLED.DrawHorizonLine(Start_Row+11-1, Start_Col-1+21, 4, 1);		
        OLED.DrawHorizonLine(Start_Row+12-1, Start_Col-1+20, 1, 1);	
        OLED.DrawHorizonLine(Start_Row+13-1, Start_Col-1+21, 5, 1);	
        OLED.DrawVerticalLine(Start_Row+14-1, Start_Col-1+20, 2, 1);	
        OLED.DrawVerticalLine(Start_Row+14-1, Start_Col-1+26, 2, 1);
        OLED.DrawHorizonLine(Start_Row+16-1, Start_Col-1+21, 5, 1);	

        // 'h'
        OLED.DrawHorizonLine(Start_Row+5-1, Start_Col-1+29, 2, 1);	
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+30, 10, 1);			
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+29, 3, 1);
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+33, 3, 1);
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+31, 1, 1);	
        OLED.DrawHorizonLine(Start_Row+8-1, Start_Col-1+32, 2, 1);	
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+34, 6, 1);
#endif		
		
		
	}
	else if( val == InjectSpeed_Low )
    {
#ifdef 	VER_CN	
	  // 中文“慢”
		OLED.DrawVerticalLine(Start_Row+8-2, Start_Col+13, 4, 1);
		OLED.DrawVerticalLine(Start_Row+6-2, Start_Col+15, 12, 1);	
		OLED.DrawVerticalLine(Start_Row+8-2, Start_Col+16, 1, 1);

 		OLED.DrawVerticalLine(Start_Row+6-2, Start_Col+18, 4, 5);  
		OLED.ClearHorizonLine(Start_Row+7-2, Start_Col+19, 3, 1);
		OLED.ClearHorizonLine(Start_Row+9-2, Start_Col+19, 3, 1);
		
 		OLED.DrawVerticalLine(Start_Row+10-2, Start_Col+17, 3, 7);
		OLED.ClearHorizonLine(Start_Row+11-2, Start_Col+18, 1, 1);
		OLED.ClearHorizonLine(Start_Row+11-2, Start_Col+20, 1, 1);		
		OLED.ClearHorizonLine(Start_Row+11-2, Start_Col+22, 1, 1);

 		OLED.DrawVerticalLine(Start_Row+14-2, Start_Col+17, 1, 6);
 		OLED.DrawVerticalLine(Start_Row+15-2, Start_Col+18, 1, 1);
 		OLED.DrawVerticalLine(Start_Row+15-2, Start_Col+22, 1, 1);
 		OLED.DrawVerticalLine(Start_Row+16-2, Start_Col+19, 1, 3);
 		OLED.DrawVerticalLine(Start_Row+17-2, Start_Col+17, 1, 2);
 		OLED.DrawVerticalLine(Start_Row+17-2, Start_Col+22, 1, 2);	
#else
        // "L"
        OLED.DrawHorizonLine(Start_Row+5-1, Start_Col-1+8+1, 3, 1);	
        OLED.DrawVerticalLine(Start_Row+6-1, Start_Col-1+9+1, 9, 1);	
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+8+1, 6, 1);
        OLED.DrawHorizonLine(Start_Row+14-1, Start_Col-1+14+1, 1, 1);	

        // 'o'
        OLED.DrawVerticalLine(Start_Row+10-1, Start_Col-1+17+1, 4, 1);			
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+18+1, 1, 1);
        OLED.DrawVerticalLine(Start_Row+14-1, Start_Col-1+18+1, 1, 1);
        OLED.DrawHorizonLine( Start_Row+8-1, Start_Col-1+19+1, 3, 1);	
        OLED.DrawHorizonLine( Start_Row+15-1, Start_Col-1+19+1, 3, 1);	
        OLED.DrawVerticalLine( Start_Row+9-1, Start_Col-1+22+1, 1, 1);
        OLED.DrawVerticalLine(Start_Row+14-1, Start_Col-1+22+1, 1, 1);
        OLED.DrawVerticalLine(Start_Row+10-1, Start_Col-1+23+1, 4, 1);	
     
		// 'w'
        OLED.DrawVerticalLine( Start_Row+8-1, Start_Col-1+26+1, 5, 1);
        OLED.DrawVerticalLine(Start_Row+13-1, Start_Col-1+27+1, 3, 1);	
        OLED.DrawVerticalLine(Start_Row+11-1, Start_Col-1+28+1, 2, 1);	
        OLED.DrawVerticalLine( Start_Row+8-1, Start_Col-1+29+1, 3, 1);
        OLED.DrawVerticalLine(Start_Row+11-1, Start_Col-1+30+1, 2, 1);
        OLED.DrawVerticalLine(Start_Row+13-1, Start_Col-1+31+1, 3, 1);		
        OLED.DrawVerticalLine( Start_Row+8-1, Start_Col-1+32+1, 5, 1);
#endif
	}
	else if( val == InjectSpeed_Mid )
	{
		
#ifdef 	VER_CN			
	  // 中文“中”		
        OLED.DrawVerticalLine(Start_Row+8-1, Start_Col+16-1, 6, 1);
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col+20-1, 12, 1);	
        OLED.DrawVerticalLine(Start_Row+8-1, Start_Col+24-1, 6, 1);
        OLED.DrawHorizonLine(Start_Row+8-1, Start_Col+16-1, 9, 1);
        OLED.DrawHorizonLine(Start_Row+12-1, Start_Col+16-1, 9, 1);		
#else
		// "M"
        OLED.DrawHorizonLine( Start_Row+4,  Start_Col-1+7,  3, 1);		
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col-1+8,  9, 1);
        OLED.DrawHorizonLine(Start_Row+14,  Start_Col-1+7,  3, 1);
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col-1+9,  2, 1);		
        OLED.DrawVerticalLine(Start_Row+6,  Start_Col-1+10, 4, 1);		
        OLED.DrawVerticalLine(Start_Row+10, Start_Col-1+11, 3, 1);		
        OLED.DrawVerticalLine(Start_Row+13, Start_Col-1+12, 2, 1);
        OLED.DrawVerticalLine(Start_Row+10, Start_Col-1+13, 3, 1);
        OLED.DrawVerticalLine(Start_Row+6,  Start_Col-1+14, 4, 1);	
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col-1+15, 2, 1);
        OLED.DrawHorizonLine(Start_Row+14,  Start_Col-1+15, 3, 1);
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col-1+16, 9, 1);		
        OLED.DrawHorizonLine(Start_Row+4,   Start_Col-1+15, 3, 1);

		// 'i'
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+21+1, 2, 1);	
        OLED.DrawVerticalLine(Start_Row+9-1, Start_Col-1+20+1, 1, 2);		    
        OLED.DrawVerticalLine(Start_Row+10-1, Start_Col-1+21+1, 5, 1);	
        OLED.DrawVerticalLine(Start_Row+15-1, Start_Col-1+20+1, 1, 3);
		
		// 'd'
        OLED.DrawVerticalLine(Start_Row+11-1, Start_Col-1+26+1, 3, 1);
        OLED.DrawVerticalLine(Start_Row+10-1, Start_Col-1+27+1, 1, 1);
        OLED.DrawVerticalLine(Start_Row+14-1, Start_Col-1+27+1, 1, 1);
        OLED.DrawHorizonLine(Start_Row+9-1, Start_Col-1+28+1, 3, 1);
        OLED.DrawHorizonLine(Start_Row+15-1, Start_Col-1+28+1, 2, 1);	
        OLED.DrawHorizonLine(Start_Row+14-1, Start_Col-1+30+1, 1, 1);			
        OLED.DrawHorizonLine(Start_Row+5-1, Start_Col-1+30+1, 1, 1);	
        OLED.DrawVerticalLine(Start_Row+5-1, Start_Col-1+31+1, 11, 1);	
        OLED.DrawVerticalLine(Start_Row+15-1, Start_Col-1+32+1, 1, 1);

#endif

	}
    
    else if( val == InjectSpeed_PDL )
    {
        // "P"
        OLED.DrawHorizonLine( Start_Row+4,  Start_Col+8, 6, 1);        
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col+9, 9, 1);
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col+14, 4, 1);        
        OLED.DrawHorizonLine( Start_Row+9,  Start_Col+10, 4, 1);
        OLED.DrawHorizonLine( Start_Row+14,  Start_Col+8, 3, 1);                
        // "D"                
        OLED.DrawHorizonLine( Start_Row+4,  Start_Col+17, 5, 1);
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col+18, 9, 1);
        OLED.DrawHorizonLine( Start_Row+14,  Start_Col+17, 5, 1);        
        OLED.DrawHorizonLine( Start_Row+5,  Start_Col+22, 1, 1);
        OLED.DrawHorizonLine( Start_Row+13,  Start_Col+22, 1, 1);        
        OLED.DrawVerticalLine(Start_Row+6,  Start_Col+23, 7, 1);                
        // "L"        
        OLED.DrawHorizonLine( Start_Row+4,  Start_Col+27, 3, 1);                
        OLED.DrawVerticalLine(Start_Row+5,  Start_Col+28, 9, 1);        
        OLED.DrawHorizonLine( Start_Row+13,  Start_Col+33, 1, 1);                        
        OLED.DrawHorizonLine( Start_Row+14,  Start_Col+27, 7, 1);        
        
    }
}



/**
  *----------------------------------------------
  * @name   : Background_Char_mL
  * @brief  : 字符mL
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void Background_Char_mL(void)
{
	const uint8_t Start_Row = 30;    // 起始行
	const uint8_t Start_Col = 107;   // 起始列	
	const uint8_t Start_Row_2 = Start_Row - 3;    // 起始行
	const uint8_t Start_Col_2 = Start_Col + 11;   // 起始列	

	const uint8_t Start_Row_3 = 51;    // 起始行
	const uint8_t Start_Col_3 = 107;   // 起始列	
	const uint8_t Start_Row_4 = Start_Row_3 - 3;    // 起始行
	const uint8_t Start_Col_4 = Start_Col_3 + 11;   // 起始列		
	
	// 'm'
	OLED.DrawVerticalLine(Start_Row,   Start_Col,   6, 9);
	OLED.ClearHorizonLine(Start_Row,   Start_Col+1, 1, 1);
	OLED.ClearHorizonLine(Start_Row+2, Start_Col+1, 1, 4);
	OLED.ClearHorizonLine(Start_Row+1, Start_Col+2, 2, 5);
	OLED.ClearHorizonLine(Start_Row,   Start_Col+4, 2, 1);
	OLED.ClearHorizonLine(Start_Row+2, Start_Col+5, 1, 4);	
	OLED.ClearHorizonLine(Start_Row+1, Start_Col+6, 2, 5);		
	OLED.ClearHorizonLine(Start_Row,   Start_Col+8, 1, 1);	
	
	// 'L'
	OLED.DrawVerticalLine(Start_Row_2, Start_Col_2,   9, 5);
	OLED.ClearHorizonLine(Start_Row_2, Start_Col_2+1, 4, 8);
	
	// 'm'
	OLED.DrawVerticalLine(Start_Row_3,   Start_Col_3,   6, 9);
	OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+1, 1, 1);
	OLED.ClearHorizonLine(Start_Row_3+2, Start_Col_3+1, 1, 4);
	OLED.ClearHorizonLine(Start_Row_3+1, Start_Col_3+2, 2, 5);
	OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+4, 2, 1);
	OLED.ClearHorizonLine(Start_Row_3+2, Start_Col_3+5, 1, 4);	
	OLED.ClearHorizonLine(Start_Row_3+1, Start_Col_3+6, 2, 5);		
	OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+8, 1, 1);	
	
	// 'L'
	OLED.DrawVerticalLine(Start_Row_4, Start_Col_4,   9, 5);
	OLED.ClearHorizonLine(Start_Row_4, Start_Col_4+1, 4, 8);	
}

/**
  *----------------------------------------------
  * @name   : ShutdownCartoon
  * @brief  : 关机动画
  * @param  : None
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static void ShutdownCartoon(void)
{


}


/**
  *----------------------------------------------
  * @name   : Resistance_Feedback
  * @brief  : 阻力反馈UI
  * @param  : PressureLevel 阻力反馈数值
  * @retval : None
  * @note   : 将阻力具现化为三个档位
  *----------------------------------------------
  */
static void Resistance_Feedback(uint16_t Pressure)
{
    uint8_t PressureLevel = 0;
    OLED.ClearHorizonLine(43,85,43,21);
    /*F*/
    OLED.DrawHorizonLine(47,90,8,1);
    OLED.DrawHorizonLine(52,92,6,1);
    OLED.DrawVerticalLine(47,92,12,1);
    
    /*一号砖方框*/
    OLED.DrawVerticalLine(55,103,4,1);
    OLED.DrawHorizonLine(55,103,4,1);
    OLED.DrawVerticalLine(55,106,4,1);
    OLED.DrawHorizonLine(59,103,4,1);
    
    
    /*二号砖方框*/
    OLED.DrawVerticalLine(51,110,8,1);
    OLED.DrawHorizonLine(51,110,4,1);
    OLED.DrawVerticalLine(51,113,8,1);
    OLED.DrawHorizonLine(59,110,4,1);
    
    
    /*三号砖方框*/
    OLED.DrawVerticalLine(47,117,12,1);
    OLED.DrawHorizonLine(47,117,4,1);
    OLED.DrawVerticalLine(47,120,12,1);
    OLED.DrawHorizonLine(59,117,4,1);
    if(Pressure<40)
        PressureLevel = 0;
    else if(Pressure<65&&Pressure>=40)
        PressureLevel = 1;
    else if(Pressure>=65&&Pressure<121)
        PressureLevel = 2;
    else
        PressureLevel = 3;
        
    
    switch(PressureLevel)
    {
        case 0: break;
        
        case 1: OLED.DrawVerticalLine(55,103,4,3);//填充，将方框变成实心的
        break;
        
        case 2: OLED.DrawVerticalLine(55,103,4,3);//填充，将方框变成实心的
                OLED.DrawVerticalLine(51,110,8,3);//填充，将方框变成实心的
        break;
        
        case 3: OLED.DrawVerticalLine(55,103,4,3);//填充，将方框变成实心的
                OLED.DrawVerticalLine(51,110,8,3);//填充，将方框变成实心的
                OLED.DrawVerticalLine(47,117,12,3);//填充，将方框变成实心的
        break;
        
        default:break;
    }
    

}



/**
  *----------------------------------------------
  * @name   : PDL_Or_NOPDL
  * @brief  : PDL模式工作状态下右下角显示以及非PDL模式的右下角显示
  * @param  : 
  * @retval : None
  * @note   : PDL模式工作状态右下角显示阻力反馈，非PDL模式显示设定注射量
  *----------------------------------------------
  */
static void PDL_Or_NOPDL()
{
    const uint8_t Start_Row_3 = 51;    // 起始行
	const uint8_t Start_Col_3 = 107;   // 起始列	
    const uint8_t Start_Row_4 = Start_Row_3 - 3;    // 起始行
	const uint8_t Start_Col_4 = Start_Col_3 + 11;   // 起始列
    if(Sys.InjectSpeed==InjectSpeed_PDL && FSM_InjectProcess != InjectProc_Finished)
    {
        OLED.ClearHorizonLine(47,89,39,16);
        UI.Resistance_Feedback(Sys.PressureValue);
    }
    else if(Sys.InjectSpeed!=InjectSpeed_PDL && FSM_InjectProcess != InjectProc_Finished)
    {
        /*20240806增加PDL模式非工作状态下显示注射剂量*/
        OLED.ClearHorizonLine(47,89,39,16);
        // 注射剂量
        UI.Icon_InjectDose(Sys.InjectDose);
        // 'm'
        OLED.DrawVerticalLine(Start_Row_3,   Start_Col_3,   6, 9);
        OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+1, 1, 1);
        OLED.ClearHorizonLine(Start_Row_3+2, Start_Col_3+1, 1, 4);
        OLED.ClearHorizonLine(Start_Row_3+1, Start_Col_3+2, 2, 5);
        OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+4, 2, 1);
        OLED.ClearHorizonLine(Start_Row_3+2, Start_Col_3+5, 1, 4);	
        OLED.ClearHorizonLine(Start_Row_3+1, Start_Col_3+6, 2, 5);		
        OLED.ClearHorizonLine(Start_Row_3,   Start_Col_3+8, 1, 1);	
        
        // 'L'
        OLED.DrawVerticalLine(Start_Row_4, Start_Col_4,   9, 5);
        OLED.ClearHorizonLine(Start_Row_4, Start_Col_4+1, 4, 8);
    }
    
}





/********************************************************
  End Of File
********************************************************/