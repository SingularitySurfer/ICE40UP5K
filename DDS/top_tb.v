
module top_tb ();

  reg CLK=0;
  wire R,G,B;

  wire v;
  wire[7:0] C;

  wire ss, mosi, sck;
  reg miso=0;
  reg[3:0] S=0;


top top_test(
  CLK,
  ss,
  miso,
  mosi,
  sck,

  C,
  v,
  S,

  R,
  G,
  B
  );

initial begin
  $dumpfile("out.vcd");
  $dumpvars(0, top_tb);
  #10
  S[0]<=1;
  S[1]<=1;
  #1000
  $display("hallu world");
  $finish;
end

always begin
  #1
  CLK<=!CLK;
end

endmodule //top_tb
