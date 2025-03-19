/**
  ******************************************************************************
  * @file           : FlashSave.c
  * @brief          : 
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
#include "FlashSave.h"

static void FMC_Erase_Pages(void);
static void FMC_Program(uint32_t *data, int len);

static int  Write(FlashData_t *WriteData);
static int  Read(FlashData_t *ReadData);
static int  isAvaliable(void);


FlashData_t FlashWriteData = {0};
FlashData_t FlashReadData = {0};

FlashTool_t FlashTool = 
{
     .Write         = Write,
	   .Read          = Read,
	   .isAvaliable   = isAvaliable
};

/**
  *----------------------------------------------
  * @name   : Read
  * @brief  : 读出flash
  * @param  : *ReadData -> 接收读出数据的指针
  * @retval : 成功返回1，失败返回0
  * @note   : 将数据读出到 *ReadData;
  *----------------------------------------------
  */
int Read(FlashData_t *ReadData)
{
	// 创建一个联合体类型临时变量 temp_union
    FlashData_union temp_union;  
	
  // 读取flash起始的第一个字节;	
	unsigned char *ptr = (unsigned char *)FMC_WRITE_START_ADDR;  
	
	//　判断是否合法
	if( *ptr == 0xF1 )  
	{
    // 将flash的数据拷贝到联合体临时变量 temp_union；		
    memcpy(&temp_union, ptr, sizeof(FlashData_union)); 

    // 将temp_union拷贝到 *ReadData	
		memcpy(ReadData, &temp_union.FlashData, sizeof(FlashData_t));  
	  return 1;
	}
    return 0;
}


/**
  *----------------------------------------------
  * @name   : *Get_Config_Params
  * @brief  : 获取参数配置
  * @param  : None
  * @retval : 返回FlashSave_t类型数据
  * @note   : None
  *----------------------------------------------
  */
FlashData_t *Get_Config_Params(void)
{
    return &FlashReadData;
}


/**
  *----------------------------------------------
  * @name   : isAvaliable
  * @brief  : 判断数据的有效性
  * @param  : None
  * @retval : 合法返回1，否则返回0
  * @note   : None
  *----------------------------------------------
  */
int isAvaliable(void)
{
    return (FlashReadData.data_valid_flag == 0xF1)?1:0;
}


/**
  *----------------------------------------------
  * @name   : Write
  * @brief  : 写入flash
  * @param  : *WriteData 用户将写入的数据的指针
  * @retval : 合法返回1，否则返回0
  * @note   : None
  *----------------------------------------------
  */
int Write(FlashData_t *WriteData)
{
    if( WriteData == NULL ) return -1;
	
	// 创建一个联合体类型临时变量data_union
    FlashData_union temp_union;  
	
    // 将临时变量 data_union 初始化置0
    memset(&temp_union, 0, sizeof(FlashData_union)); 

    // 将用户数据 *WriteData 写入临时联合体变量 temp_union
	memcpy(&temp_union.FlashData, WriteData, sizeof(FlashData_t));
    
	// 擦除flash
	FMC_Erase_Pages();
	
	// 写入flash
	FMC_Program((uint32_t *)&temp_union, sizeof(FlashData_union));

	return 0;
}





/**
  *----------------------------------------------
  * @name   : FMC_Erase_Pages
  * @brief  : [底层] flash擦除 
  * @param  : None
  * @retval : None
  * @note   : 擦除一页，因为只用到一页
  *----------------------------------------------
  */
static void FMC_Erase_Pages(void)
{
    fmc_unlock();
    fmc_flag_clear(FMC_FLAG_END | FMC_FLAG_WPERR | FMC_FLAG_PGERR);	
    fmc_page_erase(FMC_WRITE_START_ADDR );
    fmc_flag_clear(FMC_FLAG_END | FMC_FLAG_WPERR | FMC_FLAG_PGERR);	
    fmc_lock();
}

/**
  *----------------------------------------------
  * @name   : FMC_Program
  * @brief  : [底层] flash写入 底层
  * @param  : *data -> 要写入的数据地址
  *           len -> 数据大小(32的倍数)
  * @retval : None
  * @note   : 整字写入，即32位
  *----------------------------------------------
  */
static void FMC_Program(uint32_t *data, int len)
{
    fmc_unlock();
	uint32_t address = FMC_WRITE_START_ADDR;
	while( address <= FMC_WRITE_END_ADDR )
	{
	    if( len <= 0 ) break;
        fmc_word_program( address, *data); 
        address += 4U;
        data ++;		
        fmc_flag_clear(FMC_FLAG_END | FMC_FLAG_WPERR | FMC_FLAG_PGERR);	
	    len -= 4U;
	}
	fmc_lock();
}


