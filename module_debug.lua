---@diagnostic disable: lowercase-global, undefined-global

-------------------- [[  调试业务 Dbg   ]] --------------------
-- 页码ID配置
--screenID_Monitor = 4
-- 控件ID配置
dbg_Button_Left = 16             -- 按钮.调试入口左按钮
dbg_Button_Right = 41            -- 按钮.调试入口右按钮
dbg_Button_Return = 47           -- 按钮.返回主界面
dbg_Text_MainLog = 23            -- 文本.主页面记录
dbg_Text_SettingsLog = 19        -- 文本.设置页面记录
-- 宏开关
dbgSwitch = 0                   -- 调试信息显示开关.0隐藏 1显示
-- 变量
dbgTxRxSelfCnt = 0               -- 模拟自收发计数  
dbgInterMonitorCount = 0         -- 进入监控界面计数
dbgMonitorNextButton = 0         -- 下一个s

--[[ 函数
function Dbg_Init()
function Dbg_Show()
function Dbg_ButtonEvent_Handler(screen, control, value)
function Dbg_TimerEvent_Handler()
function Dbg_TxRxSelf_TimerEvent_Handler()
function Dbg_AnalogTxRxSelf()
--]]

-------------------------------------------------------------------------------
-- name  Dbg_Init()
-- note  用户函数.调试模块初始化
-------------------------------------------------------------------------------
function Dbg_Init()
    set_visiable(screenID_Main, dbg_Text_MainLog, DISABLE)
    set_visiable(screenID_Settings, dbg_Text_SettingsLog, DISABLE)
    start_timer(timerID_TxRxSelf, 100, 0, 0)  -- 模拟收发检测定时器    
 
    -- 老化测试页面
    set_back_color(dbgAging_ScreenID, dbgAging_Text_Switch, 0x07E0)

    -- 超声测试界面
    dbgUltraSetPowerDuty = 12
    dbgUltraSetWaterRpm = 30
    dbgUltraSetVbus = get_value(dbgUltra_ScreenID, dbgUltra_Slider_Vbus);
    set_text(dbgUltra_ScreenID, dbgUltra_Text_Vbus, "电压V:  "..dbgUltraSetVbus)
end


-------------------------------------------------------------------------------
-- name  Dbg_ButtonEvent_Handler(screen, control, value)
-- note  用户函数.调试业务.按钮事件
-------------------------------------------------------------------------------
function Dbg_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0

    -- 参数监控
    tempRet = DbgMonitor_ButtonEvent_Handler(screen, control, value)
    if tempRet == 1 then return tempRet end

    -- 老化测试
    tempRet = DbgAging_ButtonEvent_Handler(screen, control, value)
    if tempRet == 1 then return tempRet end

    -- 水泵测试    
    tempRet = DbgPump_ButtonEvent_Handler(screen, control, value)
    if tempRet == 1 then return tempRet end

    -- 超声测试  
    tempRet = DbgUltra_ButtonEvent_Handler(screen, control, value)
    if tempRet == 1 then return tempRet end
    
    -- 整机参数
    tempRet = DbgSysParam_ButtonEvent_Handler(screen, control, value)
    if tempRet == 1 then return tempRet end

end


-------------------- [[  调试业务--参数监控 DbgMonitor   ]] --------------------
dbgMon_ScreenID = screenID_Monitor           -- 页码.参数监控的页码
dbgMon_Button_JumpToDbgAging = 54            -- 按钮.跳转到老化测试
dbgMon_Button_JumpToDbgPump = 55             -- 按钮.跳转到水泵测试
dbgMon_Button_JumpToDbgUltra = 56            -- 按钮.跳转到超声测试
dbgMon_Button_JumpToDbgSysParam = 57         -- 按钮.跳转到整机参数
dbgMon_Button_JumpToMain = 47                -- 按钮.跳转到主界面
dgbMon_Text_UltraFreq = 16                   -- 文本.超声频率
dbgMon_Text_UltraIAD = 17                    -- 文本.超声电流
dbgMon_Text_UltraVbus_mV = 18                -- 文本.超声电压
dbgMon_Text_ErrorCode = 22                   -- 文本.错误代码
dbgMon_Text_UltraMode = 20                   -- 文本.超声模式
dbgMon_Text_UltraStronger = 21               -- 文本.超强开关
dbgMon_Text_UltraPowerGear = 19              -- 文本.功率档位
dbgMon_Text_UltraWaterGear = 23              -- 文本.水量档位
dbgMon_Text_UltraDuty = 24                   -- 文本.超声占空比
dbgMon_Text_UltraRpm = 25                    -- 文本.超声水量转速

--[[ 函数
function DbgMonitor_Show()
function DbgMonitor_ButtonEvent_Handler(screen, control, value)
function DbgMonitor_UartEvent_Handler()
function RxMsg06_DbgMonitor_Handler(packet)
--]]

