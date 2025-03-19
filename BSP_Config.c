/**
  ******************************************************************************
  * @file           : IO_Config.c
  * @brief          : 
  ******************************************************************************
  * @attention
  * &IO分配：
  *  PA0 ——— TKEY            触摸按键             		 
  *  PA1 ——— KEY             实体按键1           		 
  *  PA2 ——— PWR_AD          电量AD
  *  PA3 ——— Hall_Sensor_1   板底霍尔
  *  PA4 ——— PKEY            电源按键
  *  PA5 ——— Motor_CUR       马达电流AD
  *  PA6 ——— PWR_Ctrl        电源控制开关
  *  PA7 ——— KEY3            实体按键3
  *  PA8 ——— 空                             		 
  *  PA9 ——  Hall_A          电机编码器A相     		 
  *  PA10 —— Hall_B          电机编码器B相     
  *  PA11 —— BUSY            语音IC忙信号       
  *  PA12 —— CLK2            语音IC时钟线       
  *  PA13 —— SWDIO           调试接口           
  *  PA14 —— SWCLK           调试接口           
  *  PA15 —— DATA2           语音IC数据线       
  *
  *  PB0 ——— PWMB            电机PWM输出
  *  PB1 ——— PWMA            电机PWM输出
  *  PB2 ——— 空         
  *  PB3 ——— OLED_D0         SPI时钟线
  *  PB4 ——— OLED_A0         Data/Command
  *  PB5 ——— OLED_DI         SPI数据线
  *  PB6 ——— OLED_CS         屏幕片选
  *  PB7 ——— KEY2            实体按键2
  *  PB8 ——— 空
  * 
  *  PF0 ——— OLED_VppCrtl    OLED电源控制  
  *  PF1 ——— OLED_RES        OLED复位
  * 
  *     
  *  OLED：  PF0 ——— OLED_VppCrtl    OLED电源控制
  *          PF1 ——— OLED_RES        OLED复位引脚
  *          PB3 ——— OLED_D0         SPI时钟线
  *          PB4 ——— OLED_A0         Data/Command
  *          PB5 ——— OLED_DI         SPI数据线
  *          PB6 ——— OLED_CS         屏幕片选
  *
  *  KEY 1+3+1:   PA0 ——— TKEY       触摸按键 
  *               PA1 ——— KEY        实体按键1 
  *               PB7 ——— KEY2       实体按键2
  *               PA7 ——— KEY3       实体按键3
  *               PA4 ——— PKEY       电源按键
  *                  
  *  Motor:   PB0 ——— PWMB           电机PWM输出
  *           PB1 ——— PWMA           电机PWM输出
  *           PA9 ——— Hall_A         电机编码器A相     		 
  *           PA10 —— Hall_B         电机编码器B相 
  *           PA5 ——— Motor_CUR      马达电流AD 
  *
  *  Voice:   PA15 —— DATA2           语音IC数据线  
  *           PA11 —— BUSY            语音IC忙信号       
  *           PA12 —— CLK2            语音IC时钟线 
  *
  *  &外设分配：
  *  General timer(16-bit)(2,13,15,16)
  *    timer2 :  Motor PWM+PWMN
  *    timer13:  无操作关机
  *    timer15:  定时读编码数
  *  Basic timer(16-bit)(5)
  *	   timer5 :  Voice data send
  *
  *  Advanced timer(16-bit)(0)
  *    timer0 :  Motor encode
  *
  *  ADC:
  *  ADC_CH2:  Battery voltage
  *  ADC_CH5:  Motor current
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "BSP_Config.h"


/* Private variables----------------------------------------------------------*/

/* Public variables-----------------------------------------------------------*/
uint16_t ADCDMA_Buf[4];
ADC_t Motor_ADC=
{
	.SampleCnt = 10, 
	.MaxValue = 0, 
	.MinValue = 4095, 
	.Range = 20, 
	.Value = 0, 
	.LastValue = 0, 
	.OutValue = 0, 
	.Coefficient = 8, 
	.Sum = 0, 
	.ValueBuf = {0}
};

