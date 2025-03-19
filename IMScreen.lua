--种植界面相关逻辑脚本实现
ENABLE = 1
DISABLE = 0
LongTouch = 2 --长按


--用户步骤数据库内容
IMUserStepsDataBuf =
{
    {   --第二维是用户下的程序ID：P1,P2,P3,P4,P5
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户1

    {   --第二维是用户下的程序ID
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户2

    {   --第二维是用户下的程序ID
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户3
}


------------------初始化用户步骤数据库内容---------
IM_InitUserStepsDataBuf =
{
    {   --第二维是用户下的程序ID：P1,P2,P3,P4,P5
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户1

    {   --第二维是用户下的程序ID
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户2

    {   --第二维是用户下的程序ID
        {2, 3, 4, 6, 7, 8, 0, 0},   --第三维是用户的程序下的步骤数据: 0为不显示步骤; 非0为显示步骤:1-12

        {2, 3, 4, 5, 6, 7, 8, 0},   --1:球钻,2：标记钻,3：先锋钻,4：扩孔钻,5：成型钻,6：攻丝钻,7：种植体,

        {2, 3, 4, 4, 4, 6, 7, 8},   --8：愈合帽,9：骨锯,10：高速,11：低速,12：冲水

        {2, 3, 4, 12, 7, 8, 0, 0},

        {10, 2, 3, 4, 0, 0, 0, 0},
    }, --第一维用户3
}

--当前用户当前程序显示当前步骤数据库内容，只显示，不做数据更新
IMStepsDisplayBuf = {1, 0, 0, 0, 0, 0, 0, 0}

Temp_Steps = 0        --临时的步骤储存,不涉及数据更新,只用于界面显示

--用户名称ID数据库内容
IMUserIDDataBuf =
{
    {"User1", "User2", "User3"}
}

--用户程序备注数据库内容
IMUserProgramIDDataBuf =
{
    --Usr1
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""},
    --Usr2
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""},
    --Usr3
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""}
}

IM_Init_UserProgramIDDataBuf =
{
    --Usr1
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""},
    --Usr2
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""},
    --Usr3
    {"Very Soft Bone", "Soft Bone", "Hard Bone", "", ""}
}

--用户1下数据：速度，扭矩，速比，水量，LED
IM_User1ProgramBuf=
{
    --P1
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {20,25,12,2,0},               --第四步骤  攻丝钻
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤  预留
            {500,10,12,2,2},               --第八步骤  预留
    },

    --P2
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  成型钻
            {20,25,12,2,0},               --第五步骤  攻丝钻
            {20,20,12,2,2},               --第六步骤  种植体
            {20,10,12,2,2},               --第七步骤  愈合帽
            {500,10,12,2,2},               --第八步骤
    },
    --P3
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤  扩孔钻
            {20,25,12,2,2},               --第六步骤  攻丝钻
            {20,20,12,2,2},               --第七步骤  种植体
            {20,10,12,2,2},               --第八步骤  愈合帽
    },
    --P4
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {0,0,12,2,0},                  --第四步骤  冲水
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    },
    --P5
    {
        --速度，扭矩，速比，水量，LED
            {10000,40,4,2,2},                --第一步骤  高速
            {500,10,12,2,2},               --第二步骤  标记钻
            {500,10,12,2,2},               --第三步骤  先锋钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤
            {500,10,12,2,2},               --第六步骤
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    }
}

IM_User2ProgramBuf=
{
        --P1
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {20,25,12,2,0},               --第四步骤  攻丝钻
                {20,20,12,2,0},               --第五步骤  种植体
                {20,10,12,2,2},               --第六步骤  愈合帽
                {500,10,12,2,2},               --第七步骤  预留
                {500,10,12,2,2},               --第八步骤  预留
        },
    
        --P2
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {500,10,12,2,0},               --第四步骤  成型钻
                {20,25,12,2,0},               --第五步骤  攻丝钻
                {20,20,12,2,2},               --第六步骤  种植体
                {20,10,12,2,2},               --第七步骤  愈合帽
                {500,10,12,2,2},               --第八步骤
        },
        --P3
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {500,10,12,2,0},               --第四步骤  扩孔钻
                {500,10,12,2,0},               --第五步骤  扩孔钻
                {20,25,12,2,2},               --第六步骤  攻丝钻
                {20,20,12,2,2},               --第七步骤  种植体
                {20,10,12,2,2},               --第八步骤  愈合帽
        },
        --P4
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {0,0,12,2,0},                  --第四步骤  冲水
                {20,20,12,2,0},               --第五步骤  种植体
                {20,10,12,2,2},               --第六步骤  愈合帽
                {500,10,12,2,2},               --第七步骤
                {500,10,12,2,2},               --第八步骤
        },
        --P5
        {
            --速度，扭矩，速比，水量，LED
                {10000,40,4,2,2},                --第一步骤  高速
                {500,10,12,2,2},               --第二步骤  标记钻
                {500,10,12,2,2},               --第三步骤  先锋钻
                {500,10,12,2,0},               --第四步骤  扩孔钻
                {500,10,12,2,0},               --第五步骤
                {500,10,12,2,2},               --第六步骤
                {500,10,12,2,2},               --第七步骤
                {500,10,12,2,2},               --第八步骤
        }
}

IM_User3ProgramBuf=
{
       --P1
       {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {20,25,12,2,0},               --第四步骤  攻丝钻
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤  预留
            {500,10,12,2,2},               --第八步骤  预留
    },

    --P2
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  成型钻
            {20,25,12,2,0},               --第五步骤  攻丝钻
            {20,20,12,2,2},               --第六步骤  种植体
            {20,10,12,2,2},               --第七步骤  愈合帽
            {500,10,12,2,2},               --第八步骤
    },
    --P3
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤  扩孔钻
            {20,25,12,2,2},               --第六步骤  攻丝钻
            {20,20,12,2,2},               --第七步骤  种植体
            {20,10,12,2,2},               --第八步骤  愈合帽
    },
    --P4
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {0,0,12,2,0},                  --第四步骤  冲水
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    },
    --P5
    {
        --速度，扭矩，速比，水量，LED
            {10000,40,4,2,2},                --第一步骤  高速
            {500,10,12,2,2},               --第二步骤  标记钻
            {500,10,12,2,2},               --第三步骤  先锋钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤
            {500,10,12,2,2},               --第六步骤
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    }
}
------------------------------初始化数据-------------------------
IM_Init_User1ProgramBuf=
{
       --P1
       {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {20,25,12,2,0},               --第四步骤  攻丝钻
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤  预留
            {500,10,12,2,2},               --第八步骤  预留
    },

    --P2
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  成型钻
            {20,25,12,2,0},               --第五步骤  攻丝钻
            {20,20,12,2,2},               --第六步骤  种植体
            {20,10,12,2,2},               --第七步骤  愈合帽
            {500,10,12,2,2},               --第八步骤
    },
    --P3
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤  扩孔钻
            {20,25,12,2,2},               --第六步骤  攻丝钻
            {20,20,12,2,2},               --第七步骤  种植体
            {20,10,12,2,2},               --第八步骤  愈合帽
    },
    --P4
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {0,0,12,2,0},                  --第四步骤  冲水
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    },
    --P5
    {
        --速度，扭矩，速比，水量，LED
            {10000,40,4,2,2},                --第一步骤  高速
            {500,10,12,2,2},               --第二步骤  标记钻
            {500,10,12,2,2},               --第三步骤  先锋钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤
            {500,10,12,2,2},               --第六步骤
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    }
}

IM_Init_User2ProgramBuf=
{
        --P1
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {20,25,12,2,0},               --第四步骤  攻丝钻
                {20,20,12,2,0},               --第五步骤  种植体
                {20,10,12,2,2},               --第六步骤  愈合帽
                {500,10,12,2,2},               --第七步骤  预留
                {500,10,12,2,2},               --第八步骤  预留
        },
    
        --P2
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {500,10,12,2,0},               --第四步骤  成型钻
                {20,25,12,2,0},               --第五步骤  攻丝钻
                {20,20,12,2,2},               --第六步骤  种植体
                {20,10,12,2,2},               --第七步骤  愈合帽
                {500,10,12,2,2},               --第八步骤
        },
        --P3
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {500,10,12,2,0},               --第四步骤  扩孔钻
                {500,10,12,2,0},               --第五步骤  扩孔钻
                {20,25,12,2,2},               --第六步骤  攻丝钻
                {20,20,12,2,2},               --第七步骤  种植体
                {20,10,12,2,2},               --第八步骤  愈合帽
        },
        --P4
        {
            --速度，扭矩，速比，水量，LED
                {500,10,12,2,2},               --第一步骤  标记钻
                {500,10,12,2,2},               --第二步骤  先锋钻
                {500,10,12,2,2},               --第三步骤  扩孔钻
                {0,0,12,2,0},                  --第四步骤  冲水
                {20,20,12,2,0},               --第五步骤  种植体
                {20,10,12,2,2},               --第六步骤  愈合帽
                {500,10,12,2,2},               --第七步骤
                {500,10,12,2,2},               --第八步骤
        },
        --P5
        {
            --速度，扭矩，速比，水量，LED
                {10000,40,4,2,2},                --第一步骤  高速
                {500,10,12,2,2},               --第二步骤  标记钻
                {500,10,12,2,2},               --第三步骤  先锋钻
                {500,10,12,2,0},               --第四步骤  扩孔钻
                {500,10,12,2,0},               --第五步骤
                {500,10,12,2,2},               --第六步骤
                {500,10,12,2,2},               --第七步骤
                {500,10,12,2,2},               --第八步骤
        }
}

IM_Init_User3ProgramBuf=
{
         --P1
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {20,25,12,2,0},               --第四步骤  攻丝钻
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤  预留
            {500,10,12,2,2},               --第八步骤  预留
    },

    --P2
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  成型钻
            {20,25,12,2,0},               --第五步骤  攻丝钻
            {20,20,12,2,2},               --第六步骤  种植体
            {20,10,12,2,2},               --第七步骤  愈合帽
            {500,10,12,2,2},               --第八步骤
    },
    --P3
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤  扩孔钻
            {20,25,12,2,2},               --第六步骤  攻丝钻
            {20,20,12,2,2},               --第七步骤  种植体
            {20,10,12,2,2},               --第八步骤  愈合帽
    },
    --P4
    {
        --速度，扭矩，速比，水量，LED
            {500,10,12,2,2},               --第一步骤  标记钻
            {500,10,12,2,2},               --第二步骤  先锋钻
            {500,10,12,2,2},               --第三步骤  扩孔钻
            {0,0,12,2,0},                  --第四步骤  冲水
            {20,20,12,2,0},               --第五步骤  种植体
            {20,10,12,2,2},               --第六步骤  愈合帽
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    },
    --P5
    {
        --速度，扭矩，速比，水量，LED
            {10000,40,4,2,2},                --第一步骤  高速
            {500,10,12,2,2},               --第二步骤  标记钻
            {500,10,12,2,2},               --第三步骤  先锋钻
            {500,10,12,2,0},               --第四步骤  扩孔钻
            {500,10,12,2,0},               --第五步骤
            {500,10,12,2,2},               --第六步骤
            {500,10,12,2,2},               --第七步骤
            {500,10,12,2,2},               --第八步骤
    }
}

--User = 1                        --当前选择用户:1，2，3
Promgrame = {1, 1, 1}           --用户选择的程序:1，2，3，4，5 用户选择的程序
Steps = {{1, 1, 1, 1, 1}, {1, 1, 1, 1, 1}, {1, 1, 1, 1, 1}} --当前选择步骤:1，2，3，4，5，6，7，8 五个程序的当前步骤
Steps_Init = {{1, 1, 1, 1, 1}, {1, 1, 1, 1, 1}, {1, 1, 1, 1, 1}}
IMScreenID = 1                  --当前屏幕ID:种植界面

Flag = 0 --若选择的步骤为0，则flag为1，否则为0

IM_Step_ProNum=    --各P的步骤总数
{
    {6,7,8,6,4},   --一维是用户
    {6,7,8,6,4},   --二维是各P的步骤总数
    {6,7,8,6,4},
}
IM_Temp_Step_ProNum=  --各P的步骤总数
{
    {6,7,8,6,4},
    {6,7,8,6,4},
    {6,7,8,6,4},
}
IM_Init_Step_ProNum=  --各P的步骤总数
{
    {6,7,8,6,4},
    {6,7,8,6,4},
    {6,7,8,6,4},
}


IMBackgroundIcon = 81 --背景图标

--------------------------[[数据查看]]----------------------------------
IMDataReviewEnter = 22 --数据查看进入按键

------------------------------步骤栏---------------------------------
IM_ProgramBackground_Icon = 1 --程序背景图标
IM_Program_Button = 21    --程序切换按钮
IM_Program_Icon   = 54    --程序显示图标
IM_Step1_Icon = 2       --步骤1图标
IM_Step1_Button = 10    --步骤1按钮
IM_Step2_Icon = 3       --步骤2图标
IM_Step2_Button = 11    --步骤2按钮
IM_Step3_Icon = 4       --步骤3图标
IM_Step3_Button = 12    --步骤3按钮
IM_Step4_Icon = 5       --步骤4图标
IM_Step4_Button = 13    --步骤4按钮
IM_Step5_Icon = 6       --步骤5图标
IM_Step5_Button = 14    --步骤5按钮
IM_Step6_Icon = 7       --步骤6图标
IM_Step6_Button = 15    --步骤6按钮
IM_Step7_Icon = 8       --步骤7图标
IM_Step7_Button = 16    --步骤7按钮
IM_Step8_Icon = 9       --步骤8图标
IM_Step8_Button = 17    --步骤8按钮

IM_BigStep_Icon = 18    --大步骤图标
IM_BigStep_Button = 19  --大步骤按钮

-----------------------------------------------------------------------

------------------------------速度、扭矩加减按键-----------------------
IM_TopAdd_Button = 60    --最上面的速度加按钮
IM_TopSub_Button = 59    --最上面的速度减按钮
IM_TopAddSub_Icon = 63    --最上面的速度加减图标
IM_MidAdd_Button = 42    --中间的速度加按钮
IM_MidSub_Button = 41    --中间的速度减按钮
IM_MidAddSub_Icon = 40    --中间的速度加减图标
IM_BottomAdd_Button = 62    --最下面的速度加按钮
IM_BottomSub_Button = 61    --最下面的速度减按钮
IM_BottomAddSub_Icon = 39    --最下面的速度加减图标
-----------------------------------------------------------------------

------------------------------冲水步骤-----------------------
IM_WaterFlush_Icon = 65    --冲水动画

-----------------------------------------------------------------------


------------------------------水量模块---------------------------------
IM_Water_Button = 30    --水量按钮
IM_Water_Icon   = 24    --水量图标
-----------------------------------------------------------------------


------------------------------LED模块---------------------------------
IM_LED_Button = 31    --LED按钮
IM_LED_Icon   = 25    --LED图标
-----------------------------------------------------------------------

------------------------------速比模块---------------------------------
IM_Ratio_Button = 33    --速比按钮
IM_Ratio_Icon   = 27    --速比图标
MaxRatio = 13   --最大速比
MinRatio = 8    --最小速比
-----------------------------------------------------------------------

-----------------------------种植和外壳模式切换--------------------------
IM_Change_SR_Button = 64    --种植按钮
IM_Change_SR_Icon   = 76    --种植图标
-----------------------------------------------------------------------

-----------------------------种植界面用户明显示--------------------------
--g_IM_UserNameText = 67       --用户名
g_IM_UserHeadText   = 37     --大写字母

--g_IM_UserNameText_Black = 83       --用户名  黑夜
g_IM_UserHeadText_Black   = 82     --大写字母  黑夜

g_IM_UserNameTextFirst = 67       --种植程序名 用户1
g_IM_UserNameTextSecond = 83      --种植程序名 用户2
g_IM_UserNameTextThree = 87       --种植程序名 用户3

g_IM_UserNameButton = 56     --切换为用户用户设置界面
-----------------------------------------------------------------------
--------------------------------种植界面程序名显示--------------------------
g_IM_ProgramNameText = 69            --种植程序名 白底
g_IM_ProgramNameText_Black = 84      --种植程序名 黑底

g_IM_ProgramNameButton = 58     --种植程序名修改按键

g_IM_ProgramNameChangeFlag = 0  --修改程序名标志位，区分键盘修改用户名
-----------------------------------------------------------------------

------------------------------速度显示---------------------------------
IM_Speed_FirstNum = 46    --速度第一位数字
IM_Speed_SecondNum = 47    --速度第二位数字
IM_Speed_ThirdNum = 48    --速度第三位数字
IM_Speed_FourthNum = 49    --速度第四位数字
IM_Speed_FifthNum = 50    --速度第五位数字
IM_Speed_SixthNum = 51    --速度第六位数字
IM_Speed_SenventhNum = 68    --速度第七位数字
IM_Speed_EighthNum = 66    --速度第八位数字
IM_Speed_NinethNum = 79    --速度第九位数字
IM_Speed_TenthNum = 70    --速度第十位数字
IM_Speed_EleventhNum = 77    --速度第十一位数字
IM_Speed_TwelfthNum = 78    --速度第十二位数字
IM_Speed_Zero = 35      --速度0时显示--
-----------------------------------------------------------------------

------------------------------文本显示---------------------------------
IM_SpeedTorque_Text = 29    --种植界面文本显示（速度、扭矩文本）
------------------------------------------------------------------------

------------------------------扭矩显示---------------------------------
IM_Torque_FirstNum = 52    --扭矩第一位数字
IM_Torque_SecondNum = 53    --扭矩第二位数字
IM_Torque_Zero = 36      --扭矩0时显示--
-----------------------------------------------------------------------

------------------------------状态栏---------------------------------
Status_Bar_Motor = 71    --状态栏马达图标
Status_Bar_Ble = 72    --状态栏蓝牙图标
Status_Bar_Foot = 73    --状态栏脚踏图标
Status_Bar_FootPower = 74    --状态栏脚踏电量图标
Status_Bar_Voice = 75    --状态栏声音图标
Status_Bar_Timer = 1    --状态栏闪烁定时器

-----------------------------------------------------------------------

------------------------------电机方向---------------------------------
IM_MotordirectionButton = 32    --电机按钮
IM_MotordirectionIcon   = 26    --电机图标
-----------------------------------------------------------------------

------------------------------电机方向---------------------------------
IM_Set_Button = 34    --设置按钮
IM_Set_Icon   = 28    --设置图标
-----------------------------------------------------------------------

-----------------------------扭力条图标--------------------------------
IM_Torque_Progress_Bars_Icon   = 43    --种植扭力进度条
-----------------------------------------------------------------------

-----------------------------数据查看----------------------------------
IM_DataViewingButton = 22    
IM_DataViewingIcon   = 45    
g_IM_DataViewing = 0      --数据查看标志位
-----------------------------------------------------------------------

-----------------------------弯机清洗----------------------------------
IM_WashingButton = 23  
IM_WashingIcon   = 20 

g_IM_WashingFlag = 0      --弯机清洗标志位
g_IM_WashingCnt = 0       --弯机清洗计数器
g_IM_WashingTime = 14     --定时器14 弯机清洗
g_IM_WashingCancleTime = 15  --定时器15 中途取消
g_IM_WashingCancleFlag = 0   --中途取消标准位
g_IM_WashingCancleCnt = 0    --中途取消计数器
-----------------------------------------------------------------------

