module RGB2YCBCR
(
    //图像处理前的数据接口
    input               pre_frame_vsync ,   // vsync信号
    input               pre_frame_hsync ,   // hsync信号
    input               pre_frame_de    ,   // data enable信号
    input       [7:0]  	rgb888_r		,   // 输入图像数据R
    input       [7:0]  	rgb888_g		,   // 输入图像数据G
    input       [7:0]  	rgb888_b		,   // 输入图像数据B

    //图像处理后的数据接口
    output              frame_vsync,   // vsync信号
    output              frame_hsync,   // hsync信号
    output              post_frame_de, // data enable信号
    output      [7:0]   img_y,         // 输出图像Y数据
    output      [7:0]   img_cb,
    output      [7:0]   img_cr
);

//reg define
reg  [15:0]   rgb_r_m0, rgb_r_m1, rgb_r_m2;
reg  [15:0]   rgb_g_m0, rgb_g_m1, rgb_g_m2;
reg  [15:0]   rgb_b_m0, rgb_b_m1, rgb_b_m2;
reg  [15:0]   img_y0 ;
reg  [15:0]   img_cb0;
reg  [15:0]   img_cr0;
reg  [ 7:0]   img_y1 ;
reg  [ 7:0]   img_cb1;
reg  [ 7:0]   img_cr1;

//*****************************************************
//**                    main code
//*****************************************************

//同步输出数据接口信号
assign frame_vsync   = pre_frame_vsync ;
assign frame_hsync   = pre_frame_hsync ;
assign post_frame_de = pre_frame_de    ;
assign img_y         = frame_hsync ? img_y1 : 8'd0;
assign img_cb        = frame_hsync ? img_cb1: 8'd0;
assign img_cr        = frame_hsync ? img_cr1: 8'd0;

//--------------------------------------------
//RGB 888 to YCbCr

/********************************************************
            RGB888 to YCbCr
 Y  = 0.299R +0.587G + 0.114B
 Cb = 0.568(B-Y) + 128 = -0.172R-0.339G + 0.511B + 128
 CR = 0.713(R-Y) + 128 = 0.511R-0.428G -0.083B + 128

 Y  = (77 *R    +    150*G    +    29 *B)>>8
 Cb = (-43*R    -    85 *G    +    128*B)>>8 + 128
 Cr = (128*R    -    107*G    -    21 *B)>>8 + 128

 Y  = (77 *R    +    150*G    +    29 *B        )>>8
 Cb = (-43*R    -    85 *G    +    128*B + 32768)>>8
 Cr = (128*R    -    107*G    -    21 *B + 32768)>>8
*********************************************************/

//step1 计算括号内的各乘法项
always @(*) begin
        rgb_r_m0 = rgb888_r * 8'd77 ;
        rgb_r_m1 = rgb888_r * 8'd43 ;
        rgb_r_m2 = rgb888_r * 8'd128;
        rgb_g_m0 = rgb888_g * 8'd150;
        rgb_g_m1 = rgb888_g * 8'd85 ;
        rgb_g_m2 = rgb888_g * 8'd107;
        rgb_b_m0 = rgb888_b * 8'd29 ;
        rgb_b_m1 = rgb888_b * 8'd128;
        rgb_b_m2 = rgb888_b * 8'd21 ;
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

endmodule
