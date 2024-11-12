module  uart_rx//串口接收模块
#(
    //parameter   UART_BPS    =   'd115200      ,//115200波特率
    parameter   UART_BPS    =   'd89367      ,//115200波特率
    //parameter   CLK_FREQ    =   'd123_750_000  //时钟信号频率
    parameter   CLK_FREQ    =   'd96_000_000  //时钟信号频率
)
(   
    input   wire            sys_clk     ,   //时钟信号
    input   wire            sys_rst_n   ,   //复位信号
    input   wire            rx          ,   //输入串口信号
        
    output  reg     [7:0]   po_data     ,   //输出的并行数据
    output  reg             po_flag         //输出标志信号
);

parameter   BAUD_CNT_MAX   =     CLK_FREQ / UART_BPS;     //baud计数信号最大值

reg             rx_reg1     ;   
reg             rx_reg2     ;
reg             rx_reg3     ;   //消抖(与时钟同步)
reg             start_flag  ;   //起始标志位
reg             work_en     ;   //使能信号
reg     [15:0]  baud_cnt    ;   //baud计数信号
reg             bit_flag    ;   //bit标志信号
reg     [3:0]   bit_cnt     ;   //bit计数信号
reg     [7:0]   rx_data     ;   //读取信号内容
reg             rx_flag     ;   //终止标志位

//消抖(与时钟同步)
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        rx_reg1 <= 1'b1;
    else    
        rx_reg1 <= rx;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        rx_reg2 <= 1'b1;
    else    
        rx_reg2 <= rx_reg1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        rx_reg3 <= 1'b1;
    else    
        rx_reg3 <= rx_reg2;
        
//对起始标志位赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        start_flag <= 1'b0;
    else    if((rx_reg3 == 1'b1) && (rx_reg2 == 1'b0) && (work_en == 1'b0))
        start_flag <= 1'b1;
    else
        start_flag <= 1'b0;
      
//对使能信号赋值  
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        work_en <= 1'b0;
    else    if(start_flag == 1'b1)
        work_en <= 1'b1;
    else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
        work_en <= 1'b0;       
    else
        work_en <= work_en;
        
//对baud计数信号进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        baud_cnt <= 16'd0;
    else    if((baud_cnt == (BAUD_CNT_MAX - 1)) || (work_en == 1'b0))
        baud_cnt <= 16'd0;
    else    if(work_en == 1'b1)
        baud_cnt <= baud_cnt + 16'd1;
        
//对bit标志信号进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)       
        bit_flag <= 1'b0;
    else    if(baud_cnt == (BAUD_CNT_MAX / 2 - 1))
        bit_flag <= 1'b1;
    else
        bit_flag <= 1'b0;
        
//对bit计数信号进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        bit_cnt <= 4'd0;
    else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
        bit_cnt <= 4'd0;
    else    if(bit_flag == 1'b1)
        bit_cnt <= bit_cnt + 4'd1;
        
//拼接数据
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        rx_data <= 8'b0;
    else    if((bit_cnt >= 4'd1) && (bit_cnt <= 4'd8) && (bit_flag == 1'b1))
        rx_data <= {rx_reg3,rx_data[7:1]};
    
//对终止标志位进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        rx_flag <= 1'b0;
    else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
        rx_flag <= 1'b1;
    else
        rx_flag <= 1'b0;
        
//对输出的并行数据进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        po_data <= 8'b0;
    else    if(rx_flag == 1'b1)
        po_data <= rx_data;
        
//对输出标志信号进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)     
        po_flag <= 1'b0;
    else
        po_flag <= rx_flag;
    
endmodule