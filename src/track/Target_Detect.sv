//通过寻找很小的被蓝绿包围的红色来给出眼眶位置
//你们需要做的：增加眼白来减小红色块的丢失（见28,29,128,138行）
module Target_Detect
#(
	//parameter	[11:0]	red_max		    =	12'd50		,
	//parameter	[11:0]	red_min		    =	12'd5		,
	//parameter	[11:0]	deh			    =	12'd5		,	//列容错
	//parameter	[11:0]	NCNT 		    =	12'd5		,	//行容错
	parameter	[11:0]	MIN			    =	12'd0		,
	parameter	[11:0]	IMG_HDISP       =   12'd1280    ,	//行1280
	parameter	[11:0]	IMG_VDISP       =   12'd720        //列720
	//parameter	[7:0]	black_cnt_max   =   8'd10            //黑色计数最大值
)
(
	
	input		clk,  						//cmos时钟
	input		rst_n,						//复位
					
	input		per_frame_vsync,			//传入图像数据列有效信号  
	input		per_frame_href,				//传入图像数据行有效信号  
	input		per_frame_clken,			//传入图像数据输入使能效信号
	input		[23:0]  per_img_Bit,		//传入图像像素色彩数据     
    
    input       [11:0]  black_cnt_max,
	input	    [11:0]	deh			 ,	//列容错
	input	    [11:0]	NCNT 		 ,	//行容错
    input	    [11:0]	red_max		 ,
	input	    [11:0]	red_min		 ,
    
    input       [9:0]   en     ,
	input   	[7:0]   Y_max  ,
    input   	[7:0]   Y_min  ,
	input   	[7:0]   yellow_max  ,
    input   	[7:0]   yellow_min  ,
    input   	[7:0]   Cb_max ,
    input   	[7:0]   Cb_min ,
    input   	[7:0]   Cr_max ,
    input   	[7:0]   Cr_min, 
		
	output  	[23:0]  target_out[9:0],
    output  reg [47:0]  target_xy [9:0]
);

wire vsync_pos_flag;					  //帧开始标志
wire vsync_neg_flag;					  //帧结束标志


reg				per_frame_vsync_r;   //传入图像数据列有效信号  
reg				per_frame_href_r;	 //传入图像数据行有效信号  
reg				per_frame_clken_r;   //传入图像数据输入使能效信号
reg  		   	per_img_Bit_r;       //传入图像像素色彩数据     
reg 	[11:0]  x_cnt;					//行计数标志
reg 	[11:0]  y_cnt;   				//列计数标志
reg 	[11:0]  x_point;				//行计数延迟一拍
reg 	[11:0]  y_point;             	//列计数延迟一拍


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
integer j;
wire jg_green_flag   ;  //瞳孔外围
wire jg_blue_flag    ;  //瞳孔中心
wire jg_red_flag     ;  //光斑
wire jg_black_flag   ;  //其他
wire jg_yellow_flag  ;  //眼白
wire jg_flag         ;

assign jg_green_flag = (Cb_min <= per_img_Bit[7:0] && Cb_max >= per_img_Bit[7:0]);
assign jg_blue_flag  = (Cr_min <= per_img_Bit[7:0] && Cr_max >= per_img_Bit[7:0]); 
assign jg_red_flag   = (Y_min <= per_img_Bit[7:0] && Y_max >= per_img_Bit[7:0]); 
assign jg_yellow_flag   = (yellow_min <= per_img_Bit[7:0] && yellow_max >= per_img_Bit[7:0]); 
assign jg_black_flag = ~(jg_red_flag || jg_flag); 
assign jg_flag       = (jg_blue_flag || jg_green_flag || jg_yellow_flag);//把jg_yellow_flag并进来

reg	[1:0]	jg_S		;
reg	[9:0]	as_flag		;
reg	[5:0]	black_cnt   ;
reg	[11:0]	ncnt    	;
parameter	S0 = 2'b00	;
parameter	S1 = 2'b01	;
parameter	S2 = 2'b10	;
//无效延迟判断
always@(posedge clk or negedge rst_n) begin //判断光斑是否被眼白包围
	if(!rst_n) 
        black_cnt <= 1'b0;
    else    if(!jg_black_flag)
        black_cnt <= 1'b0;
    else    if(jg_black_flag&&black_cnt<black_cnt_max)
        black_cnt <= black_cnt + 1'b1;
end
always@(posedge clk or negedge rst_n) //判断是否完成单行有效扫描
	if(!rst_n) 
		ncnt <= 1'b0;
	else	if(x_cnt == IMG_HDISP - 1)
		ncnt <= 1'b0;
	else	if(jg_red_flag)
		ncnt <= 1'b0;
	else	if(!jg_red_flag&&ncnt<NCNT)
		ncnt <= ncnt + 1'b1;
