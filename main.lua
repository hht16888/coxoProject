
function on_init()
    
    Language=0        --0中文 1英文
    beep(300)
    dofile("usbdownload_1309.lua")--多用文件关键字   USB-串口下载
    dofile("IMScreen.lua")  --启用种植界面lua脚本
    SystemMode=0  --模式0-开机 1-种植 2-外科 3-设置 4-弹窗 5-SN 6-Programm 7-DEBUG 8-用户界面 9-键盘小写白色 10-键盘大写白色
    SystemModeBeforSet=0           --进入设置前的模式
    ReadSystemMode=0               --flash读取的模式
    PowerOnFlag=0                  --上电开机标志位，用于U盘检测提示
    USBDriverFalg = 0             --U盘插入标志位
    USBDir = "A"            

    IM_Currentfile=1           --当前程序
    --g_SR_CurrentStepBuf[g_CurrentUser]=1

    Manual_Control=0           --0正常模式 1手动模式
    workingMode=0              --  0-待机 1-工作
    MotorState=0               -- 0-马达待机 1-马达工作 0x02马达到达扭矩 0x03蓝牙错误 0x04马达异常 0X05校准错误
    watersteptime=0            --冲水步骤图标闪烁计时

    Motordirection=0           --通过主板发的RecveDire来改变
    ShowNum_Speed=0            --屏幕显示的速度
    ShowNum_Torque=0           --屏幕显示的扭力
    IM_TorqueLooperNum=0        --扭力条

    RecivCommandID=0                                --接收到的指令
    ScreenSendFlag=0                                --屏幕发送标志
    ScreenSendStep=0                                --屏幕发送步骤

    TorqueRevCnt=0             --扭力延时接收计时

    LastRecveMotorStaus=0         --上一次马达状态
    --主板发给屏幕的参数
    RecveSpeed=0                                    --主板发上来的速度
    RecveTorque=0
    RecveDire=0                                     --脚踏电机方向切换
    RecveWaterFlag=0                                --脚踏水量切换 
    RecveProgFlag=0                                 --脚踏程序切换
    RecveMotorStaus=0                               --电机状态
    BLE_Staus=0                                     --0-未匹配未连接  1-已匹配未连接  2-已匹配已连接  3连接超时
    WirelessFootBat=3                               --无线脚踏电池 0-3
    FootType=4                                      --脚踏类型 0无脚踏 1有线脚踏 2无线脚踏 11有线踩踏踩下 12无线脚踏踩下  设置为3防止启动闪烁2S
    FootDireKeyPress=0                              --脚踏方向按键踩下 0松开 1踩下
    MotorHandleFlag=3                               --手柄标志  设置为3防止启动闪烁2S
    FootPressFlag = 0
    --debug接收主板
    BLERecvTimes=0                          --主板接收蓝牙 接收总数
    BLESendTimes=0                          --蓝牙发送主板 发送总数
    Debug_MotoSpeed=0                       --调试模式实时速度
    Debug_FootState=0                       --脚踏类型
    Debug_FootADH=0                         --脚踏AD高
    Debug_FootADL=0                         --脚踏AD低
    Debug_FootAD=0                          --脚踏AD
    Debug_MinDacValue=0                     --速度最小DAC值
    Debug_TorqueADC=0                       --扭力ADC值
    -----------------------------
    --屏幕发给主板的参数
    ScreenSetSpeed=0                               --当前设置速度（速比转换后）
    ScreenSetTorque=0                              --当前设置扭力
    ScreenSetWater=0                               --当前设置水量
    ScreenSetLight=0                               --当前设置灯光
    ScreenSetDire=0                                --当前电机方向
    HandControlFlag=0                              --手动按键 0-待机 1-工作    
    BLEMatchFlag=0                                 --蓝牙操作 0-无操作 1-配对 2-断开
    PedalAllowedOperation=0                        --脚踏允许操作标志位 0-不工作 1-全功能工作 2-设置模式下的蓝牙匹配
    calibration=0                                  --校准标志位 0-不校准 1-校准
    --DEBUG
    DebugMotorRun=0                          --马达 1-运行 0-停止
    DebugSetSpeed=0                          --老化速度
    DebugBleReset=0                          --蓝牙复位 1-复位 0-无操作
    DebugStepMotorRun=0                      --步进电机 1-运行 0-停止
    DebugStepMotorValue=0                    --步进电机档位
    DebugDACSetFlag=0                        --设置最小DAC标志位 1表示设置
    DebugDACSetValue=0                       --设置最小DAC值
    DebugDACResetFlag=0                      --DAC复位标志
    DebugADCSetFlag=0                        --设置ADC标志位 1表示设置
    DebugADCSetValue=0                       --设置ADC值 
    DebugADCResetFlag=0                      --ADC复位标志
    DebugTorqueSetValue=0                    --设置扭力值

    ToruqeBufNum=1                           --扭力数组下标值
    DebugTorqueBuf={5,10,20,30,40,50,60,70,80}  --扭力值数组

    FirstTorqueADCfromMainBoard=0              -- +或-扭力时 保存主板下发的第一次ADC值
    FirstSpeedDACfromMainBoard=0              -- 保存主板下发的第一次DAC值
    ------------------------------
    --马达老化老化用到的时间变量
    Debug_MotorState=0
    --Debug_MotorOnTime=0                   --调试模式马达老化时间
    Runtime=0                             --调试模式马达老化运行/停止计时
    Debug_MotorTestCnt=0                  --老化次数 一次=运行时间+停止时间
    Debug_SetRunTime=0
    Debug_SetStopTime=0

    --步进电机老化
    Debug_StepMotorState=0                --步进电机开启老化状态
    DebugStepMotorRunTime=0               --步进电机运行时间
    DebugStepMotorStopTime=0              --步进电机停止时间  
    StepMotorRuntime=0                    --运行时间
    Debug_SetpMotorTestCnt=0              --老化次数 一次=运行时间+停止时间

    DebugBleResetTime=0
    --------------- 

    LowFootBatTime=120                      --蓝牙低电量弹窗弹出间隔120s
    WirelessFootBatTime=LowFootBatTime-3    --首次脚踏电池弹窗时间 LowFootBatTime-3
    UartErroTime=0                          --屏幕通信中断计时
    ControlUartErrorCnt=0          --当屏幕的TX失效时，会一直收到主板的A0数据帧，计次大于50次，判断为屏幕通信中断
    calibrationtime=1                         --校准时间
    calibrationshowcount=0                    --校准图标显示计次
    calibrationErrorFlag=0                    --校准错误标志位
    calibrationErrorCnt=0                     --校准失败 图标显示计时
    MotorNotConnectedFlg = 0                        --校准马达未连接标志位
    BLEMatchTime=0
    ResetFlag=0                                    --复位标志
    ResetTime=0

    DebugDacAdcSetFlag=0        --debud界面微调功能开启 0关 1开

    TwinkleFlag=0 --闪烁

    POP_WindowNum=0            --1-复位 2-蓝牙连接 3-蓝牙断开 4-蓝牙匹配重试 5-蓝牙匹配中 6-手动控制确认 7-无线脚踏电量不足 8-马达未连接 9-E1屏幕通信中断 10-E2蓝牙错误 11-E3马达异常 12-删除用户 13-自动清洗 14-是否保存数据

    SNInEnFlag=0x10			    --序列号输入使能 0x10-enable   0x01-desable
	SNCODE="ZZZZZZZZ"
	SNNull="0000-0000"
    ScreenVision="Ver 1.0.3"
    --标准
    --0.0.2 增加外科步骤
    --0.0.3 第二版GUI 添加错误弹窗
    --0.0.4 修复部分转速比 工作时速度显示为0
    --0.0.5 修复自定义1:5切换到1:1或4:1时加减步进错误;种植模式64:1工作时转速显示为0
    --0.0.6 屏幕通信中断弹窗修改，增加判断屏幕TX失效检测 ；警告类弹窗提示声 DATE:20240222
    --0.0.7 修复种植模式 非手动模式和手动模式的冲水图标错乱
    --0.0.8 DEBUG模式增加微调功能
    --0.0.9 新版黑色风格GUI 更改换方向方式 增加校准错误 Debug模式微调数值范围
    --0.0.10 增加英文版GUI

    MainVision=0    --主板软件版本号
    FootVision=0    --脚踏软件版本号

    testcnt=0               --检查脚本是否卡死
    Debugbuttoncnt=0        --进入debug 按键按下次数
    ClearDebugCnt=0         --清除DEBUG按键按下的时间

    RecvTimes=0             --USB下载成功计时进入开机动画

    Voice=1                        --声音开
    BackLight=3                    --背光调节1 2 3
    
    Errbeepstep=0			--错误提示音阶段
    MotorStopbeepstep=0     --马达停提示音阶段
	ErrBeep=0				--错误提示音标志
    NoteBeep=0              --完成提示音标志
    BLEBeep=0
    MotorStopBeep=0         --马达停提示音标志
    FootLowPowerBeep=0      --马达低电量标志

    testmessageshowflag =0     --调试信息显示

    Popflag=0
    Warnbeepflag=0                  --警告类弹窗蜂鸣器提示

    ChangeStep_SystemMode=0         --切换模式 步骤 方向=0
    DireBtnFlag=0                   --方向按键改变标志位

    CRC16result2 = 0xffff
    CRC16result = 0xffff

    CRC16resultUser2 = 0xffff
    CRC16resultUser = 0xffff

    BLEMatchExitFlag = 0          --配网中取消标志位
    MotorChangeFlag = 1           --马达手柄切换标志位（小马达）
    BLEkeyOnFlag = 0              --蓝牙图标按键启动标志位
    ErrorCode = 0

    IMFileBuf=                      ----IM模式默认库
    {
        --序号,速度，扭力，速比，水量，LED
        {500,10,10,2,2},                --定位
        {500,10,10,2,2},                --扩孔
        {20,25,10,2,2},                --攻丝
        {20,25,10,0,2},                --植入
        {20,10,10,0,2},                --愈合基台
        {0,0,0,4,2}                  --冲水
    }
    IM_ProgramBuf=                      
    {
        --,速度，扭力，速比，水量，LED
            {500,10,10,2,2},                --定位
            {500,10,10,2,2},                --扩孔
            {20,25,10,2,2},                --攻丝
            {20,20,10,0,0},                --植入
            {20,10,10,0,0},                --愈合基台
            {0,0,0,4,2}                  --冲水               
    }
    IM_ProgramMaxMin=              --IM步骤的转速范围 扭力范围
    {
        {200,2500,5,40},            --球钻                        
        {200,2500,5,40},            --标记钻
        {200,2500,5,40},            --先峰钻
        {200,2500,5,40},            --扩孔钻
        {200,2500,5,40},            --成型钻
        {15,100,5,80},              --攻丝钻                         
        {15,100,5,80},              --种植体
        {15,100,5,20},              --愈合帽
        {10000,40000,5,40},            --骨锯
        {10000,200000,5,40},        --高速
        {2000,40000,5,40},          --低速
        {0,0,0,0}                   --冲水
    }
    SRFileBuf=                      ----SR模式默认库
    {
        --转速 速比 水量 照明
        {150000,4,2,2}, --拔牙
        {180000,5,2,2}, --修复
        {0,0,4,2}, --冲水
        {8000,6,2,2}, --自定义1
        {150000,4,2,2}, --自定义2
        {180000,5,2,2} --自定义3
    }
    SR_ProgramBuf=                     
    {
        --转速 速比 水量 照明
        {150000,4,2,2}, --拔牙
        {180000,5,2,2}, --修复
        {0,0,4,2}, --冲水
        {8000,6,2,2}, --自定义1
        {150000,4,2,2}, --自定义2
        {180000,5,2,2} --自定义3
    }
    AllRatioSpeedMinMax=     --不同转速比的最小速度，最大速度
    {       
        {600,80000},           --1:2                          
        {1000,120000},          --1:3
        {1000,130000},          --1:3.3
        {1200,170000},          --1:4.2
        {1500,200000},         --1:5
        {300,40000},           --1:1
        {100,12000},             --3.2:1
        {90,11000},             --3.4:1        
        {75,10000},             --4:1
        {30,4000},             -- 10:1 
        {20,2500},              --16:1
        {15,2000},              --20:1    
        {15,1500},              --27:1
        {15,1200},              --32:1
        {15,600}                --64:1
    }
--用户设置界面
    g_UserSetFlag = 0                 --进入用户设置界面标志位

    g_UserFisrtIcon = 1               --第一个用户图标位置
    g_UserSecondIcon = 2              --第二个用户图标位置
    g_UserThreeIcon = 3               --第三个用户图标位置
    g_UserFourIcon = 4                --第四个用户图标位置
    g_UserFivetIcon = 5               --第五个用户图标位置 

    g_UserFisrtSelectIcon = 6         --第一个用户被选中图标
    g_UserSecondSelectIcon = 7        --第二个用户被选中图标
    g_UserThreeSelectIcon = 8         --第三用户被选中图标
    g_UserFourSelectIcon = 9          --第四个用户被选中图标
    g_UserFiveSelectIcon = 10         --第五个用户被选中图标

    g_UserFisrtNameIcon = 11          --第一个用户名称背景色，在用户设计界面
    g_UserSecondNameIcon = 12         --第二个用户名称背景色，在用户设计界面
    g_UserThreeNameIcon = 13          --第三个用户名称背景色，在用户设计界面
    g_UserFourNameIcon = 14           --第四个用户名称背景色，在用户设计界面
    g_UserFiveNameIcon = 15           --第五个用户名称背景色，在用户设计界面

    g_HeadFisrtNameText = 16          --第一个用户名称首字母
    g_HeadSecondNameText = 17         --第二个用户名称首字母
    g_HeadThreeNameText = 18          --第三个用户名称首字母
    g_HeadFourNameText = 19           --第四个用户名称首字母
    g_HeadFiveNameText = 20           --第五个用户名称首字母

    g_UserFisrtNameText = 21              --第一个用户名称
    g_UserSecondNameText = 22             --第二个用户名称
    g_UserThreeNameText = 23              --第三个用户名称
    g_UserFourNameText = 24               --第四个用户名称
    g_UserFiveNameText = 25               --第五个用户名称 

    g_UserFisrtButton = 26          --第一个用户触摸按键
    g_UserSecondButton = 27         --第二个用户触摸按键
    g_UserThreeButton = 28          --第三个用户触摸按键
    g_UserFourButton = 29           --第四个用户触摸按键
    g_UserFiveButton = 30           --第五个用户触摸按键 

    g_UserFisrtNameButton = 31          --第一个用户名称触摸按键
    g_UserSecondNameButton = 32         --第二个用户名称触摸按键
    g_UserThreeNameButton = 33         --第三个用户名称触摸按键
    g_UserFourNameButton = 34           --第四个用户名称触摸按键
    g_UserFiveNameButton = 35          --第五个用户名称触摸按键 

    g_UserFisrtSelectButton = 36        --第一个用户触摸按键
    g_UserSecondSelectButton = 37       --第二个用户触摸按键
    g_UserThreeSelectButton = 38        --第三个用户触摸按键
    g_UserFourSelectButton = 39         --第四个用户触摸按键
    g_UserFiveSelectButton = 40         --第五个用户触摸按键 

    g_UserSetButton = 47                --用户设置按钮
    g_UserSetRightIcon = 41             --用户设置右下角

    g_UserSetLeftIcon = 44              --用户设置左上角

    g_UserCountBackIcon = 42            --用户界面倒数显示数字
    g_UserCountBack2Icon = 43           --用户界面倒数文字
    g_UserCountBack2ENIcon = 49           --用户界面倒数文字

    g_UserScreenBackIcon =  50          --用户界面背景

    g_HeadFisrtNameText_Black = 51          --第一个用户名称首字母_黑夜模式
    g_HeadSecondNameText_Black = 52         --第二个用户名称首字母_黑夜模式
    g_HeadThreeNameText_Black = 53          --第三个用户名称首字母_黑夜模式
    g_HeadFourNameText_Black = 54           --第四个用户名称首字母_黑夜模式
    g_HeadFiveNameText_Black = 55           --第五个用户名称首字母_黑夜模式

    g_UserFisrtNameText_Black = 56              --第一个用户名称_黑夜模式
    g_UserSecondNameText_Black = 57             --第二个用户名称_黑夜模式
    g_UserThreeNameText_Black = 58              --第三个用户名称_黑夜模式
    g_UserFourNameText_Black = 59               --第四个用户名称_黑夜模式
    g_UserFiveNameText_Black = 60               --第五个用户名称_黑夜模式 

    g_UserExitIcon = 45                 --用户界面退出图标
    g_UserExitButton = 48               --用户界面退出按键

    g_UserDataChangeFlag = 0x00            --用户数据改变标志位

    g_UserSaveIcon = 46                 --保存按键图标 

    g_CurrentUser = 0x01                --当前用户默认为用户

    g_DeleteFirstUserFlag = 0x00        --删除第一用户标志位
    g_DeleteSecondUserFlag = 0x00       --删除第二用户标志位
    g_DeleteThreeUserFlag = 0x00        --删除第三用户标志位

    g_ChangeFirstUserNameFlag = 0x00     --改变第一用户姓名标志位
    g_ChangeSecondUserNameFlag = 0x00    --改变第二用户姓名标志位
    g_ChangeThreeUserNameFlag = 0x00     --改变第三用户姓名标志位
    
    g_FirstID = 0xFF                    --缓存用户图标对应的ID号
    g_SecondID = 0xFF
    g_ThreeID = 0xFF

    g_UserTatolNum = 1                --用户总数量
    UserIDBuf = {0x01,0xFF,0xFF}      --用户编号（默认）按123排列
    UserNameBuf =                     --用户名称（默认）
    {
        "User",
        "User",
        "User"
    }

    UserIDInitBuf = {0x01,0xFF,0xFF}      --初始化用户编号（默认）按123排列
    UserNameInitBuf =                     --初始化用户名称（默认）
    {
        "User",
        "User",
        "User"
    }

    g_TempUserTatolNum = 1                --临时用户总数量
    TempUserIDBuf = {0x01,0xFF,0xFF}      --临时用户编号（默认）按123排列
    TempUserNameBuf =                     --临时用户名称（默认）
    {
        "User",
        "User",
        "User"
    }
--弹窗界面
    g_PopLeftButton = 3                     --弹窗界面左边按键
    g_PopRightButton = 5                    --弹窗界面右边按键
    g_PopMiddleButton = 4                   --弹窗界面中间按键  
    g_PopScreenIcon = 2                     --弹窗背景图标

    g_PopWashingFirstNumIcon   = 7          --倒计时数字1
    g_PopWashingSecondNumIcon  = 6          --倒计时数字2
--键盘输入界面
    g_KeyBoardExistButton = 44              --键盘输入取消按键
    g_KeyBoardConfirmButton = 45            --键盘输入确认按键
    g_KeyBoardSwitchButton = 50             --键盘大小写字母切换按键
    --g_KeyBoardCapitalLetterFlag = 42       --键盘输入大写字母
    g_KeyBoardUserNameText = 2              --键盘输入用户名10个
    --g_KeyBoardProgamNameText = 1            --键盘输入程序名20个字符
--键盘界面
    g_KeyBoardUserNamebfuf = "User"           --姓名缓存区
    g_KeyBoardOKIcon = 1                      --键盘OK确认

    g_KeyBoardUserNamebfuf2 = "U"             --姓名缓存区,用于超过10位限制
--定时器
    g_UserCountBackTime_1s = 13               --定时器13   
    g_UserCountBackCnt = 0                    --定时器计时  

--外壳模式界面
    g_SR_ProgramBuf=                     
    {
        --用户1
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        },
        --用户2
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        },
        --用户3
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        }
    }

    g_SR_Init_ProgramBuf=   --外科模式初始化BUF                  
    {
        --用户1
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        },
        --用户2
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        },
        --用户3
        {
            --转速 速比 水量 照明
            {150000,4,2,2}, --拔牙
            {180000,5,2,2}, --修复
            {10000,4,2,2}, --根尖切除
            {200000,5,2,2}, --窦底提升
            {30000,6,2,2}, --矢状锯
            {30000,6,2,2}, --摆动锯
            {30000,6,2,2}, --往复锯
            {0,0,4,2}, --冲水
            {8000,6,2,2} --自定义1
        }
    }
    g_SR_ScreenBackIcon = 54
    g_SR_CurrentStepBuf = {1,1,1}  --当前用户选择当前外科步骤，Buf[1-3]表示用户

    g_SR_ToothExtractionIcon = 1   --拔牙图标
    g_SR_RestorationIcon = 2       --修复图标
    g_SR_ApicalResectionIcon = 3       --根尖切除图标
    g_SR_SinusLiftIcon = 4         --窦底提升图标
    g_SR_SagittalSawIcon = 5        --矢状锯图标
    g_SR_SwingingSawIcon = 6        --摆动锯图标
    g_SR_ReciprocatingSawIcon = 7       --往复锯图标
    g_SR_RinsingIcon = 8             --冲水图标
    g_SR_OtherIcon = 9             --自定义图标

    g_SR_StepBigIcon = 10           --步骤大图标
    g_SR_SpeedtextIcon = 11          --速度文字显示

    g_SR_FirstNumIcon = 12          --速度文字显示
    g_SR_SecondNumIcon = 13          --速度文字显示
    g_SR_ThreeNumIcon = 14          --速度文字显示
    g_SR_FourNumIcon = 15           --速度文字显示    
    g_SR_FiveNumIcon = 16           --速度文字显示 
    g_SR_SixNumIcon = 17            --速度文字显示 

    g_SR_AddSubIcon = 18            --加减号图标  

    g_SR_BottomBackGroundIcon = 19  --下排背景图标 

    g_SR_ChangeIMIcon = 20        --种植与外壳切换图标
    g_SR_WaterIcon =  21           --水量图标
    g_SR_LEDIcon = 22              --LED图标
    g_SR_DirecionIcon = 23         --方向图标    
    g_SR_RatioIcon = 24            --速比图标  
    g_SR_SetIcon = 25              --设置图标 

    g_SR_UserIcon = 26              --用户绿色图标
    
    g_SR_WaterCrossBarIcon = 27     --冲水横杆图标
    g_SR_WaterWorkIcon = 28         --冲水工作图标

    g_SR_UserHeadText = 32              --用户名第一字母
    --g_SR_UserNameText = 33              --用户名
    g_SR_UserHeadText_Black = 55              --用户名第一字母
    --g_SR_UserNameText_Black = 56              --用户名
    g_SR_UserNameTextFirst = 33           --用户名1
    g_SR_UserNameTextSecond = 56           --用户名2
    g_SR_UserNameTextThree = 58           --用户名3

    g_SR_ToothExtractionButton = 34     --拔牙
    g_SR_RestorationButton = 35         --修复
    g_SR_ApicalResectionButton = 36      --根尖切除
    g_SR_SinusLiftButton = 37           --窦底提升
    g_SR_SagittalSawButton = 38         --矢状锯
    g_SR_SwingingSawButton = 39         --摆动锯
    g_SR_ReciprocatingSawButton = 40    --往复锯
    g_SR_RinsingButton = 41               --冲水
    g_SR_OtherButton = 42                --自定义  

    g_SR_StepBigButton = 43              --步骤大
    g_SR_AddButton = 45                  --加按键
    g_SR_SubButton = 44               --减按键

    g_SR_ChangeIMButton = 46        --种植与外壳切换按键 
    g_SR_WaterButton =  47           --水量
    g_SR_LEDButton = 48              --LED
    g_SR_DirecionButton = 49         --方向    
    g_SR_RatioButton = 50            --速比  
    g_SR_SetButton = 51              --设置



    g_SR_UserButton = 52              --外壳模式用户按键    
 
--设置界面
    g_SetScreenID = 3                 --设置界面ID

    g_SetVolumeIcon = 1                  --音量图标
    g_SetVolumeButton = 2                --音量按键
    g_SetBacklightIcon = 3                --背光亮度图标
    g_SetBacklightButton = 4              --背光亮度按键
    g_SetBleMatchIcon = 5                --蓝牙配对图标
    g_SetBleMatchButton = 6             --蓝牙配对按键
    g_SetCalibrationIcon = 7             --校准图标
    g_SetCalibrationButton = 8           --校准按键
    g_SetDarkModeIcon = 9               --深色模式图标
    g_SetDarkModeButton = 10            --深色模式按键   
    g_SetResetIcon = 11                  --恢复出厂设置图标
    g_SetResetButton = 12                --恢复出厂设置按键   

    g_SetExistButton = 13                --退出按键 
    g_SetScreenBackGround = 14           --背景图标 

    g_SetReversalIcon = 16             --步进电机反转图标
    g_SetReversalButton = 27             --步进电机反转按钮

    g_SetSNEnterButton = 50              --SN码输入按键/图标一体 

    g_SetFirmwareVerText = 17          --固件文本 
    g_SetInterfaceVerText = 18         --界面文本  
    g_SetMainControlVerText = 19       --主控文本  
    g_SetFootVerText = 20              --脚踏文本 

    g_SetFirmwareVerText_Black = 23          --固件文本 
    g_SetInterfaceVerText_Black = 24         --界面文本  
    g_SetMainControlVerText_Black = 25       --主控文本  
    g_SetFootVerText_Black = 26              --脚踏文本 

    g_SetQRCode = 21                   --二维码控件
    g_SetQRCodeText = 22               --二维码显示文本 
    g_SetQRCodeText_Black = 15         --二维码显示文本 
    g_SetKeyBoardText = 98             --小键盘文本 
    g_SetKeyBoardButton = 99           --小键盘触发控件 

    g_SetDarkModeFlag = 0              --深色模式关闭
    g_SetReversalFlag = 1            --步进电机反转标志位

    g_SetResetTime = 5                 --恢复出厂设置定时器5

    uart_set_baudrate(115200)	       --波特率115200 

    --种植参数
    --FlashWriteBuf1={}       
    --FlashReadBuf1 ={}	

    g_IMFlashWriteUser1Pro={}          --用户1程序步骤参数    
    g_IMFlashReadUser1Pro ={}   
    g_IMFlashWriteUser2Pro={}          --用户2程序步骤参数  
    g_IMFlashReadUser2Pro ={}  
    g_IMFlashWriteUser3Pro={}           --用户3程序步骤参数 
    g_IMFlashReadUser3Pro ={}  

    g_IMFlashWriteStep={}             --用户当前步骤
    g_IMFlashReadStep ={}  

    g_IMFlashWriteStepNum={}             --当前步骤总数
    g_IMFlashReadStepNum ={}  

    g_IMFlashWriteStepDate={}             --程序对应的步骤
    g_IMFlashReadStepDate ={}  

    g_IMFlashWriteProName={}             --程序名字
    g_IMFlashReadProName ={}     
    --外科参数
    g_SRFlashWriteUserBuf={}           --外科用户参数  
    g_SRFlashReadUserBuf ={} 



    g_FlashWriteUserID = {0x01,0xFF,0xFF}

    g_FlashWriteUserName = { "User", "User", "User"} 

    g_CurrentDire = 0         --串口：马达方向用于 防止方向改变，没有发送成功或者连续发送两帧无法识别
    g_CurrentDireFlag = 0     --串口：马达方向标志位 防止方向改变，没有发送成功或者连续发送两帧无法识别  

    g_CurrentDireBtn = 0         --串口：马达方向用于 防止方向改变，没有发送成功或者连续发送两帧无法识别
    g_CurrentDireBtnFlag = 0     --串口：马达方向标志位 防止方向改变，没有发送成功或者连续发送两帧无法识别  

    --其他变量参数
    FlashWriteBuf2={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF}       
    FlashReadBuf2 ={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF}
    --SN标志
    FlashWriteBuf3={0xFF}
    FlashReadBuf3={0xFF}
    --Language
    FlashWriteBuf4={0xFF,0xFF}
    FlashReadBuf4={0xFF,0xFF}
    --马达切换标志位
    FlashWriteMotorChangeBuf={0xFF,0xFF}
    FlashReadMotorChangeBuf={0xFF,0xFF}

    TxBuf={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}		--20个
    DebugTxBuf={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}	--21	

    --速比20:1 -- 12    1:1--6
    Ratio_PointNum={ 2,3,3.3,4.2,5,1,3.2,3.4,4,10,16,20,27,32,64 }--前5个÷    共15个速比

    DebugAdcStandardValue={102,197,408,579,796,1024,1200,1600,1795}  --标准值
    DebugAdcSetValue_MaxMin=
    {
        {30, 80, 250,400,500,700, 900, 1100,1300},        --Min                         
        {120,300,440,636,875,1124,1320,1500,1700}       --Max
    }
    
    start_timer(1, 300, 0, 0)       --闪烁刷新时间 
    start_timer(3, 50, 0, 0)        --错误提示蜂鸣器计时
    start_timer(7,3700,0,1)         --开机动画   
    --start_timer(9, 1000, 0, 0)      --1秒定时器

    set_visiable(3,98,0)--关闭调试入口
    set_visiable(7,27,0)  --ADC输入键盘关闭   
    set_visiable(7,29,0)  --DAC输入键盘关闭 

    DataReadFlashInit()
    change_screen(0) --开机动画
end
    -----------
function on_control_notify(screen,control,value)   --按键回调函数
    if(SystemMode==0)--开机动画
    then
        change_screen(0) 

    elseif(SystemMode==1)--种植模式
    then
        --IMScreen_Run(control,value)	
       -- IMScreen_Show()	
       IMScreen_Logical_operations(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])],control,value)
       IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])

    elseif(SystemMode==2)--外科模式
    then
        SRScreen_Run(control,value)	
        SRScreen_Show()

    elseif(SystemMode==3)--设置模式
    then
        SetScreen_Run(control,value)
        SetScreen_Show()

    elseif(SystemMode==4)--弹窗模式
    then
        WindowScreen_Run(control,value)
        WindowScreen_Show()
    elseif(SystemMode==5)--SN码
    then
        screenSN_run(control,value)
    elseif(SystemMode==7)--DEBUG
    then
        DebugScreen_Run(control,value)
        DebugScreen_Show()
    elseif(SystemMode==8)--开机用户界面
    then
        UserScreen_Run(control,value)
        UserScreen_Show()
    elseif(SystemMode==9)--白色小写键盘输入
    then
        KeyBoardSmallWhite_run(control,value)     
    elseif(SystemMode==10)--白色大写键盘输入
    then
        KeyBoardBigWhite_run(control,value)      
    elseif(SystemMode==16)--黑色小写键盘输入
    then
        KeyBoardSmallBlack_run(control,value)     
    elseif(SystemMode==17)--黑色大写键盘输入
    then
        KeyBoardBigBlack_run(control,value)         
    end 
end
    
