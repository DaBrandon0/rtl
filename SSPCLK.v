//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 10:25:53 PM
// Design Name: 
// Module Name: SSPCLK
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


module SSPCLK(
    input PCLK,
    input CLEAR_B,
    output SSPCLK
    );
    
    
    reg reseted;
    reg div2;
    always@(posedge PCLK)
    begin
        if (!CLEAR_B)
        begin
            reseted <= 1;
        end
        div2 <= 1;
        if (reseted <= 1)
            div2 <= !div2;
    end
    
    assign SSPCLK = (div2);
    
endmodule
