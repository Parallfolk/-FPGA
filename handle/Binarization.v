module Binarization
#(
	parameter	Color_idfine0  = 86		,
	parameter	Color_idfine1  = 80		,
	parameter	Color_idfine2  = 24		,
	parameter	Color_idfine3  = 152	,
	parameter	Color_idfine4  = 50		,
	parameter	Color_idfine5  = 144	,
	parameter	Color_idfine6  = 83		,
	parameter	Color_idfine7  = 32		,
	parameter	Color_idfine8  = 85		,
	parameter	Color_idfine9  = 85		,
	parameter	Color_idfine10 = 20		,
	parameter	Color_idfine11 = 150	,
	parameter	Color_idfine12 = 31		,
	parameter	Color_idfine13 = 140	,
	parameter	Color_idfine14 = 77		,
	parameter	Color_idfine15 = 45		, 
	parameter	up		=	44   	,
	parameter	down	=	380  	,
	parameter	left	=	47		,
	parameter	right	=  567 	   
)
(
    input               clk             ,   // 时钟信号
    input               rst_n           ,   // 复位信号（低有效）

	input				per_frame_vsync,
	input				per_frame_href ,	
	input				per_frame_clken,
	input		[7:0]	per_img_Y,		
	input		[7:0] 	per_img_Cb , 
	input		[7:0] 	per_img_Cr ,  	
	input     	[2:0]   flag,
	output	reg 		post_frame_vsync,	
	output	reg 		post_frame_href ,	
	output	reg 		post_frame_clken,	
	output	reg 		post_img_Bit    ,
    
    //二值化上下界
    input   [7:0]   Y_max  ,
    input   [7:0]   Y_min  ,
    input   [7:0]   Cb_max ,
    input   [7:0]   Cb_min ,
    input   [7:0]   Cr_max ,
    input   [7:0]   Cr_min 
);
parameter  IMG_HDISP = 11'd640;                 
parameter  IMG_VDISP = 11'd480;    


reg	[9:0] x_cnt;
reg	[9:0] y_cnt;

always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				x_cnt <= 10'd0;
				y_cnt <= 10'd0;
			end
		else   
			begin
				if(per_frame_vsync)
					begin
						x_cnt <= 10'd0;
						y_cnt <= 10'd0;
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
								x_cnt <= 10'd0;
								y_cnt <= y_cnt + 1'b1;
							end
					end
			end
	end



//延时一拍
always@(posedge clk or negedge rst_n) 
	begin
		 if(!rst_n) 
			 begin
				  post_frame_vsync <= 1'd0;
				  post_frame_href  <= 1'd0;
				  post_frame_clken <= 1'd0;
			 end
		 else 
			 begin
				  post_frame_vsync <= per_frame_vsync;
				  post_frame_href  <= per_frame_href ;
				  post_frame_clken <= per_frame_clken;
			 end
	end
	
wire    [2:0]   define;
wire	rec_flag;

assign define[0]   = (per_img_Y >= 8'd0 && per_img_Y <= 8'd60)  ;
assign define[1]   = 1'b1  ;
assign define[2]   = 1'b1  ;

//assign rec_flag = ((x_cnt > right - 10'd4 && x_cnt < right + 10'd3)||(x_cnt > left - 10'd4 && x_cnt < left + 10'd3)||((y_cnt < up +10'd3)&&(y_cnt > up -10'd2)))? (1'b1):(1'b0);

//二值化
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        post_img_Bit <= 1'b0;
	else if(define == 3'b111)
        post_img_Bit <= 1'b1;
    else
        post_img_Bit <= 1'b0;
		
end



endmodule