-------------------------------------------------------------------------------
-- name  DbgMonitor_ButtonEvent_Handler(control, value)
-- note  用户函数.调试业务.参数监控按钮事件
-------------------------------------------------------------------------------
function DbgMonitor_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    if screen ~= dbgMon_ScreenID then
        return tempRet
    end
    if control ==  dbgMon_Button_JumpToDbgAging and value == 1 then
        change_screen(dbgAging_ScreenID)  -- 跳转到老化测试
        tempRet = 1
    elseif control ==  dbgMon_Button_JumpToDbgPump and value == 1 then
        change_screen(dbgPump_ScreenID)   -- 跳转到水泵测试
        tempRet = 1
    elseif control ==  dbgMon_Button_JumpToDbgUltra and value == 1 then
        change_screen(dbgUltra_ScreenID)   -- 跳转到超声测试
        tempRet = 1
    elseif control ==  dbgMon_Button_JumpToDbgSysParam and value == 1 then
        change_screen(dbgSysParam_ScreenID)  -- 跳转到整机参数
        tempRet = 1
    elseif control ==  dbgMon_Button_JumpToMain and value == 1 then
        change_screen(screenID_Main)          -- 跳转到主界面
        tempRet = 1
    end
    return tempRet
end


-------------------------------------------------------------------------------
-- name  RxMsg06_DbgMonitor_Handler(packet)
-- note  用户函数.调试模式.监控参数
-------------------------------------------------------------------------------
function RxMsg06_DbgMonitor_Handler(packet)
    local ultraFreq
    local ultraCurrentAD
    local ultraVbus_mV
    local modeString
    local strongerString

    ultraFreq = packet[UART_FRAME_PLD_INDEX] *256 + packet[UART_FRAME_PLD_INDEX+1]
    ultraCurrentAD = packet[UART_FRAME_PLD_INDEX+2] *256 + packet[UART_FRAME_PLD_INDEX+3]
    ultraVbus_mV = packet[UART_FRAME_PLD_INDEX+4] *256 + packet[UART_FRAME_PLD_INDEX+5]+0.001

    if ultraMode == 0 then
        modeString = "骨手术"
    elseif ultraMode == 1 then
        modeString = "牙周"
    elseif ultraMode == 2 then
        modeString = "根管"
    elseif ultraMode == 3 then
        modeString = "冲洗"
    else
        modeString = "空"
    end

    if ultraStrongerFlag == 0 then
        strongerString = "关"
    else
        strongerString = "开"       
    end

    set_text(screenID_Monitor, dgbMon_Text_UltraFreq, ultraFreq)
    set_text(screenID_Monitor, dbgMon_Text_UltraIAD, ultraCurrentAD)
    set_text(screenID_Monitor, dbgMon_Text_UltraVbus_mV, ultraVbus_mV/1000)
    set_text(screenID_Monitor, dbgMon_Text_ErrorCode, packet[UART_FRAME_PLD_INDEX+6])
    set_text(screenID_Monitor, dbgMon_Text_UltraMode, modeString)
    set_text(screenID_Monitor, dbgMon_Text_UltraStronger, strongerString)
    set_text(screenID_Monitor, dbgMon_Text_UltraPowerGear, ultraPowerGear)
    set_text(screenID_Monitor, dbgMon_Text_UltraWaterGear, ultraWaterGear)
    set_text(screenID_Monitor, dbgMon_Text_UltraDuty, packet[UART_FRAME_PLD_INDEX+7])
    set_text(screenID_Monitor, dbgMon_Text_UltraRpm, packet[UART_FRAME_PLD_INDEX+8])

end


-------------------- [[  调试业务--老化测试 DbgAging   ]] --------------------
dbgAging_ScreenID = 5                               -- 页码.老化测试的页码
dbgAging_Button_JumpToDbgMonitor = 10               -- 按钮.跳转到参数监控
dbgAging_Button_JumpToDbgPump = 11                  -- 按钮.跳转到水泵测试
dbgAging_Button_JumpToDbgUltra = 12                 -- 按钮.跳转到超声测试
dbgAging_Button_JumpToDbgParam = 13                 -- 按钮.跳转到整机参数
dbgAging_Button_JumpToMain = 5                      -- 按钮.跳转到主页码
dbgAging_Button_Switch = 20                         -- 按钮.开关
dbgAging_Button_Reset = 21                          -- 按钮.清零
dbgAging_Text_Display1 = 15                         -- 文本框1
dbgAging_Text_Display2 = 18                         -- 文本框2
dbgAging_Text_Switch = 14                           -- 文本.开关按钮
dbgAging_Text_Reset = 19                            -- 文本.清零按钮

DBG_AGING_RUN_DURATION_OF_TIME = 15   -- 开时长15s
DBG_AGING_STOP_DURATION_OF_TIME = 15  -- 关时长15s