-----------------------------种植用户图标---------------------------------- 
IM_UserIcon   = 55    
-----------------------------------------------------------------------
-----------------------------下排背景图标---------------------------------- 
IM_LowerRowBlackIcon   = 44    
-----------------------------------------------------------------------
-----------------------------中间工作背景图标---------------------------------- 
IM_MiddleBlackIcon   = 85    
-----------------------------------------------------------------------

IM_MaxSetSpeed=0
IM_MinSetSpeed=0
IM_MaxSetTorque=0
IM_MinSetTorque=0

IM_RatioSpeedMax=0
IM_RatioSpeedMin=0
IM_CurrentworkingMode = 0    --当前工作状态
-----------------------------------------------------------------------------
--@program:IM_Screen_Lower_Row_Black_Show()
--@brief:中间背景显示
-------------------------------------------------------------------------------
function IM_Screen_Middle_Black_Show()
    if  workingMode == 1 then
        set_value(IMScreenID,IM_MiddleBlackIcon,0+g_SetDarkModeFlag)  
        set_visiable(IMScreenID,IM_MiddleBlackIcon,ENABLE)    
    else
        set_visiable(IMScreenID,IM_MiddleBlackIcon,DISABLE)           
    end

end
-----------------------------------------------------------------------------
--@program:IM_Screen_Lower_Row_Black_Show()
--@brief:下排背景显示
-------------------------------------------------------------------------------
function IM_Screen_Lower_Row_Black_Show()
    if  workingMode == 1 then
        set_value(IMScreenID,IM_LowerRowBlackIcon,0+g_SetDarkModeFlag)  --当前图标用户
        set_visiable(IMScreenID,IM_LowerRowBlackIcon,ENABLE)  
    else
        set_visiable(IMScreenID,IM_LowerRowBlackIcon,DISABLE)           
    end
end
-----------------------------------------------------------------------------
--@program:IM_Screen_Data_Refresh_Show()
--@brief:查看数据刷新
-------------------------------------------------------------------------------
function IM_Screen_Data_Refresh_Show(user, program, steps)
    if IM_CurrentworkingMode ~=  workingMode then
        if  workingMode == 1 and Motordirection == 0 then       --正转清空扭力
            if user == 1 then
                IM_Usr1DataReview_Buf[program][steps][3] = 0    --查看数据速度清零
                IM_Usr1DataReview_Buf[program][steps][5] = 0    --查看数据速度清零
            elseif  user == 2 then   
                IM_Usr2DataReview_Buf[program][steps][3] = 0    --查看数据速度清零
                IM_Usr2DataReview_Buf[program][steps][5] = 0    --查看数据速度清零
            elseif  user == 3 then   
                IM_Usr3DataReview_Buf[program][steps][3] = 0    --查看数据速度清零
                IM_Usr3DataReview_Buf[program][steps][5] = 0    --查看数据速度清零               
            end
        end  
        IM_CurrentworkingMode =  workingMode
    end
end
-----------------------------------------------------------------------------
--@program:IM_Screen_User_Show()
--@brief:当前图标用户
-------------------------------------------------------------------------------
function IM_Screen_User_Show()
    set_value(IMScreenID,IM_UserIcon,g_CurrentUser)  --当前图标用户
    set_visiable(IMScreenID,IM_UserIcon,ENABLE)    
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--@program: IM_DataViewing()
--@brief:数据记录标志位
--@param:
-------------------------------------------------------------------------------
function IM_DataViewing(user,program,steps)

    if IMUserStepsDataBuf[user][program][steps]==7 and get_current_screen() == IMScreenID then
        g_IM_DataViewing = 1   --进入数据记录标志位
    elseif IMUserStepsDataBuf[user][program][steps]~=7 and get_current_screen() == IMScreenID then
        g_IM_DataViewing = 0   --不记录数据
    end
end
-----------------------------------------------------------------------------
--@program:IM_Washing
--@brief:自动清洗
--@param:
--@param:
--@param:
--@return:
-------------------------------------------------------------------------------
function IM_Washing_Show()

    if workingMode ~= 1 then
        set_value(IMScreenID,IM_WashingIcon,0+Language*1+g_SetDarkModeFlag*2)
        set_visiable(IMScreenID,IM_WashingIcon,ENABLE) 
    else                               
        set_visiable(IMScreenID,IM_WashingIcon,DISABLE)
    end

end
-----------------------------------------------------------------------------
--@program:IM_Washing
--@brief:自动清洗
--@param:
-------------------------------------------------------------------------------
function IM_Washing()

    if workingMode ~= 1 then
        change_child_screen(4)   
        SystemMode=4
        POP_WindowNum=13        
        WindowScreen_Show()
    end

end
-----------------------------------------------------------------------------
--@program:IM_DataViewing_Show
--@brief:数据查看
--@param:
--@param:
--@param:
--@return:
-------------------------------------------------------------------------------
function IM_DataViewing_Show(user, program, steps)

    if workingMode ~= 1 then
        --if IMUserStepsDataBuf[user][program][steps] == 7 then
            set_value(IMScreenID,IM_DataViewingIcon,0+Language*2+g_SetDarkModeFlag*4)
            set_visiable(IMScreenID,IM_DataViewingIcon,ENABLE) 
       -- else    
            --set_value(IMScreenID,IM_DataViewingIcon,0+Language*2+g_SetDarkModeFlag*4+1)
            --set_visiable(IMScreenID,IM_DataViewingIcon,ENABLE)             
       -- end
    else                               
        set_visiable(IMScreenID,IM_DataViewingIcon,DISABLE)
    end

end
-----------------------------------------------------------------------------
--@program:IMTorque_Progress_Bars_Show(user, program, steps)
--@brief:扭力进度条显示
--@param:user:用户ID
--@param:program:用户选中的当前程序
--@param:steps:选中的步骤
--@return:无
-------------------------------------------------------------------------------
function IMTorque_Progress_Bars_Show(user, program, steps)

    if IMUserStepsDataBuf[user][program][steps] > 0  and IMUserStepsDataBuf[user][program][steps] < 9 and workingMode == 1 then
        set_value(IMScreenID,IM_Torque_Progress_Bars_Icon,IM_TorqueLooperNum-1+g_SetDarkModeFlag*11)
        set_visiable(IMScreenID,IM_Torque_Progress_Bars_Icon,ENABLE) 
    else                               
        set_visiable(IMScreenID,IM_Torque_Progress_Bars_Icon,DISABLE)
    end

end
-----------------------------------------------------------------------------
--@program:IM_SetSpeedTorqueMaxMin
--@brief:种植步骤速速和扭力的最大值和最小值
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IM_SetSpeedTorqueMaxMin(user, program, steps)
    local ratio = 0
    if user == 1 then
        ratio = IM_User1ProgramBuf[program][steps][3]
    elseif user == 2 then
        ratio = IM_User2ProgramBuf[program][steps][3]
    elseif user == 3 then
        ratio = IM_User3ProgramBuf[program][steps][3]
    end

    if(IMUserStepsDataBuf[user][program][steps] ==12 )then    --冲水模式
        IM_MaxSetSpeed=0
        IM_MinSetSpeed=0
        IM_MaxSetTorque=0
        IM_MinSetTorque=0
    elseif(IMUserStepsDataBuf[user][program][steps] ==11 and ratio == 12)then
        IM_MaxSetSpeed=2000
        IM_MinSetSpeed=15
        IM_MaxSetTorque=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][4]
        IM_MinSetTorque=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][3]
    elseif IMUserStepsDataBuf[user][program][steps] ~= 0 then
        IM_MaxSetSpeed=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][2]
        IM_MinSetSpeed=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][1]
        IM_MaxSetTorque=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][4]
        IM_MinSetTorque=IM_ProgramMaxMin[IMUserStepsDataBuf[user][program][steps]][3]
    end
end
-----------------------------------------------------------------------------
--@program:IM_RatioSpeedMaxMin
--@brief:种值速比限制的最大值和最小值
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IM_RatioSpeedMaxMin(user, program, steps)
    local ratio = 0
    if(IMUserStepsDataBuf[user][program][steps]~=12  and workingMode~=1)then    --不等于工作模式和冲水模式
        if user == 1 then
            ratio = IM_User1ProgramBuf[program][steps][3]
        elseif user == 2 then
            ratio = IM_User2ProgramBuf[program][steps][3]
        elseif user == 3 then
            ratio = IM_User3ProgramBuf[program][steps][3]
        end
        print("ratio",ratio)
        print("user",user)

        IM_RatioSpeedMax=AllRatioSpeedMinMax[ratio][2]
        IM_RatioSpeedMin=AllRatioSpeedMinMax[ratio][1]


        if user == 1 then
            if(IM_User1ProgramBuf[program][steps][1]>IM_RatioSpeedMax)--切换转速比后，如果当前速度大于切换后转速比的速度最大值，则等于它
            then
                IM_User1ProgramBuf[program][steps][1]=IM_RatioSpeedMax
            elseif(IM_User1ProgramBuf[program][steps][1]<IM_RatioSpeedMin) --切换转速比后，如果当前速度小于切换后转速比的速度最小值，则等于它
            then
                IM_User1ProgramBuf[program][steps][1]=IM_RatioSpeedMin
            end
        elseif user == 2 then
            if(IM_User2ProgramBuf[program][steps][1]>IM_RatioSpeedMax)--切换转速比后，如果当前速度大于切换后转速比的速度最大值，则等于它
            then
                IM_User2ProgramBuf[program][steps][1]=IM_RatioSpeedMax
            elseif(IM_User2ProgramBuf[program][steps][1]<IM_RatioSpeedMin) --切换转速比后，如果当前速度小于切换后转速比的速度最小值，则等于它
            then
                IM_User2ProgramBuf[program][steps][1]=IM_RatioSpeedMin
            end
        elseif user == 3 then
            if(IM_User3ProgramBuf[program][steps][1]>IM_RatioSpeedMax)--切换转速比后，如果当前速度大于切换后转速比的速度最大值，则等于它
            then
                IM_User3ProgramBuf[program][steps][1]=IM_RatioSpeedMax
            elseif(IM_User3ProgramBuf[program][steps][1]<IM_RatioSpeedMin) --切换转速比后，如果当前速度小于切换后转速比的速度最小值，则等于它
            then
                IM_User3ProgramBuf[program][steps][1]=IM_RatioSpeedMin
            end
        end

    end
end
-----------------------------------------------------------------------------
--@program:Status_Bar_Updata
--@brief:状态栏图标更新
--@param:motor:马达连接标志位
--@param:ble:蓝牙连接标志位
--@param:foot:脚踏连接标志位
--@param:power:脚踏电量
--@param:voice:声音开关标志位
--@param:flashFlag:闪烁标志位
--@param:screenID:更新ID为screenID的状态栏
--@return:无
-------------------------------------------------------------------------------
function Status_Bar_Updata(motor, ble, foot, power, voice, flashFlag, screenID)
    set_visible(screenID, Status_Bar_Motor, motor)      --状态栏马达图标更新
    set_visible(screenID, Status_Bar_Ble, ble)          --状态栏蓝牙图标更新
    set_visible(screenID, Status_Bar_Voice, voice)          --状态栏声音图标更新
    if foot ~= DISABLE then     --若脚踏连接
        set_visible(screenID, Status_Bar_Foot, ENABLE)          --状态栏脚踏图标显示
        if ble == ENABLE then
            set_visible(screenID, Status_Bar_FootPower, ENABLE)          --状态栏脚踏电量图标显示
            set_value(screenID, Status_Bar_FootPower, power)          --状态栏脚踏电量图标更新
        else
            set_visible(screenID, Status_Bar_FootPower, DISABLE)          --状态栏脚踏电量图标隐藏
        end

    elseif foot == DISABLE then     --若无脚踏连接
        set_visible(screenID, Status_Bar_FootPower, DISABLE)          --状态栏脚踏电量图标隐藏
        set_visible(screenID, Status_Bar_Foot, flashFlag)          --状态栏脚踏图标闪烁
    end
end

-----------------------------------------------------------------------------
--@program:IMProgram_Change
--@brief:当前程序切换
--@param:user:用户ID
--@return:无
-------------------------------------------------------------------------------
function IMProgram_Change(user)
    Promgrame[user] = Promgrame[user] + 1
    if Promgrame[user] > 5 then
        Promgrame[user] = 1
    end
    Temp_Steps = Steps[user][Promgrame[user]] --更新选择的步骤位号
    IMRatio_Matching(user,Promgrame[user],Temp_Steps)      --用户速比匹配
end

-----------------------------------------------------------------------------
--@program:IMProgram_Show
--@brief:当前程序显示
--@param:user:用户ID
--@return:无
-------------------------------------------------------------------------------
function IMProgram_Show(user)
    set_value(IMScreenID,IM_ProgramBackground_Icon,g_SetDarkModeFlag)
    set_value(IMScreenID,IM_Program_Icon,Promgrame[user]-1+g_SetDarkModeFlag*5)
end

-----------------------------------------------------------------------------
--@program:IMStep_Change
--@brief:当前步骤切换
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IMStep_Change(control, program, user)

    if control == IM_Step1_Button then      --表示步骤1，按下了步骤栏上面的第一个按钮
        Steps[user][program] = 1
    elseif control == IM_Step2_Button then  --表示步骤2，按下了步骤栏上面的第二个按钮
        Steps[user][program] = 2
    elseif control == IM_Step3_Button then  --表示步骤3，按下了步骤栏上面的第三个按钮
        Steps[user][program] = 3
    elseif control == IM_Step4_Button then  --表示步骤4，按下了步骤栏上面的第四个按钮
        Steps[user][program] = 4
    elseif control == IM_Step5_Button then  --表示步骤5，按下了步骤栏上面的第五个按钮
        Steps[user][program] = 5
    elseif control == IM_Step6_Button then  --表示步骤6，按下了步骤栏上面的第六个按钮
        Steps[user][program] = 6
    elseif control == IM_Step7_Button then  --表示步骤7，按下了步骤栏上面的第七个按钮
        Steps[user][program] = 7
    elseif control == IM_Step8_Button then  --表示步骤8，按下了步骤栏上面的第八个按钮
        Steps[user][program] = 8
    end
    Temp_Steps = Steps[user][program] --更新选择的步骤位号

    IMRatio_Matching(user,program,Temp_Steps)  --转速比与当前步骤匹配
end


-----------------------------------------------------------------------------
--@program:IMBigStep_Change
--@brief:大图标步骤切换
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IMBigStep_Change(program, user)

    Steps[user][program] = Steps[user][program]+1
    if Steps[user][program] > IM_Step_ProNum[user][program] then
            Steps[user][program] = 1
    end
end
-----------------------------------------------------------------------------
--@program:IM_Change_User_Screen
--@brief:种植模式切换用户界面
--@param:无
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Change_User_Screen()
    SystemMode=8
    change_screen(8)
    g_UserSetFlag = 0
    UserScreen_Show()
    --KeyBeep_App()

    --start_timer(g_UserCountBackTime_1s, 1000, 0, 0) --开启倒数定时器
end
-----------------------------------------------------------------------------
--@program:IM_Change_SR_Change
--@brief:种植模式与外壳模式切换
--@param:无
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Change_SR_Change()
    Motordirection=0
    ScreenSetDire=0
    SystemMode=2
    change_screen(2)
    SRScreen_Show()
    ChangeStep_SystemMode=1
    --KeyBeep_App()
    StartFlashWrite_App()
end
-----------------------------------------------------------------------------
--@program:IM_Change_SR_Change_Show()
--@brief:种植模式与外壳模式切换按键显示
--@param：无
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Change_SR_Change_Show()
    if(workingMode~=1)then
        set_value(IMScreenID,IM_Change_SR_Icon,0+Language*2+g_SetDarkModeFlag*4)           --种植与外壳切换图标
        set_visiable(IMScreenID,IM_Change_SR_Icon,1)        -- 显示种植与外壳切换图标       
    else
        set_visiable(IMScreenID,IM_Change_SR_Icon,0)        -- 显示种植与外壳切换图标   
    end
end
-----------------------------------------------------------------------------
--@program:IM_Set_Mode()
--@brief:种植设置模式
--@param:无
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Mode()
    SystemMode=3
    SystemModeBeforSet=IMScreenID
    change_screen(3)
    SetScreen_Show()
    --KeyBeep_App()
end
-----------------------------------------------------------------------------
--@program:IM_Change_SR_Change_Show()
--@brief:种植模式与外壳模式切换按键显示
--@param：无
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Mode_Show()
    if(workingMode~=1)then
        set_value(IMScreenID,IM_Set_Icon,0+Language*2+g_SetDarkModeFlag*4)           --设置图标
        set_visiable(IMScreenID,IM_Set_Icon,1)
    else
        set_visiable(IMScreenID,IM_Set_Icon,0)
    end
end
-----------------------------------------------------------------------------
--@program:IM_Dire_Change()
--@brief:种植模式电机方向
--@param:不分用户
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Dire_Change(user, program, steps)
    if(workingMode~=1 and IMUserStepsDataBuf[user][program][steps]~=12 )then    --不等于工作模式和冲水模式
        ScreenSetDire=ScreenSetDire+1     
        if(ScreenSetDire==2)
        then
            ScreenSetDire=0
        end 
        Motordirection=ScreenSetDire
        DireBtnFlag=1   
        --KeyBeep_App()      -- 
    end
end
-----------------------------------------------------------------------------
--@program:IM_Dire_Change_Show()
--@brief:种植模式电机方向
--@param:不分用户
--@param:无
--@return:无
-------------------------------------------------------------------------------
function IM_Dire_Change_Show(user, program, steps)
    if( IMUserStepsDataBuf[user][program][steps]==12 )then        --冲水模式
        --if(workingMode~=1)then
            --set_value(IMScreenID,IM_MotordirectionIcon,2+g_SetDarkModeFlag*3)           --2代表灰色图标
            --set_visiable(IMScreenID,IM_MotordirectionIcon,1)
        --else
            set_visiable(IMScreenID,IM_MotordirectionIcon,0)               
        --end
    else    
        if(workingMode~=1)then    --防止与闪烁图标冲突
            set_value(IMScreenID,IM_MotordirectionIcon,Motordirection+g_SetDarkModeFlag*3)           --
            set_visiable(IMScreenID,IM_MotordirectionIcon,1)
        end            --             
    end
end
-----------------------------------------------------------------------------
--@program:IMStep_Show
--@brief:步骤栏显示
--@param:user:用户ID
--@param:steps:选中的步骤
--@return:无
-------------------------------------------------------------------------------
function IMStep_Show(user, program, steps)

    for i = 1, 8, 1 do
        IMStepsDisplayBuf[i] = IMUserStepsDataBuf[user][program][i]
    end

    for number = 1, 8, 1 do
        if number == steps then
            set_value( IMScreenID,number+1,IMStepsDisplayBuf[number]+13+Language*26+g_SetDarkModeFlag*52 )      --高亮显示
            set_visiable( IMScreenID,number+1,ENABLE )
        else
            set_value( IMScreenID,number+1,IMStepsDisplayBuf[number]+Language*26+g_SetDarkModeFlag*52 )         --显示灰色
            set_visiable( IMScreenID,number+1,ENABLE )
        end
        if IMStepsDisplayBuf[number] == 0 then
            set_visiable( IMScreenID,number+9,DISABLE )    --失能不显示步骤区域按键
        elseif IMStepsDisplayBuf[number] ~= 0 then
            set_visiable( IMScreenID,number+9,ENABLE )    --使能显示步骤区域按键
        end
    end

