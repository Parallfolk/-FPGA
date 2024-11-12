`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    11:23:23 02/27/2022 
// Module Name:    rgb2dvi 
//////////////////////////////////////////////////////////////////////////////////

module rgb2dvi #(
	parameter 	ENABLE_OSERDES 	= 1		
)(
	//	Pixel Clock (1X). 
	input 			PixelClk,
	input 			aRst,
	input 			aRst_n, 
	
	input 	[3:0] 	bitflip_i,		//	LVDS Lane Flip. [3]TXC, [2:0]TXD
	input 			oe_i, 		//	Output Enable. 
	
	//	Video Timing Generator (With Data Valid Control)
	input 			vid_pVSync,		//	VSync. High Valid. 
	input 			vid_pHSync,		//	HSync. High Valid. 
	input 			vid_pVDE, 		//	DataValid (Timing). Must be WIDTH + 2. (de & ~dvalid) will send VLG. 
	input 	[23:0] 	vid_pData,		//	RGB Data. [7:0]B(0), [15:8]G(1), [23:16]R(2). 
	
	//	HDMI Serializer (5X). 
	input 	 		SerialClk, 
	output 			TMDS_Clk_p,
	output 			TMDS_Clk_n,
	output 	[2:0] 	TMDS_Data_p,
	output 	[2:0] 	TMDS_Data_n,
	    //二值化上下界
    input   [7:0]   Y_max  ,
    input   [7:0]   Y_min  ,
    input   [7:0]   Cb_max ,
    input   [7:0]   Cb_min ,
    input   [7:0]   Cr_max ,
    input   [7:0]   Cr_min ,
    input   [7:0]   Yellow_min ,
    input   [7:0]   Yellow_max ,
    input   [7:0]   Mode   ,
    
    input       [11:0]  black_cnt_max,
	input	    [11:0]	deh			 ,	//列容错
	input	    [11:0]	NCNT 		 ,	//行容错
    input	    [11:0]	red_max		 ,
	input	    [11:0]	red_min		 ,
    
    output  [11:0]  target_x ,
    output  [11:0]  target_y ,
    
	output 	[9:0] 	txc_o, 
	output 	[9:0] 	txd0_o, 
	output 	[9:0] 	txd1_o, 
	output 	[9:0] 	txd2_o
);
	
	wire 			w_rst = aRst || (~aRst_n); 
	
	wire 	[3:0] 	w_ctl = 4'b0000; 
	
	//////////////////////////////////////////////////////////////////////////////////
	//	TMDS Encoder
	//////////////////////////////////////////////////////////////////////////////////
	
	wire 	[9:0] 	w_tmds_0_enc, w_tmds_1_enc, w_tmds_2_enc; 
	
    wire    [23:0] Data;
    wire    [23:0] Data_out;
    wire    [7:0]  Data_mid;
    wire    [9:0]        jg_bit;
    wire    [9:0]        jg_bit_mid;
    
    wire    [9:0]  target_en;
    
    wire  [23:0]    target_out[9:0];
    wire    [23:0]  red_out [9:0]   ;
    wire    [23:0]  eye_out [9:0]   ;
    
   // wire    [7:0] yellow_max ;
   // wire    [7:0] yellow_min ;
    
    
    assign  target_x = target_out[0][23:12];
    assign  target_y = target_out[0][11: 0];
    
   //parameter  yellow_max = 8'd180;
   //parameter  yellow_min = 8'd110;
    
    assign  Data =  (Mode == 0)    ? //原本是0   24'b1111_1111_1111_1111_0000_0000   24'b0111_1111_0000_0000_0000_0000
                        vid_pData   :
                            ((1)    ? //24'h00FFFF : 24'h0);
                               ((vid_pData[7:0] >= Y_min && vid_pData[7:0] <= Y_max) ? 
                                    24'b0111_1111_0000_0000_0000_0000 :
                                (vid_pData[7:0] >= Cb_min && vid_pData[7:0] <= Cb_max) ? 
                                    24'b0000_0000_1111_1111_0000_0000 :
                                (vid_pData[7:0] >= Cr_min && vid_pData[7:0] <= Cr_max) ? 
                                    24'b0000_0000_0000_0000_1111_1111 :
                                (vid_pData[7:0] >= Yellow_min && vid_pData[7:0] <= Yellow_max) ? 
                                    24'b1111_1111_1111_1111_0000_0000 :
                                    24'b0) : 24'b0);
    //assign  Data_mid =  ((vid_pData[7:0]>>>6)<<<6 );
    //assign  Data =  {Data_mid,Data_mid,Data_mid};
	tmds_channel enc_0 (
		.clk_pixel			(PixelClk),
		.video_data			(Data_out[ 7: 0]),
		.data_island_data		(0),
		.control_data		({post2_frame_vsync, post2_frame_href}),//({vid_pVSync, vid_pHSync})
		.mode				({3'b0, post2_frame_clken}),  //({3'b0, vid_pVDE})// Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_0_enc)
	);
	tmds_channel enc_1 (
		.clk_pixel			(PixelClk),
		.video_data			(Data_out[15: 8]),
		.data_island_data		(0),
		.control_data		(w_ctl[1:0]),
		.mode				({3'b0, post2_frame_clken}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_1_enc)
	);
	tmds_channel enc_2 (
		.clk_pixel			(PixelClk),
		.video_data			(Data_out[23:16]),
		.data_island_data		(0),
		.control_data		(w_ctl[3:2]),
		.mode				({3'b0, post2_frame_clken}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_2_enc)
	);
	
	wire 	[9:0] 	w_tmds_clk_enc = 10'b1111100000; 
	
	//////////////////////////////////////////////////////////////////////////////////
	//	Serializer
	//////////////////////////////////////////////////////////////////////////////////
	
	assign txc_o = bitflip_i[3] ? ~w_tmds_clk_enc : w_tmds_clk_enc;
	assign txd0_o = bitflip_i[0] ? ~w_tmds_0_enc : w_tmds_0_enc;
	assign txd1_o = bitflip_i[1] ? ~w_tmds_1_enc : w_tmds_1_enc;
	assign txd2_o = bitflip_i[2] ? ~w_tmds_2_enc : w_tmds_2_enc; 
   /* 
    reg  [15:0]   rgb_r_m0, rgb_r_m1, rgb_r_m2;
    reg  [15:0]   rgb_g_m0, rgb_g_m1, rgb_g_m2;
    reg  [15:0]   rgb_b_m0, rgb_b_m1, rgb_b_m2;
    reg  [15:0]   img_y0 ;
    reg  [15:0]   img_cb0;
    reg  [15:0]   img_cr0;
    reg  [ 7:0]   img_y1 ;
    reg  [ 7:0]   img_cb1;
    reg  [ 7:0]   img_cr1;
    
    //step1 计算括号内的各乘法项
    always @(*) begin
            rgb_r_m0 = vid_pData[23:16] * 8'd77 ;
            rgb_r_m1 = vid_pData[23:16] * 8'd43 ;
            rgb_r_m2 = vid_pData[23:16] * 8'd128;
            rgb_g_m0 = vid_pData[15: 8] * 8'd150;
            rgb_g_m1 = vid_pData[15: 8] * 8'd85 ;
            rgb_g_m2 = vid_pData[15: 8] * 8'd107;
            rgb_b_m0 = vid_pData[ 7: 0] * 8'd29 ;
            rgb_b_m1 = vid_pData[ 7: 0] * 8'd128;
            rgb_b_m2 = vid_pData[ 7: 0] * 8'd21 ;
    end

    //step2 括号内各项相加
    always @(*) begin
            img_y0  = rgb_r_m0 + rgb_g_m0 + rgb_b_m0;
            img_cb0 = rgb_b_m1 - rgb_r_m1 - rgb_g_m1 + 16'd32768;
            img_cr0 = rgb_r_m2 - rgb_g_m2 - rgb_b_m2 + 16'd32768;
    end

    //step3 括号内计算的数据右移8位
    always @(*) begin
            img_y1  = img_y0 [15:8];
            img_cb1 = img_cb0[15:8];
            img_cr1 = img_cr0[15:8];
    end
	*/
    wire    [47:0]  target_xy [9:0];
    wire    [47:0]  target_xy_mid [9:0];
    
wire        post2_frame_vsync ;
wire        post2_frame_href	; 
wire        post2_frame_clken ;    
wire    [23:0]  tout    [9:0]   ;   

assign tout = (Mode==1) ? target_out	: red_out ;
    
Rectangular 
/*#(
	 //大方框边界位置
	.up_pos                 (40     ),    
	.down_pos               (680      ),	
	.left_pos               (40 	   ),	
	.right_pos              (1240      )
)*/
Rectangular_inst
(

	.clk					 (PixelClk),  				//cmos时钟 
	.rst_n					 (aRst_n),	
	 
	.per_frame_vsync		(vid_pVSync         ),	 
	.per_frame_href		    (vid_pHSync         ),	 
    .per_frame_clken 	    (vid_pVDE	        ),	 	
	.in_img    			    (	  Data          ),
    
	.target_xy	            (target_xy_mid	),  //target_xy
	.target_out		   		(tout),	//eye_out  red_out
    
   	.post_frame_vsync		(post2_frame_vsync	), 
	.post_frame_href		(post2_frame_href	), 
	.post_frame_clken	    (post2_frame_clken	), 
             

	.out_img_Y			      ( Data_out	)

);
Target_Detect 
#(
	 //大方框边界位置
	.MIN		           (0		),    
	.IMG_HDISP             (1280	),	
	.IMG_VDISP             (720 	)	

	
	)
	Target_Detect_inst
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),		

    .black_cnt_max      (3  ),
	.deh			    (5			),	//列容错
	.NCNT 		        (5 		    ),	//行容错
    .red_max		    (15		),
	.red_min		    (0		),      

    
   // .en                 (target_en  ),
    .Y_max              (Y_max      ),
    .Y_min              (Y_min      ),
    .yellow_max         (Yellow_max ),
    .yellow_min         (Yellow_min ),
    .Cb_max             (Cb_max     ),
    .Cb_min             (Cb_min     ),
    .Cr_max             (Cr_max     ),
    .Cr_min             (Cr_min     ),
    
    
	
	.target_out	        (target_out	)
   // .target_xy          (target_xy  )
	
	);
    wire    [9:0]   en_red;
Target_jg Target_Jg_inst0
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[0]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
	.jg_bit		    (jg_bit_mid[0]), 
    .en             (en_red[0]),
	.out_left		(target_xy_mid[0][23:12]),
	.out_right		(target_xy_mid[0][11: 0]),
	.out_top		(target_xy_mid[0][47:36]),
	.out_down		(target_xy_mid[0][35:24]),
    .out_red        (red_out[0])

);
Target_jg Target_Jg_inst1
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[1]), 
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    
	.jg_bit		    (jg_bit_mid[1]), 
    .en             (en_red[1]),
	.out_left		(target_xy_mid[1][23:12]),
	.out_right		(target_xy_mid[1][11: 0]),
	.out_top		(target_xy_mid[1][47:36]),
	.out_down		(target_xy_mid[1][35:24]),
    .out_red        (red_out[1])

);
Target_jg Target_Jg_inst2
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[2]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    
	.jg_bit		    (jg_bit_mid[2]), 
    .en             (en_red[2]),
	.out_left		(target_xy_mid[2][23:12]),
	.out_right		(target_xy_mid[2][11: 0]),
	.out_top		(target_xy_mid[2][47:36]),
	.out_down		(target_xy_mid[2][35:24]),
    .out_red        (red_out[2])

);
Target_jg Target_Jg_inst3
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[3]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    
	.jg_bit		    (jg_bit_mid[3]), 
    .en             (en_red[3]),
	.out_left		(target_xy_mid[3][23:12]),
	.out_right		(target_xy_mid[3][11: 0]),
	.out_top		(target_xy_mid[3][47:36]),
	.out_down		(target_xy_mid[3][35:24]),
    .out_red        (red_out[3])

);
Target_jg Target_Jg_inst4
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[4]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    
	.jg_bit		    (jg_bit_mid[4]), 
    .en             (en_red[4]),
	.out_left		(target_xy_mid[4][23:12]),
	.out_right		(target_xy_mid[4][11: 0]),
	.out_top		(target_xy_mid[4][47:36]),
	.out_down		(target_xy_mid[4][35:24]),
    .out_red        (red_out[4])	 

);
Target_jg Target_Jg_inst5
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[5]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    
	.jg_bit		    (jg_bit_mid[5]), 
    .en             (en_red[5]),
	.out_left		(target_xy_mid[5][23:12]),
	.out_right		(target_xy_mid[5][11: 0]),
	.out_top		(target_xy_mid[5][47:36]),
	.out_down		(target_xy_mid[5][35:24]),
    .out_red        (red_out[5])	

);
Target_jg Target_Jg_inst6
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[6]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
    	
	.jg_bit		    (jg_bit_mid[6]), 
    .en             (en_red[6]),
    .out_left		(target_xy_mid[6][23:12]),
	.out_right		(target_xy_mid[6][11: 0]),
	.out_top		(target_xy_mid[6][47:36]),
	.out_down		(target_xy_mid[6][35:24]),
    .out_red        (red_out[6])	

);
Target_jg Target_Jg_inst7
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[7]),	
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
        	
	.jg_bit		    (jg_bit_mid[7]),
    .en             (en_red[7]), 
    .out_left		(target_xy_mid[7][23:12]),
	.out_right		(target_xy_mid[7][11: 0]),
	.out_top		(target_xy_mid[7][47:36]),
	.out_down		(target_xy_mid[7][35:24]),
    .out_red        (red_out[7])	

);
Target_jg Target_Jg_inst8
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[8]),
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
        	
	.jg_bit		    (jg_bit_mid[8]), 
    .en             (en_red[8]),
    .out_left		(target_xy_mid[8][23:12]),
	.out_right		(target_xy_mid[8][11: 0]),
	.out_top		(target_xy_mid[8][47:36]),
	.out_down		(target_xy_mid[8][35:24]),
    .out_red        (red_out[8])	

);
Target_jg Target_Jg_inst9
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Green_max          (Cb_max     ),       
    .Green_min          (Cb_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[9]),	
       	
  
    .blue_min           (black_cnt_max  ),
	.deh			    (deh			),	//列容错
	.NCNT 		        (NCNT 		    ),	//行容错
    .red_max		    (red_max		),
	.red_min		    (red_min		),  
  
	.jg_bit		    (jg_bit_mid[9]), 
    .en             (en_red[9]),
    .out_left		(target_xy_mid[9][23:12]),
	.out_right		(target_xy_mid[9][11: 0]),
	.out_top		(target_xy_mid[9][47:36]),
	.out_down		(target_xy_mid[9][35:24]),
    .out_red        (red_out[9])	

);
Target_Blue Target_Blue_inst0
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (target_out[0]),
    .en_red             (en_red[0]),
  
    .en             (target_en[0]),  
	.jg_bit		    (jg_bit[0]),
	.out_left		(target_xy[0][23:12]),
	.out_right		(target_xy[0][11: 0]),
	.out_top		(target_xy[0][47:36]),
	.out_down		(target_xy[0][35:24]),
    .out_red        (eye_out[0])	

);
Target_Blue Target_Blue_inst1
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[1]), 
    .en_red             (en_red[1]),
    
    .en             (target_en[1]),
	.jg_bit		    (jg_bit[1]),	 
	.out_left		(target_xy[1][23:12]),
	.out_right		(target_xy[1][11: 0]),
	.out_top		(target_xy[1][47:36]),
	.out_down		(target_xy[1][35:24]),
    .out_red        (eye_out[1])	

);
Target_Blue Target_Blue_inst2
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[2]),
    .en_red             (en_red[2]),
    
    .en             (target_en[2]),
	.jg_bit		    (jg_bit[2]),	 
	.out_left		(target_xy[2][23:12]),
	.out_right		(target_xy[2][11: 0]),
	.out_top		(target_xy[2][47:36]),
	.out_down		(target_xy[2][35:24]),
    .out_red        (eye_out[2])	

);
Target_Blue Target_Blue_inst3
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[3]),
    .en_red             (en_red[3]),
    
    .en             (target_en[3]),
	.jg_bit		    (jg_bit[3]),	 
	.out_left		(target_xy[3][23:12]),
	.out_right		(target_xy[3][11: 0]),
	.out_top		(target_xy[3][47:36]),
	.out_down		(target_xy[3][35:24]),
    .out_red        (eye_out[3])	

);
Target_Blue Target_Blue_inst4
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[4]),
    .en_red             (en_red[4]),
    
    .en             (target_en[4]),
	.jg_bit		    (jg_bit[4]),	 
	.out_left		(target_xy[4][23:12]),
	.out_right		(target_xy[4][11: 0]),
	.out_top		(target_xy[4][47:36]),
	.out_down		(target_xy[4][35:24]),
    .out_red        (eye_out[4])	

);
Target_Blue Target_Blue_inst5
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[5]),
    .en_red             (en_red[5]),
    
    .en             (target_en[5]),
	.jg_bit		    (jg_bit[5]),	 
	.out_left		(target_xy[5][23:12]),
	.out_right		(target_xy[5][11: 0]),
	.out_top		(target_xy[5][47:36]),
	.out_down		(target_xy[5][35:24]),
    .out_red        (eye_out[5])	

);
Target_Blue Target_Blue_inst6
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[6]),
    .en_red             (en_red[6]),
    
    .en             (target_en[6]),
	.jg_bit		    (jg_bit[6]),	 
	.out_left		(target_xy[6][23:12]),
	.out_right		(target_xy[6][11: 0]),
	.out_top		(target_xy[6][47:36]),
	.out_down		(target_xy[6][35:24]),
    .out_red        (eye_out[6])	

);
Target_Blue Target_Blue_inst7
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[7]),
    .en_red             (en_red[7]),	
    
    .en             (target_en[7]),
	.jg_bit		    (jg_bit[7]), 
	.out_left		(target_xy[7][23:12]),
	.out_right		(target_xy[7][11: 0]),
	.out_top		(target_xy[7][47:36]),
	.out_down		(target_xy[7][35:24]),
    .out_red        (eye_out[7])	

);
Target_Blue Target_Blue_inst8
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[8]),
    .en_red             (en_red[8]),
    
    .en             (target_en[8]),
	.jg_bit		    (jg_bit[8]), 
	.out_left		(target_xy[8][23:12]),
	.out_right		(target_xy[8][11: 0]),
	.out_top		(target_xy[8][47:36]),
	.out_down		(target_xy[8][35:24]),
    .out_red        (eye_out[8])	

);
Target_Blue Target_Blue_inst9
(
	.clk				(PixelClk),  
	.rst_n	    		(aRst_n		),     
	.per_frame_vsync	(vid_pVSync ),		
	.per_frame_href		(vid_pHSync ),		    
	.per_frame_clken	(vid_pVDE	),		 
	.per_img_Bit		(vid_pData	),	
    .Blue_max           (Cr_max     ),
    .Blue_min           (Cr_min     ),
    .Red_max           (Y_max     ),
    .Red_min           (Y_min     ),
	.in_red	            (red_out[9]),	
    .en_red             (en_red[9]),
   
    .en             (target_en[9]), 
	.jg_bit		    (jg_bit[9]), 
	.out_left		(target_xy[9][23:12]),
	.out_right		(target_xy[9][11: 0]),
	.out_top		(target_xy[9][47:36]),
	.out_down		(target_xy[9][35:24]),
    .out_red        (eye_out[9])	

);
endmodule
