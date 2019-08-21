


module top (
  input CLK12,

  output wire ss,
  input wire  miso,
  output wire mosi,
  output wire sck,

  output wire [7:0] HC,
  output wire [3:0] HB,
  output wire v,
  input wire [3:0] S,

  output R,
  output G,
  output B
  );
  parameter issimulation=0;   // sets clock to input clk for sim.


  reg[31:0] count=0;
  reg[17:0] sweep=0;
  reg rst=0,loadlookup=0;

  wire wen,busy;
	wire[15:0] addr, wdata, addr_w, addr_r, dout,
  sin, cos;


  // PLL vars
  wire lock,clk,pllclk;


  // Assignments

  assign clk= issimulation?  CLK12 : pllclk;    // if this gets synthed migh effect clk skew??

  assign {R,G,B}=~{loadlookup,lock,busy};

  assign HC=dout[15:8];

  assign HB[3]={pulse_out};

  //assign HB[2]= S[1]? !pulse_out:0;


  assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};
  //assign addr_r={sweep};

  always @ (posedge clk) begin
    if(!loadlookup&&count[8]) loadlookup<=1;
    rst<=1;
    count<=count+1;
    sweep<=sweep+count[26:20];
  end


dds dds_core(
    clk,
    count[4],
    {sweep},
    sin,
    cos,

// sram
    addr_r,
    dout
  );


sigma_delta DAC(
    clk,
    {~cos[15],cos[14:0]},
    pulse_out
  );


Flash_to_SRAM F2SRAM(
    CLK12,
    rst,

    loadlookup,
    busy,

  // spi interface
    mosi,
    miso,
    ss,
    sck,

  // sram interface
    wen_w,
  	addr_w,
  	wdata,

    v

  );


  sram16x16 SRAM(
    clk,
    wen,
    addr,
    wdata,
    dout
  );


  SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.PLLOUT_SELECT("GENCLK"),
		.DIVR(4'b0000),
		.DIVF(7'b1001111),
		.DIVQ(3'b111),
		.FILTER_RANGE(3'b001)
	) PLL (
		.LOCK(lock),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(CLK12),
		.PLLOUTCORE(pllclk)
	);







endmodule //top