end

-----------------------------------------------------------------------------
--@program:IMBigStep_Show
--@brief:大步骤显示
--@param:user:用户ID
--@param:steps:选中的步骤
--@return:无
-------------------------------------------------------------------------------
function IMBigStep_Show(user, program, steps)

    set_value( IMScreenID,IM_BigStep_Icon,IMUserStepsDataBuf[user][program][steps]-1+Language*12+g_SetDarkModeFlag*24)         --显示大步骤图标
    set_visiable( IMScreenID,IM_BigStep_Icon,ENABLE )    --失能不显示步骤区域按

end

-----------------------------------------------------------------------------
--@program:IMAddSub_Show
--@brief:加减号显示
--@param:user:用户ID
--@param:program:用户选中的当前程序
--@param:steps:选中的步骤
--@return:无
-------------------------------------------------------------------------------
function IMAddSub_Show(user, program, steps)

    set_value(IMScreenID,IM_TopAddSub_Icon,g_SetDarkModeFlag)
    set_value(IMScreenID,IM_MidAddSub_Icon,g_SetDarkModeFlag)
    set_value(IMScreenID,IM_BottomAddSub_Icon,g_SetDarkModeFlag)
    if IMUserStepsDataBuf[user][program][steps] == 12 or workingMode==1 then      --冲水步骤或者工作模式，不显示加减号，全部加减按键失能
        set_visiable(IMScreenID,IM_TopAddSub_Icon,DISABLE)
        set_enable(IMScreenID,IM_TopAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_TopSub_Button,DISABLE)
        set_visiable(IMScreenID,IM_MidAddSub_Icon,DISABLE)
        set_enable(IMScreenID,IM_MidAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_MidSub_Button,DISABLE)
        set_visiable(IMScreenID,IM_BottomAddSub_Icon,DISABLE)
        set_enable(IMScreenID,IM_BottomAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_BottomSub_Button,DISABLE)
    elseif IMUserStepsDataBuf[user][program][steps] == 10 or IMUserStepsDataBuf[user][program][steps] == 11 or IMUserStepsDataBuf[user][program][steps] == 9 then
        set_visiable(IMScreenID,IM_TopAddSub_Icon,DISABLE)               --高速跟低速步骤，只显示只使能中间的加减号
        set_enable(IMScreenID,IM_TopAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_TopSub_Button,DISABLE)
        set_visiable(IMScreenID,IM_MidAddSub_Icon,ENABLE)
        set_enable(IMScreenID,IM_MidAdd_Button,ENABLE)
        set_enable(IMScreenID,IM_MidSub_Button,ENABLE)
        set_visiable(IMScreenID,IM_BottomAddSub_Icon,DISABLE)
        set_enable(IMScreenID,IM_BottomAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_BottomSub_Button,DISABLE)
    else                                        --别的步骤，显示使能上下的加减号
        set_visiable(IMScreenID,IM_TopAddSub_Icon,ENABLE)
        set_enable(IMScreenID,IM_TopAdd_Button,ENABLE)
        set_enable(IMScreenID,IM_TopSub_Button,ENABLE)
        set_visiable(IMScreenID,IM_MidAddSub_Icon,DISABLE)
        set_enable(IMScreenID,IM_MidAdd_Button,DISABLE)
        set_enable(IMScreenID,IM_MidSub_Button,DISABLE)
        set_visiable(IMScreenID,IM_BottomAddSub_Icon,ENABLE)
        set_enable(IMScreenID,IM_BottomAdd_Button,ENABLE)
        set_enable(IMScreenID,IM_BottomSub_Button,ENABLE)
    end

end



-----------------------------------------------------------------------------
--@program:IMFlush_Show
--@brief:冲水动画中间区域显示
--@param:user:用户ID
--@param:program:用户选中的当前程序
--@param:steps:选中的步骤
--@return:无
-------------------------------------------------------------------------------
function IMFlush_Show(user, program, steps)

    if workingMode ~= 1 then
        set_value(IMScreenID,IM_WaterFlush_Icon,0+g_SetDarkModeFlag*4)
    end
    if IMUserStepsDataBuf[user][program][steps] == 12 then      --冲水步骤，显示冲水工作图标
        set_visiable(IMScreenID,IM_WaterFlush_Icon,ENABLE)
    else                                        --别的步骤，不显示冲水工作图标
        set_visiable(IMScreenID,IM_WaterFlush_Icon,DISABLE)
    end

end


-----------------------------------------------------------------------------
--@program:IMWater_Change
--@brief:当前水量切换
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMWater_Change(user,program,steps)
    local water
    if user == 1 then
        water = IM_User1ProgramBuf[program][steps][4]
        water = water + 1
        IM_User1ProgramBuf[program][steps][4] = water%5
    elseif user == 2 then
        water = IM_User2ProgramBuf[program][steps][4]
        water = water + 1
        IM_User2ProgramBuf[program][steps][4] = water%5
    elseif user == 3 then
        water = IM_User3ProgramBuf[program][steps][4]
        water = water + 1
        IM_User3ProgramBuf[program][steps][4] = water%5
    end
end


-----------------------------------------------------------------------------
--@program:IMWater_Show
--@brief:当前水量显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMWater_Show(user,program,steps)
    local water
    if user == 1 then
        water = IM_User1ProgramBuf[program][steps][4]
        set_value(IMScreenID,IM_Water_Icon,water+g_SetDarkModeFlag*5)
    elseif user == 2 then
        water = IM_User2ProgramBuf[program][steps][4]
        set_value(IMScreenID,IM_Water_Icon,water+g_SetDarkModeFlag*5)
    elseif user == 3 then
        water = IM_User3ProgramBuf[program][steps][4]
        set_value(IMScreenID,IM_Water_Icon,water+g_SetDarkModeFlag*5)
    end
end


-----------------------------------------------------------------------------
--@program:IMLED_Change
--@brief:当前LED切换
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMLED_Change(user,program,steps)
    local led
    if user == 1 then
        led = IM_User1ProgramBuf[program][steps][5]
        led = led + 1
        IM_User1ProgramBuf[program][steps][5] = led%3
    elseif user == 2 then
        led = IM_User2ProgramBuf[program][steps][5]
        led = led + 1
        IM_User2ProgramBuf[program][steps][5] = led%3
    elseif user == 3 then
        led = IM_User3ProgramBuf[program][steps][5]
        led = led + 1
        IM_User3ProgramBuf[program][steps][5] = led%3
    end
end


-----------------------------------------------------------------------------
--@program:IMLED_Show
--@brief:当前LED显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMLED_Show(user,program,steps)
    local led
    if(IMUserStepsDataBuf[user][program][steps] == 9)then  --骨锯
        --if workingMode ~= 1 then
            --led = 0
            --set_value(IMScreenID,IM_LED_Icon,led+g_SetDarkModeFlag*3)
            --set_visiable(IMScreenID,IM_LED_Icon,ENABLE)
        --else
            set_visiable(IMScreenID,IM_LED_Icon,DISABLE)
        --end
    else   
        if user == 1 then
            led = IM_User1ProgramBuf[program][steps][5]
            set_value(IMScreenID,IM_LED_Icon,led+g_SetDarkModeFlag*3)
            set_visiable(IMScreenID,IM_LED_Icon,ENABLE)
        elseif user == 2 then
            led = IM_User2ProgramBuf[program][steps][5]
            set_value(IMScreenID,IM_LED_Icon,led+g_SetDarkModeFlag*3)
            set_visiable(IMScreenID,IM_LED_Icon,ENABLE)
        elseif user == 3 then
            led = IM_User3ProgramBuf[program][steps][5]
            set_value(IMScreenID,IM_LED_Icon,led+g_SetDarkModeFlag*3)
            set_visiable(IMScreenID,IM_LED_Icon,ENABLE)
        end
    end    
end

-----------------------------------------------------------------------------
--@program:IMRatio_Change
--@brief:当前速比切换
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无      步骤切换用
-------------------------------------------------------------------------------
function IMRatio_Change(user,program,steps)
    local ratio
    if IMUserStepsDataBuf[user][program][steps] == 12 then
        MaxRatio = 16
        MinRatio = 16
    elseif IMUserStepsDataBuf[user][program][steps] == 10 then --高速
        MaxRatio = 5
        MinRatio = 1
    elseif IMUserStepsDataBuf[user][program][steps] == 11 then  --低速
        MaxRatio = 12
        MinRatio = 6
    elseif IMUserStepsDataBuf[user][program][steps] == 9 then
        MaxRatio = 6
        MinRatio = 6
    else
        MaxRatio = 15
        MinRatio = 11
    end

    if user == 1 then
        ratio = IM_User1ProgramBuf[program][steps][3]
        if IMUserStepsDataBuf[user][program][steps] == 11 and ratio ==6  then  --低速模式不需要3.2和3.4
            ratio = ratio + 3
        else   
            ratio = ratio + 1 
        end
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User1ProgramBuf[program][steps][3] = ratio
    elseif user == 2 then
        ratio = IM_User2ProgramBuf[program][steps][3]
        if IMUserStepsDataBuf[user][program][steps] == 11 and ratio ==6  then
            ratio = ratio + 3
        else   
            ratio = ratio + 1 
        end
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User2ProgramBuf[program][steps][3] = ratio
    elseif user == 3 then
        ratio = IM_User3ProgramBuf[program][steps][3]
        if IMUserStepsDataBuf[user][program][steps] == 11 and ratio ==6  then
            ratio = ratio + 3
        else   
            ratio = ratio + 1 
        end
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User3ProgramBuf[program][steps][3] = ratio
    end
end

-----------------------------------------------------------------------------
--@program:IMRatio_Matching
--@brief:速比匹配，在切换步骤跟切换程序时若速比不在范围内，则自动匹配
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无    切换步骤用的
-------------------------------------------------------------------------------
function IMRatio_Matching(user,program,steps)

    local ratio
    if IMUserStepsDataBuf[user][program][steps] == 12 then
        MaxRatio = 16
        MinRatio = 16
    elseif IMUserStepsDataBuf[user][program][steps] == 10 then
        MaxRatio = 5
        MinRatio = 1
    elseif IMUserStepsDataBuf[user][program][steps] == 11 then --低速
        MaxRatio = 12
        MinRatio = 6
    elseif IMUserStepsDataBuf[user][program][steps] == 9 then
        MaxRatio = 6
        MinRatio = 6
    else
        MaxRatio = 15
        MinRatio = 11
    end

    if user == 1 then
        ratio = IM_User1ProgramBuf[program][steps][3]
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User1ProgramBuf[program][steps][3] = ratio
    elseif user == 2 then
        ratio = IM_User2ProgramBuf[program][steps][3]
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User2ProgramBuf[program][steps][3] = ratio
    elseif user == 3 then
        ratio = IM_User3ProgramBuf[program][steps][3]
        if ratio > MaxRatio or ratio < MinRatio then
            ratio = MinRatio
        end
        IM_User3ProgramBuf[program][steps][3] = ratio
    end
end



-----------------------------------------------------------------------------
--@program:IMRatio_Show
--@brief:当前速比显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMRatio_Show(user,program,steps)
    local ratio

    if(IMUserStepsDataBuf[user][program][steps] == 12 )then  --冲水 模式
        --if(workingMode~=1)then
            --set_value(IMScreenID,IM_Ratio_Icon,15+g_SetDarkModeFlag*18)
            --set_visiable(IMScreenID,IM_Ratio_Icon,1)
        --else
            set_visiable(IMScreenID,IM_Ratio_Icon,0)
        --end
    elseif IMUserStepsDataBuf[user][program][steps] == 9 then --骨锯 模式
        set_visiable(IMScreenID,IM_Ratio_Icon,0)
    else
        if user == 1 then
            ratio = IM_User1ProgramBuf[program][steps][3]
            set_value(IMScreenID,IM_Ratio_Icon,ratio-1+g_SetDarkModeFlag*18)
            set_visiable(IMScreenID,IM_Ratio_Icon,1)
        elseif user == 2 then
            ratio = IM_User2ProgramBuf[program][steps][3]
            set_value(IMScreenID,IM_Ratio_Icon,ratio-1+g_SetDarkModeFlag*18)
            set_visiable(IMScreenID,IM_Ratio_Icon,1)
        elseif user == 3 then
            ratio = IM_User3ProgramBuf[program][steps][3]
            set_value(IMScreenID,IM_Ratio_Icon,ratio-1+g_SetDarkModeFlag*18)
            set_visiable(IMScreenID,IM_Ratio_Icon,1)
        end
    end
end


-----------------------------------------------------------------------------
--@program:IMSpeed_Add
--@brief:当前速度加
--@param:speed:需要修改的速度
--@return:修改后的速度
-------------------------------------------------------------------------------
function IMSpeed_Add(speed)

    if speed < 100 then
        speed = speed + 5
    elseif speed < 3000 then
        speed = speed + 100
    elseif speed < 40000 then
        speed = speed + 1000
    else
       speed = speed + 10000
    end

    return speed
end

-----------------------------------------------------------------------------
--@program:IMTorque_Add
--@brief:当前扭矩加
--@param:speed:需要修改的速度
--@return:修改后的速度
-------------------------------------------------------------------------------
function IMTorque_Add(torque)
    torque = torque + 5
    return torque
end



-----------------------------------------------------------------------------
--@program:IMSpeed_Sub
--@brief:当前速度减
--@param:speed:需要修改的速度
--@return:修改后的速度
-------------------------------------------------------------------------------
function IMSpeed_Sub(speed)

    if speed > 40000 then
        speed = speed - 10000
    elseif speed > 3000 then
        speed = speed - 1000
    elseif speed > 100 then
        speed = speed - 100
    elseif speed > 5 then
        speed = speed - 5
    end
    return speed

end


-----------------------------------------------------------------------------
--@program:IMTorque_Sub
--@brief:当前扭矩减
--@param:speed:需要修改的速度
--@return:修改后的速度
-------------------------------------------------------------------------------
function IMTorque_Sub(torque)
    torque = torque - 5
    return torque
end




