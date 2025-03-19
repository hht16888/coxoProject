#include "OLED.h"
#include "Picture.h"

/* 静态函数声明 --------------------------------------------------------*/
static unsigned char Reverse_Byte(unsigned char c);
static void OLED_WriteByte(uint8_t data);
void OLED_WriteREG(uint8_t data);
static void OLED_WriteData(uint8_t data);
static void OLED_Init(void);
static void OLED_Refresh(void);
static void OLED_Clear(void);
static void OLED_Fill(void);
static void OLED_ShowString(uint8_t x, uint8_t y, char *format, ... );
static void OLED_ScreenDark(void);
static void OLED_ScreenBright(void);
static void OLED_ESD_Init(void);
static void OLED_DrawHorizonLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
static void OLED_DrawVerticalLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
static void OLED_ClearHorizonLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide);
//static void InsertAreaBMP_4Byte_16Byte(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp);
//static void InsertAreaBMP_64Pix_16Byte(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp);
static void InsertAreaBMP_64Pix_128Pix(uint8_t x0, uint8_t y0, uint8_t *bmp, uint8_t Y, uint8_t X);
static void Drawchar_num(uint8_t num, uint8_t x, uint8_t y);
static void DrawChar_0(uint8_t x, uint8_t y);
static void DrawChar_1(uint8_t x, uint8_t y);
static void DrawChar_2(uint8_t x, uint8_t y);
static void DrawChar_3(uint8_t x, uint8_t y);
static void DrawChar_4(uint8_t x, uint8_t y);
static void DrawChar_5(uint8_t x, uint8_t y);
static void DrawChar_6(uint8_t x, uint8_t y);
static void DrawChar_7(uint8_t x, uint8_t y);
static void DrawChar_8(uint8_t x, uint8_t y);
static void DrawChar_9(uint8_t x, uint8_t y);

char OLED_Line0[16] = "";
char OLED_Line1[16] = "";
char OLED_Line2[16] = "";
char OLED_Line3[16] = "";


/* 结构体类型定义 ------------------------------------------------------*/
OLED_t OLED=
{
	.DisplayBuf = {""},
	.Init                       = OLED_Init,
	.Clear                      = OLED_Clear,
	.Fill                       = OLED_Fill,
	.Refresh                    = OLED_Refresh,
	.ShowString                 = OLED_ShowString,
	.ESD_Init                   = OLED_ESD_Init,
//	.InsertAreaBMP_4Byte_16Byte = InsertAreaBMP_4Byte_16Byte,
//	.InsertAreaBMP_64Pix_16Byte = InsertAreaBMP_64Pix_16Byte,	
	.InsertAreaBMP_64Pix_128Pix = InsertAreaBMP_64Pix_128Pix,
	.DrawHorizonLine            = OLED_DrawHorizonLine,
	.ClearHorizonLine           = OLED_ClearHorizonLine,
	.DrawVerticalLine           = OLED_DrawVerticalLine,
	.ScreenDark                 = OLED_ScreenDark,
	.ScreenBright               = OLED_ScreenBright,
	.Drawchar_num               = Drawchar_num	
};



/* 函数体 --------------------------------------------------------------*/



/**
  *----------------------------------------------
  * @name   : OLED_Init
  * @brief  : OLED初始化
  * @param  : None
  * @retval : 完成返回1，未完成返回0
  * @note   : 1ms轮询
  *----------------------------------------------
  */
