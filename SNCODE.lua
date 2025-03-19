

-------------------------------[[SN码录入]]------------------------------------
SNCode_Input_Screen = 3                --SN码输入界面的屏幕ID号
SNCode_Display_Screen = 2                --SN码显示界面的屏幕ID号
SNCode_Enter_Screen = 1                --进入SN码输入界面的控件所在屏幕ID号
SNCode_Enter_Button = 47              --SN码界面进入按键
SNCode_Input_Button = 39              --SN码确定按键
SNCode_Return_Button = 41             --SN码返回主界面按键s
SNCode_Display_Icon = 38              --SN码字符显示控件
SN_Display_Icon = 16                  --SN码显示控件
SNText_Display_Icon = 27                  --SN文本显示控件
SNDelete_Button = 37                --SN码临时清空按键

SNCode_Inputed_Flag = 0              --SN码已录入标志位  0：未录入  1：已录入
SNCODE = 'ZZZZZZZZ'                    --SN码储存

gFlashSNDataBuf = {0}
gFlashSNReadDataBuf = {0}


-------------------------------[[指令]]------------------------------------
g_Directives = 0            --指令
g_Directives_Screen = 2            --指令控件所在页面
g_Directives_Button = 22            --指令按钮，按够十下弹出小键盘输入
g_Directives_Icon = 21            --指令控件按钮，键盘输入指令密码

g_Directives_Enable_Cnt = 0            --指令按钮按下的次数

-------------------------------------------------------------------------------
--function SNCode_Init()                --SN码开机初始化
--function SNCode_Input()                --SN码录入回调函数
--function SNCode_Purge()                --SN码清除回调函数
--function SNCode_Screen_Quit()          --SN码页面退出回调



-------------------------------------------------------------------------------
-- name  SNCode_Init() 
-- note  SN码开机初始化
-------------------------------------------------------------------------------
function SNCode_Init()                --SN码开机初始化
    local sncode1
    local sncode2
    local sncode3
    gFlashSNReadDataBuf = read_flash(4900, 1)
    SNCode_Inputed_Flag = gFlashSNReadDataBuf[0]
    if SNCode_Inputed_Flag == 1 then
        SNCODE = read_flash_string(4975, 8)
        sncode1=string.sub(SNCODE,1,4)
        sncode2=string.sub(SNCODE,5,8)
        sncode3=sncode1..'-'..sncode2
        set_text(SNCode_Display_Screen, SN_Display_Icon, sncode3) -- 设置二维码内容
        set_text(SNCode_Display_Screen,SNText_Display_Icon,sncode3)      --显示二维码文本
        set_enable(SNCode_Enter_Screen , SNCode_Enter_Button , DISABLE)    --失能主界面进入SN界面控件
        set_visiable(SNCode_Enter_Screen , SNCode_Enter_Button , DISABLE) --隐藏主界面进入SN界面控件
    else
        set_enable(SNCode_Enter_Screen , SNCode_Enter_Button , ENABLE) --使能主界面进入SN界面控件
        set_visiable(SNCode_Enter_Screen , SNCode_Enter_Button , ENABLE) --显示主界面进入SN界面控件
    end
end