-----------------------------------------------------------------------------
--@program:SpeedNumber_Display
--@brief:速度显示
--@param:speed:要显示的速度
--@return:无
-------------------------------------------------------------------------------
function SpeedNumber_Display(speed,user,program,steps)
    if IMUserStepsDataBuf[user][program][steps] == 10 or IMUserStepsDataBuf[user][program][steps] == 11 or IMUserStepsDataBuf[user][program][steps] == 9 then
        set_value(IMScreenID,IM_SpeedTorque_Text,1+Language*2+g_SetDarkModeFlag*4)
        set_visiable(IMScreenID,IM_SpeedTorque_Text,ENABLE) 

        set_visiable(IMScreenID,IM_Speed_FirstNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_SecondNum,DISABLE)         --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_ThirdNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_FourthNum,DISABLE)         --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏

        set_visiable(IMScreenID,IM_Speed_Zero,DISABLE)          --显示/隐藏
        if speed < 100 then
            set_value(IMScreenID,IM_Speed_SenventhNum,speed//10%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EighthNum,speed%10+g_SetDarkModeFlag*10)
                

            set_visiable(IMScreenID,IM_Speed_SenventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EighthNum,ENABLE)         --显示/隐藏

            set_visiable(IMScreenID,IM_Speed_NinethNum,DISABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TenthNum,DISABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EleventhNum,DISABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TwelfthNum,DISABLE)          --显示/隐藏
    
        elseif speed < 1000 and speed >= 100 then
            set_value(IMScreenID,IM_Speed_SenventhNum,speed//100%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EighthNum,speed//10%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_NinethNum,speed%10+g_SetDarkModeFlag*10)
                
            set_visiable(IMScreenID,IM_Speed_SenventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EighthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_NinethNum,ENABLE)          --显示/隐藏

            set_visiable(IMScreenID,IM_Speed_TenthNum,DISABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EleventhNum,DISABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TwelfthNum,DISABLE)          --显示/隐藏
    
        elseif speed < 10000 and speed >= 1000 then
            set_value(IMScreenID,IM_Speed_SenventhNum,speed//1000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EighthNum,speed//100%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_NinethNum,speed//10%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_TenthNum,speed%10+g_SetDarkModeFlag*10)

            set_visiable(IMScreenID,IM_Speed_SenventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EighthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_NinethNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TenthNum,ENABLE)         --显示/隐藏

            set_visiable(IMScreenID,IM_Speed_EleventhNum,DISABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TwelfthNum,DISABLE)          --显示/隐藏

        elseif speed < 100000 and speed >= 10000 then
            set_value(IMScreenID,IM_Speed_SenventhNum,speed//10000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EighthNum,speed//1000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_NinethNum,speed//100%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_TenthNum,speed//10%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EleventhNum,speed%10+g_SetDarkModeFlag*10)

            set_visiable(IMScreenID,IM_Speed_SenventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EighthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_NinethNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TenthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EleventhNum,ENABLE)          --显示/隐藏

            set_visiable(IMScreenID,IM_Speed_TwelfthNum,DISABLE)          --显示/隐藏
        else

            set_value(IMScreenID,IM_Speed_SenventhNum,speed//100000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EighthNum,speed//10000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_NinethNum,speed//1000%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_TenthNum,speed//100%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_EleventhNum,speed//10%10+g_SetDarkModeFlag*10)
            set_value(IMScreenID,IM_Speed_TwelfthNum,speed%10+g_SetDarkModeFlag*10)

            set_visiable(IMScreenID,IM_Speed_SenventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EighthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_NinethNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TenthNum,ENABLE)         --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_EleventhNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Speed_TwelfthNum,ENABLE)          --显示/隐藏

        end
    else
        if IMUserStepsDataBuf[user][program][steps] == 12  and workingMode==1 then    --冲水模式
            set_visiable(IMScreenID,IM_SpeedTorque_Text,DISABLE) 
        else
            set_value(IMScreenID,IM_SpeedTorque_Text,0+Language*2+g_SetDarkModeFlag*4)
            set_visiable(IMScreenID,IM_SpeedTorque_Text,ENABLE) 
        end
        set_visiable(IMScreenID,IM_Speed_SenventhNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_EighthNum,DISABLE)         --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_NinethNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_TenthNum,DISABLE)         --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_EleventhNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Speed_TwelfthNum,DISABLE)          --显示/隐藏

        if speed == 0 then
            if (workingMode~=1) then
                set_visiable(IMScreenID,IM_Speed_Zero,ENABLE)           --显示/隐藏 --
                set_visiable(IMScreenID,IM_Speed_FirstNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏
            else        --在工作状态
                set_visiable(IMScreenID,IM_Speed_Zero,DISABLE)          --显示/隐藏
                if IMUserStepsDataBuf[user][program][steps] == 12 then
                    set_visiable(IMScreenID,IM_Speed_FirstNum,DISABLE)          --显示/隐藏
                else
                    set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)          --显示/隐藏
                    set_value(IMScreenID,IM_Speed_FirstNum,0+g_SetDarkModeFlag*10)  --显示0
                end
                set_visiable(IMScreenID,IM_Speed_SecondNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏
            end
            
        else
            set_visiable(IMScreenID,IM_Speed_Zero,DISABLE)          --显示/隐藏
            if speed < 100 then
                set_value(IMScreenID,IM_Speed_FirstNum,speed//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SecondNum,speed%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,ENABLE)          --显示/隐藏

                set_visiable(IMScreenID,IM_Speed_ThirdNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏
            elseif speed < 1000 and speed >= 100 then
                set_value(IMScreenID,IM_Speed_FirstNum,speed//100%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SecondNum,speed//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_ThirdNum,speed%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,ENABLE)          --显示/隐藏

                set_visiable(IMScreenID,IM_Speed_FourthNum,DISABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏
            elseif speed < 10000 and speed >= 1000 then
                set_value(IMScreenID,IM_Speed_FirstNum,speed//1000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SecondNum,speed//100%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_ThirdNum,speed//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_FourthNum,speed%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,ENABLE)         --显示/隐藏

                set_visiable(IMScreenID,IM_Speed_FifthNum,DISABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏

            elseif speed < 100000 and speed >= 10000 then
                set_value(IMScreenID,IM_Speed_FirstNum,speed//10000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SecondNum,speed//1000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_ThirdNum,speed//100%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_FourthNum,speed//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_FifthNum,speed%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,ENABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,ENABLE)          --显示/隐藏

                set_visiable(IMScreenID,IM_Speed_SixthNum,DISABLE)          --显示/隐藏
            else
                set_value(IMScreenID,IM_Speed_FirstNum,speed//100000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SecondNum,speed//10000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_ThirdNum,speed//1000%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_FourthNum,speed//100%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_FifthNum,speed//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Speed_SixthNum,speed%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Speed_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SecondNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_ThirdNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FourthNum,ENABLE)         --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_FifthNum,ENABLE)          --显示/隐藏
                set_visiable(IMScreenID,IM_Speed_SixthNum,ENABLE)          --显示/隐藏

            end
        end
    end


    
end

-----------------------------------------------------------------------------
--@program:TorqueNumber_Display
--@brief:扭矩数字显示
--@param:speed:要显示的扭矩
--@return:无
-------------------------------------------------------------------------------
function TorqueNumber_Display(torque,user,program,steps)

    if IMUserStepsDataBuf[user][program][steps] == 10 or IMUserStepsDataBuf[user][program][steps] == 11 or IMUserStepsDataBuf[user][program][steps] == 9 then
        set_visiable(IMScreenID,IM_Torque_FirstNum,DISABLE)           --显示/隐藏
        set_visiable(IMScreenID,IM_Torque_SecondNum,DISABLE)          --显示/隐藏
        set_visiable(IMScreenID,IM_Torque_Zero,DISABLE)          --显示/隐藏 --
    else
        if torque == 0 then
            set_visiable(IMScreenID,IM_Torque_FirstNum,DISABLE)           --显示/隐藏
            set_visiable(IMScreenID,IM_Torque_SecondNum,DISABLE)          --显示/隐藏
            if workingMode~=1 then
                set_visiable(IMScreenID,IM_Torque_Zero,ENABLE)          --显示/隐藏 --
            else
                set_visiable(IMScreenID,IM_Torque_Zero,DISABLE)          --显示/隐藏 --
                if torque < 10 and IMUserStepsDataBuf[user][program][steps] ~= 12 then
                    set_value(IMScreenID,IM_Torque_FirstNum,torque%10+g_SetDarkModeFlag*10)
    
                    set_visiable(IMScreenID,IM_Torque_FirstNum,ENABLE)           --显示/隐藏
                    set_visiable(IMScreenID,IM_Torque_SecondNum,DISABLE)          --显示/隐藏
                elseif torque >= 10 and torque < 100 then
                    set_value(IMScreenID,IM_Torque_FirstNum,torque//10%10+g_SetDarkModeFlag*10)
                    set_value(IMScreenID,IM_Torque_SecondNum,torque%10+g_SetDarkModeFlag*10)
    
                    set_visiable(IMScreenID,IM_Torque_FirstNum,ENABLE)           --显示/隐藏
                    set_visiable(IMScreenID,IM_Torque_SecondNum,ENABLE)          --显示/隐藏
                end
            end
        else
            set_visiable(IMScreenID,IM_Torque_FirstNum,ENABLE)           --显示/隐藏
            set_visiable(IMScreenID,IM_Torque_SecondNum,ENABLE)          --显示/隐藏
            set_visiable(IMScreenID,IM_Torque_Zero,DISABLE)          --显示/隐藏 --
            if torque < 10 then
                set_value(IMScreenID,IM_Torque_FirstNum,torque%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Torque_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Torque_SecondNum,DISABLE)          --显示/隐藏
            elseif torque >= 10 and torque < 100 then
                set_value(IMScreenID,IM_Torque_FirstNum,torque//10%10+g_SetDarkModeFlag*10)
                set_value(IMScreenID,IM_Torque_SecondNum,torque%10+g_SetDarkModeFlag*10)

                set_visiable(IMScreenID,IM_Torque_FirstNum,ENABLE)           --显示/隐藏
                set_visiable(IMScreenID,IM_Torque_SecondNum,ENABLE)          --显示/隐藏
            end
        end
    end


end


-----------------------------------------------------------------------------
--@program:IMSpeed_Show
--@brief:当前速度显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMSpeed_Show(user,program,steps)
    local speed
    if user == 1 then
        if workingMode~=1 then
            speed = IM_User1ProgramBuf[program][steps][1]
        else
            speed = RecveSpeed
        end
    elseif user == 2 then
        if workingMode~=1 then
            speed = IM_User2ProgramBuf[program][steps][1]
        else
            speed = RecveSpeed
        end
    elseif user == 3 then
        if workingMode~=1 then
            speed = IM_User3ProgramBuf[program][steps][1]
        else
            speed = RecveSpeed
        end
    end
    SpeedNumber_Display(speed,user,program,steps)
end

-----------------------------------------------------------------------------
--@program:IMTorque_Show
--@brief:当前扭矩显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMTorque_Show(user,program,steps)
    local torque
    if user == 1 then
        if workingMode ~= 1 then
           torque = IM_User1ProgramBuf[program][steps][2]
        else
           torque = RecveTorque
        end
    elseif user == 2 then
        if workingMode ~= 1 then
            torque = IM_User2ProgramBuf[program][steps][2]
        else
            torque = RecveTorque
        end
    elseif user == 3 then
        if workingMode ~= 1 then
            torque = IM_User3ProgramBuf[program][steps][2]
        else
            torque = RecveTorque
        end    
    end
    TorqueNumber_Display(torque,user,program,steps)
end
-----------------------------------------------------------------------------
--@program:IMProgramName_Show
--@brief:种植程序名显示
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IMProgramName_Show(user,program)
    if g_SetDarkModeFlag == 1 then
        if #IMUserProgramIDDataBuf[user][program] == 0 then
            set_text(IMScreenID,g_IM_ProgramNameText_Black,IMUserProgramIDDataBuf[user][program])
        else    
            set_text(IMScreenID,g_IM_ProgramNameText_Black,'[  '..IMUserProgramIDDataBuf[user][program]..'  ]')
        end

        set_visiable(IMScreenID,g_IM_ProgramNameText_Black,ENABLE)          --显示/隐藏

        set_visiable(IMScreenID,g_IM_ProgramNameText,DISABLE)          --显示/隐藏
    else
        --set_text(IMScreenID,g_IM_ProgramNameText,IMUserProgramIDDataBuf[user][program] )
        if #IMUserProgramIDDataBuf[user][program] == 0 then
            set_text(IMScreenID,g_IM_ProgramNameText,IMUserProgramIDDataBuf[user][program])
        else
            set_text(IMScreenID,g_IM_ProgramNameText,'[  '..IMUserProgramIDDataBuf[user][program]..'  ]' ) 
        end   
        set_visiable(IMScreenID,g_IM_ProgramNameText,ENABLE)          --显示/隐藏    
        
        set_visiable(IMScreenID,g_IM_ProgramNameText_Black,DISABLE)          --显示/隐藏
    end
end
-----------------------------------------------------------------------------
--@program:IMProgramName_Change
--@brief:种植程序名修改
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IMProgramName_Change()

    if get_current_screen() == IMScreenID then
        
    end
    g_IM_ProgramNameChangeFlag = 0x01


    if g_SetDarkModeFlag == 0 then
        SystemMode=9
        change_screen(9)
    else
        SystemMode=16
        change_screen(16)
    end
    --KeyBeep_App()      
end

-----------------------------------------------------------------------------
--@program:IMScreen_Logical_operations
--@brief:种植界面逻辑操作
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@param:control:控件ID
--@param:value:控件值
--@return:无
-------------------------------------------------------------------------------
function IMScreen_Logical_operations(user,program,steps,control,value)

    IM_SetSpeedTorqueMaxMin(user, program, steps)
    IM_RatioSpeedMaxMin(user, program, steps)

    if (value == ENABLE or value == LongTouch) and (workingMode~=1) and get_current_screen() == IMScreenID then
        if control > 9 and control < 18 then
            Motordirection=0     
            ScreenSetDire=0
            ChangeStep_SystemMode=1
            IMStep_Change(control, program, user)   --用户步骤切换
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
        elseif control == IM_Ratio_Button then
            IMRatio_Change(user,program,steps)      --用户速比切换
            if(IMUserStepsDataBuf[user][program][steps]~=12 and IMUserStepsDataBuf[user][program][steps]~=9)then        --冲水模式
                KeyBeep_App()  --按键音12
                StartFlashWrite_App()
            end
        elseif control == IM_LED_Button and IMUserStepsDataBuf[user][program][steps] ~= 9 then
            IMLED_Change(user,program,steps)        --用户LED切换
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
        elseif control == IM_Water_Button then
            IMWater_Change(user,program,steps)      --用户水量切换
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
        elseif control == IM_BigStep_Button then   
            Motordirection=0     
            ScreenSetDire=0
            ChangeStep_SystemMode=1
            IMBigStep_Change(program, user)         --大图标切换
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
        elseif control == IM_Change_SR_Button then    
            IM_Change_SR_Change()                   --切换外壳模式
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
        elseif control == g_IM_UserNameButton then    
            IM_Change_User_Screen()                   --返回用户设置界面     
            KeyBeep_App()  --按键音 
            SystemModeBeforSet=IMScreenID  
            --StartFlashWrite_App()
        elseif control == IMDataReviewEnter then    --数据查看界面进入
            --if IMUserStepsDataBuf[user][program][steps] == 7 then
                IM_DataReview_Screen_UI_Init(user,program,steps)          --数据查看界面UI初始化
                IM_DataReview_Screen_Enter()
            --end
        elseif control == IM_MotordirectionButton then    
            IM_Dire_Change(user, program, steps)       --方向 
            if(IMUserStepsDataBuf[user][program][steps]~=12)then        --冲水模式
                KeyBeep_App()  --按键音
                StartFlashWrite_App()
            end
        elseif control == IM_Set_Button then    
            IM_Set_Mode()                              --设置按钮
            KeyBeep_App()  --按键音
        elseif control == IM_WashingButton then    
            if MotorHandleFlag==1 then
                IM_Washing()                             --弯机清洗
                KeyBeep_App()  --按键音    
            else    
                ErroBeep_App()                     --取消错误提示音   
                MotorNotConnectedFlg = 1
            end
        elseif control == g_IM_ProgramNameButton  then    
            --IMProgramName_Change()                     --修改程序名  
            --KeyBeep_App()  --按键音
        elseif control == IM_Program_Button and value == LongTouch then  --长按进入步骤设置界面
                IM_Set_DataChangeFlag = 0   --数据改变清零
                change_screen(IM_Set_ScreenID)          --用户程序设置界面
                IM_Set_Screen_Init(user, program, steps)  -----种植模式的步骤编辑界面初始化显示----  
                IM_Set_ProgramName_Show(user,program)
                KeyBeep_App()  --按键音  
        elseif control == IM_TopSub_Button or control == IM_MidSub_Button then  --速度减
            if user == 1 then
                if((IM_User1ProgramBuf[program][steps][1]>IM_MinSetSpeed) and ( IM_User1ProgramBuf[program][steps][1] > IM_RatioSpeedMin))then 
                    IM_User1ProgramBuf[program][steps][1] = IMSpeed_Sub(IM_User1ProgramBuf[program][steps][1])   --用户速度减
                    IM_Usr1DataReview_Buf[program][steps][3] = 0    --查看数据速度清零
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end    
            elseif user == 2 then
                if((IM_User2ProgramBuf[program][steps][1]>IM_MinSetSpeed) and ( IM_User2ProgramBuf[program][steps][1] > IM_RatioSpeedMin))then 
                    IM_User2ProgramBuf[program][steps][1] = IMSpeed_Sub(IM_User2ProgramBuf[program][steps][1])   --用户速度减
                    IM_Usr2DataReview_Buf[program][steps][3] = 0    --查看数据速度清零
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end    
            elseif user == 3 then
                if((IM_User3ProgramBuf[program][steps][1]>IM_MinSetSpeed) and ( IM_User3ProgramBuf[program][steps][1] > IM_RatioSpeedMin))then 
                    IM_User3ProgramBuf[program][steps][1] = IMSpeed_Sub(IM_User3ProgramBuf[program][steps][1])   --用户速度减
                    IM_Usr3DataReview_Buf[program][steps][3] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end    
            end
            StartFlashWrite_App()
        elseif control == IM_TopAdd_Button or control == IM_MidAdd_Button then --速度加
            if user == 1 then
                if((IM_User1ProgramBuf[program][steps][1]<IM_MaxSetSpeed) and (IM_User1ProgramBuf[program][steps][1]<IM_RatioSpeedMax))then     --小于最大
                    IM_User1ProgramBuf[program][steps][1] = IMSpeed_Add(IM_User1ProgramBuf[program][steps][1])
                    IM_Usr1DataReview_Buf[program][steps][3] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 2 then
                if((IM_User2ProgramBuf[program][steps][1]<IM_MaxSetSpeed) and (IM_User2ProgramBuf[program][steps][1]<IM_RatioSpeedMax))then     --小于最大
                    IM_User2ProgramBuf[program][steps][1] = IMSpeed_Add(IM_User2ProgramBuf[program][steps][1])
                    IM_Usr2DataReview_Buf[program][steps][3] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 3 then
                if((IM_User3ProgramBuf[program][steps][1]<IM_MaxSetSpeed) and (IM_User3ProgramBuf[program][steps][1]<IM_RatioSpeedMax))then     --小于最大
                    IM_User3ProgramBuf[program][steps][1] = IMSpeed_Add(IM_User3ProgramBuf[program][steps][1]) 
                    IM_Usr3DataReview_Buf[program][steps][3] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            end

            StartFlashWrite_App()
        elseif  control == IM_BottomSub_Button then     --扭矩
            if user == 1 then
                if(IM_User1ProgramBuf[program][steps][2]>IM_MinSetTorque)then
                    IM_User1ProgramBuf[program][steps][2] = IMTorque_Sub(IM_User1ProgramBuf[program][steps][2])   --用户扭矩减
                    IM_Usr1DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 2 then
                if(IM_User2ProgramBuf[program][steps][2]>IM_MinSetTorque)then
                    IM_User2ProgramBuf[program][steps][2] = IMTorque_Sub(IM_User2ProgramBuf[program][steps][2])   --用户扭矩减
                    IM_Usr2DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 3 then
                if(IM_User3ProgramBuf[program][steps][2]>IM_MinSetTorque)then
                    IM_User3ProgramBuf[program][steps][2] = IMTorque_Sub(IM_User3ProgramBuf[program][steps][2])   --用户扭矩减
                    IM_Usr3DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            end
            StartFlashWrite_App()
        elseif  control == IM_BottomAdd_Button then     --扭矩
            if user == 1 then
                if(IM_User1ProgramBuf[program][steps][2]<IM_MaxSetTorque)then 
                    IM_User1ProgramBuf[program][steps][2] = IMTorque_Add(IM_User1ProgramBuf[program][steps][2])   --用户扭矩加
                    IM_Usr1DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 2 then
                if(IM_User2ProgramBuf[program][steps][2]<IM_MaxSetTorque)then 
                    IM_User2ProgramBuf[program][steps][2] = IMTorque_Add(IM_User2ProgramBuf[program][steps][2])   --用户扭矩加
                    IM_Usr2DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            elseif user == 3 then
                if(IM_User3ProgramBuf[program][steps][2]<IM_MaxSetTorque)then 
                    IM_User3ProgramBuf[program][steps][2] = IMTorque_Add(IM_User3ProgramBuf[program][steps][2])   --用户扭矩加
                    IM_Usr3DataReview_Buf[program][steps][5] = 0
                    KeyBeep_App()  --按键音   
                else    
                    ErroBeep_App()
                end   
            end

            StartFlashWrite_App()
        end

    elseif value == DISABLE and (workingMode~=1) and get_current_screen() == IMScreenID then
        if control == IM_Program_Button then
            Motordirection=0     
            ScreenSetDire=0
            ChangeStep_SystemMode=1         
            IMProgram_Change(user)                  --用户程序切换
            KeyBeep_App()  --按键音
            StartFlashWrite_App()
       end
    end

    if get_current_screen() == IM_Set_ScreenID and value == ENABLE then
        IM_Set_Steps_Operation(user, program, steps, control, value)
    end

    if get_current_screen() == IM_DataReview_ScreenID or get_current_screen() == IM_LineChartMagnify_ScreenID or get_current_screen() == IM_DataEntry_ScreenID or get_current_screen() == IM_Wheel_ScreenID and value == ENABLE then
        IM_DataReview_Operation(user, program, steps, control, value)
    end
end
-----------------------------------------------------------------------------
--@program:IMScreen_UserName_Show()
--@brief:当前图标用户名字
-------------------------------------------------------------------------------
function IMScreen_UserName_Show()
    if g_CurrentUser == 1 then
        set_text(IMScreenID,g_IM_UserNameTextFirst,UserNameBuf[g_CurrentUser])
        set_visiable(IMScreenID,g_IM_UserNameTextFirst,1)

        set_visiable(IMScreenID,g_IM_UserNameTextSecond,0)
        set_visiable(IMScreenID,g_IM_UserNameTextThree,0)
    elseif g_CurrentUser == 2 then
        set_text(IMScreenID,g_IM_UserNameTextSecond,UserNameBuf[g_CurrentUser])
        set_visiable(IMScreenID,g_IM_UserNameTextSecond,1)

        set_visiable(IMScreenID,g_IM_UserNameTextFirst,0)
        set_visiable(IMScreenID,g_IM_UserNameTextThree,0)
    elseif g_CurrentUser == 3 then
        set_text(IMScreenID,g_IM_UserNameTextThree,UserNameBuf[g_CurrentUser])
        set_visiable(IMScreenID,g_IM_UserNameTextThree,1)

        set_visiable(IMScreenID,g_IM_UserNameTextFirst,0)
        set_visiable(IMScreenID,g_IM_UserNameTextSecond,0)
    end
end
-----------------------------------------------------------------------------
--@program:IMScreen_UserNameHead_Show()
--@brief:用户名大写字母
-------------------------------------------------------------------------------
function IMScreen_UserNameHead_Show()
    local FirstNum = "U"
    if g_SetDarkModeFlag == 1 then       
        FirstNum = string.sub(UserNameBuf[g_CurrentUser],1,1)
        set_text(IMScreenID,g_IM_UserHeadText_Black,FirstNum)
        set_visiable(IMScreenID,g_IM_UserHeadText_Black,1)

        set_visiable(IMScreenID,g_IM_UserHeadText,0) 
    else 
        FirstNum = string.sub(UserNameBuf[g_CurrentUser],1,1)
        set_text(IMScreenID,g_IM_UserHeadText,FirstNum)
        set_visiable(IMScreenID,g_IM_UserHeadText,1)

        set_visiable(IMScreenID,g_IM_UserHeadText_Black,0) 
    end
end
-----------------------------------------------------------------------------
--@program:IMScreen_Show
--@brief:种植界面控件显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMScreen_Show(user,program,steps)

    if get_current_screen() == IMScreenID then

        --set_text(1,38,"ScreenSetDire= "..ScreenSetDire)
        --set_text(1,57,"RecveDire="..RecveDire)
        --set_text(1,80,"direction="..Motordirection)
        --set_text(1,86,"DireBtnFlag="..DireBtnFlag)
        
        set_value(IMScreenID,IMBackgroundIcon,0+g_SetDarkModeFlag)
        StateView()  --状态栏
        --显示用户名

        IMProgram_Show(user)
        IMStep_Show(user,program,steps)
        IMWater_Show(user,program,steps)
        IMLED_Show(user,program,steps)
        IMRatio_Show(user,program,steps)
        IMTorque_Show(user,program,steps)
        IMSpeed_Show(user,program,steps)
        IMAddSub_Show(user, program, steps)
        IMFlush_Show(user, program, steps)
        IMBigStep_Show(user, program, steps)
        IM_Change_SR_Change_Show()   --外科模式和种植模式按键
        IM_Dire_Change_Show(user, program, steps)        --方向
        IM_Set_Mode_Show()  --设置按钮
        IMProgramName_Show(user,program)  --显示程序名
        IMTorque_Progress_Bars_Show(user, program, steps) --扭力条
        IM_DataViewing_Show(user, program, steps)     --查看数据
        IM_Washing_Show()         --弯机清洗
        IM_DataViewing(user,program,steps) --数据记录标志位
        IM_Screen_User_Show()
        IMScreen_UserName_Show()
        IMScreen_UserNameHead_Show()
        IM_Screen_Middle_Black_Show()
        IM_Screen_Lower_Row_Black_Show()
    end

end
-----------------------------------------------------------------------------
--@program:IMScreen_Init_Show
--@brief:开机种植界面显示
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:第几位步骤
--@return:无
-------------------------------------------------------------------------------
function IMScreen_Init_Show(user,program,steps)

    --if get_current_screen() == IMScreenID then
        set_value(IMScreenID,IMBackgroundIcon,0+g_SetDarkModeFlag)
        StateView()  --状态栏
        --显示用户名

        IMProgram_Show(user)
        IMStep_Show(user,program,steps)
        IMWater_Show(user,program,steps)
        IMLED_Show(user,program,steps)
        IMRatio_Show(user,program,steps)
        IMTorque_Show(user,program,steps)
        IMSpeed_Show(user,program,steps)
        IMAddSub_Show(user, program, steps)
        IMFlush_Show(user, program, steps)
        IMBigStep_Show(user, program, steps)
        IM_Change_SR_Change_Show()   --外科模式和种植模式按键
        IM_Dire_Change_Show(user, program, steps)        --方向
        IM_Set_Mode_Show()  --设置按钮
        IMProgramName_Show(user,program)  --显示程序名
        IMTorque_Progress_Bars_Show(user, program, steps) --扭力条
        IM_DataViewing_Show(user, program, steps)     --查看数据
        IM_Washing_Show()         --弯机清洗
        IM_DataViewing(user,program,steps) --数据记录标志位
        IM_Screen_User_Show()
        IMScreen_UserName_Show()
        IMScreen_UserNameHead_Show()
        IM_Screen_Middle_Black_Show()
        IM_Screen_Lower_Row_Black_Show()
    --end

end

-------------------------------------种植模式的步骤编辑界面----------------------------------------------

IM_Set_ScreenID = 11
IM_SetBackgroundIcon = 50
IM_Set_Program_Icon = 1       --程序图标
IM_Set_TipText_Icon = 51       --提示文本图标

IM_Set_Empty_Icon = 43       --清空图标
IM_Set_Empty_Button = 46       --清空按钮

IM_Set_Save_Icon = 44       --保存图标
IM_Set_Save_Button = 47       --保存按钮

IM_Set_Exit_Icon = 45       --退出图标
IM_Set_Exit_Button = 48       --退出按钮

-------------------------------------步骤栏------------------------------------------------
IM_Set_Step1_Icon = 2       --步骤1图标
IM_Set_Step1_Button = 10    --步骤1按钮
IM_Set_Step2_Icon = 3       --步骤2图标
IM_Set_Step2_Button = 11    --步骤2按钮
IM_Set_Step3_Icon = 4       --步骤3图标
IM_Set_Step3_Button = 12    --步骤3按钮
IM_Set_Step4_Icon = 5       --步骤4图标
IM_Set_Step4_Button = 13    --步骤4按钮
IM_Set_Step5_Icon = 6       --步骤5图标
IM_Set_Step5_Button = 14    --步骤5按钮
IM_Set_Step6_Icon = 7       --步骤6图标
IM_Set_Step6_Button = 15    --步骤6按钮
IM_Set_Step7_Icon = 8       --步骤7图标
IM_Set_Step7_Button = 16    --步骤7按钮
IM_Set_Step8_Icon = 9       --步骤8图标
IM_Set_Step8_Button = 17    --步骤8按钮
--------------------------------------------------------------------------------------------


-------------------------------------选择框------------------------------------------------
IM_Ball_Drills_Icon = 18       --球钻图标
IM_Ball_Drills_Button = 31    --球钻按钮
IM_Marker_Drills_Icon = 19       --标记钻图标
IM_Marker_Drills_Button = 32    --标记钻按钮
IM_Pioneer_Diamond_Icon = 20       --先锋钻图标
IM_Pioneer_Diamond_Button = 33    --先锋钻按钮
IM_Reamer_Drills_Icon = 21       --扩孔钻图标
IM_Reamer_Drills_Button = 34    --扩孔钻按钮
IM_Forming_Drills_Icon = 22       --成型钻图标
IM_Forming_Drills_Button = 35    --成型钻按钮
IM_Tapping_Drills_Icon = 23       --攻丝钻图标
IM_Tapping_Drills_Button = 36    --攻丝钻按钮
IM_Implants_Icon = 24       --种植体图标
IM_Implants_Button = 37    --种植体按钮
IM_Healing_caps_Icon = 25       --愈合帽图标
IM_Healing_caps_Button = 38    --愈合帽按钮
IM_Bone_Saws_Icon = 26       --骨锯图标
IM_Bone_Saws_Button = 39    --骨锯按钮
IM_High_Speed_Icon = 27       --高速图标
IM_High_Speed_Button = 40    --高速按钮
IM_Low_Speed_Icon = 28       --低速图标
IM_Low_Speed_Button = 41    --低速按钮
IM_Flush_Icon = 29       --冲水图标
IM_Flush_Button = 42    --冲水按钮
--------------------------------------------------------------------------------------------

IM_Set_ProgramName_Button = 30    --程序名编辑
IM_Set_ProgramName_Text = 49      --程序名显示
IM_Set_ProgramName_Icon = 52      --程序名备注提醒

IM_Set_DataChangeFlag = 0          --种植编辑界面数据标志位

-----------------------------------------------------------------------------
--@program:IM_Set_Screen_Exit
--@brief:退出种植模式设置界面，返回种植界面
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Screen_Exit()
    change_screen(IMScreenID)
    --IMScreen_Show(user,program,steps)   --种植页面更新
end

-----------------------------------------------------------------------------
--@program:IM_Set_Screen_Empty
--@brief:清空种植设置界面选择的所有步骤
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Screen_Empty()
    for i = 1, 8, 1 do
        IMStepsDisplayBuf[i] = 0
    end
    Temp_Steps = 1
end

-----------------------------------------------------------------------------
--@program:IM_Set_Screen_Save
--@brief:保存种植设置界面的操作
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Screen_Save(user, programe, steps, steps_value)
    for i = 1, 8, 1 do
        IMUserStepsDataBuf[user][programe][i] = IMStepsDisplayBuf[i]
        NewStepInit(user, programe, i, IMStepsDisplayBuf[i]) --将新步骤的参数初始化到对应的步骤中
    end
    for j = 1, 5, 1 do
        IM_Step_ProNum[user][j] = IM_Temp_Step_ProNum[user][j]
    end

    IM_DataReview_DataBufReset(user, programe) --重置数据回放数据数组
    
    DataWriteFlash_StepSetScreen()
end


-----------------------------------------------------------------------------
--@program:IM_Set_Screen_Init
--@brief:种植模式设置界面初始化
--@param:user:用户ID
--@param:steps:当前选择的步骤
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Screen_Init(user, programe, steps)
    local zeroNum = 0
    set_value(IM_Set_ScreenID,IM_Set_Program_Icon,programe-1+g_SetDarkModeFlag*5)            --显示程序号
    set_value(IM_Set_ScreenID,IM_Set_TipText_Icon,0+Language*1+g_SetDarkModeFlag*2)            --显示程序号
    set_value(IM_Set_ScreenID,IM_SetBackgroundIcon,g_SetDarkModeFlag)            --显示程序号

    for i = 1, 8, 1 do
        IMStepsDisplayBuf[i] = IMUserStepsDataBuf[user][programe][i]        --赋值显示数组
    end

    for number = 1, 8, 1 do
        if zeroNum == 0 then
            set_enable( IM_Set_ScreenID,number+9,ENABLE )    --使能可修改步骤
            if number == steps then
                Temp_Steps = steps
                Flag = 0
                set_value( IM_Set_ScreenID,number+1,IMStepsDisplayBuf[number]+13+Language*26+g_SetDarkModeFlag*52 )      --高亮显示
                set_visiable( IM_Set_ScreenID,number+1,ENABLE )
            else
                set_value( IM_Set_ScreenID,number+1,IMStepsDisplayBuf[number]+Language*26+g_SetDarkModeFlag*52 )         --显示灰色
                set_visiable( IM_Set_ScreenID,number+1,ENABLE )
            end
        else
            set_visiable( IM_Set_ScreenID,number+1,DISABLE )    --隐藏不可修改步骤
            set_enable( IM_Set_ScreenID,number+9,DISABLE )    --失能不可修改步骤
        end
        
        if IMStepsDisplayBuf[number] == 0 then
            zeroNum = zeroNum + 1
        end
    end

    for i = 1, 12, 1 do     --选择框内控件显示
        set_value( IM_Set_ScreenID,i+17,0+Language*2+g_SetDarkModeFlag*4 )         -- 显示灰色
    end
    set_value( IM_Set_ScreenID,IMStepsDisplayBuf[steps]+17,1+Language*2+g_SetDarkModeFlag*4 )         -- 高亮显示

    if IM_Set_DataChangeFlag == 1 then
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,0+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,ENABLE )
    elseif IMStepsDisplayBuf[1] == 0 then
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,1+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,1+Language*2+g_SetDarkModeFlag*4)
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,1+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,DISABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,DISABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,DISABLE )
    else
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,1+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,0+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,DISABLE)
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,ENABLE )        
    end
end


-----------------------------------------------------------------------------
--@program:Flag_Rollback
--@brief:将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
--@return:无
-------------------------------------------------------------------------------
function NewStepInit(user, program, steps, steps_value)

    if user == 1 then
        if steps_value == 12 then       -- 冲水
            IM_User1ProgramBuf[program][steps][1] = 0      --速度
            IM_User1ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 15      --速比
            IM_User1ProgramBuf[program][steps][4] = 4      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 6 then        --攻丝钻
            IM_User1ProgramBuf[program][steps][1] = 20      --速度
            IM_User1ProgramBuf[program][steps][2] = 25      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 12      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 7 then        --种植体
            IM_User1ProgramBuf[program][steps][1] = 20      --速度
            IM_User1ProgramBuf[program][steps][2] = 20      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 12      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 8 then        --愈合帽
            IM_User1ProgramBuf[program][steps][1] = 20      --速度
            IM_User1ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 12      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 9 then        --骨锯
            IM_User1ProgramBuf[program][steps][1] = 30000    --速度
            IM_User1ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 6      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 10 then        --高速
            IM_User1ProgramBuf[program][steps][1] = 10000  --速度
            IM_User1ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 4      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 11 then        --低速
            IM_User1ProgramBuf[program][steps][1] = 2000  --低速
            IM_User1ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 6      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED
        else
            --print("steps_value",steps_value)
            IM_User1ProgramBuf[program][steps][1] = 500      --速度
            IM_User1ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User1ProgramBuf[program][steps][3] = 12      --速比
            IM_User1ProgramBuf[program][steps][4] = 2      --水量
            IM_User1ProgramBuf[program][steps][5] = 2      --LED            
        end
    elseif user == 2 then
        if steps_value == 12 then       -- 冲水
            IM_User2ProgramBuf[program][steps][1] = 0      --速度
            IM_User2ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 15     --速比
            IM_User2ProgramBuf[program][steps][4] = 4      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 6 then        --攻丝钻
            IM_User2ProgramBuf[program][steps][1] = 20      --速度
            IM_User2ProgramBuf[program][steps][2] = 25      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 12      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 7 then        --种植体
            IM_User2ProgramBuf[program][steps][1] = 20      --速度
            IM_User2ProgramBuf[program][steps][2] = 20      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 12      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 8 then        --愈合帽
            IM_User2ProgramBuf[program][steps][1] = 20      --速度
            IM_User2ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 12      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 9 then        --骨锯
            IM_User2ProgramBuf[program][steps][1] = 30000      --速度
            IM_User2ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 6      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 10 then        --高速
            IM_User2ProgramBuf[program][steps][1] = 10000      --速度
            IM_User2ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 4      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 11 then        --低速
            IM_User2ProgramBuf[program][steps][1] = 2000  --低速
            IM_User2ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 6      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED            
        else
            IM_User2ProgramBuf[program][steps][1] = 500      --速度
            IM_User2ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User2ProgramBuf[program][steps][3] = 12      --速比
            IM_User2ProgramBuf[program][steps][4] = 2      --水量
            IM_User2ProgramBuf[program][steps][5] = 2      --LED       
        end
    elseif user == 3 then
        if steps_value == 12 then       -- 冲水
            IM_User3ProgramBuf[program][steps][1] = 0      --速度
            IM_User3ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 15      --速比
            IM_User3ProgramBuf[program][steps][4] = 4      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 6 then        --攻丝钻
            IM_User3ProgramBuf[program][steps][1] = 20      --速度
            IM_User3ProgramBuf[program][steps][2] = 25      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 12      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 7 then        --种植体
            IM_User3ProgramBuf[program][steps][1] = 20      --速度
            IM_User3ProgramBuf[program][steps][2] = 20      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 12      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 8 then        --愈合帽
            IM_User3ProgramBuf[program][steps][1] = 20      --速度
            IM_User3ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 12      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 9 then        --骨锯
            IM_User3ProgramBuf[program][steps][1] = 30000      --速度
            IM_User3ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 6      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 10 then        --高速
            IM_User3ProgramBuf[program][steps][1] = 10000      --速度
            IM_User3ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 4      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED
        elseif steps_value == 11 then        --低速
            IM_User3ProgramBuf[program][steps][1] = 2000  --低速
            IM_User3ProgramBuf[program][steps][2] = 0      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 6      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED            
        else 
            IM_User3ProgramBuf[program][steps][1] = 500      --速度
            IM_User3ProgramBuf[program][steps][2] = 10      --扭矩
            IM_User3ProgramBuf[program][steps][3] = 12      --速比
            IM_User3ProgramBuf[program][steps][4] = 2      --水量
            IM_User3ProgramBuf[program][steps][5] = 2      --LED       
        end
    end
    

end



-----------------------------------------------------------------------------
--@program:Flag_Rollback
--@brief:将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
--@return:无    为了实现连续点击添加步骤
-------------------------------------------------------------------------------
function Flag_Rollback(user, program, steps, steps_value, flag)
    if flag == 1 then
        if Temp_Steps < 8 then
            Temp_Steps = Temp_Steps + 1
        end
        flag = 0
    end
end

-----------------------------------------------------------------------------
--@program:IM_Set_Steps_Operation
--@brief:种植模式设置界面操作
--@param:user:用户ID
--@param:program:程序ID
--@param:steps:当前选择的步骤
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Steps_Operation(user, program, steps, control, value)

    if value == ENABLE then
        if control == IM_Set_Step1_Button then
            Temp_Steps = 1
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step2_Button then
            Temp_Steps = 2
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step3_Button then
            Temp_Steps = 3
            Flag = 0
            KeyBeep_App()  --按键音
        elseif control == IM_Set_Step4_Button then
            Temp_Steps = 4
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step5_Button then
            Temp_Steps = 5
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step6_Button then
            Temp_Steps = 6
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step7_Button then
            Temp_Steps = 7
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Step8_Button then
            Temp_Steps = 8
            Flag = 0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Ball_Drills_Button then    --球钻
            IMStepsDisplayBuf[Temp_Steps] = 1
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Marker_Drills_Button then    --标记钻
            IMStepsDisplayBuf[Temp_Steps] = 2
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Pioneer_Diamond_Button then    --先锋钻
            IMStepsDisplayBuf[Temp_Steps] = 3
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Reamer_Drills_Button then    --扩孔钻
            IMStepsDisplayBuf[Temp_Steps] = 4
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Forming_Drills_Button then    --成型钻
            IMStepsDisplayBuf[Temp_Steps] = 5
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Tapping_Drills_Button then    --攻丝钻
            IMStepsDisplayBuf[Temp_Steps] = 6
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Implants_Button then    --种植体
            IMStepsDisplayBuf[Temp_Steps] = 7
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Healing_caps_Button then    --愈合帽
            IMStepsDisplayBuf[Temp_Steps] = 8
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Bone_Saws_Button then    --骨锯
            IMStepsDisplayBuf[Temp_Steps] = 9
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0 
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_High_Speed_Button then    --高速
            IMStepsDisplayBuf[Temp_Steps] = 10
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Low_Speed_Button then    --低速
            IMStepsDisplayBuf[Temp_Steps] = 11
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Flush_Button then    --冲水
            IMStepsDisplayBuf[Temp_Steps] = 12
            Flag_Rollback(user, program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps], Flag)         --将空步骤设置为非空时，将Temp_Steps加1，并将flag置为0
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        elseif control == IM_Set_Empty_Button then
            Steps[user][(Promgrame[user])] = 1          --清空后默认步骤1
            IM_Set_Screen_Empty()        --清空种植设置界面选择的所有步骤
            KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 0
        elseif control == IM_Set_Save_Button and IMStepsDisplayBuf[1] ~=0 then
            IM_Set_Screen_Save(user,program, Temp_Steps, IMStepsDisplayBuf[Temp_Steps-1])        --保存种植设置界面的设置参数
            KeyBeep_App()  --按键音
            StartFlashWrite_App()    --保存写flash 
            IM_Set_DataChangeFlag = 0
        elseif control == IM_Set_Exit_Button then
            if IM_Set_DataChangeFlag == 1 then
                change_child_screen(4)
                SystemMode=4
                POP_WindowNum=14
                WindowScreen_Show()
                KeyBeep_App()
            else
                IM_Set_Screen_Exit()        --返回种植界面
                IMScreen_Show(user,program,steps)   --种植页面更新
                KeyBeep_App()  --按键音
            end
            return
        elseif control == IM_Set_ProgramName_Button then
            IM_Set_ProgramName_Change(control)        --切换到键盘输入程序名
            --KeyBeep_App()  --按键音
            IM_Set_DataChangeFlag = 1
        end
        if IMStepsDisplayBuf[Temp_Steps] == 0 then     --若当前选择的步骤为0，则将flag设置为1
            Flag = 1
        end



    end

    IM_Set_Steps_Update(Temp_Steps,user, program)

end


-----------------------------------------------------------------------------
--@program:IM_Set_Steps_Update
--@brief:种植模式设置界面更新显示
--@param:steps:当前选择的步骤
--@return:无
-------------------------------------------------------------------------------
function IM_Set_Steps_Update(steps,user, program)
    local zeroNum = 0
    for number = 1, 8, 1 do

        if zeroNum == 0 then
            set_visiable( IM_Set_ScreenID,number+1,ENABLE )    --显示可修改步骤
            set_enable( IM_Set_ScreenID,number+9,ENABLE )    --使能可修改步骤
            if number == steps then
                Temp_Steps = steps
                --Flag = 0
                set_value( IM_Set_ScreenID,number+1,IMStepsDisplayBuf[number]+13+Language*26+g_SetDarkModeFlag*52 )      -- 图标高亮显示
                set_visiable( IM_Set_ScreenID,number+1,ENABLE )
            else
                set_value( IM_Set_ScreenID,number+1,IMStepsDisplayBuf[number]+Language*26+g_SetDarkModeFlag*52 )         -- 图标显示灰色
                set_visiable( IM_Set_ScreenID,number+1,ENABLE )
            end
            if IMStepsDisplayBuf[8] ~=  0  and number == 8 then    --判断外面步骤图标数
                IM_Temp_Step_ProNum[user][program] = 8
            else    
                IM_Temp_Step_ProNum[user][program] = number -1
            end

        else
            set_visiable( IM_Set_ScreenID,number+1,DISABLE )
            set_enable( IM_Set_ScreenID,number+9,DISABLE )    --失能可修改步骤
        end

        if IMStepsDisplayBuf[number] == 0 then                --两次为零是为了显示+号
            zeroNum = zeroNum + 1
        end
    end

    for i = 1, 12, 1 do     --选择框内控件显示
        set_value( IM_Set_ScreenID,i+17,0+Language*2+g_SetDarkModeFlag*4 )         -- 显示灰色
    end
    set_value( IM_Set_ScreenID,IMStepsDisplayBuf[steps]+17,1+Language*2+g_SetDarkModeFlag*4 )         -- 高亮显示

    IM_Set_ProgramName_Show(user,program)--程序名显示

    if IM_Set_DataChangeFlag == 1 then
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,0+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,ENABLE )
    elseif IMStepsDisplayBuf[1] == 0 then
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,1+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,1+Language*2+g_SetDarkModeFlag*4)
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,1+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,DISABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,DISABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,DISABLE )
    else
        set_value( IM_Set_ScreenID,IM_Set_Empty_Icon,0+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Save_Icon,1+Language*2+g_SetDarkModeFlag*4 )
        set_value( IM_Set_ScreenID,IM_Set_Exit_Icon,0+Language*2+g_SetDarkModeFlag*4)
        set_enable( IM_Set_ScreenID,IM_Set_Empty_Button,ENABLE )
        set_enable( IM_Set_ScreenID,IM_Set_Save_Button,DISABLE)
        set_enable( IM_Set_ScreenID,IM_Set_Exit_Button,ENABLE )        
    end

    if IMStepsDisplayBuf[1] == 0 then
        set_enable( IM_Set_ScreenID,IM_Set_Step1_Button,DISABLE )       --清空后 取消步骤1按钮
        --set_enable( IM_Set_ScreenID,IM_Set_ProgramName_Button,DISABLE )
    else
        set_enable( IM_Set_ScreenID,IM_Set_Step1_Button,ENABLE )        
       set_value( IM_Set_ScreenID,IM_Set_ProgramName_Button,ENABLE )   --使能用户名按钮
    end

end
-----------------------------------------------------------------------------
--@program:IMProgramName_Show
--@brief:种植编辑程序名显示和备注提示   编辑界面
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IM_Set_ProgramName_Show(user,program)
    set_text(IM_Set_ScreenID,IM_Set_ProgramName_Text,IMUserProgramIDDataBuf[user][program] )
    set_value(IM_Set_ScreenID,IM_Set_ProgramName_Icon,0+Language+g_SetDarkModeFlag*2)
end
-----------------------------------------------------------------------------
--@program:IMProgramName_Change
--@brief:种植编制程序名修改   编制界面
--@param:user:用户ID
--@param:program:程序ID
--@return:无
-------------------------------------------------------------------------------
function IM_Set_ProgramName_Change(control)

    if get_current_screen() == IM_Set_ScreenID then
       g_IM_ProgramNameChangeFlag = 0x01
    elseif get_current_screen() == IM_DataEntry_ScreenID then
        if control == IMReportName_Button then
            IM_Report_NameFlag = 1     --病人姓名修改标志位
        elseif control == IMReportNO_Button then
            IM_Report_NOFlag = 1       --病人编号修改标志位
        end
    end
    

    if g_SetDarkModeFlag == 0 then
        SystemMode=9
        change_screen(9)
    else
        SystemMode=16
        change_screen(16)
    end
    
end




------------------------------------------------------------------------------
----------------------------数据查看模块---------------------------------------
IM_DataReview_Text1 = 1         --数据查看界面左上角文本控件
IM_DataReview_Text2 = 2         --数据查看界面左下角文本控件
IM_DataReviewBackgroundIcon = 54    --数据查看界面背景控件
IM_DataReview_ExportButton = 3      --数据导出按钮
IM_DataReview_ScreenID = 12         --数据查看界面ID
IM_LineChartMagnify_ScreenID = 13         --折线图放大界面ID
IM_DataEntry_ScreenID = 14         --数据录入界面ID
IM_Report_Screen = 15           --报告界面ID
IM_Wheel_ScreenID = 18         --滚字轮界面ID
--------------------[[数据查看界面宏]]--------------------------
IMDataReviewMagnify = 70         --画面放大按钮
IMExportEnter = 71         --数据导出按钮
IMDataReviewReturn = 72         --返回按钮
IMDataReviewLegend = 63

BlackColor = 0         --黑色字体颜色
BlueColor = 1309         --蓝色字体颜色


--------------------[[折线放大界面宏]]--------------------------
IMLineChartMagnifyBackgroundIcon = 4    --折线图放大界面背景控件
IMLineChartMagnifyReturn = 3         --返回按钮


-----------[[数据录入界面宏]]---------------
IMDataReviewScreenIcon = 1          --数据录入界面背景控件
IMReportBirthWheel_BUtton = 45  --生日滚字轮唤醒按钮
IMReportTreatWheel_BUtton = 47  --治疗日期滚字轮唤醒按钮
IMDataEntryReturn = 128         --返回按钮
IMDataEntrySure = 55         --确定按钮
IMDataEntrySureIcon = 120         --确定按钮显示控件
IMDataEntryName_Icon = 40       --名字显示控件
IMDataEntryBirth_Icon = 41      --生日显示控件
IMDataEntryNO_Icon = 42         --编号显示控件
IMDataEntryTreatDay_Icon = 43   --治疗日期显示控件
IMDataEntryNameNight_Icon = 133       --名字显示控件
IMDataEntryBirthNight_Icon = 134      --生日显示控件
IMDataEntryNONight_Icon = 135         --编号显示控件
IMDataEntryTreatDayNight_Icon = 136   --治疗日期显示控件
BoonD1_Icon = 2      --D1图标
BoonD1_Icon = 3      --D2图标
BoonD1_Icon = 4      --D3图标
BoonD1_Icon = 5      --D4图标
BoonD1_Icon = 6      --D5图标
IMDataEntryNumbering_System_Icon = 7    --编号系统显示控件
FDINumbering_Button = 53     --FDI编号图标
ADANumbering_Button = 54     --ADA编号图标
FDINumbering_EN_Button = 129     --FDI编号图标
ADANumbering_EN_Button = 130     --ADA编号图标
IMDataEntryWheelBackground = 121         --滚字轮背景
IMDataEntryWheel = 122         --滚字轮样式
YearWheel = 123         --年的滚字轮
MoonWheel = 124         --月的滚字轮
DayWheel = 125         --日的滚字轮
YearWheel_Night = 137         --年的夜间滚字轮
MoonWheel_Night = 138         --月的夜间滚字轮
DayWheel_Night = 139         --日的夜间滚字轮
CancelButton = 126         --滚字轮取消按钮
SureButton = 127         --滚字轮确定按钮
CancelIcon = 131         --滚字轮取消按钮
SureIcon = 132         --滚字轮确定按钮


-----------[[报告界面宏]]---------------
IMReportBackgroundIcon = 127          --报告界面背景控件
IMReportName_Text = 113       --名字文本显示控件
IMReportName_Icon = 115       --名字显示控件
IMReportName_Button = 44     --名字输入控件
IMReportBirth_Text = 117      --生日文本显示控件
IMReportBirth_Icon = 119      --生日显示控件
IMReportNO_Text = 114       --编号文本显示控件
IMReportNO_Icon = 116         --编号显示控件
IMReportNO_Button = 46         --编号输入控件
IMReportTreatDay_Text = 118      --治疗日期文本显示控件
IMReportTreatDay_Icon = 120   --治疗日期显示控件
IMReportBone_Text = 121      --骨密度文本显示控件
IMReportBone_Icon = 122     --骨密度显示控件
IMReportBoneDensityENText = 125         --骨密度英文文本显示控件
IMReportBoneDensityENIcon = 126         --骨密度英文显示控件

IMReportScreenShot_Timer = 20     --报告截图定时器


--出生日期
IM_DataReview_Name = "patient_name"     --病人姓名
IM_DataReview_NO = "001"     --病人编号
IM_DataReview_BirthYear = 1985     --病人出生年
IM_DataReview_BirthMoon = 1     --病人出生月
IM_DataReview_BirthDay = 1     --病人出生日

--治疗日期
IM_DataReview_TreatYear = 2025     --病人治疗年
IM_DataReview_TreatMoon = 1     --病人治疗月
IM_DataReview_TreatDay = 1     --病人治疗日

WheelFlag = 1   --滚字轮标志位，0为生日，1：为治疗日期

Bone_Density = 1  --骨密度  1：D1 2：D2 3：D3 4：D4 5：D5

Numbering_System = 0     --编号系统         0:FDI双数字系统   1:ADA通用编号系统
FDINumbering = {18, 17, 16, 15, 14, 13, 12, 11, 21, 22, 23, 24, 25, 26, 27, 28,
                 48, 47, 46, 45, 44, 43, 42, 41, 31, 32, 33, 34, 35, 36, 37, 38}     --FDI双数字编号
ADANumbering = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17}     --FDI双数字编号                 


RatioDisplayBuff = {"1:2","1:3","1:3.3","1:4.2","1:5","1:1","3.2:1","3.4:1","4:1","10:1","16:1","20:1","27:1","32:1","64:1","/"}--速比显示
NamaTextBuf={"姓名:","Name:"}
BirthTextBuf={"出生日期:","Birthday:"}
NOTextBuf={"患者编号:","Number:"}
TreatDateTextBuf={"治疗日期:","Date:"}
BoneTextBuf={"骨密度:","Bone Debsity:"}
DensityTextBuf={"D1","D2","D3","D4","未知","D1","D2","D3","D4","Other"}
IM_Usr1DataReview_Buf ={
    {           --用户1 ：P1:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户1 ：P2:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户1 ：P3:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户1 ：P4:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户1 ：P5:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
}

IM_Usr2DataReview_Buf ={
    {           --用户2 ：P1:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户2 ：P2:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户2 ：P3:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户2 ：P4:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户2 ：P5:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
}

IM_Usr3DataReview_Buf ={
    {           --用户3 ：P1:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户3 ：P2:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户3 ：P3:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户3 ：P4:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
    {           --用户3 ：P5:序列号，步骤，实际速度，设定速度，实际扭矩，设定扭矩，水量，速比位号
        {1, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
    },       --数据为0时不显示
}
Serial_Number = 1          --序列号
Tooth_Number = 1           --牙位号     --当前选择的牙齿位号，默认为第一颗牙
IM_Report_NameFlag = 0     --病人姓名修改标志位
IM_Report_NOFlag = 0       --病人编号修改标志位

-------------------------------------------------------------------------------



------------------------------------------------------------------------------
--@program:IM_DataReview_Screen_Enter
--@brief:数据查看界面进入
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_Screen_Enter()
    --SystemMode=8
    change_screen(IM_DataReview_ScreenID)
    KeyBeep_App()
    g_IM_DataViewing = 2   --进入数据查看标志位
end



------------------------------------------------------------------------------
--@program:IM_DataEntry_Screen_Enter
--@brief:数据录入界面进入
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Screen_Enter()
    change_screen(IM_DataEntry_ScreenID)
    set_value(IM_DataEntry_ScreenID, IMDataEntryWheel, 0+g_SetDarkModeFlag*1)  --切换日夜滚字轮样式
    set_visiable(IM_DataEntry_ScreenID, YearWheel_Night, DISABLE)       --隐藏夜间年滚字轮
    set_visiable(IM_DataEntry_ScreenID, MoonWheel_Night, DISABLE)      --隐藏夜间月滚字轮
    set_visiable(IM_DataEntry_ScreenID, DayWheel_Night, DISABLE)     --隐藏夜间日滚字轮
    set_visiable(IM_DataEntry_ScreenID, YearWheel, DISABLE)          --隐藏日间年滚字轮
    set_visiable(IM_DataEntry_ScreenID, MoonWheel, DISABLE)           --隐藏日间月滚字轮
    set_visiable(IM_DataEntry_ScreenID, DayWheel, DISABLE)            --隐藏日间日滚字轮
    if Language == 0 then
        set_enable(IM_DataEntry_ScreenID, FDINumbering_Button, ENABLE)
        set_enable(IM_DataEntry_ScreenID, ADANumbering_Button, ENABLE)
        set_enable(IM_DataEntry_ScreenID, FDINumbering_EN_Button, DISABLE)
        set_enable(IM_DataEntry_ScreenID, ADANumbering_EN_Button, DISABLE)
    else
        set_enable(IM_DataEntry_ScreenID, FDINumbering_Button, DISABLE)
        set_enable(IM_DataEntry_ScreenID, ADANumbering_Button, DISABLE)
        set_enable(IM_DataEntry_ScreenID, FDINumbering_EN_Button, ENABLE)
        set_enable(IM_DataEntry_ScreenID, ADANumbering_EN_Button, ENABLE)
    end
    if g_SetDarkModeFlag == 0 then
        
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNameNight_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryBirthNight_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNONight_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryTreatDayNight_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryName_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryBirth_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNO_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryTreatDay_Icon, ENABLE)
    else
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNameNight_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryBirthNight_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNONight_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryTreatDayNight_Icon, ENABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryName_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryBirth_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryNO_Icon, DISABLE)
        set_visiable(IM_DataEntry_ScreenID, IMDataEntryTreatDay_Icon, DISABLE)
    end
    IM_DataEntry_Wheel_UI_Disable()   --禁用数据录入界面滚轮
end


------------------------------------------------------------------------------
--@program:IM_DataReview_Screen_Exit
--@brief:数据查看界面退出
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_Screen_Exit()
    change_screen(IMScreenID)
    --g_IM_DataViewing = 1   --进入数据查看标志位
end

------------------------------------------------------------------------------
--@program:IM_DataReview_Screen_Exit
--@brief:数据录入界面退出
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Screen_Exit()
    change_screen(IM_DataReview_ScreenID)
end

------------------------------------------------------------------------------
--@program:IM_LineChart_Magnify_Enter
--@brief:折线图放大界面进入
--@return:无
-------------------------------------------------------------------------------
function IM_LineChart_Magnify_Enter()
    change_screen(IM_LineChartMagnify_ScreenID)
    set_value(IM_LineChartMagnify_ScreenID, IMLineChartMagnifyBackgroundIcon, 0+g_SetDarkModeFlag)   --设置折线放大图的界面背景
end


------------------------------------------------------------------------------
--@program:IM_LineChart_Magnify_Exit
--@brief:折线图放大界面退出
--@return:无
-------------------------------------------------------------------------------
function IM_LineChart_Magnify_Exit()
    change_screen(IM_DataReview_ScreenID)
end

------------------------------------------------------------------------------
--@program:IM_DataReview_BufNew_Data
--@brief:数据查看界面显示数组数据新增
--@param:work_flag :工作标志位
--@param:user :当前用户
--@param:program :当前程序
--@param:steps :当前步骤
--@param:receive_speed :接收到的速度
--@param:receive_torque :接收到的扭矩
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_BufNew_Data(work_flag, user, program, steps,receive_speed,receive_torque)
    local realTimeSpeed
    local realTimeTorque
    if work_flag == 1 and Motordirection == 0 then --正转工作时记录数据
        if user == 1 then
            realTimeSpeed = IM_Usr1DataReview_Buf[program][steps][3]
            realTimeTorque = IM_Usr1DataReview_Buf[program][steps][5]      
        elseif user == 2 then
            realTimeSpeed = IM_Usr2DataReview_Buf[program][steps][3]
            realTimeTorque = IM_Usr2DataReview_Buf[program][steps][5]        
        elseif user == 3 then
            realTimeSpeed = IM_Usr3DataReview_Buf[program][steps][3]
            realTimeTorque = IM_Usr3DataReview_Buf[program][steps][5]        
        end    

        if realTimeSpeed < receive_speed then       --获取最大速度值
            if user == 1 then
                if receive_speed < IM_User1ProgramBuf[program][steps][1] then        --设定速度 
                    realTimeSpeed = receive_speed
                else
                    realTimeSpeed = IM_User1ProgramBuf[program][steps][1]
                end
            elseif user == 2 then
                if receive_speed < IM_User2ProgramBuf[program][steps][1] then        --设定速度 
                    realTimeSpeed = receive_speed
                else
                    realTimeSpeed = IM_User2ProgramBuf[program][steps][1]
                end
            elseif user == 3 then
                if receive_speed < IM_User3ProgramBuf[program][steps][1] then        --设定速度 
                    realTimeSpeed = receive_speed
                else
                    realTimeSpeed = IM_User3ProgramBuf[program][steps][1]
                end
            end
        end

        if realTimeTorque < receive_torque then      --获取最大扭矩值
            if user == 1 then
                if receive_torque < IM_User1ProgramBuf[program][steps][2] then        --设定扭矩 
                    realTimeTorque = receive_torque
                else
                    realTimeTorque = IM_User1ProgramBuf[program][steps][2]
                end
            elseif user == 2 then
                if receive_torque < IM_User2ProgramBuf[program][steps][2] then        --设定扭矩
                    realTimeTorque = receive_torque
                else
                    realTimeTorque = IM_User2ProgramBuf[program][steps][2]
                end
            elseif user == 3 then
                if receive_torque < IM_User3ProgramBuf[program][steps][2] then        --设定扭矩 
                    realTimeTorque = receive_torque
                else
                    realTimeTorque = IM_User3ProgramBuf[program][steps][2]
                end
            end
        end

        if user == 1 then
            IM_Usr1DataReview_Buf[program][steps][2] = steps
            IM_Usr1DataReview_Buf[program][steps][3] = math.floor(realTimeSpeed)
            IM_Usr1DataReview_Buf[program][steps][5] = math.floor(realTimeTorque)
        elseif user == 2 then
            IM_Usr2DataReview_Buf[program][steps][2] = steps
            IM_Usr2DataReview_Buf[program][steps][3] = math.floor(realTimeSpeed)
            IM_Usr2DataReview_Buf[program][steps][5] = math.floor(realTimeTorque)
        elseif user == 3 then
            IM_Usr3DataReview_Buf[program][steps][2] = steps
            IM_Usr3DataReview_Buf[program][steps][3] = math.floor(realTimeSpeed)
            IM_Usr3DataReview_Buf[program][steps][5] = math.floor(realTimeTorque)
        end
        
    end
    if work_flag == 2 then   --达到扭矩
        if user == 1 then
            IM_Usr1DataReview_Buf[program][steps][5] = IM_User1ProgramBuf[program][steps][2]
        elseif user == 2 then
            IM_Usr2DataReview_Buf[program][steps][5] = IM_User2ProgramBuf[program][steps][2]
        elseif user == 3 then
            IM_Usr3DataReview_Buf[program][steps][5] = IM_User3ProgramBuf[program][steps][2]
        end
    end
end
------------------------------------------------------------------------------
--@program:IM_DataReview_DataBufReset
--@brief:数据查看界面显示数组数据清零
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_DataBufReset(user,program)
    --数组初始化
    for e = 1, 8, 1 do
        if user == 1 then
            for z = 1, 8, 1 do
                IM_Usr1DataReview_Buf[program][e][z] = 0
            end
        elseif user == 2 then
            for z = 1, 8, 1 do
                IM_Usr2DataReview_Buf[program][e][z] = 0
            end
        elseif user == 3 then
            for z = 1, 8, 1 do
                IM_Usr3DataReview_Buf[program][e][z] = 0
            end
        end
    end

end

------------------------------------------------------------------------------
--@program:IM_DataReview_Screen_UI_Init
--@brief:数据查看界面UI初始化
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_Screen_UI_Init(user,program,steps)
    Serial_Number = 1
    set_value(IM_DataReview_ScreenID, IM_DataReviewBackgroundIcon, 0+Language*1+g_SetDarkModeFlag*2)   --设置界面背景
    set_value(IM_DataReview_ScreenID, IMDataReviewLegend, 0+Language*1)   --图例
    set_value(IM_DataReview_ScreenID, IM_DataReview_Text1, 0+Language*1+g_SetDarkModeFlag*2)   --设置左上角文本
    set_value(IM_DataReview_ScreenID, IM_DataReview_Text2, 0+Language*1+g_SetDarkModeFlag*2)   --设置左下角文本
    set_value(IM_DataReview_ScreenID, IM_DataReview_ExportButton, 0+Language*1+g_SetDarkModeFlag*2)   --设置数据导出按钮样式
    for j = 1, 8, 1 do
        if IMUserStepsDataBuf[user][program][j] ~= 0 then
            if  user == 1  then
                IM_Usr1DataReview_Buf[program][j][1] = Serial_Number
                IM_Usr1DataReview_Buf[program][j][2] = IMUserStepsDataBuf[user][program][j]     --步骤号
                IM_Usr1DataReview_Buf[program][j][4] = IM_User1ProgramBuf[program][j][1]        --设定速度
                IM_Usr1DataReview_Buf[program][j][6] = IM_User1ProgramBuf[program][j][2]        --设定扭矩
                IM_Usr1DataReview_Buf[program][j][7] = IM_User1ProgramBuf[program][j][4]        --设定水量
                IM_Usr1DataReview_Buf[program][j][8] = IM_User1ProgramBuf[program][j][3]        --设定速比
            elseif user == 2 then
                IM_Usr2DataReview_Buf[program][j][1] = Serial_Number
                IM_Usr2DataReview_Buf[program][j][2] = IMUserStepsDataBuf[user][program][j]    --步骤号
                IM_Usr2DataReview_Buf[program][j][4] = IM_User2ProgramBuf[program][j][1]        --设定速度
                IM_Usr2DataReview_Buf[program][j][6] = IM_User2ProgramBuf[program][j][2]        --设定扭矩
                IM_Usr2DataReview_Buf[program][j][7] = IM_User2ProgramBuf[program][j][4]        --设定水量
                IM_Usr2DataReview_Buf[program][j][8] = IM_User2ProgramBuf[program][j][3]        --设定速比
            elseif user == 3 then
                IM_Usr3DataReview_Buf[program][j][1] = Serial_Number
                IM_Usr3DataReview_Buf[program][j][2] = IMUserStepsDataBuf[user][program][j]     --步骤号
                IM_Usr3DataReview_Buf[program][j][4] = IM_User3ProgramBuf[program][j][1]        --设定速度
                IM_Usr3DataReview_Buf[program][j][6] = IM_User3ProgramBuf[program][j][2]        --设定扭矩
                IM_Usr3DataReview_Buf[program][j][7] = IM_User3ProgramBuf[program][j][4]        --设定水量
                IM_Usr3DataReview_Buf[program][j][8] = IM_User3ProgramBuf[program][j][3]        --设定速比
            end
            Serial_Number = (Serial_Number + 1)%9   --序列号递增
        else        --数组清零
            IM_Usr1DataReview_Buf[program][j][1] = 0
            IM_Usr1DataReview_Buf[program][j][2] = 0    --步骤号
            IM_Usr1DataReview_Buf[program][j][3] = 0    --实际速度
            IM_Usr1DataReview_Buf[program][j][4] = 0    --设定速度
            IM_Usr1DataReview_Buf[program][j][5] = 0    --实际扭矩
            IM_Usr1DataReview_Buf[program][j][6] = 0    --设定扭矩
            IM_Usr1DataReview_Buf[program][j][7] = 0    --设定水量
            IM_Usr1DataReview_Buf[program][j][8] = 0    --设定速比

            IM_Usr2DataReview_Buf[program][j][1] = 0
            IM_Usr2DataReview_Buf[program][j][2] = 0    --步骤号
            IM_Usr2DataReview_Buf[program][j][3] = 0    --实际速度
            IM_Usr2DataReview_Buf[program][j][4] = 0    --设定速度
            IM_Usr2DataReview_Buf[program][j][5] = 0    --实际扭矩
            IM_Usr2DataReview_Buf[program][j][6] = 0    --设定扭矩
            IM_Usr2DataReview_Buf[program][j][7] = 0    --设定水量
            IM_Usr2DataReview_Buf[program][j][8] = 0    --设定速比
            
            IM_Usr3DataReview_Buf[program][j][1] = 0
            IM_Usr3DataReview_Buf[program][j][2] = 0    --步骤号
            IM_Usr3DataReview_Buf[program][j][3] = 0    --实际速度
            IM_Usr3DataReview_Buf[program][j][4] = 0    --设定速度
            IM_Usr3DataReview_Buf[program][j][5] = 0    --实际扭矩
            IM_Usr3DataReview_Buf[program][j][6] = 0    --设定扭矩
            IM_Usr3DataReview_Buf[program][j][7] = 0    --设定水量
            IM_Usr3DataReview_Buf[program][j][8] = 0    --设定速比
        end
    end

    for i = 1, 8, 1 do
        if user == 1 then
            if IM_Usr1DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), ENABLE)      --实际速度控件显示
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), ENABLE)      --实际扭矩显示
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), ENABLE)      --速比控件显示
                if IM_Usr1DataReview_Buf[program][i][2] ~= 12 and IM_Usr1DataReview_Buf[program][i][2] ~= 9 and IM_Usr1DataReview_Buf[program][i][2] ~= 10 and IM_Usr1DataReview_Buf[program][i][2] ~= 11 then     --非冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_text(IM_DataReview_ScreenID, 55+(i-1), IM_Usr1DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/"..IM_Usr1DataReview_Buf[program][i][6])   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr1DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr1DataReview_Buf[program][i][2] == 9 then   --骨锯
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), "/")   --设置速比控件显示值
                elseif IM_Usr1DataReview_Buf[program][i][2] == 10 or IM_Usr1DataReview_Buf[program][i][2] == 11 then   --骨锯
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1),"/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr1DataReview_Buf[program][i][8]])   --设置速比控件显示值                    
                else            --冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), "/")   --设置实际速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), DISABLE)      --实际扭矩和设定扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), DISABLE)      --速比控件隐藏   
            end
        end
        if user == 2 then
            if IM_Usr2DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), ENABLE)      --实际速度和设定速度控件显示
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), ENABLE)      --实际扭矩显示
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), ENABLE)      --速比控件显示

                if IM_Usr2DataReview_Buf[program][i][2] ~= 12 and IM_Usr2DataReview_Buf[program][i][2] ~= 9 and IM_Usr2DataReview_Buf[program][i][2] ~= 10 and IM_Usr2DataReview_Buf[program][i][2] ~= 11 then     --非冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_text(IM_DataReview_ScreenID, 55+(i-1), IM_Usr2DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/"..IM_Usr2DataReview_Buf[program][i][6])   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr2DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr2DataReview_Buf[program][i][2] == 9 then
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), "/")   --设置速比控件显示值
                elseif IM_Usr2DataReview_Buf[program][i][2] == 10  or IM_Usr2DataReview_Buf[program][i][2] == 11 then
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr2DataReview_Buf[program][i][8]])   --设置速比控件显示值                    
                else            --冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), "/")   --设置实际速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), DISABLE)      --实际扭矩和设定扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), DISABLE)      --速比控件隐藏   
            end
        end
        if user == 3 then
            if IM_Usr3DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), ENABLE)      --实际速度控件显示
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), ENABLE)      --实际扭矩显示
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), ENABLE)      --速比控件显示

                if IM_Usr3DataReview_Buf[program][i][2] ~= 12 and IM_Usr3DataReview_Buf[program][i][2] ~= 9 and IM_Usr3DataReview_Buf[program][i][2] ~= 10 and IM_Usr3DataReview_Buf[program][i][2] ~= 11 then     --非冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_text(IM_DataReview_ScreenID, 55+(i-1), IM_Usr3DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/"..IM_Usr3DataReview_Buf[program][i][6])   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr3DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr3DataReview_Buf[program][i][2] == 9 then
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1),  "/")   --设置速比控件显示值
                elseif IM_Usr3DataReview_Buf[program][i][2] == 10 or IM_Usr3DataReview_Buf[program][i][2] == 11 then
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), RatioDisplayBuff[IM_Usr3DataReview_Buf[program][i][8]])   --设置速比控件显示值                    
                else            --冲水步骤
                    set_text(IM_DataReview_ScreenID, 6+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_DataReview_ScreenID, 7+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_DataReview_ScreenID,8+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_DataReview_ScreenID, 8+6*(i-1), "/")   --设置实际速度控件显示值
                    set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_DataReview_ScreenID, 9+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_DataReview_ScreenID, 10+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_DataReview_ScreenID, 11+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_DataReview_ScreenID, 6+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_DataReview_ScreenID, 7+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_DataReview_ScreenID, 8+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_DataReview_ScreenID, 55+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 9+6*(i-1), DISABLE)      --实际扭矩和设定扭矩控件隐藏
                set_visiable(IM_DataReview_ScreenID, 10+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_DataReview_ScreenID, 11+6*(i-1), DISABLE)      --速比控件隐藏
            end
        end
    end
