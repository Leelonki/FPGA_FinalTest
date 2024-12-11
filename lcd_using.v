module lcd_using(
    input sys_clk,             // 系统时钟
    input sys_rst_n,           // 复位信号
    input [3:0] display_num,   // 需要显示的数字 (0-9)
    output lcd_hs,             // LCD 行同步信号
    output lcd_vs,             // LCD 场同步信号
    output lcd_de,             // LCD 数据使能
    output [23:0] lcd_rgb,     // LCD RGB888 数据
    output lcd_bl,             // LCD 背光控制信号
    output lcd_rst,            // LCD 复位信号
    output lcd_pclk            // LCD 采样时钟
);

    // 内部信号定义
    wire lcd_clk_w;            // LCD 驱动时钟
    wire locked_w;             // PLL 锁定信号
    wire rst_n_w;              // 内部复位信号
    wire [23:0] pixel_data_w;  // 像素点数据
    wire [10:0] pixel_xpos_w;  // 像素点横坐标
    wire [10:0] pixel_ypos_w;  // 像素点纵坐标

    // 待 PLL 输出稳定之后，停止复位
    assign rst_n_w = sys_rst_n & locked_w;

    // PLL 时钟分频模块实例化
    lcd_pll u_lcd_pll (
        .inclk0(sys_clk),      // 输入时钟
        .areset(~sys_rst_n),   // 复位信号
        .c0(lcd_clk_w),        // 输出 LCD 驱动时钟
        .locked(locked_w)      // PLL 锁定信号
    );

    // LCD 驱动模块实例化
    lcd_driver u_lcd_driver (
        .lcd_clk(lcd_clk_w),       // LCD 驱动时钟
        .sys_rst_n(rst_n_w),       // 内部复位信号
        .lcd_hs(lcd_hs),           // 行同步信号
        .lcd_vs(lcd_vs),           // 场同步信号
        .lcd_de(lcd_de),           // 数据使能信号
        .lcd_rgb(lcd_rgb),         // RGB 数据
        .lcd_bl(lcd_bl),           // 背光控制信号
        .lcd_rst(lcd_rst),         // 复位信号
        .lcd_pclk(lcd_pclk),       // 采样时钟
        .pixel_data(pixel_data_w), // 像素点数据
        .pixel_xpos(pixel_xpos_w), // 像素点横坐标
        .pixel_ypos(pixel_ypos_w)  // 像素点纵坐标
    );

    // LCD 显示模块实例化
    lcd_display u_lcd_display (
        .lcd_clk(lcd_clk_w),       // LCD 驱动时钟
        .sys_rst_n(rst_n_w),       // 内部复位信号
        .pixel_xpos(pixel_xpos_w), // 像素点横坐标
        .pixel_ypos(pixel_ypos_w), // 像素点纵坐标
        .number(display_num),      // 输入数字
        .pixel_data(pixel_data_w)  // 像素点数据
    );

endmodule
