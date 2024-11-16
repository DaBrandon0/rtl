//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 10:33:15 PM
// Design Name: 
// Module Name: wish_master
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
/*
The TAG signals [TAGN_I] and [TAGN_O] are used by both MASTER and SLAVE modules.
They are used for three purposes: (a) to tag data with information such as parity or time stamps,
(b) to identify specialty bus cycles (like interrupts or cache control operations) 
and (c) to communicate with the bus interconnection. These signals are user defined.
*/
//////////////////////////////////////////////////////////////////////////////////


module MASTER(
    input rst_i,
    input clk_i,
//from ARM
    input mem_req, //0 = memory request
    input mwr_arm,
    input memoryRead,
    input memoryWrite,
    input [25:0] addressBus,
//from slave
    input [31:0] dat_i,// recieves binary data
    input ack_i, //acknowledges termination of normal bus cycle
    input tagn_i,
    output reg [25:0] adr_o,// passes binary address
    output reg [31:0] dat_o,// passes binary data
    output reg we_o,// bus cycle is read(0) or write(1)
    output reg stb_o,// indicates valid data transfer, 0 when reset
    output reg cyc_o,// 1 = valid bus cycle in progress, 0 when reset
    output tagn_0,
    inout [31:0] dataBus
    );
    

    reg [3:0] state;
    reg [3:0] nstate;
    reg [31:0] data;
    
    assign dataBus = we_o ? 32'bz : data;
    
    always@(posedge clk_i)
    begin
        if(!rst_i)
        begin
            state <= 0;
        end
        else
        begin
            state <= nstate;
        end
    end
   
    always@(*)
    begin
        case (state)
        4'd0:
        begin
        if (memoryRead && !mem_req && rst_i)
        begin
            nstate = 1;
            we_o = 0;
            cyc_o = 1;
            stb_o = 1;
            adr_o = addressBus;
        end
        else if (memoryWrite && !mem_req && rst_i)
        begin
            nstate = 2;
            adr_o = addressBus;
            we_o = 1;
            cyc_o = 1;
            stb_o = 1;
            dat_o = dataBus;
        end
        else
        begin
            nstate = 0;
        end
        end
        4'd1://memory read
        begin
            if(ack_i)
            begin
                data = dat_i;
                stb_o = 0;
                cyc_o = 0;
                nstate = 0;
            end
            else
                nstate = 1;
        end
        
        4'd2://memory write
        begin
            if(ack_i)
            begin
                nstate = 0;
                stb_o = 0;
                cyc_o = 0;
            end
            else
                nstate = 2;
        end
        endcase
    end
    
endmodule