dbgAgingSwitch = 0                                  -- 开关 0关1开
dbgAgingReset = 0                                   -- 重置 0无 1请求重置
dbgAgingRunCount = 0                                -- 运行次数
dbgAgingTime = 0                                    -- 计时
dbgAgingMutex = 0                                   -- 互斥
dbgAgingError1Sum = 0                               -- E1累计次数
dbgAgingError2Sum = 0                               -- E2累计次数
dbgAgingError3Sum = 0                               -- E3累计次数
dbgAgingMaxFreq = 0                                 -- 最大频率
dbgAgingMinFreq = 35000                             -- 最小频率
dbgAgingMaxCurrent = 0                              -- 最大电流
dbgAgingMinCurrent = 35000                          -- 最小电流


--[[ 函数
function DbgAging_Show()
function DbgAging_ButtonEvent_Handler(screen, control, value)
function DbgAging_UartEvent_Handler()
function RxMsg07_DbgAging_Handler(packet)
--]]

-------------------------------------------------------------------------------
-- name  DbgAging_ButtonEvent_Handler(control, value)
-- note  用户函数.调试业务.老化测试按钮事件
-------------------------------------------------------------------------------
function DbgAging_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    if screen ~= dbgAging_ScreenID then
        return tempRet
    end
    if control ==  dbgAging_Button_JumpToDbgMonitor and value == 1 then
        BeepOnce()
        change_screen(dbgMon_ScreenID)       -- 跳转到参数监控
        tempRet = 1
    elseif control ==  dbgAging_Button_JumpToDbgPump and value == 1 then
        BeepOnce()
        change_screen(dbgPump_ScreenID)      -- 跳转到水泵测试
        tempRet = 1
    elseif control ==  dbgAging_Button_JumpToDbgUltra and value == 1 then
        BeepOnce()
        change_screen(dbgUltra_ScreenID)     -- 跳转到超声测试
        tempRet = 1
    elseif control ==  dbgAging_Button_JumpToDbgParam and value == 1 then
        BeepOnce()
        change_screen(dbgSysParam_ScreenID)  -- 跳转到整机参数
        tempRet = 1
    elseif control ==  dbgAging_Button_JumpToMain and value == 1 then
        BeepOnce()
        change_screen(screenID_Main)         -- 跳转到主界面
        dbgAgingSwitch = 0
        tempRet = 1
    elseif control == dbgAging_Button_Switch and value == 1 then
        BeepOnce()
        if dbgAgingSwitch == 0 then
            dbgAgingSwitch = 1
            set_text(dbgAging_ScreenID, dbgAging_Text_Switch, "点击停止")
            set_back_color(dbgAging_ScreenID, dbgAging_Text_Switch, 0xF800)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgMonitor, DISABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgPump, DISABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgUltra, DISABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgParam, DISABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToMain, DISABLE)
        else
            dbgAgingSwitch = 0
            set_text(dbgAging_ScreenID, dbgAging_Text_Switch, "点击开始")
            set_back_color(dbgAging_ScreenID, dbgAging_Text_Switch, 0x07E0)  
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgMonitor, ENABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgPump, ENABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgUltra, ENABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToDbgParam, ENABLE)
            set_enable(dbgAging_ScreenID, dbgAging_Button_JumpToMain, ENABLE)            
        end
        tempRet = 1
    elseif control == dbgAging_Button_Reset and value == 2 then
        BeepOnce()
        dbgAgingReset = 1
        tempRet = 1
    end
    return tempRet
end