ADC_t Power_ADC = 
{
	.SampleCnt = 10, 
	.MaxValue = 0, 
	.MinValue = 4095, 
	.Range = 20, 
	.Value = 0, 
	.LastValue = 0, 
	.OutValue = 0, 
	.Coefficient = 8, 
	.Sum = 0, 
	.ValueBuf = {0}
};

ADC_t Hall_ADC = 
{
	.SampleCnt = 10, 
	.MaxValue = 0, 
	.MinValue = 4095, 
	.Range = 20, 
	.Value = 0, 
	.LastValue = 0, 
	.OutValue = 0, 
	.Coefficient = 8, 
	.Sum = 0, 
	.ValueBuf = {0}
};


/* function prototypes -------------------------------------------------------*/ 
void IO_Config(void);
void NVIC_Config(void);
void SPI0_Init(void);
void TIMER0_Init(void);
void TIMER2_Init(uint16_t psc, uint16_t arr);
void TIMER5_Init(uint16_t psc, uint16_t arr);
void TIMER13_Init(uint16_t psc, uint16_t arr);
void TIMER15_Init(uint16_t psc, uint16_t arr);
void DMA_Init(void);
void ADC_Init(void);
void FWDGT_Config(void);

/**
* @name   : IO_Config
* @brief  : IO配置
* @param  : None
* @retval : None
* @note   : None
*/
void IO_Config(void)
{
	// 外设时钟使能
	rcu_periph_clock_enable(RCU_GPIOA);
	rcu_periph_clock_enable(RCU_GPIOB);
	rcu_periph_clock_enable(RCU_GPIOF);
	
	// IO口反初始化	
	gpio_deinit(GPIOA);
	gpio_deinit(GPIOB);
	gpio_deinit(GPIOF);
	

	// 电池电压 PWR_AD  PA2
	gpio_mode_set(GPIOA, GPIO_MODE_ANALOG, GPIO_PUPD_PULLUP, GPIO_PIN_2);
	
	// 按键配置
	    // 触摸按键 TKEY PA0
        gpio_mode_set(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO_PIN_0);  // 悬空输入（外部上拉）
	
        // 触摸按键开关
        gpio_mode_set(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_8);	
	    gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_8);
	    gpio_bit_reset(GPIOB, GPIO_PIN_8);		 //触摸IC开机上电
        
        // 实体按键1 KEY1 PA1
        gpio_mode_set(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, GPIO_PIN_1); // 内部上拉（按下接地）
        
        // 实体按键2 KEY2 PB7
        gpio_mode_set(GPIOB, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, GPIO_PIN_7); // 内部上拉（按下接地）
        
        // 实体按键3 KEY3 PA7
        gpio_mode_set(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, GPIO_PIN_7); // 内部上拉（按下接地）
		
	// 开关机控制配置
	    // 电源键输入检测 PA4
		gpio_mode_set(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_PULLUP, GPIO_PIN_4); // 内部上拉（按下接地）
	    
		// 电源开关控制 PA6
	    gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_PULLDOWN, GPIO_PIN_6);	
	    gpio_output_options_set(GPIOA, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_6);
	    gpio_bit_reset(GPIOA, GPIO_PIN_6);		
	  
	// OLED配置
        // 电源控制 PF0 
        gpio_mode_set(GPIOF, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_0);	
	    gpio_output_options_set(GPIOF, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_0);
	    gpio_bit_reset(GPIOF, GPIO_PIN_0);	

        // 复位控制 PF1 
        gpio_mode_set(GPIOF, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_1);	
	    gpio_output_options_set(GPIOF, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_1);
	    gpio_bit_reset(GPIOF, GPIO_PIN_1);	
		
		
		// Data/Com PB4   高电平数据，低电平指令
	    gpio_mode_set(GPIOB, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_4);	
	    gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_2MHZ, GPIO_PIN_4);
	    gpio_bit_reset(GPIOB, GPIO_PIN_4);	
		
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
		
	// 马达配置
	    // PWMA PB0 TIMER2_CH2
	    gpio_mode_set(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_PIN_0);
		gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_0);		
		gpio_af_set(GPIOB, GPIO_AF_1, GPIO_PIN_0);	

		// PWMB PB1 TIMER2_CH3 
	    gpio_mode_set(GPIOB, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO_PIN_1);
		gpio_output_options_set(GPIOB, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_1);		
		gpio_af_set(GPIOB, GPIO_AF_1, GPIO_PIN_1);	
	
        // Hall_A  TIMER0_CH1 PA9
	    gpio_mode_set(GPIOA, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_9);	
		gpio_af_set(GPIOA, GPIO_AF_2, GPIO_PIN_9);			
			
		// Hall_B TIMER0_CH2 PA10
	    gpio_mode_set(GPIOA, GPIO_MODE_AF, GPIO_PUPD_PULLUP, GPIO_PIN_10);
		gpio_af_set(GPIOA, GPIO_AF_2, GPIO_PIN_10);

		// 电流AD   Motor_CUR  PA5 
		gpio_mode_set(GPIOA, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, GPIO_PIN_5);	

	// 线性霍尔 PA3
		gpio_mode_set(GPIOA, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, GPIO_PIN_3);	
		
	// 语音配置	
	    // CLK  PA12
	    gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_12);	
	    gpio_output_options_set(GPIOA, GPIO_OTYPE_OD, GPIO_OSPEED_50MHZ, GPIO_PIN_12); 
	    gpio_bit_set(GPIOA, GPIO_PIN_12);	
		
        // DATA PA15    
	    gpio_mode_set(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO_PIN_15);	
	    gpio_output_options_set(GPIOA, GPIO_OTYPE_OD, GPIO_OSPEED_50MHZ, GPIO_PIN_15);		
	    gpio_bit_set(GPIOA, GPIO_PIN_15);	
        
		// BUSY PA11
	    gpio_mode_set(GPIOA, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO_PIN_11); // 悬空输入（外部有上拉）
}

