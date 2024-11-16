module TOP (clear,clock,armadr,dataBus,memread,memwrite,memwr,memreqb,phi1,phi2,dataBus_slave,memadr,memr,memw,sspclki,sspfssi,ssprx,sspclko,sspfsso,ssptx,sspoe);

input clear;
input clock;

input [25:0] armadr;
inout [31:0] dataBus;
input memread;
input memwrite;
input memwr;
input memreqb;

output phi1;
output phi2;

inout [31:0] dataBus_slave;
output [25:0] memadr;
output memr;
output memw;

input sspclki;
input sspfssi;
input ssprx;
output sspclko;
output sspfsso;
output ssptx;
output sspoe;

wire	clr;
wire	clk;

wire [25:0] adr;
wire [31:0] dat1;
wire [31:0] dat2;
wire we;
wire stb;
wire ack;
wire cyc;
wire tag1;
wire tag2;

wire sspclk;
wire sspsel;
wire sspw;
wire [1:0] sspintr;
wire ssptxintr;
wire ssprxintr;
assign sspintr[1]=ssptxintr;
assign sspintr[0]=ssprxintr;



MASTER wishmaster (.rst_i(clr), .clk_i(clk), .mem_req(memreqb), .mwr_arm(memwr), .memoryRead(memread), .memoryWrite(memwrite), .addressBus(armadr), .dat_i(dat1), .ack_i(ack), .tagn_i(tag2), .adr_o(adr), .dat_o(dat2), .we_o(we), .stb_o(stb), .cyc_o(cyc), .tagn_o(tag1), .dataBus(dataBus));

SLAVE wishslave (.rst_i(clr), .clk_i(clk), .dat_i(dat2), .adr_i(adr), .tagn_i(tag1), .we_i(we), .stb_i(stb), .cyc_i(cyc), .mem_adr_o(memadr), .mem_r_o(memr), .mem_w_o(memw), .ssp_sel_o(sspsel), .ssp_w_o(sspw), .dat_o(dat1), .tagn_o(tag2), .ack_o(ack), .dataBus(dataBus_slave));

ssp ssp2 (.PCLK(sspclk), .CLEAR_B(clr), .PSEL(sspsel), .PWRITE(sspw), .SSPCLKIN(sspclki), .SSPFSSIN(sspfssi), .SSPRXD(ssprx), .PWDATA(), .PRDATA(), .SSPCLKOUT(sspclko), .SSPFSSOUT(sspfsso), .SSPTXD(ssptx), .SSPOE_B(sspoe), .SSPTXINTR(ssptxintr), .SSPRXINTR(ssprxintr));

CMU cmu(.clk_i(clock), .clear_i(clear), .ssp_intr_i(sspintr), .phi1(phi1), .phi2(phi2), .clk_o(clk), .clear_o(clr));

endmodule
