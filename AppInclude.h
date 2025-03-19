/**
  ******************************************************************************
  * @file           : AppInclude.h
  * @brief          : This file include all the header files.                  
  ******************************************************************************
  * @attention
  *
  *
  ******************************************************************************
  */
#ifndef __APPINCLUDE_H__
#define __APPINCLUDE_H__


#define VER_CN  1// 中文版本
//#define VER_EN  1// 英文版本

/* Includes peripheral device files ----------------------------------*/
#include "main.h"
#include "systick.h"
#include "gd32e23x_it.h"
#include "gd32e23x_libopt.h"
#include "gd32e23x.h"

/* Includes user files  ---------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "BLL.h"
#include "UI.h"
#include "MicroKey.h"
#include "OLED.h"
#include "Motor.h"
#include "Voice.h"
#include "BSP_Config.h"
#include "Picture.h"
#include "FlashSave.h"
#include "AppParam.h"

#endif


/********************************************************
  End Of File
********************************************************/
