module Target_Blue
#(
	parameter	[11:0]	red_max		=	12'd20		,
	parameter	[11:0]	red_min		=	12'd0		,
	parameter	[11:0]	deh			=	12'd5		,	//列容错
	parameter	[11:0]	NCNT 		=	12'd30		,	//行容错
	parameter	[11:0]	ACNT 		=	12'd20		,
	parameter	[11:0]	MIN			=	12'd0		,
	parameter	[11:0]	IMG_HDISP   =   12'd1280    ,	//行1280
	parameter	[11:0]	IMG_VDISP   =   12'd720         //列720
)
(
	
	input					clk,  							//cmos时钟
	input					rst_n,							//复位
			
	input					per_frame_vsync,				//传入图像数据列有效信号  
	input					per_frame_href,				//传入图像数据行有效信号  
	input					per_frame_clken,				//传入图像数据输入使能效信号
	input		  [23:0]    per_img_Bit,					//传入图像像素色彩数据    
	input	[23:0]	in_red      ,
    input   [7:0]   Blue_max ,
    input   [7:0]   Blue_min ,
    input   [7:0]   Red_max ,
    input   [7:0]   Red_min , 
    input               en_red,
    
    output  reg         en              ,
	output	jg_bit			,
	output	reg	[23:0]	out_red			,
	output	reg	[11:0]	out_top			,
	output	reg	[11:0]	out_down		,
	output	reg	[11:0]	out_left		,
	output	reg	[11:0]	out_right		
	

);


wire vsync_pos_flag;					  //帧开始标志
wire vsync_neg_flag;					  //帧结束标志


reg				per_frame_vsync_r;   //传入图像数据列有效信号  
reg				per_frame_href_r;	   //传入图像数据行有效信号  
reg				per_frame_clken_r;   //传入图像数据输入使能效信号
reg  		   	per_img_Bit_r;       //传入图像像素色彩数据     
reg 	[11:0]  x_cnt;					//行计数标志
reg 	[11:0]  y_cnt;   				//列计数标志
reg 	[11:0]  x_point;					//行计数延迟一拍
reg 	[11:0]  y_point;             //列计数延迟一拍
reg             en_p;

//通过打一拍的操作来获得一帧结束的有效标志

assign vsync_pos_flag = per_frame_vsync    & (~per_frame_vsync_r);
assign vsync_neg_flag = (~per_frame_vsync) & per_frame_vsync_r;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			per_frame_vsync_r 	<= 0;
			per_frame_href_r 	<= 0;
			per_frame_clken_r 	<= 0;
			per_img_Bit_r		<= 0;
		end
	else
		begin
			per_frame_vsync_r 	<= 	per_frame_vsync	;
			per_frame_href_r	<= 	per_frame_href		;
			per_frame_clken_r 	<= 	per_frame_clken	;
			per_img_Bit_r	    <= 	per_img_Bit			;
		end
end


//在行列方向分别计数
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

//计数延时一拍
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				x_point <= 12'd0;
				y_point <= 12'd0;
			end
		else 
			begin
				x_point <= x_cnt;
				y_point <= y_cnt;
			end
	end



parameter	H = IMG_HDISP -1;
parameter	V = IMG_VDISP -1;
//阈值判断
//integer j;
wire jg_flag    ;
wire jg_blue_flag    ;
wire jg_red_flag    ;
wire jg_x_flag    ;
wire jg_y_flag    ;

assign jg_blue_flag  = 	(Blue_min <= per_img_Bit[7:0] && Blue_max >= per_img_Bit[7:0] );
assign jg_red_flag  = 	(Red_min <= per_img_Bit[7:0] && Red_max >= per_img_Bit[7:0] );
assign jg_x_flag  = 	(x_cnt >= in_red[23:12] - 12'd20 	&& x_cnt <= in_red[23:12] + 12'd20); 
assign jg_y_flag  = 	(y_cnt >= in_red[11: 0] - 12'd15 	&& y_cnt <= in_red[11: 0] + 12'd15); 
assign jg_flag  = 	(jg_blue_flag | (jg_red_flag&&en_red)  ) & jg_y_flag & jg_x_flag; 
assign jg_bit  = 	jg_flag; 

reg	[1:0]	jg_S		;
reg	[9:0]	as_flag		;
reg	[5:0]	black_cnt   ;
reg	[11:0]	ncnt    	;
parameter	S0 = 2'b00	;
parameter	S2 = 2'b10	;
parameter	S1 = 2'b01	;
always@(posedge clk or negedge rst_n) 
	if(!rst_n) 
		ncnt <= 1'b0;
	else	if(x_cnt == IMG_HDISP - 1)
		ncnt <= 1'b0;
	else	if(jg_flag)
		ncnt <= 1'b0;
	else	if(!jg_flag&&ncnt<NCNT)
		ncnt <= ncnt + 1'b1;
//状态判断
always@(posedge clk or negedge rst_n) begin
//S1
	if(!rst_n) 
		jg_S <= S1;
	else    if(vsync_pos_flag)
		jg_S <= S1;
	else	if(x_cnt>=IMG_HDISP - 2)
		jg_S <= S1;
//S2
	else	if(jg_S==S1 && jg_flag)	
		jg_S <= S2;
	else	if(ncnt==NCNT&&jg_S==S2)	
		jg_S <= S1;
