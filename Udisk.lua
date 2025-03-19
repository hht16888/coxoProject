


-------------------- [[  U盘业务 ]] --------------------
-- 页码ID配置
--screenID_Udisk = 9   已在main.lua定义

-- 控件ID配置
udisk_Text_Display2 = 2   -- 文本控件
udisk_Text_Display3 = 3   -- 文本控件
udisk_Text_Display4 = 4   -- 文本控件
udisk_Text_Display5 = 5   -- 文本控件
udisk_Text_Display6 = 6   -- 文本控件

udisk_Button_IAP = 7      -- 按钮.点击开始烧录
udisk_Text_IAP = 8        -- 文本.烧录按钮的文本提示

-- 变量
local FA_OPEN_EXISTING = 0x00
local FA_READ          = 0x01 -- 读
local FA_WRITE         = 0x02 -- 写
local FA_CREATE_NEW    = 0x04 -- 创建新文件
local FA_CREATE_ALWAYS = 0x08 -- 覆盖创建新文件
local FA_OPEN_ALWAYS   = 0x10 -- 打开

local WriteOnceSize = 512   -- 单次读出的大小
local UdiskDir = ''
--[[ 函数
funciton Udisk_ShowVersionInfo()
function Udisk_IAP_ToMainboard()
funciton on_usb_inserted(dir:盘符) 
function Udisk_ButtonEvent_Handler(screen, control, value)
function Udisk_TimerEvent_Handler()
--]]

-------------------------------------------------------------------------------
-- name  Udisk_ButtonEvent_Handler(screen, control, value)
-- note  用户函数.U盘界面按钮回调函数
-------------------------------------------------------------------------------
function Udisk_ButtonEvent_Handler(screen, control, value)
    local tempRet = 0

    if screen ~= screenID_Udisk then
        return tempRet
    end

    if control ==  udisk_Button_IAP and value == 1 then
        tempRet = 1
        set_text(screenID_Udisk, udisk_Text_IAP, "正在烧录")
        set_back_color(screenID_Udisk, udisk_Text_IAP, 0xF800)
        set_text(screenID_Udisk, udisk_Text_Display6, " ")
        set_enable(screenID_Udisk, udisk_Button_IAP, DISABLE)  -- 失能按钮
        refresh_screen()
        start_timer(timerID_Udisk, 100, 0, 1)
    end
    return tempRet
end

-------------------------------------------------------------------------------
-- name  Udisk_TimerEvent_Handler() 
-- note  库函数.U盘定时回调函数
-------------------------------------------------------------------------------
function Udisk_TimerEvent_Handler()
    local ret = 0
    ret = Udisk_IAP_ToMainboard(UdiskDir)
    if ret == 1 then  -- 烧录成功
    beep(100)
        set_text(screenID_Udisk, udisk_Text_IAP, "点击开始烧录")
        set_back_color(screenID_Udisk, udisk_Text_IAP, 0x07E0)
    elseif ret == 2 then
        set_text(screenID_Udisk, udisk_Text_IAP, "点击重新烧录")
        set_back_color(screenID_Udisk, udisk_Text_IAP, 0x07E0)
    end
    set_enable(screenID_Udisk, udisk_Button_IAP, ENABLE)  -- 使能按钮
    refresh_screen()
end


