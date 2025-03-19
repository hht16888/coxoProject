---@diagnostic disable: lowercase-global, undefined-global

--------------------- [[ 宏定义 ]]------------------------
FUNSTA_READY   = 0   -- 就绪态
FUNSTA_RUNNING = 1   -- 运行态
FUNSTA_REFUSED = 2   -- 禁用态
DISABLE = 0          -- 失能
ENABLE  = 1          -- 使能
Language = 0         -- 语言   0:中文 1:英文

VER1_STRING = "1.0.1"  -- 固件版本
VER2_STRING = "1.0.1"  -- 界面版本
VER3_STRING = "1.0.1"  -- 主控版本
VER4_STRING = "1.0.1"  -- 脚踏版本

-------------------- [[  通讯业务 Uart   ]] --------------------
-- 宏
UART_FRAME_PLD_INDEX = 6              -- roblink协议帧第一个有效数据的下标 
-- 变量
uartSendBuffer = {}                   -- 串口数据发送Buffer
uartSeq = 0                           -- 串口发送的序列字节
uartSeqMsg01 = 0                      -- Msg01帧的序列字节
uartSeqMsg02 = 0                      -- Msg02帧的序列字节
uartSeqMsg03 = 0                      -- Msg03帧的序列字节
uartSeqMsg04 = 0                      -- Msg04帧的序列字节
--[[
函数
function Uart_RobFrame_Transmit(msgid, len)
function CRC16_Check(data, n)
function TxMsg01_ACK(msgid)
function RxMsg01_SYN_Handler(packet)
function RxMsg02_DeviceInfo_Handler(packet) 
function RxMsg03_InitInfo_Handler(packet)
function RxMsg04_RdataCmd_Handler(packet)
function RxMsg05_RefreshView_Handler(packet)
]]--


-------------------- [[  数据存储 Flash   ]] --------------------
-- 宏

-- 变量
flashWriteBuffer = {}                   -- FLASH 写入的Buffer
flashReadBuffer = {}                    -- FLASH 读出的Buffer
flashCount = 0                          -- 计数
--[[
函数
function Flash_Write()
function Flash_Read()
function Flash_TimerEvent_Handler()
function Flash_ReFreshCount()
]]--


----------------------- [[  应用层   ]] -----------------------
-- 页面ID配置
screenID_SysInit = 0             -- 上电页面"开机大吉"
screenID_Main = 1                -- 主页面
screenID_Settings = 2            -- 设置页面
screenID_Monitor = 4             -- 开发者模式-监控
screenID_Aging = 5               -- 开发者模式-老化测试
screenID_Pump = 6                -- 开发者模式-水泵测试
screenID_Ultra = 7               -- 开发者测试-超声测试
screenID_Udisk = 9               -- 开发者模式-U盘接入
-- 定时器ID配置
timerID_SysInit = 1              -- 定时器编号.系统初始化
timerID_Uart = 3                 -- 定时器编号.串口通讯异常定时器
timerID_StatusBar = 4            -- 定时器编号.状态栏模块
timerID_CleanHose = 5            -- 定时器编号.管路清洗模块
timerID_TxRxSelf = 6             -- 定时器编号.模拟收发
timerID_DbgInfo = 7              -- 定时器变化.调试信息
timerID_Ble = 8                  -- 定时器编号.蓝牙脚踏模块
timerID_Flash = 9                -- 定时器编号.Flash
timerID_ButtonSound = 10         -- 定时器编号.按键音效
timerID_JumpToMonitor = 11       -- 定时器编号.进入监控界面
timerID_Udisk = 12               -- 定时器编号.U盘处理
timerID_BlePairedDelay = 13      -- 定时器编号.蓝牙连接成功延时
-- 控件ID配置
sys_Icon_Fuzzy = 17              -- 图标.主页面的灰幕
sys_Icon_Fuzzy2 = 14             -- 图标.设置界面的灰幕
sys_Icon_Background = 20         -- 图标.设置界面的背景控件
sys_Button_JumpToSettings = 26   -- 按钮.跳转到设置页面
sys_Icon_JumpToSettings = 25     -- 图标.跳转到设置页面
sys_Button_JumpToMain = 5        -- 按钮.跳转到主页面
-- 变量 
screenMainFsmSta = 0             -- 主页面状态机.0待机 1超声运行 2管路清洗运行 3故障弹窗
screenSettingsFsmSta = 0         -- 设置页面状态机.0待机 1恢复出厂运行 2蓝牙运行
sysDataIsChanged = 0             -- 系统数据变更标志
sysTouchSignal = 0               -- 触控信号.用于发送
--[[
函数
function ScreenMain_Init()       -- 主页面初始化
function ScreenSettings_Init()   -- 设置页面初始化
]]--



------------------- [[  状态栏模块 StatusBar  ]] -------------------
-- 控件ID配置
statusBar_ScreenID = 1             -- 页面.状态栏所在的页面ID
statusBar_Icon_BleLogo = 20        -- 图标.蓝牙logo
statusBar_Icon_Pedal = 21          -- 图标.脚踏logo
statusBar_Icon_BleBattey = 22      -- 图标.蓝牙电池电量
statusBar_Icon_Sound = 33          -- 图标.音效开关
-- 变量
statusBarPedalFilp = 0             -- 脚踏图标闪烁互斥量
statusBar_PedalIsConnected = 0     -- 有线脚踏连接状态
--[[ 函数
function StatusBar_Init()
function StatusBar_TimerEvent_Handler()
function StatusBar_UartEvent_Handler(pedalSta, bleSta, batteyLevel, noiseSwtich)
function StatusBar_RefreshView(pedalSta, batteyLevel, noiseSwitch)
--]]

------------------- [[  超声模块 Ultra  ]] -------------------
-- 控件ID配置
ultra_ScreenID = 1             -- 页面.超声功能所在的页面ID
ultra_Icon_PowerGear = 1       -- 图标.功率档位条
ultra_Icon_WaterGear = 2       -- 图标.水量档位条
ultra_Icon_M3WaterGear = 42    -- 图标.冲洗模式水量档位条
ultra_Icon_Mode = 3            -- 图标.超声模式状态栏
ultra_Icon_Tip = 4             -- 图标.工作尖
ultra_Icon_Water = 5           -- 图标.水滴
ultra_Icon_M3Water = 44        -- 图标.冲洗模式水滴
ultra_Icon_Stronger = 34       -- 图标.超强
ultra_Icon_PopError = 19       -- 图标.弹窗.故障弹窗
ultra_Icon_PowerAddSub = 12    -- 图标.功率加减
ultra_Icon_WaterAddSub = 13    -- 图标.水量加减
ultra_Icon_PowerNum = 14       -- 图标.功率数字
ultra_Icon_WaterNum = 15       -- 图标.水量数字
ultra_Icon_M3WaterNum = 43     -- 图标.冲洗模式的水量数字
ultra_Button_Stronger = 35     -- 按钮.超强开关
ultra_Button_BoneMode = 8      -- 按钮.骨手术模式
ultra_Button_PeriMode = 9      -- 按钮.牙周治疗模式
ultra_Button_EndoMode = 10     -- 按钮.根管治疗模式
ultra_Button_FlushMode = 11    -- 按钮.冲洗模式
ultra_Button_WaterUp = 40      -- 按钮.增加水量档位
ultra_Button_WaterDown = 32    -- 按钮.减少水量档位
ultra_Button_M3WaterUp = 45    -- 按钮.冲洗模式增加水量档位
ultra_Button_M3WaterDown = 46  -- 按钮.冲洗模式减少水量档位
ultra_Button_PowerUp = 31      -- 按钮.增加功率档位
ultra_Button_PowerDown = 27    -- 按钮.减少功率档位

-- 变量
ultraFunSta = FUNSTA_READY     -- 模块任务状态 0就绪态  1运行态  2禁用态
ultraFsmStep = 0               -- 状态机 0待机  1运行
-- 超声参数表.4行3列.超强开关[][1] 功率档位[][2] 水量档位[][3] 
ultraParamTable = {{       0,           2,           2      },    -- 骨手术   模式 [1][]
                   {       0,           3,           3      },    -- 牙周治疗 模式 [2][]
                   {       0,           4,           4      },    -- 根管治疗 模式 [3][]
                   {       0,           0,           0      }}    -- 冲洗    模式 [4][]
--发送与接收共用.以参数表作为缓存区
ultraMode = 0                  -- 超声模式 0骨手术 1牙周治疗 2根管治疗 3冲洗
ultraMode_Response = 0         -- 超声模式(接收) 0骨手术 1牙周治疗 2根管治疗 3冲洗
ultraStrongerFlag = 0          -- 超强开关 0关  1开
ultraStrongerFlag_Response = 0 -- 超强开关(接收) 0关  1开
ultraPowerGear = 1             -- 功率档位 0-7
ultraPowerGear_Response = 0    -- 功率档位(接收) 0-7
ultraWaterGear = 1             -- 水量档位 0-7
ultraWaterGear_Response = 0    -- 水量档位(接收) 0-7
ultraErroeCode = 0             -- 超声故障代码
ultraDataIsChanged = 0         -- 模块参数发生变生变更标志
ultraRunSta_Response = 0       -- 超声运行状态0开机1运行
--[[ 函数
function Ultra_Init()
function Ultra_SetFunState()
function Ultra_ButtonEvent_Handler(control)
function Ultra_UartEvent_Handler(response)
function Ultra_RefreshView(fsmStep)
function Ultra_SetButtonEnable(val)
--]]

------------------- [[  照明灯模块 Light  ]] -------------------
-- 控件ID配置
light_ScreenID = 1             -- 页面.照明灯功能所在的页面ID
light_Icon_Logo = 6            -- 图标.照明灯标签
light_Button_Logo = 7          -- 按钮.照明灯区域
-- 变量
lightFunSta = FUNSTA_READY     -- 模块任务状态 0就绪态  1运行态  2禁用态
lightFsmStep = 0               -- 状态机 0关模式  1开模式  2自动模式
lightMode = 0                  -- 模块参数 0关模式  1开模式  2自动模式
lightMode_Response = 0         -- 响应数据(接收)   0关模式  1开模式  2自动模式
lightDataIsChanged = 0         -- 模块参数发生变生变更标志
--[[ 函数
function Light_Init()
function Light_SetFunState(val)
function Light_ButtonEvent_Handler(control)
function Light_UartEvent_Handler(response)
function Light_RefreshView(fsmStep)
--]]

------------------- [[  管路清洗模块 CleanHose  ]] -------------------
-- 控件ID配置
cleanHose_ScreenID = 1               -- 页面.管路清洗功能所在的页面ID
cleanHose_Icon_Logo = 36             -- 图标.管路清洗Logo
cleanHose_Icon_Pop = 18              -- 图标.管路清洗对话弹窗
cleanHose_Text_Sec = 39              -- 文本.倒计时 s
cleanHose_Text_Count = 38            -- 文本.倒计时计数
cleanHose_Button_Logo = 37           -- 按钮.管路清洗Logo区域
cleanHose_Button_Left = 28           -- 按钮.弹窗对话左按钮
cleanHose_Button_Mid = 29            -- 按钮.弹窗对话中按钮
cleanHose_Button_Right = 30          -- 按钮.弹窗对话右按钮
-- 常量
CLEAN_HOSE_TIME_MAX = 30             -- 最长清洗时长.单位：秒
-- 变量
cleanHoseFunSta = FUNSTA_READY       -- 模块任务状态 0就绪态  1运行态  2禁用态
cleanHoseFsmStep = 0                 -- 状态机(发送) 0无动作 1弹窗确认 2清洗中
cleanHoseRun_Request = 0             -- 请求数据(发出)  0无请求    1请求停止清洗  2请求执行清洗
cleanHoseRun_Response = 0            -- 响应数据(接收)  0停止清洗  1正在清洗
cleanHoseTimeCount = 0               -- 计数值
cleanHoseDataIsChanged = 0           -- 模块数据发生变更
--[[ 函数
function CleanHose_Init()
function CleanHose_SetFunState()
function CleanHose_ButtonEvent_Handler(control)
function CleanHose_TimerEvent_Handler()   
function CleanHose_UartEvent_Handler(response)
function CleanHose_RefreshView(fsmStep)
function CleanHose_SetButtonEnable(val)
--]]

--------------- [[  按键音效 Sound + 亮度调节 Brightness + 版本信息  ]] -------------------
-- 控件ID配置
sound_Icon_Switch = 1          -- 图标.音效开关
sound_Button_Switch = 6        -- 按钮.开关区域
brightness_Icon_Level = 2      -- 图标.亮度调节
brightness_Button_Level = 7    -- 按钮.调节区域
version_Text_Display1 = 23     -- 文本.固件版本 中文
version_Text_Display2 = 24     -- 文本.界面版本 中文
version_Text_Display3 = 25     -- 文本.主控版本 中文
version_Text_Display4 = 26     -- 文本.脚踏版本 中文

version_Text_Display5 = 29     -- 文本.固件版本 英文
version_Text_Display6 = 30     -- 文本.界面版本 英文
version_Text_Display7 = 31     -- 文本.主控版本 英文
version_Text_Display8 = 28     -- 文本.脚踏版本 英文

-- 变量
soundSwitch = 0                -- 音效开关 0关1开
brightnessLevel = 0            -- 亮度等级 012
--[[ 函数
function SysSettings_Init()
function SysSettings_ButtonEvent_Handler(control)
function BeepTwice()
function BeepOnce
--]]