static void OLED_Init(void)
{	
    OLED_CTRL(0);
    OLED_CS(0);	
	OLED_RES(0);	
	delay_1ms(1);	
	OLED_RES(1);	
	delay_1ms(1);	
    OLED_WriteREG(OLED_DISPLAY_OFF);
       
    OLED_WriteREG(OLED_LOW_COLUMN_ADDRESS);  
    OLED_WriteREG(OLED_HIGH_COLUMN_ADDRESS);  
    OLED_WriteREG(OLED_PAGE_ADDRESS);  
    OLED_WriteREG(OLED_DISPLAY_STARTLINE_A);  
    OLED_WriteREG(OLED_DISPLAY_STARTLINE_B);  
    OLED_WriteREG(OLED_CONTRACT_CONTROL);  
    OLED_WriteREG(OLED_128);  
    OLED_WriteREG(OLED_MEMORY_ADDRESS_MODE);  
    OLED_WriteREG(OLED_SEGMENT_REMAP);  
    OLED_WriteREG(OLED_SCAN_DIRECTION);  
    OLED_WriteREG(OLED_DISABLE_ENTIRE_DISPLAY_ON);  
    OLED_WriteREG(OLED_BACKGROUND_COLOR);  
    OLED_WriteREG(OLED_MULTIPLEX_RATIO_A);  
    OLED_WriteREG(OLED_MULTIPLEX_RATIO_B);  
    OLED_WriteREG(OLED_DISPLAY_OFFSET_A);  
    OLED_WriteREG(OLED_DISPLAY_OFFSET_B);  
    OLED_WriteREG(OLED_OSC_DIVISION_A);  
    OLED_WriteREG(OLED_OSC_DIVISION_B);  
    OLED_WriteREG(OLED_PRE_CHARGE_PERIOD_A);  
    OLED_WriteREG(OLED_PRE_CHARGE_PERIOD_B);  
    OLED_WriteREG(OLED_SET_VCOMH_A);  
    OLED_WriteREG(OLED_SET_VCOMH_B);  
    OLED_WriteREG(OLED_CHARGE_PUMP_ENABLE);  
    OLED_WriteREG(OLED_DCDC_ENABLE);  
    OLED.Clear();
	OLED.ScreenDark();	
    OLED_CTRL(1);
}


/**
  *----------------------------------------------
  * @name   : OLED_ESD_Init
  * @brief  : ESD初始化
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_ESD_Init(void)
{
        // 电源控制 PA0 推挽下拉
  //      gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_0);	
//	    gpio_output_options_set(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_0);
//	    gpio_bit_reset(GPIOA, GPIO_PIN_0);
	gpio_mode_set(GPIOF, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLUP, GPIO_PIN_1);	
	gpio_output_options_set(GPIOF, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_1);
	gpio_bit_set(GPIOF, GPIO_PIN_1);	
		
		// Data/Com PB4   高电平数据，低电平指令
	    gpio_mode_set(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_4);	
	    gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_4);
	    gpio_bit_set(GPIOB, GPIO_PIN_4);	
		
		// 片选 PB6
	    gpio_mode_set(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_6);	
	    gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_6);
	    gpio_bit_reset(GPIOB, GPIO_PIN_6);		
		
		// 时钟线 SPI0_CLK    PB3
		gpio_mode_set(GPIOB, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_3);
		gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_3);
	    gpio_af_set(GPIOB, GPIO_AF_0, GPIO_PIN_3);
		 
		// 数据线 SPI0_MOSI   PB5
		gpio_mode_set(GPIOB, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_5);
		gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_5);
	    gpio_af_set(GPIOB, GPIO_AF_0, GPIO_PIN_5);

}

/**
  *----------------------------------------------
  * @name   : OLED_WriteByte
  * @brief  : 写入一字节
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_WriteByte(uint8_t data)
{
#ifdef 	SPI0_DMA_CH2
    dma_channel_disable(DMA_CH2);       /*失能DMA通道2*/
	spi0_send_array[0] = data;	
	DMA_CH2CNT = 1;
    dma_channel_enable(DMA_CH2);        /*使能DMA通道2*/
	while(!dma_flag_get(DMA_CH2, DMA_FLAG_FTF));
#else
    while(RESET == spi_i2s_flag_get(SPI0, SPI_FLAG_TBE));
	spi_i2s_data_transmit(SPI0,data);	
	while(SET == spi_i2s_flag_get(SPI0, SPI_FLAG_TRANS));
#endif
}

/**
  *----------------------------------------------
  * @name   : OLED_WriteREG
  * @brief  : 写寄存器
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
void OLED_WriteREG(uint8_t data)
{
    OLED_CS(0);		
	OLED_A0(RESET);
	OLED_WriteByte(data);
    OLED_CS(1);		
}

/**
  *----------------------------------------------
  * @name   : OLED_WriteData
  * @brief  : 写数据
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_WriteData(uint8_t data)
{
    OLED_CS(0);		
	OLED_A0(SET);
	OLED_WriteByte(data);
    OLED_CS(1);		
}

/**
  *----------------------------------------------
  * @name   : OLED_Refresh
  * @brief  : 刷新画面
  * @param  : None
  * @retval : None
  * @note   : 全屏刷新
  *           DisplayBuf[64][16]
  *----------------------------------------------
  */
