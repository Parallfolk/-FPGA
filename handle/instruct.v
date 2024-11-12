//*********************************************************
//通过97位的指令信号进行串口发送
//*********************************************************

module  instruct
#(
    //parameter   UART_BPS    =   'd115200                            ,//115200波特率
    parameter   UART_BPS    =   'd89467                            ,//115200波特率
    //parameter   CLK_FREQ    =   'd123_750_000                         //时钟信号频率
    parameter   CLK_FREQ    =   'd96_000_000                         //时钟信号频率
)
(
    input   wire            sys_clk     ,   //时钟信号
    input   wire            sys_rst_n   ,   //复位信号
    input   wire            pi_flag     ,   //输入标志信号
    input   wire            en          ,   //使能信号
    input   wire    [7:0]   DIGIT_CNT   ,   //位数
    input   wire    [815:0] DATA        ,   //指令信号
    
    output  reg             tx          ,   //输出信号
    output  reg             tx_flag         //输出标志信号
);

parameter   BAUD_CNT_MAX   =     CLK_FREQ / UART_BPS;     //baud计数信号最大值

reg             work_flag   ;   //使能标志信号
reg             work_flag0  ;   //使能标志信号0
reg             work_en     ;   //使能信号
reg     [15:0]  baud_cnt    ;   //baud计数信号
reg             bit_flag    ;   //bit标志信号
reg     [3:0]   bit_cnt     ;   //bit计数信号
reg     [7:0]   digit_cnt   ;   //位数计数信号


//对使能标志信号0进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        work_flag0 <= 1'b0;
    else 
        work_flag0 <= pi_flag;
        
//对使能标志信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        work_flag <= 1'b0;
    else 
        work_flag <= work_flag0;
        
    
//对使能信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        work_en <= 1'b0;    
    else    if(work_flag == 1'b1 && en == 1'b1)
        work_en <= 1'b1;
    else    if(((bit_cnt == 4'd10) && (bit_flag == 1'b1) && (digit_cnt == 4'd0)) || en == 1'b0)
        work_en <= 1'b0;
    else
        work_en <= work_en;

//对baud计数信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        baud_cnt <= 16'd0;
    else    if((work_en == 1'b0) || (baud_cnt == BAUD_CNT_MAX))
        baud_cnt <= 16'd0;
    else    if(work_en == 1'b1)
        baud_cnt <=baud_cnt + 16'd1;

//对bit标志信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        bit_flag <= 1'b0;
    else    if(baud_cnt == 16'd1)
        bit_flag <= 1'b1;
    else
        bit_flag <= 1'b0;
        
//对bit计数信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        bit_cnt <= 4'd0;
    else    if((bit_cnt == 4'd10) && (bit_flag ==1'b1)) 
        bit_cnt <= 4'd0;
    else    if(bit_flag ==1'b1) 
        bit_cnt <= bit_cnt + 4'd1;
        
//对输出标志信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        tx_flag <= 1'b0;
    else    if((bit_cnt == 4'd10) && (bit_flag == 1'b1) && (digit_cnt == 4'd0))
        tx_flag <= 1'b1;
    else
        tx_flag <= 1'b0;
        
//对位计数信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        digit_cnt <= DIGIT_CNT - 1;
    else    if(work_flag == 1'b1)
        digit_cnt <= DIGIT_CNT - 1;
    else    if((bit_cnt == 4'd10) && (bit_flag == 1'b1)) 
        digit_cnt <= digit_cnt - 8'd1; 
		
		
		
//对输出信号进行赋值（rs232用于通过串口屏调试）
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        tx <= 1'b1;
    else    if(bit_flag ==1'b1) 
        case(bit_cnt)
            0:tx <= 1'b0;  
            1:tx <= DATA[(digit_cnt * 8)+3'd0];
            2:tx <= DATA[(digit_cnt * 8)+3'd1];
            3:tx <= DATA[(digit_cnt * 8)+3'd2];
            4:tx <= DATA[(digit_cnt * 8)+3'd3];
            5:tx <= DATA[(digit_cnt * 8)+3'd4];
            6:tx <= DATA[(digit_cnt * 8)+3'd5];
            7:tx <= DATA[(digit_cnt * 8)+3'd6];
            8:tx <= DATA[(digit_cnt * 8)+3'd7];
            9:tx <= 1'b1;
            default:tx <= 1'b1;
        endcase



/*



//对输出信号进行赋值(ttl用于驱动机械臂)
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        tx <= 1'b0;
    else    if(bit_flag ==1'b1) 
        case(bit_cnt)
            0:tx <= 1'b1;  
            1:tx <= ~DATA[(digit_cnt * 8)+3'd0];
            2:tx <= ~DATA[(digit_cnt * 8)+3'd1];
            3:tx <= ~DATA[(digit_cnt * 8)+3'd2];
            4:tx <= ~DATA[(digit_cnt * 8)+3'd3];
            5:tx <= ~DATA[(digit_cnt * 8)+3'd4];
            6:tx <= ~DATA[(digit_cnt * 8)+3'd5];
            7:tx <= ~DATA[(digit_cnt * 8)+3'd6];
            8:tx <= ~DATA[(digit_cnt * 8)+3'd7];
            9:tx <= 1'b0;
            default:tx <= 1'b0;
        endcase



*/
endmodule