-------------------- [[  恢复出厂设置 Restore ]] ------------------------
-- 控件ID配置
restore_ScreenID = 2           -- 页面.功能所在的页面
restore_Icon_Pop = 18          -- 图标.弹窗
restore_Button_Logo = 9        -- 按钮.功能按钮
restore_Button_Icon = 4        -- 图标.功能按钮
restore_Button_Left = 10       -- 按钮.左按钮
restore_Button_Right = 17      -- 按钮.右按钮
-- 变量
restoreFunSta = FUNSTA_READY   -- 模块任务状态 0就绪态  1运行态  2禁用态
restoreFsmStep = 0             -- 状态机(发送) 0无动作 1弹窗确认 2执行中
restoreRun_Request = 0         -- 请求数据(发出)  0无请求  1请求恢复出厂
restoreRun_Response = 0        -- 响应数据(接收)  0无      1完成
restoreDataIsChanged = 0       -- 模块数据发生变更
--[[ 函数
function Restore_Init()
function Restore_SetFunState(val)
function Restore_ButtonEvent_Handler(control)
function Restore_UartEvent_Handler(response)
function Restore_RefreshView(fsmStep)
function Restore_Action()
--]]

------------------- [[  蓝牙模块 Ble  ]] -------------------
-- 控件ID配置
ble_ScreenID = 2               -- 页面.蓝牙模块所在的页面ID
ble_Icon_Logo = 3              -- 图标.蓝牙Logo
ble_Icon_Pop = 11              -- 图标.蓝牙弹窗
ble_Button_Logo = 8            -- 按钮.蓝牙Logo可触摸区域
ble_Button_Left = 12           -- 按钮.弹窗对话左按钮
ble_Button_Mid = 15            -- 按钮.弹窗对话中按钮
ble_Button_Right = 13          -- 按钮.弹窗对话右按钮
-- 常量
BLE_PAIRING_TIMEOUT = 30       -- 蓝牙配对超时时长.单位.秒
BLE_STOP_PAIRING_TIMEOUT = 10  -- 蓝牙中止配对超时时长.单位.秒
BLE_UNPAIRING_TIMEOUT = 10     -- 蓝牙取消超时时长.单位.秒
-- 变量
bleFunSta = FUNSTA_READY       -- 模块任务状态 0就绪态  1运行态  2禁用态       
bleFsmStep = 0                 -- 状态机.0未配对      1 配对询问      2 发起配对      3 配对超时  
                               --        4 配对成功    5 取消配对询问  6 发起取消配对  7 发起中止配对
bleRun_Request = 0             -- 请求数据(发出) 0无请求  1请求配对  2请求取消配对  3请求中止配对
bleRun_Response = 0            -- 响应数据(接收) 0未配对  1未连接    2已连接        3中止配对成功
blePairedSucceedDelayCnt = 0   -- 蓝牙配对成功延时
belRun_PairedSucceed = 0       -- 用于弹窗消失
bleBatteyLevel= 0              -- 蓝牙电量 01234
bleTimeCount = 0               -- 蓝牙模块计数
bleDataIsChanged = 0           -- 数据变更标志位
blePairedFlag_ReadFlash = 0    -- 蓝牙配对成功标志位.从Flash读取
blePairedFlag_WriteFlash = 0   -- 蓝牙配对成功标志位.写进Flash读取

--[[ 函数
function Ble_Init()
function Ble_SetFunState(val)
function Ble_Button_Disable()
function Ble_TimerEvent_Handler()
function Ble_TimerEvent2_Handler()
function Ble_ButtonEvent_Handler(control)
function Ble_UartEvent_Handler(response)
function Ble_RefreshView(fsmStep)
--]]


------------------- [[  二维码内容  ]] -------------------



------------------- [[  测试内容  ]] -------------------
--Flag = 0



-------------------------------------------------------------------------------
-- name  on_init()
-- note  库函数.开机初始化
-------------------------------------------------------------------------------
function on_init()

    dofile("module_debug.lua")
    dofile("SNCODE.lua")
    dofile("Udisk.lua")
    uart_set_baudrate(115200)

    --Flag = 1            --置一的时候串口不接收信息 

    Flash_Read()
    
    ScreenMain_Init()     -- 主页面初始化
    StatusBar_Init()      -- 状态栏模块初始化
    Ultra_Init()          -- 超声模块初始化
    Light_Init()          -- 照明灯模块初始化
    CleanHose_Init()      -- 管路清洗模块初始化

    ScreenSettings_Init() -- 设置页面初始化
    SysSettings_Init()    -- 按键音和屏幕亮度初始化
    Restore_Init()        -- 恢复出厂功能初始化
    Ble_Init()            -- 蓝牙初始化

    Flash_RefreshCount()  -- 开启一次存储   
    Dbg_Init()            -- 调试模块初始化

    Directives_Init()     -- 指令开机初始化
    SNCode_Init()         -- SN码开机初始化

    beep(300)  -- 开机提示音


    --start_timer(timerID_SysInit, 400, 0, 1)   -- 开机延时1秒.等待稳定
end


-------------------------------------------------------------------------------
-- name  ScreenMain_Init()
-- note  用户函数.主页面初始化
-------------------------------------------------------------------------------
function ScreenMain_Init()
    -- 进入设置界面图标根据语言显示
    set_value(screenID_Main, sys_Icon_JumpToSettings, 0+(Language*1))
end

-------------------------------------------------------------------------------
-- name  ScreenSettings_Init()
-- note  用户函数.设置页面初始化
-------------------------------------------------------------------------------
function ScreenSettings_Init()
    -- 设置界面背景图标根据语言显示
    set_value(screenID_Settings, sys_Icon_Background, 0+(Language*1))
    
    -- 设置版本信息
    if Language == 0 then -- 中文
        set_text(screenID_Settings, version_Text_Display1, VER1_STRING)
        set_text(screenID_Settings, version_Text_Display2, VER2_STRING)
        set_text(screenID_Settings, version_Text_Display3, VER3_STRING)
        set_text(screenID_Settings, version_Text_Display4, VER4_STRING)
        set_text(screenID_Settings, version_Text_Display5, ' ')
        set_text(screenID_Settings, version_Text_Display6, ' ')
        set_text(screenID_Settings, version_Text_Display7, ' ')
        set_text(screenID_Settings, version_Text_Display8, ' ')

    elseif Language == 1 then -- 英文
        set_text(screenID_Settings, version_Text_Display1, ' ')
        set_text(screenID_Settings, version_Text_Display2, ' ')
        set_text(screenID_Settings, version_Text_Display3, ' ')
        set_text(screenID_Settings, version_Text_Display4, ' ')
        set_text(screenID_Settings, version_Text_Display5, VER1_STRING)
        set_text(screenID_Settings, version_Text_Display6, VER2_STRING)
        set_text(screenID_Settings, version_Text_Display7, VER3_STRING)
        set_text(screenID_Settings, version_Text_Display8, VER4_STRING)
    end

end

-------------------------------------------------------------------------------
-- name  on_timer()  timer_id 定时器编号
-- note  库函数.定时器更新事件回调函数 
-------------------------------------------------------------------------------
function on_timer(timer_id)

    -- 系统开机定时器
    if timer_id == timerID_SysInit then
        SysInit_TimerEvent_Handler()
    end

    -- 按键音效  
    if timer_id == timerID_ButtonSound then
        beep(50)
    end    
    
    -- 管路清洗功能
    if timer_id == timerID_CleanHose then
        CleanHose_TimerEvent_Handler()
    end
    
    -- 状态栏模块
    if timer_id == timerID_StatusBar then
        StatusBar_TimerEvent_Handler()
    end
   
    -- 蓝牙模块
    if timer_id == timerID_Ble then
        Ble_TimerEvent_Handler()
    end
    -- 蓝牙模块 配对成功延时
    if timer_id == timerID_BlePairedDelay then
        Ble_TimerEvent2_Handler()
    end

    -- 模拟串口数据接收
    if timer_id == timerID_TxRxSelf then
        Dbg_TxRxSelf_TimerEvent_Handler()
    end

    -- Flash存储
    if timer_id == timerID_Flash then
        Flash_TimerEvent_Handler()
    end

    -- 调试信息显示
    if timer_id == timerID_DbgInfo then
        Dbg_TimerEvent_Handler()
    end

    -- U盘处理
    if timer_id == timerID_Udisk then
        Udisk_TimerEvent_Handler()
    end

end

-------------------------------------------------------------------------------
-- name  on_control_notify(screen, control, value) screen页码 control控件ID value赋值 
-- note  大彩库函数.控件触发事件
-------------------------------------------------------------------------------
function on_control_notify(screen, control, value)
    --local temp
    local tempButtonIsTrigger = 0
    sysTouchSignal = sysTouchSignal % 200 +1

    tempButtonIsTrigger = DbgMain_ButtonEvent_Handler(screen, control, value)
    if tempButtonIsTrigger == 1 then return end

    tempButtonIsTrigger = Dbg_ButtonEvent_Handler(screen, control, value)
    if tempButtonIsTrigger == 1 then return end


    if screen == screenID_Main and value == 1 then
        -- 主页面按钮事件处理
        if control == sys_Button_JumpToSettings then
            BeepOnce()
            change_screen(screenID_Settings)  -- 跳转到设置界面
        elseif control == SNCode_Enter_Button then
            SNCode_Screen_Enter()
        end

        -- 超声模块按钮事件处理
        tempButtonIsTrigger = Ultra_ButtonEvent_Handler(control)
        if tempButtonIsTrigger == 1 then return end

        -- 照明灯模块按钮事件处理
        tempButtonIsTrigger = Light_ButtonEvent_Handler(control)
        if tempButtonIsTrigger == 1 then return end

        -- 管路清洗模块按钮事件处理
        tempButtonIsTrigger = CleanHose_ButtonEvent_Handler(control)
        if tempButtonIsTrigger == 1 then return end

    elseif screen == screenID_Settings then
        if value == 1 then
            -- 设置页面按钮事件处理
            if control == sys_Button_JumpToMain then
                BeepOnce()
                change_screen(screenID_Main)  -- 跳转到主页面
            end
            -- 恢复出厂设置事件处理
            tempButtonIsTrigger = Restore_ButtonEvent_Handler(control)
            if tempButtonIsTrigger == 1 then return end

            -- 蓝牙按钮事件处理
            tempButtonIsTrigger = Ble_ButtonEvent_Handler(control)
            if tempButtonIsTrigger == 1 then return end

            -- 系统设置事件处理
            tempButtonIsTrigger = SysSettings_ButtonEvent_Handler(control)

            if tempButtonIsTrigger == 1 then return end

            Directives_Enable(control)                --使能指令输入按钮
        end

        if control == g_Directives_Icon then        --SN码清除指令
            SNCode_Purge()
        end
    elseif screen == SNCode_Input_Screen and value == 1 then  --SN输入界面按钮事件处理
        if control == SNCode_Input_Button then
            SNCode_Input()
        elseif control == SNCode_Return_Button then
            SNCode_Screen_Quit()
        elseif control == SNDelete_Button then
            SNCode_Delete()
        end
    end

    tempButtonIsTrigger = Udisk_ButtonEvent_Handler(screen, control, value)
    if tempButtonIsTrigger == 1 then return end

    Flash_RefreshCount() --写Flash开启
end

-------------------------------------------------------------------------------
-- name  on_uart_recv_data(packet)  packet表示接收到的字节数组,下标从0开始
-- note  大彩库函数,协议格式: EE B5 AA + 长度LEN + 序列字节SEQ + 消息包编号MSG + 
--       有效载荷PLD + 校验低CKL + 校验高CKH + FF FC FF FF     
--       其中帧头EE B5 和帧尾FF FC FF FF大彩识别成功后触发              2024-12-11
-------------------------------------------------------------------------------
function on_uart_recv_data(packet)
    local STX   -- 帧头 0xAA
    local LEN   -- 载荷长度
    local SEQ   -- 序列字节(可不处理)
    local MSG   -- 消息包编号
    local CKL = 0   -- 校验低
    local CKH = 0  -- 校验高
    local crc   -- CRC校验值
    local checklen

    STX = packet[2]
    LEN = packet[3]
    SEQ = packet[4]
    MSG = packet[5]

    if packet[LEN+6] ~= nil then
        CKL = packet[LEN+6]
    end

    if packet[LEN+7] ~= nil then
        CKH = packet[LEN+7]
    end

    checklen = LEN+5
    -- SEQ=0 时不需CRC校验.
    if STX == 0xAA and SEQ ~= 0 then
        crc = CRC16_Check(packet, checklen)
    elseif STX == 0xAA and SEQ == 0  then
        crc = 0
        CKL = 0
        CKH = 0
    end
     

    if crc == (CKL + CKH * 256) then
        dbgTxRxSelfCnt = 0  -- 接收到信息.自收发通讯标志清0
        if MSG == 0x00  then
            TxMsg01_ACK(0x00)                         -- 测试包 返回 ACK+0x00
        elseif MSG == 0x01  then
            RxMsg01_SYN_Handler(packet)               -- Msg = 01 接收到主板端发送的 握手请求
        elseif MSG == 0x02  then
            RxMsg02_DeviceInfo_Handler(packet)        -- Msg = 02 接收到主板端发送的 设备信息
        elseif MSG == 0x03  then
            RxMsg03_InitInfo_Handler(packet)          -- Msg = 03 接收到主板端发送的 初始化信息
        elseif MSG == 0x04  then
            RxMsg04_RdataCmd_Handler(packet)          -- Msg = 04 接收到主板端发送的 读数据请求
        elseif MSG == 0x05  then
            RxMsg05_RefreshView_Handler(packet)       -- Msg = 05 接收到主板端发送的 全局更新
        elseif MSG == 0x06  then
            RxMsg06_DbgMonitor_Handler(packet)        -- Msg = 06 接收到主板端发送的 超声监控数据
        elseif MSG == 0x07  then
            RxMsg07_DbgAging_Handler(packet)          -- Msg = 07 接收到主板端发送的 老化数据
        elseif MSG == 0x08 then
            RxMsg08_DbgUltra_Handler(packet)          -- Msg = 08 接收到主板端发送的 超声测试数据
        end
    end