static void OLED_Refresh(void)   
{
	uint8_t i, j;
	for(i=0; i<64; i++)
	{
		OLED_WriteREG(0xB0);                //页地址
		OLED_WriteREG(i&0x0F);              //列低地址
		OLED_WriteREG(((i>>4)&0x0F)|0x10);  //列高地址
		for(j=0; j<16; j++) 
		{
			OLED_WriteData(OLED.DisplayBuf[i][j]);
		}
	}
}

/**
  *----------------------------------------------
  * @name   : InsertAreaBMP_64Pix_16Byte
  * @brief  : 更新指定区域的画面
  * @param  : x0 -> 起始行  y0 -> 起始列
              x1 -> 结束行  y1 -> 结束列
              *bmp -> 更新的画面数据指针
  * @retval : None
  * @note   : 画面数据水平扫描
  *           64行Pix 16列Byte 任意插入
  *           行像素级，列字节级
  *           即时更新
  *----------------------------------------------
  */
static void InsertAreaBMP_64Pix_16Byte(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp)
{
	if( x0 > x1 || y0 > y1 ) return;
	if( x0 > 63 || x1 > 63 ) return;
	if( y0 > 15 || y1 > 15 ) return;
	if( bmp == NULL ) return;
	
    for( uint8_t i = x0; i < x1+1; i++ )  // 行赋值
	{
	   for( uint8_t j = y0; j < y1+1; j++  ) // 列赋值
        {
			OLED.DisplayBuf[i][j] = *(bmp++);
		}
	}
	
	for( uint8_t i = x0; i < x1+1; i++ )  
	{
		OLED_WriteREG(0xB0+y0);             // 起始列地址
		OLED_WriteREG(i&0x0F);              // 行低地址
		OLED_WriteREG(((i>>4)&0x0F)|0x10);  // 行高地址
	    for( uint8_t j = y0; j < y1+1; j++  ) // 列移动
        {
			OLED_WriteData(OLED.DisplayBuf[i][j]);  // 即时更新
		}			
	}
}


/**
  *----------------------------------------------
  * @name   : OLED_DrawVerticalLine
  * @brief  : 画垂直线
  * @param  : x0 -> 起始行点  y0 -> 起始列点
              Long -> 线长    Wide -> 线宽
  * @retval : None
  * @note   : 指定位置画一直线
  *----------------------------------------------
  */  
static void OLED_DrawVerticalLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide)
{
    if(  x0 > 63 )   return;
    if(  y0 > 127 )  return;
    if( Long > 63 )  return;
    if( Wide > 128 ) return;   
	uint8_t data[16];
	for(uint8_t i = 0; i < 16; i++)
	{
	    data[i] = 0xff;
	}
	for(uint8_t j = 0; j<Long; j++)
	{
		InsertAreaBMP_64Pix_128Pix(x0+j, y0, data, Wide, 1);
	}    	
}



/**
  *----------------------------------------------
  * @name   : OLED_DrawHorizonLine
  * @brief  : 画水平直线
  * @param  : x0 -> 起始行点  y0 -> 起始列点
              Long -> 线长    Wide -> 线宽
  * @retval : None
  * @note   : 指定位置画一直线
  *----------------------------------------------
  */   
static void OLED_DrawHorizonLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide)
{
    if(  x0 > 63 ) return;
    if(  y0 > 127 ) return;
    if( Long > 128 ) return;
    if( Wide > 63 )	return;
	uint8_t data[16];
	for(uint8_t i = 0; i < 16; i++)
	{
	    data[i] = 0xff;
	}
	for(uint8_t j = 0; j<Wide; j++)
	{
		InsertAreaBMP_64Pix_128Pix(x0+j, y0, data, Long, 1);
	}
}

/**
  *----------------------------------------------
  * @name   : OLED_ClearHorizonLine
  * @brief  : 擦除水平直线
  * @param  : x0 -> 起始行点  y0 -> 起始列点
              Long -> 线长    Wide -> 线宽
  * @retval : None
  * @note   : 指定位置擦除一直线
  *----------------------------------------------
  */ 