function SR_Manual_Control_Set()

    if(g_SR_CurrentStepBuf[g_CurrentUser]~=g_SR_RinsingIcon)--不为冲水步骤
    then
        if(ShowNum_Speed<100)
        then
            set_value(2,g_SR_FirstNumIcon,ShowNum_Speed//10%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SecondNumIcon,ShowNum_Speed%10+g_SetDarkModeFlag*10)
        
            set_visiable(2,g_SR_FirstNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_SecondNumIcon,1)        --显示/隐藏

            set_visiable(2,g_SR_ThreeNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_FourNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_FiveNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_SixNumIcon,0)        --显示/隐藏

        elseif(ShowNum_Speed<1000)
        then
            set_value(2,g_SR_FirstNumIcon,ShowNum_Speed//100%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SecondNumIcon,ShowNum_Speed//10%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_ThreeNumIcon,ShowNum_Speed%10+g_SetDarkModeFlag*10)
        
            set_visiable(2,g_SR_FirstNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_SecondNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_ThreeNumIcon,1)        --显示/隐藏

            set_visiable(2,g_SR_FourNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_FiveNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_SixNumIcon,0)        --显示/隐藏
        
        elseif(ShowNum_Speed<10000)
        then
            set_value(2,g_SR_FirstNumIcon,ShowNum_Speed//1000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SecondNumIcon,ShowNum_Speed//100%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_ThreeNumIcon,ShowNum_Speed//10%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_FourNumIcon,ShowNum_Speed%10+g_SetDarkModeFlag*10)
        
            set_visiable(2,g_SR_FirstNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_SecondNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_ThreeNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_FourNumIcon,1)        --显示/隐藏

            set_visiable(2,g_SR_FiveNumIcon,0)        --显示/隐藏
            set_visiable(2,g_SR_SixNumIcon,0)        --显示/隐藏

        elseif(ShowNum_Speed<100000)
        then
            set_value(2,g_SR_FirstNumIcon,ShowNum_Speed//10000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SecondNumIcon,ShowNum_Speed//1000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_ThreeNumIcon,ShowNum_Speed//100%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_FourNumIcon,ShowNum_Speed//10%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_FiveNumIcon,ShowNum_Speed%10+g_SetDarkModeFlag*10)
        
            set_visiable(2,g_SR_FirstNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_SecondNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_ThreeNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_FourNumIcon,1)        --显示/隐藏
            set_visiable(2,g_SR_FiveNumIcon,1)        --显示/隐藏
    
            set_visiable(2,g_SR_SixNumIcon,0)        --显示/隐藏

        elseif(ShowNum_Speed<1000000)
        then
            set_value(2,g_SR_FirstNumIcon,ShowNum_Speed//100000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SecondNumIcon,ShowNum_Speed//10000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_ThreeNumIcon,ShowNum_Speed//1000%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_FourNumIcon,ShowNum_Speed//100%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_FiveNumIcon,ShowNum_Speed//10%10+g_SetDarkModeFlag*10)
            set_value(2,g_SR_SixNumIcon,ShowNum_Speed%10+g_SetDarkModeFlag*10)
        
            set_visiable(2,g_SR_FirstNumIcon,1)--显示转速
            set_visiable(2,g_SR_SecondNumIcon,1)
            set_visiable(2,g_SR_ThreeNumIcon,1)
            set_visiable(2,g_SR_FourNumIcon,1)
            set_visiable(2,g_SR_FiveNumIcon,1)
            set_visiable(2,g_SR_SixNumIcon,1)
        end
        if(workingMode~=1)
        then
            set_value(2,g_SR_AddSubIcon,0+g_SetDarkModeFlag)             --+-图标
            set_visiable(2,g_SR_AddSubIcon,1)          -- +-图标
            set_enable(2,g_SR_AddButton,1)             --使能加号   
            set_enable(2, g_SR_SubButton,1)          --使能减号
            set_visiable(2,g_SR_BottomBackGroundIcon,0)--关闭参数栏背景          --  
            set_value(2,g_SR_SetIcon,0+Language*2+g_SetDarkModeFlag*4)                --设置图标
            set_visiable(2,g_SR_SetIcon,1)             -- 显示设置图标
            set_value(2,g_SR_ChangeIMIcon,1+Language*2+g_SetDarkModeFlag*4)           --种植与外壳切换图标
            set_visiable(2,g_SR_ChangeIMIcon,1)        -- 显示种植与外壳切换图标
        else
            set_visiable(2,g_SR_AddSubIcon,0)          -- +-图标
            set_enable(2,g_SR_AddButton,0)             --使能加号   
            set_enable(2, g_SR_SubButton,0)          --使能减号
            set_value(2,g_SR_BottomBackGroundIcon,0+g_SetDarkModeFlag)   --
            set_visiable(2,g_SR_BottomBackGroundIcon,1)--关闭参数栏背景          --  
            set_visiable(2,g_SR_SetIcon,0)             -- 显示设置图标
            set_visiable(2,g_SR_ChangeIMIcon,0)        -- 显示种植与外壳切换图标
        end  
        set_value(2,g_SR_SpeedtextIcon,0+Language*1+g_SetDarkModeFlag*2)     
        set_visiable(2,g_SR_SpeedtextIcon,1)--转速文字

        set_visiable(2,g_SR_WaterWorkIcon,0)--冲水工作图标 
        set_visiable(2,g_SR_WaterCrossBarIcon,0)--冲水步骤横线
    else--冲水步骤
        set_visiable(2,g_SR_FirstNumIcon,0)--转速数字
        set_visiable(2,g_SR_SecondNumIcon,0)
        set_visiable(2,g_SR_ThreeNumIcon,0)
        set_visiable(2,g_SR_FourNumIcon,0)
        set_visiable(2,g_SR_FiveNumIcon,0)
        set_visiable(2,g_SR_SixNumIcon,0)
        --set_visiable(2,g_SR_SpeedtextIcon,0)--转速文字
        set_visiable(2, g_SR_AddSubIcon,0)-- +-图标
        set_enable(2,g_SR_AddButton,0)
        set_enable(2, g_SR_SubButton,0)
        --set_visiable(2,g_SR_SpeedtextIcon,0)--转速文字

        if(workingMode~=1)
        then
            set_value(2,g_SR_SetIcon,0+Language*2+g_SetDarkModeFlag*4)--设置图标
            set_visiable(2,g_SR_SetIcon,1)
            set_visiable(2,g_SR_BottomBackGroundIcon,0)--下排背景隐藏

            set_value(2,g_SR_SpeedtextIcon,0+Language+g_SetDarkModeFlag*2)--转速文字
            set_visiable(2,g_SR_SpeedtextIcon,1)--转速文字
            set_value(2,g_SR_WaterCrossBarIcon,0+g_SetDarkModeFlag*2)--冲水步骤横线
            set_visiable(2,g_SR_WaterCrossBarIcon,1)
            set_visiable(2,g_SR_WaterWorkIcon,0)--冲水图标 

            set_value(2,g_SR_DirecionIcon,1+g_SetDarkModeFlag*3)--
            set_visiable(2,g_SR_DirecionIcon,1) --冲水模式待机时 显示方向图标                

            set_value(2,g_SR_ChangeIMIcon,1+Language*2+g_SetDarkModeFlag*4)           --种植与外壳切换图标
            set_visiable(2,g_SR_ChangeIMIcon,1)        -- 显示种植与外壳切换图标
        else     --工作模式
            set_visiable(2,g_SR_SetIcon,0)
            set_value(2,g_SR_BottomBackGroundIcon,0+g_SetDarkModeFlag)
            set_visiable(2,g_SR_BottomBackGroundIcon,1)--下排背景显示

            set_visiable(2,g_SR_SpeedtextIcon,0)--转速文字
            set_visiable(2,g_SR_WaterCrossBarIcon,0)
            --set_value(2,g_SR_WaterWorkIcon,0)
            set_visiable(2,g_SR_WaterWorkIcon,1)--冲水图标 

            set_visiable(2,g_SR_DirecionIcon,0) --冲水模式待机时 显示方向图标                
            set_visiable(2,g_SR_ChangeIMIcon,0)        -- 显示种植与外壳切换图标
        end
    end
end
function SRScreen_Run(control,value)

    local MaxSetSpeed=0
    local MinSetSpeed=0
    local MaxSetTorque=0
    local MinSetTorque=0
    local Ratio=0
    local RatioSpeedMax=0
    local RatioSpeedMin=0

    if(g_SR_CurrentStepBuf[g_CurrentUser]==g_SR_RinsingIcon)        --冲水步骤
    then
        MaxSetSpeed=0
        MinSetSpeed=0
    else
        Ratio=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]
        if(g_SR_CurrentStepBuf[g_CurrentUser] >= g_SR_ToothExtractionIcon and g_SR_CurrentStepBuf[g_CurrentUser] <= g_SR_SinusLiftIcon) --1-4步
        then
            MinSetSpeed=10000
            if(Ratio==1)then MaxSetSpeed=80000 --1:2
            elseif(Ratio==2)then MaxSetSpeed=120000 --1:3
            elseif(Ratio==3)then MaxSetSpeed=130000--1:3.3
            elseif(Ratio==4)then MaxSetSpeed=170000--1:4.2
            elseif(Ratio==5)then MaxSetSpeed=200000 --1:5
            end    
        elseif(g_SR_CurrentStepBuf[g_CurrentUser] >= g_SR_SagittalSawIcon and g_SR_CurrentStepBuf[g_CurrentUser] <= g_SR_ReciprocatingSawIcon) --5-7
        then
                MinSetSpeed=10000
                MaxSetSpeed=40000 --4:1             
        else  -- 修复、自定义123
            if(Ratio==1)then 
                MinSetSpeed=600 
                MaxSetSpeed=80000--1:2
            elseif(Ratio==2)then 
                MinSetSpeed=1000 
                MaxSetSpeed=120000--1:3
            elseif(Ratio==3)then 
                MinSetSpeed=1000 
                MaxSetSpeed=130000--1:3.3
            elseif(Ratio==4)then 
                MinSetSpeed=1200 
                MaxSetSpeed=170000--1:4.2
            elseif(Ratio==5)then 
                MinSetSpeed=1500 
                MaxSetSpeed=200000 --1:5 
            elseif(Ratio==6)then 
                MinSetSpeed=300 
                MaxSetSpeed=40000--1:1
            elseif(Ratio==7)then 
                MinSetSpeed=100 
                MaxSetSpeed=12000--3.2:1
            elseif(Ratio==8)then 
                MinSetSpeed=90 
                MaxSetSpeed=11000--3.4:1
            elseif(Ratio==9)then 
                MinSetSpeed=75 
                MaxSetSpeed=10000--4:1
            elseif(Ratio==10)then 
                MinSetSpeed=30 
                MaxSetSpeed=4000--10:1     
            elseif(Ratio==11)then 
                MinSetSpeed=20 
                MaxSetSpeed=2500--16:1  
            elseif(Ratio==12)then 
                MinSetSpeed=15 
                MaxSetSpeed=2000--20:1  
            elseif(Ratio==13)then 
                MinSetSpeed=15 
                MaxSetSpeed=1500--27:1  
            elseif(Ratio==14)then 
                MinSetSpeed=15 
                MaxSetSpeed=1200--32:1  
            elseif(Ratio==15)then 
                MinSetSpeed=15 
                MaxSetSpeed=600--64:1  
            end                                          
        end
    end
    if(workingMode~=1)   --非工作模式不处理按键
    then
        if(control==g_SR_ChangeIMButton and value==1)--切换种植模式按键
        then
            KeyBeep_App()
            Motordirection=0     
            ScreenSetDire=0
            SystemMode=1
            change_screen(1)
            IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][Promgrame[g_CurrentUser]])
            ChangeStep_SystemMode=1   
            StartFlashWrite_App()
        end
        if(control==g_SR_SetButton and value==1)  --设置界面按键
        then
            SystemMode=3
            SystemModeBeforSet=2
            change_screen(3)
            SetScreen_Show()
            KeyBeep_App()
        end
        if(control==g_SR_UserButton and value==1)  --返回用户界面按键
        then
            SystemMode=8
            change_screen(8)
            SystemModeBeforSet=2
            g_UserSetFlag = 0
            UserScreen_Show()
            KeyBeep_App()

            --start_timer(g_UserCountBackTime_1s, 1000, 0, 0) --开启倒数定时器
        end        
        if(control>33 and control<43 and value==1)  --步骤选择
        then
            Motordirection=0
            ScreenSetDire=0
            g_SR_CurrentStepBuf[g_CurrentUser]=control-33
            ChangeStep_SystemMode=1
            KeyBeep_App()
            StartFlashWrite_App()

        end
        if(control==g_SR_StepBigButton and value==1)--大图标步骤
        then
            Motordirection=0
            ScreenSetDire=0
            g_SR_CurrentStepBuf[g_CurrentUser]=g_SR_CurrentStepBuf[g_CurrentUser]+1
            if(g_SR_CurrentStepBuf[g_CurrentUser]==10)
            then
                g_SR_CurrentStepBuf[g_CurrentUser]=1
            end
            ChangeStep_SystemMode=1
            KeyBeep_App()
            StartFlashWrite_App()
        end

        if(control==g_SR_RatioButton and value==1 and g_SR_CurrentStepBuf[g_CurrentUser]~=g_SR_RinsingIcon)--转速比
        then 
            if(g_SR_CurrentStepBuf[g_CurrentUser] >= g_SR_ToothExtractionIcon and g_SR_CurrentStepBuf[g_CurrentUser] <= g_SR_SinusLiftIcon)
            then
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]+1
                if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]==6)
                then
                    g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]=1
                end

            elseif(g_SR_CurrentStepBuf[g_CurrentUser] >= g_SR_SagittalSawIcon and g_SR_CurrentStepBuf[g_CurrentUser] <= g_SR_ReciprocatingSawIcon)
                then
                    g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]=6   --速比为1:1 输出马达速度
            else -- 自定义123
                if g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]==5 
                then
                    if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]<2000)
                    then
                        g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]=2000
                    end
                end
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]+1
                if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]==16)
                then
                    g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]=1
                end
            end

            if (g_SR_CurrentStepBuf[g_CurrentUser] < g_SR_SagittalSawIcon or g_SR_CurrentStepBuf[g_CurrentUser] > g_SR_ReciprocatingSawIcon) then
                KeyBeep_App()  --按键音
            end
            StartFlashWrite_App()    
        end
        
       -- if(g_SR_CurrentStepBuf[g_CurrentUser]~=g_SR_RinsingIcon and g_SR_CurrentStepBuf[g_CurrentUser]~=g_SR_SagittalSawIcon)  --不是冲水步骤，限制最大速度
       if(g_SR_CurrentStepBuf[g_CurrentUser]> g_SR_RinsingIcon or g_SR_CurrentStepBuf[g_CurrentUser] < g_SR_SagittalSawIcon)
        then
            Ratio=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]
            RatioSpeedMax=AllRatioSpeedMinMax[Ratio][2]
            RatioSpeedMin=AllRatioSpeedMinMax[Ratio][1]
            if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]>RatioSpeedMax)--切换转速比后，如果当前速度大于切换后转速比的速度最大值，则等于它
            then
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]=RatioSpeedMax
            elseif(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]<RatioSpeedMin) --切换转速比后，如果当前速度小于切换后转速比的速度最小值，则等于它
            then
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]=RatioSpeedMin
            end
        end

        local Speed=0
        if((control==g_SR_AddButton) and (value==1 or value==2))-- 速度 +
        then
            Speed=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]
            if(Speed<MaxSetSpeed)     --小于最大
            then
                if(Ratio==1)--1:2
                then       
                    if(Speed<2000)
                    then
                        Speed=Speed+100
                    elseif(Speed<10000)
                    then
                        Speed=Speed+1000
                    else
                        Speed=Speed+10000
                    end
                    KeyBeep_App()
                elseif(Ratio==2 or Ratio==3 or Ratio==4 or Ratio==5)--1:3 1:3.3 1:4.2 1:5
                then
                    if(Speed<2000)
                    then
                        Speed=Speed+100                   
                    elseif(Speed<10000)   
                    then                
                        Speed=Speed+1000                   
                    else                
                        Speed=Speed+10000; 
                    end
                    KeyBeep_App()
                elseif(Ratio==6 or Ratio==7 or Ratio==8 or Ratio==9)--1:1 4:1
                then
                    if((Speed%1000)~=0 and Speed>100)
                    then
                        Speed=Speed+100 
                    else
                        if(Speed<100)
                        then
                            Speed=Speed+5                        
                        elseif(Speed<1000)
                        then
                            Speed=Speed+100                        
                        else                       
                            Speed=Speed+1000  
                        end    
                    end                           
                        KeyBeep_App()
                else--10:1 16:1 20:1 27:1
                    if(Speed<100)
                    then
                        Speed=Speed+5                
                    else                   
                       Speed=Speed+100;
                    end
                    KeyBeep_App()
                end
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]=Speed
            else
                ErroBeep_App()
            end
            StartFlashWrite_App()
        end
        if((control== g_SR_SubButton) and (value==1 or value==2))-- 速度-
        then
            Speed=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]
            if(Speed>MinSetSpeed)     --小于最大
            then
                if(Ratio==1)--1:2
                then             
                    if(Speed>10000)
                    then
                        Speed=Speed-10000                   
                    elseif(Speed>2000)
                    then
                        Speed=Speed-1000                   
                    else
                        Speed=Speed-100
                    end
                    KeyBeep_App()
                elseif(Ratio==2 or Ratio==3 or Ratio==4 or Ratio==5)
                then
                    if(Speed>10000)
                    then
                        Speed=Speed-10000                  
                    elseif(Speed>2000)
                    then
                        Speed=Speed-1000
                    else
                        Speed=Speed-100
                    end
                    KeyBeep_App()
                elseif(Ratio==6 or Ratio==7 or Ratio==8 or Ratio==9)--1:1 4:1
                then
                    if((Speed%1000)~=0 and Speed>100)
                    then
                        Speed=Speed-100 
                    else    
                        if(Speed>1000)
                        then
                            Speed=Speed-1000;
                        elseif(Speed>100)
                        then
                            Speed=Speed-100;                 
                        else                        
                            Speed=Speed-5;                      
                        end  
                    end
                    KeyBeep_App()              
                else  -- 10:1 16:1 20:1 27:1
                    if(Speed>100)
                    then
                        Speed=Speed-100                   
                    else
                        Speed=Speed-5   
                    end 
                    KeyBeep_App()                 
                end
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]=Speed
            else
                ErroBeep_App()
            end
            StartFlashWrite_App()
        end   
        --水量
        if(control==g_SR_WaterButton and value==1)
        then
            g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]+1
            if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]==5)
            then
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]=0
            end
            KeyBeep_App()
            StartFlashWrite_App()
        end
        --灯光亮度
        if(control==g_SR_LEDButton and value==1)
        then
            g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]+1
            if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]==3)
            then
                g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]=0
            end
            KeyBeep_App()
            StartFlashWrite_App()
        end
        if(control==g_SR_DirecionButton and value==1)--电机方向
        then 
            ScreenSetDire=ScreenSetDire+1     
            if(ScreenSetDire==2)
            then
                ScreenSetDire=0
            end 
            Motordirection=ScreenSetDire     
            DireBtnFlag=1   
            KeyBeep_App()
        end
    end
end
function SRScreen_Back_Show()   --外科界面背景显示
    if g_SetDarkModeFlag == 1 then
        set_value(2,g_SR_ScreenBackIcon,1)
        set_visiable(2,g_SR_ScreenBackIcon,1)   
    else
        set_value(2,g_SR_ScreenBackIcon,0)
        set_visiable(2,g_SR_ScreenBackIcon,1) 
    end
end    
function SRScreen_Show()

    --set_text(2,53,"ScreenSetDire="..ScreenSetDire)
    --set_text(2,31,"RecveDire="..RecveDire)
    --set_text(2,30,"Motordirection="..Motordirection)
    
    --testmessageshow()
    --set_text(2,29,"DireBtnFlag="..DireBtnFlag)

    --set_text(2,57,"S="..g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1])

    StateView()                 --状态栏
    SRScreen_Back_Show()        --外壳模式背景
    SRScreen_UserName_Show()    --显示用户名

    if(workingMode==1)           --工作状态
    then   
        ShowNum_Speed=RecveSpeed
    else
        ShowNum_Speed=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]
    end
    SR_Manual_Control_Set()    --图标默认值显示
      
    for i=1,9,1 do
        if(i==g_SR_CurrentStepBuf[g_CurrentUser])    --步骤显示
        then
            set_value(2,i,1+Language*2+g_SetDarkModeFlag*4) --选中的变色
        else
            set_value(2,i,0+Language*2+g_SetDarkModeFlag*4) --没选中的默认色
        end
        set_enable(2,33+i,1)  --使能步骤按键
        set_visiable(2,i,1)   --显示步骤图标
    end
    
    set_value(2,g_SR_StepBigIcon,g_SR_CurrentStepBuf[g_CurrentUser]-1+Language*9+g_SetDarkModeFlag*18)--大步骤图标

    set_value(2,g_SR_WaterIcon,g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]+g_SetDarkModeFlag*5)--水量图标
    set_value(2,g_SR_LEDIcon,g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]+g_SetDarkModeFlag*3)--亮度图标

    if(g_SR_CurrentStepBuf[g_CurrentUser]~=g_SR_RinsingIcon) --冲水步骤
    then
        set_enable(2,g_SR_RatioButton,1)--其他步骤 开启转速比按键
        set_enable(2,g_SR_DirecionButton,1)--其他步骤 开启方向
        set_value(2,g_SR_DirecionIcon,Motordirection+g_SetDarkModeFlag*3)--方向
    else
        set_enable(2,g_SR_RatioButton,0)--冲水 关闭速比按键
        set_enable(2,g_SR_DirecionButton,0)--冲水 关闭方向按键
        --set_value(2,g_SR_DirecionIcon,2+g_SetDarkModeFlag*3)--冲水时 方向图标显示灰色
        set_visiable(2,g_SR_DirecionIcon,DISABLE)  --冲水步骤隐藏反向图标
    end

    SRScreen_Dire_Show()  --速比图标显示
    SRScreen_User_Show()  --当前图标用户图标显示
end
-----------------------------------------------------------------------------
--@program:SRScreen_Dire_Show()
--@brief:当前图标用户
-------------------------------------------------------------------------------
function SRScreen_User_Show()
    set_value(2,g_SR_UserIcon,g_CurrentUser)  --当前图标用户
    set_visiable(2,g_SR_UserIcon,ENABLE)    
end
-----------------------------------------------------------------------------
--@program:SRScreen_UserName_Show()
--@brief:当前图标用户名字
-------------------------------------------------------------------------------
function SRScreen_UserName_Show()
    local FirstNum = "U"

    if g_CurrentUser == 1 then   --用户名
        set_text(2,g_SR_UserNameTextFirst,UserNameBuf[g_CurrentUser])
        set_visiable(2,g_SR_UserNameTextFirst,1)

        set_visiable(2,g_SR_UserNameTextSecond,0)
        set_visiable(2,g_SR_UserNameTextThree,0)
    elseif g_CurrentUser == 2 then
        set_text(2,g_SR_UserNameTextSecond,UserNameBuf[g_CurrentUser])
        set_visiable(2,g_SR_UserNameTextSecond,1)

        set_visiable(2,g_SR_UserNameTextFirst,0)
        set_visiable(2,g_SR_UserNameTextThree,0)
    elseif g_CurrentUser == 3 then
        set_text(2,g_SR_UserNameTextThree,UserNameBuf[g_CurrentUser])
        set_visiable(2,g_SR_UserNameTextThree,1)

        set_visiable(2,g_SR_UserNameTextFirst,0)
        set_visiable(2,g_SR_UserNameTextSecond,0)
    end

    if g_SetDarkModeFlag == 1 then   --大写字母
        FirstNum = string.sub(UserNameBuf[g_CurrentUser],1,1)
        set_text(2,g_SR_UserHeadText_Black,FirstNum)
        set_visiable(2,g_SR_UserHeadText_Black,1)

        set_visiable(2,g_SR_UserHeadText,0) 
    else
        FirstNum = string.sub(UserNameBuf[g_CurrentUser],1,1)
        set_text(2,g_SR_UserHeadText,FirstNum)
        set_visiable(2,g_SR_UserHeadText,1)  

        set_visiable(2,g_SR_UserHeadText_Black,0)
    end

end
-----------------------------------------------------------------------------
--@program:SRScreen_Dire_Show()
--@brief:外科模式方向图标切换
-------------------------------------------------------------------------------
function SRScreen_Dire_Show()
    if(g_SR_CurrentStepBuf[g_CurrentUser]==g_SR_RinsingIcon) then --冲水步骤
        --if(workingMode~=1)then
            --set_value(2,g_SR_RatioIcon,16+g_SetDarkModeFlag*18)       --冲水模式待机时 显示速比图标
            --set_visiable(2,g_SR_RatioIcon,ENABLE)    --
       -- else
            set_visiable(2,g_SR_RatioIcon,0)    --工作隐藏
       -- end
    elseif g_SR_CurrentStepBuf[g_CurrentUser] >= 5 and g_SR_CurrentStepBuf[g_CurrentUser] <= 7 then 
        set_visiable(2,g_SR_RatioIcon,0) --矢状锯 摆动锯和往复锯隐藏
    else
        set_value(2,g_SR_RatioIcon,g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]-1+g_SetDarkModeFlag*18)--转速比图标
        set_visiable(2,g_SR_RatioIcon,ENABLE) --
    end
end    

function SetScreen_Run(control,value)
    if(calibration==0 and ResetFlag==0 and BLEMatchFlag==0)
    then

        if(control==g_SetExistButton and value==1)  --退出键
        then
            if(SystemModeBeforSet==3 or SystemModeBeforSet==4 or SystemModeBeforSet==7)  --3设置模式 4弹窗模式 7调试模式 防止无法退出设置模式
            then
                SystemModeBeforSet=1
            end
            SystemMode=SystemModeBeforSet

            if(SystemMode==1)
            then
                IMScreen_Init_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
            else
                SRScreen_Show()
            end
            change_screen(SystemMode)
            KeyBeep_App()            
        end
        if(control==g_SetVolumeButton and value==1)--声音开关
        then
            if(Voice==1)
            then
                Voice=0
            else
                Voice=1
            end
            KeyBeep_App()
            StartFlashWrite_App()
        end

        if(control==g_SetBacklightButton and value==1)  --背光调节
        then
            BackLight=BackLight+1
            if(BackLight==4)
            then
                BackLight=1 
            end
            Backlight_App()
            KeyBeep_App()
            StartFlashWrite_App()
        end

        if(control==g_SetResetButton and value==1)   --恢复出厂设置
        then
            change_child_screen(4)
            SystemMode=4
            POP_WindowNum=1
            WindowScreen_Show()
            KeyBeep_App()    
        end

        if(control==g_SetBleMatchButton and value==1 and BLEkeyOnFlag == 1)-- 蓝牙
        then
            if(BLE_Staus==0)                        --蓝牙未匹配 就进行匹配
            then
                change_child_screen(4)
                SystemMode=4
                POP_WindowNum=2
                WindowScreen_Show()
                KeyBeep_App()

            elseif(BLE_Staus==1 or BLE_Staus==2)    --已匹配 就进行断开
            then  
                change_child_screen(4)
                SystemMode=4
                POP_WindowNum=3
                WindowScreen_Show()
                KeyBeep_App()
            end
        end
        if(control==g_SetDarkModeButton and value==1)--深色模式
        then
            if(g_SetDarkModeFlag==1)
            then
                g_SetDarkModeFlag=0
            else
                g_SetDarkModeFlag=1   --深色夜间模式要写flash
            end
            KeyBeep_App()
            StartFlashWrite_App()
        end  
        if(control==g_SetReversalButton and value==1)--反转模式
        then
            if(g_SetReversalFlag==1)
            then
                g_SetReversalFlag=0
            else
                g_SetReversalFlag=1 
            end
            KeyBeep_App()
            StartFlashWrite_App()
        end  

        if(control==g_SetCalibrationButton and value==1 )--校准开关
        then
           if(MotorHandleFlag==1)
            then
                if(calibration==0)
                then
                    calibrationtime=1                --校准时间
                    calibrationshowcount=0           --校准图标显示计次
                    start_timer(g_SetResetTime, 250, 0, 0)        --复位计时
                    calibration=1
                end
                KeyBeep_App()
            else
                ErroBeep_App()                     --取消错误提示音   
                MotorNotConnectedFlg = 1
            end

        end 

        if(control==g_SetSNEnterButton and value==1)--切换SN码界面
        then
            SystemMode=5
            change_screen(5)
            KeyBeep_App()
        end  
    end

    if(control==g_SetKeyBoardButton and value==1)  --小键盘入口按键
    then
        Debugbuttoncnt=Debugbuttoncnt+1
        ClearDebugCnt=0  --每次按下清零 进入键盘界面后有5s秒时间输入代码
        if(Debugbuttoncnt==9)
        then
            Debugbuttoncnt=0
            set_visiable(g_SetScreenID,99,0)
            set_visiable(g_SetScreenID,98,1)
            KeyBeep_App()
        end
    end
    local COXOcode=0
    COXOcode=get_value(g_SetScreenID,98)
    --[[    取消马达切换功能
    if(COXOcode==2619)--马达切换    
    then
        MotorChangeFlag=MotorChangeFlag+1
        if(MotorChangeFlag==2)
        then
            MotorChangeFlag=0
        end
        FlashWriteMotorChangeBuf[0] = 1
        FlashWriteMotorChangeBuf[1] = MotorChangeFlag
        write_flash(4800,FlashWriteMotorChangeBuf)
        KeyBeep_App()

        set_value(3,98,0)
        set_visiable(3,99,1)
        set_visiable(3,98,0)--重置调试入口
    elseif(COXOcode==1793)--调试信息  
    ]]  
    if(COXOcode==1793)--调试信息
    then
        testmessageshowflag=testmessageshowflag+1
        if(testmessageshowflag==2)
        then
            testmessageshowflag=0
        end
        KeyBeep_App()

        set_value(g_SetScreenID,98,0)
        set_visiable(g_SetScreenID,99,1)
        set_visiable(g_SetScreenID,98,0)--重置调试入口        
    elseif(COXOcode==8888)--debug
    then
        DebugSetSpeed=2000--马达老化初值
        Debug_SetRunTime=10
        Debug_SetStopTime=5

        DebugStepMotorValue=3   --步进电机老化初值
        DebugStepMotorRunTime=5              
        DebugStepMotorStopTime=1   

        DebugDACSetValue=8     --设置最小DAC初值
        DebugTorqueSetValue=5   --设置扭力初值
        
        FirstTorqueADCfromMainBoard=2
        FirstSpeedDACfromMainBoard=2

        SystemMode=7
        change_screen(7)
        DebugScreen_Show()
        KeyBeep_App()

        set_visiable(7,30,1)  --启用遮盖白块
        set_visiable(7,31,1)
        set_visiable(7,27,0)  --ADC输入键盘取消   
        set_visiable(7,29,0)  --DAC输入键盘取消 

        set_value(3,98,0)
        set_visiable(3,99,1)
        set_visiable(3,98,0)--重置调试入口
    elseif(COXOcode==2953)--清除SN
    then
        SNInEnFlag=0x10
        SNCODE="ZZZZZZZZ"
        flush_flash()
        write_flash_string(5000,SNCODE)
        FlashWriteBuf3[0]=SNInEnFlag
        write_flash(4900,FlashWriteBuf3)
        SetScreen_Show()
        beep(500)

        set_value(3,98,0)
        set_visiable(3,99,1)
        set_visiable(3,98,0)--重置调试入口
    elseif(COXOcode==4836)--中英
    then
        Language=Language+1
        if(Language==2)
        then
            Language=0
        end
        FlashWriteBuf4[0]=Language
        FlashWriteBuf4[1]=1        --语言切换标志位
        write_flash(4920,FlashWriteBuf4)

        beep(300)
        set_value(3,98,0)
        set_visiable(3,99,1)
        set_visiable(3,98,0)--重置调试入口
    end

end

function SetScreen_Show()
    --中英文背景
    set_value(g_SetScreenID,g_SetScreenBackGround,Language+g_SetDarkModeFlag*2) 

    if(ResetFlag==0)
    then
        set_value(g_SetScreenID,g_SetResetIcon,0+Language*5+g_SetDarkModeFlag*10)  --恢复出厂设置图标
    end
    if(calibration==0 and calibrationErrorFlag==0)
    then
        set_value(g_SetScreenID,g_SetCalibrationIcon,0+Language*6+g_SetDarkModeFlag*12) --显示校准
    end

    testmessageshow()
    --声音开关
    set_value(g_SetScreenID,g_SetVolumeIcon,Voice+g_SetDarkModeFlag*2)    
    --背光调节
    set_value(g_SetScreenID,g_SetBacklightIcon,BackLight-1+g_SetDarkModeFlag*3)
    --深色模式开关
    set_value(g_SetScreenID,g_SetDarkModeIcon,g_SetDarkModeFlag+g_SetDarkModeFlag*2)  --默认 不开启
    --电机反转开关
    set_value(g_SetScreenID,g_SetReversalIcon,g_SetReversalFlag+g_SetDarkModeFlag*2)  --默认 开启
    --蓝牙
    if(BLEMatchFlag==1)     --匹配
    then
        if(BLEMatchTime<180)
        then
            set_value(g_SetScreenID,g_SetBleMatchIcon,BLEMatchTime%4+1+g_SetDarkModeFlag*6)         --配对动态显示
        else
            set_value(g_SetScreenID,g_SetBleMatchIcon,7+g_SetDarkModeFlag*6)                        --超时显示红色图标
        end
    elseif(BLEMatchFlag==2)                         --断开
    then
        set_value(g_SetScreenID,g_SetBleMatchIcon,8+g_SetDarkModeFlag*6)   --断开过程中显示橙色图标
    else        --无动作
        if(BLE_Staus==0)            
        then
            set_value(g_SetScreenID,g_SetBleMatchIcon,0+g_SetDarkModeFlag*6)
        elseif(BLE_Staus==1)
        then
            set_value(g_SetScreenID,g_SetBleMatchIcon,4+g_SetDarkModeFlag*6)
        elseif(BLE_Staus==2)
        then
            set_value(g_SetScreenID,g_SetBleMatchIcon,5+g_SetDarkModeFlag*6)
        end
    end 
    set_text(g_SetScreenID,103,"校准标志："..calibration)

    --版本号
    local Mvision1=0
    local Mvision2=0
    local Mvision3=0
    local Fvision1=0
    local Fvision2=0
    local Fvision3=0

    --[[Mvision1=MainVision>>5
    Mvision2=MainVision & 0x1F
    Fvision1=FootVision>>5
    Fvision2=FootVision & 0x1F]]
    Mvision1=MainVision//100
    Mvision2=MainVision%100//10
    Mvision3=MainVision%10

    Fvision1=FootVision//100
    Fvision2=FootVision%100//10
    Fvision3=FootVision%10

    --SN码
    local sncode1="ZZZZ"
	local sncode2="ZZZZ"
	local sncode3="ZZZZ-ZZZZ"

	sncode1=string.sub(SNCODE,1,4)
	sncode2=string.sub(SNCODE,5,8)
	sncode3=sncode1..'-'..sncode2
	set_text(g_SetScreenID,g_SetQRCode,sncode3)

    if g_SetDarkModeFlag == 1 then
        set_text(g_SetScreenID,g_SetInterfaceVerText_Black,ScreenVision)
        --set_text(3,19,'Ver_'..Mvision1..'.0.'..Mvision2)
        --set_text(3,20,'Ver_'..Fvision1..'.0.'..Fvision2)
        set_text(g_SetScreenID,g_SetMainControlVerText_Black,'Ver '..Mvision1..'.'..Mvision2..'.'..Mvision3)
        set_text(g_SetScreenID,g_SetFootVerText_Black,'Ver '..Fvision1..'.'..Fvision2..'.'..Fvision3) 
        
        set_text(g_SetScreenID,g_SetQRCodeText_Black,sncode3)

        set_visiable(g_SetScreenID,g_SetInterfaceVerText_Black,1)
        set_visiable(g_SetScreenID,g_SetMainControlVerText_Black,1)
        set_visiable(g_SetScreenID,g_SetFootVerText_Black,1)
        set_visiable(g_SetScreenID,g_SetQRCodeText_Black,1)
        set_visiable(g_SetScreenID,g_SetFirmwareVerText_Black,1)

        set_visiable(g_SetScreenID,g_SetInterfaceVerText,0)
        set_visiable(g_SetScreenID,g_SetMainControlVerText,0)
        set_visiable(g_SetScreenID,g_SetFootVerText,0)
        set_visiable(g_SetScreenID,g_SetQRCodeText,0)
        set_visiable(g_SetScreenID,g_SetFirmwareVerText,0)
    else
        set_text(g_SetScreenID,g_SetInterfaceVerText,ScreenVision)
        --set_text(3,19,'Ver_'..Mvision1..'.0.'..Mvision2)
        --set_text(3,20,'Ver_'..Fvision1..'.0.'..Fvision2)
        set_text(g_SetScreenID,g_SetMainControlVerText,'Ver '..Mvision1..'.'..Mvision2..'.'..Mvision3)
        set_text(g_SetScreenID,g_SetFootVerText,'Ver '..Fvision1..'.'..Fvision2..'.'..Fvision3) 
        
        set_text(g_SetScreenID,g_SetQRCodeText,sncode3)

        set_visiable(g_SetScreenID,g_SetInterfaceVerText,1)
        set_visiable(g_SetScreenID,g_SetMainControlVerText,1)
        set_visiable(g_SetScreenID,g_SetFootVerText,1)
        set_visiable(g_SetScreenID,g_SetQRCodeText,1)
        set_visiable(g_SetScreenID,g_SetFirmwareVerText,1)

        set_visiable(g_SetScreenID,g_SetInterfaceVerText_Black,0)
        set_visiable(g_SetScreenID,g_SetMainControlVerText_Black,0)
        set_visiable(g_SetScreenID,g_SetFootVerText_Black,0)
        set_visiable(g_SetScreenID,g_SetQRCodeText_Black,0)
        set_visiable(g_SetScreenID,g_SetFirmwareVerText_Black,0)
    end



    if(SNInEnFlag==0x01)then      --SN码输入图标显示一体
        set_visiable(g_SetScreenID,g_SetSNEnterButton,0)
        set_enable(g_SetScreenID,g_SetSNEnterButton,0)
    elseif(SNInEnFlag==0x10)then
        set_visiable(g_SetScreenID,g_SetSNEnterButton,1)
        set_enable(g_SetScreenID,g_SetSNEnterButton,1)
    end

    set_text(g_SetScreenID,102,'FootType='..FootType)
    set_text(g_SetScreenID,100,'WirelessFootBat='..WirelessFootBat)
    set_text(g_SetScreenID,101,'BLE_Staus='.. BLE_Staus)