/**
* @name   : NVIC_Config
* @brief  : 全局中断配置
* @param  : ( 中断源, 中断优先级 )
* @retval : None
* @note   : 
*/
void NVIC_Config(void)
{
	nvic_irq_enable(TIMER5_IRQn, 0);	
    nvic_irq_enable(TIMER15_IRQn, 1);
    nvic_irq_enable(TIMER0_Channel_IRQn, 1);	
	nvic_irq_enable(DMA_Channel1_2_IRQn, 2);
	nvic_irq_enable(TIMER13_IRQn, 3);
	nvic_irq_enable(DMA_Channel0_IRQn, 2);	
}

/**
* @name   : ADC_Init
* @brief  : ADC配置
* @param  : None
* @retval : None
* @note   : ADC_CHANNEL_2 ->  电池PA2  
*           ADC_CHANNEL_3 ->  线性霍尔PA3
*           ADC_CHANNEL_5 ->  电机PA5
*           ADC_CHANNEL_17 -> 内部参考ADC
*/
void ADC_Init(void)
{
    rcu_periph_clock_enable(RCU_ADC);
	rcu_adc_clock_config(RCU_ADCCK_APB2_DIV6);
	adc_deinit();
	
    adc_special_function_config(ADC_CONTINUOUS_MODE, DISABLE);               // 连续转换模式关闭
    adc_special_function_config(ADC_SCAN_MODE, ENABLE);                      // 使能扫描模式
    adc_data_alignment_config(ADC_DATAALIGN_RIGHT);                          // 右对齐
    adc_channel_length_config(ADC_REGULAR_CHANNEL, 4U);                      // 3个通道	
    adc_tempsensor_vrefint_enable();	
    adc_regular_channel_config(0, ADC_CHANNEL_2, ADC_SAMPLETIME_71POINT5);   // 通道2单次采样	
    adc_regular_channel_config(1, ADC_CHANNEL_3, ADC_SAMPLETIME_71POINT5);   // 通道3单次采样	
    adc_regular_channel_config(2, ADC_CHANNEL_5, ADC_SAMPLETIME_71POINT5);   // 通道5单次采样
    adc_regular_channel_config(3, ADC_CHANNEL_17, ADC_SAMPLETIME_71POINT5);  // 通道17单次采样	

    adc_external_trigger_source_config(ADC_REGULAR_CHANNEL, ADC_EXTTRIG_REGULAR_NONE);  // 规则通道组 软件触发
//    adc_external_trigger_config(ADC_REGULAR_CHANNEL, ENABLE);    // 规则通道组 触发使能
	adc_enable();
	delay_1ms(10U);
   	adc_calibration_enable();  // ADC校准复位	
	delay_1ms(10U);
	adc_dma_mode_enable();  // ADC DMA模式
//	dma_channel_enable(DMA_CH0);  // dma开始转换		
	adc_software_trigger_enable(ADC_REGULAR_CHANNEL);  //ADC软件触发使能
	adc_software_trigger_enable(ADC_REGULAR_CHANNEL);  //ADC软件触发使能
}