static void OLED_ClearHorizonLine(uint8_t x0, uint8_t y0, uint8_t Long, uint8_t Wide)
{
    if(  x0 > 64 ) return;
    if(  y0 > 127 ) return;
    if( Long > 128 ) return;
    if( Wide > 63 )	return;
	uint8_t data[16];
	for(uint8_t i = 0; i < 16; i++)
	{
	    data[i] = 0x00;
	}
	for(uint8_t j = 0; j<Wide; j++)
	{
		InsertAreaBMP_64Pix_128Pix(x0+j, y0, data, Long, 1);
	}
}

/**
  *----------------------------------------------
  * @name   : InsertAreaBMP_64Pix_128Pix
  * @brief  : 更新指定区域的画面
  * @param  : x0 -> 起始行点  y0 -> 起始列点
              *bmp -> 更新的画面数据指针
              Y -> 图片的横向像素点数
              X -> 图片的纵向像素点数
  * @retval : None
  * @note   : 画面数据水平扫描,高位在前
  *           64行Pix 128列Pix 任意插入
  *           行像素级，列像素级
  *----------------------------------------------
  */   
static void InsertAreaBMP_64Pix_128Pix(uint8_t x0, uint8_t y0, uint8_t *bmp, uint8_t Y, uint8_t X)
{
	if( x0 > 63 ) return;
	if( y0 > 127 ) return;
	if( Y > 128 ) return;
	if( X > 64 ) return;	
	if( bmp == NULL ) return;
	
    uint8_t data[16] = { 0 };
	for(uint8_t i=0; i<16; i++) data[i]=0x00;
	
    uint8_t BMP_size = (Y + 7)/ 8;
    uint8_t BMP_Start_Col = y0 / 8;
    uint8_t BMP_Start_Bit = y0 % 8;
    uint8_t BMP_End_Col = BMP_Start_Col + (Y-1+BMP_Start_Bit)/8;   
    uint8_t BMP_Long_Int = Y%8;
    uint16_t BMP_ptr_Inc;     
	uint8_t BMP_End_Bit;
    if ((BMP_Start_Bit + Y) < 8) BMP_End_Bit = BMP_Start_Bit + Y;
    else BMP_End_Bit = (Y - 8 + BMP_Start_Bit) % 8;


	for(uint8_t j = x0 ;j < X+x0; j++)
	{
		BMP_ptr_Inc = (j-x0)*BMP_size;
        //插入头
     //   data[BMP_Start_Col] |= *(bmp+BMP_ptr_Inc) >> BMP_Start_Bit;
		//不改变原数据
		OLED.DisplayBuf[j][BMP_Start_Col] = Reverse_Byte(OLED.DisplayBuf[j][BMP_Start_Col]);
		if(BMP_size > 1 )
		{
		    data[BMP_Start_Col] |= *(bmp+BMP_ptr_Inc) >> BMP_Start_Bit;
		    OLED.DisplayBuf[j][BMP_Start_Col] = (OLED.DisplayBuf[j][BMP_Start_Col] & (0xff<<(8-BMP_Start_Bit)))|data[BMP_Start_Col];
		}
		else if(BMP_size == 1 && BMP_Start_Col == BMP_End_Col && BMP_Long_Int > 0) // 不满8个点
		{
			data[BMP_Start_Col] = (*(bmp+BMP_ptr_Inc) >> BMP_Start_Bit)&(0xff<<(8-BMP_End_Bit));
			data[BMP_Start_Col] = (OLED.DisplayBuf[j][BMP_Start_Col] & (uint8_t)(0xff<<(8-BMP_Start_Bit))) | data[BMP_Start_Col]; // 去头            			
			data[BMP_Start_Col] = (OLED.DisplayBuf[j][BMP_Start_Col] & (uint8_t)(0xff>>BMP_End_Bit)) | data[BMP_Start_Col];       // 去尾
			OLED.DisplayBuf[j][BMP_Start_Col] = data[BMP_Start_Col];
		}
		else if(BMP_size == 1 && BMP_Start_Col == BMP_End_Col && BMP_Long_Int == 0)  // 只有8个正排
		{
			data[BMP_Start_Col] |= *(bmp+BMP_ptr_Inc);
			OLED.DisplayBuf[j][BMP_Start_Col] = data[BMP_Start_Col];
		}		
		else if(BMP_size == 1 && BMP_Start_Col != BMP_End_Col)
		{
		  data[BMP_Start_Col] = *(bmp+BMP_ptr_Inc) >> BMP_Start_Bit;	
		  OLED.DisplayBuf[j][BMP_Start_Col] = (OLED.DisplayBuf[j][BMP_Start_Col] & (0xff<<(8-BMP_Start_Bit)))|data[BMP_Start_Col];	
		}
        
        OLED.DisplayBuf[j][BMP_Start_Col] = Reverse_Byte(OLED.DisplayBuf[j][BMP_Start_Col]);
		
        // 插中间
        for (uint8_t i= BMP_Start_Col+1; i< BMP_End_Col; i++)
        {
            data[i] = (uint8_t)(*(bmp+BMP_ptr_Inc + i - BMP_Start_Col - 1) << (8 - BMP_Start_Bit)) | (*(bmp+BMP_ptr_Inc + i - BMP_Start_Col) >> BMP_Start_Bit);
			OLED.DisplayBuf[j][i]=Reverse_Byte(data[i]);
        }
        //插入尾
		OLED.DisplayBuf[j][BMP_End_Col] = Reverse_Byte(OLED.DisplayBuf[j][BMP_End_Col]);
        if (BMP_size > 1 && BMP_End_Bit>0 && BMP_Long_Int > 0 && BMP_Start_Bit>0)
        {
            data[BMP_End_Col] = ((*(bmp+BMP_ptr_Inc + BMP_size - 2) << (8 - BMP_Start_Bit)) | (*(bmp+BMP_ptr_Inc + BMP_size - 1) >> BMP_Start_Bit)) & (uint8_t)(0xff << (8 - BMP_End_Bit));
			data[BMP_End_Col] = data[BMP_End_Col] | (OLED.DisplayBuf[j][BMP_End_Col] & (0xff >>  BMP_End_Bit));
        	OLED.DisplayBuf[j][BMP_End_Col]= data[BMP_End_Col];
        }
        else if (BMP_size > 1 && BMP_End_Bit>0 && BMP_Long_Int > 0 && BMP_Start_Bit==0)
        {
            data[BMP_End_Col] = (*(bmp+BMP_ptr_Inc + BMP_size - 1)) & (0xff << (8 - BMP_End_Bit));
        	data[BMP_End_Col] = data[BMP_End_Col] | (OLED.DisplayBuf[j][BMP_End_Col] & (0xff >>  BMP_End_Bit));
        	OLED.DisplayBuf[j][BMP_End_Col]= data[BMP_End_Col];
        }		
		else if (BMP_size > 1 && BMP_End_Bit>0 && BMP_Long_Int == 0)
		{
		    data[BMP_End_Col] = (*(bmp+BMP_ptr_Inc + BMP_size - 1) << (8 - BMP_Start_Bit)) & (uint8_t)(0xff << (8 - BMP_End_Bit));
			data[BMP_End_Col] = data[BMP_End_Col] | (OLED.DisplayBuf[j][BMP_End_Col] & (0xff >>  BMP_End_Bit));
	        OLED.DisplayBuf[j][BMP_End_Col]= data[BMP_End_Col];	
		}
        else if (BMP_size > 1 && BMP_End_Bit == 0 && BMP_Long_Int > 0)
        {
           	data[BMP_End_Col] = (uint8_t)(*(bmp+BMP_ptr_Inc + BMP_size - 2) << (8 - BMP_Start_Bit)) | (uint8_t)(*(bmp+BMP_ptr_Inc + BMP_size - 1) >> BMP_Start_Bit);
        	OLED.DisplayBuf[j][BMP_End_Col] = data[BMP_End_Col];
        }
        else if (BMP_size > 1 && BMP_End_Bit == 0 && BMP_Long_Int == 0)
        {
            data[BMP_End_Col] = (uint8_t)(*(bmp+BMP_ptr_Inc + BMP_size - 2) << (8 - BMP_Start_Bit)) | (*(bmp+BMP_ptr_Inc + BMP_size - 1) >> BMP_Start_Bit);
        	OLED.DisplayBuf[j][BMP_End_Col] = data[BMP_End_Col];
        }		
        else if (BMP_size == 1 && BMP_Start_Col != BMP_End_Col)
        {
            data[BMP_End_Col] = (*(bmp+BMP_ptr_Inc) << (8 - BMP_Start_Bit)) & (uint8_t)(0xff << (8 - BMP_End_Bit));
        	data[BMP_End_Col] = data[BMP_End_Col] | (OLED.DisplayBuf[j][BMP_End_Col] & (0xff>>BMP_End_Bit));
        	OLED.DisplayBuf[j][BMP_End_Col] = data[BMP_End_Col];
        }
        else if (BMP_size == 1 && BMP_Start_Col == BMP_End_Col && BMP_Start_Bit < BMP_End_Bit)
        {
            data[BMP_End_Col] = (*(bmp+BMP_ptr_Inc) >> BMP_Start_Bit) & (0xff << (8 - BMP_End_Bit));
			
			data[BMP_End_Col] = (OLED.DisplayBuf[j][BMP_End_Col] & (0xff<<(8-BMP_Start_Bit))) | data[BMP_End_Col];
			data[BMP_End_Col] = (OLED.DisplayBuf[j][BMP_End_Col] & (0xff>>BMP_End_Bit)) | data[BMP_End_Col];			
        	OLED.DisplayBuf[j][BMP_End_Col] = data[BMP_End_Col];
        }
        else if (BMP_size == 1 && BMP_Start_Col == BMP_End_Col && BMP_Start_Bit > BMP_End_Bit)
        {
            data[BMP_End_Col] = *(bmp+BMP_ptr_Inc) >> BMP_Start_Bit;
        	OLED.DisplayBuf[j][BMP_End_Col] = OLED.DisplayBuf[j][BMP_End_Col] & (0xff<<(8-BMP_Start_Bit));
        	OLED.DisplayBuf[j][BMP_End_Col] = OLED.DisplayBuf[j][BMP_End_Col] | data[BMP_End_Col];
        }
        OLED.DisplayBuf[j][BMP_End_Col] = Reverse_Byte(OLED.DisplayBuf[j][BMP_End_Col]);
	}
	
	//立即更新
//	for( uint8_t i = x0; i < X+x0 ; i++ )  
//	{
//		OLED_WriteREG(0xB0+BMP_Start_Col);  // 起始列地址
//		OLED_WriteREG(i&0x0F);              // 行低地址
//		OLED_WriteREG(((i>>4)&0x0F)|0x10);  // 行高地址
//	    for( int8_t j = BMP_Start_Col; j < BMP_End_Col+1; j++  ) // 列移动
//        {
//			OLED_WriteData(OLED.DisplayBuf[i][j]);  // 即时更新
//		}			
//	}
}