end
//边界判断
reg [11:0] 	lt_bound,rt_bound;
reg			rl_flag	;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		begin
			lt_bound <= 12'b0;
			rt_bound <= 12'b0;
			rl_flag	 <= 1'b0;
		end
	else if(vsync_pos_flag)
		begin
			lt_bound <= 12'b0;
			rt_bound <= 12'b0;
			rl_flag	 <= 1'b0;
		end
	else    if(x_cnt == IMG_HDISP - 1&&jg_S==S1)
		begin
			lt_bound <= 12'b0;
			rt_bound <= 12'b0;
			rl_flag	 <= 1'b0;
		end
	else	if(jg_flag&&jg_S==S1)//&&y_cnt>=12'd10&&y_cnt<=V-12'd10)
		begin
			lt_bound <= x_cnt	;
			rt_bound <= x_cnt	;
			rl_flag	 <= 1'b0;
		end
	else	if(ncnt==NCNT&&jg_S==S2)	
		begin
			lt_bound <= lt_bound	;
			rt_bound <= x_cnt - (NCNT);
			rl_flag	 <= 1'b1;
		end
	else	if(x_cnt == IMG_HDISP - 2&&jg_S==S2)	
		begin
			lt_bound <= lt_bound;
			rt_bound <= x_cnt;
			rl_flag	 <= 1'b1;
		end
	else
		begin
			lt_bound <= lt_bound	;
			rt_bound <= rt_bound;
			rl_flag	 <= 1'b0;
		end
	
end
//记录上一次边界
reg [11:0] 	last_lt_bound,last_rt_bound,last_y;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)  begin
		last_lt_bound <= MIN;
		last_rt_bound <= IMG_HDISP;
		as_flag	<= 1'b0;
		last_y	<= MIN;
	end
	else if(vsync_pos_flag) begin
		last_lt_bound <= MIN;
		last_rt_bound <= IMG_HDISP;
		as_flag	<= 1'b0;
		last_y 	<= MIN;
	end
	else	if(rl_flag&&(rt_bound-lt_bound>=red_min)&&(rt_bound-lt_bound<=red_max))//if(jg_S==S2 && jg_flag)	
		begin
			if(lt_bound<=last_rt_bound&&rt_bound>=last_lt_bound&&((last_y==MIN)||(y_cnt-last_y)<=deh))	 //&&(last_y[0]==MIN)||(y_cnt-last_y[0])<=12'd60)
			begin	
				last_lt_bound <= lt_bound;
				last_rt_bound <= rt_bound;
				as_flag	<= 1'b1;
				last_y  <= y_cnt;
			end
		end
	else
        begin
			as_flag	<= 1'b0;
			last_lt_bound <= last_lt_bound;
			last_rt_bound <= last_rt_bound;
			last_y <= last_y;
		end
end
//记录上下边界
//integer i;
reg [11:0] 	top,down,right,left;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		top  	 	<= MIN;
		down 	    <= IMG_VDISP;
		left 		<= IMG_HDISP;
		right	    <= MIN;
	end
	else 	if(vsync_pos_flag)begin
		top  	 	<= MIN;
		down 	    <= IMG_VDISP;
		left 	    <= IMG_HDISP;
		right	    <= MIN;
	end
	else	if(as_flag != 1'b0)	
        begin
			if(as_flag)	
            begin
				if(top == MIN)	top <= y_cnt ;
				  else    top <= top;
				  down <= last_y;
				if(left 	>=	last_lt_bound)	left  <= last_lt_bound ;
				if(right	<=	last_rt_bound)	right <= last_rt_bound ;
			end
		end
    else    begin
        top   <= top  ;
        down  <= down ;
        left  <= left ;
        right <= right;
    end
end

//给输出目标坐标赋值
//integer k;
reg	[11:0]	mid_y,mid_x;
wire  [23:0]    target_out;
//{12'd900,12'd500}
assign	target_out	=	{mid_x,mid_y};
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		mid_x <= 12'd0;
		mid_y <= 12'd0;
		out_top		<=	12'd0;
		out_down	<=	12'd0;
		out_left	<=	12'd0;
		out_right	<=	12'd0;
        en          <=  1'b0;
        en_p        <=  1'b1;
        out_red     <=  24'd0;
	end
	else if(vsync_pos_flag) begin     
        en <= en_p;
		if(top == MIN)	begin                     
			mid_x <= 12'd0;
			mid_y <= 12'd0;
			out_top		<=	12'd0;
			out_down	<=	12'd0;
			out_left	<=	12'd0;
			out_right	<=	12'd0;
            out_red     <=  12'd0;
            en_p <= 1'b0;
		end
		else	begin
			mid_x <= left[11:1]+right[11:1];
			mid_y <= top [11:1]+down [11:1];
			out_top		<=	top [11:1]+down [11:1] - 12'd10	;
			out_down	<=	top [11:1]+down [11:1] + 12'd10	;
			out_left	<=	left[11:1]+right[11:1] - 12'd10	;
			out_right	<=	left[11:1]+right[11:1] + 12'd10	;
            out_red     <=  in_red;
            en_p <= 1'b1;
		end
	end
	else	begin
		mid_x <= mid_x;
		mid_y <= mid_y;
        en    <= en   ;  
        en_p  <= en_p ;
		out_top		<=	out_top		;
		out_down	<=	out_down	;
		out_left	<=	out_left	;
		out_right	<=	out_right	;
        out_red     <=  out_red;
	end
end


endmodule 