/**
* @name   : DMA_Init
* @brief  : DMA配置
* @param  : None
* @retval : None
* @note   : DMA_CH0 -> ADC转换
*           DMA_CH2 -> SPI0
*/
uint8_t spi0_send_array[1] = {1};
void DMA_Init(void)
{
    rcu_periph_clock_enable(RCU_DMA);

    dma_parameter_struct dma_data_parameter;
	
	dma_deinit(DMA_CH0);
	
    dma_data_parameter.periph_addr  = (uint32_t)(&ADC_RDATA);        // 外设基地址
    dma_data_parameter.memory_addr  = (uint32_t)(ADCDMA_Buf);        // 内存源地址	
    dma_data_parameter.periph_inc   = DMA_PERIPH_INCREASE_DISABLE;   // 外设源地址不增长
    dma_data_parameter.memory_inc   = DMA_MEMORY_INCREASE_ENABLE;    // 内存增长
    dma_data_parameter.periph_width = DMA_PERIPHERAL_WIDTH_16BIT;    // 外设数据宽度
    dma_data_parameter.memory_width = DMA_MEMORY_WIDTH_16BIT;        // 内存地址宽度
    dma_data_parameter.direction    = DMA_PERIPHERAL_TO_MEMORY;      // 传输方向 外设->内存
    dma_data_parameter.number       = 4U;                            // 传输数量4
    dma_data_parameter.priority     = DMA_PRIORITY_HIGH;             // 优先级高
    dma_init(DMA_CH0, &dma_data_parameter);	
	
	dma_circulation_enable(DMA_CH0);
	dma_memory_to_memory_disable(DMA_CH0);
	dma_interrupt_enable(DMA_CH0, DMA_INT_FTF);  // 使能DMA传输完成中断
	dma_channel_enable(DMA_CH0);  // 开始转换
	
	
    /* SPI0 transmit DMA configuration:DMA_CH2 */
	
#ifdef SPI0_DMA_CH2	
    dma_parameter_struct dma_init_struct;	
    dma_deinit(DMA_CH2);
    dma_struct_para_init(&dma_init_struct);

    dma_init_struct.priority     = DMA_PRIORITY_LOW;
    dma_init_struct.periph_addr  = (uint32_t)&SPI_DATA(SPI0);
    dma_init_struct.memory_addr  = (uint32_t)spi0_send_array;
    dma_init_struct.direction    = DMA_MEMORY_TO_PERIPHERAL;
    dma_init_struct.memory_width = DMA_MEMORY_WIDTH_8BIT;
    dma_init_struct.periph_width = DMA_PERIPHERAL_WIDTH_8BIT;

    dma_init_struct.number       = 1;
    dma_init_struct.periph_inc   = DMA_PERIPH_INCREASE_DISABLE;
    dma_init_struct.memory_inc   = DMA_MEMORY_INCREASE_ENABLE;
    dma_init(DMA_CH2, &dma_init_struct);
    /* configure DMA mode */
    dma_circulation_disable(DMA_CH2);
    dma_memory_to_memory_disable(DMA_CH2);	
//	dma_interrupt_enable(DMA_CH2, DMA_INT_FTF);
//   dma_channel_enable(DMA_CH2);
#endif


}





