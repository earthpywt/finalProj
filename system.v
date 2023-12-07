module system(
    input wire [11:0]sw, //vga
    input btnC, btnU, btnL, //vga
    output wire Hsync, Vsync, //vga
    output wire [3:0] vgaRed, vgaGreen, vgaBlue, //vga
    output wire RsTx, //uart
    input wire RsRx, //uart
    input clk //both
    );
    reg [3:0] paddle_control;
vga vga(
    .clk(clk), .sw(sw),
    .push({btnL, btnU}),
    .hsync(Hsync), .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue})
    );


uart uart(clk,RsRx,RsTx,paddle_control);
   
endmodule