-------------------------------------------------------------------------------
-- name  RxMsg07_DbgAging_Handler(packet)
-- note  用户函数.调试模式.老化测试
-------------------------------------------------------------------------------
function RxMsg07_DbgAging_Handler(packet)
    local ultraFreq
    local ultraCurrentAD
    local ultraVbus_V
    local modeString
    local strongerString
    local durationOfTime = DBG_AGING_RUN_DURATION_OF_TIME + DBG_AGING_STOP_DURATION_OF_TIME
    local runTime_s

    ultraFreq = packet[UART_FRAME_PLD_INDEX]*256 + packet[UART_FRAME_PLD_INDEX+1]
    ultraCurrentAD = packet[UART_FRAME_PLD_INDEX+2]*256 + packet[UART_FRAME_PLD_INDEX+3]
    ultraVbus_V = (packet[UART_FRAME_PLD_INDEX+4]*256 + packet[UART_FRAME_PLD_INDEX+5])/1000
    dbgAgingTime = packet[UART_FRAME_PLD_INDEX+9]*256 + packet[UART_FRAME_PLD_INDEX+10]
    runTime_s = dbgAgingTime//1000

    -- 进度环显示
    set_value(screenID_Aging, 22, dbgAgingTime/(durationOfTime*1000)*360) 

    -- 更新记录
    if runTime_s == 2 and dbgAgingMutex == 0 then
        dbgAgingMutex = 1
        record_add(screenID_Aging, 16, ultraFreq..";"..ultraCurrentAD..";"..packet[UART_FRAME_PLD_INDEX+6])
        if packet[UART_FRAME_PLD_INDEX+6] == 1 then
            dbgAgingError1Sum = dbgAgingError1Sum + 1
        elseif packet[UART_FRAME_PLD_INDEX+6] == 2  then
            dbgAgingError2Sum = dbgAgingError2Sum + 1
        elseif packet[UART_FRAME_PLD_INDEX+6] == 3  then
            dbgAgingError3Sum = dbgAgingError3Sum + 1
        end
        -- 记录频率
        if ultraFreq < dbgAgingMinFreq then
            dbgAgingMinFreq = ultraFreq
        elseif ultraFreq > dbgAgingMaxFreq then
            dbgAgingMaxFreq = ultraFreq
        end
        -- 记录电流
        if ultraCurrentAD < dbgAgingMinCurrent then
            dbgAgingMinCurrent = ultraCurrentAD
        elseif ultraCurrentAD > dbgAgingMaxCurrent then
            dbgAgingMaxCurrent = ultraCurrentAD
        end
    end

    -- 互斥
    if dbgAgingRunCount ~= (packet[UART_FRAME_PLD_INDEX+7] *256 + packet[UART_FRAME_PLD_INDEX+8]) then
        dbgAgingMutex = 0
    end

    -- 次数记录
    dbgAgingRunCount = (packet[UART_FRAME_PLD_INDEX+7] *256 + packet[UART_FRAME_PLD_INDEX+8])

    if packet[UART_FRAME_PLD_INDEX+11] == 1 then
        dbgAgingReset = 0
        ultraFreq = 0
        dbgAgingError1Sum = 0
        dbgAgingError2Sum = 0
        dbgAgingError3Sum = 0
        record_clear(screenID_Aging, 16)
    end

    if ultraMode == 0 then
        modeString = "骨手术"
    elseif ultraMode == 1 then
        modeString = "牙周治疗"
    elseif ultraMode == 2 then
        modeString = "根管治疗"
    elseif ultraMode == 3 then
        modeString = "术中冲洗"
    else
        modeString = "空"
    end

    if ultraStrongerFlag == 0 then
        strongerString = "关"
    else
        strongerString = "开"       
    end    

    set_text(screenID_Aging, dbgAging_Text_Display1,
    "运行次数: "..dbgAgingRunCount..'\n'..
    "时间s: "..runTime_s..'\n'..
    "频率: "..ultraFreq..'\n'..
    "电流AD:  "..ultraCurrentAD..'\n'..
    "电压V: "..(ultraVbus_V+0.0001)..'\n'..
    "错误代码: "..packet[UART_FRAME_PLD_INDEX+6]..'\n'..
    "E1次数:   "..dbgAgingError1Sum..'\n'..
    "E2次数:   "..dbgAgingError2Sum..'\n'..
    "E3次数:   "..dbgAgingError3Sum..'\n'..
    "工作模式:  "..modeString..'\n'..
    "超强开关:  "..strongerString..'\n'..
    "功率档位:  "..ultraPowerGear..'\n'..
    "水量档位:  "..ultraWaterGear..'\n'..'\n'..
    "最小频率:  "..dbgAgingMinFreq..'\n'..
    "最大频率:  "..dbgAgingMaxFreq..'\n'..
    "频率差值:  "..dbgAgingMaxFreq-dbgAgingMinFreq..'\n'..
    "最小电流:  "..dbgAgingMinCurrent..'\n'..
    "最大电流:  "..dbgAgingMaxCurrent..'\n'..
    "电流差值:  "..dbgAgingMaxCurrent-dbgAgingMinCurrent..'\n'
    )

    set_text(screenID_Aging, dbgAging_Text_Display2,
    "备注: "..'\n'..
    "开时长s: "..DBG_AGING_RUN_DURATION_OF_TIME..'\n'..
    "关时长s: "..DBG_AGING_STOP_DURATION_OF_TIME..'\n'
    )
end


-------------------- [[  调试业务--水泵测试 DbgPump   ]] -----------------------
dbgPump_ScreenID = screenID_Pump                   -- 页码.水泵测试的页码
dbgPump_Button_JumpToMonitor = 10                  -- 按钮.跳转到参数监控
dbgPump_Button_JumpToDbgAging = 11                 -- 按钮.跳转到老化测试
dbgPump_Button_JumpToDbgUltra = 12                 -- 按钮.跳转到超声测试
dbgPump_Button_JumpToDbgSysParam = 13              -- 按钮.跳转到整机参数
dbgPump_Button_JumpToMain = 5                      -- 按钮.跳转到主页码

--[[ 函数
function DbgPump_Show()
function DbgPump_ButtonEvent_Handler(screen, control, value)
function DbgPump_UartEvent_Handler()
--]]