/**
* @name   : TIMER0_Init
* @brief  : 输入捕获中断配置
* @param  : None
* @retval : None
* @note   : 应用于马达编码输入
*           TIMER0_CH1 PA9
*           TIMER0_CH2 PA10
*/
void TIMER0_Init(void)
{
	timer_parameter_struct    timer_initpara;
    timer_ic_parameter_struct timer_icinitpara; 
	
    rcu_periph_clock_enable(RCU_TIMER0);
	
    timer_deinit(TIMER0);	
	
	timer_struct_para_init(&timer_initpara);	
    timer_initpara.prescaler         = 0;                   // 
    timer_initpara.alignedmode       = TIMER_COUNTER_EDGE;  // 边缘对齐
    timer_initpara.counterdirection  = TIMER_COUNTER_UP;    // 向上计数
    timer_initpara.period            = 65535;               // ARR 
    timer_initpara.clockdivision     = TIMER_CKDIV_DIV1;
    timer_initpara.repetitioncounter = 0;
    timer_init(TIMER0, &timer_initpara);
	
	timer_channel_input_struct_para_init(&timer_icinitpara);
	timer_icinitpara.icpolarity  = TIMER_IC_POLARITY_RISING;             // 通道输入极性
	timer_icinitpara.icselection = TIMER_IC_SELECTION_DIRECTTI;          // 通道输入模式选择
	timer_icinitpara.icprescaler = TIMER_IC_PSC_DIV1; 
	timer_icinitpara.icfilter    = 0x08;                                 // 输入捕获滤波
    timer_input_capture_config(TIMER0, TIMER_CH_1, &timer_icinitpara );  // 霍尔1
    timer_input_capture_config(TIMER0, TIMER_CH_2, &timer_icinitpara );	 // 霍尔2
	timer_auto_reload_shadow_enable(TIMER0);
	
	timer_interrupt_flag_clear(TIMER0,TIMER_INT_FLAG_CH1);
	timer_interrupt_flag_clear(TIMER0,TIMER_INT_FLAG_CH2);
	
    timer_interrupt_enable(TIMER0,TIMER_INT_CH1);		
    timer_interrupt_enable(TIMER0,TIMER_INT_CH2);		
	timer_enable(TIMER0);
}

/**
* @name   : SPI0_Init
* @brief  : SPI0配置
* @param  : None
* @retval : None
* @note   : 应用于OLED
*/
void SPI0_Init(void)
{
    /* SPI0外设时钟使能 */
    rcu_periph_clock_enable(RCU_SPI0);	

	spi_parameter_struct spi_init_struct;
		
    /* SPI0配置 */	
    spi_i2s_deinit(SPI0);
    spi_struct_para_init(&spi_init_struct);

	spi_init_struct.trans_mode           = SPI_TRANSMODE_BDTRANSMIT;
    spi_init_struct.device_mode          = SPI_MASTER;	
    spi_init_struct.frame_size           = SPI_FRAMESIZE_8BIT;
    spi_init_struct.clock_polarity_phase = SPI_CK_PL_HIGH_PH_2EDGE;
    spi_init_struct.nss                  = SPI_NSS_SOFT;
    spi_init_struct.prescale             = SPI_PSC_4;
    spi_init_struct.endian               = SPI_ENDIAN_MSB;

    spi_init(SPI0, &spi_init_struct);
	spi_enable(SPI0);
#ifdef SPI0_DMA_CH2
  //  spi_dma_enable(SPI0, SPI_DMA_TRANSMIT);	
#endif
	
	
}