//状态判断
always@(posedge clk or negedge rst_n) begin
//S0
	if(!rst_n) 
		jg_S <= S0;
	else    if(vsync_pos_flag)
		jg_S <= S0;
	else	if(x_cnt>=IMG_HDISP - 2)
		jg_S <= S0;
	else	if(black_cnt==black_cnt_max)	
		jg_S <= S0;
//S1
    else    if(jg_S==S0 && jg_flag)
		jg_S <= S1;
//S2
	else	if(jg_S==S1 && jg_red_flag)	
		jg_S <= S2;
	else	if(ncnt==NCNT&&jg_S==S2)	
		jg_S <= S0;
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
	else	if(jg_S==S0)
		begin
			lt_bound <= 12'b0;
			rt_bound <= 12'b0;
			rl_flag	 <= 1'b0;
		end
	else	if(jg_red_flag&&jg_S==S1&&y_cnt>=12'd10&&y_cnt<=V-12'd10)
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
			rt_bound <= x_cnt - ncnt;
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
reg [11:0] 	last_lt_bound[9:0],last_rt_bound[9:0],last_y[9:0];
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		for(j=0;j<9;j=j+1) begin
			last_lt_bound[j] <= MIN;
			last_rt_bound[j] <= IMG_HDISP;
			as_flag[j]	<= 1'b0;
			last_y[j]	<= MIN;
		end
	else if(vsync_pos_flag)
		for(j=0;j<9;j=j+1) begin
			last_lt_bound[j] <= MIN;
			last_rt_bound[j] <= IMG_HDISP;
			as_flag[j]	<= 1'b0;
			last_y[j]	<= MIN;
		end
	else	if(rl_flag&&(rt_bound-lt_bound>=red_min)&&(rt_bound-lt_bound<=red_max))//if(jg_S==S2 && jg_flag)	
		begin
			if(lt_bound<=last_rt_bound[0]&&rt_bound>=last_lt_bound[0]&&((last_y[0]==MIN)||(y_cnt-last_y[0])<=deh))	 //&&(last_y[0]==MIN)||(y_cnt-last_y[0])<=12'd60)
			begin	
				last_lt_bound[0] <= x_cnt;//lt_bound;
				last_rt_bound[0] <= rt_bound;
				as_flag[0]	<= 1'b1;
				last_y[0] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[1]&&rt_bound>=last_lt_bound[1]&&((last_y[1]==MIN)||(y_cnt-last_y[1])<=deh))	 //&&(last_y[1]==MIN)||(y_cnt-last_y[1])<=12'd61)
			begin	
				last_lt_bound[1] <= lt_bound;
				last_rt_bound[1] <= rt_bound;
				as_flag[1]	<= 1'b1;
				last_y[1] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[2]&&rt_bound>=last_lt_bound[2]&&((last_y[2]==MIN)||(y_cnt-last_y[2])<=deh))	 //&&(last_y[2]==MIN)||(y_cnt-last_y[2])<=12'd62)
			begin	
				last_lt_bound[2] <= lt_bound;
				last_rt_bound[2] <= rt_bound;
				as_flag[2]	<= 1'b1;
				last_y[2] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[3]&&rt_bound>=last_lt_bound[3]&&((last_y[3]==MIN)||(y_cnt-last_y[3])<=deh))	 //&&(last_y[3]==MIN)||(y_cnt-last_y[3])<=12'd63)
			begin	
				last_lt_bound[3] <= lt_bound;
				last_rt_bound[3] <= rt_bound;
				as_flag[3]	<= 1'b1;
				last_y[3] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[4]&&rt_bound>=last_lt_bound[4]&&((last_y[4]==MIN)||(y_cnt-last_y[4])<=deh))	 //&&(last_y[4]==MIN)||(y_cnt-last_y[4])<=12'd64)
			begin	
				last_lt_bound[4] <= lt_bound;
				last_rt_bound[4] <= rt_bound;
				as_flag[4]	<= 1'b1;
				last_y[4] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[5]&&rt_bound>=last_lt_bound[5]&&((last_y[5]==MIN)||(y_cnt-last_y[5])<=deh))	 //&&(last_y[5]==MIN)||(y_cnt-last_y[5])<=12'd65)
			begin	
				last_lt_bound[5] <= lt_bound;
				last_rt_bound[5] <= rt_bound;
				as_flag[5]	<= 1'b1;
				last_y[5] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[6]&&rt_bound>=last_lt_bound[6]&&((last_y[6]==MIN)||(y_cnt-last_y[6])<=deh))	 //&&(last_y[6]==MIN)||(y_cnt-last_y[6])<=12'd66)
			begin	
				last_lt_bound[6] <= lt_bound;
				last_rt_bound[6] <= rt_bound;
				as_flag[6]	<= 1'b1;
				last_y[6] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[7]&&rt_bound>=last_lt_bound[7]&&((last_y[7]==MIN)||(y_cnt-last_y[7])<=deh))	 //&&(last_y[7]==MIN)||(y_cnt-last_y[7])<=12'd67)
			begin	
				last_lt_bound[7] <= lt_bound;
				last_rt_bound[7] <= rt_bound;
				as_flag[7]	<= 1'b1;
				last_y[7] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[8]&&rt_bound>=last_lt_bound[8]&&((last_y[8]==MIN)||(y_cnt-last_y[8])<=deh))	 //&&(last_y[8]==MIN)||(y_cnt-last_y[8])<=12'd68)
			begin	
				last_lt_bound[8] <= lt_bound;
				last_rt_bound[8] <= rt_bound;
				as_flag[8]	<= 1'b1;
				last_y[8] <= y_cnt;
			end
			else	if(lt_bound<=last_rt_bound[9]&&rt_bound>=last_lt_bound[9]&&((last_y[9]==MIN)||(y_cnt-last_y[9])<=deh))	 //&&(last_y[9]==MIN)||(y_cnt-last_y[9])<=12'd69)
			begin	
				last_lt_bound[9] <= lt_bound;
				last_rt_bound[9] <= rt_bound;
				as_flag[9]	<= 1'b1;
				last_y[9] <= y_cnt;
			end
		end
	else
        begin
			as_flag	<= 10'b00_0000_0000;
			last_lt_bound <= last_lt_bound;
			last_rt_bound <= last_rt_bound;
			last_y <= last_y;
		end