-------------------------------------------------------------------------------
-- name  SNCode_Input()
-- note  SN码录入回调函数
-------------------------------------------------------------------------------
function SNCode_Input()                --SN码录入回调函数
    local sncode1
    local sncode2
    local sncode3
    SNCODE=get_text(SNCode_Input_Screen, SNCode_Display_Icon)  --读取显示控件内的SN码
    if(#SNCODE==8) then        --如果获取到的值为8位数
        SNCode_Inputed_Flag = 0x01
        gFlashSNDataBuf[0]=SNCode_Inputed_Flag
        write_flash(4900,gFlashSNDataBuf)  --将已录入SN码标志位置一
        flush_flash()--立刻写入
        write_flash_string(4975,SNCODE)        --将SN码写入Flash
        sncode1=string.sub(SNCODE,1,4)
        sncode2=string.sub(SNCODE,5,8)
        sncode3=sncode1..'-'..sncode2
        set_text(SNCode_Display_Screen, SN_Display_Icon, sncode3) -- 设置二维码内容
        set_text(SNCode_Display_Screen,SNText_Display_Icon,sncode3)      --显示二维码文本
        change_screen(1)            --括号内为主界面ID
        if SNCode_Inputed_Flag == 1 then
            set_enable(SNCode_Enter_Screen , SNCode_Enter_Button , DISABLE)        --失能主界面进入SN界面控件
            set_visiable(SNCode_Enter_Screen , SNCode_Enter_Button , DISABLE)      --隐藏主界面进入SN界面控件
        end
    end
end


-------------------------------------------------------------------------------
-- name  SNCode_Purge()  
-- note  SN码清除回调函数
-------------------------------------------------------------------------------
function SNCode_Purge()                --SN码清除回调函数
    local Directives
    Directives = get_text(g_Directives_Screen, g_Directives_Icon)
    if Directives == '299536' then
        SNCODE = 'ZZZZZZZZ'
        set_text(SNCode_Display_Screen, SN_Display_Icon, SNCODE) -- 设置二维码内容
        write_flash_string(4975,SNCODE)        --清空SN码
        SNCode_Inputed_Flag = 0
        gFlashSNDataBuf[0]=SNCode_Inputed_Flag 
        write_flash(4950,gFlashSNDataBuf)  --将已录入SN码标志位置0
        set_enable(SNCode_Enter_Screen , SNCode_Enter_Button , ENABLE) --使能主界面进入SN界面控件
        set_visiable(SNCode_Enter_Screen , SNCode_Enter_Button , ENABLE) --显示主界面进入SN界面控件
    elseif Directives == '887936' then
        if Language == 0 then
            Language = 1        --设置语言为英文
        elseif Language == 1 then
            Language = 0        --设置语言为中文
        end
        set_value(screenID_Main, sys_Icon_JumpToSettings, 0+(Language*1))   -- 进入设置界面图标根据语言显示
        set_value(screenID_Settings, sys_Icon_Background, 0+(Language*1))   -- 设置界面背景图标根据语言显示
        ScreenSettings_Init()

        Ble_RefreshView(bleFsmStep)

    elseif Directives == '887863' then
        change_screen(dbgMon_ScreenID)  -- 跳转到监控界面
    end
end


-------------------------------------------------------------------------------
-- name  SNCode_Delete()  
-- note  SN码临时清空回调函数
-------------------------------------------------------------------------------
function SNCode_Delete()                --SN码删除回调函数

    SNCODE = ''
    set_text(SNCode_Screen, SNCode_Display_Icon, SNCODE)  --设置显示控件内的SN码

end


-------------------------------------------------------------------------------
-- name  SNCode_Screen_Quit()  
-- note  SN码页面退出回调
-------------------------------------------------------------------------------
function SNCode_Screen_Quit()          --SN码页面退出回调

    change_screen(1)            --括号内为主界面ID,返回主界面

end

-------------------------------------------------------------------------------
-- name  SNCode_Screen_Enter()  
-- note  SN码页面进入回调
-------------------------------------------------------------------------------
function SNCode_Screen_Enter()          --SN码页面进入回调

    change_screen(SNCode_Input_Screen)            --括号内为SN码输入界面ID,进入SN码输入界面

end


-------------------------------------------------------------------------------
-- name   Directives_Init() 
-- note  指令开机初始化
-------------------------------------------------------------------------------
function Directives_Init()                --指令开机初始化

    g_Directives = 0            --指令
    set_enable(g_Directives_Screen , g_Directives_Button , ENABLE)    --使能指令输入控件
    set_enable(g_Directives_Screen , g_Directives_Icon , DISABLE)    --失能指令输入控件
    set_visiable(g_Directives_Screen , g_Directives_Icon , DISABLE) --隐藏指令输入控件

end

-------------------------------------------------------------------------------
-- name   Directives_Enable()   
-- note  使能指令输入按钮
-------------------------------------------------------------------------------
function Directives_Enable(control)                --使能指令输入按钮
    if control == g_Directives_Button then
        g_Directives_Enable_Cnt = g_Directives_Enable_Cnt + 1
    end

    if g_Directives_Enable_Cnt == 10 then
        beep(100)
        set_enable(g_Directives_Screen , g_Directives_Button , DISABLE)    --失能指令输入控件
        set_enable(g_Directives_Screen , g_Directives_Icon , ENABLE)    --使能指令输入控件
        set_visiable(g_Directives_Screen , g_Directives_Icon , ENABLE)  --显示指令输入控件
    end
end