/**
* @name   : TIMER2_Init
* @brief  : 定时器2初始化
* @param  : PSC -> 分频值, ARR -> 重装值
* @retval : None
* @note   : 应用于Motor PWM输出
*           PB0 TIMER2_CH2     PB1 TIMER2_CH3          
*           主频 72M  频率f = 主频(72M)/(PCS+1)/(ARR+1)
*           建议 50k > f > 10k
*           f = 72 000 000 /36/100 = 20 000
*/
void TIMER2_Init(uint16_t psc, uint16_t arr)
{
	timer_parameter_struct    timer_initpara;
    timer_oc_parameter_struct timer_ocinitpara; 
    
	rcu_periph_clock_enable(RCU_TIMER2);
	
    timer_deinit(TIMER2);

    timer_struct_para_init(&timer_initpara);	
    timer_initpara.prescaler         = psc;                 // PSC 36分频 
    timer_initpara.alignedmode       = TIMER_COUNTER_EDGE;  // 边缘对齐
    timer_initpara.counterdirection  = TIMER_COUNTER_UP;    // 向上计数
    timer_initpara.period            = arr;                 // ARR 
    timer_initpara.clockdivision     = TIMER_CKDIV_DIV1;
    timer_initpara.repetitioncounter = 0;
    timer_init(TIMER2, &timer_initpara);
	
	timer_channel_output_struct_para_init(&timer_ocinitpara);
    timer_ocinitpara.outputstate  = TIMER_CCX_ENABLE;           // 通道输出使能
    timer_ocinitpara.outputnstate = TIMER_CCXN_DISABLE;         // 互补输出失能 
    timer_ocinitpara.ocpolarity   = TIMER_OC_POLARITY_HIGH;     // 通道输出极性 = 高电平
    timer_ocinitpara.ocnpolarity  = TIMER_OCN_POLARITY_HIGH;    // 互补输出极性 = 高电平
    timer_ocinitpara.ocidlestate  = TIMER_OC_IDLE_STATE_LOW;    // 空闲下通道输出 = 低电平
    timer_ocinitpara.ocnidlestate = TIMER_OCN_IDLE_STATE_LOW;	// 空闲下互补输出 = 低电平
	
    timer_channel_output_config(TIMER2, TIMER_CH_2, &timer_ocinitpara); // 通道2 PB0
    timer_channel_output_config(TIMER2, TIMER_CH_3, &timer_ocinitpara);	// 通道3 PB1
    
    timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_2, 0);                     // 比较值
    timer_channel_output_mode_config(TIMER2, TIMER_CH_2, TIMER_OC_MODE_PWM0);           // PWM0输出模式
    timer_channel_output_shadow_config(TIMER2, TIMER_CH_2, TIMER_OC_SHADOW_DISABLE);	// 禁能影子寄存器
	
    timer_channel_output_pulse_value_config(TIMER2, TIMER_CH_3, 0);
    timer_channel_output_mode_config(TIMER2, TIMER_CH_3, TIMER_OC_MODE_PWM0);
    timer_channel_output_shadow_config(TIMER2, TIMER_CH_3, TIMER_OC_SHADOW_DISABLE);	

	
    timer_auto_reload_shadow_enable(TIMER2);
    timer_enable(TIMER2);
}

