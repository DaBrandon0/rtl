module ssp(
    input PCLK,
    input CLEAR_B,
    input PSEL,
    input PWRITE,
    input [7:0] PWDATA,
    input SSPCLKIN,
    input SSPFSSIN,
    input SSPRXD,
    output [7:0] PRDATA,
    output reg SSPOE_B,
    output SSPTXD,
    output SSPCLKOUT, 
    output reg SSPFSSOUT,
    output SSPTXINTR,
    output SSPRXINTR
    );
    
    reg [7:0] RxData;
    wire [7:0] TxData;
    wire fintx;
    wire validTx;
    wire finrx;
    SSPCLK slow(PCLK, CLEAR_B, SSPCLKOUT);
    FIFOTX TX(PSEL, PWRITE, PWDATA, CLEAR_B, PCLK, fintx, validTx, SSPTXINTR, TxData);
    FIFORX RX(PSEL,PWRITE, RxData,CLEAR_B, PCLK, finrx, SSPRXINTR, PRDATA);
    reg[3:0] startrx;
    reg[3:0] starttx;
    reg finish;
    always@(posedge SSPCLKIN)
    begin
        if (!CLEAR_B)
            startrx <= 8;
        else
        begin
        
        if (startrx != 15 && startrx <= 7)
            begin
            RxData[startrx] <= SSPRXD;
            startrx <= startrx - 1;
            end
        if (SSPFSSIN)
            startrx <= 7;
        end
        if (startrx == 0 || startrx == 15)
            finish <= 1;
        else
            finish <= 0;
    end
    assign finrx = (finish && SSPCLKIN && PCLK);
    
    always@(posedge SSPCLKOUT)
    begin
        if (!CLEAR_B)
        begin
            starttx <= 8;
            SSPFSSOUT <= 0;
        end
        else
        begin
        if(validTx && SSPFSSOUT)
            starttx <= 7;
        if (SSPFSSOUT)
            SSPFSSOUT <= 0;
        else if(validTx && (starttx == 8 || starttx == 1))
            SSPFSSOUT <= 1;
        if(starttx != 0 && starttx <= 7)
            begin
                starttx <= starttx - 1;
            end
        end
    end
    
    always@(negedge SSPCLKOUT)
    begin
        if (!CLEAR_B)
            SSPOE_B <= 1;
        else
        begin
        if ((starttx == 8 || starttx == 0) && validTx)
          SSPOE_B <= 0;
        else if(starttx == 0 && validTx)
          SSPOE_B <= 1;
        end
    end
    
    assign fintx = (starttx == 0 && SSPCLKOUT && PCLK && !SSPRXINTR);
    assign SSPTXD = TxData[starttx] && starttx <= 7;
    //assign SSPFSSOUT = validTx && (starttx == 0);
endmodule