-------------------------------------------------------------------------------
-- name  on_usb_inserted(dir:盘符) 
-- note  库函数.U盘插入回调函数
-------------------------------------------------------------------------------
function on_usb_inserted(dir)

    local file_open_ret = false    -- 打开文件操作的返回值
    local all_byte = 0             -- 文件大小
    local version_txt = ''
    local tempScreenID

    tempScreenID = get_current_screen()
    if tempScreenID ~= screenID_Monitor then
        return
    end

    beep(50)
    change_screen(screenID_Udisk)  -- 跳转到U盘界面
    refresh_screen()
    UdiskDir = dir

    -- 读取 version.txt 文件中的版本信息文本并显示
    version_txt = Udisk_Read_Txt(UdiskDir, "version.txt")
    set_text(screenID_Udisk, udisk_Text_Display2, version_txt)

    --Udisk_ShowVersionInfo(UdiskDir, "version.txt")


    -- 读取 C_Explorer_Pro_Release.bin 文件
    set_text(screenID_Udisk, udisk_Text_Display3, " ")
    set_text(screenID_Udisk, udisk_Text_Display4, " ")
    set_text(screenID_Udisk, udisk_Text_Display5, " ")
    set_text(screenID_Udisk, udisk_Text_Display6, " ")

    file_open_ret = file_open(dir.."/".."C_Explorer_Pro_Release.bin", FA_READ)
    if file_open_ret == true then
        all_byte = file_size() -- 获取当前文件的大小
        if all_byte > 0 then
            set_text(screenID_Udisk, udisk_Text_Display3, "读取到烧录文件 [C_Explorer_Pro_Release.bin] ".."\n"..
                                                          "文件大小: "..all_byte.." Byte")                                         
            set_text(screenID_Udisk, udisk_Text_IAP, "点击开始烧录")
            set_back_color(screenID_Udisk, udisk_Text_IAP, 0x07E0)
            set_enable(screenID_Udisk, udisk_Button_IAP, ENABLE)  -- 使能按钮
        else
            set_text(screenID_Udisk, udisk_Text_Display3, "未读取到烧录文件 [C_Explorer_Pro_Release.bin]")
            set_text(screenID_Udisk, udisk_Text_IAP, "未找到文件")
            set_back_color(screenID_Udisk, udisk_Text_IAP, 0xF800)
            set_enable(screenID_Udisk, udisk_Button_IAP, DISABLE)  -- 失能按钮            
        end
        file_close()
        refresh_screen()
    else
        set_text(screenID_Udisk, udisk_Text_Display3, "未找到烧录文件 [C_Explorer_Pro_Release.bin]")
        set_text(screenID_Udisk, udisk_Text_IAP, "未找到文件")
        set_back_color(screenID_Udisk, udisk_Text_IAP, 0xF800)
        set_enable(screenID_Udisk, udisk_Button_IAP, DISABLE)  -- 失能按钮    
        refresh_screen()
        file_close()
    end

end

-------------------------------------------------------------------------------
-- name  on_usb_removed()
-- note  库函数.U盘拔出回调函数
-------------------------------------------------------------------------------
function on_usb_removed()
    beep(100)
    change_screen(screenID_Main)  -- 跳转到主界面
end


