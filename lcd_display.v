module lcd_display(
    input lcd_clk,                // LCD 驱动时钟
    input sys_rst_n,              // 复位信号
    input [10:0] pixel_xpos,      // 像素点横坐标
    input [10:0] pixel_ypos,      // 像素点纵坐标
    input [3:0] number,           // 输入数字 (0-9)
    output reg [23:0] pixel_data  // 像素点数据
);
    parameter H_DISP = 11'd800;   // 行分辨率
    parameter V_DISP = 11'd480;   // 列分辨率
    localparam WHITE = 24'hFFFFFF; // 白色背景
    localparam BLACK = 24'h000000; // 黑色前景

    // 数码管显示区域大小
    localparam SEGMENT_WIDTH = 10;   // 段宽度
    localparam SEGMENT_HEIGHT = 60; // 段高度
    localparam GAP = 10;            // 段间距

    // 数码管中心点
    localparam CENTER_X = H_DISP / 2;
    localparam CENTER_Y = V_DISP / 2;

    // 每个段的起点位置
    wire [10:0] seg_a_x_start = CENTER_X - SEGMENT_HEIGHT / 2;
    wire [10:0] seg_a_y_start = CENTER_Y - (SEGMENT_HEIGHT + 2 * GAP);

    wire [10:0] seg_b_x_start = CENTER_X + SEGMENT_HEIGHT / 2;
    wire [10:0] seg_b_y_start = CENTER_Y - SEGMENT_HEIGHT - GAP;

    wire [10:0] seg_c_x_start = seg_b_x_start;
    wire [10:0] seg_c_y_start = CENTER_Y + GAP;

    wire [10:0] seg_d_x_start = seg_a_x_start;
    wire [10:0] seg_d_y_start = CENTER_Y + SEGMENT_HEIGHT + 2 * GAP;

    wire [10:0] seg_e_x_start = CENTER_X - SEGMENT_HEIGHT / 2;
    wire [10:0] seg_e_y_start = seg_c_y_start;

    wire [10:0] seg_f_x_start = seg_a_x_start;
    wire [10:0] seg_f_y_start = seg_b_y_start;

    wire [10:0] seg_g_x_start = seg_a_x_start;
    wire [10:0] seg_g_y_start = CENTER_Y - SEGMENT_WIDTH / 2;

    // 数字与段点亮模式对应表
    reg [6:0] segment_map [0:9];
    initial begin
        segment_map[0] = 7'b1111110;
        segment_map[1] = 7'b0110000;
        segment_map[2] = 7'b1101101;
        segment_map[3] = 7'b1111001;
        segment_map[4] = 7'b0110011;
        segment_map[5] = 7'b1001011;
        segment_map[6] = 7'b1011111;
        segment_map[7] = 7'b1110000;
        segment_map[8] = 7'b1111111;
        segment_map[9] = 7'b1111011;
    end

    // 当前数字的点亮模式
    wire [6:0] segment_pattern = segment_map[number];

    // 判断是否在某段的区域内
    wire seg_a = (pixel_xpos >= seg_a_x_start && pixel_xpos < seg_a_x_start + SEGMENT_HEIGHT &&
                  pixel_ypos >= seg_a_y_start && pixel_ypos < seg_a_y_start + SEGMENT_WIDTH);
    wire seg_b = (pixel_xpos >= seg_b_x_start && pixel_xpos < seg_b_x_start + SEGMENT_WIDTH &&
                  pixel_ypos >= seg_b_y_start && pixel_ypos < seg_b_y_start + SEGMENT_HEIGHT);
    wire seg_c = (pixel_xpos >= seg_c_x_start && pixel_xpos < seg_c_x_start + SEGMENT_WIDTH &&
                  pixel_ypos >= seg_c_y_start && pixel_ypos < seg_c_y_start + SEGMENT_HEIGHT);
    wire seg_d = (pixel_xpos >= seg_d_x_start && pixel_xpos < seg_d_x_start + SEGMENT_HEIGHT &&
                  pixel_ypos >= seg_d_y_start && pixel_ypos < seg_d_y_start + SEGMENT_WIDTH);
    wire seg_e = (pixel_xpos >= seg_e_x_start && pixel_xpos < seg_e_x_start + SEGMENT_WIDTH &&
                  pixel_ypos >= seg_e_y_start && pixel_ypos < seg_e_y_start + SEGMENT_HEIGHT);
    wire seg_f = (pixel_xpos >= seg_f_x_start && pixel_xpos < seg_f_x_start + SEGMENT_WIDTH &&
                  pixel_ypos >= seg_f_y_start && pixel_ypos < seg_f_y_start + SEGMENT_HEIGHT);
    wire seg_g = (pixel_xpos >= seg_g_x_start && pixel_xpos < seg_g_x_start + SEGMENT_HEIGHT &&
                  pixel_ypos >= seg_g_y_start && pixel_ypos < seg_g_y_start + SEGMENT_WIDTH);

    // 生成像素数据
    always @(posedge lcd_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            pixel_data <= WHITE; // 默认背景白色
        else begin
            // 根据当前段点亮模式判断像素颜色
            if ((seg_a && segment_pattern[6]) ||
                (seg_b && segment_pattern[5]) ||
                (seg_c && segment_pattern[4]) ||
                (seg_d && segment_pattern[3]) ||
                (seg_e && segment_pattern[2]) ||
                (seg_f && segment_pattern[1]) ||
                (seg_g && segment_pattern[0]))
                pixel_data <= BLACK; // 段亮起为黑色
            else
        end
                pixel_data <= WHITE; // 其余为白色
    end

endmodule