end

-------------------------------------------------------------------------------
-- name : CRC16_Check()   (data数据源, n长度)
-- note : 用户函数.CRC-16-MODBUS类型
-------------------------------------------------------------------------------
function CRC16_Check(data, n)

    local i, j, carry_flag, a = 0,0,0,0
    local result = 0xffff
    for i = 0, n  do
        result =  result ~ data[i]
        for j = 1, 8  do
            a = result
            carry_flag = a & 0x0001
            result = result >> 1
            if carry_flag == 1 then
                result = result ~ 0xa001
            end
        end
    end
    return result

--[[
local i, j, carry_flag, a = 0, 0, 0, 0
local result = 0xffff
for i = 0, n-1 do -- 假设n是data数组的长度
    result = bitwise.bxor(result, data[i]) -- 假设bitwise库已经加载
    for j = 0, 7 do
        a = result
        carry_flag = a & 0x0001
        result = result >> 1
        if carry_flag ~= 0 then -- 简化条件判断
            result = bitwise.bxor(result, 0xa001)
        end
    end
end
return result
]]--
    
end

-------------------------------------------------------------------------------
-- name   Uart_RobFrame_Transmit()   (msgid 消息包ID, len 数据长度)
-- note   用户函数,补全协议并发送.用户输入消息包ID和长度.自动补充帧头帧尾和序列字节
--        EE B5 AA + 载荷长度LEN + 序列字节SEQ + 消息包编号MSG + 有效载荷PLD + 
--        校验低CKL + 校验高CKH + FF FC FF FF
-------------------------------------------------------------------------------
function Uart_RobFrame_Transmit(msgid, len)
    local crc
    -- 共享序列字节SEQ 
    uartSeq = uartSeq + 1             -- 序列字节 全局变量
    uartSeq = uartSeq % 255           -- 序列字节 自增1
    -- 独立序列字节SEQ
    if msgid == 0x01 then
        uartSeqMsg01 = uartSeqMsg01 + 1
        uartSeqMsg01 = uartSeqMsg01 % 255
        uartSendBuffer[4] = uartSeqMsg01
    elseif msgid == 0x02 then
        uartSeqMsg02 = uartSeqMsg02 + 1
        uartSeqMsg02 = uartSeqMsg02 % 255
        uartSendBuffer[4] = uartSeqMsg02        
    elseif msgid == 0x03 then
        uartSeqMsg03 = uartSeqMsg03 + 1
        uartSeqMsg03 = uartSeqMsg03 % 255
        uartSendBuffer[4] = uartSeqMsg03
    else
        uartSendBuffer[4] = 0
    end

    uartSendBuffer[0] = 0xEE                -- 固定帧头
    uartSendBuffer[1] = 0xB5                -- 固定帧头
    uartSendBuffer[2] = 0xAA                -- 固定帧头
    uartSendBuffer[3] = len                 -- 长度

    uartSendBuffer[5] = msgid               -- 消息包编号
    crc = CRC16_Check(uartSendBuffer, len+5)
    uartSendBuffer[len+6 ] = crc % 256      -- 校验值低字节
    uartSendBuffer[len+7 ] = crc // 256     -- 校验值高字节
    uartSendBuffer[len+8 ] = 0xFF           -- 固定帧尾
    uartSendBuffer[len+9 ] = 0xFC           -- 固定帧尾
    uartSendBuffer[len+10] = 0xFF           -- 固定帧尾
    uartSendBuffer[len+11] = 0xFF           -- 固定帧尾

    uart_send_data(uartSendBuffer)

end

-------------------------------------------------------------------------------
-- name  TxMsg01_ACK(msgid)  msgid 回复对方的帧ID
-- note  用户函数.收到主板端01帧的握手请求.本机发送01帧应答“DCOK+对方帧ID”
-------------------------------------------------------------------------------
function TxMsg01_ACK(msgid)
    uartSendBuffer[UART_FRAME_PLD_INDEX  ] = 0x41  -- 'A'
    uartSendBuffer[UART_FRAME_PLD_INDEX+1] = 0x43  -- 'C'
    uartSendBuffer[UART_FRAME_PLD_INDEX+2] = 0x4B  -- 'K'
    uartSendBuffer[UART_FRAME_PLD_INDEX+3] = msgid
    Uart_RobFrame_Transmit(0x01, 4)  -- 01帧 长度4
end

-------------------------------------------------------------------------------
-- name  RxMsg01_SYN_Handler(packet)   (packet表示接收的字节数组.下标从0开始)
-- note  用户函数.收到主机端01帧的握手请求.本机发送01帧应答“ACK+0x01”
-------------------------------------------------------------------------------
function RxMsg01_SYN_Handler(packet)
    local LEN   -- 载荷长度
    local PLD   -- 第一个有效数据的数组下标
    LEN = packet[3]
    PLD = LEN+3
    -- 0x53='S'  0x59='Y'  0x4E='N'
    if packet[PLD] == 0x53 and packet[PLD+1] == 0x59 and packet[PLD+2] == 0x4E then
        TxMsg01_ACK(0x01)
    end
end

-------------------------------------------------------------------------------
-- name  RxMsg02_DeviceInfo_Handler(packet)   (packet表示接收的字节数组.下标从0开始)
-- note  用户函数.收到主机端02帧的设备信息.本机发送02帧显示屏的设备版本信息
-------------------------------------------------------------------------------
function RxMsg02_DeviceInfo_Handler(packet) 
    -- UI软件版本信息 1.0.1
    uartSendBuffer[UART_FRAME_PLD_INDEX  ] = 0x01
    uartSendBuffer[UART_FRAME_PLD_INDEX+1] = 0x00
    uartSendBuffer[UART_FRAME_PLD_INDEX+2] = 0x01
    --屏幕固件版本信息 1.0.2
    uartSendBuffer[UART_FRAME_PLD_INDEX+3] = 0x01
    uartSendBuffer[UART_FRAME_PLD_INDEX+4] = 0x00
    uartSendBuffer[UART_FRAME_PLD_INDEX+5] = 0x02
    Uart_RobFrame_Transmit(0x02, 6)  -- 02帧 长度6
end

-------------------------------------------------------------------------------
-- name  RxMsg03_InitInfo_Handler(packet)   (packet表示接收的字节数组.下标从0开始)
-- note  用户函数.收到主机端03帧的初始化信息.返回记忆数据
-------------------------------------------------------------------------------
function RxMsg03_InitInfo_Handler(packet)
    uartSendBuffer[UART_FRAME_PLD_INDEX   ] = ultraParamTable[1][1]    -- 骨手术   超强标志
    uartSendBuffer[UART_FRAME_PLD_INDEX+1 ] = ultraParamTable[1][2]    -- 骨手术   功率档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+2 ] = ultraParamTable[1][3]    -- 骨手术   水量档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+3 ] = ultraParamTable[2][1]    -- 牙周治疗 超强标志
    uartSendBuffer[UART_FRAME_PLD_INDEX+4 ] = ultraParamTable[2][2]    -- 牙周治疗 功率档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+5 ] = ultraParamTable[2][3]    -- 牙周治疗 水量档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+6 ] = ultraParamTable[3][1]    -- 根管治疗 超强标志
    uartSendBuffer[UART_FRAME_PLD_INDEX+7 ] = ultraParamTable[3][2]    -- 根管治疗 功率档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+8 ] = ultraParamTable[3][3]    -- 根管治疗 水量档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+9 ] = 0                        -- 冲洗     超强标志 固定为0 
    uartSendBuffer[UART_FRAME_PLD_INDEX+10] = 0                        -- 冲洗     功率档位 固定为0 
    uartSendBuffer[UART_FRAME_PLD_INDEX+11] = ultraParamTable[4][3]    -- 冲洗     水量档位  
    uartSendBuffer[UART_FRAME_PLD_INDEX+12] = ultraMode                -- 超声模式
    uartSendBuffer[UART_FRAME_PLD_INDEX+13] = ultraStrongerFlag        -- 超强开关  
    uartSendBuffer[UART_FRAME_PLD_INDEX+14] = ultraPowerGear           -- 超声功率档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+15] = ultraWaterGear           -- 超声水量档位
    uartSendBuffer[UART_FRAME_PLD_INDEX+16] = lightMode                -- 照明灯模式
    uartSendBuffer[UART_FRAME_PLD_INDEX+17] = blePairedFlag_ReadFlash  -- 蓝牙配对记忆.从Flash读取
    Uart_RobFrame_Transmit(0x04, 18)  -- 04帧 长度18
end

-------------------------------------------------------------------------------
-- name  RxMsg04_RdataCmd_Handler()   (packet表示接收的字节数组.下标从0开始)
-- note  用户函数.收到主机端04帧的读数据请求.
-------------------------------------------------------------------------------
function RxMsg04_RdataCmd_Handler(packet)
    local tempScreenID

    tempScreenID = get_current_screen()

    if tempScreenID == screenID_Main or tempScreenID == screenID_Settings then
        uartSendBuffer[UART_FRAME_PLD_INDEX  ]  = 0x00
        -- 当前页面的状态机
        if tempScreenID == screenID_Main then
            uartSendBuffer[UART_FRAME_PLD_INDEX+1]  = screenMainFsmSta
        elseif tempScreenID == screenID_Settings  then
            uartSendBuffer[UART_FRAME_PLD_INDEX+1]  = screenSettingsFsmSta
        end
        uartSendBuffer[UART_FRAME_PLD_INDEX+2]  = tempScreenID            -- 当前页面 
        uartSendBuffer[UART_FRAME_PLD_INDEX+3]  = ultraMode               -- 超声模式
        uartSendBuffer[UART_FRAME_PLD_INDEX+4]  = ultraStrongerFlag       -- 超强开关
        uartSendBuffer[UART_FRAME_PLD_INDEX+5]  = ultraPowerGear          -- 功率挡位
        uartSendBuffer[UART_FRAME_PLD_INDEX+6]  = ultraWaterGear          -- 水量挡位
        uartSendBuffer[UART_FRAME_PLD_INDEX+7]  = lightMode               -- 照明灯模式指令
        uartSendBuffer[UART_FRAME_PLD_INDEX+8]  = cleanHoseRun_Request    -- 管路清洗指令
        uartSendBuffer[UART_FRAME_PLD_INDEX+9]  = restoreRun_Request      -- 恢复出厂设置指令
        uartSendBuffer[UART_FRAME_PLD_INDEX+10] = bleRun_Request          -- 蓝牙指令
        uartSendBuffer[UART_FRAME_PLD_INDEX+11] = blePairedFlag_ReadFlash -- 蓝牙配对记忆.从Flash读取
        Uart_RobFrame_Transmit(0x03, 12)  -- 03帧 长度12
    elseif tempScreenID == screenID_Monitor then
        uartSendBuffer[UART_FRAME_PLD_INDEX]   = tempScreenID           -- 当前页面         
        uartSendBuffer[UART_FRAME_PLD_INDEX+1] = 0x4D
        uartSendBuffer[UART_FRAME_PLD_INDEX+2] = 0x6F
        uartSendBuffer[UART_FRAME_PLD_INDEX+3] = 0x6E
        Uart_RobFrame_Transmit(0x05, 4)  -- 05帧 长度4
    elseif tempScreenID == screenID_Aging then
        uartSendBuffer[UART_FRAME_PLD_INDEX]   = tempScreenID           -- 当前页面          
        uartSendBuffer[UART_FRAME_PLD_INDEX+1] = 0x41
        uartSendBuffer[UART_FRAME_PLD_INDEX+2] = 0x67
        uartSendBuffer[UART_FRAME_PLD_INDEX+3] = 0x69
        uartSendBuffer[UART_FRAME_PLD_INDEX+4] = 0x6E
        uartSendBuffer[UART_FRAME_PLD_INDEX+5] = 0x67
        uartSendBuffer[UART_FRAME_PLD_INDEX+6] = dbgAgingSwitch
        uartSendBuffer[UART_FRAME_PLD_INDEX+7] = dbgAgingReset
        uartSendBuffer[UART_FRAME_PLD_INDEX+8] = DBG_AGING_RUN_DURATION_OF_TIME
        uartSendBuffer[UART_FRAME_PLD_INDEX+9] = DBG_AGING_STOP_DURATION_OF_TIME
        Uart_RobFrame_Transmit(0x06, 10)  -- 06帧 长度10
    elseif tempScreenID == screenID_Ultra then
        uartSendBuffer[UART_FRAME_PLD_INDEX]    = tempScreenID           -- 当前页面          
        uartSendBuffer[UART_FRAME_PLD_INDEX+1]  = 0x55
        uartSendBuffer[UART_FRAME_PLD_INDEX+2]  = 0x6C
        uartSendBuffer[UART_FRAME_PLD_INDEX+3]  = 0x74
        uartSendBuffer[UART_FRAME_PLD_INDEX+4]  = 0x72
        uartSendBuffer[UART_FRAME_PLD_INDEX+5]  = 0x64
        uartSendBuffer[UART_FRAME_PLD_INDEX+6]  = dbgUltraRunSwitch
        uartSendBuffer[UART_FRAME_PLD_INDEX+7]  = dbgUltraSetVbus
        uartSendBuffer[UART_FRAME_PLD_INDEX+8]  = dbgUltraSetPowerDuty
        uartSendBuffer[UART_FRAME_PLD_INDEX+9]  = dbgUltraSetWaterRpm
        uartSendBuffer[UART_FRAME_PLD_INDEX+10] = (dbgUltraSetFreq >> 8) & 0xFF
        uartSendBuffer[UART_FRAME_PLD_INDEX+11] = dbgUltraSetFreq & 0xFF
        Uart_RobFrame_Transmit(0x07, 12)  -- 07帧 长度12
    end