-------------------------------------------------------------------------------
-- name  Udisk_ShowVersionInfo()
-- note  用户函数.从U盘读取version.txt文本中的版本信息
-------------------------------------------------------------------------------
function Udisk_ShowVersionInfo(dir, fileName)

    local file_open_ret = false  -- 打开文件操作的返回值
	local count    = 0           -- 计数值    
    local all_byte = 0           -- 文件大小dir
    local read_cnt = 0           -- 读出次数
    local offset   = 0           -- 偏移值
    local read_byte_Tb = {}
    local read_char_Tb = {}
	local read_str     = ''

    -- 读取 version.txt 文件中的版本信息文本
    file_open_ret = file_open(dir.."/"..fileName, FA_READ)   -- 读文件中的 version.txt 文件
    if file_open_ret == true then
        all_byte = file_size() -- 获取当前文件的大小
        if all_byte > 0 then
            -- 计算需要分几次读出
            read_cnt = math.modf(all_byte/WriteOnceSize)
            if all_byte % WriteOnceSize > 0 then
                read_cnt = read_cnt +1
            end

            for i = 1, read_cnt do
                -- 复位字节数组
                read_byte_Tb = {}
                read_char_Tb = {}
               
                -- 计算读取的偏移位置
                offset = (i - 1) * WriteOnceSize
                local offst_result = file_seek(offset)
                -- 文件偏移失败
                if offst_result == false then
                    set_text(screenID_Udisk, udisk_Text_Display2, '未找到版本信息文件')
                    break  -- 退出for循环
                end

                -- 计算本次读的个数
                count = WriteOnceSize
                if i == read_cnt then
                    if all_byte % WriteOnceSize > 0 then
                        count = all_byte % WriteOnceSize
                    end
                end

                -- 将读取的字节转换微字符并拼接成字符串
                read_byte_Tb = file_read(count)
                if #(read_byte_Tb) > 0 then
                    for j = 0, #(read_byte_Tb) do
                        read_char_Tb[j + 1] = string.char(read_byte_Tb[j])
                    end
                    read_str =  read_str..table.concat(read_char_Tb)
                    set_text(screenID_Udisk, udisk_Text_Display2, read_str)  -- 最终显示的内容
                elseif read_byte_Tb == nil then
                    set_text(screenID_Udisk, udisk_Text_Display2, '未找到版本信息文件')
                    break  -- 退出for循环
                end

            end
        
        else  -- 文件大小<0
            set_text(screenID_Udisk, udisk_Text_Display2, '未找到版本信息文件')
        end
    else
        set_text(screenID_Udisk, udisk_Text_Display2, '未找到版本信息文件')
        file_close()  -- 关闭文件
    end
    file_close()  -- 关闭文件
    refresh_screen()
end