-------------------------------------------------------------------------------
-- name  DbgPump_ButtonEvent_Handler(control, value)
-- note  用户函数.调试业务.水泵测试按钮事件
-------------------------------------------------------------------------------
function DbgPump_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    if screen ~= dbgPump_ScreenID then
        return tempRet
    end
    if control ==  dbgPump_Button_JumpToMonitor and value == 1 then
        change_screen(dbgMon_ScreenID)       -- 跳转到参数监控
        tempRet = 1
    elseif control ==  dbgPump_Button_JumpToDbgAging and value == 1 then
        change_screen(dbgAging_ScreenID)     -- 跳转到老化测试
        tempRet = 1
    elseif control ==  dbgPump_Button_JumpToDbgUltra and value == 1 then
        change_screen(dbgUltra_ScreenID)     -- 跳转到超声测试
        tempRet = 1
    elseif control ==  dbgPump_Button_JumpToDbgSysParam and value == 1 then
        change_screen(dbgSysParam_ScreenID)  -- 跳转到整机参数
        tempRet = 1
    elseif control ==  dbgPump_Button_JumpToMain and value == 1 then
        change_screen(screenID_Main)         -- 跳转到主界面
        tempRet = 1
    end
    return tempRet
end


-------------------- [[  调试业务--超声测试 DbgUltra   ]] ----------------------
dbgUltra_ScreenID = screenID_Ultra                 -- 页码.超声测试的页码
dbgUltra_Button_JumpToMonitor = 10                 -- 按钮.跳转到参数监控
dbgUltra_Button_JumpToDbgAging = 11                -- 按钮.跳转到老化测试
dbgUltra_Button_JumpToDbgPump = 12                 -- 按钮.跳转到水泵测试
dbgUltra_Button_JumpToDbgSysParam = 13             -- 按钮.跳转到整机参数
dbgUltra_Button_JumpToMain = 5                     -- 按钮.跳转到主页码
dbgUltra_Button_Switch = 39                        -- 按钮.运行开关
dbgUltra_Text_Display = 33                         -- 文本.自由文本
dbgUltra_Text_Vbus = 32                            -- 文本.母线电压值
dbgUltra_Text_SetFreq = 47                         -- 文本.频率设定值
dbgUltra_Slider_PowerDuty = 34                     -- 控件.功率占空比
dbgUltra_Slider_WaterRpm = 35                      -- 控件.水量转速
dbgUltra_Slider_Vbus = 31                          -- 控件.母线电压滑块
dbgUltra_Button_FreqAdd = 45                       -- 控件.频率增加
dbgUltra_Button_FreqSub = 46                       -- 控件.频率减少

dbgUltraWorkFreq = 0                               -- 频率工作值
dbgUltraSetFreq = 0                                -- 频率设定值
dbgUltraWorkVbus_mV = 0                            -- 母线电压工作值
dbgUltraSetVbus = 0                                -- 母线电压设定值
dbgUltraWorkPowerDuty = 0                          -- 工作功率占空比
dbgUltraSetPowerDuty = 0                           -- 设定功率占空比
dbgUltraWorkWaterRpm = 0                           -- 水量工作转速
dbgUltraSetWaterRpm = 0                            -- 设置水量转速
dbgUltraRunSwitch = 0                              -- 运行开关 
dbgUltraDataIsChanged = 0                          -- 参数被改变
dbgUltraWorkStep = 0                               -- 0待机1扫频2运行

--[[ 函数
function DbgUltra_Show()
function DbgUltra_ButtonEvent_Handler(screen, control, value)
function DbgUltra_UartEvent_Handler()
function RxMsg08_DbgUltra_Handler(packet)
--]]
-------------------------------------------------------------------------------
-- name  DbgUltra_ButtonEvent_Handler(control, value)
-- note  用户函数.调试业务.超声测试按钮事件
-------------------------------------------------------------------------------
function DbgUltra_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    local tempARR
    if screen ~= dbgUltra_ScreenID then
        return tempRet
    end
    if control ==  dbgUltra_Button_JumpToMonitor and value == 1 then
        change_screen(dbgMon_ScreenID)       -- 跳转到参数监控
        BeepOnce()
        tempRet = 1
    elseif control ==  dbgUltra_Button_JumpToDbgAging and value == 1 then
        change_screen(dbgAging_ScreenID)     -- 跳转到老化测试
        BeepOnce()        
        tempRet = 1
    elseif control ==  dbgUltra_Button_JumpToDbgPump and value == 1 then
        change_screen(dbgPump_ScreenID)     -- 跳转到水泵测试
        BeepOnce()        
        tempRet = 1
    elseif control ==  dbgUltra_Button_JumpToDbgSysParam and value == 1 then
        change_screen(dbgSysParam_ScreenID)  -- 跳转到整机参数
        BeepOnce()        
        tempRet = 1
    elseif control ==  dbgUltra_Button_JumpToMain and value == 1 then
        change_screen(screenID_Main)         -- 跳转到主界面
        BeepOnce()        
        tempRet = 1
    elseif control == dbgUltra_Slider_Vbus then
        BeepOnce()        
        dbgUltraSetVbus = get_value(dbgUltra_ScreenID, dbgUltra_Slider_Vbus);
        set_text(dbgUltra_ScreenID, dbgUltra_Text_Vbus, "电压V:  "..dbgUltraSetVbus)        
        tempRet = 1        
    elseif control == dbgUltra_Slider_PowerDuty then
        BeepOnce()        
        dbgUltraSetPowerDuty = get_value(dbgUltra_ScreenID, dbgUltra_Slider_PowerDuty);
        dbgUltraSetPowerDuty = 10+dbgUltraSetPowerDuty*2
        tempRet = 1
    elseif control == dbgUltra_Slider_WaterRpm then
        BeepOnce()        
        dbgUltraSetWaterRpm = get_value(dbgUltra_ScreenID, dbgUltra_Slider_WaterRpm);
        dbgUltraSetWaterRpm = 20+dbgUltraSetWaterRpm*10
        tempRet = 1        
    elseif control == dbgUltra_Button_Switch and value == 1 then
        BeepOnce()        
        dbgUltraRunSwitch = 1
        tempRet = 1
    elseif control == dbgUltra_Button_Switch and value == 0 then
        BeepOnce()        
        dbgUltraRunSwitch = 0
        dbgUltraSetFreq = 0
        tempRet = 1
    elseif control == dbgUltra_Button_FreqAdd and value == 1 and dbgUltraWorkStep == 2 then
        BeepOnce()
        dbgUltraDataIsChanged = 1
        tempARR = 168000000 // dbgUltraWorkFreq
        tempARR = tempARR - 5
        dbgUltraSetFreq = 168000000 // tempARR
        tempRet = 1
    elseif control == dbgUltra_Button_FreqSub and value == 1 and dbgUltraWorkStep == 2 then
        BeepOnce()        
        dbgUltraDataIsChanged = 1
        tempARR = 168000000 // dbgUltraWorkFreq
        tempARR = tempARR + 5
        dbgUltraSetFreq = 168000000 // tempARR
        tempRet = 1
    end
    return tempRet