end

function StateView()--状态栏
    --声音图标
    if(Voice==1)
    then
        set_value(1,Status_Bar_Voice,ENABLE+g_SetDarkModeFlag*2)
        set_value(2,Status_Bar_Voice,ENABLE+g_SetDarkModeFlag*2)
    else
        set_value(1,Status_Bar_Voice,DISABLE+g_SetDarkModeFlag*2)
        set_value(2,Status_Bar_Voice,DISABLE+g_SetDarkModeFlag*2)
    end 
    --脚踏图标
    if((FootType & 0x01)==0x01)--有线脚踏   
    then
        set_value(1,Status_Bar_FootPower,4+g_SetDarkModeFlag*5) --电池图标显示背景色
        set_value(2,Status_Bar_FootPower,4+g_SetDarkModeFlag*5) --电池图标显示背景色
        set_value(1,Status_Bar_Ble,DISABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(2,Status_Bar_Ble,DISABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(1,Status_Bar_Foot,0+g_SetDarkModeFlag)
        set_value(2,Status_Bar_Foot,0+g_SetDarkModeFlag)
        set_visiable(1,Status_Bar_Foot,ENABLE)--脚踏
        set_visiable(2,Status_Bar_Foot,ENABLE)--脚踏
    elseif((FootType & 0x02)==0x02) --无线脚踏 
    then
        set_value(1,Status_Bar_FootPower,WirelessFootBat+g_SetDarkModeFlag*5)    --电池图标
        set_value(2,Status_Bar_FootPower,WirelessFootBat+g_SetDarkModeFlag*5)
        set_value(1,Status_Bar_Ble,ENABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(2,Status_Bar_Ble,ENABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(1,Status_Bar_Foot,0+g_SetDarkModeFlag)
        set_value(2,Status_Bar_Foot,0+g_SetDarkModeFlag)
    else--无脚踏
        set_value(1,Status_Bar_FootPower,4+g_SetDarkModeFlag*5) --电池图标显示背景色
        set_value(2,Status_Bar_FootPower,4+g_SetDarkModeFlag*5) --电池图标显示背景色
        set_value(1,Status_Bar_Ble,DISABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(2,Status_Bar_Ble,DISABLE+g_SetDarkModeFlag*2) --蓝牙图标
        set_value(1,Status_Bar_Foot,0+g_SetDarkModeFlag)
        set_value(2,Status_Bar_Foot,0+g_SetDarkModeFlag)
        set_visiable(1,Status_Bar_Foot,TwinkleFlag)--脚踏
        set_visiable(2,Status_Bar_Foot,TwinkleFlag)--脚踏
    end
    --手柄图标
    if(MotorHandleFlag==1 and MotorState==0x04) --检测到马达异常 显示红色手柄
    then
        set_visiable(1,Status_Bar_Motor,ENABLE)
        set_visiable(2,Status_Bar_Motor,ENABLE)
        set_value(1,Status_Bar_Motor,ENABLE+g_SetDarkModeFlag*2)
        set_value(2,Status_Bar_Motor,ENABLE+g_SetDarkModeFlag*2)           
    elseif(MotorHandleFlag==1)
    then
        set_visiable(1,Status_Bar_Motor,ENABLE)
        set_visiable(2,Status_Bar_Motor,ENABLE)
        set_value(1,Status_Bar_Motor,0+g_SetDarkModeFlag*2)
        set_value(2,Status_Bar_Motor,0+g_SetDarkModeFlag*2)
    elseif(MotorHandleFlag == 3 or MotorHandleFlag == 0)              --程序无法进去所以无法显示
    then
        --set_visiable(1,Status_Bar_Motor,ENABLE)
        --set_visiable(2,Status_Bar_Motor,ENABLE)
        set_value(1,Status_Bar_Motor,DISABLE+g_SetDarkModeFlag*2)
        set_value(2,Status_Bar_Motor,DISABLE+g_SetDarkModeFlag*2)
    end
end

function WindowScreen_Run(control,value)

    if(POP_WindowNum == 1)then --  恢复出厂设置
        if(control == g_PopLeftButton and value==1)then --删除确认按键
            change_screen(3) --设置界面
            SystemMode=3
            POP_WindowNum=0
            ResetFlag=1
            start_timer(g_SetResetTime, 250, 0, 0)     --复位计时250ms
            SetScreen_Show()

            KeyBeep_App() --按键音
        elseif(control == g_PopRightButton and value==1)then --取消按键
            change_screen(3) --设置界面
            SystemMode=3
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end
    elseif(POP_WindowNum == 2)then --  蓝牙配对
        if(control == g_PopLeftButton and value==1)then --点击继续，进行蓝牙配对
            BLEMatchFlag=1
            BLEMatchTime=0
            start_timer(g_SetResetTime, 250, 0, 0)           --计时            
            SetScreen_Show()
            KeyBeep_App() --按键音
        elseif(control == g_PopRightButton and value==1)then --取消按键
            BLEMatchFlag=0
            BLEMatchTime=0
            change_screen(3)
            SystemMode=3
            SetScreen_Show()
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end
    elseif(POP_WindowNum == 3)then --蓝牙断开配对
        if(control == g_PopLeftButton and value==1)then --点击继续，断开配对
            BLEMatchFlag=2
            BLEMatchTime=0
            start_timer(5, 250, 0, 0)       
            SetScreen_Show()
            KeyBeep_App() --按键音
        elseif(control == g_PopRightButton and value==1)then --取消按键
            BLEMatchFlag=0
            BLEMatchTime=0
            change_screen(3)
            SystemMode=3
            SetScreen_Show()
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end    
    elseif(POP_WindowNum == 4)then -- 蓝牙配对失败重试
        if(control == g_PopLeftButton and value==1)then --点击重试，重新配对
            BLEMatchFlag=1             
            BLEMatchTime=0
            start_timer(5, 250, 0, 0)  --计时
            KeyBeep_App() --按键音
        elseif(control == g_PopRightButton and value==1)then --取消按键
            BLEMatchFlag=0
            BLEMatchTime=0
            change_screen(3)
            SystemMode=3
            SetScreen_Show()
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end           
    elseif(POP_WindowNum == 5)then --  蓝牙配对中取消
        if(control ==  g_PopMiddleButton and value==1)then --点击取消，取消配对
            BLEMatchFlag=3
            BLEMatchTime=0
            start_timer(5, 250, 0, 0)  --计时
            POP_WindowNum=6           --正在取消中弹窗
            WindowScreen_Show()
            KeyBeep_App() --按键音
        end     
    elseif(POP_WindowNum == 7)then --  蓝牙脚踏电量不足
        if(control ==  g_PopMiddleButton and value==1)then --点击确定
            Warnbeepflag=0
            Popflag=0      

            WirelessFootBatTime=0--清除低电量弹窗计时
            Errbeepstep=0        --清除低电量响声
            FootLowPowerBeep=0

            SystemMode=SystemModeBeforSet 
        
            if(SystemMode==4 and g_IM_WashingFlag == 0) then  --蓝牙弹窗界面上报异常
                BLEMatchFlag=0
                BLEMatchTime=0
                stop_timer(5)--如果在蓝牙配对中断开通信 需要清零

                SystemMode=3
                SystemModeBeforSet=1
            elseif(SystemMode==4 and g_IM_WashingFlag == 1) then--种植弯机清洗弹窗界面上报异常
                g_IM_WashingFlag = 0      --弯机清洗标志位
                g_IM_WashingCnt = 0       --弯机清洗计数器
                SystemMode=IMScreenID
                stop_timer(g_IM_WashingTime)
            
                SystemModeBeforSet=IMScreenID
            end     
               
            change_screen(SystemMode)  
            System_Mode_Screen_Change_Show(SystemMode)  --切换页面
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end     
    elseif(POP_WindowNum == 8)then --  马达未连接
        if(control ==  g_PopMiddleButton and value==1)then --点击确定
            Warnbeepflag=0
            Popflag=0      

            SystemMode=SystemModeBeforSet 
        
            if(SystemMode==4 and g_IM_WashingFlag == 0) then  --蓝牙弹窗界面上报异常
                BLEMatchFlag=0
                BLEMatchTime=0
                stop_timer(5)--如果在蓝牙配对中断开通信 需要清零

                SystemMode=3
                SystemModeBeforSet=1
            elseif(SystemMode==4 and g_IM_WashingFlag == 1) then--种植弯机清洗弹窗界面上报异常
                g_IM_WashingFlag = 0      --弯机清洗标志位
                g_IM_WashingCnt = 0       --弯机清洗计数器
                SystemMode=IMScreenID
                stop_timer(g_IM_WashingTime)
            
                SystemModeBeforSet=IMScreenID
            end     
               
            change_screen(SystemMode)  
            System_Mode_Screen_Change_Show(SystemMode)  --切换页面
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end  
    elseif(POP_WindowNum == 10)then --  蓝牙错误
        if(control ==  g_PopMiddleButton and value==1)then --点击确定
            Warnbeepflag=0
            Popflag=0      

            SystemMode=SystemModeBeforSet 
        
            if(SystemMode==4 and g_IM_WashingFlag == 0) then  --蓝牙弹窗界面上报异常
                BLEMatchFlag=0
                BLEMatchTime=0
                stop_timer(5)--如果在蓝牙配对中断开通信 需要清零

                SystemMode=3
                SystemModeBeforSet=1
            elseif(SystemMode==4 and g_IM_WashingFlag == 1) then--种植弯机清洗弹窗界面上报异常
                g_IM_WashingFlag = 0      --弯机清洗标志位
                g_IM_WashingCnt = 0       --弯机清洗计数器
                SystemMode=IMScreenID
                stop_timer(g_IM_WashingTime)
            
                SystemModeBeforSet=IMScreenID
            end     
               
            change_screen(SystemMode)  
            System_Mode_Screen_Change_Show(SystemMode)  --切换页面
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end          
    elseif(POP_WindowNum == 9)then --  通信异常
        if(control ==  g_PopMiddleButton and value==1)then --点击确定
            Warnbeepflag=0
            Popflag=0      

            UartErroTime=0   --计时清零

            SystemMode=SystemModeBeforSet 
        
            if(SystemMode==4 and g_IM_WashingFlag == 0) then  --蓝牙弹窗界面上报异常
                BLEMatchFlag=0
                BLEMatchTime=0
                stop_timer(5)--如果在蓝牙配对中断开通信 需要清零

                SystemMode=3
                SystemModeBeforSet=1
            elseif(SystemMode==4 and g_IM_WashingFlag == 1) then--种植弯机清洗弹窗界面上报异常
                g_IM_WashingFlag = 0      --弯机清洗标志位
                g_IM_WashingCnt = 0       --弯机清洗计数器
                SystemMode=IMScreenID
                stop_timer(g_IM_WashingTime)
            
                SystemModeBeforSet=IMScreenID
            end     
               
            change_screen(SystemMode)  
            System_Mode_Screen_Change_Show(SystemMode)  --切换页面
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end            
    elseif(POP_WindowNum == 11)then --  马达异常
        if(control ==  g_PopMiddleButton and value==1)then --点击确定
            Warnbeepflag=0
            Popflag=0      

            SystemMode=SystemModeBeforSet 
        
            if(SystemMode==4 and g_IM_WashingFlag == 0) then  --蓝牙弹窗界面上报异常
                BLEMatchFlag=0
                BLEMatchTime=0
                stop_timer(5)--如果在蓝牙配对中断开通信 需要清零

                SystemMode=3
                SystemModeBeforSet=1
            elseif(SystemMode==4 and g_IM_WashingFlag == 1) then--种植弯机清洗弹窗界面上报异常
                g_IM_WashingFlag = 0      --弯机清洗标志位
                g_IM_WashingCnt = 0       --弯机清洗计数器
                SystemMode=IMScreenID
                stop_timer(g_IM_WashingTime)
            
                SystemModeBeforSet=IMScreenID
            end     
               
            change_screen(SystemMode)  
            System_Mode_Screen_Change_Show(SystemMode)  --切换页面
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end                            
    elseif(POP_WindowNum == 12)then --删除用户
        if(control == g_PopLeftButton and value==1)then --删除确认按键

            SystemMode=8
            change_screen(8)
            POP_WindowNum=0
            Delete_User() 
            g_UserDataChangeFlag =0x00                   --用户数据改变标志位 清零

            g_UserTatolNum = g_TempUserTatolNum     --用户总数量
            for i=1,3,1 do
            UserIDBuf[i] =  TempUserIDBuf[i]        --用户编号（默认）按123排列
            end
            for i=1,3,1 do
            UserNameBuf[i] = TempUserNameBuf[i] 
            end 

            KeyBeep_App() --按键音
            DataWriteFlash_UserScreen()
            StartFlashWrite_App()    --保存写flash
        elseif(control == g_PopRightButton and value==1)then --取消按键

            SystemMode=8
            change_screen(8)
            POP_WindowNum=0
            g_DeleteFirstUserFlag = 0x00        --标志问清零防止误删除
            g_DeleteSecondUserFlag = 0x00       --标志问清零防止误删除
            g_DeleteThreeUserFlag = 0x00        --标志问清零防止误删除
            KeyBeep_App() --按键音
        end 
    elseif(POP_WindowNum == 13)then --自动清洗
        if(control == g_PopLeftButton and value==1)then --点击开始，自动清洗，切换弹窗
            g_IM_WashingFlag = 1      --弯机清洗标志位
            g_IM_WashingCnt = 30       --弯机清洗计数器
            start_timer(g_IM_WashingTime, 1000, 0, 0)           --自动清洗计时 1s 
            
            change_child_screen(4)   
            SystemMode=4
            POP_WindowNum=20        --切换到倒计时弹窗
            WindowScreen_Show()

            WindowScreen_WashingNumber(g_IM_WashingCnt)   
            KeyBeep_App() --按键音      
        elseif(control == g_PopRightButton and value==1)then --取消按键，返回种植界面
            g_IM_WashingFlag = 0      --弯机清洗标志位
            g_IM_WashingCnt = 0       --弯机清洗计数器
            change_screen(IMScreenID)
            SystemMode=IMScreenID
            IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end
    elseif(POP_WindowNum == 14)then --是否保存数据
        if g_UserDataChangeFlag == 0x01 then  --用户设置界面 
            if(control == g_PopMiddleButton and value==1)then        --不保存按钮
                SystemMode=8
                change_screen(8)
                POP_WindowNum=0
                if g_UserTatolNum == 0 then
                    ResetData_AllUser()  -- 清空所有用户和数据
                end
                g_UserSetFlag = 0
                UserScreen_Show()
                --start_timer(g_UserCountBackTime_1s, 1000, 0, 0) --开启倒数定时器
                g_UserDataChangeFlag =0x00                   --清空用户数据标改变志位
                KeyBeep_App() --按键音
            elseif(control == g_PopLeftButton and value==1)then  --保存按钮
                SystemMode=8
                change_screen(8)
                POP_WindowNum=0
    
                g_UserSetFlag = 0
                g_UserTatolNum = g_TempUserTatolNum     --用户总数量
                for i=1,3,1 do
                UserIDBuf[i] =  TempUserIDBuf[i]        --用户编号（默认）按123排列
                end
                for i=1,3,1 do
                UserNameBuf[i] = TempUserNameBuf[i] 
                end
                DataWriteFlash_UserScreen() 
                StartFlashWrite_App()    --保存写flash   --写flash     
                UserScreen_Show()
                --start_timer(g_UserCountBackTime_1s, 1000, 0, 0) --开启倒数定时器
                g_UserDataChangeFlag =0x00                   --清空用户数据标改变志位
                KeyBeep_App() --按键音
            elseif(control == g_PopRightButton and value==1)then   --取消按钮
                SystemMode=8
                change_screen(8)
                POP_WindowNum=0
                KeyBeep_App() --按键音
            end
        elseif IM_Set_DataChangeFlag == 0x01 then   --种植步骤编辑页面
            if(control == g_PopMiddleButton and value==1)then        --不保存按钮
                SystemMode=1
                change_screen(1)
                POP_WindowNum=0
    
                IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                IM_Set_DataChangeFlag = 0     --标志位清零
                KeyBeep_App() --按键音
            elseif(control == g_PopLeftButton and value==1)then  --保存按钮
                SystemMode=1
                change_screen(1)
                POP_WindowNum=0
                IM_Set_Screen_Save(g_CurrentUser,Promgrame[g_CurrentUser], 1, 1)
                DataWriteFlash_StepSetScreen()
                StartFlashWrite_App()    --保存写flash
                IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                IM_Set_DataChangeFlag = 0     --标志位清零
                KeyBeep_App() --按键音
            elseif(control == g_PopRightButton and value==1)then   --取消按钮
                SystemMode=1
                change_screen(11)
                POP_WindowNum=0
                KeyBeep_App() --按键音
            end            
            
        end
    elseif(POP_WindowNum == 15)then --显示没检测到设备
        if(control == g_PopMiddleButton and value==1)then --OK按键

            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)
            POP_WindowNum=0
            KeyBeep_App() --按键音
            StartFlashWrite_App()
        end    
    elseif(POP_WindowNum == 16)then --清空用户恢复默认数据 

        if(control == g_PopMiddleButton and value==1)then --取消按键

            SystemMode=8
            change_screen(8)
            POP_WindowNum=0

            ResetData_AllUser()  -- 清空所有用户和数据

            g_UserSetFlag = 0
            UserScreen_Show()
            --start_timer(g_UserCountBackTime_1s, 1000, 0, 0) --开启倒数定时器
            KeyBeep_App() --按键音
            StartFlashWrite_App()
        end
    elseif(POP_WindowNum == 17)then --显示数据保存成功
        if(control == g_PopMiddleButton and value==1)then --OK按键

            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)
            POP_WindowNum=0
            KeyBeep_App() --按键音
            StartFlashWrite_App()
        end 
    elseif(POP_WindowNum == 18)then --显示数据保存失败
        if(control == g_PopMiddleButton and value==1)then --OK按键

            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)
            POP_WindowNum=0
            KeyBeep_App() --按键音
            StartFlashWrite_App()
        end 
    elseif(POP_WindowNum == 19)then --弯机清洗完成
        if(control == g_PopMiddleButton and value==1)then --确认按键
            g_IM_WashingFlag = 0      --弯机清洗标志位
            g_IM_WashingCnt = 0       --弯机清洗计数器
            change_screen(IMScreenID)
            SystemMode=IMScreenID
            IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
            POP_WindowNum=0
            KeyBeep_App() --按键音
        end
    elseif(POP_WindowNum == 20)then --弯机清洗倒计时

        if(control == g_PopMiddleButton and value==1)then --取消按键
            g_IM_WashingFlag = 0      --弯机清洗标志位
            g_IM_WashingCnt = 0       --弯机清洗计数器
            --change_screen(IMScreenID)
            --SystemMode=IMScreenID
            --IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
            --POP_WindowNum=0
            WindowScreen_WashingNumber(30)
            g_IM_WashingCancleFlag = 1
            g_IM_WashingCancleCnt = 0
            stop_timer(g_IM_WashingTime)
            start_timer(g_IM_WashingCancleTime, 500, 0, 0) --开启倒数定时器
            KeyBeep_App() --按键音
        end    
    end
end

function WindowScreen_Show()
    if(POP_WindowNum == 1)then --复位
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --恢复出厂设置继续
        set_enable(4,g_PopRightButton,1)      --恢复出厂设置取消
        set_enable(4,g_PopMiddleButton,0)      --中间不用按钮
    elseif(POP_WindowNum == 2)then --蓝牙配对，显示继续
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --蓝牙配对继续
        set_enable(4,g_PopRightButton,1)      --蓝牙取消
        set_enable(4,g_PopMiddleButton,0)      --中间不用按钮
    elseif(POP_WindowNum == 3)then --蓝牙断开配对
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --蓝牙断开配对，继续
        set_enable(4,g_PopRightButton,1)      --蓝牙取消
        set_enable(4,g_PopMiddleButton,0)      --中间不用按钮
    elseif(POP_WindowNum == 4)then -- 蓝牙配对失败重试
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --蓝牙重试配对
        set_enable(4,g_PopRightButton,1)      --蓝牙取消
        set_enable(4,g_PopMiddleButton,0)      --中间不用按钮
    elseif(POP_WindowNum == 5)then --  蓝牙中断配对
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏
        set_enable(4,g_PopMiddleButton,1)      --中间按钮取消    
    elseif(POP_WindowNum == 6)then  --  蓝牙正在中断配对
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏
        set_enable(4,g_PopMiddleButton,1)      --中间按钮取消 
    elseif(POP_WindowNum == 7)then      --  蓝牙脚踏电量不足
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,1)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏  
    elseif(POP_WindowNum == 8)then      --  马达未连接弹窗
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,1)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏
    elseif(POP_WindowNum == 9)then      --  通信异常
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,1)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏
    elseif(POP_WindowNum == 10)then      --  蓝牙错误
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,1)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏
    elseif(POP_WindowNum == 11)then      --  马达异常
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,1)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏        
    elseif(POP_WindowNum == 12) then    -- 12-删除用户弹窗
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --删除用户确认
        set_enable(4,g_PopRightButton,1)      --删除用户取消
        set_enable(4,g_PopMiddleButton,0)      --删除用户取消
    elseif(POP_WindowNum == 13) then    -- 13 自动清洗弹窗
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --蓝牙配对继续
        set_enable(4,g_PopRightButton,1)      --蓝牙取消
        set_enable(4,g_PopMiddleButton,0)     --中间不用按钮
    elseif(POP_WindowNum == 14) then    -- 14-是否保存数据
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,1)       --保存
        set_enable(4,g_PopRightButton,1)      --不保存
        set_enable(4,g_PopMiddleButton,1)      --取消 
    elseif(POP_WindowNum == 15) then    -- 15 显示检测不到设备
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        set_enable(4,g_PopMiddleButton,1)      --中间按钮                   
    elseif(POP_WindowNum == 16) then     -- 16-删除数据恢复默认
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        set_enable(4,g_PopMiddleButton,1)      -- 确认按键
    elseif(POP_WindowNum == 17) then    -- 17 显示数据保存成功
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        set_enable(4,g_PopMiddleButton,1)      --中间按钮
    elseif(POP_WindowNum == 18) then    -- 18 显示数据保存失败
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        set_enable(4,g_PopMiddleButton,1)      --中间按钮                
    elseif(POP_WindowNum == 19) then     -- 19-弯机清洗完成
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        set_enable(4,g_PopMiddleButton,1)      -- 取消按键               
    elseif(POP_WindowNum == 20) then     -- 20-弯机清洗倒计时
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopLeftButton,0)       --
        set_enable(4,g_PopRightButton,0)      --
        if g_IM_WashingCancleFlag == 1 then
            set_enable(4,g_PopMiddleButton,0)      -- 取消按键    
        else   
            set_enable(4,g_PopMiddleButton,1)      -- 取消按键 
        end 
    elseif(POP_WindowNum == 21)then      --  马达未连接弹窗，无确认按键
        set_value(4,g_PopScreenIcon,POP_WindowNum-1+Language*21+g_SetDarkModeFlag*42)
        set_enable(4,g_PopMiddleButton,0)      --中间按钮确认   
        set_enable(4,g_PopLeftButton,0)       --左键隐藏
        set_enable(4,g_PopRightButton,0)      --右键隐藏                     
    end    
    WindowScreen_WashingNumber(g_IM_WashingCnt) --清洗数字清零     