end
//记录上下边界
integer i;
reg [11:0] 	top[9:0],down[9:0],right[9:0],left[9:0];
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		for(i=0;i<9;i=i+1) begin
			top  [i] 	<= MIN;
			down [i]    <= IMG_VDISP;
			left [i]	<= IMG_HDISP;
			right[i]    <= MIN;
		end
	else 	if(vsync_pos_flag)
		for(i=0;i<9;i=i+1) begin
			top  [i] 	<= MIN;
			down [i]    <= IMG_VDISP;
			left [i]    <= IMG_HDISP;
			right[i]    <= MIN;
		end
	else	if(as_flag != 10'b0)	
		for(i=0;i<9;i=i+1) 
        begin
			if(as_flag[i])	
            begin
                //top  [i] 	<= last_y[i];
                //down [i]    <= last_y[i];
                //left [i]    <= last_lt_bound[i];
                //right[i]    <= last_lt_bound[i];
				if(top[i] == MIN)	top[i] <= y_cnt ;
				  else    top[i] <= top[i];
				  down[i] <= last_y[i];
				if(left[i]	>=	last_lt_bound[i])	left[i]  <= last_lt_bound[i] ;
				if(right[i]	<=	last_rt_bound[i])	right[i] <= last_rt_bound[i] ;
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
integer k;
reg	[11:0]	mid_y[9:0],mid_x[9:0];
//{12'd900,12'd500}
assign	target_out[0]	=	{mid_x[0],mid_y[0]};
assign	target_out[1]	=	{mid_x[1],mid_y[1]};
assign	target_out[2]	=	{mid_x[2],mid_y[2]};
assign	target_out[3]	=	{mid_x[3],mid_y[3]};
assign	target_out[4]	=	{mid_x[4],mid_y[4]};
assign	target_out[5]	=	{mid_x[5],mid_y[5]};
assign	target_out[6]	=	{mid_x[6],mid_y[6]};
assign	target_out[7]	=	{mid_x[7],mid_y[7]};
assign	target_out[8]	=	{mid_x[8],mid_y[8]};
assign	target_out[9]	=	{mid_x[9],mid_y[9]};
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		for(k=0;k<9;k=k+1) begin
			mid_x[k] <= 12'd0;
			mid_y[k] <= 12'd0;
            target_xy[k] <= 48'd0;
		end
	else if(vsync_pos_flag)
		for(k=0;k<10;k=k+1) begin
			if(top[k] == MIN||(down[k]-top[k]>=red_max))	begin
            
                target_xy[k] <= 48'd0;
                mid_x[k] <= 12'd0;
                mid_y[k] <= 12'd0;
                //if(en[k] == 1'b1)
                //    begin
                //        mid_x[k] <= mid_x[k];//12'd0
                //        mid_y[k] <= mid_y[k];//12'd0
                //    end
                //else
                //        mid_x[k] <= mid_x[k];
                //        mid_y[k] <= mid_y[k];
			end
			else	begin
				mid_x[k] <= left[k][11:1]+right[k][11:1];
				mid_y[k] <= top[k][11:1]+down[k][11:1];
                target_xy[k] <= {top[k],down[k],left[k],right[k]};
			end
		end
	else	begin
		mid_x <= mid_x;
		mid_y <= mid_y;
	end
end


endmodule 