-------------------------------------------------------------------------------
-- name  Udisk_IAP_ToMainboard(dir) 
-- note  用户函数.将bin文件发送至主板端.实现IAP
-------------------------------------------------------------------------------
function Udisk_IAP_ToMainboard(dir)

    local ret = 0
    local file_open_ret = false  -- 打开文件操作的返回值

	local count    = 0   -- 计数值    
    local all_byte = 0   -- 文件大小
    local read_cnt = 0   -- 读出次数
    local offset   = 0   -- 偏移值
    local TolBufSize = 0 -- 已发送大小    
    local Headbuf={0xFE, 0xFF, 0xFE, 0xFF, 0xFE, 0xFF, 0x00, 0x00, 0x00, 0x00}           --帧头 下标从1开始,第7-10位作为长度位

    -- 读取 C_Explorer_Pro_Release.bin 文件
    file_open_ret = file_open(dir.."/".."C_Explorer_Pro_Release.bin", FA_READ)   -- 读文件中的 version.txt 文件
    if file_open_ret == true then
        all_byte = file_size() -- 获取当前文件的大小
        if all_byte > 0 then
            Headbuf[7] = (all_byte>>24) & 0XFF
            Headbuf[8] = (all_byte>>16) & 0XFF
            Headbuf[9] = (all_byte>>8 ) & 0XFF
            Headbuf[10]= all_byte&0XFF

            -- 计算需要分几次读出
            read_cnt = math.modf(all_byte/WriteOnceSize)
            if all_byte % WriteOnceSize > 0 then
                read_cnt = read_cnt +1
            end

            for i = 1, read_cnt do
                -- 复位字节数组
                read_byte_Tb = {}

                -- 计算读取的偏移位置
                offset = (i - 1) * WriteOnceSize
                local offst_result = file_seek(offset)
                -- 文件偏移失败
                if offst_result == false then
                    set_text(screenID_Udisk, udisk_Text_Display4, '读取文件失败,请重试! ! !')
                    ret = 2
                    break  -- 退出for循环
                else
                    set_text(screenID_Udisk, udisk_Text_Display4, '读取文件成功')
                end

                -- 计算本次读的个数
                count = WriteOnceSize
                if i == read_cnt then
                    if all_byte % WriteOnceSize > 0 then
                        count = all_byte % WriteOnceSize
                    end
                end
                
                -- 读出字节到buf
                read_byte_Tb = file_read(count)

                -- 开始发送
                if #(read_byte_Tb) > 0 then
                    set_text(screenID_Udisk, udisk_Text_Display5, '开始发送...'..i..'/'..read_cnt)
                    if i == 1 then
                        uart_send_data(Headbuf)    -- 帧头只发送一次
                    end
                    uart_send_data(read_byte_Tb)
 
                    feed_dog()  -- 喂狗 否则屏幕重启

                    TolBufSize= #(read_byte_Tb)+1+TolBufSize  -- 累计已发送大小
                elseif read_byte_Tb == nil then
                    set_text(screenID_Udisk, udisk_Text_Display5, ' 文件发送失败，请重试 ! ! !')
                    ret = 2
                end
                refresh_screen()
            end
            
            -- 发送完成
            set_text(screenID_Udisk, udisk_Text_Display5, '文件发送完成,总大小 = '..TolBufSize..' + '..(#Headbuf)) 
            set_text(screenID_Udisk, udisk_Text_Display6, '主机正在处理，请等待...')
            file_close()  -- 关闭文件
            ret = 1
        else -- 读取到的 all_byte 小于0 文件为空
            set_text(screenID_Udisk, udisk_Text_Display4, '未读取到主机程序烧录文件')
            ret = 2
            file_close()  -- 关闭文件
        end
    else
        set_text(screenID_Udisk, udisk_Text_Display4, '未读取到主机程序烧录文件')
        ret = 2
    end
    return ret
end





-------------------------------------------------------------------------------
-- name  Udisk_Read_Txt(dir:盘符, txtFileName:文件名)
-- note  用户函数.从U盘读取.txt文本中的内容
-------------------------------------------------------------------------------
function Udisk_Read_Txt(dir, txtFileName)   -- dir:U盘盘符  txtFileName: txt格式文件名
    local file_open_ret = false  -- 打开文件操作返回值
    local all_byte = 0           -- 文件大小
    local writeOnceSize = 512    -- 单次读出的大小
    local read_cnt = 0           -- 读出次数
    local read_byte_buf = {}     -- 读出数据缓存
    local read_char_buf = {}     -- 字符缓存区
    local read_offset = 0        -- 文件偏移值
    local read_offset_ret = 0    -- 偏移操作返回值
    local read_count = 0         -- 数据大小计数值 
    local read_str = ''          -- 读出的字符串

    -- 打开文件
    file_open_ret = file_open(dir.."/"..txtFileName, FA_READ)   -- 读文件中的 txtFileName 文件
    if file_open_ret == false then
        return "文件打开失败或文件不存在"
    end

    -- 获取文件大小
    all_byte = file_size()
    if all_byte <= 0 then
        file_close()
        return "文件为空"
    end

    -- 计算分几次读出
    read_cnt = math.ceil(all_byte / writeOnceSize)
    
    -- 分块读取文件内容      
    for i = 1, read_cnt do
        -- 计算读取位置的偏移位置
        read_offset  = (i - 1)*writeOnceSize
        read_offset_ret = file_seek(read_offset)
        if read_offset_ret == false then
            file_close()
            return "文件偏移失败"
        end

        -- 计算每次读出的字节大小，最后一次可能不满 writeOnceSize 个
        read_count = writeOnceSize
        if i == read_cnt then
            read_count = all_byte % writeOnceSize  -- 不到 writeOnceSize 个字节
            if read_count == 0 then
                read_count = writeOnceSize
            end
        end
  
        -- 将文件内容读出到 buf
        read_byte_buf = file_read(read_count)
        if #(read_byte_buf) == 0 or read_byte_buf == nil then
            file_close()
            return "文件读取失败"
        end

        for j = 0, #(read_byte_buf) do
            read_char_buf[j+1] = string.char(read_byte_buf[j])
        end
        read_str =  read_str..table.concat(read_char_buf)
    end

    file_close()
    return read_str
end