end


-------------------------------------------------------------------------------
-- name  RxMsg05_RefreshView_Handler()   (packet表示接收的字节数组.下标从0开始)
-- note  用户函数.收到主机端05帧.执行更新全局参数与UI显示
--       本机发送应答帧TxMsg01_ACK(0x05)
-------------------------------------------------------------------------------
function RxMsg05_RefreshView_Handler(packet)
    local tempblePairedFlag
    local tempDataIsChanged

    -- 超声模块
    ultraMode_Response         = packet[UART_FRAME_PLD_INDEX  ]   -- 超声模式
    ultraStrongerFlag_Response = packet[UART_FRAME_PLD_INDEX+1]   -- 超强开关
    ultraPowerGear_Response    = packet[UART_FRAME_PLD_INDEX+2]   -- 功率档位
    ultraWaterGear_Response    = packet[UART_FRAME_PLD_INDEX+3]   -- 水量档位
    ultraRunSta_Response       = packet[UART_FRAME_PLD_INDEX+4]   -- 超声运行状态 0待机1运行
    -- 照明灯模块
    lightMode_Response         = packet[UART_FRAME_PLD_INDEX+5]   -- 0关 1开 2自动
    -- 管路清洗模块
    cleanHoseRun_Response      = packet[UART_FRAME_PLD_INDEX+6]   -- 0停止清洗 1执行清洗
    -- 有线脚踏连接状态
    statusBar_PedalIsConnected = packet[UART_FRAME_PLD_INDEX+7]   -- 0未连接  1已连接  
    -- 蓝牙脚踏模块
    bleRun_Response            = packet[UART_FRAME_PLD_INDEX+8]
    bleBatteyLevel             = packet[UART_FRAME_PLD_INDEX+9] -- 蓝牙电量
    -- 故障代码
    ultraErroeCode             = packet[UART_FRAME_PLD_INDEX+10]
    -- 恢复出厂设置功能
    restoreRun_Response        = packet[UART_FRAME_PLD_INDEX+11]
    -- 蓝牙连接标志位
    blePairedFlag_WriteFlash   = packet[UART_FRAME_PLD_INDEX+12] -- 写进Flash

    if tempblePairedFlag ~= blePairedFlag_WriteFlash then
        tempblePairedFlag = blePairedFlag_WriteFlash
        tempDataIsChanged = 1
    end

    
    -- 模块数据状态复位
    cleanHoseDataIsChanged = 0
    restoreDataIsChanged = 0
    bleDataIsChanged = 0

    tempScreenID = get_current_screen()  -- 获取当前界面

        -- 判断主页面.各功能状态
        if ultraErroeCode ~= 0 then
            screenMainFsmSta = 3  -- 超声故障
        elseif ultraFunSta == FUNSTA_RUNNING then
            screenMainFsmSta = 1  -- 超声运模块行
        elseif cleanHoseFunSta == FUNSTA_RUNNING then
            screenMainFsmSta = 2  -- 管路清洗模块运行
        elseif ultraErroeCode == 0 or ultraFunSta == FUNSTA_READY or cleanHoseFunSta == FUNSTA_READY then
            screenMainFsmSta = 0  -- 待机
        end
        -- 模块任务控制
        if screenMainFsmSta ~= 0 then
            Light_SetFunState(FUNSTA_REFUSED)
            if screenMainFsmSta ~= 1 then  Ultra_SetFunState(FUNSTA_REFUSED)      end
            if screenMainFsmSta ~= 2 then  CleanHose_SetFunState(FUNSTA_REFUSED)  end
        else
            Ultra_SetFunState(FUNSTA_READY)
            Light_SetFunState(FUNSTA_READY)
            CleanHose_SetFunState(FUNSTA_READY)
        end

        ScreenMain_RefreshView(screenMainFsmSta)
        -- 模块接收数据
        StatusBar_UartEvent_Handler(statusBar_PedalIsConnected, bleRun_Response, bleBatteyLevel, soundSwitch)
        if restoreRun_Request == 0 then  -- 出厂过程中不更新
            tempDataIsChanged = Ultra_UartEvent_Handler(ultraRunSta_Response)
        end
        Light_UartEvent_Handler(lightMode_Response)
        CleanHose_UartEvent_Handler(cleanHoseRun_Response)

        -- 判断设置页面.各功能状态
        if restoreFunSta == FUNSTA_RUNNING then
            screenSettingsFsmSta = 1  -- 恢复出厂模块运行
        elseif bleFunSta == FUNSTA_RUNNING then
            screenSettingsFsmSta = 2  -- 蓝牙模块运行
        elseif restoreFunSta == FUNSTA_READY or bleFunSta == FUNSTA_READY then
            screenSettingsFsmSta = 0  -- 待机
        end
        -- 模块任务控制
        if screenSettingsFsmSta ~= 0 then
            if screenSettingsFsmSta ~= 1 then  Restore_SetFunState(FUNSTA_REFUSED)   end
            if screenSettingsFsmSta ~= 2 then  Ble_SetFunState(FUNSTA_REFUSED)       end
        else
            Restore_SetFunState(FUNSTA_READY)
            Ble_SetFunState(FUNSTA_READY)
        end
        ScreenSettings_RefreshView(screenSettingsFsmSta)
        -- 模块接收数据        
        Restore_UartEvent_Handler(restoreRun_Response)

        if bleRun_Response == 2 then
            start_timer(timerID_BlePairedDelay, 2000, 0, 1)  -- 延时2s
            if belRun_PairedSucceed == 1 then
                Ble_UartEvent_Handler(bleRun_Response)
            end
        else
            belRun_PairedSucceed = 0
            Ble_UartEvent_Handler(bleRun_Response)
        end

        
        -- 模块刷新
        if tempDataIsChanged == 1 then
            tempDataIsChanged = 0
            Flash_RefreshCount()
        end

    Dbg_Show()
end




-------------------------------------------------------------------------------
-- name  ScreenMain_RefreshView(fsmStep)  screenMainFsmSta
-- note  用户函数.主页面视图更新
-------------------------------------------------------------------------------
function ScreenMain_RefreshView(fsmStep)
    if fsmStep == 0 then
        set_visiable(screenID_Main, sys_Icon_Fuzzy, DISABLE)           -- 隐藏灰幕   
        set_visiable(screenID_Main, ultra_Icon_PopError, DISABLE)      -- 隐藏故障弹窗        
        set_enable(screenID_Main, sys_Button_JumpToSettings, ENABLE)
    else
        set_enable(screenID_Main, sys_Button_JumpToSettings, DISABLE)
    end

    if fsmStep == 3 then -- 故障弹窗
        set_visiable(screenID_Main, sys_Icon_Fuzzy, ENABLE)               -- 显示灰幕
        set_visiable(screenID_Main, ultra_Icon_PopError, (ultraErroeCode-1)+(Language*4))  -- 超声故障弹窗
        set_value(screenID_Main, ultra_Icon_PopError, (ultraErroeCode-1)+(Language*4))  -- 超声故障弹窗       
    end
end

-------------------------------------------------------------------------------
-- name  ScreenSettings_RefreshView(fsmStep)  screenSettingsFsmSta
-- note  用户函数.设置页面视图更新
-------------------------------------------------------------------------------
function ScreenSettings_RefreshView(fsmStep)
    if fsmStep == 0 then
        set_visiable(screenID_Settings, sys_Icon_Fuzzy2, DISABLE)        -- 隐藏灰幕          
        set_enable(screenID_Settings, sys_Button_JumpToMain, ENABLE) 
        set_enable(screenID_Settings, sound_Button_Switch, ENABLE)   
        set_enable(screenID_Settings, brightness_Button_Level, ENABLE)           
    else
        set_enable(screenID_Settings, sys_Button_JumpToMain, DISABLE) 
        set_enable(screenID_Settings, sound_Button_Switch, DISABLE)   
        set_enable(screenID_Settings, brightness_Button_Level, DISABLE)                  
    end
end

-------------------------------------------------------------------------------
-- name  SysInit_TimerEvent_Handler()
-- note  用户函数.开机初始化完成后进入主界面
-------------------------------------------------------------------------------
function SysInit_TimerEvent_Handler()
    beep(100)
    --Flag = 0
    change_screen(screenID_Main)  -- 跳转到主界面
end



-------------------------------------------------------------------------------
-- name  Flash_TimerEvent_Handler()
-- note  用户函数.Flash存储  8*100ms 存储1次
-------------------------------------------------------------------------------
function Flash_TimerEvent_Handler()
    if flashCount < 8 then
        flashCount = flashCount + 1
    else
        Flash_Write()
        stop_timer(timerID_Flash)
    end
end


-------------------------------------------------------------------------------
-- name  Flash_ReFreshCount()
-- note  用户函数.Flash喂狗
-------------------------------------------------------------------------------
function Flash_RefreshCount()
    flashCount = 0
    start_timer(timerID_Flash, 100, 0, 0)
end



-------------------------------------------------------------------------------
-- name  StatusBar_Init()
-- note  用户函数.状态栏模块.初始化
-------------------------------------------------------------------------------
function StatusBar_Init()
    statusBarPedalFilp = 0
    StatusBar_RefreshView(0, 0, 0)
end

-------------------------------------------------------------------------------
-- name  StatusBar_TimerEvent_Handler()
-- note  用户函数.状态栏模块.定时器事件
-------------------------------------------------------------------------------
function StatusBar_TimerEvent_Handler()
    if statusBarPedalFilp == 0 then
        statusBarPedalFilp = 1
        set_visiable(statusBar_ScreenID, statusBar_Icon_Pedal, ENABLE)
    else
        statusBarPedalFilp = 0
        set_visiable(statusBar_ScreenID, statusBar_Icon_Pedal, DISABLE)
     end
end

-------------------------------------------------------------------------------
-- name  StatusBar_UartEvent_Handler(pedalSta, bleSta, batteyLevel, noiseSwtich)
-- note  用户函数.状态栏模块.串口数据
-------------------------------------------------------------------------------
function StatusBar_UartEvent_Handler(pedalSta, bleSta, batteyLevel, noiseSwtich)
    local tmepPedalSta
    if pedalSta == 0 and bleSta ~= 2 then -- 有线未连接 + 蓝牙未连接
        tmepPedalSta = 0
    elseif pedalSta == 1 then  -- 有线已连接
        tmepPedalSta = 1
    elseif pedalSta == 0 and bleSta == 2 then -- 有线未连接 + 蓝牙已连接
        tmepPedalSta = 2
    end
    StatusBar_RefreshView(tmepPedalSta, batteyLevel, noiseSwtich)
end

-------------------------------------------------------------------------------
-- name  StatusBar_RefreshView(pedalSta, batteyLevel, noiseSwitch)
-- note  用户函数.状态栏模块.更新视图
-------------------------------------------------------------------------------
function StatusBar_RefreshView(pedalSta, batteyLevel, noiseSwitch)
    if pedalSta == 0 then  -- 有线无线脚踏未连接
        start_timer(timerID_StatusBar, 500, 0, 0)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleLogo, DISABLE)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleBattey, DISABLE)
    elseif pedalSta == 1 then   -- 有线已连接
        stop_timer(timerID_StatusBar)
        set_visiable(statusBar_ScreenID, statusBar_Icon_Pedal, ENABLE)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleLogo, DISABLE)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleBattey, DISABLE) 
    elseif pedalSta == 2 then  -- 有线未连接 + 无线已连接
        stop_timer(timerID_StatusBar)
        set_visiable(statusBar_ScreenID, statusBar_Icon_Pedal, ENABLE)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleLogo, ENABLE)
        set_visiable(statusBar_ScreenID, statusBar_Icon_BleBattey, ENABLE)
        if batteyLevel > 3 then
            set_value(statusBar_ScreenID, statusBar_Icon_BleBattey, 3)
        else
            set_value(statusBar_ScreenID, statusBar_Icon_BleBattey, batteyLevel)
        end
    end
    set_visiable(statusBar_ScreenID, statusBar_Icon_Sound, ENABLE)
    if noiseSwitch == 1 then
        set_value(statusBar_ScreenID, statusBar_Icon_Sound, 0)
    else
        set_value(statusBar_ScreenID, statusBar_Icon_Sound, 1)
    end
end

-------------------------------------------------------------------------------
-- name  Ultra_Init()
-- note  用户函数.超声模块功能初始化
-------------------------------------------------------------------------------
function Ultra_Init()
    Ultra_SetFunState(FUNSTA_READY)  -- 初始为就绪态
    ultraFsmStep = 0
    Ultra_RefreshView(ultraFsmStep)  -- 初始为待机
end

-------------------------------------------------------------------------------
-- name  Ultra_SetFunState(funSta)  FUNSTA_READY.FUNSTA_RUNNING.FUNSTA_REFUSED
-- note  用户函数.超声模块.设定功能模块任务状态
-------------------------------------------------------------------------------
function Ultra_SetFunState(funSta)
    ultraFunSta = funSta
end