/**
  *----------------------------------------------
  * @name   : OLED_Clear
  * @brief  : 全屏清除
  * @param  : None
  * @retval : None
  * @note   : 即时刷新
  *----------------------------------------------
  */
static void OLED_Clear(void)
{
	uint8_t i, j;
	for(i=0; i<64; i++)
	{
		for(j=0; j<16; j++) OLED.DisplayBuf[i][j] = 0x00;
	}
	OLED.Refresh();
}

/**
  *----------------------------------------------
  * @name   : OLED_Fill
  * @brief  : 全屏填充
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_Fill(void)
{
	uint8_t i, j;
	for(i=0; i<64; i++)
	{
		for(j=0; j<16; j++) OLED.DisplayBuf[i][j] = 0xFF;
	}
}



/**
  *----------------------------------------------
  * @name   : OLED_DrawBMP
  * @brief  : 在指定的区域写入BMP图片
  * @param  : x0 -> 起始行[0,3]     y1 -> 起始列[0,15]
  *           x1 -> 结束行[0,3]     y1 -> 结束列[0,15]
  *           BMP[] -> 要显示的图片
  * @retval : None
  * @note   : 画面数据行列扫描
  *           4行Byte 16列Byte 任意插入
  *           行数字节级，列数字节级
  *----------------------------------------------
  */
