`define	W_All           [159:0]
`define	W_A		        [159:144]
`define	W_buwei	        [143:140]
`define	W_black_cnt_max [139:128]
`define	W_deh			[127:116]
`define	W_NCNT 		    [115:104]
`define	W_red_max		[103:92]
`define	W_red_min		[91:80]
`define	W_Yellow_max    [79:72]
`define	W_Yellow_min    [71:64]
`define	W_Mode		    [63:56]
`define	W_Y_max		    [63:56]
`define	W_Y_min		    [55:48]
`define	W_Cb_max	    [47:40]
`define	W_Cb_min	     [39:32]
`define	W_Cr_max	    [31:24]
`define	W_Cr_min	    [23:16]
`define	W_B	            [15: 0]
`define	W_need	        [143:16]
module  uart
(
	input	wire		    sys_clk 	,
	input	wire		    sys_rst_n	,
	input	wire		    rx			,
	input	wire    [11:0]  target_x    ,
	input	wire    [11:0]  target_y    ,
	
	output	wire		    tx			,
	output	reg	    `W_All	need_data	
);
    parameter   	CNT_MAX = 20'd999_999   ;
	reg             pi_flag     ;   //输入信号
    reg     [19:0]  cnt_20ms    ;
    wire            po_flag,en_flag ;
    reg             tx_en       ;
    reg     [6:0]   tx_cnt      ;

    wire	[7:0]	po_data;
    wire            pa_flag;
    reg		`W_All	rx_data	;
    assign en_flag = (rx_data[23:0] == {"g","e","t"})&&pa_flag;
    //对tx使能信号赋值
    always@(posedge sys_clk or negedge  sys_rst_n)
        if(sys_rst_n == 1'b0)
            tx_en <= 1'b0;
        else    if(tx_cnt == 7'd10)
            tx_en <= 1'b0;
        else    
            tx_en <= 1'b1;
    always@(posedge sys_clk or negedge  sys_rst_n)
        if(sys_rst_n == 1'b0)
            tx_cnt <= 7'd10;
        else    if(en_flag)
            tx_cnt <= 1'b1;
        else    if(tx_cnt < 7'd10 && po_flag)
            tx_cnt <= tx_cnt + 1'b1;
    //对消抖信号进行赋值
    always@(posedge sys_clk or negedge  sys_rst_n)
        if(sys_rst_n == 1'b0)
            cnt_20ms <= CNT_MAX;
        else    if(po_flag || en_flag)
            cnt_20ms <= 20'd0;
        else    if(cnt_20ms == CNT_MAX)
            cnt_20ms <= CNT_MAX;
        else
            cnt_20ms <= cnt_20ms + 20'd1;
    //对输入信号进行赋值
    always@(posedge sys_clk or negedge  sys_rst_n)
        if(sys_rst_n == 1'b0)
            pi_flag <= 1'b0;
        else    if(cnt_20ms == (CNT_MAX - 20'd1))
            pi_flag <= 1'b1;
            
        else
            pi_flag <= 1'b0;
    //实例化指令模块        
    instruct instruct_inst
    (
        .sys_clk     (sys_clk   ),   //时钟信号
        .sys_rst_n   (sys_rst_n	),   //复位信号
        .pi_flag     (pi_flag  	),   //输入标志信号
        .DIGIT_CNT   ('d20   	),   //位数
        .DATA        ({16'haaaa,
						need_data`W_need,
                        16'hbbbb}),   //指令信号			{8'hAB,space,8'hBA}
        .en          (tx_en  	),   //指令信号
        
        .tx          (tx	),   //输出信号
        .tx_flag     (po_flag  	)    //输出标志信号
    );
    //rx_data
    always@(posedge pa_flag or negedge sys_rst_n)
        if(!sys_rst_n)
            rx_data <= 160'd0;
        else
            rx_data <= {rx_data[151:0],po_data};
    always@(posedge pa_flag or negedge sys_rst_n)
        if(!sys_rst_n) begin
            //need_data <= {16'd0,12'd5,12'd10,12'd10,12'd50,12'd0,8'd140,8'd110,8'd255,8'd250,8'd100,8'd70,8'd40,8'd0,16'd0};
            need_data`W_A               <= 16'haaaa ;
            need_data`W_buwei           <= 4'h0 ;
            need_data`W_Y_min           <= 8'd250 ;
            need_data`W_Cb_max          <= 8'd80 ;
            need_data`W_Cb_min          <= 8'd40 ;
            need_data`W_Cr_max          <= 8'd40 ;
            need_data`W_Cr_min          <= 8'd0 ;
            need_data`W_Yellow_max      <= 8'd200 ;
            need_data`W_Yellow_min      <= 8'd80 ;
            need_data`W_Mode            <= 8'd1   ;
            need_data`W_black_cnt_max   <= 12'd10 ;
            need_data`W_deh			    <=  12'd5 ;
            need_data`W_NCNT 		    <=  12'd5 ;
            need_data`W_red_max		    <= 12'd50 ;
            need_data`W_red_min		    <= 12'd2 ;
            need_data`W_B               <= 16'hbbbb ;          
        end
        else    if(rx_data`W_A == 16'haaaa && rx_data`W_B == 16'hbbbb && pa_flag)
            need_data <= rx_data;
    //串口接收模块
    uart_rx uart_rx_inst
    (
        .sys_clk     (sys_clk  ),   //时钟信号
        .sys_rst_n   (sys_rst_n),   //复位信号
        .rx          (rx		),   //输入串口信号
                      
        .po_data     (po_data  ),   //输出的并行数据
        .po_flag     (pa_flag  )    //输出标志信号
    );

endmodule
