module Rectangular
/*#(


)*/
(
    // 全局时钟信号
    input clk,                // 时钟信号
    input rst_n,              // 复位信号

    // 准备处理的图像数据
    input per_frame_vsync,    // 每帧的垂直同步信号
    input per_frame_href,     // 每帧的水平参考信号
    input per_frame_clken,    // 每帧的时钟使能信号
    input per_img_Bit,        // 每帧图像的位数据
	 
    // 输入图像数据
    input [23:0] in_img,      // 输入图像数据



    // 目标
    input [23:0] target_out[9:0], // 目标坐标数组
    input [47:0]  target_xy [9:0],

    // 处理后的图像数据输出
    output reg 			post_frame_vsync,   // 处理后的垂直同步信号
    output reg 			post_frame_href,    // 处理后的水平参考信号
    output reg 			post_frame_clken,   // 处理后的时钟使能信号
    output reg [23:0] 	out_img_Y   // 输出的Y通道图像数据
	
);




//parameter 
parameter  IMG_HDISP = 12'd1280;                 
parameter  IMG_VDISP = 12'd720;                 

 //定义画框的颜色 
     
parameter  YELLOW = 24'hFFFFFF;     

//reg
reg 			draw_flag;
reg [11:0]  	x_cnt;
reg [11:0]   y_cnt;

reg			per_frame_vsync_r;
reg			per_frame_href_r ;	
reg			per_frame_clken_r;
reg	[23:0] in_img_Y_r	 ;	

//wire
//目标画框变量
//wire [5:0] target_flag;			    //图形有效标志
wire [11:0] target_left 		[9:0] ;		//图形左边界
wire [11:0] target_right 	    [9:0] ;		//图形右边界
wire [11:0] target_up  		    [9:0] ;		//图形上边界
wire [11:0] target_down  	    [9:0] ;		//图形下边界
//计数获得xy坐标

wire vsync_pos_flag;


always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				x_cnt <= 12'd0;
				y_cnt <= 12'd0;
			end
		else if(vsync_pos_flag)
			begin
				x_cnt <= 12'd0;
				y_cnt <= 12'd0;
			end
		else if(per_frame_clken) 
			begin
				if(x_cnt < IMG_HDISP - 1) 
					begin
						x_cnt <= x_cnt + 1'b1;
						y_cnt <= y_cnt;
					end
				else 
					begin
						x_cnt <= 12'd0;
						y_cnt <= y_cnt + 1'b1;
					end
			end
	end
	parameter	[11:0]			up_pos   	=	12'd40  	;   //10'd52     520 336
	parameter	[11:0]			down_pos 	=	12'd680  	; //10'd412  
	parameter	[11:0]			left_pos	=	12'd40 	    ; //10'd28	
	parameter	[11:0]			right_pos	=   12'd1240 	; 	 // 10'd586	    
    
    
//判断坐标是否落在矩形方框边界上
always @(posedge clk or negedge rst_n) 
	begin
		 if(!rst_n) 
				draw_flag <= 1'b0;
		 else 
			 begin
  			   if((x_cnt >  left_pos) && (x_cnt < right_pos) && ((y_cnt == up_pos) ||(y_cnt == down_pos)) )  //上下边界画框
					draw_flag <= 1'b0;
				else if((y_cnt > up_pos) && (y_cnt < down_pos) && ((x_cnt == left_pos) ||(x_cnt == right_pos)) )  //左右边界画框
					draw_flag <= 1'b0;
				else 
					draw_flag <= 1'b0;
			 end 
	end 

//画框边界与使能赋值

generate
genvar i;
    for(i=0;i<10;i=i+1) begin: limbo_sign1
	    //assign target_flag 	    = 1'b1;
                assign target_left [i]	= target_xy[i][23:12];//target_out[i][23:12] - 12'd60
                assign target_right[i] 	= target_xy[i][11: 0];//target_out[i][23:12] + 12'd60
                assign target_up   [i]  = target_xy[i][47:36];//target_out[i][11: 0] - 12'd30
                assign target_down [i] 	= target_xy[i][35:24];//target_out[i][11: 0] + 12'd30
 
    end
endgenerate

wire    [11:0]  red_left     [9:0]    ;
wire    [11:0]  red_right    [9:0]    ;
wire    [11:0]  red_up       [9:0]    ;
wire    [11:0]  red_down     [9:0]    ;
generate
genvar o;
    for(o=0;o<10;o=o+1) begin: limbo_sign2
	    //assign target_flag 	    = 1'b1;
                assign red_left [o]	    =target_out[o][23:12] - 12'd60;
                assign red_right[o] 	=target_out[o][23:12] + 12'd60;
                assign red_up   [o]     =target_out[o][11: 0] - 12'd30;
                assign red_down [o] 	=target_out[o][11: 0] + 12'd30;
 
    end