end
-----------------------------------------------------------------------------
--@program:TorqueNumber_Display
--@brief:扭矩数字显示
--@param:Number:倒数计时
--@return:无
-------------------------------------------------------------------------------
function WindowScreen_WashingNumber(Number)

    if g_IM_WashingFlag ~= 1 and g_IM_WashingCancleFlag == 0 then
        set_visiable(4,g_PopWashingFirstNumIcon,DISABLE)           --显示/隐藏
        set_visiable(4,g_PopWashingSecondNumIcon,DISABLE)          --显示/隐藏
    else
        if Number < 10 then
            set_value(4,g_PopWashingFirstNumIcon,Number%10+g_SetDarkModeFlag*10)
            set_value(4,g_PopWashingSecondNumIcon,0+g_SetDarkModeFlag*10)

            set_visiable(4,g_PopWashingFirstNumIcon,ENABLE)           --显示/隐藏
            set_visiable(4,g_PopWashingSecondNumIcon,ENABLE)          --显示/隐藏
        elseif Number >= 10 and Number < 100 then
            set_value(4,g_PopWashingSecondNumIcon,Number//10%10+g_SetDarkModeFlag*10)
            set_value(4,g_PopWashingFirstNumIcon,Number%10+g_SetDarkModeFlag*10)

            set_visiable(4,g_PopWashingFirstNumIcon,ENABLE)           --显示/隐藏
            set_visiable(4,g_PopWashingSecondNumIcon,ENABLE)          --显示/隐藏
        end
    end
end
-----------------------------------------------------------------------------
--@program:TorqueNumber_Display
--@brief:只用于清洗显示30s
--@param:Number:倒数计时
--@return:取消判断，其它地方不能用
-------------------------------------------------------------------------------
function WindowScreen_WashingNumber_Cancle(Number)
    if Number < 10 then
        set_value(4,g_PopWashingFirstNumIcon,Number%10+g_SetDarkModeFlag*10)
        set_value(4,g_PopWashingSecondNumIcon,0+g_SetDarkModeFlag*10)

        set_visiable(4,g_PopWashingFirstNumIcon,ENABLE)           --显示/隐藏
        set_visiable(4,g_PopWashingSecondNumIcon,ENABLE)          --显示/隐藏
    elseif Number >= 10 and Number < 100 then
        set_value(4,g_PopWashingSecondNumIcon,Number//10%10+g_SetDarkModeFlag*10)
        set_value(4,g_PopWashingFirstNumIcon,Number%10+g_SetDarkModeFlag*10)

        set_visiable(4,g_PopWashingFirstNumIcon,ENABLE)           --显示/隐藏
        set_visiable(4,g_PopWashingSecondNumIcon,ENABLE)          --显示/隐藏
    end
end
function ClearDebugSet()
    --马达老化
    Debug_MotorState=0
    Runtime=0                             --调试模式马达老化运行/停止计时
    Debug_MotorTestCnt=0                  --老化次数 一次=运行时间+停止时间 
    --步进电机老化
    Debug_StepMotorState=0                --步进电机开启老化状态
    StepMotorRuntime=0                    --运行时间
    Debug_SetpMotorTestCnt=0              --老化次数 一次=运行时间+停止时间
end    

function DebugScreen_Run(control,value)
    if(control==25 and value==1)    --退出键
    then
        ClearDebugSet()
        SystemMode=3
        change_screen(3) 
        SetScreen_Show()
        KeyBeep_App()
    end
    if(control==6 and value==1)  --马达启停
    then
        if(Debug_MotorState==0)
        then
            Debug_MotorState=1
            DebugMotorRun=1
            start_timer(10,1000,0,0)
        else
            Debug_MotorState=0
            DebugMotorRun=0
            Runtime=0
            Debug_MotorTestCnt=0
            --Debug_MotorOnTime=0
            stop_timer(10)
        end
        KeyBeep_App()
    end
    if(control==13 and value==1)  --步进电机启停
    then
        if(Debug_StepMotorState==0)
        then
            Debug_StepMotorState=1
            DebugStepMotorRun=1
        else
            Debug_StepMotorState=0
            DebugStepMotorRun=0
            StepMotorRuntime=0                    
            Debug_SetpMotorTestCnt=0             
        end
        KeyBeep_App()
    end
    if(control==7 and value==1) --水量+
    then
        if(DebugStepMotorValue<4)
        then
            DebugStepMotorValue=DebugStepMotorValue+1
            KeyBeep_App()
        end
    end
    if(control==8 and value==1) --水量-
    then
        if(DebugStepMotorValue>0)
        then
            if(Debug_StepMotorState==1)
            then
                if(DebugStepMotorValue>1)
                then
                    DebugStepMotorValue=DebugStepMotorValue-1
                end              
            else
                DebugStepMotorValue=DebugStepMotorValue-1
            end
            KeyBeep_App()
        end
        
    end

    if(control==20 and (value==1 or value==2))       --蓝牙复位初始化
    then
        if(Debug_FootState==2 and DebugBleReset==0)
        then
            DebugBleReset=1
            KeyBeep_App()
        end 
    else
        DebugBleReset=0   
    end

    if(control==33 and value==1 and DebugDacAdcSetFlag==1)  --上传扭力数组下标值+   1-9
    then
        ToruqeBufNum=ToruqeBufNum+1
        if(ToruqeBufNum>9)
        then
            ToruqeBufNum=1
        end
        DebugTorqueSetValue=DebugTorqueBuf[ToruqeBufNum]
        FirstTorqueADCfromMainBoard=2
        KeyBeep_App()
    end 

    if(control==34 and value==1 and DebugDacAdcSetFlag==1)  --上传扭力数组下标值-   1-9
    then
        ToruqeBufNum=ToruqeBufNum-1
        if(ToruqeBufNum<1)
        then
            ToruqeBufNum=9
        end
        DebugTorqueSetValue=DebugTorqueBuf[ToruqeBufNum]
        FirstTorqueADCfromMainBoard=2
        KeyBeep_App()
    end 

    if(control==36 and value==1)  --DAC保存按键  马达运行的时候无法保存
    then
        if(DebugDACSetFlag==0 and Debug_MotorState==0 and DebugDacAdcSetFlag==1)
        then
            DebugDACSetFlag=1       
            KeyBeep_App()
        end
    end
    if(control==43 and value==1)  --DAC复位按键  马达运行的时候无法保存
    then
        if(DebugDACResetFlag==0 and Debug_MotorState==0 and DebugDacAdcSetFlag==1)
        then
            DebugDACResetFlag=1 
            FirstSpeedDACfromMainBoard=2      
            KeyBeep_App()
        end       
    end

    if(control==40 and value==1)  --ADC保存按键 马达运行的时候无法保存
    then
        if(DebugADCSetFlag==0 and Debug_MotorState==0 and DebugDacAdcSetFlag==1)
        then
            if(DebugADCSetValue>DebugAdcSetValue_MaxMin[1][ToruqeBufNum] and DebugADCSetValue<DebugAdcSetValue_MaxMin[2][ToruqeBufNum])  
            then  --键盘设置的值在数组范围内才能进行保存
                DebugADCSetFlag=1   
                KeyBeep_App()
            else
                ErroBeep_App()   
            end                          
        end
    end

    if(control==45 and value==1)  --ADC复位按键  马达运行的时候无法保存
    then
        if(DebugADCResetFlag==0 and Debug_MotorState==0 and DebugDacAdcSetFlag==1)
        then
            DebugADCResetFlag=1 
            ToruqeBufNum=1  
            DebugADCSetValue=DebugAdcStandardValue[ToruqeBufNum]  --获取标准值
            DebugTorqueSetValue=DebugTorqueBuf[ToruqeBufNum]
            set_value(7,27,DebugADCSetValue)   --获取标准值后修改到键盘
            KeyBeep_App()
        end
        
    end

    DebugSetSpeed=get_value(7,1)--速度获取
    Debug_SetRunTime=get_value(7,3)--运行时间
    Debug_SetStopTime=get_value(7,4)--停止时间

    DebugStepMotorRunTime=get_value(7,10)--运行时间
    DebugStepMotorStopTime=get_value(7,11)--停止时间

    if(DebugDacAdcSetFlag==1)
    then
        DebugDACSetValue=get_value(7,29)--DAC键盘值   
        DebugADCSetValue=get_value(7,27)--ADC键盘值
    end

    local DEBUGcode=0
    DEBUGcode=get_value(7,42)
    if(DEBUGcode==6752)--微调开启    
    then
        DebugDacAdcSetFlag=1
        set_visiable(7,30,0)  --取消遮盖白块
        set_visiable(7,31,0)
        set_visiable(7,27,1)  --ADC输入键盘开启   
        set_visiable(7,29,1)  --DAC输入键盘开启   
    end

end
function DebugScreen_Show()
    local ber=0

    set_value(7,12,Debug_MotorState)   
    set_value(7,5,Debug_MotorTestCnt)--马达测试次数
    set_value(7,2,Debug_MotoSpeed)--主板发回来的实时速度

    set_value(7,14,Debug_StepMotorState)  --步进电机运行图标
    set_value(7,9,DebugStepMotorValue)  --步进电机档位
    set_value(7,41,Debug_SetpMotorTestCnt)  --步进电机运行次数

    set_value(7,26,Debug_TorqueADC)--接收主板 速度最小DAC值
    set_value(7,28,Debug_MinDacValue)--接收主板 扭力ADC值
                     
    set_value(7,32,DebugTorqueSetValue) --上传 扭力

    set_value(7,35,DebugDACSetFlag)  --DAC保存按键图标
    set_value(7,38,DebugDACResetFlag) --DAC复位按键图标

    set_value(7,39,DebugADCSetFlag) --ADC保存按键图标
    set_value(7,44,DebugADCResetFlag) --ADC复位按键图标

    --脚踏类型     
    if(Debug_FootState==0)
    then
        set_text(7,15,"无连接")
    elseif(Debug_FootState==1)    
    then
        set_text(7,15,"有线")
    elseif(Debug_FootState==2) 
    then
        set_text(7,15,"无线")
    end
    set_value(7,16,Debug_FootAD)
    set_value(7,17,Debug_FootADH)
    set_value(7,18,Debug_FootADL)

    if(Debug_FootState==2 and DebugBleReset==0)
    then
        set_value(7,19,0) --复位
    end
    if(Debug_FootState==2 and DebugBleReset==1)
    then
        set_value(7,19,1) --复位中
    end
    if(Debug_FootState==0)
    then
        set_value(7,19,2)--已断开
    end
    
    --丢包测试数据
    if(BLESendTimes>0 or BLERecvTimes>0)
    then
        if(BLESendTimes>0)
        then
            ber=((BLESendTimes-BLERecvTimes)/BLESendTimes)*100
            ber=string.format('%.2f',ber)
        end
        set_text(7,24,BLERecvTimes..'/'..BLESendTimes..'('..ber..'%'..')')
        set_text(7,22,BLESendTimes)
        set_text(7,23,BLERecvTimes)
    end
    if(Debug_FootState==0)
    then
        set_text(7,21,"未匹配未连接")
    elseif(Debug_FootState==1)    
    then
        set_text(7,21,"已匹配未连接")
    elseif(Debug_FootState==2) 
    then
        set_text(7,21,"已匹配已连接")
    end

end  
  
function screenSN_run(control,value)

	--返回
	if( control==41 and value==1)
	then
		SystemMode=g_SetScreenID   --返回设置界面
		change_screen(g_SetScreenID)
		KeyBeep_App()

        set_text(5,38,"")         --清空
	end
	--OK
	if(control==39 and value==1)
	then		
		SNCODE=get_text(5,38)
		if(#SNCODE==8)
		then

			SNInEnFlag=0x01

			FlashWriteBuf3[0]=SNInEnFlag
			write_flash(4900,FlashWriteBuf3)

			flush_flash()
			write_flash_string(5000,SNCODE)
			
			SystemMode=g_SetScreenID   --返回设置界面
			change_screen(g_SetScreenID)
            KeyBeep_App()

            set_text(5,38,"")         --清空
		end
	end

    if(control>0 and control<38)
    then
        KeyBeep_App()
    end
    
end
function DataToUart(user, program, steps)
    local Ratio=0
    local Speed=0
    local Torque=0

    if(SystemMode==1)   --种植模式
    then
        if(IMUserStepsDataBuf[user][program][steps]~=12 ) --冲水模式
        then
            if user == 1 then
                Ratio=IM_User1ProgramBuf[program][steps][3]
                Speed=IM_User1ProgramBuf[program][steps][1] 
                Torque=IM_User1ProgramBuf[program][steps][2] 
            elseif user == 2 then
                Ratio=IM_User2ProgramBuf[program][steps][3]
                Speed=IM_User2ProgramBuf[program][steps][1] 
                Torque=IM_User2ProgramBuf[program][steps][2]                 
            elseif user == 3 then
                Ratio=IM_User3ProgramBuf[program][steps][3]
                Speed=IM_User3ProgramBuf[program][steps][1] 
                Torque=IM_User3ProgramBuf[program][steps][2]   
            end    
            if IMUserStepsDataBuf[user][program][steps] == 10 then  --高速模式
                ScreenSetSpeed=(Speed//Ratio_PointNum[Ratio])--转速
            --elseif IMUserStepsDataBuf[user][program][steps] == 9 then  --骨锯模式--输出马达速度
                    --ScreenSetSpeed=Speed --转速
            else
                ScreenSetSpeed=Speed*Ratio_PointNum[Ratio]--转速
            end

            if(Ratio > 6)--速比大于1:1
            then
                ScreenSetTorque=Torque*20//Ratio_PointNum[Ratio] --主板的基准扭力是按照20:1的弯机计算的
                if(ScreenSetTorque==0)
                then
                    ScreenSetTorque=1
                end
            else
                ScreenSetTorque=35               --由70改成35N
            end
        else
            Ratio=0
            Speed=0
            ScreenSetSpeed=0
            ScreenSetTorque=0
        end

        if user == 1 then
            ScreenSetWater=IM_User1ProgramBuf[program][steps][4]
            ScreenSetLight=IM_User1ProgramBuf[program][steps][5] 
        elseif user == 2 then
            ScreenSetWater=IM_User2ProgramBuf[program][steps][4]
            ScreenSetLight=IM_User2ProgramBuf[program][steps][5]                
        elseif user == 3 then
            ScreenSetWater=IM_User3ProgramBuf[program][steps][4]
            ScreenSetLight=IM_User3ProgramBuf[program][steps][5]               
        end

    elseif(SystemMode==2)      --外壳模式
    then 
        if(g_SR_CurrentStepBuf[g_CurrentUser]~=8)   --不是冲水模式
        then 
            Ratio=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]
            Speed=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][1]  

            if(Ratio>0 and Ratio<6) then 
                ScreenSetSpeed=(Speed//Ratio_PointNum[Ratio])--转速
            else
                ScreenSetSpeed=Speed*Ratio_PointNum[Ratio]
            end
            if(ScreenSetSpeed > 1100)
            then 
                ScreenSetTorque=35                 --由70改成35N
            else
                ScreenSetTorque=50                 --由70改成50N
            end
        else
            Ratio=0
            Speed=0
            ScreenSetSpeed=0
            ScreenSetTorque=0
        end
        ScreenSetWater=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]
        ScreenSetLight=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][4]
    end

    if(SystemMode==3 or SystemMode==4 or g_IM_DataViewing == 2) --设置弹窗或者数据查看模式
    then
        ScreenSetWater=0
        ScreenSetSpeed=0
        ScreenSetLight=0
    end
end

function on_uart_recv_data(msg)
    local CRCresult = 0
    local Ratio = 0
    local FootDireKeyPress=0
    local CRClocation=18 --正常模式校验位位置
    local DebugCRClocation=18 --Debug校验位位置
    --local ErrorCode = 0 --Debug校验位位置
    local user = g_CurrentUser
    local program = Promgrame[g_CurrentUser]
    local steps = Steps[g_CurrentUser][Promgrame[g_CurrentUser]]

    local TempTorque  = 1

    RecivCommandID=msg[2]
    if(RecivCommandID==0xA0) 
    then 
        --CRCresult = XOR_CRC(msg,5)    --校验带帧
        --if( CRCresult==msg[5] )
        if(1)  --握手指令
        then
            UartErroTime=0
            ControlUartErrorCnt=ControlUartErrorCnt+1
            if(SystemMode==6)
            then
                set_text(6,8,'The App program is starting ...  ')
                RecvTimes=RecvTimes+1
                if(RecvTimes>20)
                then
                    RecvTimes=0
                    SystemMode=0
                    beep(300)
                    change_screen(0)
                    start_timer(7,6000,0,1)                    
                end
            end

            MainVision=msg[3]
            --FootVision=msg[4]    --脚踏版本号改为实时更新
            ScreenSendStep=1   
            ScreenSendFlag=1
            SendData() 
        end

    elseif(RecivCommandID==0x81 or RecivCommandID==0x82 or RecivCommandID==0x83 or RecivCommandID==0x84 )--种植 外科 设置 弹窗 
    then 
        CRCresult = XOR_CRC(msg,CRClocation)    --校验带帧
        if( CRCresult==msg[CRClocation] )
        --if(1)
        then
            UartErroTime=0

            RecveDire=msg[6] --方向接收         
            if(ChangeStep_SystemMode==0 and DireBtnFlag==0 and RecveDire<2 and RecivCommandID~=0x84) --弹窗模式弯机清洗不接收反向改变
            then
                if(SystemMode==1)
                then
                    if(RecveDire~=Motordirection)
                    then
                        if(IMUserStepsDataBuf[user][program][steps]==12) --冲水步骤
                        then
                            RecveDire=0
                            Motordirection=0
                            ScreenSetDire=0
                            ErroBeep_App()
                        else
                            Motordirection=RecveDire
                            ScreenSetDire=RecveDire
                            if(RecveDire==1)
                            then
                                start_timer(4, 1000, 0, 0)        --反转蜂鸣
                            else
                                stop_timer(4)
                            end
                            KeyBeep_App()
                        end
                    end
                elseif(SystemMode==2)
                then
                    if(RecveDire~=Motordirection)
                    then
                        if(g_SR_CurrentStepBuf[g_CurrentUser]==8)  --冲水模式
                        then
                            RecveDire=0
                            Motordirection=0
                            ScreenSetDire=0
                            ErroBeep_App()
                        else
                            Motordirection=RecveDire
                            ScreenSetDire=RecveDire
                            if(RecveDire==1)
                            then
                                start_timer(4, 1000, 0, 0)        --反转蜂鸣
                            else
                                stop_timer(4)
                            end
                            KeyBeep_App()
                        end
                    end
                end
            end

            if(IMUserStepsDataBuf[user][program][steps] ==12 and SystemMode==1) --冲水步骤 马达状态为0
            then
                MotorState=0
            else
                MotorState=msg[9]      --马达状态
                if(MotorState==0x02)
                then
                    HandControlFlag=0
                    MotorStopBeep_App()
                end
            end 
            if(g_SR_CurrentStepBuf[g_CurrentUser]==8 and SystemMode==2) --冲水步骤 马达状态为0
            then
                MotorState=0
            else
                MotorState=msg[9]      --马达状态
                if(MotorState==0x02)
                then
                    HandControlFlag=0
                    MotorStopBeep_App()
                end
            end

            if(SystemMode==3 and calibration==1)  --校准时收到校准错误
            then
                MotorState=msg[9]
                if(MotorState==0x05)
                then 
                    calibrationErrorFlag=1
                    MotorState=0
                    stop_timer(5)
                    calibration=0
                    set_visiable(g_SetScreenID,g_SetCalibrationButton,0)  --关闭校准按钮
                    set_value(g_SetScreenID,g_SetCalibrationIcon,5+Language*6+g_SetDarkModeFlag*12) --显示失败  
                    beep(300)                
                end
            end
            workingMode=msg[9]     -- 1工作界面 其余待机界面         
            
            if(SystemMode==1 or SystemMode==2)
            then
                if(MotorState==1)      --马达状态
                then
                    MotorStopBeep=0
                    MotorStopbeepstep=0

                    if(RecveDire==1)          --反转
                    then
                        start_timer(4, 1000, 0, 0)        --反转蜂鸣器
                    else
                        stop_timer(4)
                    end
                else
                    stop_timer(4)
                end

                if(LastRecveMotorStaus~=RecveMotorStaus and RecveDire==1)  --当方向反向，踩下脚踏立刻响一声
                then
                    LastRecveMotorStaus=RecveMotorStaus
                    if(LastRecveMotorStaus==1)
                    then
                        beep(100)
                    end
                end
            end

            ------Ratio_PointNum={ 2,3,3.3,4.2,5,1,4,10,16,20,27,32,64 }--前5个÷
            --接收主板发过来的实际转速
            if(SystemMode==1)--种植模式 速度接收
            then
                if(IMUserStepsDataBuf[user][program][steps]~=12)
                then
                    if user == 1 then
                        Ratio=IM_User1ProgramBuf[program][steps][3]
                    elseif user == 2 then
                        Ratio=IM_User2ProgramBuf[program][steps][3]              
                    elseif user == 3 then
                        Ratio=IM_User3ProgramBuf[program][steps][3]
                    end    
                    if IMUserStepsDataBuf[user][program][steps] ==10 then  --高速模式乘以速比
                        RecveSpeed=((msg[3]*256+msg[4]+1)*Ratio_PointNum[Ratio])
                    --elseif IMUserStepsDataBuf[user][program][steps] ==9 then  --骨锯模式--直接马达速度
                            --RecveSpeed=(msg[3]*256+msg[4]+1)
                    else
                        RecveSpeed=((msg[3]*256+msg[4])//Ratio_PointNum[Ratio])    
                    end

                    if(RecveSpeed>1000)   
                    then
                        RecveSpeed=RecveSpeed//100*100 
                    end
                elseif(IMUserStepsDataBuf[user][program][steps]==12)
                then
                    RecveSpeed=0
                end
            elseif(SystemMode==2) --外科模式 速度接收  
            then
                Ratio=g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][2]
 
                if(Ratio>0 and Ratio<6)--的转速比1-5  2,3,3.3,4.2,5
                then
                    RecveSpeed=((msg[3]*256+msg[4]+1)*Ratio_PointNum[Ratio])//100*100       
                elseif(Ratio>5 and Ratio<15)--6-11  1,4,10,16,20,27
                then
                    RecveSpeed=(msg[3]*256+msg[4])//Ratio_PointNum[Ratio]
                    if(RecveSpeed>1000)   
                    then
                        RecveSpeed=RecveSpeed//100*100 
                    end  
                end
                if(g_SR_CurrentStepBuf[g_CurrentUser]==8)  --冲水 
                then
                    RecveSpeed=0
                end
            end

            set_text(1,200,"收到的扭力："..msg[13])
           if(SystemMode==1)--种植模式 扭力值接收
            then
                TorqueRevCnt=TorqueRevCnt+1
                if(TorqueRevCnt>=5)
                then
                    TorqueRevCnt=0
                    if(IMUserStepsDataBuf[user][program][steps]~=12)
                    then
                        if user == 1 then
                            Ratio=IM_User1ProgramBuf[program][steps][3]
                            TempTorque=IM_User1ProgramBuf[program][steps][2]
                        elseif user == 2 then
                            Ratio=IM_User2ProgramBuf[program][steps][3] 
                            TempTorque=IM_User2ProgramBuf[program][steps][2]             
                        elseif user == 3 then
                            Ratio=IM_User3ProgramBuf[program][steps][3]
                            TempTorque=IM_User3ProgramBuf[program][steps][2]
                        end    
                        RecveTorque=msg[13]
                        if(RecveTorque > ScreenSetTorque) 
                        then
                            RecveTorque = ScreenSetTorque
                        end
                        RecveTorque=RecveTorque*Ratio_PointNum[Ratio]//20
                        IM_TorqueLooperNum=RecveTorque*10//TempTorque
                    end
                end

            end
            IM_Screen_Data_Refresh_Show(user, program, steps) --刷新显示数据
            IM_DataReview_BufNew_Data(workingMode, user, program, steps,RecveSpeed,RecveTorque) --实时速度、实时扭矩
            if(IM_TorqueLooperNum<1)
            then
                IM_TorqueLooperNum=1
            end
            if(IM_TorqueLooperNum>10)
            then
                IM_TorqueLooperNum=10
            end
            if(workingMode==0)
            then
                IM_TorqueLooperNum=0
            end

            --脚踏切换程序
            RecveProgFlag=msg[8]   
            set_text(1,103,'RecveProgFlag='..RecveProgFlag)
            if(RecveProgFlag==1)
            then
                if(SystemMode==1)      
                then
                    if(workingMode~=1)
                    then
                        Steps[user][program]=Steps[user][program]+1
                        Motordirection=0
                        ScreenSetDire=0
                        if Steps[user][program] > IM_Step_ProNum[user][program] then
                            Steps[user][program] = 1
                        end

                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                elseif(SystemMode==2)      
                then
                    if(workingMode~=1)
                    then
                        g_SR_CurrentStepBuf[g_CurrentUser]=g_SR_CurrentStepBuf[g_CurrentUser]+1
                        Motordirection=0
                        ScreenSetDire=0
                
                        if(g_SR_CurrentStepBuf[g_CurrentUser]>9)
                        then
                            g_SR_CurrentStepBuf[g_CurrentUser]=1
                        end
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                end
            elseif(RecveProgFlag==2)
            then
                if(SystemMode==1)      
                then
                    if(workingMode~=1)
                    then
                        Steps[user][program]=Steps[user][program]-1
                        Motordirection=0
                        ScreenSetDire=0
                
                        if(Steps[user][program]==0)
                        then
                            Steps[user][program] = IM_Step_ProNum[user][program]  --未调试
                        end
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                elseif(SystemMode==2)      
                then
                    if(workingMode~=1)
                    then
                        g_SR_CurrentStepBuf[g_CurrentUser]=g_SR_CurrentStepBuf[g_CurrentUser]-1
                        Motordirection=0
                        ScreenSetDire=0
                
                        if(g_SR_CurrentStepBuf[g_CurrentUser]==0)
                        then
                            g_SR_CurrentStepBuf[g_CurrentUser]=9
                        end
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                end            
            end

            --脚踏改变水量
            RecveWaterFlag=msg[7]  
            set_text(1,104,'RecveWaterFlag='..RecveWaterFlag)
            if(RecveWaterFlag==1)
            then 
                if(SystemMode==1) 
                then
                    if(workingMode~=1)
                    then
                        if user == 1 then
                            IM_User1ProgramBuf[program][steps][4]=IM_User1ProgramBuf[program][steps][4]+1
                            if(IM_User1ProgramBuf[program][steps][4]==5)
                            then
                                IM_User1ProgramBuf[program][steps][4]=0
                            end
                        elseif user == 2 then
                            IM_User2ProgramBuf[program][steps][4]=IM_User2ProgramBuf[program][steps][4]+1
                            if(IM_User2ProgramBuf[program][steps][4]==5)
                            then
                                IM_User2ProgramBuf[program][steps][4]=0
                            end
                        elseif user == 3 then  
                            IM_User3ProgramBuf[program][steps][4]=IM_User3ProgramBuf[program][steps][4]+1
                            if(IM_User3ProgramBuf[program][steps][4]==5)
                            then
                                IM_User3ProgramBuf[program][steps][4]=0
                            end                           
                        end
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                elseif(SystemMode==2) 
                then
                    if(workingMode~=1)
                    then
                        g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]= g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]+1
                        if(g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]==5)
                        then
                            g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]=0

                        end
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                end
            elseif(RecveWaterFlag==2)  --长按最大水量
            then
                if(SystemMode==1) 
                then
                    if(workingMode~=1)
                    then
                        IM_User1ProgramBuf[program][steps][4]=4
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                elseif(SystemMode==2) 
                then
                    if(workingMode~=1)
                    then
                        g_SR_ProgramBuf[g_CurrentUser][g_SR_CurrentStepBuf[g_CurrentUser]][3]=4
                        KeyBeep_App() 
                        StartFlashWrite_App()
                    else
                        ErroBeep_App()
                    end
                end
            end

            local hand=0 --手柄插入标志
            hand=msg[12]
            if( (hand & 0x10)==0x10 )  
            then
                MotorHandleFlag=1
            else
                MotorHandleFlag=0
            end
            if( (FootType & 0x01)==0x01) --有线脚踏关闭手动模式控件
            then
                Manual_Control=0
                HandControlFlag=0
            end
            if((FootType & 0x02)==0x02) --无线脚踏关闭手动模式控件
            then
                Manual_Control=0
                HandControlFlag=0
            end
            if((MotorHandleFlag==1 or FootPressFlag==0)and POP_WindowNum==21 and SystemModeBeforSet~=3 and Manual_Control==0)
            then 
                Popflag=0      
                SystemMode=SystemModeBeforSet 
                change_screen(SystemMode)                            
                if(SystemMode==1)    --系统模式
                then
                    IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                elseif(SystemMode==2)
                then
                    SRScreen_Show()
                elseif(SystemMode==3)
                then
                    SetScreen_Show()
                end
                POP_WindowNum=0
            end

            local DAC=0  --DAC调试用
            DAC=msg[14]*256+msg[15]
            set_text(1,201,"DAC="..DAC)
            set_text(2,201,"DAC="..DAC)

            FootVision=msg[16]    --脚踏版本实时更新

            local CurrentADC=0  --ADC调试用
            CurrentADC=msg[17]
            set_text(1,202,"CurrentADC="..CurrentADC)
            set_text(2,202,"CurrentADC="..CurrentADC)

            --蓝牙脚踏电池0-3
            WirelessFootBat=msg[5]

            ----脚踏类型 0无脚踏 01有线脚踏 02无线脚踏 ---
            FootType=msg[11]          
            if( (FootType & 0x10)==0x10 )  
            then
                FootPressFlag=1
            else
                FootPressFlag=0
            end

            --蓝牙状态 0-未匹配未连接 1-已匹配未连接 2-已匹配已连接 3-配网中取消
            BLE_Staus=msg[10]
            BLEkeyOnFlag = 1
            if(3 == BLE_Staus)
            then 
              BLEMatchExitFlag = 1
            end

            Popcheck() --错误代码
            ScreenSendFlag=1
            ScreenSendStep=1      
            SendData()  --发送函数
        end
    
    elseif(RecivCommandID==0x8D)--Debug模式接收主板数据
    then
        CRCresult=XOR_CRC(msg,DebugCRClocation)    --校验带帧
        if(CRCresult==msg[DebugCRClocation])
        --if(1)
        then            
        Debug_MotoSpeed=msg[3]*256+msg[4]
        Debug_FootState=msg[5]
        Debug_FootADH=msg[6]*10
        Debug_FootADL=msg[7]*10
        Debug_FootAD=msg[8]*256+msg[9]
        BLESendTimes=msg[10]*256+msg[11]
        BLERecvTimes=msg[12]*256+msg[13]
        Debug_MinDacValue=msg[14]
        Debug_TorqueADC=msg[15]*256+msg[16]
        MotorState = msg[17]   --用于显示错误代码

        if(FirstTorqueADCfromMainBoard~=0)  
        then
            DebugADCSetValue=Debug_TorqueADC
            set_value(7,27,DebugADCSetValue)
            FirstTorqueADCfromMainBoard=FirstTorqueADCfromMainBoard-1
        end
        if(FirstSpeedDACfromMainBoard~=0)
        then
            DebugDACSetValue=Debug_MinDacValue
            set_value(7,29,DebugDACSetValue)
            FirstSpeedDACfromMainBoard=FirstSpeedDACfromMainBoard-1
        end

        Popcheck() --错误代码
        ScreenSendFlag=1
        ScreenSendStep=1  
        SendData()              --发送函数
        end
    end  

    if(SystemMode==1)    --显示函数                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    then
        IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
    elseif(SystemMode==2)
    then
        SRScreen_Show()
    elseif(SystemMode==3)
    then
        SetScreen_Show()
    elseif(SystemMode==7)
    then
        DebugScreen_Show()
    end

end
function  SendData() 
    local commandID=0       --指令页面ID
    commandID=SystemMode
    if  commandID == 0x05 or commandID == 0x08 or commandID == 0x09 or commandID == 10 then  --SN码模式发送设置模式数据 05-SN   03-设置
        commandID = 0x03
    elseif get_current_screen() == IM_Set_ScreenID then 
        commandID = 0x03
    end
 
    DataToUart(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])]) --要发送的数据

    --发送屏幕数据
    if(ScreenSendStep==1)
    then    
        if(commandID==0x01 or commandID==0x02 or commandID==0x03 or commandID==0x04)        --发送 种植 拔牙 设置 弹窗模式的数据
        then
            for i=0,19 do
                TxBuf[i]=0x00;
            end

            TxBuf[4] =0x0E  --长度位
            TxBuf[5] =commandID 
            TxBuf[6] =ScreenSetSpeed//256
            TxBuf[7] =ScreenSetSpeed%256
            TxBuf[8] =g_IM_WashingFlag --弯机清洗标志位
            TxBuf[9] =ScreenSetWater
            TxBuf[10]=ScreenSetLight
            if(ScreenSetDire > 1)
            then
                ScreenSetDire = 0
            end
            TxBuf[11]=ScreenSetDire
            TxBuf[12]=g_IM_DataViewing   --数据查看标志位
            TxBuf[13]=BLEMatchFlag
            TxBuf[14]=ScreenSetTorque
            TxBuf[15]=calibration
            TxBuf[16]=g_SetReversalFlag

            if(ChangeStep_SystemMode==1)
            then
                TxBuf[11]=0
            end

            TxBuf[17]=XOR_CRC(TxBuf,17)
            --帧头	              
            TxBuf[0]=0x43
            TxBuf[1]=0x4F
            TxBuf[2]=0x58
            TxBuf[3]=0x4F	 

            if(ScreenSendFlag==1)
            then
                ScreenSendFlag=0
                ScreenSendStep=0
                uart_send_data(TxBuf)
            end
            if(ChangeStep_SystemMode == 1 and RecveDire == 0)  --步骤和界面切换默认是正转0
            then
                ChangeStep_SystemMode = 0
            end
            if(DireBtnFlag == 1)                                 --按键切换模式可以是正反转
            then
                DireBtnFlag = 0
            end
        elseif(commandID==0x00 or commandID==0x05) --开机  都发0
        then
            for i=0,19 do
                TxBuf[i]=0x00;
            end
            TxBuf[4] =0x0E
            TxBuf[5] =commandID 
            TxBuf[6] =0
            TxBuf[7] =0
            TxBuf[8] =0
            TxBuf[9] =0
            TxBuf[10]=0
            TxBuf[11]=0
            TxBuf[12]=0
            TxBuf[13]=0
            TxBuf[14]=0
            TxBuf[15]=0
            TxBuf[16]=0
            TxBuf[17]=XOR_CRC(TxBuf,17)

            --帧头	              
            TxBuf[0]=0x43
            TxBuf[1]=0x4F
            TxBuf[2]=0x58
            TxBuf[3]=0x4F	 

            if(ScreenSendFlag==1)
            then
                ScreenSendFlag=0
                ScreenSendStep=0
                uart_send_data(TxBuf)
            end

        elseif(commandID==0x07)--DEBUG  
        then            
            for i=0,13 do
                DebugTxBuf[i]=0x00;
            end
            DebugTxBuf[4] =0x11  --长度
            DebugTxBuf[5] =0x0D 
            DebugTxBuf[6] =DebugMotorRun
            DebugTxBuf[7] =DebugSetSpeed//256
            DebugTxBuf[8] =DebugSetSpeed%256
            DebugTxBuf[9] =DebugStepMotorRun
            DebugTxBuf[10]=DebugStepMotorValue
            DebugTxBuf[11]=DebugBleReset
            DebugTxBuf[12]=DebugDACSetFlag
            DebugTxBuf[13]=DebugDACSetValue
            DebugTxBuf[14]=DebugADCSetFlag
            DebugTxBuf[15]=DebugADCSetValue//256
            DebugTxBuf[16]=DebugADCSetValue%2560
            DebugTxBuf[17]=DebugTorqueSetValue
            DebugTxBuf[18]=DebugDACResetFlag
            DebugTxBuf[19]=DebugADCResetFlag
            DebugTxBuf[20]=XOR_CRC(DebugTxBuf,20)

            --帧头	              
            DebugTxBuf[0]=0x43
            DebugTxBuf[1]=0x4F
            DebugTxBuf[2]=0x58
            DebugTxBuf[3]=0x4F	

            if(ScreenSendFlag==1)
            then
                ScreenSendFlag=0
                ScreenSendStep=0
                uart_send_data(DebugTxBuf)
            end

            if(DebugDACSetFlag==1)
            then
                DebugDACSetFlag=0
            end
            if(DebugDACResetFlag==1)
            then
                DebugDACResetFlag=0
            end
            if(DebugADCSetFlag==1)
            then
                DebugADCSetFlag=0
            end
            if(DebugADCResetFlag==1)
            then
                DebugADCResetFlag=0
            end

        end
    end
end
--[[
function senddata_dire()
    local commandID=0       --指令页面ID
    commandID=SystemMode

    DataToUart(user, program, steps)
    for i=0,19 do
        TxBuf[i]=0x00;
    end
    TxBuf[4] =0x0D
    TxBuf[5] =commandID 
    TxBuf[6] =ScreenSetSpeed//256
    TxBuf[7] =ScreenSetSpeed%256
    TxBuf[8] =Manual_Control
    TxBuf[9] =ScreenSetWater
    TxBuf[10]=ScreenSetLight
    TxBuf[11]=ScreenSetDire
    TxBuf[12]=HandControlFlag
    TxBuf[13]=BLEMatchFlag
    TxBuf[14]=ScreenSetTorque
    TxBuf[15]=calibration
    TxBuf[16]=XOR_CRC(TxBuf,16)
    --帧头	              
    TxBuf[0]=0x43
    TxBuf[1]=0x4F
    TxBuf[2]=0x58
    TxBuf[3]=0x4F	
    uart_send_data(TxBuf)

end
]]

function testmessageshow()
    --IM界面
    --set_visiable(1,18,testmessageshowflag)
    --set_visiable(1,19,testmessageshowflag)
    --set_visiable(1,69,testmessageshowflag)
    set_visiable(1,102,testmessageshowflag)
    set_visiable(1,103,testmessageshowflag)
    set_visiable(1,104,testmessageshowflag)
    set_visiable(1,105,testmessageshowflag)
    set_visiable(1,200,testmessageshowflag)
    set_visiable(1,201,testmessageshowflag)
    set_visiable(1,202,testmessageshowflag)
    set_visiable(1,203,testmessageshowflag)
    --SR界面
    --set_visiable(2,69,testmessageshowflag)
    set_visiable(2,102,testmessageshowflag)
    set_visiable(2,201,testmessageshowflag)
    set_visiable(2,202,testmessageshowflag)
    set_visiable(2,203,testmessageshowflag)
    set_visiable(2,204,testmessageshowflag)
    --设置界面
    set_visiable(3,100,testmessageshowflag)
    set_visiable(3,101,testmessageshowflag)
    set_visiable(3,102,testmessageshowflag)
    set_visiable(3,103,testmessageshowflag)
