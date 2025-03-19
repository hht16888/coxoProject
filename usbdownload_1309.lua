------------------------U盘操作回调函数----------------------
function  on_usb_inserted(dir)

    USBDriverFalg = 1            --U盘插入标志位

    USBDir = dir
    if(SystemMode==1)
    then
        IMScreen_Show()
    elseif(SystemMode==2)
    then
        SRScreen_Show()
    end
 
    local Open_state = file_open(dir.."/".."COXO.bin",0x01)
    local SD_Data = {0,0,0,0}
    if(Open_state==true)
    then
        file_seek(0)
        SD_Data=file_read(4)      
        if(SD_Data[0] == 0x43 and SD_Data[1] == 0x4F and SD_Data[2] == 0x58 and SD_Data[3] == 0x4F)
        then       
            ResetData()
        end
        file_close()
        beep(500)
    end

    if(SystemMode==0)
    then
        local Pro_State = file_open(dir.."/".."CSailorAir.bin",0x01)
        if(Pro_State==true)
        then
            IAP_Download()
        else
        file_close()         --关闭文件
        end 
    end

    if((SystemMode==3) and (PowerOnFlag == 0))
    then
        local Pro_State_Test = file_open(dir.."/".."TEXT.bin",0x01)    --增加U盘检测功能在种植模式
        if(Pro_State_Test==true)
        then
            beep(500)
        else
        file_close()         --关闭文件
        end 
        PowerOnFlag = 1
    end
    --在设置模式插入U盘检测到文件【CLEARSNCODE.bin】清除SN
    if(SystemMode==3)
    then
        local Clear_Data = {0,0,0,0,0,0,0,0,0,0,0} 
        local Clear_sate= file_open(dir..'/'..'CLEARSNCODE.bin',0x01)

            --SNClear
        if(Clear_sate==true)
        then

            file_seek(0)
            Clear_Data=file_read(11)
            
            if(Clear_Data[0] == 0x43 and Clear_Data[2] == 0x45 and Clear_Data[4] == 0x52 and Clear_Data[6] == 0x4E)
            then
                SNInEnFlag=0x10
                SNCODE="ZZZZZZZZ"
                flush_flash()
                write_flash_string(5000,SNCODE)
                FlashWriteBuf3[0]=SNInEnFlag
                write_flash(4900,FlashWriteBuf3)

                SetScreen_Show()
                beep(500)
            end	
        end
        file_close()
    end

end

function  on_usb_removed()
    USBDriverFalg = 0            --U盘插出
    if(SystemMode==1)
    then
        IMScreen_Show()
    elseif(SystemMode==2)
    then
        SRScreen_Show()
    end
end

function IAP_Download()
    stop_timer(7)--关闭开机动画计时器
    SystemMode=6  
    change_screen(6)
    IAP_Bootloader()
end

function IAP_Bootloader()

    local count    = 0
    local read_cnt = 0
    local offset    = 0
    local all_byte = 0
    local TolBufSize = 0
    local Headbuf={0xFE,0xFF,0xFE,0xFF,0xFE,0xFF,0xFE,0xFF,0xFE,0xFE}           --头 从1开始
        
    local WriteOnceSize=512
    local ProgramFlag=1
    
    set_text(6, 1, 'Enter in IAP Bootloader ...')
    refresh_screen()

    if(ProgramFlag==1)
    then
        --获取当前文件大小
        all_byte = file_size()

        set_text(6, 2, 'File size =   '..all_byte..'  byte')
        refresh_screen()

        if (all_byte > 0)
        then
            Headbuf[9]=all_byte>>8
            Headbuf[10]=all_byte&0X00FF

            set_text(6, 1, 'Extracting file...   [CSailorAir.bin]')
            refresh_screen()

        
            read_cnt =  math.modf(all_byte/WriteOnceSize)

            if( all_byte % WriteOnceSize > 0)
            then
                read_cnt = read_cnt + 1
            end
            set_text(6, 3, 'Read Times =   '..read_cnt..'  c')
            refresh_screen()


            for i = 1, read_cnt
            do
                --复位读字节数组
                read_byte_Tb = {}
        
                --计算读取的偏移位置
                offset = (i - 1) * WriteOnceSize
                local offst_result = file_seek(offset)
                --文件偏移失败
                if (offst_result == false) 
                then
                    set_text(6, 1, 'When reading the file, an offset error occurred. please try again! ! !')
                    refresh_screen()
                
                    break
                end

                --计算本次读的个数
                count = WriteOnceSize
                if i == read_cnt
                then
                    if all_byte % WriteOnceSize > 0
                    then
                        count = all_byte % WriteOnceSize
                    end
                end

                --读取字节转换为字符并拼接成字符串
                read_byte_Tb = file_read(count)

                
                if #(read_byte_Tb) > 0
                then
                    set_text(6, 4, 'Start sending files...   (  '..i..'/'..read_cnt..'  )')
                    refresh_screen()

                    feed_dog()
                    if(i==1)            --头
                    then
                        uart_send_data(Headbuf)
                    end
                    uart_send_data(read_byte_Tb)


                    feed_dog()
                    TolBufSize= #(read_byte_Tb)+1+TolBufSize


                elseif( read_byte_Tb ==nil)
                then
                    set_text(6, 1, ' File read error. please try again! ! !')
                    refresh_screen()
                
                    break;
                end 
            end

            set_text(6, 5, 'File sending completed !!!   TolSize = '..TolBufSize..'   +   '..(#Headbuf) )
            refresh_screen()

            ProgramFlag=2

            set_text(6,6,'The program is copying ...  ')
            refresh_screen()
            set_text(6,7,'Waiting ...  ')
            refresh_screen()
        
        else        --读取的文件为空
            set_text(6, 1, 'The file don`t exist, please check the contents of the USB car! ! !')
            refresh_screen()
            
        end
    end
end