end


------------------------------------------------------------------------------
--@program:IM_DataEntry_Wheel_UI_Enable
--@brief:数据录入界面滚字轮UI使能
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Wheel_UI_Enable()
    local year
    local month
    local day

    change_child_screen(IM_Wheel_ScreenID)      --切换到滚字轮界面，显示滚字轮

    if WheelFlag == 0 then
        year = IM_DataReview_BirthYear - 1949   --默认开始日期
        month = IM_DataReview_BirthMoon - 1
        day = IM_DataReview_BirthDay - 1
    else
        year = IM_DataReview_TreatYear - 1949
        month = IM_DataReview_TreatMoon - 1
        day = IM_DataReview_TreatDay - 1
    end

    set_value(IM_Wheel_ScreenID, IMDataEntryWheel, 0+g_SetDarkModeFlag)
    if g_SetDarkModeFlag == 0 then
        set_value(IM_Wheel_ScreenID, YearWheel, year)       --设置白天年滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, YearWheel, ENABLE)       --显示白天年滚字轮
        set_enable(IM_Wheel_ScreenID, YearWheel, ENABLE)       --使能白天年滚字轮
        set_value(IM_Wheel_ScreenID, MoonWheel, month)       --设置白天月滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, MoonWheel, ENABLE)       --显示白天月滚字轮
        set_enable(IM_Wheel_ScreenID, MoonWheel, ENABLE)       --使能白天月滚字轮
        set_value(IM_Wheel_ScreenID, DayWheel, day)       --设置白天日滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, DayWheel, ENABLE)       --显示白天日滚字轮
        set_enable(IM_Wheel_ScreenID, DayWheel, ENABLE)       --使能白天日滚字轮
        set_visiable(IM_Wheel_ScreenID, YearWheel_Night, DISABLE)       --隐藏夜间年滚字轮
        set_enable(IM_Wheel_ScreenID, YearWheel_Night, DISABLE)       --失能夜间年滚字轮
        set_visiable(IM_Wheel_ScreenID, MoonWheel_Night, DISABLE)       --隐藏夜间月滚字轮
        set_enable(IM_Wheel_ScreenID, MoonWheel_Night, DISABLE)       --失能夜间月滚字轮
        set_visiable(IM_Wheel_ScreenID, DayWheel_Night, DISABLE)       --隐藏夜间日滚字轮
        set_enable(IM_Wheel_ScreenID, DayWheel_Night, DISABLE)       --失能夜间日滚字轮
    else
        set_visiable(IM_Wheel_ScreenID, YearWheel, DISABLE)       --隐藏白天年滚字轮
        set_enable(IM_Wheel_ScreenID, YearWheel, DISABLE)       --失能白天年滚字轮
        set_visiable(IM_Wheel_ScreenID, MoonWheel, DISABLE)       --隐藏白天月滚字轮
        set_enable(IM_Wheel_ScreenID, MoonWheel, DISABLE)       --失能白天月滚字轮
        set_visiable(IM_Wheel_ScreenID, DayWheel, DISABLE)       --隐藏白天日滚字轮
        set_enable(IM_Wheel_ScreenID, DayWheel, DISABLE)       --失能白天日滚字轮
        set_value(IM_Wheel_ScreenID, YearWheel_Night, year)       --设置白天年滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, YearWheel_Night, ENABLE)       --显示夜间年滚字轮
        set_enable(IM_Wheel_ScreenID, YearWheel_Night, ENABLE)       --使能夜间年滚字轮
        set_value(IM_Wheel_ScreenID, MoonWheel_Night, month)       --设置白天月滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, MoonWheel_Night, ENABLE)       --显示夜间月滚字轮
        set_enable(IM_Wheel_ScreenID, MoonWheel_Night, ENABLE)       --使能夜间月滚字轮
        set_value(IM_Wheel_ScreenID, DayWheel_Night, day)       --设置白天日滚字轮显示值
        set_visiable(IM_Wheel_ScreenID, DayWheel_Night, ENABLE)       --显示夜间日滚字轮
        set_enable(IM_Wheel_ScreenID, DayWheel_Night, ENABLE)       --使能夜间日滚字轮
    end
    
    set_visiable(IM_Wheel_ScreenID, CancelButton, ENABLE)       --显示取消按钮
    set_visiable(IM_Wheel_ScreenID, CancelIcon, ENABLE)       --显示取消控件
    set_value(IM_Wheel_ScreenID, CancelIcon,0+Language+g_SetDarkModeFlag*2)
    set_enable(IM_Wheel_ScreenID, CancelButton, ENABLE)       --使能取消按钮
    set_visiable(IM_Wheel_ScreenID, SureButton, ENABLE)       --显示确定按钮
    set_visiable(IM_Wheel_ScreenID, SureIcon, ENABLE)       --显示确定控件
    set_value(IM_Wheel_ScreenID, SureIcon,0+Language+g_SetDarkModeFlag*2)
    set_enable(IM_Wheel_ScreenID, SureButton, ENABLE)       --使能确定按钮