static void InsertAreaBMP_4Byte_16Byte(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t *bmp)
{
    // 判读入口参数有效性
    if( x0 > 15 || y0 > 3 || x1 > 15 || y0 > 3 ) return;
	if( x1 < x0 || y1 < y0 ) return;
	if( bmp == NULL ) return;

	for(uint8_t j = 0; j < y1-y0+1; j++)
	{
		for(uint8_t i = 0; i < x1-x0+1; i++ )
		{
			for( uint8_t k = 0; k < 16; k++ )
			{
				OLED.DisplayBuf[x0*16+k+i*16][y0+j] = *bmp++;
			}
		}
	}
}




/**
  *----------------------------------------------
  * @name   : OLED_ShowSrting
  * @brief  : 字符串显示
  * @param  : 从x行y列开始写起, 后接printf显示内容
  * @retval : None
  * @note   : x表示行数，从第n行写起，n=0,1,2,3，共4行
  *           y表示列数，从第y列写起，y=0~15，共16行
  *           后接封装格式控制打印函数
  *           DisplayBuf[64][16]
  *----------------------------------------------
  */
static void OLED_ShowString(uint8_t x, uint8_t y, char *format, ... )  
{
	char buf[16] = {0};
	va_list p;
	va_start(p, format);
	vsprintf(buf, format, p);
	va_end(p);

	
//字符串转字符数组
	uint8_t len, n;
	uint32_t i, j, k=0;
	char c[16]={0};	
	len = strlen(buf);     //计算字符数组长度
	if(len >16-y) len = 16-y;    //取前16-y位

//点阵索引
	for(n=0; n<16; n++)
	{
		c[n] = buf[n];                   //将字符放进数组
		if(c[n]>=32 && c[n]<=126)
		{       
            c[n] = c[n]-32;
		}
	}
//放进缓存	
	for(n=0; n<len; n++)    
	{
		for(k=0, i=x*16; i<x*16+16; i++)   
		{
			for(j=y+n; j<y+1+n; j++)   
			{
				OLED.DisplayBuf[i][j]= *(ASCII_ptr[c[n]]+(k++));
			}
		}	
	}	
}