end
function on_timer(timer_id)
    --闪烁间隔  

   if(timer_id==1)
   then
       if(TwinkleFlag==0)
       then
           TwinkleFlag=1
       else
           TwinkleFlag=0
       end
       Icon_Twinkle(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
   end
   
   if(timer_id==3)			
	then
		if(ErrBeep==1)
		then
			if(Errbeepstep==1)
			then
				beep(50)
				Errbeepstep=2
			elseif(Errbeepstep==2)
			then
				Errbeepstep=3
			elseif(Errbeepstep==3)
			then
				beep(50)
				Errbeepstep=4
			else
				Errbeepstep=0
				ErrBeep=0
			end
        elseif(NoteBeep==1)
        then
            Errbeepstep=Errbeepstep+1
            if(Errbeepstep==1 or Errbeepstep==2 or Errbeepstep==5 or Errbeepstep==6)
			then
				beep(100)
            elseif(Errbeepstep==8)
            then
				Errbeepstep=0
				NoteBeep=0
			end
        elseif(BLEBeep==1)
        then
            Errbeepstep=Errbeepstep+1
            if(Errbeepstep==1 or Errbeepstep==5 or Errbeepstep==9 )
			then
				beep(100)
            elseif(Errbeepstep==13)
            then
				Errbeepstep=0
				BLEBeep=0
			end
        elseif(MotorStopBeep==1)
        then
            MotorStopbeepstep=MotorStopbeepstep+1
            if(MotorStopbeepstep==2 or MotorStopbeepstep==15)
            then
                beep(500)
            elseif(MotorStopbeepstep==20)
            then
                MotorStopbeepstep=0
               
                 MotorStopBeep=2                 
            end
        elseif(FootLowPowerBeep==1)
        then
            Errbeepstep=Errbeepstep+1
            if(Errbeepstep==2 or Errbeepstep==22 or Errbeepstep==42 or Errbeepstep==62 or Errbeepstep==82)
			then
				beep(200)
            elseif(Errbeepstep==83)
            then
				Errbeepstep=0
				FootLowPowerBeep=0
			end
	    end
end

    --------------电机反转蜂鸣器----------------
    if(timer_id==4)
    then
        if(SystemMode==1 and MotorState==1 and Motordirection==1)
        then
            beep(100)
        end
        if(SystemMode==2 and MotorState==1 and Motordirection==1)
        then
            beep(100)
        end
    end

    ---------------复位计时-----------------
    if(timer_id == g_SetResetTime)      --定时器5
    then
        if(SystemMode==g_SetScreenID or SystemMode==4)  --设置或者弹窗界面
        then
            --复位
            if(ResetFlag==1)
            then
                ResetTime=ResetTime+1  --250ms自增
                 if(ResetTime<4)
                then
                    set_value(g_SetScreenID,g_SetResetIcon,ResetTime+Language*5+g_SetDarkModeFlag*10)
                elseif(ResetTime<7)
                then
                    set_value(g_SetScreenID,g_SetResetIcon,(ResetTime-3)+Language*5+g_SetDarkModeFlag*10)
                elseif(ResetTime==7)
                then
                    set_value(g_SetScreenID,g_SetResetIcon,4+Language*5)
                    ResetData_User(g_CurrentUser)--数据重置
                    ResetData_SetMode()     --设置界面初始化
                    Backlight_App()         --背光要在初始化之后
                    NoteBeep_App()
                elseif(ResetTime==10)
                then
                    set_value(g_SetScreenID,g_SetResetIcon,0+Language*5)
                    ResetFlag=0
                    ResetTime=0
                    stop_timer(g_SetResetTime)
                    StartFlashWrite_App()

                    Motordirection=0  --方向正向
                    ScreenSetDire=0
                    ChangeStep_SystemMode=1

                    SystemMode=1
                    change_screen(1)   --返回种植界面
                    IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                end
            end
            
            --蓝牙匹配
            if(BLEMatchFlag==1)
            then
                BLEMatchTime=BLEMatchTime+1

                if(BLEMatchTime==1)--显示 配对中 弹窗
                then
                    change_child_screen(4)
                    SystemMode=4
                    POP_WindowNum=5
                    WindowScreen_Show()
                end
        
                if(BLEMatchTime>180)        --显示 匹配超时重试弹窗
                then
                    stop_timer(5)
                    BLEMatchFlag=0
                    BLEMatchTime=0
                    POP_WindowNum=4
                    WindowScreen_Show()
                else
                    if(BLE_Staus==2)        --匹配完成
                    then
                        SystemMode=3
                        change_screen(3)
                        stop_timer(5)
                        BLEMatchTime=0
                        BLEMatchFlag=0
                        NoteBeep_App()
                    end
                end
            elseif(BLEMatchFlag==2)       --退网操作
            then
                BLEMatchTime=BLEMatchTime+1

                if(BLEMatchTime>30)    --超时
                then
                    stop_timer(5)
                    BLEMatchFlag=0
                    BLEMatchTime=0
                    SystemMode=3
                    change_screen(3)
                else
                    if(BLE_Staus==0)   --断开完成
                    then
                        SystemMode=3
                        change_screen(3)
                        stop_timer(5)
                        BLEMatchTime=0
                        BLEMatchFlag=0
                    --    NoteBeep_App()
                    end
                end  
            elseif(BLEMatchFlag==3)       --配网中取消
            then
                BLEMatchTime=BLEMatchTime+1

                if(BLEMatchTime>40)    --超时
                then
                    stop_timer(5)
                    BLEMatchFlag=0
                    BLEMatchTime=0
                    SystemMode=3
                    change_screen(3)
                else
                    if(BLEMatchExitFlag == 1)        --取消完成
                    then
                        BLEMatchExitFlag = 0
                        SystemMode=3
                        change_screen(3)
                        stop_timer(5)
                        BLEMatchTime=0
                        BLEMatchFlag=0
                        --NoteBeep_App()
                    end  
                end                                              
            end
            if(calibration==1)            --校准
            then 
                if(calibrationshowcount<18)
                then
                    calibrationtime=calibrationtime+1
                    if(calibrationtime<5) 
                    then
                        set_value(g_SetScreenID,g_SetCalibrationIcon,calibrationtime-1+Language*6+g_SetDarkModeFlag*12)
                    else --5*15=75  75*0.25s=18.75s
                        calibrationshowcount=calibrationshowcount+1
                        if(calibrationshowcount<18)
                        then
                             calibrationtime=1
                        else --calibrationshowcount=15
                            set_value(g_SetScreenID,g_SetCalibrationIcon,4+Language*6+g_SetDarkModeFlag*12) --显示完成
                            beep(300)
                            calibrationtime=1                     
                        end
                    end
                end
                if(calibrationshowcount==18)    
                then
                    calibrationtime=calibrationtime+1   --为了显示完成图标时间
                    if(calibrationtime>15)
                    then
                        set_value(g_SetScreenID,g_SetCalibrationIcon,0+Language*6+g_SetDarkModeFlag*12) --显示校准
                        calibrationtime=1
                        stop_timer(g_SetResetTime)   --停止定时器
                        calibration=0
                        calibrationshowcount=0  
                    end
                end       
            end
            SetScreen_Show()
        end
    end

    if(timer_id==7)
    then
        if(SystemMode==0)
        then
            g_UserSetFlag = 0

            SystemMode=ReadSystemMode
            if(SystemMode==2)
            then
                SRScreen_Show()
                change_screen(2)
            else
                SystemMode=1
                IMScreen_Init_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                change_screen(1)
            end  
        end
        Backlight_App()
        ControlUartErrorCnt=0
        start_timer(9, 1000, 0, 0)       --1秒定时器
    end


    if(timer_id==9)--1秒定时器
    then
        if(calibrationErrorFlag==1)
        then
            calibrationErrorCnt=calibrationErrorCnt+1
            if(calibrationErrorCnt==3)  --显示3s校准失败
            then
                calibrationErrorCnt=0
                calibrationErrorFlag=0
                set_visiable(3,8,1)  --开启校准按钮
                set_value(3,g_SetCalibrationIcon,0+Language*6+g_SetDarkModeFlag*12) --显示校准
            end
        end
        if(Warnbeepflag==1)
        then
            beep(100)
        end
        --[[
        --POP_WindowNum=9 判断屏幕TX失效 开机主板会一直发A0指令
        if((SystemMode==1 or SystemMode==2 or SystemMode==3 or SystemMode==4) and Popflag~=1)
        then
            if(ControlUartErrorCnt>50)
            then
                Warnbeepflag=1
                Popflag=1
                ControlUartErrorCnt=0
                SystemModeBeforSet=SystemMode --保存当前的模式，用以确认弹窗后回到原来的模式          
                --SystemMode=4  
                --POP_WindowNum=9
                change_child_screen(4)
                WindowScreen_Show()
            end
        end
        ]]
        --POP_WindowNum=9 屏幕通信中断弹窗RX失效
        if((SystemMode==1 or SystemMode==2 or SystemMode==3 or SystemMode==4) and Popflag~=1 and g_IM_DataViewing ~= 2)
        then
            UartErroTime=UartErroTime+1
            if(UartErroTime>=5 and ResetFlag==0)  --超过3s没有通过串口回调函数清0，判断为通信中断
            then
                Warnbeepflag=1
                Popflag=1
                UartErroTime=0
                SystemModeBeforSet=SystemMode --保存当前的模式，用以确认弹窗后回到原来的模式          
                SystemMode=4  
                POP_WindowNum=9
                change_child_screen(4)
                WindowScreen_Show()
            end 
        end
        
        --POP_WindowNum=7 蓝牙脚踏低电量弹窗
        if((FootType & 0x02)==0x02 and WirelessFootBat<2 and Popflag~=1 and g_IM_DataViewing ~= 2)  --无线脚踏低电量弹窗判断
        then
            WirelessFootBatTime=WirelessFootBatTime+1
            if(WirelessFootBatTime>LowFootBatTime) --弹出低电量弹窗时间 120s
            then
                if(workingMode~=1 and (SystemMode==1 or SystemMode==2))
                then
                    Popflag=1
                    WirelessFootBatTime=0
                    SystemModeBeforSet=SystemMode --保存当前的模式，用以确认弹窗后回到原来的模式
                    change_child_screen(4)
                    SystemMode=4  
                    POP_WindowNum=7
                    WindowScreen_Show()
                    FootLowPowerBeep_App()                   
                end     
            end
        end

        ClearDebugCnt=ClearDebugCnt+1
        if(ClearDebugCnt==5)
        then
            ClearDebugCnt=0
            Debugbuttoncnt=0
            set_visiable(3,99,1)
            set_visiable(3,98,0)--重置调试入口
        end

        testcnt=testcnt+1
        if(testcnt>60)
        then
            testcnt=0
        end
        set_text(1,102,testcnt)
        set_text(2,102,testcnt)

        if(Debug_StepMotorState==1)  --步进电机老化
        then
            if(DebugStepMotorRun==1)
            then
                StepMotorRuntime=StepMotorRuntime+1
                if(StepMotorRuntime>DebugStepMotorRunTime*60)
                then
                    DebugStepMotorRun=0
                    StepMotorRuntime=0
                end
            elseif(DebugStepMotorRun==0)
            then
                StepMotorRuntime=StepMotorRuntime+1
                if(StepMotorRuntime>DebugStepMotorStopTime*60)
                then
                    DebugStepMotorRun=1
                    StepMotorRuntime=0
                    Debug_SetpMotorTestCnt=Debug_SetpMotorTestCnt+1
                end                   
            end
        else
            DebugStepMotorRun=0
            StepMotorRuntime=0
            DebugStepMotorRun=0
            Debug_SetpMotorTestCnt=0
        end

        if(DebugBleReset==1)
        then
            DebugBleResetTime=DebugBleResetTime+1
            if(DebugBleResetTime==6)
            then
                DebugBleResetTime=0
                DebugBleReset=0
            end
        end
    end

    -------------flash写入-----------
    if(timer_id==12)
    then
        DataWriteFlash()
        stop_timer(12)          
    end

    if(timer_id == g_UserCountBackTime_1s)then    --开机页面倒数定时器13
        g_UserCountBackCnt = g_UserCountBackCnt + 1
        if(g_UserCountBackCnt < 5)then 
            set_value(8,g_UserCountBackIcon,g_UserCountBackCnt+g_SetDarkModeFlag*5)
            set_visiable(8,g_UserCountBackIcon,1)
        else
            g_UserCountBackCnt = 0
            stop_timer(g_UserCountBackTime_1s)
            set_visiable(8,g_UserCountBackIcon,0) --关闭倒数显示

            SystemMode=ReadSystemMode
            if(SystemMode==2)
            then
                SRScreen_Show()
                change_screen(2)
            else
                SystemMode=1
                IMScreen_Init_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                change_screen(1)
            end           
        end       
    end

    if(timer_id == g_IM_WashingTime)then    --弯机清洗定时器14
        if g_IM_WashingFlag  == 1 and MotorHandleFlag==1 then 
            g_IM_WashingCnt= g_IM_WashingCnt-1
            WindowScreen_WashingNumber(g_IM_WashingCnt) 
            if g_IM_WashingCnt  == 0 then 
                g_IM_WashingFlag = 0
                stop_timer(g_IM_WashingTime)

                change_child_screen(4)   
                SystemMode=4
                POP_WindowNum=19        --切换到完成弹窗
                WindowScreen_Show()
            end
        else
            g_IM_WashingFlag = 0      --弯机清洗标志位
            g_IM_WashingCnt = 0       --弯机清洗计数器
            change_screen(IMScreenID)
            SystemMode=IMScreenID
            IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
            POP_WindowNum=0

            stop_timer(g_IM_WashingTime)           
        end       
    end
    if timer_id == g_IM_WashingCancleTime then   --定时15  弯机清洗中途取消定时器
        if g_IM_WashingCancleFlag == 1  then
            g_IM_WashingCancleCnt = g_IM_WashingCancleCnt+1
            --WindowScreen_WashingNumber_Cancle(30)
            if g_IM_WashingCancleCnt == 2 then
                g_IM_WashingCancleCnt = 0
                g_IM_WashingCancleFlag = 0
                change_screen(IMScreenID)
                SystemMode=IMScreenID
                IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
                POP_WindowNum=0    
                stop_timer(g_IM_WashingCancleTime) 
            end
        end
    end
    if timer_id == IMReportScreenShot_Timer then   --定时20
        if USBDriverFalg == 1 then      --表示U盘已插入
            local filename
            local succeedFlag
            fileName ="2:/"..IM_DataReview_NO..IM_DataReview_Name.."_"..IM_DataReview_TreatYear.."-"..IM_DataReview_TreatMoon.."-"..IM_DataReview_TreatDay..".jpg"
            succeedFlag = screen_shoot(fileName)       --截图
            if succeedFlag == 1 then
                POP_WindowNum = 17
            else
                POP_WindowNum = 18
            end
            SystemMode=4
            change_child_screen(4)
            WindowScreen_Show()
        else
            SystemMode=4
            POP_WindowNum = 15      --显示监测不到设备
            change_child_screen(4)
            WindowScreen_Show()
        end
    end

end  
function StartFlashWrite_App()
    stop_timer(12)
    start_timer(12, 1500, 0, 0)
end
function Popcheck() --错误代码

    if((SystemMode==1 or SystemMode==2 or SystemMode==3 or SystemMode==4 or SystemMode==7)and Popflag==0 and g_IM_DataViewing ~= 2)
    then
            --[[
         if(MotorState==0x02)--马达过载
        then
            if(SystemMode==1 or SystemMode==2)
            then
                SystemModeBeforSet=SystemMode --保存当前的模式，用以确认弹窗后回到原来的模式
                SystemMode=4
                change_child_screen(4)              
                POP_WindowNum=8
                WindowScreen_Show()
            end
        end 
            ]]
        if( MotorHandleFlag==0 and FootPressFlag==1) --马达未连接,无确认按键
        then
            beep(300)
            if(SystemMode==1 or SystemMode==2)
            then
                Popflag=1
                SystemModeBeforSet=SystemMode 
                SystemMode=4  
                change_child_screen(4)            
                POP_WindowNum=21
                WindowScreen_Show()
            end
        elseif MotorNotConnectedFlg == 1 then 
            beep(300)
            if(SystemMode==1  or  SystemMode==3)
            then
                Popflag=1
                SystemModeBeforSet=SystemMode 
                SystemMode=4  
                change_child_screen(4)            
                POP_WindowNum=8
                WindowScreen_Show()
            end

           MotorNotConnectedFlg = 0    
        end         
        if(MotorState==0x03)--蓝牙错误
        then
            if(SystemMode==3 or SystemMode==4)
            then
                Popflag=1
                Warnbeepflag=1
                SystemModeBeforSet=3               
                stop_timer(5)
                BLEMatchFlag=0
                BLEMatchTime=0
                SystemMode=4
                change_child_screen(4)
                POP_WindowNum=10
                WindowScreen_Show()
            end
        elseif(MotorState==0x04)--马达异常
        then
            if(SystemMode==1 or SystemMode==2 or SystemMode==7)
            then
                --beep(300)
                Popflag=1
                Warnbeepflag=1
                SystemModeBeforSet=SystemMode 
                SystemMode=4  
                change_child_screen(4)
                POP_WindowNum=11
                WindowScreen_Show()

                Debug_MotorState=0  --老化模式，马达异常，关闭马达
                DebugMotorRun=0
            end
        elseif(MotorState==0x06)--通信中断
        then
            if(SystemMode==1 or SystemMode==2 or SystemMode==3 or SystemMode==4)
            then
                Popflag=1
                Warnbeepflag=1
                SystemModeBeforSet=SystemMode 
                SystemMode=4  
                change_child_screen(4)
                POP_WindowNum=9
                WindowScreen_Show()
            end
        end
    end
end 
function ResetData_AllUser()  --所有用户数据初始化

    g_CurrentUser = 0x01     --当前用户
    g_UserTatolNum = 0x01    --用户总数量
    for i=1,3,1 do
        UserIDBuf[i] =  UserIDInitBuf[i]        --用户编号（默认）按123排列
    end
    for i=1,3,1 do
        UserNameBuf[i] = UserNameInitBuf[i] 
    end    
    
    g_TempUserTatolNum = 0x01    --临时用户BUF用户总数量
    for i=1,3,1 do
        TempUserIDBuf[i] =  UserIDInitBuf[i]        --用户编号（默认）按123排列
    end
    for i=1,3,1 do
        TempUserNameBuf[i] = UserNameInitBuf[i] 
    end   

    for i = 1, 5, 1 do     --5个程序  用户1
        for k = 1, 8, 1 do  --8个步骤
            for j = 1, 5, 1 do --5个参数
--                IM_User1ProgramBuf[i][k][j]=IM_Init_User1ProgramBuf[i][k][j]  
            end
        end
    end    
    for i = 1, 5, 1 do     --5个程序 用户2
        for k = 1, 8, 1 do  --8个步骤
            for j = 1, 5, 1 do --5个参数
                IM_User2ProgramBuf[i][k][j]=IM_Init_User2ProgramBuf[i][k][j]  
            end
        end
    end   
    for i = 1, 5, 1 do     --5个程序  用户3
        for k = 1, 8, 1 do  --8个步骤
            for j = 1, 5, 1 do --5个参数
                IM_User3ProgramBuf[i][k][j]=IM_Init_User3ProgramBuf[i][k][j]  
            end
        end
    end      

    for i = 1,3,1 do    --种植步骤初始化
        for k = 1, 5, 1 do                  
            for j = 1, 8, 1 do
                IMUserStepsDataBuf[i][k][j]=IM_InitUserStepsDataBuf[i][k][j]  
            end
        end
    end
     
    for i = 1, 3, 1 do
        Promgrame[i] = 1         --当前程序初始化
    end

    for i = 1, 3, 1 do
        for k = 1, 5, 1 do                   --种植步骤初始化
            Steps[i][k] = Steps_Init[i][k]
        end  
    end

    for i = 1, 3, 1 do
        for k = 1, 5, 1 do                   --种植步骤初始化
            IM_Step_ProNum[i][k] = IM_Init_Step_ProNum[i][k]
        end    
    end

    for i = 1, 3, 1 do
        for k = 1, 5, 1 do                   --种植程序名字初始化
            IMUserProgramIDDataBuf[i][k] = IM_Init_UserProgramIDDataBuf[i][k]
        end       
    end

    for i = 1, 3, 1 do
        for k = 1, 9, 1 do                  --外科模式
            for j = 1, 4, 1 do
                g_SR_ProgramBuf[i][k][j]=g_SR_Init_ProgramBuf[i][k][j]  
            end
        end
    end    
    --Backlight_App()              --背光要在初始化之后
    for i = 1, 3, 1 do
        g_SR_CurrentStepBuf[i]=1  --外科模式当前步骤
    end
end
function ResetData_User(CurrentUser)
    if (CurrentUser == 0x01) then     --种植模式
        for i = 1, 5, 1 do     --5个晨旭
            for k = 1, 8, 1 do  --8个步骤
                for j = 1, 5, 1 do --5个参数
                    IM_User1ProgramBuf[i][k][j]=IM_Init_User1ProgramBuf[i][k][j]  
                end
            end
        end    
    elseif (CurrentUser == 0x02) then
        for i = 1, 5, 1 do     --5个晨旭
            for k = 1, 8, 1 do  --8个步骤
                for j = 1, 5, 1 do --5个参数
                    IM_User2ProgramBuf[i][k][j]=IM_Init_User2ProgramBuf[i][k][j]  
                end
            end
        end   
    elseif (CurrentUser == 0x03) then
        for i = 1, 5, 1 do     --5个晨旭
            for k = 1, 8, 1 do  --8个步骤
                for j = 1, 5, 1 do --5个参数
                    IM_User3ProgramBuf[i][k][j]=IM_Init_User3ProgramBuf[i][k][j]  
                end
            end
        end      
    end

    for k = 1, 5, 1 do                  --种植步骤初始化
        for j = 1, 8, 1 do
            IMUserStepsDataBuf[CurrentUser][k][j]=IM_InitUserStepsDataBuf[CurrentUser][k][j]  
        end
    end    
    Promgrame[CurrentUser] = 1         --当前程序初始化
    for k = 1, 5, 1 do                   --种植步骤初始化
        Steps[CurrentUser][k] = Steps_Init[CurrentUser][k]
    end    
    for k = 1, 5, 1 do                   --种植步骤初始化
        IM_Step_ProNum[CurrentUser][k] = IM_Init_Step_ProNum[CurrentUser][k]
    end    
    for k = 1, 5, 1 do                   --种植程序名字初始化
        IMUserProgramIDDataBuf[CurrentUser][k] = IM_Init_UserProgramIDDataBuf[CurrentUser][k]
    end       

    for k = 1, 9, 1 do                  --外科模式
        for j = 1, 4, 1 do
            g_SR_ProgramBuf[CurrentUser][k][j]=g_SR_Init_ProgramBuf[CurrentUser][k][j]  
        end
    end
    --Backlight_App()              --背光要在初始化之后
    g_SR_CurrentStepBuf[CurrentUser]=1  --外科模式当前步骤
end
function ResetData_SetMode()
    Voice=1                        --声音开
    BackLight=3                    --背光调节
    g_SetDarkModeFlag = 0          --默认白色底色
end
function Icon_Twinkle(user,programe,steps)
    -----电机工作时 方向图标闪烁----
    if(SystemMode==1)              --种植模式
    then
        if(IMUserStepsDataBuf[user][programe][steps]~=12) --步骤不是冲水模式
        then
            if(workingMode==1)         
            then
                if(TwinkleFlag==1)
                then
                    set_visiable(1,IM_MotordirectionIcon,DISABLE)
                else
                    set_visiable(1,IM_MotordirectionIcon,ENABLE)
                end
            else
                set_visiable(1,IM_MotordirectionIcon,ENABLE)
            end
        else--冲水
            if(workingMode==1)        
            then
                set_visiable(1,IM_MotordirectionIcon,DISABLE)  --冲水模式默认隐藏
            --else
                --set_visiable(1,IM_MotordirectionIcon,ENABLE)
            end
        end
    elseif(SystemMode==2)
    then
        if(g_SR_CurrentStepBuf[g_CurrentUser]~=8)  --步骤不是冲水模式
        then
            if(workingMode==1)         
            then
                if(TwinkleFlag==1)
                then
                    set_visiable(2,g_SR_DirecionIcon,DISABLE)
                else
                    set_visiable(2,g_SR_DirecionIcon,ENABLE)
                end
            else
                set_visiable(2,g_SR_DirecionIcon,ENABLE)
            end
        else--冲水
            --if(workingMode==1)        
            --then
                set_visiable(2,g_SR_DirecionIcon,DISABLE)
            --else
              --  set_visiable(2,g_SR_DirecionIcon,ENABLE)
            --end
        end
    end

    if(IMUserStepsDataBuf[user][programe][steps]==12 or g_SR_CurrentStepBuf[g_CurrentUser]==8)--冲水运行时 冲水图标闪烁
    then
        if(workingMode==1)
        then
            watersteptime=watersteptime+1
            set_value(1,IM_WaterFlush_Icon,watersteptime-1+g_SetDarkModeFlag*4)

            set_value(2,g_SR_WaterWorkIcon,watersteptime-1+g_SetDarkModeFlag*4)
            if(watersteptime>3)
            then
                watersteptime=0
            end
        else
            set_value(1,IM_WaterFlush_Icon,0+g_SetDarkModeFlag*4)

            set_value(2,g_SR_WaterWorkIcon,0+g_SetDarkModeFlag*4)
            watersteptime=0
        end
    end
    ----------------------------------------
    if(MotorHandleFlag==0)  --马达图标闪烁
    then
        set_visiable(1,Status_Bar_Motor,TwinkleFlag)  
        set_visiable(2,Status_Bar_Motor,TwinkleFlag)
    end

    if(FootType==0)--没有脚踏连接闪烁
    then
        set_visiable(1,Status_Bar_Foot,TwinkleFlag)
        set_visiable(2,Status_Bar_Foot,TwinkleFlag)
    elseif((FootType & 0x02)==0x02)    --无线脚踏
    then
        set_visiable(1,Status_Bar_Foot,ENABLE)
        set_visiable(2,Status_Bar_Foot,ENABLE)
        if(WirelessFootBat<2)       --电池空格或小1
        then
            set_visiable(1,Status_Bar_FootPower,TwinkleFlag) --电池图标闪烁
            set_visiable(2,Status_Bar_FootPower,TwinkleFlag)
        else
            set_visiable(1,Status_Bar_FootPower,ENABLE)
            set_visiable(2,Status_Bar_FootPower,ENABLE)
        end
    elseif((FootType & 0x01)==0x01) --有线脚踏
    then 
        set_visiable(1,Status_Bar_Foot,ENABLE)
        set_visiable(2,Status_Bar_Foot,ENABLE)
    end 

    if get_current_screen() == IM_Set_ScreenID and IMStepsDisplayBuf[1] == 0 then  --种植编辑界面，清空后步骤闪烁
        set_visiable(IM_Set_ScreenID,IM_Set_Step1_Icon,TwinkleFlag)
    end
end
-----------------------------------------------------------------------------
--@program: DataWriteUserNameFlash()
--@brief:用户名写flash
-------------------------------------------------------------------------------
function DataWriteUserNameFlash()
    local User1Name = "User1"
    local User2Name = "User2"
    local User3Name = "User3"
    User1Name = UserNameBuf[1]
    User2Name = UserNameBuf[2]
    User3Name = UserNameBuf[3]

    flush_flash()
    write_flash_string(2200,User1Name)             --用户名字 30个字节
    write_flash_string(2230,User2Name)             --用户名字 30个字节
    write_flash_string(2260,User3Name)             --用户名字 30个字节
end    
-----------------------------------------------------------------------------
--@program: DataReadUserNameFlash()
--@brief:用户名写flash
-------------------------------------------------------------------------------
function DataReadUserNameFlash()
    local User1Name = "User1"
    local User2Name = "User2"
    local User3Name = "User3"

    User1Name = read_flash_string(2200)            --用户名字
    User2Name = read_flash_string(2230)            --用户名字
    User3Name = read_flash_string(2260)            --用户名字

    if(User1Name ~=nil ) then
        UserNameBuf[1] = User1Name
    end
    if(User2Name ~=nil ) then
        UserNameBuf[2] = User2Name
    end
    if(User2Name ~=nil ) then
        UserNameBuf[3] = User3Name
    end
end  
-----------------------------------------------------------------------------
--@program: DataWriteProNameFlash()
--@brief:程序名写flash
-------------------------------------------------------------------------------
function DataWriteProNameFlash()
    local User1Pro1 = "User1"
    local User1Pro2 = "User2"
    local User1Pro3 = "User3"
    local User1Pro4 = "User4"
    local User1Pro5 = "User5"

    local User2Pro1 = "User1"
    local User2Pro2 = "User2"
    local User2Pro3 = "User3"
    local User2Pro4 = "User4"
    local User2Pro5 = "User5"

    local User3Pro1 = "User1"
    local User3Pro2 = "User2"
    local User3Pro3 = "User3"
    local User3Pro4 = "User4"
    local User3Pro5 = "User5"

    User1Pro1 = IMUserProgramIDDataBuf[1][1]
    User1Pro2 = IMUserProgramIDDataBuf[1][2]
    User1Pro3 = IMUserProgramIDDataBuf[1][3]
    User1Pro4 = IMUserProgramIDDataBuf[1][4]
    User1Pro5 = IMUserProgramIDDataBuf[1][5]

    User2Pro1 = IMUserProgramIDDataBuf[2][1]
    User2Pro2 = IMUserProgramIDDataBuf[2][2]
    User2Pro3 = IMUserProgramIDDataBuf[2][3]
    User2Pro4 = IMUserProgramIDDataBuf[2][4]
    User2Pro5 = IMUserProgramIDDataBuf[2][5]

    User3Pro1 = IMUserProgramIDDataBuf[3][1]
    User3Pro2 = IMUserProgramIDDataBuf[3][2]
    User3Pro3 = IMUserProgramIDDataBuf[3][3]
    User3Pro4 = IMUserProgramIDDataBuf[3][4]
    User3Pro5 = IMUserProgramIDDataBuf[3][5]

    flush_flash()
    write_flash_string(3000,User1Pro1)             --用户名字 30个字节
    write_flash_string(3150,User1Pro2)             --用户名字 30个字节
    write_flash_string(3200,User1Pro3)             --用户名字 30个字节
    write_flash_string(3250,User1Pro4)             --用户名字 30个字节
    write_flash_string(3300,User1Pro5)             --用户名字 30个字节

    write_flash_string(3350,User2Pro1)             --用户名字 30个字节
    write_flash_string(3400,User2Pro2)             --用户名字 30个字节
    write_flash_string(3450,User2Pro3)             --用户名字 30个字节
    write_flash_string(3500,User2Pro4)             --用户名字 30个字节
    write_flash_string(3550,User2Pro5)             --用户名字 30个字节

    write_flash_string(3600,User3Pro1)             --用户名字 30个字节
    write_flash_string(3650,User3Pro2)             --用户名字 30个字节
    write_flash_string(3700,User3Pro3)             --用户名字 30个字节
    write_flash_string(3750,User3Pro4)             --用户名字 30个字节
    write_flash_string(3800,User3Pro5)             --用户名字 30个字节

end   

-----------------------------------------------------------------------------
--@program: DataReadProNameFlash()
--@brief:程序名写flash
-------------------------------------------------------------------------------
function DataReadProNameFlash()
    local User1Pro1 = "User1"
    local User1Pro2 = "User2"
    local User1Pro3 = "User3"
    local User1Pro4 = "User4"
    local User1Pro5 = "User5"

    local User2Pro1 = "User1"
    local User2Pro2 = "User2"
    local User2Pro3 = "User3"
    local User2Pro4 = "User4"
    local User2Pro5 = "User5"

    local User3Pro1 = "User1"
    local User3Pro2 = "User2"
    local User3Pro3 = "User3"
    local User3Pro4 = "User4"
    local User3Pro5 = "User5"

    User1Pro1 = read_flash_string(3000)            --用户名字 30个字节
    User1Pro2 = read_flash_string(3150)            --用户名字 30个字节
    User1Pro3 = read_flash_string(3200)            --用户名字 30个字节
    User1Pro4 = read_flash_string(3250)            --用户名字 30个字节
    User1Pro5 = read_flash_string(3300)            --用户名字 30个字节

    User2Pro1 = read_flash_string(3350)            --用户名字 30个字节
    User2Pro2 = read_flash_string(3400)            --用户名字 30个字节
    User2Pro3 = read_flash_string(3450)            --用户名字 30个字节
    User2Pro4 = read_flash_string(3500)            --用户名字 30个字节
    User2Pro5 = read_flash_string(3550)            --用户名字 30个字节

    User3Pro1 = read_flash_string(3600)            --用户名字 30个字节
    User3Pro2 = read_flash_string(3650)            --用户名字 30个字节
    User3Pro3 = read_flash_string(3700)            --用户名字 30个字节
    User3Pro4 = read_flash_string(3750)            --用户名字 30个字节
    User3Pro5 = read_flash_string(3800)            --用户名字 30个字节

    if(User1Pro1 ~=nil ) then                      --用户1
        IMUserProgramIDDataBuf[1][1] = User1Pro1
    end
    if(User1Pro2 ~=nil ) then
        IMUserProgramIDDataBuf[1][2] = User1Pro2
    end
    if(User1Pro3 ~=nil ) then
        IMUserProgramIDDataBuf[1][3] = User1Pro3
    end
    if(User1Pro4 ~=nil ) then
        IMUserProgramIDDataBuf[1][4] = User1Pro4
    end
    if(User1Pro5 ~=nil ) then
        IMUserProgramIDDataBuf[1][5] = User1Pro5
    end
 
    if(User2Pro1 ~=nil ) then                     --用户2
        IMUserProgramIDDataBuf[2][1] = User2Pro1
    end
    if(User2Pro2 ~=nil ) then
        IMUserProgramIDDataBuf[2][2] = User2Pro2
    end
    if(User2Pro3 ~=nil ) then
        IMUserProgramIDDataBuf[2][3] = User2Pro3
    end
    if(User2Pro4 ~=nil ) then
        IMUserProgramIDDataBuf[2][4] = User2Pro4
    end
    if(User2Pro5 ~=nil ) then
        IMUserProgramIDDataBuf[2][5] = User2Pro5
    end
    
    if(User3Pro1 ~=nil ) then                     --用户3
        IMUserProgramIDDataBuf[3][1] = User3Pro1
    end
    if(User3Pro2 ~=nil ) then
        IMUserProgramIDDataBuf[3][2] = User3Pro2
    end
    if(User3Pro3 ~=nil ) then
        IMUserProgramIDDataBuf[3][3] = User3Pro3
    end
    if(User3Pro4 ~=nil ) then
        IMUserProgramIDDataBuf[3][4] = User3Pro4
    end
    if(User3Pro5 ~=nil ) then
        IMUserProgramIDDataBuf[3][5] = User3Pro5
    end
end    
function DataWriteFlash()
    --local CRC16result2 = 0xfefe
    --IM
    --if g_CurrentUser==1 then
        for i=1,5,1 do  --用户1
            for j = 1, 8, 1 do    --速度，扭力，速比，水量，LED
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+1]=IM_User1ProgramBuf[i][j][1]//65536
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+2]=IM_User1ProgramBuf[i][j][1]%65536//256
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+3]=IM_User1ProgramBuf[i][j][1]%256
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+4]=IM_User1ProgramBuf[i][j][2]
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+5]=IM_User1ProgramBuf[i][j][3]
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+6]=IM_User1ProgramBuf[i][j][4]
                g_IMFlashWriteUser1Pro[(i-1)*56+(j-1)*7+7]=IM_User1ProgramBuf[i][j][5]   -- 单个程序56  5个程序 5*56 = 280
            end  
        end       
    --elseif g_CurrentUser==2 then
        for i=1,5,1 do --用户2
            for j = 1, 8, 1 do    --速度，扭力，速比，水量，LED
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+1]=IM_User2ProgramBuf[i][j][1]//65536
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+2]=IM_User2ProgramBuf[i][j][1]%65536//256
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+3]=IM_User2ProgramBuf[i][j][1]%256
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+4]=IM_User2ProgramBuf[i][j][2]
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+5]=IM_User2ProgramBuf[i][j][3]
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+6]=IM_User2ProgramBuf[i][j][4]
                g_IMFlashWriteUser2Pro[(i-1)*56+(j-1)*7+7]=IM_User2ProgramBuf[i][j][5]   -- 单个程序56  5个程序 5*56 = 280
            end  
        end       
    --elseif g_CurrentUser==3 then
        for i=1,5,1 do --用户3
            for j = 1, 8, 1 do    --速度，扭力，速比，水量，LED
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+1]=IM_User3ProgramBuf[i][j][1]//65536
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+2]=IM_User3ProgramBuf[i][j][1]%65536//256
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+3]=IM_User3ProgramBuf[i][j][1]%256
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+4]=IM_User3ProgramBuf[i][j][2]
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+5]=IM_User3ProgramBuf[i][j][3]
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+6]=IM_User3ProgramBuf[i][j][4]
                g_IMFlashWriteUser3Pro[(i-1)*56+(j-1)*7+7]=IM_User3ProgramBuf[i][j][5]   -- 单个程序56  5个程序 5*56 = 280
            end  
        end       
    --end

    --SR 参数
    for i=1,3,1 do
        for j = 1, 9, 1 do  ----,速度，速比，水量，LED
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+1]=g_SR_ProgramBuf[i][j][1]//65536
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+2]=g_SR_ProgramBuf[i][j][1]%65536//256
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+3]=g_SR_ProgramBuf[i][j][1]%256
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+4]=g_SR_ProgramBuf[i][j][2]
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+5]=g_SR_ProgramBuf[i][j][3]
            g_SRFlashWriteUserBuf[(i-1)*54+(j-1)*6+6]=g_SR_ProgramBuf[i][j][4]  --单个程序54   3个用户共162个
        end
    end

    --IM模式 当前步骤数组
    for j = 1, 3, 1 do  
        g_IMFlashWriteStep[(j-1)*5+1]=Steps[j][1]
        g_IMFlashWriteStep[(j-1)*5+2]=Steps[j][2]
        g_IMFlashWriteStep[(j-1)*5+3]=Steps[j][3]
        g_IMFlashWriteStep[(j-1)*5+4]=Steps[j][4]
        g_IMFlashWriteStep[(j-1)*5+5]=Steps[j][5]
    end
    --[[
    --IM模式 步骤的总数
    for j = 1, 3, 1 do  
        g_IMFlashWriteStepNum[(j-1)*5+1]=IM_Step_ProNum[j][1]
        g_IMFlashWriteStepNum[(j-1)*5+2]=IM_Step_ProNum[j][2]
        g_IMFlashWriteStepNum[(j-1)*5+3]=IM_Step_ProNum[j][3]
        g_IMFlashWriteStepNum[(j-1)*5+4]=IM_Step_ProNum[j][4]
        g_IMFlashWriteStepNum[(j-1)*5+5]=IM_Step_ProNum[j][5]
    end
    --IM模式 程序对应的步骤
    for i=1,3,1 do
        for j = 1, 5, 1 do  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+1]=IMUserStepsDataBuf[i][j][1]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+2]=IMUserStepsDataBuf[i][j][2]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+3]=IMUserStepsDataBuf[i][j][3]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+4]=IMUserStepsDataBuf[i][j][4]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+5]=IMUserStepsDataBuf[i][j][5]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+6]=IMUserStepsDataBuf[i][j][6]  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+7]=IMUserStepsDataBuf[i][j][7]  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+8]=IMUserStepsDataBuf[i][j][8]
        end
    end
    ]]

   --各模式当前程序
   FlashWriteBuf2[1] = g_CurrentUser      --当前用户ID
   FlashWriteBuf2[2] = g_UserTatolNum     --当前用户总数
   --模式
   if(SystemMode==1 or SystemMode==2)
   then
       FlashWriteBuf2[3]=SystemMode   
   else
        FlashWriteBuf2[3]=1
   end
   --voice
   FlashWriteBuf2[4]=Voice
   --背光
   FlashWriteBuf2[5]=BackLight

   CRC16result2 =add_crc16(g_SRFlashWriteUserBuf,162)
   FlashWriteBuf2[6]=CRC16result2 //256
   FlashWriteBuf2[7]=CRC16result2 %256
   FlashWriteBuf2[8]=g_SetDarkModeFlag
   FlashWriteBuf2[9]=g_SetReversalFlag
   CRC16resultUser2 =add_crc16(g_IMFlashWriteUser1Pro,280)
   FlashWriteBuf2[10]=CRC16resultUser2 //256
   FlashWriteBuf2[11]=CRC16resultUser2 %256

   flush_flash()
   write_flash(1,g_IMFlashWriteUser1Pro)     --种植用户1  280字节
   write_flash(500,g_IMFlashWriteUser2Pro)   --种植用户1
   write_flash(1000,g_IMFlashWriteUser3Pro)
   write_flash(1500,g_SRFlashWriteUserBuf)   --外科模式参数 162字节
   write_flash(2000,FlashWriteBuf2)          --系统信息 10个字节
   --write_flash(2100,UserIDBuf)               --用户ID 3个字节
   write_flash(2300,g_SR_CurrentStepBuf)     --外科当前步骤 3个字节
   write_flash(2400,Promgrame)               --种植模式三个用户选择的3当前程序 3个字节
   write_flash(2500,g_IMFlashWriteStep)      --种植模式程序的当前步骤 15个字节
   --write_flash(2600,g_IMFlashWriteStepNum)   --种植模式程序对应步骤总数 15个字节
   --write_flash(2700,g_IMFlashWriteStepDate)  --种植模式程序对应的8个步骤 120个字节
   --DataWriteUserNameFlash()                  --写用户名，地址2200
   --DataWriteProNameFlash()                   --种植模式程序名字 