endgenerate

/*assign target_flag [2]	= target_out[2][40];
assign target_left [2]	= target_out[2][ 9: 0];
assign target_right[2] 	= target_out[2][29:20];
assign target_up	 [2]	= target_out[2][19:10];
assign target_down [2] 	= target_out[2][39:30];*/



integer j;
reg  [9:0]	target_draw_flag;//画框标志
reg 	 	target_draw_flag_final;//画框中间量标志
//目标画框
always @(posedge clk or negedge rst_n) 
	begin
		 if(!rst_n) 		 //初始化
			target_draw_flag <= 10'd0;
		 else   
					for(j=0;j<10;j=j+1)begin
							if((x_cnt >  target_left[j]) && (x_cnt < target_right[j]) && ((y_cnt == target_up[j]) ||(y_cnt == target_down[j] )))    //上下边界画框
								target_draw_flag[j] <= 1'b1;

							else if((y_cnt > target_up[j]) && (y_cnt < target_down[j] ) && ((x_cnt == target_left[j]) ||(x_cnt == target_right[j]))) //左右边界画框 
								target_draw_flag[j] <= 1'b1;

							else 
								 target_draw_flag[j] <= 1'b0;	
					end
			 
	end
integer k;
reg  [9:0]	red_draw_flag;//画框标志
reg 	 	red_draw_flag_final;//画框中间量标志
//目标画框
always @(posedge clk or negedge rst_n) 
	begin
		 if(!rst_n) 		 //初始化
			red_draw_flag <= 10'd0;
		 else   
                    for(k=0;k<10;k=k+1)begin
							if((x_cnt >  red_left[k]) && (x_cnt < red_right[k]) && ((y_cnt == red_up[k]) ||(y_cnt == red_down[k] )))    //上下边界画框
								red_draw_flag[k] <= 1'b1;

							else if((y_cnt > red_up[k]) && (y_cnt < red_down[k] ) && ((x_cnt == red_left[k]) ||(x_cnt == red_right[k]))) //左右边界画框 
								red_draw_flag[k] <= 1'b1;

							else 
								 red_draw_flag[k] <= 1'b0;	
					end
			 
	end
    
//视向绘制

wire [11:0]     blue_x      [9:0];
wire [11:0]     blue_y      [9:0];
wire [11:0]     red_x       [9:0];
wire [11:0]     red_y       [9:0];
wire    [3:0]    line_flag [9:0]    ;//判断是否在视向上

generate
genvar n;
    for(n=0;n<10;n=n+1) begin: xy_point
	    //assign target_flag 	    = 1'b1;
                assign blue_x [n]	= target_xy[n][23:13] + target_xy[n][11: 1];
                assign blue_y [n] 	= target_xy[n][47:37] + target_xy[n][35:25];
                assign red_x  [n]   = target_out[n][23:12];
                assign red_y  [n]   = target_out[n][11:0];
                //左上：(red_x - x_cnt)/(red_y - y_cnt) == (red_x - blue_x)/(red_y - blue_y)
                assign    line_flag[n][0] = (blue_x[n] <= red_x[n] && blue_y[n] <= red_y[n]) && (((red_x[n] - x_cnt)*(red_y[n] - blue_y[n]) - (red_x[n] - blue_x[n])*(red_y[n] - y_cnt) <=12'd5) || ((red_x[n] - blue_x[n])*(red_y[n] - y_cnt) - (red_x[n] - x_cnt)*(red_y[n] - blue_y[n])<=12'd5));
                //右上：(x_cnt - red_x[m])/(red_y[m] - y_cnt) == (blue_x[m] - red_x[m])/(red_y[m] - blue_y[m])    (x_cnt - red_x[n])*(red_y[n] - blue_y[n]) == (blue_x[n] - red_x[n])*(red_y[n] - y_cnt)
                assign    line_flag[n][1] = (blue_x[n] > red_x[n] && blue_y[n] <= red_y[n]) && ((x_cnt - red_x[n])*(red_y[n] - blue_y[n]) - (blue_x[n] - red_x[n])*(red_y[n] - y_cnt) < 12'd5 || (blue_x[n] - red_x[n])*(red_y[n] - y_cnt) - (x_cnt - red_x[n])*(red_y[n] - blue_y[n]) < 12'd5);
                //左下：(red_x - x_cnt)/(y_cnt - red_y) == (red_x - blue_x)/(blue_y - red_y)     (red_x[n] - x_cnt)*(blue_y[n] - red_y[n]) == (red_x[n] - blue_x[n])*(y_cnt - red_y[n])
                assign    line_flag[n][2] = (blue_x[n] <= red_x[n] && blue_y[n] > red_y[n]) && ((red_x[n] - x_cnt)*(blue_y[n] - red_y[n]) - (red_x[n] - blue_x[n])*(y_cnt - red_y[n]) < 12'd5 || (red_x[n] - blue_x[n])*(y_cnt - red_y[n]) - (red_x[n] - x_cnt)*(blue_y[n] - red_y[n]) < 12'd5);
                //右下：(x_cnt - red_x)/(red_y - y_cnt) == (blue_x - red_x)/(blue_y - red_y)     (x_cnt - red_x[n])*(blue_y[n] - red_y[n]) == (blue_x[n] - red_x[n])*(red_y[n] - y_cnt)
                assign    line_flag[n][3] = (blue_x[n] >  red_x[n] && blue_y[n] > red_y[n]) && ((x_cnt - red_x[n])*(blue_y[n] - red_y[n]) - (blue_x[n] - red_x[n])*(red_y[n] - y_cnt) < 12'd5 || (blue_x[n] - red_x[n])*(red_y[n] - y_cnt) - (x_cnt - red_x[n])*(blue_y[n] - red_y[n]) < 12'd5);