-------------------------------------------------------------------------------
-- name  Ultra_ButtonEvent_Handler(control)
-- note  用户函数.超声模块.按钮事件
-------------------------------------------------------------------------------
function Ultra_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    local function UpdateMode(mode)
        BeepOnce()
        ultraDataIsChanged = 1
        ultraMode = mode
        ultraStrongerFlag = ultraParamTable[ultraMode + 1][1]
        ultraPowerGear = ultraParamTable[ultraMode + 1][2]
        ultraWaterGear = ultraParamTable[ultraMode + 1][3]
    end

    if control == ultra_Button_Stronger then
        BeepOnce()
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        if  ultraStrongerFlag == 1 then  -- 当前处于超强开
            ultraStrongerFlag = 0
            ultraPowerGear = ultraParamTable[ultraMode + 1][2]
        else  -- 当前处于超强关
            ultraStrongerFlag = 1
        end
    elseif control == ultra_Button_BoneMode then
        UpdateMode(0)
        tempButtonIsTrigger = 1
    elseif control == ultra_Button_PeriMode then
        UpdateMode(1)
        tempButtonIsTrigger = 1
    elseif control == ultra_Button_EndoMode then
        UpdateMode(2)
        tempButtonIsTrigger = 1
    elseif control == ultra_Button_FlushMode then
        UpdateMode(3)
        tempButtonIsTrigger = 1
    elseif control == ultra_Button_M3WaterUp then 
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        if ultraWaterGear < 7 then
            ultraWaterGear = ultraWaterGear + 1
            BeepOnce()
        else
            BeepTwice()
        end
    elseif control == ultra_Button_M3WaterDown then
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        if ultraWaterGear > 1 then
            ultraWaterGear = ultraWaterGear - 1
            BeepOnce()
        else
            BeepTwice()
        end
    elseif control == ultra_Button_PowerDown then  -- 功率减
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        set_value(ultra_ScreenID, ultra_Icon_PowerAddSub, 1)
        if ultraStrongerFlag == 0 and ultraPowerGear > 1 then
            ultraPowerGear = ultraPowerGear - 1
            BeepOnce()
        elseif ultraStrongerFlag == 0 and ultraPowerGear == 1  then
            BeepTwice()
        elseif ultraStrongerFlag == 1 then
            BeepOnce()
            ultraStrongerFlag = 0
            ultraPowerGear = 7
        end
    elseif control == ultra_Button_PowerUp then  -- 功率加
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        set_value(ultra_ScreenID, ultra_Icon_PowerAddSub, 2)
        if ultraStrongerFlag == 0 and ultraPowerGear < 7 then
            ultraPowerGear = ultraPowerGear + 1
            BeepOnce()
        elseif ultraMode ~= 3 then
            BeepTwice()
        end
    elseif control == ultra_Button_WaterDown then  -- 水量减
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        set_value(ultra_ScreenID, ultra_Icon_WaterAddSub, 1)
        if ultraMode == 0 then
            if ultraWaterGear > 1 then
                ultraWaterGear = ultraWaterGear - 1
                BeepOnce()
            else
                BeepTwice()
            end
        else
            if ultraWaterGear > 0 then
                ultraWaterGear = ultraWaterGear - 1
                BeepOnce()
            else
                BeepTwice()
            end
        end

    elseif control == ultra_Button_WaterUp then   -- 水量加
        ultraDataIsChanged = 1
        tempButtonIsTrigger = 1
        set_value(ultra_ScreenID, ultra_Icon_WaterAddSub, 2)
        if ultraWaterGear < 7 then
            ultraWaterGear = ultraWaterGear + 1
            BeepOnce()
        else
            BeepTwice()
        end
    end

    -- 将数据写进参数表
    ultraParamTable[ultraMode+1][1] = ultraStrongerFlag
    ultraParamTable[ultraMode+1][2] = ultraPowerGear
    ultraParamTable[ultraMode+1][3] = ultraWaterGear
    Ultra_RefreshView(0)
    return tempButtonIsTrigger
end

-------------------------------------------------------------------------------
-- name  Ultra_UartEvent_Handler(response)  response: 0待机 1运行
-- note  用户函数.超声模块.串口数据响应
-------------------------------------------------------------------------------
function Ultra_UartEvent_Handler(response)
    local tempDataIsChanged
    -- 本机有数据变更，需主板返回的数据与本机一致
    -- 本机数据无变更，接收主板的数据指令
    if ultraDataIsChanged == 1 then     --判断数据是否有改变
        if ultraMode_Response == ultraMode and ultraStrongerFlag_Response == ultraStrongerFlag and
           ultraPowerGear_Response == ultraPowerGear and ultraWaterGear_Response == ultraWaterGear then
            ultraDataIsChanged = 0
        end
    elseif ultraMode_Response ~= ultraMode or ultraStrongerFlag_Response ~= ultraStrongerFlag or
           ultraPowerGear_Response ~= ultraPowerGear or ultraWaterGear_Response ~= ultraWaterGear then
        BeepOnce()
        tempDataIsChanged = 1
        ultraMode = ultraMode_Response
        ultraStrongerFlag = ultraStrongerFlag_Response
        ultraPowerGear = ultraPowerGear_Response
        ultraWaterGear = ultraWaterGear_Response
        ultraParamTable[ultraMode+1][1] = ultraStrongerFlag
        ultraParamTable[ultraMode+1][2] = ultraPowerGear
        ultraParamTable[ultraMode+1][3] = ultraWaterGear
    end
    Ultra_RefreshView(response)
    return tempDataIsChanged
end

-------------------------------------------------------------------------------
-- name  Ultra_RefreshView(fsmStep)  ultraFsmStep: 0待机 1运行
-- note  用户函数.超声模块.视图更新.从参数表里取出数据
-------------------------------------------------------------------------------
function Ultra_RefreshView(fsmStep)
    local tempMode           -- 用于显示
    local tempStrongerFlag
    local tempPowerGear   
    local tempWaterGear

    if ultraFunSta == FUNSTA_REFUSED then  -- 禁用态
        Ultra_SetButtonEnable(DISABLE)
        return
    end
    if fsmStep == 0 then -- 待机状态 ------------------------------------------
        -- 按钮有效.显示所有图标
        Ultra_SetFunState(FUNSTA_READY)  -- 就绪态
        Ultra_SetButtonEnable(ENABLE)    -- 有效所有按钮    
        if ultraMode ~= 3 then  -- 骨手术 牙周治疗 根管治疗
            -- 隐藏冲洗模式
            -- 显示非冲洗模式
            set_visiable(ultra_ScreenID, ultra_Icon_M3WaterGear, DISABLE)      -- 隐藏冲洗模式的水量挡位条 
            set_visiable(ultra_ScreenID, ultra_Icon_M3Water, DISABLE)          -- 隐藏冲洗模式的水量图标           
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterUp, DISABLE)      -- 隐藏冲洗模式的水量+按钮
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterDown, DISABLE)    -- 隐藏冲洗模式的水量-按钮
            set_visiable(ultra_ScreenID, ultra_Icon_M3WaterNum, DISABLE)       -- 隐藏冲洗模式的水量数字图标

            set_visiable(ultra_ScreenID, ultra_Icon_Stronger, ENABLE)          -- 显示超强图标

            set_visiable(ultra_ScreenID, ultra_Icon_PowerGear, ENABLE)         -- 显示功率挡位条图标
            set_visiable(ultra_ScreenID, ultra_Icon_Tip, ENABLE)               -- 显示工作尖图标
            set_visiable(ultra_ScreenID, ultra_Icon_PowerAddSub, ENABLE)       -- 显示功率+-图标 
            set_visiable(ultra_ScreenID, ultra_Button_PowerUp, ENABLE)         -- 显示功率+按钮           
            set_visiable(ultra_ScreenID, ultra_Button_PowerDown, ENABLE)       -- 显示功率-按钮            
            set_visiable(ultra_ScreenID, ultra_Icon_PowerNum, ENABLE)          -- 显示功率数字图标

            set_visiable(ultra_ScreenID, ultra_Icon_WaterGear, ENABLE)         -- 显示水量挡位条图标
            set_visiable(ultra_ScreenID, ultra_Icon_Water, ENABLE)             -- 显示水量图标
            set_value(ultra_ScreenID, ultra_Icon_Water, 0+(Language*1))        -- 水量图标根据语言显示
            set_visiable(ultra_ScreenID, ultra_Icon_WaterAddSub, ENABLE)       -- 显示水量+-图标  
            set_visiable(ultra_ScreenID, ultra_Button_WaterUp, ENABLE)         -- 显示水量+按钮
            set_visiable(ultra_ScreenID, ultra_Button_WaterDown, ENABLE)       -- 显示水量-按钮
            set_visiable(ultra_ScreenID, ultra_Icon_WaterNum, ENABLE)          -- 显示水量数字图标
        else -- 冲洗模式
            -- 显示冲洗模式
            -- 隐藏非冲洗模式
            set_visiable(ultra_ScreenID, ultra_Icon_M3WaterGear, ENABLE)       -- 显示冲洗模式的水量挡位条 
            set_visiable(ultra_ScreenID, ultra_Icon_M3Water, ENABLE)           -- 显示冲洗模式的水量图标
            set_value(ultra_ScreenID, ultra_Icon_M3Water, 0+(Language*1))        -- 水量图标根据语言显示           
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterUp, ENABLE)       -- 显示冲洗模式的水量+按钮
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterDown, ENABLE)     -- 显示冲洗模式的水量-按钮
            set_visiable(ultra_ScreenID, ultra_Icon_M3WaterNum, ENABLE)        -- 显示冲洗模式的水量数字图标

            set_visiable(ultra_ScreenID, ultra_Icon_Stronger, DISABLE)         -- 隐藏超强图标

            set_visiable(ultra_ScreenID, ultra_Icon_PowerGear, DISABLE)        -- 隐藏功率挡位条图标
            set_visiable(ultra_ScreenID, ultra_Icon_Tip, DISABLE)              -- 隐藏工作尖图标
            set_visiable(ultra_ScreenID, ultra_Icon_PowerAddSub, DISABLE)      -- 隐藏功率+-图标 
            set_visiable(ultra_ScreenID, ultra_Button_PowerUp, DISABLE)        -- 隐藏功率+按钮
            set_visiable(ultra_ScreenID, ultra_Button_PowerDown, DISABLE)      -- 隐藏功率-按钮
            set_visiable(ultra_ScreenID, ultra_Icon_PowerNum, DISABLE)         -- 隐藏功率数字图标

            set_visiable(ultra_ScreenID, ultra_Icon_WaterGear, DISABLE)        -- 隐藏水量挡位条图标
            set_visiable(ultra_ScreenID, ultra_Icon_Water, DISABLE)            -- 隐藏水量图标
            set_visiable(ultra_ScreenID, ultra_Icon_WaterAddSub, DISABLE)      -- 隐藏水量+-图标  
            set_visiable(ultra_ScreenID, ultra_Button_WaterUp, DISABLE)        -- 隐藏水量+按钮
            set_visiable(ultra_ScreenID, ultra_Button_WaterDown, DISABLE)      -- 隐藏水量-按钮
            set_visiable(ultra_ScreenID, ultra_Icon_WaterNum, DISABLE)         -- 隐藏水量数字图标
        end
        -- 从参数表获取
        tempMode = ultraMode                                 -- 超声模式 
        tempStrongerFlag = ultraParamTable[tempMode+1][1]    -- 超强开关
        ultraStrongerFlag = tempStrongerFlag                 -- 超强开关标志位赋值
        tempPowerGear    = ultraParamTable[tempMode+1][2]    -- 功率档位
        tempWaterGear    = ultraParamTable[tempMode+1][3]    -- 水量档位
        set_value(ultra_ScreenID, ultra_Icon_Mode, tempMode+(Language*4)) -- 更新超声模式导航栏
        set_value(ultra_ScreenID, ultra_Icon_Tip, tempMode+(Language*3))  -- 更新工作尖图标       
        set_value(ultra_ScreenID, ultra_Icon_Stronger, ultraStrongerFlag+(Language*2)) -- 更新超强开关标识   

        if ultraMode ~= 3 then   -- 骨手术 牙周治疗 根管治疗
            -- 更新水量档位条与数字
            set_value(ultra_ScreenID, ultra_Icon_WaterGear, tempWaterGear)
            set_value(ultra_ScreenID, ultra_Icon_WaterNum, tempWaterGear)
            -- 更新功率档位条与数字
            if tempStrongerFlag == 1 then
                set_value(ultra_ScreenID, ultra_Icon_PowerGear, 8)             -- 超强开
                set_value(ultra_ScreenID, ultra_Icon_PowerNum, 7)              -- 功率数字为超强
            else
                set_value(ultra_ScreenID, ultra_Icon_PowerGear, tempPowerGear)   -- 超强关
                set_value(ultra_ScreenID, ultra_Icon_PowerNum, tempPowerGear-1)  -- 功率数字
            end
        elseif ultraMode == 3 then -- 冲洗模式
            -- 更新水量档位条与数字            
            set_value(ultra_ScreenID, ultra_Icon_M3WaterGear, tempWaterGear)
            set_value(ultra_ScreenID, ultra_Icon_M3WaterNum, tempWaterGear)
        end

    elseif fsmStep == 1 then -- 超声运行状态 ------------------------------------------
        Ultra_SetFunState(FUNSTA_RUNNING)  -- 运行态
        Ultra_SetButtonEnable(DISABLE)
        if ultraMode ~= 3 then     -- 骨手术 牙周治疗 根管治疗
            set_visiable(ultra_ScreenID, ultra_Icon_PowerAddSub, DISABLE)
            set_visiable(ultra_ScreenID, ultra_Icon_WaterAddSub, DISABLE)
            set_visiable(ultra_ScreenID, ultra_Icon_Stronger, DISABLE)
        elseif ultraMode == 3 then   -- 冲洗模式
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterUp, DISABLE)
            set_visiable(ultra_ScreenID, ultra_Button_M3WaterDown, DISABLE)
        end
    end
