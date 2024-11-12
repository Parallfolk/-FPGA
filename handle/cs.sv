`define	W_Y_max		[47:40]
`define	W_Y_min		[39:32]
`define	W_Cb_max	[31:24]
`define	W_Cb_min	[23:16]
`define	W_Cr_max	[15: 8]
`define	W_Cr_min	[ 7: 0]

module  cs
#(
    parameter   CNT_MAX = 20'd999_999	,
	parameter	Begin_point0  = {9'd148,9'd0}	,
	parameter	Begin_point1  = {9'd73,9'd190}	,
	parameter	Begin_point2  = {9'd73,9'd148}	,
	parameter	Begin_point3  = {9'd73,9'd106}	,
	parameter	Begin_point4  = {9'd24 ,9'd190}	,
	parameter	Begin_point5  = {9'd24 ,9'd148}	,
	parameter	Begin_point6  = {9'd24 ,9'd106}	,
	parameter	Begin_point7  = {1'b1,8'd24 ,9'd190},
	parameter	Begin_point8  = {1'b1,8'd24 ,9'd148},
	parameter	Begin_point9  = {1'b1,8'd24 ,9'd106},
	parameter	Begin_point10 = {1'b1,8'd73,9'd190}	,
	parameter	Begin_point11 = {1'b1,8'd73,9'd148}	,
	parameter	Begin_point12 = {1'b1,8'd73,9'd106}	,
	parameter	End_point0  = {9'd148,9'd0}			,
	parameter	End_point1  = {9'd73,1'b1,8'd106}	,
	parameter	End_point2  = {9'd73,1'b1,8'd148}	,
	parameter	End_point3  = {9'd73,1'b1,8'd190}	,
	parameter	End_point4  = {9'd24 ,1'b1,8'd106}	,
	parameter	End_point5  = {9'd24 ,1'b1,8'd148}	,
	parameter	End_point6  = {9'd24 ,1'b1,8'd190}	,
	parameter	End_point7  = {1'b1,8'd24 ,1'b1,8'd106}	,
	parameter	End_point8  = {1'b1,8'd24 ,1'b1,8'd148}	,
	parameter	End_point9  = {1'b1,8'd24 ,1'b1,8'd190}	,
	parameter	End_point10 = {1'b1,8'd73,1'b1,8'd106}	,
	parameter	End_point11 = {1'b1,8'd73,1'b1,8'd148}	,
	parameter	End_point12 = {1'b1,8'd73,1'b1,8'd190}	,	
    parameter    area0      =    16'd9500    ,
    parameter    area1      =    16'd7950    ,
    parameter    area2      =    16'd7400    ,
    parameter    area3      =    16'd6600    ,
    parameter    area4      =    16'd6050    ,
    parameter    area5      =    16'd4900    ,
    parameter    area6      =    16'd9800    ,
    parameter    area7      =    16'd8500    ,
    parameter    area8      =    16'd7800    ,
    parameter    area9      =    16'd6800    ,
    parameter    area10     =    16'd6400    ,
    parameter    area11     =    16'd5300    ,
    parameter    area12     =    16'd10000    ,
    parameter    area13     =    16'd8700    ,
    parameter    area14     =    16'd8000    ,
    parameter    area15     =    16'd6640    ,
    parameter    area16     =    16'd6500    ,
    parameter    area17     =    16'd5500    ,
    parameter    area18     =    16'd10400    ,
    parameter    area19     =    16'd8700    ,
    parameter    area20     =    16'd7900    ,
    parameter    area21     =    16'd7050    ,
    parameter    area22     =    16'd6600    ,
    parameter    area23     =    16'd5600    ,
    parameter    Color_idfine0   = 220        ,
    parameter    Color_idfine1   = 80        ,
    parameter    Color_idfine2   = 24        ,
    parameter    Color_idfine3   = 137        ,
    parameter    Color_idfine4   = 50        ,
    parameter    Color_idfine5   = 145        ,
    parameter    Color_idfine6   = 79        ,
    parameter    Color_idfine7   = 32        ,
    parameter    Color_idfine8   = 206        ,
    parameter    Color_idfine9   = 95        ,
    parameter    Color_idfine10  = 25        ,
    parameter    Color_idfine11  = 141        ,
    parameter    Color_idfine12  = 30        ,
    parameter    Color_idfine13  = 135        ,
    parameter    Color_idfine14  = 80        ,
    parameter    Color_idfine15  = 48        ,
    parameter    Bright  = 8'hCF


)
(
    input   wire            sys_clk     ,   //时钟信号
    input   wire            sys_rst_n   ,   //复位信号
    input   wire    [3:0]   key_in      ,   //按键信号
	 input	wire	[2:0]	key_switch  ,
    input   wire            en          ,   //使能信号
	input	wire			rx			,
 
    

    //摄像头接口
    input                 cam_pclk    ,  //cmos 数据像素时钟
    input                 cam_vsync   ,  //cmos 场同步信号
    input                 cam_href    ,  //cmos 行同步信号
    input        [7:0]    cam_data    ,  //cmos 数据  
    output                cam_rst_n   ,  //cmos 复位信号，低电平有效
    output                cam_pwdn    ,  //cmos 电源休眠模式选择信号
    output                cam_scl     ,  //cmos SCCB_SCL线
    inout                 cam_sda     ,  //cmos SCCB_SDA线
	
    //SDRAM接口
    output                sdram_clk   ,  //SDRAM 时钟
    output                sdram_cke   ,  //SDRAM 时钟有效
    output                sdram_cs_n  ,  //SDRAM 片选
    output                sdram_ras_n ,  //SDRAM 行有效
    output                sdram_cas_n ,  //SDRAM 列有效
    output                sdram_we_n  ,  //SDRAM 写有效
    output       [1:0]    sdram_ba    ,  //SDRAM Bank地址
    output       [1:0]    sdram_dqm   ,  //SDRAM 数据掩码
    output       [12:0]   sdram_addr  ,  //SDRAM 地址
    inout        [15:0]   sdram_data  ,  //SDRAM 数据    
	
    //VGA接口                          
    output                vga_hs      ,  //行同步信号
    output                vga_vs      ,  //场同步信号
    output        [15:0]  vga_rgb      , //红绿蓝三原色输出

	 
	 //机械臂
	 output  wire            tx              //机械臂输出信号 
	
);
wire    [11:0]  data0       ;   //数据信号
wire    [11:0]  data1       ;   //数据信号
wire    [11:0]  data2       ;   //数据信号
wire    [11:0]  data3       ;   //数据信号
wire    [11:0]  data4       ;   //数据信号
wire    [11:0]  data5       ;   //数据信号
wire    [19:0]  bcd0        ;   //bcd信号
wire    [19:0]  bcd1        ;   //bcd信号
wire    [19:0]  bcd2        ;   //bcd信号
wire    [19:0]  bcd3        ;   //bcd信号
wire    [19:0]  bcd4        ;   //bcd信号
wire    [19:0]  bcd5        ;   //bcd信号
wire    [3:0]   cnt_flag    ;
wire    [815:0] instruct    ;   //指令信号
wire            po_flag     ;
wire            delay_flag  ;
wire            time_module ;
wire            mo_flag     ;
wire    [2:0]   color_flag  ;   //颜色信号 
wire    [22:0]  target [2:0];   //在color_flag == 4'dxx情况下的目标形状与坐标
wire	[22:0]  rotate		;	//旋转角
wire   	[15:0] 	space      	;
wire			move_en		;	//运动使能

wire	[2:0]      flag_change_color   ;
wire   [1:0]      flag_switch		   ;
wire         add_press			   ;
wire         minus_press		   ;

reg	[15:0]	area	[23:0]	;	//形状阈值
reg	[9:0]	color_limit	[15:0]	;	//颜色阈值

reg		[9:0] 	data_color_1;
reg		[9:0] 	data_color_2;	
reg		[9:0] 	data_color_3;	

	 
reg     [17:0]  begin_point		;	//起点 
reg     [17:0]  end_point  		;	//终点
reg     [17:0]  rotate_point	;	//旋转点
reg 			mi_flag			;
reg 	[3:0]	mi_cnt			;	//移动计数器
reg             pi_flag     	;   //输入信号
reg     [19:0]  cnt_20ms    	;   //使能消抖
wire    [17:0]  begin_point_mid	;	//起点的中转变量
reg     [17:0]  end_point_mid  	;	//终点的中转变量
wire    [17:0]  rotate_point_mid;	//旋转点的中转变量
reg				en1				;	//机械臂待机使能信号
reg 			flag_key_1	 	;
reg 			flag_key_2	 	;

wire	[7:0]	po_data	;
wire			pa_flag	;
reg		[143:0]	rx_data	;
reg		[115:0]	need_date	;
reg				need_en		;
reg		[7:0]	bright;
//rx_data
always@(posedge pa_flag or negedge sys_rst_n)
	if(!sys_rst_n)
		rx_data <= 144'd0;
	else
		rx_data <= {rx_data[135:0],po_data};

always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)
		need_date <= 116'd0;
	else	if(rx_data[143:132] == 12'haaa || rx_data[15:0] == 16'hbbbb)
		need_date <= rx_data[131:16];
		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)
		need_en <= 1'b0;
	else	if(rx_data[143:132] == 12'haaa || rx_data[15:0] == 16'hbbbb)
		need_en <= 1'b1;
//亮度
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)		bright <= Bright;
	else	if(need_en)	bright <= need_date`B;
//面积阈值
//黑色正方形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[0] <= area0;
	else	if(need_date`W_CS =={2'b00,2'b11}&&need_en)	area[0] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[1] <= area1;
	else	if(need_date`W_CS =={2'b00,2'b11}&&need_en)	area[1] <= need_date`W_AMN;
//黑色圆形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[2] <= area2;
	else	if(need_date`W_CS =={2'b00,2'b10}&&need_en)	area[2] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[3] <= area3;
	else	if(need_date`W_CS =={2'b00,2'b10}&&need_en)	area[3] <= need_date`W_AMN;
//黑色六边形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[4] <= area4;
	else	if(need_date`W_CS =={2'b00,2'b01}&&need_en)	area[4] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[5] <= area5;
	else	if(need_date`W_CS =={2'b00,2'b01}&&need_en)	area[5] <= need_date`W_AMN;
//黄色正方形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[6] <= area6;
	else	if(need_date`W_CS =={2'b01,2'b11}&&need_en)	area[6] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[7] <= area7;
	else	if(need_date`W_CS =={2'b01,2'b11}&&need_en)	area[7] <= need_date`W_AMN;
//黄色圆形		                      
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[8] <= area8;
	else	if(need_date`W_CS =={2'b01,2'b10}&&need_en)	area[8] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[9] <= area9;
	else	if(need_date`W_CS =={2'b01,2'b10}&&need_en)	area[9] <= need_date`W_AMN;
//黄色六边形		                  
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[10] <= area10;
	else	if(need_date`W_CS =={2'b01,2'b01}&&need_en)	area[10] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[11] <= area11;
	else	if(need_date`W_CS =={2'b01,2'b01}&&need_en)	area[11] <= need_date`W_AMN;
//蓝色正方形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[12] <= area12;
	else	if(need_date`W_CS =={2'b10,2'b11}&&need_en)	area[12] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[13] <= area13;
	else	if(need_date`W_CS =={2'b10,2'b11}&&need_en)	area[13] <= need_date`W_AMN;
//蓝色圆形		                      
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[14] <= area14;
	else	if(need_date`W_CS =={2'b10,2'b10}&&need_en)	area[14] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[15] <= area15;
	else	if(need_date`W_CS =={2'b10,2'b10}&&need_en)	area[15] <= need_date`W_AMN;
//蓝色六边形		                  
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[16] <= area16;
	else	if(need_date`W_CS =={2'b10,2'b01}&&need_en)	area[16] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[17] <= area17;
	else	if(need_date`W_CS =={2'b10,2'b01}&&need_en)	area[17] <= need_date`W_AMN;
//红色正方形		
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[18] <= area18;
	else	if(need_date`W_CS =={2'b11,2'b11}&&need_en)	area[18] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[19] <= area19;
	else	if(need_date`W_CS =={2'b11,2'b11}&&need_en)	area[19] <= need_date`W_AMN;
//红色圆形		                      
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[20] <= area20;
	else	if(need_date`W_CS =={2'b11,2'b10}&&need_en)	area[20] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[21] <= area21;
	else	if(need_date`W_CS =={2'b11,2'b10}&&need_en)	area[21] <= need_date`W_AMN;
//红色六边形		                  
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[22] <= area22;
	else	if(need_date`W_CS =={2'b11,2'b01}&&need_en)	area[22] <= need_date`W_AMX;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)								area[23] <= area23;
	else	if(need_date`W_CS =={2'b11,2'b01}&&need_en)	area[23] <= need_date`W_AMN;
	
//颜色阈值
//黑色
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[0] <= Color_idfine0;
	else	if(need_date`W_color ==2'b00&&need_en)	color_limit[0] <= need_date`W_C1;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[8] <= Color_idfine8;
	else	if(need_date`W_color ==2'b00&&need_en)	color_limit[8] <= need_date`W_C4;
//黄色
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[1] <= Color_idfine1;
	else	if(need_date`W_color ==2'b01&&need_en)	color_limit[1] <= need_date`W_C1;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[9] <= Color_idfine9;
	else	if(need_date`W_color ==2'b01&&need_en)	color_limit[9] <= need_date`W_C4;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[2] <= Color_idfine2;
	else	if(need_date`W_color ==2'b01&&need_en)	color_limit[2] <= need_date`W_C2;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[10] <= Color_idfine10;
	else	if(need_date`W_color ==2'b01&&need_en)	color_limit[10] <= need_date`W_C5;
//蓝色
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[3] <= Color_idfine3;
	else	if(need_date`W_color ==2'b10&&need_en)	color_limit[3] <= need_date`W_C1;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[11] <= Color_idfine11;
	else	if(need_date`W_color ==2'b10&&need_en)	color_limit[11] <= need_date`W_C4;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[4] <= Color_idfine4;
	else	if(need_date`W_color ==2'b10&&need_en)	color_limit[4] <= need_date`W_C2;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[12] <= Color_idfine12;
	else	if(need_date`W_color ==2'b10&&need_en)	color_limit[12] <= need_date`W_C5;
//红色
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[5] <= Color_idfine5;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[5] <= need_date`W_C1;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[13] <= Color_idfine13;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[13] <= need_date`W_C4;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[6] <= Color_idfine6;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[6] <= need_date`W_C2;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[14] <= Color_idfine14;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[14] <= need_date`W_C5;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[7] <= Color_idfine7;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[7] <= need_date`W_C3;
always@(posedge sys_clk or negedge sys_rst_n)
	if(!sys_rst_n)							color_limit[15] <= Color_idfine15;
	else	if(need_date`W_color ==2'b11&&need_en)	color_limit[15] <= need_date`W_C6;


//切换二值化显示和彩色图像显示
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
		flag_key_1 <= 1'b0;
	else
		flag_key_1 <= key_switch[1];
		
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
		flag_change_color <= 3'b0;
	else
		flag_change_color <= need_date`W_color;

always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
		flag_switch <= 2'b0;
	else if(cnt_flag[1] == 1'b1)
		flag_switch <= flag_switch + 1'b1;
	else if(flag_switch == 2'b11)
		flag_switch <= 2'b0;
	else
		flag_switch <= flag_switch;
		
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
		flag_key_2 <= 1'b0;
	else
		flag_key_2 <= key_switch[2];

//对消抖信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_20ms <= 20'd0;
    else    if(en == 1'b0)
        cnt_20ms <= 20'd0;
    else    if(cnt_20ms == CNT_MAX)
        cnt_20ms <= CNT_MAX;
    else
        cnt_20ms <= cnt_20ms + 20'd1;

//对输入信号进行赋值
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
        pi_flag <= 1'b0;
    else    if(cnt_20ms == (CNT_MAX - 20'd1) || delay_flag == 1'b1)
        pi_flag <= 1'b1;
		
    else
        pi_flag <= 1'b0;

	/*
always@(posedge sys_clk or negedge  sys_rst_n)
    if(sys_rst_n == 1'b0)
		  begin
			  data_color_1 <= 10'd0;
			  data_color_2 <= 10'd0;
			  data_color_3 <= 10'd0		;	
		  end
	  else
		begin
			case(flag_change_color)
				3'b000:begin	data_color_1 <= black1_Y_max	;		data_color_2 <= 10'd0					;	data_color_3 <= 10'd0		;						end
				3'b001:begin	data_color_1 <= yellow1_Cb_max;	   data_color_2 <= yellow1_Y_min			;	data_color_3 <= 10'd0		;						end
				3'b010:begin	data_color_1 <= blue1_Cb_min	;		data_color_2 <= blue1_Y_min			;	data_color_3 <= 10'd0		;						end
				3'b011:begin	data_color_1 <= red1_Cr_min	;		data_color_2 <= red1_Cb_min			;	data_color_3 <= red1_Y_min ;				      end

				
				3'b100:begin	data_color_1 <= black2_Y_max	;		data_color_2 <= 10'd0					;	data_color_3 <= 10'd0		;						end
				3'b101:begin	data_color_1 <= yellow2_Cb_max;	   data_color_2 <= yellow2_Y_min			;	data_color_3 <= 10'd0		;						end
				3'b110:begin	data_color_1 <= blue2_Cb_min	;		data_color_2 <= blue2_Y_min			;	data_color_3 <= 10'd0		;						end
				3'b111:begin	data_color_1 <= red2_Cr_min	;		data_color_2 <= red2_Cb_min			;	data_color_3 <= red2_Y_min ;				      end
				default:begin	data_color_1 <= 10'd0;	data_color_2 <= 10'd0;	data_color_3 <= 10'd0		;	end
			endcase
		end
*/
//串口接收模块
uart_rx uart_rx_inst
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .rx          (rx       ),   //输入串口信号
                  
    .po_data     (po_data  ),   //输出的并行数据
    .po_flag     (pa_flag  )    //输出标志信号
);
/*
color_threshold color_threshold_inst
(
	.sys_clk             (sys_clk                ) ,   // 时钟信号
    .sys_rst_n           (sys_rst_n              ) ,   // 复位信号（低有效）
	.flag_change_color   (flag_change_color      ) ,
	.flag_switch		   (flag_switch		      ) ,
	.add_press			   (cnt_flag[2]			      ) ,
	.minus_press		   (cnt_flag[3]		      ) ,
                              
	.black1_Y_max		   (color_limit[0] )	,
	.yellow1_Cb_max	   	   (color_limit[1] )	,
	.yellow1_Y_min		   (color_limit[2] ) 	,
	.blue1_Cb_min		   (color_limit[3] )	,
	.blue1_Y_min		   (color_limit[4] )	,	
	.red1_Cr_min		   (color_limit[5] )	,
	.red1_Cb_min		   (color_limit[6] )	,
	.red1_Y_min			   (color_limit[7] )  	,
	                        
	.black2_Y_max		   (color_limit[8] )	,
	.yellow2_Cb_max	   	   (color_limit[9] )	,
	.yellow2_Y_min		   (color_limit[10])  	,
	.blue2_Cb_min		   (color_limit[11])	,
	.blue2_Y_min		   (color_limit[12])	,	
	.red2_Cr_min		   (color_limit[13])	,
	.red2_Cb_min		   (color_limit[14])	,
	.red2_Y_min			   (color_limit[15])	
	
);		  
	*/	  
		  
		  /*
//坐标转换模块
trans_xyz trans_xyz_inst1
(
	.in(target[0][19:0]),
	
	.out(begin_point_mid)
);
trans_xyz trans_xyz_inst2
(
	.in(rotate[19:0]),
	
	.out(rotate_point_mid)
);     
   */     
//实例化延迟模块
delay delay_inst
(
    .sys_clk     (sys_clk   ),   //时钟信号
    .sys_rst_n   (sys_rst_n ),   //复位信号
    .flag_in     (po_flag   ),   //输入标志信号

    .flag_out    (delay_flag)    //输出信号 
);

//实例化指令模块        
instruct instruct_inst
(
    .sys_clk     (sys_clk  	),   //时钟信号
    .sys_rst_n   (sys_rst_n	),   //复位信号
    .pi_flag     (pi_flag  	),   //输入标志信号
    .DIGIT_CNT   ('d97   	),   //位数
    .DATA        ({12'haaa,
					target_x,	//11位
					target_y,	//11位
					Y_max,		//8位
					Y_min,		//8位
					Cb_max,     //8位
					Cb_min,     //8位
					Cr_max,     //8位
					Cr_min,     //8位
					16'hbbbb}),   //指令信号			{8'hAB,space,8'hBA}
    .en          (en       	),   //指令信号
    
    .tx          (tx       	),   //输出信号
    .tx_flag     (po_flag  	)    //输出标志信号
);
/*
//实例化移动模块
move move_inst
(
    .sys_clk     (sys_clk    ),   //时钟信号
    .sys_rst_n   (sys_rst_n  ),   //复位信号
    .mi_flag     (mi_flag	 ),   //输入标志信号
    .begin_point (begin_point),   //起点
    .end_point   (end_point  ),   //终点
    .rotate_point(rotate_point),   //旋转点
      
    .data_move   ({data0,data1,data2,data3,data4,data5}),   //输出信号
    .time_module (time_module),   //输出信号
    .mo_flag     (mo_flag    )    //输出标志信号 
);  
//实例化数据转指令模块
data_instruct data_instruct_inst
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .bcd0        (bcd0     ),   //bcd信号
    .bcd1        (bcd1     ),   //bcd信号
    .bcd2        (bcd2     ),   //bcd信号
    .bcd3        (bcd3     ),   //bcd信号
    .bcd4        (bcd4     ),   //bcd信号
    .bcd5        (bcd5     ),   //bcd信号
    .time_module (time_module),
    
    .instruct    (instruct )    //指令信号
);*/
//实例化按键消抖模块
key_fliter key_fliter_inst1
(
    .sys_clk     (sys_clk    ),   //时钟信号
    .sys_rst_n   (sys_rst_n  ),   //复位信号
    .key_in      (key_in[0]  ),   //输入信号
    
    .key_flag    (cnt_flag[0])  //输出信号

);/*
key_fliter key_fliter_inst2
(
    .sys_clk     (sys_clk    ),   //时钟信号
    .sys_rst_n   (sys_rst_n  ),   //复位信号
    .key_in      (key_in[1]  ),   //输入信号
    
    .key_flag    (cnt_flag[1])    //输出信号


);
key_fliter key_fliter_inst3
(
    .sys_clk     (sys_clk    ),   //时钟信号
    .sys_rst_n   (sys_rst_n  ),   //复位信号
    .key_in      (key_in[2]  ),   //输入信号
    
    .key_flag    (cnt_flag[2])    //输出信号


);
key_fliter key_fliter_inst4
(
    .sys_clk     (sys_clk    ),   //时钟信号
    .sys_rst_n   (sys_rst_n  ),   //复位信号
    .key_in      (key_in[3]  ),   //输入信号
    
    .key_flag    (cnt_flag[3])    //输出信号


);

//实例化十进制转8421模块
bcd_8421 bcd_8421_inst1 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (flag_change_color),   //数据信号

    .bcd         (bcd0     )    //输出信号         
);
bcd_8421 bcd_8421_inst2 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (data_color_1),   //数据信号

    .bcd         (bcd1     )    //输出信号         
);
bcd_8421 bcd_8421_inst3 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (data_color_2),   //数据信号

    .bcd         (bcd2     )    //输出信号         
);
bcd_8421 bcd_8421_inst4 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (data_color_3),   //数据信号

    .bcd         (bcd3     )    //输出信号         
);
bcd_8421 bcd_8421_inst5 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (color_flag),   //数据信号

    .bcd         (bcd4     )    //输出信号         
);
bcd_8421 bcd_8421_inst6 
(
    .sys_clk     (sys_clk  ),   //时钟信号
    .sys_rst_n   (sys_rst_n),   //复位信号
    .data        (space),   //数据信号

    .bcd         (bcd5     )    //输出信号         
);
*/

Color_shape_Target Color_shape_Target_inst
(    
    .sys_clk    		(sys_clk    ),  //系统时钟
    .sys_rst_n  		(sys_rst_n  ),  //系统复位，低电平有效
	 
	.area			    (area),
	
	 .flag_key_1		(flag_key_1 ),
	 .flag_key_2		(flag_key_2 ),
	 .key_mod			(key_switch   ),
	 .key_press			(cnt_flag[3]),
	 
	.black1_Y_max		   (color_limit[0]       )	,
	.yellow1_Cb_max	   	   (color_limit[1]   )	,
	.yellow1_Y_min		   (color_limit[2]       )  ,
	.blue1_Cb_min		   (color_limit[3]       )	,
	.blue1_Y_min		   (color_limit[4]   )	,	
	.red1_Cr_min		   (color_limit[5]   )	,
	.red1_Cb_min		   (color_limit[6]   )	,
	.red1_Y_min			   (color_limit[7]       )  ,
	.bright					( bright),
               
	.black2_Y_max		   (color_limit[8]       )	,
	.yellow2_Cb_max	   	   (color_limit[9]   )	,
	.yellow2_Y_min		   (color_limit[10]      )  ,
	.blue2_Cb_min		   (color_limit[11]      )	,
	.blue2_Y_min		   (color_limit[12]  )	,	
	.red2_Cr_min		   (color_limit[13]  )	,
	.red2_Cb_min		   (color_limit[14]  )	,
	.red2_Y_min			   (color_limit[15]      )	,
	.flag_change_color     (flag_change_color),
	 
	 
    .cam_pclk   		(cam_pclk   ),  //cmos 数据像素时钟
    .cam_vsync  		(cam_vsync  ),  //cmos 场同步信号
    .cam_href   		(cam_href   ),  //cmos 行同步信号
    .cam_data   		(cam_data   ),  //cmos 数据  
    .cam_rst_n  		(cam_rst_n  ),  //cmos 复位信号，低电平有效
    .cam_pwdn   		(cam_pwdn   ),  //cmos 电源休眠模式选择信号
    .cam_scl    		(cam_scl    ),  //cmos SCCB_SCL线
    .cam_sda    		(cam_sda    ),  //cmos SCCB_SDA线

    .sdram_clk  		(sdram_clk  ),  //SDRAM 时钟
    .sdram_cke  		(sdram_cke  ),  //SDRAM 时钟有效
    .sdram_cs_n 		(sdram_cs_n ),  //SDRAM 片选
    .sdram_ras_n		(sdram_ras_n),  //SDRAM 行有效
    .sdram_cas_n		(sdram_cas_n),  //SDRAM 列有效
    .sdram_we_n 		(sdram_we_n ),  //SDRAM 写有效
    .sdram_ba   		(sdram_ba   ),  //SDRAM Bank地址
    .sdram_dqm  		(sdram_dqm  ),  //SDRAM 数据掩码
    .sdram_addr 		(sdram_addr ),  //SDRAM 地址
    .sdram_data 		(sdram_data ),  //SDRAM 数据    

    .vga_hs     		(vga_hs     ),  //行同步信号
    .vga_vs     		(vga_vs     ),  //场同步信号
    .vga_rgb    		(vga_rgb    ), //红绿蓝三原色输出
	 .color_flag      	(color_flag ),
	 .target			(target		),
	 .rotate			(rotate		),
	 .space				(space		)
    );

endmodule