end

------------------------------------------------------------------------------
--@program:IM_DataEntry_Wheel_UI_Disable
--@brief:数据录入界面滚字轮UI失能
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Wheel_UI_Disable()
    change_screen(IM_DataEntry_ScreenID)
end


------------------------------------------------------------------------------
--@program:IM_DataEntry_Screen_UI_UpData
--@brief:数据录入界面UI跟新
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Screen_UI_UpData()
    set_value(IM_DataEntry_ScreenID, IMDataReviewScreenIcon, 0+Language*1+g_SetDarkModeFlag*2)   --
    set_value(IM_DataEntry_ScreenID, IMDataEntrySureIcon, 0+Language*1+g_SetDarkModeFlag*2)   --
    if g_SetDarkModeFlag == 0 then
        set_text(IM_DataEntry_ScreenID, IMDataEntryName_Icon, IM_DataReview_Name)       --初始化显示病人姓名
        --初始化显示病人生日
        set_text(IM_DataEntry_ScreenID, IMDataEntryBirth_Icon, IM_DataReview_BirthYear.."-"..IM_DataReview_BirthMoon.."-"..IM_DataReview_BirthDay)
        set_text(IM_DataEntry_ScreenID, IMDataEntryNO_Icon, IM_DataReview_NO)   --初始化显示病人编号
        --初始化显示病人治疗日期
        set_text(IM_DataEntry_ScreenID, IMDataEntryTreatDay_Icon, IM_DataReview_TreatYear.."-"..IM_DataReview_TreatMoon.."-"..IM_DataReview_TreatDay)
    else
        set_text(IM_DataEntry_ScreenID, IMDataEntryNameNight_Icon, IM_DataReview_Name)       --初始化显示病人姓名
        --初始化显示病人生日
        set_text(IM_DataEntry_ScreenID, IMDataEntryBirthNight_Icon, IM_DataReview_BirthYear.."-"..IM_DataReview_BirthMoon.."-"..IM_DataReview_BirthDay)
        set_text(IM_DataEntry_ScreenID, IMDataEntryNONight_Icon, IM_DataReview_NO)   --初始化显示病人编号
        --初始化显示病人治疗日期
        set_text(IM_DataEntry_ScreenID, IMDataEntryTreatDayNight_Icon, IM_DataReview_TreatYear.."-"..IM_DataReview_TreatMoon.."-"..IM_DataReview_TreatDay)
    end
    

    for i = 1, 5, 1 do    --初始化显示骨密度
        if i == Bone_Density then
            set_value(IM_DataEntry_ScreenID, i+1, 1+g_SetDarkModeFlag*2)
        else
            set_value(IM_DataEntry_ScreenID, i+1, 0+g_SetDarkModeFlag*2)
        end
    end
    set_value(IM_DataEntry_ScreenID, IMDataEntryNumbering_System_Icon, Numbering_System+Language*2+g_SetDarkModeFlag*4)   --设置编号系统控件值初始化

    if Numbering_System == 0 then           --显示FDI编号
        for i = 1, 32, 1 do
            set_value(IM_DataEntry_ScreenID, i+87, FDINumbering[i])  --初始化显示FDI编号
            if i == Tooth_Number then
                set_value(IM_DataEntry_ScreenID, i+7, 1)       --显示已选择的牙齿图标
            else
                set_value(IM_DataEntry_ScreenID, i+7, 0)       --显示未选择的牙齿图标
            end
        end
    else
        for i = 1, 32, 1 do                 --显示ADA编号
            set_value(IM_DataEntry_ScreenID, i+87, ADANumbering[i])  --初始化显示ADA编号
            if i == Tooth_Number then
                set_value(IM_DataEntry_ScreenID, i+7, 1)       --显示已选择的牙齿图标
            else
                set_value(IM_DataEntry_ScreenID, i+7, 0)       --显示未选择的牙齿图标
            end
        end
    end