/**
* @name   : TIMER5_Init
* @brief  : 基本定时器5
* @param  : PSC -> 分频值, ARR -> 重装值
* @retval : None
* @note   : 应用于语音模块
*           500us 定时中断
*/
void TIMER5_Init(uint16_t psc, uint16_t arr)
{
    timer_parameter_struct timer_initpara;

    rcu_periph_clock_enable(RCU_TIMER5);

    timer_deinit(TIMER5);

    timer_struct_para_init(&timer_initpara);
    timer_initpara.prescaler         = psc;
    timer_initpara.alignedmode       = TIMER_COUNTER_EDGE;
    timer_initpara.counterdirection  = TIMER_COUNTER_UP;
    timer_initpara.period            = arr;
    timer_initpara.clockdivision     = TIMER_CKDIV_DIV1;
    timer_init(TIMER5, &timer_initpara);

    timer_interrupt_flag_clear(TIMER5, TIMER_INT_FLAG_UP);

    timer_interrupt_enable(TIMER5, TIMER_INT_UP);   // 使能更新中断
	timer_disable(TIMER5);
}


/**
* @name   : TIMER13_Init
* @brief  : 通用定时器13
* @param  : PSC -> 分频值, ARR -> 重装值
* @retval : None
* @note   : 应用于无操作关机
*/
void TIMER13_Init(uint16_t psc, uint16_t arr)
{
    timer_parameter_struct timer_initpara;

    rcu_periph_clock_enable(RCU_TIMER13);

    timer_deinit(TIMER13);

    timer_struct_para_init(&timer_initpara);
    timer_initpara.prescaler         = psc;
    timer_initpara.alignedmode       = TIMER_COUNTER_EDGE;
    timer_initpara.counterdirection  = TIMER_COUNTER_UP;
    timer_initpara.period            = arr;
    timer_initpara.clockdivision     = TIMER_CKDIV_DIV1;
    timer_init(TIMER13, &timer_initpara);

    timer_interrupt_flag_clear(TIMER13, TIMER_INT_FLAG_UP);

    timer_interrupt_enable(TIMER13, TIMER_INT_UP);   // 使能更新中断
	timer_enable(TIMER13);
}


/**
* @name   : TIMER15_Init
* @brief  : 通用定时器15
* @param  : PSC -> 分频值, ARR -> 重装值
* @retval : None
* @note   : 应用定时读电机编码器
*/
void TIMER15_Init(uint16_t psc, uint16_t arr)
{
    timer_parameter_struct timer_initpara;

    rcu_periph_clock_enable(RCU_TIMER15);

    timer_deinit(TIMER15);

    timer_struct_para_init(&timer_initpara);
    timer_initpara.prescaler         = psc;
    timer_initpara.alignedmode       = TIMER_COUNTER_EDGE;
    timer_initpara.counterdirection  = TIMER_COUNTER_UP;
    timer_initpara.period            = arr;
    timer_initpara.clockdivision     = TIMER_CKDIV_DIV1;
    timer_init(TIMER15, &timer_initpara);

    timer_interrupt_flag_clear(TIMER15, TIMER_INT_FLAG_UP);

    timer_interrupt_enable(TIMER15, TIMER_INT_UP);   // 使能更新中断
	timer_disable(TIMER15);
}


/**
* @name   : DMA_Channel1_2_IRQn
* @brief  : DMA通道1和2中断服务函数
* @param  : 
* @retval : 
* @note   : 
*/
void DMA_Channel1_2_IRQHandler()
{
	if( dma_interrupt_flag_get(DMA_CH0, DMA_INT_FLAG_FTF))
	{
	    dma_flag_clear(DMA_CH0, DMA_INT_FLAG_FTF);
	}
	if( dma_interrupt_flag_get(DMA_CH2, DMA_INT_FLAG_HTF))
	{
	    dma_flag_clear(DMA_CH2, DMA_INT_FLAG_HTF);
	}
}

/**
* @name   : FWDGT_Config
* @brief  : 看门狗
* @param  : 
* @retval : 
* @note   : 
*/
void FWDGT_Config(void)
{
    rcu_osci_on(RCU_IRC40K);
    rcu_osci_stab_wait(RCU_IRC40K); 
	fwdgt_config(625, FWDGT_PSC_DIV64); // 10ms
	fwdgt_enable();
}

/********************************************************
  End Of File
********************************************************/