end


-------------------------------------------------------------------------------
-- name  RxMsg08_DbgUltra_Handler(packet)
-- note  用户函数.调试业务.超声测试
-------------------------------------------------------------------------------
function RxMsg08_DbgUltra_Handler(packet)
    local ultraCurrrent
    local ultraErrorCode
    local ultraWorkStepString
    local tempARR1
    local tempARR2
    dbgUltraWorkFreq = packet[UART_FRAME_PLD_INDEX]*256+packet[UART_FRAME_PLD_INDEX+1]
    ultraCurrrent = packet[UART_FRAME_PLD_INDEX+2]*256+packet[UART_FRAME_PLD_INDEX+3]
    dbgUltraWorkVbus_mV = packet[UART_FRAME_PLD_INDEX+4]*256+packet[UART_FRAME_PLD_INDEX+5]
    ultraErrorCode = packet[UART_FRAME_PLD_INDEX+6]
    dbgUltraWorkPowerDuty = packet[UART_FRAME_PLD_INDEX+7]
    dbgUltraWorkWaterRpm = packet[UART_FRAME_PLD_INDEX+8]
    dbgUltraWorkStep = packet[UART_FRAME_PLD_INDEX+9]

    if dbgUltraDataIsChanged == 1 then
        tempARR1 = 168000000 // dbgUltraWorkFreq
        tempARR2 = 168000000 // dbgUltraSetFreq
        if tempARR1 == tempARR2 then
            dbgUltraDataIsChanged = 0
            dbgUltraSetFreq = dbgUltraWorkFreq
        end
    end

    if dbgUltraWorkStep == 0 then
        ultraWorkStepString = "待机"
    elseif dbgUltraWorkStep == 1  then
        ultraWorkStepString = "扫频"
    elseif dbgUltraWorkStep == 2  then
        ultraWorkStepString = "运行"
    end

    set_text(dbgUltra_ScreenID, dbgUltra_Text_SetFreq, dbgUltraSetFreq)

    
    set_text(dbgUltra_ScreenID, dbgUltra_Text_Display,
    "频率Hz:  "..dbgUltraWorkFreq..'\n'..
    "电流AD:  "..ultraCurrrent..'\n'..
    "电压:   "..(dbgUltraWorkVbus_mV//1000).." ".."V"..'\n'..
    "功率:   "..dbgUltraWorkPowerDuty.." ".."%"..'\n'..
    "水量:  "..dbgUltraWorkWaterRpm.." ".."Rpm"..'\n'..
    "错误:    "..ultraErrorCode..'\n'..
    "工作状态: "..ultraWorkStepString..'\n'..
    "数据有变: "..dbgUltraDataIsChanged
    )

end



-------------------- [[  调试业务--整机参数 DbgParam   ]] --------------------
dbgSysParam_ScreenID = 8                            -- 页码.整机参数的页码
dbgSysParam_Button_JumpToMonitor = 10               -- 按钮.跳转到参数监控
dbgSysParam_Button_JumpToDbgAging = 11              -- 按钮.跳转到老化测试
dbgSysParam_Button_JumpToDbgPump = 12               -- 按钮.跳转到水泵测试
dbgSysParam_Button_JumpToDbgUltra = 13              -- 按钮.跳转到超声测试
dbgSysParam_Button_JumpToMain = 5                   -- 按钮.跳转到主页码
--[[ 函数
function DbgSysParam_Show()
function DbgSysParam_ButtonEvent_Handler(screen, control, value)
function DbgSysParam_UartEvent_Handler()
--]]

-------------------------------------------------------------------------------
-- name  DbgSysParam_ButtonEvent_Handler(control, value)
-- note  用户函数.调试业务.超声测试按钮事件
-------------------------------------------------------------------------------
function DbgSysParam_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    if screen ~= dbgSysParam_ScreenID then
        return tempRet
    end
    if control ==  dbgSysParam_Button_JumpToMonitor and value == 1 then
        change_screen(dbgMon_ScreenID)       -- 跳转到参数监控
        tempRet = 1
    elseif control ==  dbgSysParam_Button_JumpToDbgAging and value == 1 then
        change_screen(dbgAging_ScreenID)     -- 跳转到老化测试
        tempRet = 1
    elseif control ==  dbgSysParam_Button_JumpToDbgPump and value == 1 then
        change_screen(dbgPump_ScreenID)     -- 跳转到水泵测试
        tempRet = 1
    elseif control ==  dbgSysParam_Button_JumpToDbgUltra and value == 1 then
        change_screen(dbgUltra_ScreenID)  -- 跳转到超声参数
        tempRet = 1
    elseif control ==  dbgSysParam_Button_JumpToMain and value == 1 then
        change_screen(screenID_Main)         -- 跳转到主界面
        tempRet = 1
    end
    return tempRet
end


-------------------------------------------------------------------------------
-- name  DbgMain_ButtonEvent_Handler(screen, control, value)
-- note  用户函数.主界面的进入调试模式按钮
-------------------------------------------------------------------------------
function DbgMain_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0
    if screen == screenID_Main and control == dbg_Button_Left and value == 1 then  -- 左按钮
        if dbgMonitorNextButton == 0 then
            dbgMonitorNextButton = 1
            dbgInterMonitorCount = dbgInterMonitorCount + 1
        else
            dbgMonitorNextButton = 1
            dbgInterMonitorCount = 0
        end
        tempRet =  1
    elseif screen == screenID_Main and control == dbg_Button_Right and value == 1 then  -- 左按钮        
        if dbgMonitorNextButton == 1 then
            dbgMonitorNextButton = 0
            dbgInterMonitorCount = dbgInterMonitorCount + 1
        else
            dbgMonitorNextButton = 0
            dbgInterMonitorCount = 0
        end
        tempRet =  1
    end

    if screen == screenID_Main and dbgInterMonitorCount == 10 then
        change_screen(dbgMon_ScreenID)  -- 跳转到监控界面
        dbgSwitch = 1
        dbgInterMonitorCount = 0
        beep(200)
        tempRet =  1
    end
    return tempRet
end

-------------------------------------------------------------------------------
-- name  Dbg_TimerEvent_Handler()
-- note  用户函数.调试模块定时事件
-------------------------------------------------------------------------------
function Dbg_TimerEvent_Handler()

end




-------------------------------------------------------------------------------
-- name  Dbg_TxRxSelf_TimerEvent_Handler()
-- note  用户函数.模拟串口数据接收.定时事件.100ms计时. 2s未建立通讯则进入模拟收发
-------------------------------------------------------------------------------
function Dbg_TxRxSelf_TimerEvent_Handler()
    dbgTxRxSelfCnt = dbgTxRxSelfCnt + 1
    if dbgTxRxSelfCnt > 20 then 
        dbgTxRxSelfCnt = 20
       -- Dbg_AnalogTxRxSelf()  -- 模拟接收
    end
end

-------------------------------------------------------------------------------
-- name  Dbg_Show()
-- note  用户函数.显示调试信息
-------------------------------------------------------------------------------
function Dbg_Show()
    if dbgSwitch == 1 then
        -- 主页面
        set_visiable(screenID_Main, dbg_Text_MainLog, ENABLE)
        set_text(screenID_Main, dbg_Text_MainLog, 
        "页面FsmStep: "..screenMainFsmSta..'\n'..
        "超声FunSta: "..ultraFunSta.."  模式: "..ultraMode.."   功率: "..ultraPowerGear.."   水量: "..ultraWaterGear.." 运行:"..ultraRunSta_Response.."故障: "..ultraErroeCode..'\n'..
        "照明灯FunSta: "..lightFunSta.."  lightMode: "..lightMode.."  Response: "..lightMode_Response.."  lightDataIsChanged: "..lightDataIsChanged..'\n'..
        "管路清洗FunSta: "..cleanHoseFunSta.."   Request: "..cleanHoseRun_Request.."  Response: "..cleanHoseRun_Response..'\n'..
        "有线脚踏Sta: "..statusBar_PedalIsConnected..'\n'..
        "无线连接: "..bleRun_Response.."  电量: "..bleBatteyLevel.." blePairedFlag_ReadFlash: "..blePairedFlag_ReadFlash..'\n'..
        "写Flash计数: "..flashCount..'\n'..
        "骨手参数: "..ultraParamTable[1][1].."/"..ultraParamTable[1][2].."/"..ultraParamTable[1][3]..'\n'..
        "牙周参数: "..ultraParamTable[2][1].."/"..ultraParamTable[2][2].."/"..ultraParamTable[2][3]..'\n'..
        "根管参数: "..ultraParamTable[3][1].."/"..ultraParamTable[3][2].."/"..ultraParamTable[3][3]..'\n'..
        "冲洗参数: "..ultraParamTable[4][1].."/"..ultraParamTable[4][2].."/"..ultraParamTable[4][3]
    )

        -- 设置页面
        set_visiable(screenID_Settings, dbg_Text_SettingsLog, ENABLE)         
        set_text(screenID_Settings, dbg_Text_SettingsLog, 
        "页面FsmStep: "..screenSettingsFsmSta..'\n'..
        "恢复FunSta: "..restoreFunSta.."   FsmStep: "..restoreFsmStep.."  restoreRun_Request: "..restoreRun_Request.."  restoreRun_Response: "..restoreRun_Response..'\n'..
        "蓝牙FunSta: "..bleFunSta..    "   FsmStep: "..bleFsmStep.."   count: "..bleTimeCount..'\n'..
        "     Request: "..bleRun_Request.."   Response: "..bleRun_Response.." blePairedFlag_WriteFlash: "..blePairedFlag_WriteFlash
        )
    else
        set_visiable(screenID_Main, dbg_Text_MainLog, DISABLE)
        set_visiable(screenID_Settings, dbg_Text_SettingsLog, DISABLE)
    end
end

-------------------------------------------------------------------------------
-- name  Dbg_AnalogTxRxSelf()
-- note  用户函数.模拟收到主板发送的Msg05帧信息
-------------------------------------------------------------------------------
function Dbg_AnalogTxRxSelf()
    local tempScreenID
    g_Sys_Screen_ID            = 1
    -- 超声模块
    ultraMode                  = ultraMode           -- 超声模式
    ultraStrongerFlag          = ultraStrongerFlag   -- 超强开关
    ultraPowerGear             = ultraPowerGear      -- 功率档位
    ultraWaterGear             = ultraWaterGear      -- 水量档位
    ultraRunSta_Response       = 0                   -- 超声运行状态 0待机1运行
    -- 照明灯模块
    lightMode_Response         = lightMode_Request
    -- 管路清洗模块
    cleanHoseRunSta_Response   = 1
    -- 有线脚踏模块
    PedalConnectSta            = 0
    -- 蓝牙脚踏模块
    bleRun_Response            = 0
    bleBatteyLevel             = 0
    -- 故障代码
    ultraErroeCode             = 0
    -- 恢复出厂设置功能
    restoreRun_Response  = 0

    ultraDataIsChanged = 0
    lightDataIsChanged = 0
    cleanHoseDataIsChanged = 0
    restoreDataIsChanged = 0
    bleDataIsChanged = 0

    tempScreenID = get_current_screen()  -- 获取当前界面
    if tempScreenID == screenID_Main then
        -- 判断主页面.各功能状态
        if ultraErroeCode ~= 0 then
            screenMainFsmSta = 3  -- 超声故障
        elseif ultraFunSta == FUNSTA_RUNNING then
            screenMainFsmSta = 1  -- 超声运模块行
        elseif cleanHoseFunSta == FUNSTA_RUNNING then
            screenMainFsmSta = 2  -- 管路清洗模块运行
        elseif ultraFunSta == FUNSTA_READY or cleanHoseFunSta == FUNSTA_READY then
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
        -- 模块执行
        ScreenMain_RefreshView(screenMainFsmSta)
        StatusBar_UartEvent_Handler(PedalConnectSta, bleRun_Response, bleBatteyLevel, soundSwitch)
        Ultra_UartEvent_Handler(ultraRunSta_Response)
        Light_UartEvent_Handler(lightMode_Response)
        CleanHose_UartEvent_Handler(cleanHoseRunSta_Response)
    elseif tempScreenID == screenID_Settings then
        if bleFsmStep == 2 then
            bleRun_Response = 2
        elseif bleFsmStep == 6 then
            bleRun_Response = 0
        elseif bleFsmStep == 7 then
            bleRun_Response = 3
        end
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
        -- 模块执行      
        ScreenSettings_RefreshView(screenSettingsFsmSta)
        Restore_UartEvent_Handler(restoreRun_Response)
        Ble_UartEvent_Handler(bleRun_Response)
    end

end


-------------------------------------------------------------------------------
-- name  DbgMonitor_Show()
-- note  用户函数.监控界面.显示参数
-------------------------------------------------------------------------------
function DbgMonitor_Show()


end