end


------------------------------------------------------------------------------
--@program:IM_Export_Screen_UI_UpData
--@brief:报告界面UI跟新
--@return:无
-------------------------------------------------------------------------------
function IM_Export_Screen_UI_UpData(user,program)
    set_value(IM_Report_Screen, IMReportBackgroundIcon, 0+Language*1)
    set_text(IM_Report_Screen, IMReportName_Text, NamaTextBuf[1+Language])       --初始化显示"姓名"文本
    set_text(IM_Report_Screen, IMReportName_Icon, IM_DataReview_Name)       --初始化显示病人姓名
    --初始化显示病人生日
    set_text(IM_Report_Screen, IMReportBirth_Text, BirthTextBuf[1+Language])       --初始化显示"生日"文本
    set_text(IM_Report_Screen, IMReportBirth_Icon, IM_DataReview_BirthYear.."-"..IM_DataReview_BirthMoon.."-"..IM_DataReview_BirthDay)

    set_text(IM_Report_Screen, IMReportNO_Text, NOTextBuf[1+Language])       --初始化显示"患者编号"文本
    set_text(IM_Report_Screen, IMReportNO_Icon, IM_DataReview_NO)   --初始化显示病人编号

    --初始化显示病人治疗日期
    set_text(IM_Report_Screen, IMReportTreatDay_Text, TreatDateTextBuf[1+Language])       --初始化显示"治疗日期"文本
    set_text(IM_Report_Screen, IMReportTreatDay_Icon, IM_DataReview_TreatYear.."-"..IM_DataReview_TreatMoon.."-"..IM_DataReview_TreatDay)

    if Language == 0 then
        set_visiable(IM_Report_Screen, IMReportBone_Text, ENABLE)       --初始化显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBone_Icon, ENABLE)       --初始化显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBoneDensityENText, DISABLE)       --初始化不显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBoneDensityENIcon, DISABLE)       --初始化不显示"骨密度"文本
        set_text(IM_Report_Screen, IMReportBone_Text, BoneTextBuf[1+Language*1])       --初始化显示"骨密度"文本
        set_text(IM_Report_Screen, IMReportBone_Icon, DensityTextBuf[Bone_Density+Language*5])       --初始化显示骨密度
    else
        set_visiable(IM_Report_Screen, IMReportBone_Text, DISABLE)       --初始化显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBone_Icon, DISABLE)       --初始化显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBoneDensityENText, ENABLE)       --初始化不显示"骨密度"文本
        set_visiable(IM_Report_Screen, IMReportBoneDensityENIcon, ENABLE)       --初始化不显示"骨密度"文本
        set_text(IM_Report_Screen, IMReportBoneDensityENText, BoneTextBuf[1+Language*1])       --初始化显示"骨密度"文本
        set_text(IM_Report_Screen, IMReportBoneDensityENIcon, DensityTextBuf[Bone_Density+Language*5])       --初始化显示骨密度
    end
    

    if Numbering_System == 0 then           --显示FDI编号
        for i = 1, 32, 1 do
            set_value(IM_Report_Screen, i+32, FDINumbering[i])  --初始化显示FDI编号
            if i == Tooth_Number then
                set_value(IM_Report_Screen, i, 1)       --显示已选择的牙齿图标
            else
                set_value(IM_Report_Screen, i, 0)       --显示未选择的牙齿图标
            end
        end
    else
        for i = 1, 32, 1 do                 --显示ADA编号
            set_value(IM_Report_Screen, i+32, ADANumbering[i])  --初始化显示ADA编号
            if i == Tooth_Number then
                set_value(IM_Report_Screen, i, 1)       --显示已选择的牙齿图标
            else
                set_value(IM_Report_Screen, i, 0)       --显示未选择的牙齿图标
            end
        end
    end

    for i = 1, 8, 1 do
        if user == 1 then
            if IM_Usr1DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_Report_Screen, 65+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_Report_Screen, 66+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_Report_Screen,67+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_Report_Screen, 67+6*(i-1), ENABLE)      --实际速度控件显示
                set_visiable(IM_Report_Screen, 129+(i-1), ENABLE)      --实际扭矩控件显示
                set_visiable(IM_Report_Screen, 68+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_Report_Screen, 69+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_Report_Screen, 70+6*(i-1), ENABLE)      --速比控件显示
                if IM_Usr1DataReview_Buf[program][i][2] ~= 12 and IM_Usr1DataReview_Buf[program][i][2] ~= 11 and IM_Usr1DataReview_Buf[program][i][2] ~= 10 and IM_Usr1DataReview_Buf[program][i][2] ~= 9 then     --非冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_text(IM_Report_Screen, 129+(i-1), IM_Usr1DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_Report_Screen, 68+6*(i-1), "/"..IM_Usr1DataReview_Buf[program][i][6])   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr1DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr1DataReview_Buf[program][i][2] == 9 then   --骨锯步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                elseif IM_Usr1DataReview_Buf[program][i][2] == 10 or IM_Usr1DataReview_Buf[program][i][2] == 11 then   --高速跟低速步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr1DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr1DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr1DataReview_Buf[program][i][8]])   --设置速比控件显示值
                else            --冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr1DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr1DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_Report_Screen,67+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_Report_Screen, 67+6*(i-1), "/")   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_Report_Screen, 65+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_Report_Screen, 66+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_Report_Screen, 67+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_Report_Screen, 68+6*(i-1), DISABLE)      --设定扭矩控件隐藏
                set_visiable(IM_Report_Screen, 69+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_Report_Screen, 70+6*(i-1), DISABLE)      --速比控件隐藏   
            end
        end
        if user == 2 then
            if IM_Usr2DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_Report_Screen, 65+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_Report_Screen, 66+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_Report_Screen,67+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_Report_Screen, 67+6*(i-1), ENABLE)      --实际速度控件显示
                set_visiable(IM_Report_Screen, 129+(i-1), ENABLE)      --实际扭矩控件显示
                set_visiable(IM_Report_Screen, 68+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_Report_Screen, 69+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_Report_Screen, 70+6*(i-1), ENABLE)      --速比控件显示

                if IM_Usr2DataReview_Buf[program][i][2] ~= 12 and IM_Usr2DataReview_Buf[program][i][2] ~= 11 and IM_Usr2DataReview_Buf[program][i][2] ~= 10 and IM_Usr2DataReview_Buf[program][i][2] ~= 9 then     --非冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_text(IM_Report_Screen, 129+(i-1), IM_Usr2DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_Report_Screen, 68+6*(i-1), "/"..IM_Usr2DataReview_Buf[program][i][6])   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr2DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr2DataReview_Buf[program][i][2] == 9 then   --骨锯步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                elseif IM_Usr2DataReview_Buf[program][i][2] == 10 or IM_Usr2DataReview_Buf[program][i][2] == 11 then   --高速跟低速步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr2DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr2DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr2DataReview_Buf[program][i][8]])   --设置速比控件显示值
                else            --冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr2DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr2DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_Report_Screen,67+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_Report_Screen, 67+6*(i-1), "/")   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_Report_Screen, 65+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_Report_Screen, 66+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_Report_Screen, 67+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_Report_Screen, 68+6*(i-1), DISABLE)      --设定扭矩控件隐藏
                set_visiable(IM_Report_Screen, 69+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_Report_Screen, 70+6*(i-1), DISABLE)      --速比控件隐藏   
            end
        end
        if user == 3 then
            if IM_Usr3DataReview_Buf[program][i][2] ~= 0 then        --当前步骤不为0时，显示该步骤
                set_visiable(IM_Report_Screen, 65+6*(i-1), ENABLE)      --序列号控件显示
                set_visiable(IM_Report_Screen, 66+6*(i-1), ENABLE)      --步骤控件显示
                set_fore_color(IM_Report_Screen,67+6*(i-1),BlueColor)        --设置实际速度控件字体颜色，蓝色
                set_visiable(IM_Report_Screen, 67+6*(i-1), ENABLE)      --实际速度控件显示
                set_visiable(IM_Report_Screen, 129+(i-1), ENABLE)      --实际扭矩控件显示
                set_visiable(IM_Report_Screen, 68+6*(i-1), ENABLE)      --设定扭矩控件显示
                set_visiable(IM_Report_Screen, 69+6*(i-1), ENABLE)      --水量控件显示
                set_visiable(IM_Report_Screen, 70+6*(i-1), ENABLE)      --速比控件显示

                if IM_Usr3DataReview_Buf[program][i][2] ~= 12 and IM_Usr3DataReview_Buf[program][i][2] ~= 11 and IM_Usr3DataReview_Buf[program][i][2] ~= 10 and IM_Usr3DataReview_Buf[program][i][2] ~= 9 then     --非冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度和设定速度控件显示值
                    set_text(IM_Report_Screen, 129+(i-1), IM_Usr3DataReview_Buf[program][i][5])   --设置实际扭矩控件显示值
                    set_text(IM_Report_Screen, 68+6*(i-1), "/"..IM_Usr3DataReview_Buf[program][i][6])   --设置实际扭矩和设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr3DataReview_Buf[program][i][8]])   --设置速比控件显示值
                elseif IM_Usr3DataReview_Buf[program][i][2] == 9 then   --骨锯步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                elseif IM_Usr3DataReview_Buf[program][i][2] == 10 or IM_Usr3DataReview_Buf[program][i][2] == 11 then   --高速跟低速步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_text(IM_Report_Screen, 67+6*(i-1), IM_Usr3DataReview_Buf[program][i][3])   --设置实际速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), IM_Usr3DataReview_Buf[program][i][7])   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), RatioDisplayBuff[IM_Usr3DataReview_Buf[program][i][8]])   --设置速比控件显示值
                else            --冲水步骤
                    set_text(IM_Report_Screen, 65+6*(i-1), IM_Usr3DataReview_Buf[program][i][1])   --设置序列号控件显示值
                    set_value(IM_Report_Screen, 66+6*(i-1), IM_Usr3DataReview_Buf[program][i][2]-1+Language*12)   --设置步骤控件显示值
                    set_fore_color(IM_Report_Screen,67+6*(i-1),BlackColor)        --设置实际速度控件字体颜色，黑色
                    set_text(IM_Report_Screen, 67+6*(i-1), "/")   --设置实际速度和设定速度控件显示值
                    set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                    set_text(IM_Report_Screen, 68+6*(i-1), "/")   --设置设定扭矩控件显示值
                    set_text(IM_Report_Screen, 69+6*(i-1), "/")   --设置水量控件显示值
                    set_text(IM_Report_Screen, 70+6*(i-1), "/")   --设置速比控件显示值
                end
            else
                set_visiable(IM_Report_Screen, 65+6*(i-1), DISABLE)      --序列号控件隐藏
                set_visiable(IM_Report_Screen, 66+6*(i-1), DISABLE)      --步骤控件隐藏
                set_visiable(IM_Report_Screen, 67+6*(i-1), DISABLE)      --实际速度控件隐藏
                set_visiable(IM_Report_Screen, 129+(i-1), DISABLE)      --实际扭矩控件隐藏
                set_visiable(IM_Report_Screen, 68+6*(i-1), DISABLE)      --设定扭矩控件隐藏
                set_visiable(IM_Report_Screen, 69+6*(i-1), DISABLE)      --水量控件隐藏
                set_visiable(IM_Report_Screen, 70+6*(i-1), DISABLE)      --速比控件隐藏   
            end
        end
    end