end

-------------------------------------------------------------------------------
-- name  Ultra_SetButtonEnable(val)  val = ENABLE / DIAABLE
-- note  用户函数.超声模块.辅助函数.使能/失能所有按钮
-------------------------------------------------------------------------------
function Ultra_SetButtonEnable(val)
    if val ~= ENABLE and val~= DISABLE then
        val = DISABLE
    end
    set_enable(ultra_ScreenID, ultra_Button_Stronger,  val)
    set_enable(ultra_ScreenID, ultra_Button_BoneMode,  val)
    set_enable(ultra_ScreenID, ultra_Button_PeriMode,  val)
    set_enable(ultra_ScreenID, ultra_Button_EndoMode,  val)
    set_enable(ultra_ScreenID, ultra_Button_FlushMode, val)
    set_enable(ultra_ScreenID, ultra_Button_PowerUp,   val)
    set_enable(ultra_ScreenID, ultra_Button_PowerDown, val)
    set_enable(ultra_ScreenID, ultra_Button_WaterUp,   val)
    set_enable(ultra_ScreenID, ultra_Button_WaterDown, val)
    set_enable(ultra_ScreenID, ultra_Button_M3WaterUp,   val)
    set_enable(ultra_ScreenID, ultra_Button_M3WaterDown, val)
end
-------------------------------------------------------------------------------
-- name  Light_Init()
-- note  用户函数.照明灯模块初始化
-------------------------------------------------------------------------------
function Light_Init()
    Light_SetFunState(FUNSTA_READY)
    if lightMode == 1 then
        lightMode = 2
    end
    lightFsmStep = lightMode
    Light_RefreshView(lightFsmStep)
end

-------------------------------------------------------------------------------
-- name  Light_SetFunState(val)  FUNSTA_READY.FUNSTA_RUNNING.FUNSTA_REFUSED
-- note  用户函数.照明灯模块.设定功能模块任务状态
-------------------------------------------------------------------------------
function Light_SetFunState(val)
    lightFunSta = val
end

-------------------------------------------------------------------------------
-- name  Light_ButtonEvent_Handler()
-- note  用户函数.照明灯模块.按钮事件处理
-------------------------------------------------------------------------------
function Light_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    if control == light_Button_Logo then
        BeepOnce()
        lightDataIsChanged = 1
        tempButtonIsTrigger = 1
        if lightMode == 0 then
            lightMode = 2
        elseif lightMode == 2 then
            lightMode = 1
        elseif lightMode == 1 then
            lightMode = 0
        end
    end
    lightFsmStep = lightMode
    Light_RefreshView(lightFsmStep)
    return tempButtonIsTrigger
end

-------------------------------------------------------------------------------
-- name  Light_UartEvent_Handler()
-- note  用户函数.照明灯模块.通讯事件处理
-------------------------------------------------------------------------------
function Light_UartEvent_Handler(response)
    if lightDataIsChanged == 1 then
        if response == lightMode then
            lightDataIsChanged = 0
        end
    elseif lightMode ~= response  then
        lightMode = response
    end
    Light_RefreshView(lightMode)
end

-------------------------------------------------------------------------------
-- name  Light_RefreshView()
-- note  用户函数.照明灯模块.更新视图
-------------------------------------------------------------------------------
function Light_RefreshView(fsmStep)
    if fsmStep == 0 then        -- 关模式
        set_value(light_ScreenID, light_Icon_Logo, 2+(Language*3))
    elseif fsmStep == 1 then    -- 自动模式
        set_value(light_ScreenID, light_Icon_Logo, 0+(Language*3))
    elseif fsmStep == 2 then    -- 开模式
        set_value(light_ScreenID, light_Icon_Logo, 1+(Language*3))
    end

    if lightFunSta == FUNSTA_REFUSED then  -- 禁用态
        set_enable(light_ScreenID, light_Button_Logo, DISABLE)  -- 无效按键
    else
        set_enable(light_ScreenID, light_Button_Logo, ENABLE)   -- 有效按键       
    end

end

-------------------------------------------------------------------------------
-- name  CleanHose_Init()
-- note  用户函数.管路清洗模块.开机初始化
-------------------------------------------------------------------------------
function CleanHose_Init()
    CleanHose_SetFunState(FUNSTA_READY)
    cleanHoseFsmStep = 0
    cleanHoseRun_Request = 0  -- 无请求
    CleanHose_RefreshView(cleanHoseFsmStep)
end

-------------------------------------------------------------------------------
-- name  CleanHose_SetFunState(val)
-- note  用户函数.管路清洗模块.设定功能模块任务状态
-------------------------------------------------------------------------------
function CleanHose_SetFunState(val)
    cleanHoseFunSta = val
end

-------------------------------------------------------------------------------
-- name  CleanHose_ButtonEvent_Handler()
-- note  用户函数.管路清洗模块.按钮事件处理
-------------------------------------------------------------------------------
function CleanHose_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    if control == cleanHose_Button_Logo then  -- 功能图标按钮
        BeepOnce()
        cleanHoseDataIsChanged = 1
        tempButtonIsTrigger = 1
        cleanHoseFsmStep = 1
        CleanHose_RefreshView(cleanHoseFsmStep)
    elseif control == cleanHose_Button_Left then  -- 左按钮
        BeepOnce()
        cleanHoseDataIsChanged = 1
        tempButtonIsTrigger = 1
        cleanHoseRun_Request = 2 -- 请求执行清洗
        cleanHoseTimeCount = CLEAN_HOSE_TIME_MAX
        set_text(cleanHose_ScreenID, cleanHose_Text_Count, cleanHoseTimeCount)         
        start_timer(timerID_CleanHose, 1000, 0, 0)
        cleanHoseFsmStep = 2
        CleanHose_RefreshView(cleanHoseFsmStep)
    elseif control == cleanHose_Button_Mid then   -- 中按钮
        BeepOnce()
        cleanHoseDataIsChanged = 1
        tempButtonIsTrigger = 1
        cleanHoseRun_Request = 1  -- 请求停止清洗 
    --    cleanHoseFsmStep = 0
    --    CleanHose_RefreshView(cleanHoseFsmStep)
    elseif control == cleanHose_Button_Right then -- 右按钮
        BeepOnce()
        cleanHoseDataIsChanged = 1
        tempButtonIsTrigger = 1
        cleanHoseFsmStep = 0
        CleanHose_RefreshView(cleanHoseFsmStep)
    end
    return tempButtonIsTrigger
end

-------------------------------------------------------------------------------
-- name  CleanHose_TimerEvent_Handler()
-- note  库函数.管路清洗模块.定时器事件处理
-------------------------------------------------------------------------------
function CleanHose_TimerEvent_Handler()
    if cleanHoseFsmStep == 2 then
        cleanHoseTimeCount = cleanHoseTimeCount - 1
        set_text(cleanHose_ScreenID, cleanHose_Text_Count, cleanHoseTimeCount)
        if cleanHoseTimeCount == 0 or cleanHoseFsmStep == 0 then
            cleanHoseRun_Request = 1
            cleanHoseFsmStep = 0
            CleanHose_RefreshView(cleanHoseFsmStep)
        end
    else
        cleanHoseTimeCount = CLEAN_HOSE_TIME_MAX
        set_text(cleanHose_ScreenID, cleanHose_Text_Count, cleanHoseTimeCount)        
        stop_timer(timerID_CleanHose)
    end
end

-------------------------------------------------------------------------------
-- name  CleanHose_UartEvent_Handler()
-- note  库函数.管路清洗模块.串口数据处理
-------------------------------------------------------------------------------
function CleanHose_UartEvent_Handler(response)
    -- 防止数据覆盖处理 
    if cleanHoseDataIsChanged == 1 then return end
    -- 禁用态判断
    if cleanHoseFunSta == FUNSTA_REFUSED then
        cleanHoseFsmStep = 0
        CleanHose_RefreshView(cleanHoseFsmStep)
        return
    end
    -- 发出请求停止.对方回应已停止
    if  cleanHoseRun_Request == 1 and response == 0 then
        cleanHoseRun_Request = 0
        cleanHoseFsmStep = 0
    end
    CleanHose_RefreshView(cleanHoseFsmStep)
end

-------------------------------------------------------------------------------
-- name  CleanHose_RefreshView(fsmStep)
-- note  用户函数.管路清洗模块.更新视图
-------------------------------------------------------------------------------
function CleanHose_RefreshView(fsmStep)
    if cleanHoseFunSta == FUNSTA_REFUSED then  -- 禁用态
        CleanHose_ButtonDisable()
        set_value(cleanHose_ScreenID, cleanHose_Icon_Logo, 0+(Language*1))   -- 功能Logo图标状态
        set_visiable(cleanHose_ScreenID, cleanHose_Icon_Pop, DISABLE)        -- 隐藏弹窗
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Count, DISABLE)      -- 隐藏计数文本       
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Sec, DISABLE)        -- 隐藏单位文本      
        return
    end

    if fsmStep == 0 then  -- 待机
        CleanHose_ButtonDisable()
        CleanHose_SetFunState(FUNSTA_READY)
        set_visiable(cleanHose_ScreenID, sys_Icon_Fuzzy, DISABLE)        -- 隐藏灰幕        
        set_enable(cleanHose_ScreenID, cleanHose_Button_Logo, ENABLE)    -- 有效功能Logo按钮
        set_value(cleanHose_ScreenID, cleanHose_Icon_Logo, 0+(Language*1))-- 功能Logo图标状态
        set_visiable(cleanHose_ScreenID, cleanHose_Icon_Pop, DISABLE)    -- 隐藏弹窗
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Count, DISABLE)  -- 隐藏计数文本       
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Sec, DISABLE)    -- 隐藏单位文本

    elseif fsmStep == 1 then -- 弹窗确认
        CleanHose_SetFunState(FUNSTA_RUNNING)
        set_visiable(cleanHose_ScreenID, sys_Icon_Fuzzy, ENABLE)         -- 显示灰幕
        set_enable(cleanHose_ScreenID, cleanHose_Button_Logo, DISABLE)   -- 无效功能Logo按钮
        set_value(cleanHose_ScreenID, cleanHose_Icon_Logo, 0+(Language*1))-- 功能Logo图标状态 
        set_visiable(cleanHose_ScreenID, cleanHose_Icon_Pop, ENABLE)     -- 显示弹窗
        set_value(cleanHose_ScreenID, cleanHose_Icon_Pop, 0+(Language*2))-- 弹窗内容:"继续"or"取消"   
        set_enable(cleanHose_ScreenID, cleanHose_Button_Left, ENABLE)    -- 有效左按钮
        set_enable(cleanHose_ScreenID, cleanHose_Button_Right, ENABLE)   -- 有效右按钮  
    elseif fsmStep == 2 then -- 清洗中     
        CleanHose_ButtonDisable()
        set_enable(cleanHose_ScreenID, cleanHose_Button_Mid, ENABLE)     -- 有效中按钮
        set_value(cleanHose_ScreenID, cleanHose_Icon_Pop, 1+(Language*2))-- 弹窗内容:正在清洗      
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Count, ENABLE)   -- 显示计数文本       
        set_visiable(cleanHose_ScreenID, cleanHose_Text_Sec, ENABLE)     -- 显示单位文本        
    end   
end

-------------------------------------------------------------------------------
-- name  CleanHose_SetButtonEnable()
-- note  用户函数.管路清洗模块.无效所有按钮
-------------------------------------------------------------------------------
function CleanHose_ButtonDisable()
    set_enable(cleanHose_ScreenID, cleanHose_Button_Logo, DISABLE)
    set_enable(cleanHose_ScreenID, cleanHose_Button_Left, DISABLE)
    set_enable(cleanHose_ScreenID, cleanHose_Button_Mid, DISABLE)
    set_enable(cleanHose_ScreenID, cleanHose_Button_Right, DISABLE)
end

-------------------------------------------------------------------------------
-- name  Ble_Init()
-- note  用户函数.蓝牙模块.初始化
-------------------------------------------------------------------------------
function Ble_Init()
    Ble_SetFunState(FUNSTA_READY)
    bleFsmStep = 0
    Ble_RefreshView(bleFsmStep)
end

-------------------------------------------------------------------------------
-- name  Ble_SetFunState(val)  FUNSTA_READY / FUNSTA_RUNNING / FUNSTA_REFUSED
-- note  用户函数.蓝牙模块.设定任务状态
-------------------------------------------------------------------------------
function Ble_SetFunState(val)
    bleFunSta = val
end

-------------------------------------------------------------------------------
-- name  Ble_Button_Disable() 
-- note  用户函数.蓝牙模块.无效所有按钮
-------------------------------------------------------------------------------
function Ble_Button_Disable()
    set_enable(ble_ScreenID, ble_Button_Logo, DISABLE)
    set_enable(ble_ScreenID, ble_Button_Left, DISABLE)
    set_enable(ble_ScreenID, ble_Button_Mid, DISABLE)
    set_enable(ble_ScreenID, ble_Button_Right, DISABLE)
end

