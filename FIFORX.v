//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 09:48:40 PM
// Design Name: 
// Module Name: FIFORX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFORX(
    input PSEL, // Chip select for i/o FIFO
    input PWRITE, //1 = write to ssp, 0 = read from ssp
    input [7:0] RxData, //data into fifo
    input CLEAR_B, //reset signal
    input PCLK, // clock
    input fin, //signal from logic that all 8 bits have been recieved
    output SSPRXINTR, // fifofull signal
    output [7:0] PRDATA //parallel data out
    );
    
    reg [7:0] fifomem [3:0];
    reg [3:0] fifopoint;
    
    always@(posedge PCLK)
    begin
        if (!CLEAR_B)
        begin
            fifomem[0] <= 8'b0000000;
            fifomem[1] <= 8'b0000000;
            fifomem[2] <= 8'b0000000;
            fifomem[3] <= 8'b0000000;
            fifopoint <= 0;
        end
        else
        begin
           if(!PWRITE && PSEL)
                if (fifopoint != 0)
                begin
                    fifomem[0] <= fifomem[1];
                    fifomem[1] <= fifomem[2];
                    fifomem[2] <= fifomem[3];
                    fifopoint <= fifopoint - 1;
                end
           if (fin)
           begin
                if(fifopoint != 4 || !PWRITE && PSEL)
                begin
                fifomem[fifopoint] <= RxData;
                fifopoint <= fifopoint + 1;
                end
           end
        end
    end
    assign SSPRXINTR = (fifopoint == 4);
    assign PRDATA = fifomem[0];
endmodule