end



------------------------------------------------------------------------------
--@program:IM_DataEntry_Wheel_Operation
--@brief:滚字轮操作
--@return:无
-------------------------------------------------------------------------------
function IM_DataEntry_Wheel_Operation(flag)
    if flag == 0 then       --flag为0时代表当前滚字轮为病人生日录入
        if g_SetDarkModeFlag == 0 then
            IM_DataReview_BirthYear = get_value(IM_Wheel_ScreenID, YearWheel)
            IM_DataReview_BirthMoon = get_value(IM_Wheel_ScreenID, MoonWheel)
            IM_DataReview_BirthDay = get_value(IM_Wheel_ScreenID, DayWheel)
        else
            IM_DataReview_BirthYear = get_value(IM_Wheel_ScreenID, YearWheel_Night)
            IM_DataReview_BirthMoon = get_value(IM_Wheel_ScreenID, MoonWheel_Night)
            IM_DataReview_BirthDay = get_value(IM_Wheel_ScreenID, DayWheel_Night)
        end
        IM_DataReview_BirthYear = math.floor(IM_DataReview_BirthYear + 1949)
        IM_DataReview_BirthMoon = math.floor(IM_DataReview_BirthMoon + 1)
        IM_DataReview_BirthDay = math.floor(IM_DataReview_BirthDay + 1)
    else
        if g_SetDarkModeFlag == 0 then
            IM_DataReview_TreatYear = get_value(IM_Wheel_ScreenID, YearWheel)
            IM_DataReview_TreatMoon = get_value(IM_Wheel_ScreenID, MoonWheel)
            IM_DataReview_TreatDay = get_value(IM_Wheel_ScreenID, DayWheel)
        else
            IM_DataReview_TreatYear = get_value(IM_Wheel_ScreenID, YearWheel_Night)
            IM_DataReview_TreatMoon = get_value(IM_Wheel_ScreenID, MoonWheel_Night)
            IM_DataReview_TreatDay = get_value(IM_Wheel_ScreenID, DayWheel_Night)
        end
        IM_DataReview_TreatYear = math.floor(IM_DataReview_TreatYear + 1949)
        IM_DataReview_TreatMoon = math.floor(IM_DataReview_TreatMoon + 1)
        IM_DataReview_TreatDay = math.floor(IM_DataReview_TreatDay + 1)
    end

end



-----------------------------------------------------------------------------
--@program:IM_DataReview_Operation
--@brief:种植模式设置界面操作
--@param:control:控件编号
--@param:value:控件值
--@param:steps:当前选择的步骤
--@return:无
-------------------------------------------------------------------------------
function IM_DataReview_Operation(user,program,steps,control, value)
    local screenid = get_current_screen()
    if screenid == IM_DataReview_ScreenID then      --数据查看界面
        if value == ENABLE then
            if control == IMDataReviewReturn then
                IM_DataReview_Screen_Exit()             --退出按钮
                SendData()  --发送函数
                KeyBeep_App()
            elseif control == IMDataReviewMagnify then
                IM_LineChart_Magnify_Enter()          --放大按钮
                KeyBeep_App()
            elseif control == IMExportEnter then
                IM_DataEntry_Screen_UI_UpData()          --数据录入界面UI更新
                IM_DataEntry_Screen_Enter()          --数据录入界面进入按钮
                KeyBeep_App()
            end
        end
    elseif screenid == IM_LineChartMagnify_ScreenID then
        if value == ENABLE then
            if control == IMLineChartMagnifyReturn then
                IM_LineChart_Magnify_Exit()          --退出按钮
                IM_DataReview_Screen_UI_Init(user,program,steps)          --数据查看界面UI初始化
                KeyBeep_App()
            end
        end
    elseif screenid == IM_DataEntry_ScreenID then
        if value == ENABLE then
            if control == IMDataEntryReturn then
                IM_DataEntry_Screen_Exit()             --退出按钮
                IM_DataReview_Screen_UI_Init(user,program,steps)          --数据查看界面UI初始化
                KeyBeep_App()
            elseif control == IMDataEntrySure then          --截图
                change_screen(IM_Report_Screen)
                IM_Export_Screen_UI_UpData(user,program)          --数据导出界面UI更新
                start_timer(IMReportScreenShot_Timer, 3000, 0, 1)          --截图定时器启动
                KeyBeep_App()
            elseif control == IMReportName_Button then                --姓名点击输入按键
                IM_Set_ProgramName_Change(control)        --切换到键盘输入程序名
                KeyBeep_App()
            elseif control == IMReportNO_Button then        --编号点击输入按键
                IM_Set_ProgramName_Change(control)        --切换到键盘输入程序名
                KeyBeep_App()
            elseif control == IMReportBirthWheel_BUtton then
                WheelFlag = 0           --生日滚字轮标志位
                IM_DataEntry_Wheel_UI_Enable()          --数据录入界面滚字轮UI使能
                KeyBeep_App()
            elseif control == IMReportTreatWheel_BUtton then
                WheelFlag = 1           --治疗日期滚字轮标志位
                IM_DataEntry_Wheel_UI_Enable()          --数据录入界面滚字轮UI使能
                KeyBeep_App()
            elseif control == CancelButton then  --滚字轮取消按钮
                IM_DataEntry_Wheel_UI_Disable()          --数据录入界面滚字轮UI失能
                KeyBeep_App()
            elseif control == SureButton then
                IM_DataEntry_Wheel_UI_Disable()          --数据录入界面滚字轮UI失能
                KeyBeep_App()
                IM_DataEntry_Wheel_Operation(WheelFlag)
            elseif control > 47 and control < 53  then
                Bone_Density = control - 47     --骨密度选择
                KeyBeep_App()
            elseif control == FDINumbering_Button or control == ADANumbering_Button then
                Numbering_System = control - 53     --编号系统选择
                KeyBeep_App()
            elseif control == FDINumbering_EN_Button or control == ADANumbering_EN_Button then
                Numbering_System = control - 129     --编号系统选择
                KeyBeep_App()
            elseif control > 55 and control < 88  then
                Tooth_Number = control - 55     --牙齿选择
                KeyBeep_App()
            end
        end
        IM_DataEntry_Screen_UI_UpData()          --数据录入界面UI更新
    elseif screenid == IM_Wheel_ScreenID then
        if control == CancelButton then  --滚字轮取消按钮
            IM_DataEntry_Wheel_UI_Disable()          --数据录入界面滚字轮UI失能
            KeyBeep_App()
        elseif control == SureButton then
            IM_DataEntry_Wheel_UI_Disable()          --数据录入界面滚字轮UI失能
            KeyBeep_App()
            IM_DataEntry_Wheel_Operation(WheelFlag)
            IM_DataEntry_Screen_UI_UpData()          --数据录入界面UI更新
        end
    end
end






