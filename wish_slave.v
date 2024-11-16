//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 12:03:49 PM
// Design Name: 
// Module Name: wish_slave
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


module SLAVE(
    input rst_i,
    input clk_i,
    input [25:0] adr_i,
    input [31:0] dat_i,
    input we_i,
    input stb_i,
    output reg ack_o,
    input cyc_i,
    input tagn_i,
    output tagn_o,
    inout [31:0] dataBus,
    output reg [31:0] dat_o,
    output reg [25:0] mem_adr_o,
    output reg mem_r_o,
    output reg mem_w_o,
    output reg ssp_sel_o,
    output reg ssp_w_o
    );
    
    reg [3:0] state;
    reg [3:0] nstate;

    assign dataBus = we_i ? dat_i : 32'bZ;
    
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
        case(state)
        4'd0:
        begin
            mem_r_o = 0;
            mem_w_o = 0;
            ssp_sel_o = 0;
            ssp_w_o = 0;
            ack_o = 0;
            mem_adr_o = adr_i;
            if(cyc_i && stb_i)
            begin
                if(adr_i <= 26'h000FFFF)// memory access
                begin
                    if(we_i)
                    begin
                        mem_r_o = 0;
                        mem_w_o = 1;
                        nstate = 1;
                    end
                    else
                    begin
                        dat_o = dataBus;
                        mem_w_o = 0;
                        mem_r_o = 1;
                        nstate = 2;
                    end
                end
                else if (adr_i == 26'h0010001 && !we_i)//read SSP
                begin
                    dat_o = dataBus;
                    ssp_sel_o = 1;
                    ssp_w_o = 0;
                    nstate = 2;
                end
                else if (adr_i == 26'h0010000 && we_i)//write SSP
                begin
                    ssp_sel_o = 1;
                    ssp_w_o = 1;
                    nstate = 1;
                end
            end
            else
                nstate = 0;
        end
        4'd1:
        begin
            ssp_sel_o = 0;
            ssp_w_o = 0;
            nstate = 3;
        end
        4'd2:
        begin
            ssp_sel_o = 0;
            ssp_w_o = 0;
            nstate = 4;
        end
        4'd3:
        begin
            ssp_sel_o = 0;
            ssp_w_o = 0;
            nstate = 5;
        end
        4'd4:
        begin
            ssp_sel_o = 0;
            ssp_w_o = 0;
            nstate = 6;
        end
        4'd5:
        begin
            ack_o = 1;
            ssp_sel_o = 0;
            ssp_w_o = 0;
            nstate = 0;
        end
        4'd6:
        begin
            ssp_sel_o = 0;
            ssp_w_o = 0;
            ack_o = 1;
            nstate = 0;
        end
        endcase
    end
endmodule