/**
  *----------------------------------------------
  * @name   : OLED_ScreenDark
  * @brief  : 屏幕熄灭
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_ScreenDark(void)
{
	OLED.Clear();
	OLED.Refresh();
	OLED_WriteREG(OLED_DISPLAY_OFF);  
	//OLED_CTRL(0);
}
	

/**
  *----------------------------------------------
  * @name   : OLED_ScreenBright
  * @brief  : 屏幕点亮
  * @param  : None
  * @retval : None
  * @note   : None
  *----------------------------------------------
  */
static void OLED_ScreenBright(void)
{
	OLED_CTRL(1);
	OLED_WriteREG(OLED_DISPLAY_ON);
}
	



/**
  *----------------------------------------------
  * @name   : Reverse_Byte
  * @brief  : 高低位转换
  * @param  : c -> 要转换的字节
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */
static unsigned char Reverse_Byte(unsigned char c)
{
    static const unsigned char table[256] =
    {
        0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
        0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
        0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8,
        0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8,
        0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4,
        0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4,
        0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec,
        0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc,
        0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2,
        0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2,
        0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea,
        0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa,
        0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6,
        0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6,
        0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee,
        0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe,
        0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1,
        0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1,
        0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9,
        0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9,
        0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5,
        0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5,
        0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed,
        0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd,
        0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3,
        0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3,
        0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb,
        0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
        0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7,
        0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7,
        0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef,
        0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff,
    };
    return table[c];
}

/**
  *----------------------------------------------
  * @name   : Drawchar_num
  * @brief  : 画数字字符
  * @param  : unm -> 数字，x -> 行，y -> 列
  * @retval : None
  * @note   : 
  *----------------------------------------------
  */

static void Drawchar_num(uint8_t num, uint8_t x, uint8_t y)
{
    switch(num)
	{
	    case 0: DrawChar_0(x,y);
		        break;
	    case 1: DrawChar_1(x,y);
		        break;
	    case 2: DrawChar_2(x,y);
		        break;
	    case 3: DrawChar_3(x,y);
		        break;
	    case 4: DrawChar_4(x,y);
		        break;
	    case 5: DrawChar_5(x,y);
		        break;
	    case 6: DrawChar_6(x,y);
		        break;
	    case 7: DrawChar_7(x,y);
		        break;
	    case 8: DrawChar_8(x,y);
		        break;
	    case 9: DrawChar_9(x,y);
		        break;		
	    default: break;
	}


}