end
-----------------------------------------------------------------------------
--@program: DataWriteFlash_UserScreen()
--@brief:用户设置界面
-------------------------------------------------------------------------------
function DataWriteFlash_UserScreen()
   flush_flash()
   write_flash(2100,UserIDBuf)               --用户ID 3个字节
   DataWriteUserNameFlash()                  --写用户名，地址2200
end    
-----------------------------------------------------------------------------
--@program: DataWriteFlash_StepSetScreen()
--@brief:步骤设置界面
-------------------------------------------------------------------------------
function DataWriteFlash_StepSetScreen()
    --IM模式 步骤的总数
    for j = 1, 3, 1 do  
        g_IMFlashWriteStepNum[(j-1)*5+1]=IM_Step_ProNum[j][1]
        g_IMFlashWriteStepNum[(j-1)*5+2]=IM_Step_ProNum[j][2]
        g_IMFlashWriteStepNum[(j-1)*5+3]=IM_Step_ProNum[j][3]
        g_IMFlashWriteStepNum[(j-1)*5+4]=IM_Step_ProNum[j][4]
        g_IMFlashWriteStepNum[(j-1)*5+5]=IM_Step_ProNum[j][5]
    end
    --IM模式 程序对应的步骤
    for i=1,3,1 do
        for j = 1, 5, 1 do  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+1]=IMUserStepsDataBuf[i][j][1]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+2]=IMUserStepsDataBuf[i][j][2]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+3]=IMUserStepsDataBuf[i][j][3]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+4]=IMUserStepsDataBuf[i][j][4]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+5]=IMUserStepsDataBuf[i][j][5]
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+6]=IMUserStepsDataBuf[i][j][6]  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+7]=IMUserStepsDataBuf[i][j][7]  
            g_IMFlashWriteStepDate[(i-1)*40+(j-1)*8+8]=IMUserStepsDataBuf[i][j][8]
        end
    end
    flush_flash()
    write_flash(2600,g_IMFlashWriteStepNum)   --种植模式程序对应步骤总数 15个字节
    write_flash(2700,g_IMFlashWriteStepDate)  --种植模式程序对应的8个步骤 120个字节
    DataWriteProNameFlash()                   --种植模式程序名字 
 end    
function DataReadFlashInit()

    --local CRC16result = 0xFFFF
    local CurrentLanguage = 0xFF
    
    g_IMFlashReadUser1Pro = read_flash(1,300)      --种植界面参数
    g_IMFlashReadUser2Pro = read_flash(500,300)
    g_IMFlashReadUser3Pro = read_flash(1000,300)
 
    g_SRFlashReadUserBuf = read_flash(1500,180)    --外科界面参数

    FlashReadBuf2 = read_flash(2000,12)            --系统信息 10个字节

    g_IMFlashReadStep = read_flash(2500,20)        --种植模式程序的当前步骤 15个字节
    g_IMFlashReadStepNum = read_flash(2600,20)     --种植模式程序对应步骤总数 15个字节
    g_IMFlashReadStepDate = read_flash(2700,130)   --种植模式程序对应的8个步骤 120个字节
    DataReadProNameFlash()                         --程序名字

    FlashReadBuf4 = read_flash(4920,2)
    FlashReadBuf3 = read_flash(4900,1)

    SNCODE=read_flash_string(5000)

    if(FlashReadBuf4[1] == 1)then                        --语言切换标志位
        if(FlashReadBuf4[0]~=0 and FlashReadBuf4[0]~=1)
        then
            FlashReadBuf4[0]=Language
        end
        Language=FlashReadBuf4[0]
    end

	if(SNCODE==nil)
	then
		SNCODE="ZZZZZZZZ"
	end	
    SNInEnFlag=FlashReadBuf3[0]
    if(SNInEnFlag~=0x01)
    then
        SNInEnFlag=0x10
    end



    CRC16result=add_crc16(g_SRFlashReadUserBuf,162) --CRC校验
    CRC16resultUser=add_crc16(g_IMFlashReadUser1Pro,280) --CRC校验
    if(CRC16result == (FlashReadBuf2[6]*256+FlashReadBuf2[7]) and CRC16resultUser == (FlashReadBuf2[10]*256+FlashReadBuf2[11]))
    then 
        --当前程序
        if(FlashReadBuf2[1]~=nil and FlashReadBuf2[1] >0 and FlashReadBuf2[1]<4) then
            g_CurrentUser=FlashReadBuf2[1]
        else
            g_CurrentUser= 0x01
        end
        -- 用户总数
        if(FlashReadBuf2[2]~=nil and FlashReadBuf2[2]>0 and FlashReadBuf2[2]<4 )then
            g_UserTatolNum=FlashReadBuf2[2]
        end
        --声音
        if(FlashReadBuf2[4]<2)
        then
            Voice = FlashReadBuf2[4]
        else
            Voice = 1
        end
    
        --背光亮度
        if(FlashReadBuf2[5]>0 and FlashReadBuf2[5]<4)
        then
            BackLight = FlashReadBuf2[5]
        else
            BackLight = 3
        end 
    
        --模式
        if(FlashReadBuf2[3]==2)
        then
            ReadSystemMode=2
        else
            ReadSystemMode=1
        end

        --当前背景模式 白天还是黑夜
        if(FlashReadBuf2[8]~=nil and FlashReadBuf2[8]<2) then
            g_SetDarkModeFlag=FlashReadBuf2[8]
        end

        --反转模式
        if(FlashReadBuf2[9]~=nil and FlashReadBuf2[9]<2) then
            g_SetReversalFlag=FlashReadBuf2[9]
        end

        UserIDBuf = read_flash(2100,4)                 --用户ID 3个字节
        DataReadUserNameFlash()                        --用户名字
        g_SR_CurrentStepBuf = read_flash(2300,4)       --外科当前步骤 3个字节
        Promgrame = read_flash(2400,4)                 --种植模式三个用户选择的3当前程序 3个字节

     --IM数据  --速度，扭力，速比，水量，LED 
        for i = 1, 5, 1 do      --种植用户1
            for j = 1, 8, 1 do
                if(g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+1]~=nil and g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+2]~=nil and g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+3]~=nil)--速度
                then
                    IM_User1ProgramBuf[i][j][1]=g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+1]*65536+g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+2]*256+g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+3]
                end      
                if(g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+4]~=nil)--扭力
                then
                    IM_User1ProgramBuf[i][j][2]=g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+4]
                end
                if(g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+5]~=nil)--速比 9-13
                then
                    if( g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+5]>0 and g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+5]<16)
                    then
                        IM_User1ProgramBuf[i][j][3]=g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+5]
                    else
                        --超过速比范围值则不改变默认值
                    end
                end
                if(g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+6]~=nil)--水量
                then
                    IM_User1ProgramBuf[i][j][4]=g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+6]
                end
                if(g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+7]~=nil)--led
                then
                    IM_User1ProgramBuf[i][j][5]=g_IMFlashReadUser1Pro[(i-1)*56+(j-1)*7+7]
                end
            end 
        end    
        for i = 1, 5, 1 do      --种植用户2
            for j = 1, 8, 1 do
                if(g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+1]~=nil and g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+2]~=nil and g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+3]~=nil)--速度
                then
                    IM_User2ProgramBuf[i][j][1]=g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+1]*65536+g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+2]*256+g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+3]
                end      
                if(g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+4]~=nil)--扭力
                then
                    IM_User2ProgramBuf[i][j][2]=g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+4]
                end
                if(g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+5]~=nil)--速比 9-13
                then
                    if( g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+5]>0 and g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+5]<16)
                    then
                        IM_User2ProgramBuf[i][j][3]=g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+5]
                    else
                        --超过速比范围值则不改变默认值
                    end
                end
                if(g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+6]~=nil)--水量
                then
                    IM_User2ProgramBuf[i][j][4]=g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+6]
                end
                if(g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+7]~=nil)--led
                then
                    IM_User2ProgramBuf[i][j][5]=g_IMFlashReadUser2Pro[(i-1)*56+(j-1)*7+7]
                end
            end 
        end    
        for i = 1, 5, 1 do      --种植用户3
            for j = 1, 8, 1 do
                if(g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+1]~=nil and g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+2]~=nil and g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+3]~=nil)--速度
                then
                    IM_User3ProgramBuf[i][j][1]=g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+1]*65536+g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+2]*256+g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+3]
                end      
                if(g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+4]~=nil)--扭力
                then
                    IM_User3ProgramBuf[i][j][2]=g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+4]
                end
                if(g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+5]~=nil)--速比 9-13
                then
                    if( g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+5]>0 and g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+5]<16)
                    then
                        IM_User3ProgramBuf[i][j][3]=g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+5]
                    else
                        --超过速比范围值则不改变默认值
                    end
                end
                if(g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+6]~=nil)--水量
                then
                    IM_User3ProgramBuf[i][j][4]=g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+6]
                end
                if(g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+7]~=nil)--led
                then
                    IM_User3ProgramBuf[i][j][5]=g_IMFlashReadUser3Pro[(i-1)*56+(j-1)*7+7]
                end
            end 
        end            
        --SR数据  --速度，速比，水量，LED
        for i=1,3,1 do
            for j = 1, 9, 1 do
                if(g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+1]~=nil and g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+2]~=nil and g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+3]~=nil)--速度
                then
                    g_SR_ProgramBuf[i][j][1]=g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+1]*65536+g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+2]*256+g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+3]
                end      
                if(g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+4]~=nil)--速比 1-11
                then
                    if( g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+4]>0 and g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+4]<16)
                    then
                        g_SR_ProgramBuf[i][j][2]=g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+4]
                    else
                        --超过速比范围值则不改变默认值
                    end
                end
                if(g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+5]~=nil)--水量
                then
                    g_SR_ProgramBuf[i][j][3]=g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+5]
                end
                if(g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+6]~=nil)--led
                then
                    g_SR_ProgramBuf[i][j][4]=g_SRFlashReadUserBuf[(i-1)*54+(j-1)*6+6]
                end
            end
        end
         --IM模式 当前步骤数组
        for j = 1, 3, 1 do
            if(g_IMFlashReadStep[(j-1)*5+1]~=nil )
            then
                Steps[j][1]=g_IMFlashReadStep[(j-1)*5+1]
            end      
            if(g_IMFlashReadStep[(j-1)*5+2]~=nil)
            then
                Steps[j][2]=g_IMFlashReadStep[(j-1)*5+2]
            end
            if(g_IMFlashReadStep[(j-1)*5+3]~=nil)
            then
                Steps[j][3]=g_IMFlashReadStep[(j-1)*5+3]
            end
            if(g_IMFlashReadStep[(j-1)*5+4]~=nil)
            then
                Steps[j][4]=g_IMFlashReadStep[(j-1)*5+4]
            end
            if(g_IMFlashReadStep[(j-1)*5+5]~=nil)
            then
                Steps[j][5]=g_IMFlashReadStep[(j-1)*5+5]
            end
        end

        --IM模式 步骤的总数
         for j = 1, 3, 1 do
            if(g_IMFlashReadStepNum[(j-1)*5+1]~=nil )
            then
                IM_Step_ProNum[j][1]=g_IMFlashReadStepNum[(j-1)*5+1]
            end      
            if(g_IMFlashReadStepNum[(j-1)*5+2]~=nil)
            then
                IM_Step_ProNum[j][2]=g_IMFlashReadStepNum[(j-1)*5+2]
            end
            if(g_IMFlashReadStepNum[(j-1)*5+3]~=nil)
            then
                IM_Step_ProNum[j][3]=g_IMFlashReadStepNum[(j-1)*5+3]
            end
            if(g_IMFlashReadStepNum[(j-1)*5+4]~=nil)
            then
                IM_Step_ProNum[j][4]=g_IMFlashReadStepNum[(j-1)*5+4]
            end
            if(g_IMFlashReadStepNum[(j-1)*5+5]~=nil)
            then
                IM_Step_ProNum[j][5]=g_IMFlashReadStepNum[(j-1)*5+5]
            end
        end
        --IM模式 程序对应的步骤
        for i=1,3,1 do
            for j = 1, 5, 1 do
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+1]~=nil) then
                   IMUserStepsDataBuf[i][j][1] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+1]
                end
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+2]~=nil) then
                    IMUserStepsDataBuf[i][j][2] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+2]
                end
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+3]~=nil) then
                    IMUserStepsDataBuf[i][j][3] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+3]
                end     
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+4]~=nil) then
                    IMUserStepsDataBuf[i][j][4] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+4]
                end   
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+5]~=nil) then
                    IMUserStepsDataBuf[i][j][5] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+5]
                end      
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+6]~=nil) then
                    IMUserStepsDataBuf[i][j][6] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+6]
                end        
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+7]~=nil) then
                    IMUserStepsDataBuf[i][j][7] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+7]
                end    
                if(g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+8]~=nil) then
                    IMUserStepsDataBuf[i][j][8] = g_IMFlashReadStepDate[(i-1)*40+(j-1)*8+8]
                end                                                      
            end
        end
    else
        ResetData_AllUser()
    end
end
---------------------------按键音----------------------------
function KeyBeep_App()
    if(Voice==1)
    then
        beep(100)
    end
end
---------------------------错误音蜂鸣器-------------------------
function ErroBeep_App()
	if(Voice==1)
	then
		if(Errbeepstep==0)
		then
			Errbeepstep=1
		end
		ErrBeep=1
	end
end
----------------------蓝牙连接提示音------------------------
function BLEBeep_App()
	if(Voice==1)
	then
		if(Errbeepstep==0)
		then
			Errbeepstep=1
        end	
		BLEBeep=1
	end
end
----------------------马达超扭力停提示音--------------------
function MotorStopBeep_App()
--    if(Voice==1)
--    then
        if(MotorStopbeepstep==0)
        then
            MotorStopbeepstep=1
        end

        if(MotorStopBeep==0)
        then
            MotorStopBeep=1
        end
--    end   
end
----------------------完成提醒音蜂鸣器-----------------------·
function NoteBeep_App()
	if(Voice==1)
	then
		if(Errbeepstep==0)
		then
			Errbeepstep=1
		end
		NoteBeep=1
	end
end
----------------------脚踏低电量提示蜂鸣器--------------------
function FootLowPowerBeep_App()
	if(Voice==1)
	then
		if(Errbeepstep==0)
		then
			Errbeepstep=1
		end
		FootLowPowerBeep=1
	end
end
--------------------------背光函数------------------------
function Backlight_App()
     if(BackLight==1)
    then
        set_backlight(40)	
    elseif(BackLight==2)
    then
        set_backlight(70)	
    elseif(BackLight==3)
    then
        set_backlight(100)	
    end
end
----------------------异或校验函数---------------------------
function 
    XOR_CRC(data, n)
    local i = 0   
    local csum_cal = 0
    for i = 0,n-1,1
    do
        csum_cal=csum_cal ~ data[i]
    end
    return csum_cal
end
--calculate CRC16
--@data : t, data to be verified
--@n    : number of verified
--@return : check result
function add_crc16(data, n)

    local  i, j, carry_flag, a = 0
    local result = 0xffff
   
    for i = 1, n
    do
        result = result ~ data[i]
        for j = 0, 7
        do
            a = result
            carry_flag = a & 0x0001
            result = result >> 1
            if carry_flag == 1
            then
                 result = result ~ 0xa001
            end
        end
    end
    return result
end

function UserScreen_Run(control,value)   --用户界面

    if(g_UserSetFlag == 1)then   --进入用户管理页面
        RegistUser(control,value)                --增加用户
        Delete_User_Confirm(control,value)       --删除用户确认弹窗 
        --[[
        if(control==g_UserSetButton and value==1) then    --保存按钮与用户设置按键共用

            g_UserTatolNum = g_TempUserTatolNum     --用户总数量
            for i=1,3,1 do
            UserIDBuf[i] =  TempUserIDBuf[i]        --用户编号（默认）按123排列
            end
            for i=1,3,1 do
            UserNameBuf[i] = TempUserNameBuf[i] 
            end 
            g_UserDataChangeFlag = 0x00            --保存后改变标志位清零 
            KeyBeep_App()       --按键音

            StartFlashWrite_App()    --保存写flash
        end
        ]]
        if(control==g_UserExitButton and value==1) then    --退出按钮 
            if(g_TempUserTatolNum == 0x00)then     --清空恢复默认用户
                change_child_screen(4)
                SystemMode=4
                POP_WindowNum=16
                WindowScreen_Show()
                KeyBeep_App()
            elseif(g_UserDataChangeFlag == 0x01)then --数据有改变
                change_child_screen(4)
                SystemMode=4
                POP_WindowNum=14
                WindowScreen_Show()
                KeyBeep_App()
            else
                g_UserSetFlag = 0                    --退出用户管理页面
                UserScreen_Show()                    
                KeyBeep_App() 

            end    
            --set_enable(8,g_UserSetButton,1)         --使能保存按键
        end 
        if(control==g_UserFisrtNameButton and value==1) then        --编辑用户名1 
            g_ChangeFirstUserNameFlag = 0x01
            if g_SetDarkModeFlag == 1 then
                SystemMode=16
                change_screen(16)
            else    
                SystemMode=9
                change_screen(9)                
            end
            --KeyBeep_App()      
        elseif(control==g_UserThreeNameButton and value==1) then    --编辑用户名2 
            g_ChangeSecondUserNameFlag = 0x01
            if g_SetDarkModeFlag == 1 then
                SystemMode=16
                change_screen(16)
            else    
                SystemMode=9
                change_screen(9)                
            end
            --KeyBeep_App()   
        elseif(control==g_UserFiveNameButton and value==1) then    --编辑用户名2  
            g_ChangeThreeUserNameFlag = 0x01
            if g_SetDarkModeFlag == 1 then
                SystemMode=16
                change_screen(16)
            else    
                SystemMode=9
                change_screen(9)                
            end
            --KeyBeep_App()               
        end
    else                         --正常用户界面  
        if(g_UserTatolNum == 1)then                       
            if(control==g_UserThreeButton and value==1) then    --用户1按键
                g_CurrentUser = g_FirstID 
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            end
        elseif(g_UserTatolNum == 2)then                       
            if(control==g_UserSecondButton and value==1) then    --用户1按键
                g_CurrentUser = g_FirstID 
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            elseif(control==g_UserFourButton and value==1)then 
                g_CurrentUser = g_SecondID
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            end            
        elseif(g_UserTatolNum == 3)then
            if(control==g_UserFisrtButton and value==1) then    --用户1按键
                g_CurrentUser = g_FirstID 
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            elseif(control==g_UserThreeButton and value==1)then 
                g_CurrentUser = g_SecondID
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            elseif(control==g_UserFiveButton and value==1)then 
                g_CurrentUser = g_ThreeID
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
                SystemMode = SystemModeBeforSet
                change_screen(SystemMode) 
                System_Mode_Screen_Change_Show(SystemMode)

                Motordirection=0     
                ScreenSetDire=0
                ChangeStep_SystemMode=1
            end
        end
        if(control==g_UserSetButton and value==1) then           --用户设置按键
            g_UserSetFlag = 1                       --用户设置界面标志位置1
            g_TempUserTatolNum = g_UserTatolNum     --临时用户总数量
            for i=1,3,1 do
            TempUserIDBuf[i] =  UserIDBuf[i]        --临时用户编号（默认）按123排列
            end
            for i=1,3,1 do
            TempUserNameBuf[i] =  UserNameBuf[i] 
            end
            EnterUserScreen_show()    
            
            KeyBeep_App()  --按键音
            g_UserCountBackCnt = 0                       --用户界面倒计时清零
            --stop_timer(g_UserCountBackTime_1s)
            g_UserDataChangeFlag =0x00                   --清空用户数据标改变志位
        end             
    end    
--[[
    if(control==67 and value==1) then --新增用户
        for i=1,3,1 do                --个用户
            if(UserIDBuf[i] == 0xFF) then
                tempid = i
                break
            end    
        end
        
        --标志位置TRUE
        --显示置1
        --
    end 
    if(control==67 and value==1) then --保存按钮
        for i=1,3,1 do                --个用户
            if(UserIDBuf[i] == 0xFF) then
                tempid = i
                break
            end    
        end

        g_UserTatolNum = g_TempUserTatolNum     --用户总数量
        for i=1,3,1 do
        UserIDBuf[i] =  TempUserIDBuf[i]        --用户编号（默认）按123排列
        end
        for i=1,3,1 do
        UserNameBuf[i] = TempUserNameBuf[i] 
        end   
                     --保存写flash
    end  
    ]]      
end   
function UserScreen_Back_Show()   --用户界面背景显示
    if g_SetDarkModeFlag == 1 then
        set_value(8,g_UserScreenBackIcon,1)
        set_visiable(8,g_UserScreenBackIcon,1)   
    else
        set_value(8,g_UserScreenBackIcon,0)
        set_visiable(8,g_UserScreenBackIcon,1) 
    end
end    
function UserScreen_Show()   --用户界面
    
    local FirstNum = "U"
    local UserFirstFlag = 0

    --set_text(8,61,"g_UserSetFlag = "..g_UserSetFlag)
    --set_text(8,62,"g_UserTatolNum="..g_UserTatolNum)
    --set_text(8,63,"g_TempUserTatolNum="..g_TempUserTatolNum)

    UserScreen_Back_Show()  --用户设置界面背景
    User_Control_Set()

    if(g_UserSetFlag == 1)then   --进入用户管理页面
        --[[
        if(g_TempUserTatolNum == 1)then
            for i=1,3,1 do         --个用户
                if(TempUserIDBuf[i] ~= 0xFF) then 
                set_text(8, g_UserFisrtNameText,UserNameBuf[i])
                set_visiable(8, g_UserFisrtNameText,1)
                FirstNum = string.sub(UserNameBuf[i],1,1)
                set_text(8,g_HeadFisrtNameText,FirstNum)
                set_visiable(8,g_HeadFisrtNameText,1)
                g_FirstID = UserIDBuf[i]           
                break
                end    
            end
        elseif(g_TempUserTatolNum == 2)then 

        elseif(g_TempUserTatolNum == 3)then
            
        end 
        

        if g_TempUserTatolNum == 0 then    --清除用户后
            set_value(8,g_UserSaveIcon,1+Language*2+g_SetDarkModeFlag*4)
            set_visiable(8,g_UserSaveIcon,1) 
            set_enable(8,g_UserSetButton,0)         --失能保存按键
        elseif(g_UserDataChangeFlag == 0x01)then
            set_value(8,g_UserSaveIcon,0+Language*2+g_SetDarkModeFlag*4)
            set_visiable(8,g_UserSaveIcon,1)  
            set_enable(8,g_UserSetButton,1)         --使能保存按键    
        else
            set_value(8,g_UserSaveIcon,1+Language*2+g_SetDarkModeFlag*4)
            set_visiable(8,g_UserSaveIcon,1) 
            set_enable(8,g_UserSetButton,0)         --失能保存按键
        end   
        ]]
    else                       --正常用户界面
        if(g_UserTatolNum == 1) then
            for i=1,3,1 do         --个用户
                if(UserIDBuf[i] ~= 0xFF) then 
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserThreeNameText_Black,UserNameBuf[i])
                        set_visiable(8,g_UserThreeNameText_Black,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadThreeNameText_Black,FirstNum)
                        set_visiable(8,g_HeadThreeNameText_Black,1)
                    else    
                        set_text(8,g_UserThreeNameText,UserNameBuf[i])
                        set_visiable(8,g_UserThreeNameText,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadThreeNameText,FirstNum)
                        set_visiable(8,g_HeadThreeNameText,1) 
                    end
                    g_FirstID = UserIDBuf[i] 
                    g_CurrentUser = UserIDBuf[i]   --当前用户   
                    
                    set_value(8,g_UserThreeIcon,UserIDBuf[i])
                    set_visiable(8,g_UserThreeIcon,1)  --显示用户头像
                break
                end    
            end
        elseif(g_UserTatolNum == 2) then  
            for i=1,3,1 do         --个用户
                if(UserIDBuf[i] ~= 0xFF and UserFirstFlag == 0) then 
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserSecondNameText_Black,UserNameBuf[i])
                        set_visiable(8,g_UserSecondNameText_Black,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadSecondNameText_Black,FirstNum)
                        set_visiable(8,g_HeadSecondNameText_Black,1)
                    else
                        set_text(8,g_UserSecondNameText,UserNameBuf[i])
                        set_visiable(8,g_UserSecondNameText,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadSecondNameText,FirstNum)
                        set_visiable(8,g_HeadSecondNameText,1)                        
                    end    
                    UserFirstFlag = 1           
                    g_FirstID = UserIDBuf[i]

                    set_value(8,g_UserSecondIcon,UserIDBuf[i])
                    set_visiable(8,g_UserSecondIcon,1)  --显示用户头像

                elseif(UserIDBuf[i] ~= 0xFF and UserFirstFlag == 1) then
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFourNameText_Black,UserNameBuf[i])
                        set_visiable(8,g_UserFourNameText_Black,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadFourNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFourNameText_Black,1)                        
                    else
                        set_text(8,g_UserFourNameText,UserNameBuf[i])
                        set_visiable(8,g_UserFourNameText,1)
                        FirstNum = string.sub(UserNameBuf[i],1,1)
                        set_text(8,g_HeadFourNameText,FirstNum)
                        set_visiable(8,g_HeadFourNameText,1)                        
                    end    
                    UserFirstFlag = 0 
                    g_SecondID = UserIDBuf[i]   
                    
                    set_value(8,g_UserFourIcon,UserIDBuf[i])
                    set_visiable(8,g_UserFourIcon,1)  --显示用户头像
                end                
            end

            if(g_CurrentUser == g_FirstID)then        --显示选中图标
                set_value(8,g_UserSecondSelectIcon,0)
                set_visiable(8,g_UserSecondSelectIcon,1)
            elseif(g_CurrentUser == g_SecondID)then
                set_value(8,g_UserFourSelectIcon,0)
                set_visiable(8,g_UserFourSelectIcon,1)
            --elseif(g_CurrentUser == 0xFF)then
            else
                g_CurrentUser = g_FirstID
                set_value(8,g_UserSecondSelectIcon,0)
                set_visiable(8,g_UserSecondSelectIcon,1)
            end             
        elseif(g_UserTatolNum == 3) then
            if g_SetDarkModeFlag == 1 then
                set_text(8,g_UserFisrtNameText_Black,UserNameBuf[1]) --用户1
                set_visiable(8,g_UserFisrtNameText_Black,1)
                FirstNum = string.sub(UserNameBuf[1],1,1)
                set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                set_visiable(8,g_HeadFisrtNameText_Black,1) 
            else
                set_text(8,g_UserFisrtNameText,UserNameBuf[1]) --用户1
                set_visiable(8,g_UserFisrtNameText,1)
                FirstNum = string.sub(UserNameBuf[1],1,1)
                set_text(8,g_HeadFisrtNameText,FirstNum)
                set_visiable(8,g_HeadFisrtNameText,1) 
            end        
            g_FirstID = UserIDBuf[1]
            set_value(8,g_UserFisrtIcon,UserIDBuf[1])
            set_visiable(8,g_UserFisrtIcon,1)  --显示用户头像

            if g_SetDarkModeFlag == 1 then
                set_text(8,g_UserThreeNameText_Black,UserNameBuf[2]) --用户2
                set_visiable(8,g_UserThreeNameText_Black,1)
                FirstNum = string.sub(UserNameBuf[2],1,1)
                set_text(8,g_HeadThreeNameText_Black,FirstNum)
                set_visiable(8,g_HeadThreeNameText_Black,1)
            else
                set_text(8,g_UserThreeNameText,UserNameBuf[2]) --用户2
                set_visiable(8,g_UserThreeNameText,1)
                FirstNum = string.sub(UserNameBuf[2],1,1)
                set_text(8,g_HeadThreeNameText,FirstNum)
                set_visiable(8,g_HeadThreeNameText,1)                
            end    
            g_SecondID = UserIDBuf[2]
            set_value(8,g_UserThreeIcon,UserIDBuf[2])
            set_visiable(8,g_UserThreeIcon,1)  --显示用户头像

            if g_SetDarkModeFlag == 1 then
                set_text(8,g_UserFiveNameText_Black,UserNameBuf[3]) --用户3
                set_visiable(8,g_UserFiveNameText_Black,1)
                FirstNum = string.sub(UserNameBuf[3],1,1)
                set_text(8,g_HeadFiveNameText_Black,FirstNum)
                set_visiable(8,g_HeadFiveNameText_Black,1)
            else
                set_text(8,g_UserFiveNameText,UserNameBuf[3]) --用户3
                set_visiable(8,g_UserFiveNameText,1)
                FirstNum = string.sub(UserNameBuf[3],1,1)
                set_text(8,g_HeadFiveNameText,FirstNum)
                set_visiable(8,g_HeadFiveNameText,1)               
            end    
            g_ThreeID = UserIDBuf[3]
            set_value(8,g_UserFivetIcon,UserIDBuf[3])
            set_visiable(8,g_UserFivetIcon,1)  --显示用户头像

            if(g_CurrentUser == UserIDBuf[1])then      --显示选中图标
                set_value(8,g_UserFisrtSelectIcon,0)
                set_visiable(8,g_UserFisrtSelectIcon,1)
            elseif(g_CurrentUser == UserIDBuf[2])then
                set_value(8,g_UserThreeSelectIcon,0)
                set_visiable(8,g_UserThreeSelectIcon,1)
            elseif(g_CurrentUser == UserIDBuf[3])then
                set_value(8,g_UserFiveSelectIcon,0)
                set_visiable(8,g_UserFiveSelectIcon,1)              
            --elseif(g_CurrentUser == 0xFF)then
            else
                g_CurrentUser = UserIDBuf[1]
                set_value(8,g_UserFisrtSelectIcon,0)
                set_visiable(8,g_UserFisrtSelectIcon,1)
            end       
        end          
    end

    --[[
    for i=1,3,1 do         --个用户
        if(UserSetBuf[i] ~= 0xFF) then 
        break;
        end    
    end
    ]]
