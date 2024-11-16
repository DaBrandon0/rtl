//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 09:50:35 PM
// Design Name: 
// Module Name: ClockMU
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


module CMU(
    input clk_i,
    input clear_i,
    input [1:0] ssp_intr_i,
    output phi1,
    output phi2,
    output clk_o,
    output clear_o
    );
    assign clear_o = clear_i;
    assign clk_o = clk_i;
    
    reg [1:0] alter; 

    always@(posedge clk_i)
    begin
        if (!clear_i)
            alter <= 0;
        else
            alter <= alter + 1;
    end
   
    assign phi1 = alter == 1 && !(ssp_intr_i[0]);
    assign phi2 = alter == 3 && !(ssp_intr_i[0]);
    
endmodule