-------------------------------------------------------------------------------
-- name  Ble_TimerEvent_Handler()
-- note  用户函数.蓝牙模块.按钮事件处理 500ms
-------------------------------------------------------------------------------
function Ble_TimerEvent_Handler()
    -- 发起配对.蓝牙图标动画过渡
    if bleFsmStep == 2 then
        bleTimeCount = bleTimeCount + 1
        set_value(ble_ScreenID, ble_Icon_Logo, (bleTimeCount%3)+1)
        if bleTimeCount > BLE_PAIRING_TIMEOUT*2 then
            stop_timer(timerID_Ble)
            bleTimeCount = 0
            bleRun_Request = 0
            bleFsmStep = 3
            stop_timer(timerID_BlePairedDelay)
            Ble_RefreshView(bleFsmStep)  -- 配对超时
        end
    elseif bleFsmStep == 7 then
        bleTimeCount = bleTimeCount + 1
        if bleTimeCount > BLE_STOP_PAIRING_TIMEOUT*2 then
            bleFsmStep = 0
            bleRun_Request = 0
            Ble_RefreshView(bleFsmStep)
        end
    elseif bleFsmStep == 6 then
        bleTimeCount = bleTimeCount + 1
        if bleTimeCount > BLE_UNPAIRING_TIMEOUT*2 then
            bleRun_Request = 0
            bleFsmStep = 0
            Ble_RefreshView(bleFsmStep)
        end
    else
        stop_timer(timerID_Ble)
        bleTimeCount = 0
    end
end

-------------------------------------------------------------------------------
-- name  Ble_TimerEvent2_Handler()
-- note  用户函数.蓝牙模块.配对成功延时
-------------------------------------------------------------------------------
function Ble_TimerEvent2_Handler()
    belRun_PairedSucceed = 1
    stop_timer(timerID_BlePairedDelay)
end

-------------------------------------------------------------------------------
-- name  Ble_ButtonEvent_Handler(control)
-- note  用户函数.蓝牙模块.按钮事件处理
-------------------------------------------------------------------------------
function Ble_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    -- 图标按钮
    if control == ble_Button_Logo then
        BeepOnce()
        bleDataIsChanged = 1
        tempButtonIsTrigger = 1
        if bleFsmStep == 0 then  
            bleFsmStep = 1     
            Ble_RefreshView(bleFsmStep)  -- 0未配对 --> 1配对询问
        elseif bleFsmStep == 4 then
            bleFsmStep = 5
            Ble_RefreshView(bleFsmStep)  -- 4配对成功 --> 5取消配对询问            
        end
--[[ 左按钮 ]]--   
    elseif control == ble_Button_Left then
        BeepOnce()
        bleDataIsChanged = 1
        tempButtonIsTrigger = 1
        if bleFsmStep == 1 then  
            bleRun_Request = 1
            bleFsmStep = 2
            Ble_RefreshView(bleFsmStep) -- 1未配对 --> 2正在配对ing
        elseif bleFsmStep == 3 then 
            bleRun_Request = 1
            bleFsmStep = 2
            Ble_RefreshView(bleFsmStep) -- 3未配对超时 --> 2正在配对ing
        elseif bleFsmStep == 5 then
            bleRun_Request = 2
            bleFsmStep = 6
            Ble_RefreshView(bleFsmStep) -- 5取消配对询问 --> 6正在取消配对ing         
        end
--[[ 中按钮 ]]--     
    elseif control == ble_Button_Mid then
        BeepOnce()
        bleDataIsChanged = 1
        tempButtonIsTrigger = 1
        bleRun_Request = 3
        bleTimeCount = 0 -- 重新计数
        bleFsmStep = 7
        Ble_RefreshView(bleFsmStep) -- 2正在配对ing --> 7中止配对ing
--[[ 右按钮 ]]--      
    elseif control == ble_Button_Right then
        BeepOnce()
        bleDataIsChanged = 1
        tempButtonIsTrigger = 1
        if bleFsmStep == 1 or bleFsmStep == 3 then
            bleRun_Request = 0
            bleFsmStep = 0
            Ble_RefreshView(bleFsmStep)
        elseif bleFsmStep == 5 then
            bleRun_Request = 0
            bleFsmStep = 4
            Ble_RefreshView(bleFsmStep)
        end
    end
    return tempButtonIsTrigger
end
-------------------------------------------------------------------------------
-- name  Ble_UartEvent_Handler(response)
-- note  用户函数.蓝牙模块.串口接收事件处理
-------------------------------------------------------------------------------
function Ble_UartEvent_Handler(response)
     
    if bleDataIsChanged == 1 then return end -- 防止数据覆盖处理
    if bleFunSta == FUNSTA_REFUSED then return end  -- 禁用态
    -- 未配对 --> 已配对
    if bleFsmStep == 0 and (response == 1 or response == 2) then
        bleFsmStep = 4
        Ble_RefreshView(bleFsmStep)
    end
    -- 已配对 --> 未配对
    if bleFsmStep == 4 and response == 0 then
        bleFsmStep = 0
        Ble_RefreshView(bleFsmStep)
    end
    -- 中止配对成功
    if bleFsmStep == 7 and response == 3 and bleTimeCount > 2 then
        bleRun_Request = 0
        bleFsmStep = 0
        BeepOnce()
        Ble_RefreshView(bleFsmStep)
    end
    -- 配对成功
    if bleFsmStep == 2 and response == 2 and bleTimeCount > 2 then
        bleRun_Request = 0
        bleFsmStep = 4
        beep(300)
        Ble_RefreshView(bleFsmStep)
    end
    -- 取消配对成功
    if bleFsmStep == 6 and response == 0 and bleTimeCount > 2 then
        bleRun_Request = 0
        bleFsmStep = 0
        BeepOnce()
        Ble_RefreshView(bleFsmStep)
    end

end
-------------------------------------------------------------------------------
-- name  Ble_RefreshView(fsmStep) bleFsmStep
-- note  用户函数.蓝牙模块.更新视图
-------------------------------------------------------------------------------
function Ble_RefreshView(fsmStep)
    if bleFunSta == FUNSTA_REFUSED then
        Ble_Button_Disable()                                  -- 无效所有按钮 
        set_visiable(ble_ScreenID, ble_Icon_Pop, DISABLE)     -- 隐藏弹窗 
        return
    end
    if fsmStep == 0  then  -- 0 未配对
        Ble_SetFunState(FUNSTA_READY)
        Ble_Button_Disable()                                  -- 无效所有按钮
        set_enable(ble_ScreenID, ble_Button_Logo, ENABLE)     -- 有效功能按钮
        set_value(ble_ScreenID, ble_Icon_Logo, 0+(Language*5))-- 灰色图标
        set_visiable(ble_ScreenID, ble_Icon_Pop, DISABLE)     -- 隐藏弹窗 
    elseif fsmStep == 1 then  -- 1 配对询问
        Ble_SetFunState(FUNSTA_RUNNING)
        set_visiable(ble_ScreenID, sys_Icon_Fuzzy2, ENABLE)   -- 显示灰幕         
        Ble_Button_Disable()                                  -- 无效所有按钮
        set_enable(ble_ScreenID, ble_Button_Left, ENABLE)     -- 有效左按钮"继续"
        set_enable(ble_ScreenID, ble_Button_Right, ENABLE)    -- 有效右按钮"取消"
        set_visiable(ble_ScreenID, ble_Icon_Pop, ENABLE)      -- 显示弹窗
        set_value(ble_ScreenID, ble_Icon_Pop, 0+(Language*6)) -- 弹窗内容:踩住加速踏板直至配对完成
    elseif fsmStep == 2 then  -- 2 发起配对
        Ble_Button_Disable()                                  -- 无效所有按钮        
        set_enable(ble_ScreenID, ble_Button_Mid, ENABLE)      -- 有效中按钮"取消" 
        set_value(ble_ScreenID, ble_Icon_Pop, 1+(Language*6)) -- 弹窗内容:正在配对...
        start_timer(timerID_Ble, 500, 0, 0)                   -- 计时
    elseif fsmStep == 3 then  -- 3 配对超时        
        Ble_Button_Disable()                                  -- 无效所有按钮   
        set_enable(ble_ScreenID, ble_Button_Left, ENABLE)     -- 有效左按钮"继续"
        set_enable(ble_ScreenID, ble_Button_Right, ENABLE)    -- 有效右按钮"取消"   
        set_value(ble_ScreenID, ble_Icon_Logo, 0+(Language*5))-- 灰色图标
        set_value(ble_ScreenID, ble_Icon_Pop, 2+(Language*6)) -- 弹窗内容:配对失败!
    elseif fsmStep == 4 then  -- 4 配对成功
        Ble_SetFunState(FUNSTA_READY)
        Ble_Button_Disable()                                  -- 无效所有按钮
        set_enable(ble_ScreenID, ble_Button_Logo, ENABLE)     -- 有效功能按钮
        set_value(ble_ScreenID, ble_Icon_Logo, 4+(Language*5))-- 蓝色图标        
        set_visiable(ble_ScreenID, ble_Icon_Pop, DISABLE)     -- 隐藏弹窗
    elseif fsmStep == 5 then  -- 5 取消配对询问
        Ble_SetFunState(FUNSTA_RUNNING)
        set_visiable(ble_ScreenID, sys_Icon_Fuzzy2, ENABLE)   -- 显示灰幕           
        Ble_Button_Disable()                                  -- 无效所有按钮        
        set_enable(ble_ScreenID, ble_Button_Left, ENABLE)     -- 有效左按钮"继续"
        set_enable(ble_ScreenID, ble_Button_Right, ENABLE)    -- 有效右按钮"取消"
        set_visiable(ble_ScreenID, ble_Icon_Pop, ENABLE)      -- 显示弹窗        
        set_value(ble_ScreenID, ble_Icon_Pop, 3+(Language*6)) -- 弹窗内容:此操作将取消与主机的配对 
    elseif fsmStep == 6 then  -- 6 发起取消配对
        Ble_Button_Disable()                                  -- 无效所有按钮        
        set_value(ble_ScreenID, ble_Icon_Pop, 5+(Language*6)) -- 弹窗内容:正在取消配对ing  
        start_timer(timerID_Ble, 500, 0, 0)                   -- 计时        
    elseif fsmStep == 7 then  -- 7 发起中止配对      
        Ble_Button_Disable()                                  -- 无效所有按钮      
        set_value(ble_ScreenID, ble_Icon_Logo, 0+(Language*5))-- 灰色图标
        set_value(ble_ScreenID, ble_Icon_Pop, 4+(Language*6)) -- 弹窗内容:正在中止蓝牙配对  
        start_timer(timerID_Ble, 500, 0, 0)                   -- 计时        
    end
end

-------------------------------------------------------------------------------
-- name  SysSettings_Init()
-- note  用户函数.设置界面系统参数.初始化
-------------------------------------------------------------------------------
function SysSettings_Init()
    set_enable(screenID_Settings, sound_Button_Switch, ENABLE)
    set_visiable(screenID_Settings, sound_Icon_Switch, ENABLE)
    set_value(screenID_Settings, sound_Icon_Switch, soundSwitch)

    set_enable(screenID_Settings, brightness_Button_Level, ENABLE)
    set_visiable(screenID_Settings, brightness_Icon_Level, ENABLE)
    set_value(screenID_Settings, brightness_Icon_Level, brightnessLevel)
    if brightnessLevel == 0 then
        set_backlight(50)
    elseif brightnessLevel == 1 then
        set_backlight(75)
    elseif brightnessLevel == 2 then
        set_backlight(100)
    end
end

-------------------------------------------------------------------------------
-- name  SysSettings_ButtonEvent_Handler()
-- note  用户函数.设置界面系统参数.按钮事件
-------------------------------------------------------------------------------
function SysSettings_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    if control == sound_Button_Switch then
        tempButtonIsTrigger = 1
        if soundSwitch == 0 then
            soundSwitch = 1
            BeepOnce()
        elseif soundSwitch == 1 then
            soundSwitch = 0
        end
        set_value(screenID_Settings, sound_Icon_Switch, soundSwitch)
        return tempButtonIsTrigger
    elseif control == brightness_Button_Level then
        BeepOnce()
        tempButtonIsTrigger = 1
        if brightnessLevel == 0 then
            brightnessLevel = 1
            set_backlight(75)
        elseif brightnessLevel == 1 then
            brightnessLevel = 2
            set_backlight(100)
        elseif brightnessLevel == 2 then
            brightnessLevel = 0
            set_backlight(50)
        end
        set_value(screenID_Settings, brightness_Icon_Level, brightnessLevel)
        return tempButtonIsTrigger
    end
end

-------------------------------------------------------------------------------
-- name  Restore_Init()
-- note  用户函数.恢复出厂设置模块.初始化
-------------------------------------------------------------------------------
function Restore_Init()
    Restore_SetFunState(FUNSTA_READY)
    restoreRun_Request = 0
    restoreFsmStep = 0
    Restore_RefreshView(restoreFsmStep)
end

-------------------------------------------------------------------------------
-- name  Restore_SetFunState()
-- note  用户函数.恢复出厂设置模块.设置任务状态
-------------------------------------------------------------------------------
function Restore_SetFunState(val)
    restoreFunSta = val
end

-------------------------------------------------------------------------------
-- name  Restore_ButtonEvent_Handler()
-- note  用户函数.恢复出厂设置模块.按钮事件
-------------------------------------------------------------------------------
function Restore_ButtonEvent_Handler(control)
    local tempButtonIsTrigger = 0
    if control == restore_Button_Logo then
        BeepOnce()
        restoreDataIsChanged = 1
        tempButtonIsTrigger = 1
        restoreRun_Request = 0
        restoreFsmStep = 1
        Restore_RefreshView(restoreFsmStep)
    elseif control == restore_Button_Left then
        -- BeepOnce()
        restoreDataIsChanged = 1
        tempButtonIsTrigger = 1
        restoreRun_Request = 1
        -- 恢复出厂设置处理
        Restore_Action()
        restoreFsmStep = 2
        Restore_RefreshView(restoreFsmStep)
    elseif control == restore_Button_Right then
        BeepOnce()
        restoreDataIsChanged = 1
        tempButtonIsTrigger = 1
        restoreFsmStep = 0
        Restore_RefreshView(restoreFsmStep)
    end
    return tempButtonIsTrigger