end   
function User_Control_Set() --用户界面控件显示设置

    if(g_UserSetFlag == 1)then   --进入用户管理页面
       
    else                                     --正常启动用户界面
        if(g_UserTatolNum == 1) then

            set_value(8,g_UserThreeIcon,0)
            set_visiable(8,g_UserFisrtIcon,0)
            set_visiable(8,g_UserSecondIcon,0)
            set_visiable(8,g_UserThreeIcon,1)
            set_visiable(8,g_UserFourIcon,0)
            set_visiable(8,g_UserFivetIcon,0)

            set_value(8,g_UserThreeSelectIcon,0)
            set_visiable(8,g_UserFisrtSelectIcon,0)
            set_visiable(8,g_UserSecondSelectIcon,0)
            set_visiable(8,g_UserThreeSelectIcon,1)
            set_visiable(8,g_UserFourSelectIcon,0)
            set_visiable(8,g_UserFiveSelectIcon,0)

            set_visiable(8,g_UserFisrtNameIcon,0)   --关闭用户名背景图标
            set_visiable(8,g_UserSecondNameIcon,0)
            set_visiable(8,g_UserThreeNameIcon,0)
            set_visiable(8,g_UserFourNameIcon,0)
            set_visiable(8,g_UserFiveNameIcon,0)

            set_visiable(8,g_HeadFisrtNameText,0)   
            set_visiable(8,g_HeadSecondNameText,0)
            set_visiable(8,g_HeadThreeNameText,0)
            set_visiable(8,g_HeadFourNameText,0)
            set_visiable(8,g_HeadFiveNameText,0)    

            set_visiable(8,g_UserFisrtNameText,0)  
            set_visiable(8,g_UserSecondNameText,0)
            set_visiable(8,g_UserThreeNameText,0)
            set_visiable(8,g_UserFourNameText,0)
            set_visiable(8,g_UserFiveNameText,0)          
            
            set_visiable(8,g_HeadFisrtNameText_Black,0)   
            set_visiable(8,g_HeadSecondNameText_Black,0)
            set_visiable(8,g_HeadThreeNameText_Black,0)
            set_visiable(8,g_HeadFourNameText_Black,0)
            set_visiable(8,g_HeadFiveNameText_Black,0)    

            set_visiable(8,g_UserFisrtNameText_Black,0)  
            set_visiable(8,g_UserSecondNameText_Black,0)
            set_visiable(8,g_UserThreeNameText_Black,0)
            set_visiable(8,g_UserFourNameText_Black,0)
            set_visiable(8,g_UserFiveNameText_Black,0)   

            set_enable(8,g_UserFisrtButton,0)  
            set_enable(8,g_UserSecondButton,0)
            set_enable(8,g_UserThreeButton,1)
            set_enable(8,g_UserFourButton,0)
            set_enable(8,g_UserFiveButton,0)

            set_enable(8,g_UserFisrtNameButton,0)  
            set_enable(8,g_UserSecondNameButton,0)
            set_enable(8,g_UserThreeNameButton,0)
            set_enable(8,g_UserFourNameButton,0)
            set_enable(8,g_UserFiveNameButton,0)

            set_enable(8,g_UserFisrtSelectButton,0)  
            set_enable(8,g_UserSecondSelectButton,0)
            set_enable(8,g_UserThreeSelectButton,0)
            set_enable(8,g_UserFourSelectButton,0)
            set_enable(8,g_UserFiveSelectButton,0)

            set_enable(8,g_UserSetButton,1)         --进入用户设置按钮
            set_value(8,g_UserSetRightIcon,0+Language*1+g_SetDarkModeFlag*2)       --图标
            set_visiable(8,g_UserSetRightIcon,1) 

            set_value(8,g_UserSetLeftIcon,0+Language*1+g_SetDarkModeFlag*2)
            set_visiable(8,g_UserSetLeftIcon,0)           

            set_visiable(8,g_UserExitIcon,0)        --退出图标
            set_enable(8,g_UserExitButton,0)        --按键
            set_visiable(8, g_UserSaveIcon,0)

        elseif(g_UserTatolNum == 2) then 
            
            set_value(8,g_UserSecondIcon,0)
            set_value(8,g_UserFourIcon,0)
            set_visiable(8,g_UserFisrtIcon,0)
            set_visiable(8,g_UserSecondIcon,1)
            set_visiable(8,g_UserThreeIcon,0)
            set_visiable(8,g_UserFourIcon,1)
            set_visiable(8,g_UserFivetIcon,0)

            set_visiable(8,g_UserFisrtSelectIcon,0)  --默认第一个被选中
            set_visiable(8,g_UserSecondSelectIcon,0)
            set_visiable(8,g_UserThreeSelectIcon,0)
            set_visiable(8,g_UserFourSelectIcon,0)
            set_visiable(8,g_UserFiveSelectIcon,0)

            set_visiable(8,g_UserFisrtNameIcon,0)   --关闭用户名背景图标
            set_visiable(8,g_UserSecondNameIcon,0)
            set_visiable(8,g_UserThreeNameIcon,0)
            set_visiable(8,g_UserFourNameIcon,0)
            set_visiable(8,g_UserFiveNameIcon,0)

            set_visiable(8,g_HeadFisrtNameText,0)   
            set_visiable(8,g_HeadSecondNameText,0)
            set_visiable(8,g_HeadThreeNameText,0)
            set_visiable(8,g_HeadFourNameText,0)
            set_visiable(8,g_HeadFiveNameText,0)    

            set_visiable(8,g_UserFisrtNameText,0)  
            set_visiable(8,g_UserSecondNameText,0)
            set_visiable(8,g_UserThreeNameText,0)
            set_visiable(8,g_UserFourNameText,0)
            set_visiable(8,g_UserFiveNameText,0)          
            
            set_visiable(8,g_HeadFisrtNameText_Black,0)   
            set_visiable(8,g_HeadSecondNameText_Black,0)
            set_visiable(8,g_HeadThreeNameText_Black,0)
            set_visiable(8,g_HeadFourNameText_Black,0)
            set_visiable(8,g_HeadFiveNameText_Black,0)    

            set_visiable(8,g_UserFisrtNameText_Black,0)  
            set_visiable(8,g_UserSecondNameText_Black,0)
            set_visiable(8,g_UserThreeNameText_Black,0)
            set_visiable(8,g_UserFourNameText_Black,0)
            set_visiable(8,g_UserFiveNameText_Black,0)                   

            set_enable(8,g_UserFisrtButton,0)  
            set_enable(8,g_UserSecondButton,1)      --开启触摸选中功能
            set_enable(8,g_UserThreeButton,0)
            set_enable(8,g_UserFourButton,1) 
            set_enable(8,g_UserFiveButton,0)

            set_enable(8,g_UserFisrtNameButton,0)  
            set_enable(8,g_UserSecondNameButton,0)
            set_enable(8,g_UserThreeNameButton,0)
            set_enable(8,g_UserFourNameButton,0)
            set_enable(8,g_UserFiveNameButton,0)

            set_enable(8,g_UserFisrtSelectButton,0)  
            set_enable(8,g_UserSecondSelectButton,0)
            set_enable(8,g_UserThreeSelectButton,0)
            set_enable(8,g_UserFourSelectButton,0)
            set_enable(8,g_UserFiveSelectButton,0)

            set_enable(8,g_UserSetButton,1)         --进入用户设置按钮
            set_value(8,g_UserSetRightIcon,0+Language*1+g_SetDarkModeFlag*2)       --图标
            set_visiable(8,g_UserSetRightIcon,1) 

            set_value(8,g_UserSetLeftIcon,0+Language*1+g_SetDarkModeFlag*2)
            set_visiable(8,g_UserSetLeftIcon,0)

            set_visiable(8,g_UserExitIcon,0)        --退出图标
            set_enable(8,g_UserExitButton,0)        --按键
            set_visiable(8, g_UserSaveIcon,0)      

        elseif(g_UserTatolNum == 3) then

            set_value(8,g_UserSecondIcon,0)
            set_value(8,g_UserFourIcon,0)
            set_value(8,g_UserFourIcon,0)
            set_visiable(8,g_UserFisrtIcon,1)
            set_visiable(8,g_UserSecondIcon,0)
            set_visiable(8,g_UserThreeIcon,1)
            set_visiable(8,g_UserFourIcon,0)
            set_visiable(8,g_UserFivetIcon,1)

            set_visiable(8,g_UserFisrtSelectIcon,0)
            set_visiable(8,g_UserSecondSelectIcon,0)
            set_visiable(8,g_UserThreeSelectIcon,0)
            set_visiable(8,g_UserFourSelectIcon,0)
            set_visiable(8,g_UserFiveSelectIcon,0)

            set_visiable(8,g_UserFisrtNameIcon,0)   --关闭用户名背景图标
            set_visiable(8,g_UserSecondNameIcon,0)
            set_visiable(8,g_UserThreeNameIcon,0)
            set_visiable(8,g_UserFourNameIcon,0)
            set_visiable(8,g_UserFiveNameIcon,0)

            set_visiable(8,g_HeadFisrtNameText,0)   
            set_visiable(8,g_HeadSecondNameText,0)
            set_visiable(8,g_HeadThreeNameText,0)
            set_visiable(8,g_HeadFourNameText,0)
            set_visiable(8,g_HeadFiveNameText,0)    

            set_visiable(8,g_UserFisrtNameText,0)  
            set_visiable(8,g_UserSecondNameText,0)
            set_visiable(8,g_UserThreeNameText,0)
            set_visiable(8,g_UserFourNameText,0)
            set_visiable(8,g_UserFiveNameText,0)          
            
            set_visiable(8,g_HeadFisrtNameText_Black,0)   
            set_visiable(8,g_HeadSecondNameText_Black,0)
            set_visiable(8,g_HeadThreeNameText_Black,0)
            set_visiable(8,g_HeadFourNameText_Black,0)
            set_visiable(8,g_HeadFiveNameText_Black,0)    

            set_visiable(8,g_UserFisrtNameText_Black,0)  
            set_visiable(8,g_UserSecondNameText_Black,0)
            set_visiable(8,g_UserThreeNameText_Black,0)
            set_visiable(8,g_UserFourNameText_Black,0)
            set_visiable(8,g_UserFiveNameText_Black,0)   

            set_enable(8,g_UserFisrtButton,1)
            set_enable(8,g_UserSecondButton,0)
            set_enable(8,g_UserThreeButton,1)
            set_enable(8,g_UserFourButton,0)
            set_enable(8,g_UserFiveButton,1)

            set_enable(8,g_UserFisrtNameButton,0)  
            set_enable(8,g_UserSecondNameButton,0)
            set_enable(8,g_UserThreeNameButton,0)
            set_enable(8,g_UserFourNameButton,0)
            set_enable(8,g_UserFiveNameButton,0)

            set_enable(8,g_UserFisrtSelectButton,0)  
            set_enable(8,g_UserSecondSelectButton,0)
            set_enable(8,g_UserThreeSelectButton,0)
            set_enable(8,g_UserFourSelectButton,0)
            set_enable(8,g_UserFiveSelectButton,0)

            set_enable(8,g_UserSetButton,1)         --进入用户设置按钮
            set_value(8,g_UserSetRightIcon,0+Language*1+g_SetDarkModeFlag*2)       --图标
            set_visiable(8,g_UserSetRightIcon,1) 

            set_value(8,g_UserSetLeftIcon,0+Language*1+g_SetDarkModeFlag*2)
            set_visiable(8,g_UserSetLeftIcon,0)

            set_visiable(8,g_UserExitIcon,0)        --退出图标
            set_enable(8,g_UserExitButton,0)        --按键
            set_visiable(8, g_UserSaveIcon,0)           
        end
        set_visiable(8,g_UserCountBackIcon,0)
        set_visiable(8,g_UserCountBack2Icon,0)
        set_visiable(8,g_UserCountBack2ENIcon,0)
    end

end    
function EnterUserScreen_Set()      --进入用户设置界面调用一次
    if(g_TempUserTatolNum == 1) then

        set_value(8,g_UserFisrtIcon,0+g_SetDarkModeFlag*4)  --设置显示用户图标
        set_value(8,g_UserThreeIcon,0+g_SetDarkModeFlag*4)
        set_value(8,g_UserFivetIcon,0+g_SetDarkModeFlag*4)
        set_visiable(8,g_UserSecondIcon,0)  --2和4隐藏
        set_visiable(8,g_UserFourIcon,0)
        set_visiable(8,g_UserFisrtIcon,1)  --使能显示
        set_visiable(8,g_UserThreeIcon,1)
        set_visiable(8,g_UserFivetIcon,1)

        set_value(8,g_UserFisrtSelectIcon,1)
        set_visiable(8,g_UserFisrtSelectIcon,1)   --显示一个用户删除图标
        set_visiable(8,g_UserSecondSelectIcon,0)
        set_visiable(8,g_UserThreeSelectIcon,0)
        set_visiable(8,g_UserFourSelectIcon,0)
        set_visiable(8,g_UserFiveSelectIcon,0)

        set_value(8,g_UserFisrtNameIcon,0+g_SetDarkModeFlag*1)
        set_visiable(8,g_UserFisrtNameIcon,1)   --关闭用户名背景图标
        set_visiable(8,g_UserSecondNameIcon,0)
        set_visiable(8,g_UserThreeNameIcon,0)
        set_visiable(8,g_UserFourNameIcon,0)
        set_visiable(8,g_UserFiveNameIcon,0)

        set_visiable(8,g_HeadFisrtNameText,0)   
        set_visiable(8,g_HeadSecondNameText,0)
        set_visiable(8,g_HeadThreeNameText,0)
        set_visiable(8,g_HeadFourNameText,0)
        set_visiable(8,g_HeadFiveNameText,0)    

        set_visiable(8,g_UserFisrtNameText,0)  
        set_visiable(8,g_UserSecondNameText,0)
        set_visiable(8,g_UserThreeNameText,0)
        set_visiable(8,g_UserFourNameText,0)
        set_visiable(8,g_UserFiveNameText,0)          
        
        set_visiable(8,g_HeadFisrtNameText_Black,0)   
        set_visiable(8,g_HeadSecondNameText_Black,0)
        set_visiable(8,g_HeadThreeNameText_Black,0)
        set_visiable(8,g_HeadFourNameText_Black,0)
        set_visiable(8,g_HeadFiveNameText_Black,0)    

        set_visiable(8,g_UserFisrtNameText_Black,0)  
        set_visiable(8,g_UserSecondNameText_Black,0)
        set_visiable(8,g_UserThreeNameText_Black,0)
        set_visiable(8,g_UserFourNameText_Black,0)
        set_visiable(8,g_UserFiveNameText_Black,0)   

        set_enable(8,g_UserFisrtButton,0)
        set_enable(8,g_UserSecondButton,0)
        set_enable(8,g_UserThreeButton,1)
        set_enable(8,g_UserFourButton,0)
        set_enable(8,g_UserFiveButton,1)

        set_enable(8,g_UserFisrtNameButton,1)  
        set_enable(8,g_UserSecondNameButton,0)
        set_enable(8,g_UserThreeNameButton,0)
        set_enable(8,g_UserFourNameButton,0)
        set_enable(8,g_UserFiveNameButton,0)

        set_enable(8,g_UserFisrtSelectButton,1)  
        set_enable(8,g_UserSecondSelectButton,0)
        set_enable(8,g_UserThreeSelectButton,0)
        set_enable(8,g_UserFourSelectButton,0)
        set_enable(8,g_UserFiveSelectButton,0)
       
    elseif(g_TempUserTatolNum == 2)then 
        set_value(8,g_UserFisrtIcon,0+g_SetDarkModeFlag*4)  --设置显示用户图标
        set_value(8,g_UserThreeIcon,0+g_SetDarkModeFlag*4)
        set_value(8,g_UserFivetIcon,0+g_SetDarkModeFlag*4)
        set_visiable(8,g_UserSecondIcon,0)  --2和4隐藏
        set_visiable(8,g_UserFourIcon,0)
        set_visiable(8,g_UserFisrtIcon,1)  --使能显示
        set_visiable(8,g_UserThreeIcon,1)
        set_visiable(8,g_UserFivetIcon,1)

        set_value(8,g_UserFisrtSelectIcon,1)
        set_value(8,g_UserThreeSelectIcon,1)
        set_visiable(8,g_UserFisrtSelectIcon,1)   --显示一个用户删除图标
        set_visiable(8,g_UserSecondSelectIcon,0)
        set_visiable(8,g_UserThreeSelectIcon,1)
        set_visiable(8,g_UserFourSelectIcon,0)
        set_visiable(8,g_UserFiveSelectIcon,0)

        set_value(8,g_UserFisrtNameIcon,0+g_SetDarkModeFlag*1)
        set_value(8,g_UserThreeNameIcon,0+g_SetDarkModeFlag*1)
        set_visiable(8,g_UserFisrtNameIcon,1)   --关闭用户名背景图标
        set_visiable(8,g_UserSecondNameIcon,0)
        set_visiable(8,g_UserThreeNameIcon,1)
        set_visiable(8,g_UserFourNameIcon,0)
        set_visiable(8,g_UserFiveNameIcon,0)

        set_visiable(8,g_HeadFisrtNameText,0)   
        set_visiable(8,g_HeadSecondNameText,0)
        set_visiable(8,g_HeadThreeNameText,0)
        set_visiable(8,g_HeadFourNameText,0)
        set_visiable(8,g_HeadFiveNameText,0)    

        set_visiable(8,g_UserFisrtNameText,0)  
        set_visiable(8,g_UserSecondNameText,0)
        set_visiable(8,g_UserThreeNameText,0)
        set_visiable(8,g_UserFourNameText,0)
        set_visiable(8,g_UserFiveNameText,0)          
        
        set_visiable(8,g_HeadFisrtNameText_Black,0)   
        set_visiable(8,g_HeadSecondNameText_Black,0)
        set_visiable(8,g_HeadThreeNameText_Black,0)
        set_visiable(8,g_HeadFourNameText_Black,0)
        set_visiable(8,g_HeadFiveNameText_Black,0)    

        set_visiable(8,g_UserFisrtNameText_Black,0)  
        set_visiable(8,g_UserSecondNameText_Black,0)
        set_visiable(8,g_UserThreeNameText_Black,0)
        set_visiable(8,g_UserFourNameText_Black,0)
        set_visiable(8,g_UserFiveNameText_Black,0)   

        set_enable(8,g_UserFisrtButton,0)
        set_enable(8,g_UserSecondButton,0)
        set_enable(8,g_UserThreeButton,0)
        set_enable(8,g_UserFourButton,0)
        set_enable(8,g_UserFiveButton,1)

        set_enable(8,g_UserFisrtNameButton,1)  
        set_enable(8,g_UserSecondNameButton,0)
        set_enable(8,g_UserThreeNameButton,1)
        set_enable(8,g_UserFourNameButton,0)
        set_enable(8,g_UserFiveNameButton,0)

        set_enable(8,g_UserFisrtSelectButton,1)  
        set_enable(8,g_UserSecondSelectButton,0)
        set_enable(8,g_UserThreeSelectButton,1)
        set_enable(8,g_UserFourSelectButton,0)
        set_enable(8,g_UserFiveSelectButton,0)
     
    elseif(g_TempUserTatolNum == 3)then
        set_value(8,g_UserFisrtIcon,0)  --设置显示用户图标
        set_value(8,g_UserThreeIcon,0)
        set_value(8,g_UserFivetIcon,0)
        set_visiable(8,g_UserSecondIcon,0)  --2和4隐藏
        set_visiable(8,g_UserFourIcon,0)
        set_visiable(8,g_UserFisrtIcon,1)  --使能显示
        set_visiable(8,g_UserThreeIcon,1)
        set_visiable(8,g_UserFivetIcon,1)

        set_value(8,g_UserFisrtSelectIcon,1)
        set_value(8,g_UserThreeSelectIcon,1)
        set_value(8,g_UserFiveSelectIcon,1)
        set_visiable(8,g_UserFisrtSelectIcon,1)   --显示一个用户删除图标
        set_visiable(8,g_UserSecondSelectIcon,0)
        set_visiable(8,g_UserThreeSelectIcon,1)
        set_visiable(8,g_UserFourSelectIcon,0)
        set_visiable(8,g_UserFiveSelectIcon,1)

        set_value(8,g_UserFisrtNameIcon,0+g_SetDarkModeFlag*1)
        set_value(8,g_UserThreeNameIcon,0+g_SetDarkModeFlag*1)
        set_value(8,g_UserFiveNameIcon,0+g_SetDarkModeFlag*1)
        set_visiable(8,g_UserFisrtNameIcon,1)   --关闭用户名背景图标
        set_visiable(8,g_UserSecondNameIcon,0)
        set_visiable(8,g_UserThreeNameIcon,1)
        set_visiable(8,g_UserFourNameIcon,0)
        set_visiable(8,g_UserFiveNameIcon,1)

        set_visiable(8,g_HeadFisrtNameText,0)   
        set_visiable(8,g_HeadSecondNameText,0)
        set_visiable(8,g_HeadThreeNameText,0)
        set_visiable(8,g_HeadFourNameText,0)
        set_visiable(8,g_HeadFiveNameText,0)    

        set_visiable(8,g_UserFisrtNameText,0)  
        set_visiable(8,g_UserSecondNameText,0)
        set_visiable(8,g_UserThreeNameText,0)
        set_visiable(8,g_UserFourNameText,0)
        set_visiable(8,g_UserFiveNameText,0)          
        
        set_visiable(8,g_HeadFisrtNameText_Black,0)   
        set_visiable(8,g_HeadSecondNameText_Black,0)
        set_visiable(8,g_HeadThreeNameText_Black,0)
        set_visiable(8,g_HeadFourNameText_Black,0)
        set_visiable(8,g_HeadFiveNameText_Black,0)    

        set_visiable(8,g_UserFisrtNameText_Black,0)  
        set_visiable(8,g_UserSecondNameText_Black,0)
        set_visiable(8,g_UserThreeNameText_Black,0)
        set_visiable(8,g_UserFourNameText_Black,0)
        set_visiable(8,g_UserFiveNameText_Black,0)   

        set_enable(8,g_UserFisrtButton,0)
        set_enable(8,g_UserSecondButton,0)
        set_enable(8,g_UserThreeButton,0)
        set_enable(8,g_UserFourButton,0)
        set_enable(8,g_UserFiveButton,0)

        set_enable(8,g_UserFisrtNameButton,1)  
        set_enable(8,g_UserSecondNameButton,0)
        set_enable(8,g_UserThreeNameButton,1)
        set_enable(8,g_UserFourNameButton,0)
        set_enable(8,g_UserFiveNameButton,1)

        set_enable(8,g_UserFisrtSelectButton,1)  
        set_enable(8,g_UserSecondSelectButton,0)
        set_enable(8,g_UserThreeSelectButton,1)
        set_enable(8,g_UserFourSelectButton,0)
        set_enable(8,g_UserFiveSelectButton,1)        
    end  
    set_enable(8,g_UserSetButton,1)          --显示设置按钮
    set_visiable(8,g_UserSetRightIcon,0)     --隐藏图标

    set_value(8,g_UserSetLeftIcon,0+Language*1+g_SetDarkModeFlag*2)
    set_visiable(8,g_UserSetLeftIcon,1)      --

    set_visiable(8,g_UserCountBackIcon,0)
    set_visiable(8,g_UserCountBack2Icon,0)
    set_visiable(8,g_UserCountBack2ENIcon,0)

    set_value(8,g_UserExitIcon,0+g_SetDarkModeFlag*1)
    set_visiable(8,g_UserExitIcon,1)
    set_enable(8,g_UserExitButton,1)

    --set_value(8,g_UserSaveIcon,0+Language*2+g_SetDarkModeFlag*4)
    --set_visiable(8,g_UserSaveIcon,1)   

end
function EnterUserScreen_show()      --进入用户设置界面调用一次
    local FirstNum = "U"
    local UserFirstFlag = 0
    EnterUserScreen_Set()   
    if(g_TempUserTatolNum == 1)then
        for i=1,3,1 do         --个用户
            if(UserIDBuf[i] ~= 0xFF) then 
                if g_SetDarkModeFlag == 1 then   --黑夜模式
                    set_text(8,g_UserFisrtNameText_Black,UserNameBuf[i])
                    set_visiable(8,g_UserFisrtNameText_Black,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                    set_visiable(8,g_HeadFisrtNameText_Black,1)
                else
                    set_text(8,g_UserFisrtNameText,UserNameBuf[i])
                    set_visiable(8,g_UserFisrtNameText,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadFisrtNameText,FirstNum)
                    set_visiable(8,g_HeadFisrtNameText,1)                   
                end
            g_FirstID = UserIDBuf[i]  
            
            set_value(8,g_UserFisrtIcon,UserIDBuf[i])
            set_visiable(8,g_UserFisrtIcon,1)  --显示用户头像   
            break
            end    
        end
    elseif(g_TempUserTatolNum == 2)then 
        for i=1,3,1 do         --个用户
            if(TempUserIDBuf[i] ~= 0xFF and UserFirstFlag == 0) then 
                if g_SetDarkModeFlag == 1 then
                    set_text(8,g_UserFisrtNameText_Black,UserNameBuf[i])
                    set_visiable(8,g_UserFisrtNameText_Black,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                    set_visiable(8,g_HeadFisrtNameText_Black,1)
                else
                    set_text(8,g_UserFisrtNameText,UserNameBuf[i])
                    set_visiable(8,g_UserFisrtNameText,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadFisrtNameText,FirstNum)
                    set_visiable(8,g_HeadFisrtNameText,1)                    
                end

                UserFirstFlag = 1           
                g_FirstID = UserIDBuf[i]

                set_value(8,g_UserFisrtIcon,UserIDBuf[i])
                set_visiable(8,g_UserFisrtIcon,1)  --显示用户头像   
            elseif(UserIDBuf[i] ~= 0xFF and UserFirstFlag == 1) then
                if g_SetDarkModeFlag == 1 then
                    set_text(8,g_UserThreeNameText_Black,UserNameBuf[i])
                    set_visiable(8,g_UserThreeNameText_Black,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadThreeNameText_Black,FirstNum)
                    set_visiable(8,g_HeadThreeNameText_Black,1)
                else
                    set_text(8,g_UserThreeNameText,UserNameBuf[i])
                    set_visiable(8,g_UserThreeNameText,1)
                    FirstNum = string.sub(UserNameBuf[i],1,1)
                    set_text(8,g_HeadThreeNameText,FirstNum)
                    set_visiable(8,g_HeadThreeNameText,1)                    
                end 

                UserFirstFlag = 0 
                g_SecondID = UserIDBuf[i] 

                set_value(8,g_UserThreeIcon,UserIDBuf[i])
                set_visiable(8,g_UserThreeIcon,1)  --显示用户头像                      
            end                
        end
    elseif(g_TempUserTatolNum == 3)then
        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserFisrtNameText_Black,UserNameBuf[1]) --用户1
            set_visiable(8,g_UserFisrtNameText_Black,1)
            FirstNum = string.sub(UserNameBuf[1],1,1)
            set_text(8,g_HeadFisrtNameText_Black,FirstNum)
            set_visiable(8,g_HeadFisrtNameText_Black,1) 
        else
            set_text(8,g_UserFisrtNameText,UserNameBuf[1]) --用户1
            set_visiable(8,g_UserFisrtNameText,1)
            FirstNum = string.sub(UserNameBuf[1],1,1)
            set_text(8,g_HeadFisrtNameText,FirstNum)
            set_visiable(8,g_HeadFisrtNameText,1)            
        end

        g_FirstID = UserIDBuf[1]
        set_value(8,g_UserFisrtIcon,UserIDBuf[1])
        set_visiable(8,g_UserFisrtIcon,1)  --显示用户头像       

        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserThreeNameText_Black,UserNameBuf[2]) --用户2
            set_visiable(8,g_UserThreeNameText_Black,1)
            FirstNum = string.sub(UserNameBuf[2],1,1)
            set_text(8,g_HeadThreeNameText_Black,FirstNum)
            set_visiable(8,g_HeadThreeNameText_Black,1)
        else
            set_text(8,g_UserThreeNameText,UserNameBuf[2]) --用户2
            set_visiable(8,g_UserThreeNameText,1)
            FirstNum = string.sub(UserNameBuf[2],1,1)
            set_text(8,g_HeadThreeNameText,FirstNum)
            set_visiable(8,g_HeadThreeNameText,1)            
        end

        g_SecondID = UserIDBuf[2]
        set_value(8,g_UserThreeIcon,UserIDBuf[2])
        set_visiable(8,g_UserThreeIcon,1)  --显示用户头像

        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserFiveNameText_Black,UserNameBuf[3]) --用户3
            set_visiable(8,g_UserFiveNameText_Black,1)
            FirstNum = string.sub(UserNameBuf[3],1,1)
            set_text(8,g_HeadFiveNameText_Black,FirstNum)
            set_visiable(8,g_HeadFiveNameText_Black,1)
        else
            set_text(8,g_UserFiveNameText,UserNameBuf[3]) --用户3
            set_visiable(8,g_UserFiveNameText,1)
            FirstNum = string.sub(UserNameBuf[3],1,1)
            set_text(8,g_HeadFiveNameText,FirstNum)
            set_visiable(8,g_HeadFiveNameText,1)            
        end

        g_ThreeID = UserIDBuf[3]    
        set_value(8,g_UserFivetIcon,UserIDBuf[3])
        set_visiable(8,g_UserFivetIcon,1)  --显示用户头像            
    end   
end
function Get_New_UserID()      --获取用户ID
    for i=1,3,1 do                --个用户
        if(TempUserIDBuf[i] == 0xFF) then
            return i
        end    
    end
