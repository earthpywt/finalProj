module uart(
    input clk,
    input RsRx,
    output RsTx,
    output reg [3:0] paddle_control
    );
   
    reg en, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
   
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_in, en, sent, RsTx);
   
always @(posedge baud)
begin
    if (en) en = 0;
    if (~last_rec & received) begin
        data_in = data_out;  // Assign received character to data_in




        // Check the received character and set paddle_control accordingly
        case (data_in)
            8'h61: paddle_control[1:0] = 2'b01;  // 'a' pressed, move paddle one up
            8'h73: paddle_control[1:0] = 2'b10;  // 's' pressed, move paddle one down
            8'h6B: paddle_control[3:2] = 2'b01;  // 'k' pressed, move paddle two up
            8'h6C: paddle_control[3:2] = 2'b10;  // 'l' pressed, move paddle two down
            default: begin
                paddle_control[1:0] = 2'b00;  // No paddle one movement
                paddle_control[3:2] = 2'b00;  // No paddle two movement
            end
        endcase




        if ((data_in >= 8'h61 && data_in <= 8'h73) || (data_in >= 8'h6B && data_in <= 8'h6C)) en = 1;
    end
    last_rec = received;
End


   
endmodule