// && (x_cnt > red_left[m]) && (x_cnt < red_right[m]) && (y_cnt > red_up[m]) && (y_cnt < red_down[m])
    end
endgenerate

reg  [9:0]	line_draw_flag;//画框标志
reg 	 	line_draw_flag_final;//画框中间量标志







integer m;
always @(posedge clk or negedge rst_n) //
	begin
		 if(!rst_n) 		 //初始化
			line_draw_flag <= 10'd0;
		 else   
                    for(m=0;m<10;m=m+1)begin
							if((line_flag[m][0]) && (x_cnt > red_left[m]) && (x_cnt < red_x[m]) && (y_cnt > red_up[m]) && (y_cnt < red_y[m]) )    //左上
								line_draw_flag[m] <= 1'b1;
							else if((line_flag[m][1]) && (x_cnt > red_x[m]) && (x_cnt < red_right[m]) && (y_cnt > red_up[m]) && (y_cnt < red_y[m]))//右上
								line_draw_flag[m] <= 1'b1;
                            else if((line_flag[m][2]) && (x_cnt > red_left[m]) && (x_cnt < red_x[m]) && (y_cnt > red_y[m]) && (y_cnt < red_down[m])) //左下
                                line_draw_flag[m] <= 1'b1;
                            else if((line_flag[m][3]) && (x_cnt > red_x[m]) && (x_cnt < red_right[m]) && (y_cnt > red_y[m]) && (y_cnt < red_down[m])) //右下
                                line_draw_flag[m] <= 1'b1;
                            else
                                line_draw_flag[m] <= 1'b0;
					end
			 
	end

//最终画框信号赋值
assign red_draw_flag_final = (red_draw_flag )? 1'b1 : 1'b0;
assign target_draw_flag_final = (target_draw_flag )? 1'b1 : 1'b0;
assign line_draw_flag_final = (line_draw_flag)? 1'b1 : 1'b0;

assign vsync_pos_flag = per_frame_vsync  & (~per_frame_vsync_r);
always@(posedge clk or negedge rst_n)

	if(!rst_n)
		begin
			per_frame_vsync_r 	<= 0;
			per_frame_href_r 	<= 0;
			per_frame_clken_r 	<= 0;
			
			in_img_Y_r <= 0;
			
			post_frame_vsync 	<= 0;
			post_frame_href 	<= 0;
			post_frame_clken 	<= 0;			
		end
	else
		begin
			per_frame_vsync_r 	<= 	per_frame_vsync		;
			per_frame_href_r		<= 	per_frame_href		;
			per_frame_clken_r 	<= 	per_frame_clken		;
			
			in_img_Y_r <= in_img;
			
			post_frame_vsync 	<= 	per_frame_vsync_r 	;
			post_frame_href 	<= 	per_frame_href_r	;
			post_frame_clken 	<= 	per_frame_clken_r 	;	
//////////////////////////////////////////////////////////////////////////////////	
		    out_img_Y	 	<=  (draw_flag) ?( 24'hFFFFFF): (target_draw_flag_final ? 24'hFFFFFF : (red_draw_flag_final ? 24'hFF0000 :( (line_draw_flag_final)? 24'hFFFF00:in_img_Y_r )));//in_img_Y_r

		end


endmodule 