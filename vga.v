module vga(
    input wire clk,
    input wire [11:0] sw,
    input wire [1:0] push,
    output wire hsync, vsync,
    output wire [11:0] rgb
    );
   
    parameter WIDTH = 640;
    parameter HEIGHT = 480;


    parameter PADDLE_WIDTH = 20;
    parameter PADDLE_HEIGHT = 80;
    parameter BALL_SIZE = 20;


    reg [9:0] paddle1_y, paddle2_y;
    reg [9:0] ball_x, ball_y;




    // register for Basys 2 8-bit RGB DAC
    reg [11:0] rgb_reg;
    reg reset = 0;
    wire [9:0] x, y;
   
    // video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on;
    wire p_tick;


    // instantiate vga_sync
    vga_sync vga_sync_unit (
        .clk(clk), .reset(reset),
        .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(p_tick),
        .x(x), .y(y)
        );
       
    // compute gradient
    reg state = 0;
    reg [11:0] top_color = 0;
    always @(posedge clk) begin
       if (push[0]) state = !state; // change direction
       if (push[1]) top_colora <= sw; // load more color to gradient
    end


    always @(posedge p_tick) // merge 2 colors with weighted average
begin
    rgb_reg <= (x < PADDLE_WIDTH && y >= paddle1_y && y < paddle1_y + PADDLE_HEIGHT) ||
    ((x >= WIDTH - PADDLE_WIDTH) && y >= paddle2_y && y < paddle2_y + PADDLE_HEIGHT) ||
    (x >= ball_x && x < ball_x + BALL_SIZE && y >= ball_y && y < ball_y + BALL_SIZE) ? 12'b1111 : 12'b0000;
end




   
    // output
    assign rgb = (video_on) ? rgb_reg : 12'b0;
endmodule