end

-------------------------------------------------------------------------------
-- name  Restore_UartEvent_Handler()
-- note  用户函数.恢复出厂设置模块.串口数据处理
-------------------------------------------------------------------------------
function Restore_UartEvent_Handler(response)
    -- 防覆盖处理
    if restoreDataIsChanged == 1 then return end
    -- 禁用态判断
    if restoreFunSta == FUNSTA_REFUSED then
        restoreFsmStep = 0
        Restore_RefreshView(restoreFsmStep)
        return
    end
    -- 主机执行恢复出厂设置完成
    if restoreRun_Request == 1 and response == 1 then
        restoreRun_Request = 0
        restoreFsmStep = 0
        beep(300)
        set_visiable(screenID_Settings, sys_Icon_Fuzzy2, DISABLE)
        change_screen(screenID_Main)
    end
    Restore_RefreshView(restoreFsmStep)
end

-------------------------------------------------------------------------------
-- name  Restore_RefreshView(fsmStep)
-- note  用户函数.恢复出厂设置模块.更新视图
-------------------------------------------------------------------------------
function Restore_RefreshView(fsmStep)
    if restoreFunSta == FUNSTA_REFUSED then
        set_visiable(restore_ScreenID, restore_Icon_Pop, DISABLE)   -- 隐藏弹窗
        set_enable(restore_ScreenID, restore_Button_Logo, DISABLE)  -- 无效功能按钮
        set_enable(restore_ScreenID, restore_Button_Left, DISABLE)  -- 无效左按钮
        set_enable(restore_ScreenID, restore_Button_Right, DISABLE) -- 无效右按钮
        return
    end
    if fsmStep == 0 then  -- 无动作
        Restore_SetFunState(FUNSTA_READY)
        set_visiable(restore_ScreenID, restore_Icon_Pop, DISABLE)   -- 隐藏弹窗
        set_enable(restore_ScreenID, restore_Button_Logo, ENABLE)   -- 有效功能按钮
        set_value(restore_ScreenID, restore_Button_Icon, 0+(Language*5))-- 复位图标根据语言显示
        set_enable(restore_ScreenID, restore_Button_Left, DISABLE)  -- 无效左按钮
        set_enable(restore_ScreenID, restore_Button_Right, DISABLE) -- 无效右按钮
    elseif fsmStep == 1 then   -- 弹窗询问 
        Restore_SetFunState(FUNSTA_RUNNING)
        set_visiable(restore_ScreenID, sys_Icon_Fuzzy2, ENABLE)     -- 显示灰幕         
        set_visiable(restore_ScreenID, restore_Icon_Pop, ENABLE)    -- 显示弹窗
        set_value(restore_ScreenID, restore_Icon_Pop, 0+(Language*1))-- 弹窗内容:确认?
        set_enable(restore_ScreenID, restore_Button_Logo, DISABLE)  -- 无效功能按钮
        set_enable(restore_ScreenID, restore_Button_Left, ENABLE)   -- 有效左按钮
        set_enable(restore_ScreenID, restore_Button_Right, ENABLE)  -- 有效右按钮
    elseif fsmStep == 2 then   -- 执行中
        Restore_SetFunState(FUNSTA_RUNNING)
        set_visiable(restore_ScreenID, restore_Icon_Pop, ENABLE)    -- 显示弹窗
        set_value(restore_ScreenID, restore_Icon_Pop, 0+(Language*1))-- 弹窗内容:确认?
        set_enable(restore_ScreenID, restore_Button_Logo, DISABLE)  -- 无效功能按钮        
        set_enable(restore_ScreenID, restore_Button_Left, DISABLE)  -- 无效左按钮
        set_enable(restore_ScreenID, restore_Button_Right, DISABLE) -- 无效右按钮
    end
end


-------------------------------------------------------------------------------
-- name  Restore_Action(fsmStep)
-- note  用户函数.恢复出厂设置模块.执行恢复出厂设置
-------------------------------------------------------------------------------
function Restore_Action()
    ultraParamTable[1][1] = 0    -- 骨手术   超强标志
    ultraParamTable[1][2] = 1    -- 骨手术   功率档位
    ultraParamTable[1][3] = 1    -- 骨手术   水量档位
    ultraParamTable[2][1] = 0    -- 牙周治疗 超强标志
    ultraParamTable[2][2] = 1    -- 牙周治疗 功率档位 
    ultraParamTable[2][3] = 1    -- 牙周治疗 水量档位  
    ultraParamTable[3][1] = 0    -- 根管治疗 超强标志   
    ultraParamTable[3][2] = 1    -- 根管治疗 功率档位   
    ultraParamTable[3][3] = 1    -- 根管治疗 水量档位   
    ultraParamTable[4][1] = 0    -- 冲洗     超强标志 固定为0 
    ultraParamTable[4][2] = 0    -- 冲洗     功率档位 固定为0 
    ultraParamTable[4][3] = 1    -- 冲洗     水量档位  
    ultraMode = 0                -- 超声模式
    ultraStrongerFlag = 0        -- 超强开关  
    ultraPowerGear = 1           -- 超声功率档位
    ultraWaterGear = 1           -- 超声水量档位
    soundSwitch = 1
    set_value(screenID_Settings, sound_Icon_Switch, soundSwitch)
    brightnessLevel = 2
    set_backlight(100)
    set_value(screenID_Settings, brightness_Icon_Level, brightnessLevel)
    lightMode = 2
    Ultra_RefreshView(0)
    Flash_Write()
end



--------------------------------------------------------------------------------------------
-- name  Flash_Write()
-- note  库函数.将flashWriteBuffer写进Flash
--------------------------------------------------------------------------------------------
function Flash_Write()
    flashWriteBuffer[1]  = ultraParamTable[1][1]    -- 骨手术   超强标志
    flashWriteBuffer[2]  = ultraParamTable[1][2]    -- 骨手术   功率档位
    flashWriteBuffer[3]  = ultraParamTable[1][3]    -- 骨手术   水量档位
    flashWriteBuffer[4]  = ultraParamTable[2][1]    -- 牙周治疗 超强标志
    flashWriteBuffer[5]  = ultraParamTable[2][2]    -- 牙周治疗 功率档位 
    flashWriteBuffer[6]  = ultraParamTable[2][3]    -- 牙周治疗 水量档位  
    flashWriteBuffer[7]  = ultraParamTable[3][1]    -- 根管治疗 超强标志   
    flashWriteBuffer[8]  = ultraParamTable[3][2]    -- 根管治疗 功率档位   
    flashWriteBuffer[9]  = ultraParamTable[3][3]    -- 根管治疗 水量档位   
    flashWriteBuffer[10] = ultraParamTable[4][1]    -- 冲洗     超强标志 固定为0 
    flashWriteBuffer[11] = ultraParamTable[4][2]    -- 冲洗     功率档位 固定为0 
    flashWriteBuffer[12] = ultraParamTable[4][3]    -- 冲洗     水量档位  
    flashWriteBuffer[13] = ultraMode                -- 超声模式
    flashWriteBuffer[14] = ultraStrongerFlag        -- 超强开关  
    flashWriteBuffer[15] = ultraPowerGear           -- 超声功率档位
    flashWriteBuffer[16] = ultraWaterGear           -- 超声水量档位
    flashWriteBuffer[17] = lightMode                -- 照明灯模式
    flashWriteBuffer[18] = soundSwitch              -- 音效开关
    flashWriteBuffer[19] = brightnessLevel          -- 屏幕亮度等级
    flashWriteBuffer[20] = blePairedFlag_WriteFlash -- 蓝牙配对状态记忆
    flashWriteBuffer[21] = Language                 -- 语言记忆 0:中文 1:英文

    write_flash(1, flashWriteBuffer)                -- 第一个参数为写flash的起始地址.第二个为写入的数据
end

--------------------------------------------------------------------------------------------
-- name  Flash_Read()
-- note  库函数.读出Flash到flashReadBuffer
--------------------------------------------------------------------------------------------
function Flash_Read()
    flashReadBuffer = read_flash(1, 22)

    ultraParamTable[1][1] = flashReadBuffer[1]    -- 骨手术   超强标志
    if ultraParamTable[1][1] ~= 0 and ultraParamTable[1][1] ~= 1 then
        ultraParamTable[1][1] =  0
    end

    ultraParamTable[1][2] = flashReadBuffer[2]    -- 骨手术   功率档位
    if ultraParamTable[1][2] < 1 or ultraParamTable[1][2] > 7 then
        ultraParamTable[1][2] =  3
    end

    ultraParamTable[1][3] = flashReadBuffer[3]    -- 骨手术   水量档位
    if ultraParamTable[1][3] < 1 or ultraParamTable[1][3] > 7 then
        ultraParamTable[1][3] =  3
    end   

    ultraParamTable[2][1] = flashReadBuffer[4]    -- 牙周治疗 超强标志
    if ultraParamTable[2][1] ~= 0 and ultraParamTable[2][1] ~= 1 then
        ultraParamTable[2][1] =  0
    end

    ultraParamTable[2][2] = flashReadBuffer[5]    -- 牙周治疗 功率档位 
    if ultraParamTable[2][2] < 1 or ultraParamTable[2][2] > 7 then
        ultraParamTable[2][2] =  3
    end

    ultraParamTable[2][3] = flashReadBuffer[6]    -- 牙周治疗 水量档位  
    if ultraParamTable[2][3] < 1 or ultraParamTable[2][3] > 7 then
        ultraParamTable[2][3] =  3
    end
    
    ultraParamTable[3][1] = flashReadBuffer[7]    -- 根管治疗 超强标志 
    if ultraParamTable[3][1] ~= 0 and ultraParamTable[3][1] ~= 1 then
        ultraParamTable[3][1] =  0
    end
    
    ultraParamTable[3][2] = flashReadBuffer[8]    -- 根管治疗 功率档位  
    if ultraParamTable[3][2] < 1 or ultraParamTable[3][2] > 7 then
        ultraParamTable[3][2] =  3
    end

    ultraParamTable[3][3] = flashReadBuffer[9]    -- 根管治疗 水量档位   
    if ultraParamTable[3][3] < 1 or ultraParamTable[3][3] > 7 then
        ultraParamTable[3][3] =  3
    end    

    ultraParamTable[4][1] = flashReadBuffer[10]   -- 冲洗     超强标志 固定为0 
    if ultraParamTable[4][1] ~= 0 then
        ultraParamTable[4][1] =  0
    end

    ultraParamTable[4][2] = flashReadBuffer[11]   -- 冲洗     功率档位 固定为0 
    if ultraParamTable[4][2] ~= 0 then
        ultraParamTable[4][2] =  0
    end

    ultraParamTable[4][3] = flashReadBuffer[12]   -- 冲洗     水量档位  
    if ultraParamTable[4][3] < 1 or ultraParamTable[4][3] > 7 then
        ultraParamTable[4][3] =  3
    end

    ultraMode             = flashReadBuffer[13]   -- 超声模式
    if ultraMode < 0 or ultraMode > 3 then
        ultraMode = 0
    end

    ultraStrongerFlag     = flashReadBuffer[14]   -- 超强开关  
    if ultraStrongerFlag ~= 0 or ultraStrongerFlag ~= 1 then
        ultraStrongerFlag = 0
    end    

    ultraPowerGear        = flashReadBuffer[15]   -- 超声功率档位
    if ultraPowerGear < 1 or ultraPowerGear > 7 then
        ultraPowerGear =  3
    end   

    ultraWaterGear        = flashReadBuffer[16]   -- 超声水量档位
    if ultraWaterGear < 0 or ultraWaterGear > 7 then
        ultraWaterGear =  3
    end

    lightMode             = flashReadBuffer[17]   -- 照明灯模式 012
    if lightMode < 1 or lightMode > 2 then
        lightMode =  2
    end

    soundSwitch           = flashReadBuffer[18]   -- 音效开关 01
    if soundSwitch ~= 0 and soundSwitch ~= 1 then
        soundSwitch = 0
    end

    brightnessLevel       = flashReadBuffer[19]   -- 屏幕亮度等级 012
    if brightnessLevel < 0 or brightnessLevel > 2  then
        brightnessLevel = 0
    end

    blePairedFlag_ReadFlash = flashReadBuffer[20]   -- 蓝牙配对状态记忆
    if blePairedFlag_ReadFlash ~= 0 and blePairedFlag_ReadFlash ~= 1  then
        blePairedFlag_ReadFlash = 0
    end

    Language = flashReadBuffer[21]   -- 语言选择
    if Language ~= 0 and Language ~= 1 then
        Language = 0
    end
end


------------------------------------------------------------------------------
-- name : BeepOnce()
-- note : 用户函数.蜂鸣器响一次                                        2024-11-21
-------------------------------------------------------------------------------
function BeepOnce()
    if soundSwitch == 1 then
        beep(50)
    end
end

------------------------------------------------------------------------------
-- name : BeepTwice()
-- note : 用户函数.蜂鸣器响两次.用于按键无效音                          2024-11-21
-------------------------------------------------------------------------------
function BeepTwice()
    if soundSwitch == 1 then
        -- 按键音效定时器.间隔时间50ms.计数方向增.重复次数2
        start_timer(timerID_ButtonSound, 50, 0, 2)
    end
end