static void DrawChar_0(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);
    OLED.DrawHorizonLine(x+7, y+1, 3, 1);
	OLED.DrawVerticalLine(x+1, y, 6, 1);
	OLED.DrawVerticalLine(x+1, y+4, 6, 1);
}
	

static void DrawChar_1(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y+1, 3, 8);
	OLED.DrawHorizonLine(x+1, y+1, 1, 1);	
	OLED.DrawVerticalLine(x, y+2, 8, 1);
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);	
}


static void DrawChar_2(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);		
	OLED.DrawVerticalLine(x+1, y, 2, 1);	
	OLED.DrawVerticalLine(x+1, y+4, 2, 1);	
	OLED.DrawVerticalLine(x+3, y+3, 1, 1);
	OLED.DrawVerticalLine(x+4, y+2, 1, 1);		
	OLED.DrawVerticalLine(x+5, y+1, 1, 1);
	OLED.DrawVerticalLine(x+6, y, 1, 1);
	OLED.DrawHorizonLine(x+7, y, 5, 1);	
}


static void DrawChar_3(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);		
	OLED.DrawHorizonLine(x+1, y, 1, 1);	
	OLED.DrawHorizonLine(x+1, y+4, 1, 2);
	OLED.DrawHorizonLine(x+3, y+2, 2, 1);
	OLED.DrawHorizonLine(x+4, y+4, 1, 3);
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);
	OLED.DrawHorizonLine(x+6, y, 1, 1);
}


static void DrawChar_4(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 4, 8);
	OLED.DrawVerticalLine(x+4, y, 1, 1);
	OLED.DrawVerticalLine(x+2, y+1, 1, 1);
 	OLED.DrawVerticalLine(x+3, y, 1, 1);   
	OLED.DrawHorizonLine(x+5, y, 5, 1);	
	OLED.DrawVerticalLine(x+1, y+2, 1, 1);
	OLED.DrawVerticalLine(x, y+3, 8, 1);

}


static void DrawChar_5(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y, 5, 1);	
	OLED.DrawVerticalLine(x, y, 4, 1);	
	OLED.DrawVerticalLine(x+6, y, 1, 1);		
	OLED.DrawHorizonLine(x+3, y, 4, 1);	
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);		
	OLED.DrawVerticalLine(x+4, y+4, 3, 1);	
}


static void DrawChar_6(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);	
	OLED.DrawVerticalLine(x+1, y, 6, 1);	
	OLED.DrawHorizonLine(x+1, y+4, 1, 1);
	OLED.DrawHorizonLine(x+3, y+1, 3, 1);
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);	
	OLED.DrawVerticalLine(x+4, y+4, 3, 1);
}


static void DrawChar_7(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y, 5, 1);	
	OLED.DrawVerticalLine(x+1, y+4, 1, 1);	
	OLED.DrawVerticalLine(x+2, y+3, 1, 1);		
	OLED.DrawVerticalLine(x+3, y+2, 2, 1);	
	OLED.DrawVerticalLine(x+5, y+1, 3, 1);		
}


static void DrawChar_8(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);	
	OLED.DrawHorizonLine(x+3, y+1, 3, 1);		
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);
	OLED.DrawVerticalLine(x+1, y, 2, 1);	
	OLED.DrawVerticalLine(x+4, y, 3, 1);
	OLED.DrawVerticalLine(x+1, y+4, 2, 1);	
	OLED.DrawVerticalLine(x+4, y+4, 3, 1);	
}


static void DrawChar_9(uint8_t x, uint8_t y)
{
    OLED.ClearHorizonLine(x, y, 5, 8);
	OLED.DrawHorizonLine(x, y+1, 3, 1);
	OLED.DrawHorizonLine(x+4, y+1, 3, 1);	
	OLED.DrawVerticalLine(x+1, y, 3, 1);
	OLED.DrawVerticalLine(x+1, y+4, 6, 1);
	OLED.DrawHorizonLine(x+7, y+1, 3, 1);		
}