end
function Delete_User()                --删除用户
    if(g_DeleteFirstUserFlag == 0x01) then    --用户1删除
        g_DeleteFirstUserFlag = 0x00          --标志位复位
        set_value(8,g_UserFisrtIcon,0+g_SetDarkModeFlag*4)
        set_visiable(8,g_UserFisrtSelectIcon,0)    --隐藏选中图标
        set_visiable(8,g_UserFisrtNameIcon,0)      --隐藏姓名底色图标
        set_visiable(8,g_HeadFisrtNameText,0)      --隐藏姓名首字母
        set_visiable(8,g_UserFisrtNameText,0)      --隐藏姓名显示文本
        set_visiable(8,g_HeadFisrtNameText_Black,0)      --隐藏姓名首字母_黑夜模式
        set_visiable(8,g_UserFisrtNameText_Black,0)      --隐藏姓名显示文本_黑夜模式
        set_enable(8,g_UserFisrtButton,1)          --启动增加按键
        set_enable(8,g_UserFisrtNameButton,0)      --关闭名字触摸按键
        set_enable(8,g_UserFisrtSelectButton,0)    --关闭选中按键

        ResetData_User(TempUserIDBuf[g_FirstID])    --删除用户信息

        TempUserIDBuf[g_FirstID] = 0xFF             --用户编号保存
        TempUserNameBuf[g_FirstID] = UserNameInitBuf[g_FirstID]
        g_FirstID = 0xFF

        g_TempUserTatolNum = g_TempUserTatolNum - 1  --用户总数加1

    end
    if(g_DeleteSecondUserFlag == 0x01) then    --用户2删除
        g_DeleteSecondUserFlag = 0x00          --标志位复位
        set_value(8,g_UserThreeIcon,0+g_SetDarkModeFlag*4)
        set_visiable(8,g_UserThreeSelectIcon,0)    --隐藏选中图标
        set_visiable(8,g_UserThreeNameIcon,0)      --隐藏姓名底色图标
        set_visiable(8,g_HeadThreeNameText,0)      --隐藏姓名首字母
        set_visiable(8,g_UserThreeNameText,0)      --隐藏姓名显示文本
        set_visiable(8,g_HeadThreeNameText_Black,0)      --隐藏姓名首字母_黑夜模式
        set_visiable(8,g_UserThreeNameText_Black,0)      --隐藏姓名显示文本_黑夜模式
        set_enable(8,g_UserThreeButton,1)          --启动增加按键
        set_enable(8,g_UserThreeNameButton,0)      --关闭名字触摸按键
        set_enable(8,g_UserThreeSelectButton,0)    --关闭选中按键

        ResetData_User(TempUserIDBuf[g_SecondID])    --删除用户信息

        TempUserIDBuf[g_SecondID] = 0xFF       --用户编号保存
        TempUserNameBuf[g_SecondID] = UserNameInitBuf[g_SecondID]       --用户编号保存
        g_SecondID = 0xFF

        g_TempUserTatolNum = g_TempUserTatolNum - 1  --用户总数加1
    end
    if(g_DeleteThreeUserFlag == 0x01) then    --用户2删除
        g_DeleteThreeUserFlag = 0x00          --标志位复位
        set_value(8,g_UserFivetIcon,0+g_SetDarkModeFlag*4)
        set_visiable(8,g_UserFiveSelectIcon,0)    --隐藏选中图标
        set_visiable(8,g_UserFiveNameIcon,0)      --隐藏姓名底色图标
        set_visiable(8,g_HeadFiveNameText,0)      --隐藏姓名首字母
        set_visiable(8,g_UserFiveNameText,0)      --隐藏姓名显示文本
        set_visiable(8,g_HeadFiveNameText_Black,0)      --隐藏姓名首字母_黑夜模式
        set_visiable(8,g_UserFiveNameText_Black,0)      --隐藏姓名显示文本_黑夜模式
        set_enable(8,g_UserFiveButton,1)          --启动增加按键
        set_enable(8,g_UserFiveNameButton,0)      --关闭名字触摸按键
        set_enable(8,g_UserFiveSelectButton,0)    --关闭选中按键

        ResetData_User(TempUserIDBuf[g_ThreeID])    --删除用户信息

        TempUserIDBuf[g_ThreeID] = 0xFF       --用户编号保存
        TempUserNameBuf[g_ThreeID] = UserNameInitBuf[g_ThreeID] 
        g_ThreeID = 0xFF

        g_TempUserTatolNum = g_TempUserTatolNum - 1  --用户总数加1
    end
end
function Delete_User_Confirm(control,value)                   --删除用户确认弹窗
    if(control==g_UserFisrtSelectButton and value==1) then    --用户1删除

        g_DeleteFirstUserFlag = 0x01
        change_child_screen(4)
        SystemMode=4
        POP_WindowNum=12
        WindowScreen_Show()
        KeyBeep_App()    
    elseif(control==g_UserThreeSelectButton and value==1) then    --用户2删除

        g_DeleteSecondUserFlag = 0x01
        change_child_screen(4)
        SystemMode=4
        POP_WindowNum=12
        WindowScreen_Show()
        KeyBeep_App()    
    elseif(control==g_UserFiveSelectButton and value==1) then    --用户2删除

        g_DeleteThreeUserFlag = 0x01
        change_child_screen(4)
        SystemMode=4
        POP_WindowNum=12
        WindowScreen_Show()
        KeyBeep_App()    
    end
end
function RegistUser(control,value)                --增加用户
    local FirstNum = "U"    
    if(control==g_UserFisrtButton and value==1) then    --用户1按键增加用户
        g_FirstID = Get_New_UserID() 
        --set_value(8,g_UserFisrtIcon,0)
        --set_value(8,g_UserFisrtNameIcon,0)
        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserFisrtNameText_Black,TempUserNameBuf[g_FirstID])
            set_visiable(8,g_UserFisrtNameText_Black,1)
            FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
            set_text(8,g_HeadFisrtNameText_Black,FirstNum)
            set_visiable(8,g_HeadFisrtNameText_Black,1)
        else   
            set_text(8,g_UserFisrtNameText,TempUserNameBuf[g_FirstID])
            set_visiable(8,g_UserFisrtNameText,1)
            FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
            set_text(8,g_HeadFisrtNameText,FirstNum)
            set_visiable(8,g_HeadFisrtNameText,1)            
        end

        TempUserIDBuf[ g_FirstID] =  g_FirstID       --用户编号保存

        set_value(8,g_UserFisrtIcon,TempUserIDBuf[ g_FirstID])
        set_visiable(8,g_UserFisrtIcon,1)  --显示用户头像

        g_TempUserTatolNum = g_TempUserTatolNum + 1  --用户总数加1

        set_enable(8,g_UserFisrtButton,0)             --关闭用户1按键
        set_enable(8,g_UserFisrtSelectButton,1)       --启动删除按键
        set_enable(8,g_UserFisrtNameButton,1)         --启动姓名触摸按键
        set_value(8,g_UserFisrtSelectIcon,1)         --使能删除图标
        set_visiable(8,g_UserFisrtSelectIcon,1)       --显示删除图标
        set_value(8,g_UserFisrtNameIcon,0+g_SetDarkModeFlag*1) --使能姓名底色图标
        set_visiable(8,g_UserFisrtNameIcon,1)        --显示姓名底色图标

        g_UserDataChangeFlag =0x01                   --用户数据标志位
        KeyBeep_App()  
    end
    if(control==g_UserThreeButton and value==1) then    --用户2按键增加用户
        g_SecondID = Get_New_UserID() 
        --set_value(8,g_UserThreeIcon,0)
        --set_value(8,g_UserThreeNameIcon,0)
        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserThreeNameText_Black,TempUserNameBuf[g_SecondID])
            set_visiable(8,g_UserThreeNameText_Black,1)
            FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
            set_text(8,g_HeadThreeNameText_Black,FirstNum)
            set_visiable(8,g_HeadThreeNameText_Black,1)
        else   
            set_text(8,g_UserThreeNameText,TempUserNameBuf[g_SecondID])
            set_visiable(8,g_UserThreeNameText,1)
            FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
            set_text(8,g_HeadThreeNameText,FirstNum)
            set_visiable(8,g_HeadThreeNameText,1)            
        end

        TempUserIDBuf[g_SecondID] =  g_SecondID      --用户编号保存

        set_value(8,g_UserThreeIcon,TempUserIDBuf[g_SecondID])
        set_visiable(8,g_UserThreeIcon,1)  --显示用户头像

        g_TempUserTatolNum = g_TempUserTatolNum + 1  --用户总数加1  
        
        set_enable(8,g_UserThreeButton,0)             --关闭用户2按键
        set_enable(8,g_UserThreeSelectButton,1)       --启动删除按键
        set_enable(8,g_UserThreeNameButton,1)         --启动姓名触摸按键
        set_value(8,g_UserThreeSelectIcon,1)         --使能删除图标
        set_visiable(8,g_UserThreeSelectIcon,1)      --显示删除图标
        set_value(8,g_UserThreeNameIcon,0+g_SetDarkModeFlag*1)           --使能姓名底色图标
        set_visiable(8,g_UserThreeNameIcon,1)        --显示姓名底色图标

        g_UserDataChangeFlag =0x01                   --用户数据标志位
        KeyBeep_App()  
    end        
    if(control==g_UserFiveButton and value==1) then    --用户3按键增加用户
        g_ThreeID = Get_New_UserID() 
        --set_value(8,g_UserFivetIcon,0)
        --set_value(8,g_UserFiveNameIcon,0)
        if g_SetDarkModeFlag == 1 then
            set_text(8,g_UserFiveNameText_Black,TempUserNameBuf[g_ThreeID])
            set_visiable(8,g_UserFiveNameText_Black,1)
            FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
            set_text(8,g_HeadFiveNameText_Black,FirstNum)
            set_visiable(8,g_HeadFiveNameText_Black,1)
        else   
            set_text(8,g_UserFiveNameText,TempUserNameBuf[g_ThreeID])
            set_visiable(8,g_UserFiveNameText,1)
            FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
            set_text(8,g_HeadFiveNameText,FirstNum)
            set_visiable(8,g_HeadFiveNameText,1)            
        end

        TempUserIDBuf[g_ThreeID] =  g_ThreeID      --用户编号保存

        set_value(8,g_UserFivetIcon,TempUserIDBuf[g_ThreeID])
        set_visiable(8,g_UserFivetIcon,1)  --显示用户头像

        g_TempUserTatolNum = g_TempUserTatolNum + 1  --用户总数加1  
        
        set_enable(8,g_UserFiveButton,0)             --关闭用户3按键
        set_enable(8,g_UserFiveSelectButton,1)       --启动删除按键
        set_enable(8,g_UserFiveNameButton,1)         --启动姓名触摸按键            
        set_value(8,g_UserFiveSelectIcon,1)         --使能删除图标
        set_visiable(8,g_UserFiveSelectIcon,1)       --显示删除图标
        set_value(8,g_UserFiveNameIcon,0+g_SetDarkModeFlag*1)--使能姓名底色图标
        set_visiable(8,g_UserFiveNameIcon,1)        --显示姓名底色图标

        g_UserDataChangeFlag =0x01                   --用户数据标志位
        KeyBeep_App()  
    end
end


function KeyBoardSmallWhite_run(control,value)
    local user = g_CurrentUser
    local program = Promgrame[g_CurrentUser]
    local steps = Steps[g_CurrentUser][Promgrame[g_CurrentUser]]
    local KeyBoardUserNamebfuf = "" 

    --set_visiable(9,g_KeyBoardProgamNameText,0)      --关闭程序名输入
	--返回
	if( control==g_KeyBoardExistButton and value==1)then

        if (g_IM_ProgramNameChangeFlag == 0x01) then

            g_IM_ProgramNameChangeFlag = 0x00
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)
            KeyBeep_App()
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        else     
            SystemMode=8
            change_screen(8)
            KeyBeep_App()

            g_ChangeFirstUserNameFlag = 0x00     --改变第一用户姓名标志位
            g_ChangeSecondUserNameFlag = 0x00    --改变第二用户姓名标志位
            g_ChangeThreeUserNameFlag = 0x00     --改变第三用户姓名标志位   
        end 
        set_text(9,g_KeyBoardUserNameText,"")         --清空
	end
	--OK
	if(control==g_KeyBoardConfirmButton and value==1)then
		g_KeyBoardUserNamebfuf=get_text(9,g_KeyBoardUserNameText)   --获取用户名
        if (g_IM_ProgramNameChangeFlag == 0x01) then

            g_IM_ProgramNameChangeFlag = 0x00
            if(#g_KeyBoardUserNamebfuf <16)then
                IMUserProgramIDDataBuf[g_CurrentUser][Promgrame[g_CurrentUser]] = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_Name = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_NO = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        else
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <11)then
                if(g_ChangeFirstUserNameFlag == 0x01)then
                    g_ChangeFirstUserNameFlag = 0x00
                    TempUserNameBuf[g_FirstID] = g_KeyBoardUserNamebfuf --用户名  

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFisrtNameText_Black,TempUserNameBuf[g_FirstID])  --赋值显示
                        set_visiable(8,g_UserFisrtNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText_Black,1)
                    else    
                        set_text(8,g_UserFisrtNameText,TempUserNameBuf[g_FirstID])  --赋值显示
                        set_visiable(8,g_UserFisrtNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText,1)                        
                    end

                elseif(g_ChangeSecondUserNameFlag== 0x01)then
                    g_ChangeSecondUserNameFlag = 0x00
                    TempUserNameBuf[g_SecondID] = g_KeyBoardUserNamebfuf 

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserThreeNameText_Black,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText_Black,FirstNum)
                        set_visiable(8,g_HeadThreeNameText_Black,1)        
                    else
                        set_text(8,g_UserThreeNameText,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText,FirstNum)
                        set_visiable(8,g_HeadThreeNameText,1)        
                    end
        
                elseif(g_ChangeThreeUserNameFlag == 0x01)then
                    g_ChangeThreeUserNameFlag = 0x00
                    TempUserNameBuf[g_ThreeID] = g_KeyBoardUserNamebfuf 
                    
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFiveNameText_Black,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFiveNameText_Black,1)
                    else
                        set_text(8,g_UserFiveNameText,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText,FirstNum)
                        set_visiable(8,g_HeadFiveNameText,1)                    
                    end

                end
            end
			SystemMode=8
			change_screen(8)
            KeyBeep_App()

            g_UserDataChangeFlag =0x01                   --用户数据标改变志位
            set_text(9,g_KeyBoardUserNameText,"")         --清空
		end
	end
	if(control==g_KeyBoardSwitchButton and value==1)then   --键盘切换到大写接盘
        g_KeyBoardUserNamebfuf=get_text(9,g_KeyBoardUserNameText)   --获取用户名
        set_text(10,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf)
        SystemMode=10
		change_screen(10)
		KeyBeep_App()   
    end

    --if(control>2 and control<44 and value==1)then
    if(control>2 and control<44)then
        KeyBeep_App()
    end

    KeyBoardUserNamebfuf = get_text(9,g_KeyBoardUserNameText)
    if (g_IM_ProgramNameChangeFlag == 0x01) then 
        set_value(9,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(10,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(10,g_KeyBoardConfirmButton,1)             --使能OK按键
        set_enable(9,g_KeyBoardConfirmButton,1)             --使能OK按键
    else
        if(#KeyBoardUserNamebfuf == 0)then
            set_value(9,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)
            set_value(10,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)

            set_enable(10,g_KeyBoardConfirmButton,0)             --关闭OK按键
            set_enable(9,g_KeyBoardConfirmButton,0)             --关闭OK按键
        else
            set_value(9,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
            set_value(10,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

            set_enable(10,g_KeyBoardConfirmButton,1)             --使能OK按键
            set_enable(9,g_KeyBoardConfirmButton,1)             --使能OK按键
        end
    end    
    --姓名缓存区,用于超过7位限制，判断
    if g_ChangeFirstUserNameFlag == 0x01 or g_ChangeSecondUserNameFlag== 0x01 or g_ChangeThreeUserNameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(9,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告名称缓存区,用于超过7位限制，判断
    if IM_Report_NameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(9,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告编号缓存区,用于超过6位限制，判断
    if IM_Report_NOFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 6 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 6 then
            set_text(9,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end    
end


function KeyBoardBigWhite_run(control,value)             --白色键盘大写输入
    local user = g_CurrentUser
    local program = Promgrame[g_CurrentUser]
    local steps = Steps[g_CurrentUser][Promgrame[g_CurrentUser]]
    local KeyBoardUserNamebfuf = "" 
    --set_visiable(10,g_KeyBoardProgamNameText,0)      --关闭程序名输入
	--返回
	if( control==g_KeyBoardExistButton and value==1)then

        if (g_IM_ProgramNameChangeFlag == 0x01) then
            g_IM_ProgramNameChangeFlag = 0x00
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)
            KeyBeep_App()
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        else
            SystemMode=8
            change_screen(8)
            KeyBeep_App()

            g_ChangeFirstUserNameFlag = 0x00     --改变第一用户姓名标志位
            g_ChangeSecondUserNameFlag = 0x00    --改变第二用户姓名标志位
            g_ChangeThreeUserNameFlag = 0x00     --改变第三用户姓名标志位  
        end

        set_text(9,g_KeyBoardUserNameText,"")         --清空
	end
	--OK
	if(control==g_KeyBoardConfirmButton and value==1)then 	
		g_KeyBoardUserNamebfuf=get_text(10,g_KeyBoardUserNameText)   --获取用户名
        if (g_IM_ProgramNameChangeFlag == 0x01) then
            g_IM_ProgramNameChangeFlag = 0x00
            if(#g_KeyBoardUserNamebfuf <16)then
                IMUserProgramIDDataBuf[g_CurrentUser][Promgrame[g_CurrentUser]] = g_KeyBoardUserNamebfuf
            end  
            
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_Name = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_NO = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(9,g_KeyBoardUserNameText,"")         --清空
        else    
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <11)then
                if(g_ChangeFirstUserNameFlag == 0x01)then
                    g_ChangeFirstUserNameFlag = 0x00
                    TempUserNameBuf[g_FirstID] = g_KeyBoardUserNamebfuf

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFisrtNameText_Black,TempUserNameBuf[g_FirstID])
                        set_visiable(8,g_UserFisrtNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText_Black,1)    
                    else
                        set_text(8,g_UserFisrtNameText,TempUserNameBuf[g_FirstID])
                        set_visiable(8,g_UserFisrtNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText,1)                        
                    end
       
                elseif(g_ChangeSecondUserNameFlag== 0x01)then
                    g_ChangeSecondUserNameFlag = 0x00
                    TempUserNameBuf[g_SecondID] = g_KeyBoardUserNamebfuf 

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserThreeNameText_Black,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText_Black,FirstNum)
                        set_visiable(8,g_HeadThreeNameText_Black,1)     
                    else
                        set_text(8,g_UserThreeNameText,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText,FirstNum)
                        set_visiable(8,g_HeadThreeNameText,1)                         
                    end
                  
                elseif(g_ChangeThreeUserNameFlag == 0x01)then
                    g_ChangeThreeUserNameFlag = 0x00
                    TempUserNameBuf[g_ThreeID] = g_KeyBoardUserNamebfuf  
                    
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFiveNameText_Black,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFiveNameText_Black,1)
                    else
                        set_text(8,g_UserFiveNameText,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText,FirstNum)
                        set_visiable(8,g_HeadFiveNameText,1)                    
                    end

                end
            end
			SystemMode=8
			change_screen(8)
            KeyBeep_App()

            g_UserDataChangeFlag =0x01                   --用户数据标改变志位
            set_text(9,g_KeyBoardUserNameText,"")         --清空
		end
	end
	if(control==g_KeyBoardSwitchButton and value==1)then   --键盘切换到大写接盘
        g_KeyBoardUserNamebfuf=get_text(10,g_KeyBoardUserNameText)   --获取用户名
        set_text(9,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf)
        SystemMode=9
		change_screen(9)
		KeyBeep_App()   
    end

    --if(control>2 and control<44 and value==1)then
    if(control>2 and control<44)then
        KeyBeep_App()
    end

    KeyBoardUserNamebfuf = get_text(10,g_KeyBoardUserNameText)
    if (g_IM_ProgramNameChangeFlag == 0x01) then
        set_value(10,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(9,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(10,g_KeyBoardConfirmButton,1)              --使能OK按键
        set_enable(9,g_KeyBoardConfirmButton,1)               --使能OK按键
    elseif(#KeyBoardUserNamebfuf == 0)then
        set_value(10,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)      --OK图标
        set_value(9,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)

        set_enable(10,g_KeyBoardConfirmButton,0)             --关闭OK按键
        set_enable(9,g_KeyBoardConfirmButton,0)              --关闭OK按键
    else
        set_value(10,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(9,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(10,g_KeyBoardConfirmButton,1)              --使能OK按键
        set_enable(9,g_KeyBoardConfirmButton,1)               --使能OK按键
    end
    --姓名缓存区,用于超过7位限制，判断
    if g_ChangeFirstUserNameFlag == 0x01 or g_ChangeSecondUserNameFlag== 0x01 or g_ChangeThreeUserNameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(10,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告名称缓存区,用于超过7位限制，判断
    if IM_Report_NameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(10,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --姓名缓存区,用于超过6位限制，判断
    if IM_Report_NOFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 6 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 6 then
            set_text(10,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
end

function System_Mode_Screen_Change_Show(System_Mode_Screen)      --界面切换显示函数
    if(System_Mode_Screen==1)    --系统模式
    then
        IMScreen_Show(g_CurrentUser,Promgrame[g_CurrentUser],Steps[g_CurrentUser][(Promgrame[g_CurrentUser])])
    elseif(System_Mode_Screen==2)
    then
        SRScreen_Show()
    elseif(System_Mode_Screen==3)
    then
        SetScreen_Show()
    end
end

function KeyBoardSmallBlack_run(control,value)
    local user = g_CurrentUser
    local program = Promgrame[g_CurrentUser]
    local steps = Steps[g_CurrentUser][Promgrame[g_CurrentUser]]
    local KeyBoardUserNamebfuf = "" 

    --set_visiable(9,g_KeyBoardProgamNameText,0)      --关闭程序名输入
	--返回
	if( control==g_KeyBoardExistButton and value==1)then

        if (g_IM_ProgramNameChangeFlag == 0x01) then

            g_IM_ProgramNameChangeFlag = 0x00
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)
            KeyBeep_App()
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        else     
            SystemMode=8
            change_screen(8)
            KeyBeep_App()

            g_ChangeFirstUserNameFlag = 0x00     --改变第一用户姓名标志位
            g_ChangeSecondUserNameFlag = 0x00    --改变第二用户姓名标志位
            g_ChangeThreeUserNameFlag = 0x00     --改变第三用户姓名标志位   
        end 
        set_text(16,g_KeyBoardUserNameText,"")         --清空
	end
	--OK
	if(control==g_KeyBoardConfirmButton and value==1)then
		g_KeyBoardUserNamebfuf=get_text(16,g_KeyBoardUserNameText)   --获取用户名
        if (g_IM_ProgramNameChangeFlag == 0x01) then

            g_IM_ProgramNameChangeFlag = 0x00
            if(#g_KeyBoardUserNamebfuf <16)then
                IMUserProgramIDDataBuf[g_CurrentUser][Promgrame[g_CurrentUser]] = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_Name = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_NO = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        else
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <11)then
                if(g_ChangeFirstUserNameFlag == 0x01)then
                    g_ChangeFirstUserNameFlag = 0x00
                    TempUserNameBuf[g_FirstID] = g_KeyBoardUserNamebfuf --用户名  

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFisrtNameText_Black,TempUserNameBuf[g_FirstID])  --赋值显示
                        set_visiable(8,g_UserFisrtNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText_Black,1)
                    else    
                        set_text(8,g_UserFisrtNameText,TempUserNameBuf[g_FirstID])  --赋值显示
                        set_visiable(8,g_UserFisrtNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText,1)                        
                    end

                elseif(g_ChangeSecondUserNameFlag== 0x01)then
                    g_ChangeSecondUserNameFlag = 0x00
                    TempUserNameBuf[g_SecondID] = g_KeyBoardUserNamebfuf 

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserThreeNameText_Black,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText_Black,FirstNum)
                        set_visiable(8,g_HeadThreeNameText_Black,1)        
                    else
                        set_text(8,g_UserThreeNameText,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText,FirstNum)
                        set_visiable(8,g_HeadThreeNameText,1)        
                    end
        
                elseif(g_ChangeThreeUserNameFlag == 0x01)then
                    g_ChangeThreeUserNameFlag = 0x00
                    TempUserNameBuf[g_ThreeID] = g_KeyBoardUserNamebfuf 
                    
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFiveNameText_Black,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFiveNameText_Black,1)
                    else
                        set_text(8,g_UserFiveNameText,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText,FirstNum)
                        set_visiable(8,g_HeadFiveNameText,1)                    
                    end

                end
            end
			SystemMode=8
			change_screen(8)
            KeyBeep_App()

            g_UserDataChangeFlag =0x01                   --用户数据标改变志位
            set_text(16,g_KeyBoardUserNameText,"")         --清空
		end
	end
	if(control==g_KeyBoardSwitchButton and value==1)then   --键盘切换到大写接盘
        g_KeyBoardUserNamebfuf=get_text(16,g_KeyBoardUserNameText)   --获取用户名
        set_text(17,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf)
        SystemMode=17
		change_screen(17)
		KeyBeep_App()   
    end

    if(control>2 and control<44)then
        KeyBeep_App()
    end

    KeyBoardUserNamebfuf = get_text(16,g_KeyBoardUserNameText)
    if (g_IM_ProgramNameChangeFlag == 0x01) then
        set_value(16,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(17,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,1)             --使能OK按键
        set_enable(16,g_KeyBoardConfirmButton,1)             --使能OK按键
    elseif(#KeyBoardUserNamebfuf == 0)then
        set_value(16,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)
        set_value(17,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,0)             --关闭OK按键
        set_enable(16,g_KeyBoardConfirmButton,0)             --关闭OK按键
    else
        set_value(16,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(17,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,1)             --使能OK按键
        set_enable(16,g_KeyBoardConfirmButton,1)             --使能OK按键
    end
    --姓名缓存区,用于超过7位限制，判断
    if g_ChangeFirstUserNameFlag == 0x01 or g_ChangeSecondUserNameFlag== 0x01 or g_ChangeThreeUserNameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(16,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end

    --报告姓名缓存区,用于超过7位限制，判断
    if IM_Report_NameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(16,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告编号缓存区,用于超过6位限制，判断
    if IM_Report_NOFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 6 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 6 then
            set_text(16,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end

end


function KeyBoardBigBlack_run(control,value)             --白色键盘大写输入
    local user = g_CurrentUser
    local program = Promgrame[g_CurrentUser]
    local steps = Steps[g_CurrentUser][Promgrame[g_CurrentUser]]
    local KeyBoardUserNamebfuf = "" 
    --set_visiable(10,g_KeyBoardProgamNameText,0)      --关闭程序名输入
	--返回
	if( control==g_KeyBoardExistButton and value==1)then

        if (g_IM_ProgramNameChangeFlag == 0x01) then
            g_IM_ProgramNameChangeFlag = 0x00
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)
            KeyBeep_App()
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        else
            SystemMode=8
            change_screen(8)
            KeyBeep_App()

            g_ChangeFirstUserNameFlag = 0x00     --改变第一用户姓名标志位
            g_ChangeSecondUserNameFlag = 0x00    --改变第二用户姓名标志位
            g_ChangeThreeUserNameFlag = 0x00     --改变第三用户姓名标志位  
        end

        set_text(16,g_KeyBoardUserNameText,"")         --清空
	end
	--OK
	if(control==g_KeyBoardConfirmButton and value==1)then 	
		g_KeyBoardUserNamebfuf=get_text(17,g_KeyBoardUserNameText)   --获取用户名
        if (g_IM_ProgramNameChangeFlag == 0x01) then
            g_IM_ProgramNameChangeFlag = 0x00
            if(#g_KeyBoardUserNamebfuf <16)then
                IMUserProgramIDDataBuf[g_CurrentUser][Promgrame[g_CurrentUser]] = g_KeyBoardUserNamebfuf
            end  
            
            SystemMode=1
            change_screen(IM_Set_ScreenID)          --用户程序设置界面
            IM_Set_Steps_Update(steps,user, program)

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NameFlag == 0x01) then

            IM_Report_NameFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_Name = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        elseif (IM_Report_NOFlag == 0x01) then

            IM_Report_NOFlag = 0x00
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <21)then
                IM_DataReview_NO = g_KeyBoardUserNamebfuf
            end
            SystemMode=1
            change_screen(IM_DataEntry_ScreenID)          --报告录入界面
            IM_DataEntry_Screen_UI_UpData()

            KeyBeep_App() 

            set_text(16,g_KeyBoardUserNameText,"")         --清空
        else    
            if(#g_KeyBoardUserNamebfuf >0 and #g_KeyBoardUserNamebfuf <11)then
                if(g_ChangeFirstUserNameFlag == 0x01)then
                    g_ChangeFirstUserNameFlag = 0x00
                    TempUserNameBuf[g_FirstID] = g_KeyBoardUserNamebfuf

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFisrtNameText_Black,TempUserNameBuf[g_FirstID])
                        set_visiable(8,g_UserFisrtNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText_Black,1)    
                    else
                        set_text(8,g_UserFisrtNameText,TempUserNameBuf[g_FirstID])
                        set_visiable(8,g_UserFisrtNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_FirstID],1,1)
                        set_text(8,g_HeadFisrtNameText,FirstNum)
                        set_visiable(8,g_HeadFisrtNameText,1)                        
                    end
       
                elseif(g_ChangeSecondUserNameFlag== 0x01)then
                    g_ChangeSecondUserNameFlag = 0x00
                    TempUserNameBuf[g_SecondID] = g_KeyBoardUserNamebfuf 

                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserThreeNameText_Black,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText_Black,FirstNum)
                        set_visiable(8,g_HeadThreeNameText_Black,1)     
                    else
                        set_text(8,g_UserThreeNameText,TempUserNameBuf[g_SecondID])
                        set_visiable(8,g_UserThreeNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_SecondID],1,1)
                        set_text(8,g_HeadThreeNameText,FirstNum)
                        set_visiable(8,g_HeadThreeNameText,1)                         
                    end
                  
                elseif(g_ChangeThreeUserNameFlag == 0x01)then
                    g_ChangeThreeUserNameFlag = 0x00
                    TempUserNameBuf[g_ThreeID] = g_KeyBoardUserNamebfuf  
                    
                    if g_SetDarkModeFlag == 1 then
                        set_text(8,g_UserFiveNameText_Black,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText_Black,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText_Black,FirstNum)
                        set_visiable(8,g_HeadFiveNameText_Black,1)
                    else
                        set_text(8,g_UserFiveNameText,TempUserNameBuf[g_ThreeID])
                        set_visiable(8,g_UserFiveNameText,1)
                        FirstNum = string.sub(TempUserNameBuf[g_ThreeID],1,1)
                        set_text(8,g_HeadFiveNameText,FirstNum)
                        set_visiable(8,g_HeadFiveNameText,1)                    
                    end

                end
            end
			SystemMode=8
			change_screen(8)
            KeyBeep_App()

            g_UserDataChangeFlag =0x01                   --用户数据标改变志位
            set_text(16,g_KeyBoardUserNameText,"")         --清空
		end
	end
	if(control==g_KeyBoardSwitchButton and value==1)then   --键盘切换到大写接盘
        g_KeyBoardUserNamebfuf=get_text(17,g_KeyBoardUserNameText)   --获取用户名
        set_text(16,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf)
        SystemMode=16
		change_screen(16)
		KeyBeep_App()   
    end

    if(control>2 and control<44)then
        KeyBeep_App()
    end

    KeyBoardUserNamebfuf = get_text(17,g_KeyBoardUserNameText)
    if (g_IM_ProgramNameChangeFlag == 0x01) then
        set_value(17,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(16,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,1)             --使能OK按键
        set_enable(16,g_KeyBoardConfirmButton,1)             --使能OK按键
    elseif(#KeyBoardUserNamebfuf == 0)then
        set_value(17,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)      --OK图标
        set_value(16,g_KeyBoardOKIcon,0+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,0)             --关闭OK按键
        set_enable(16,g_KeyBoardConfirmButton,0)             --关闭OK按键
    else
        set_value(17,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)
        set_value(16,g_KeyBoardOKIcon,1+g_SetDarkModeFlag*2)

        set_enable(17,g_KeyBoardConfirmButton,1)             --使能OK按键
        set_enable(16,g_KeyBoardConfirmButton,1)             --使能OK按键
    end
    --姓名缓存区,用于超过7位限制，判断
    if g_ChangeFirstUserNameFlag == 0x01 or g_ChangeSecondUserNameFlag== 0x01 or g_ChangeThreeUserNameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(17,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告名程缓存区,用于超过7位限制，判断
    if IM_Report_NameFlag == 0x01 then
        if #KeyBoardUserNamebfuf == 7 then
            g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
        elseif #KeyBoardUserNamebfuf > 7 then
            set_text(17,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
        end
    end
    --报告编号缓存区,用于超过6位限制，判断
    if IM_Report_NOFlag == 0x01 then
    if #KeyBoardUserNamebfuf == 6 then
        g_KeyBoardUserNamebfuf2 = KeyBoardUserNamebfuf
    elseif #KeyBoardUserNamebfuf > 6 then
        set_text(17,g_KeyBoardUserNameText,g_KeyBoardUserNamebfuf2) 
    end
end   
end