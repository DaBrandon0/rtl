module FIFOTX(
    input PSEL, // Chip select for i/o FIFO
    input PWRITE, //1 = write to ssp, 0 = read from ssp
    input [7:0] PWDATA, //data into fifo
    input CLEAR_B, //reset signal
    input PCLK, // clock
    input fin, //signal from logic that all 8 bits have been transmitted
    output validTx, // valid fifo out
    output SSPTXINTR, // fifofull signal
    output reg [7:0] TxData //parallel data
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
           TxData <= fifomem[0];
           if (fin)
           begin
                if (fifopoint != 0)
                begin
                    fifomem[0] <= fifomem[1];
                    fifomem[1] <= fifomem[2];
                    fifomem[2] <= fifomem[3];
                    fifopoint <= fifopoint - 1;
                end
           end
           if (PSEL && PWRITE)
           begin
                if(fifopoint != 4)
                begin
                fifomem[fifopoint] <= PWDATA;
                fifopoint <= fifopoint + 1;
                end
           end
        end
    end
    assign SSPTXINTR = (fifopoint == 4);
    assign validTx = (fifopoint > 0);
    
endmodule
