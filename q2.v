module dual_ff(
    input d_clk,
    input d_rst_n,
    input sig_in,
  	input sig_in2,
    output reg sig_out
);

wire sig_in3;
reg sig_in1;

assign sig_in3 = sig_in1 & sig_in2;

always @ (posedge d_clk or negedge d_rst_n) begin 
  if(!d_rst_n)  begin
    sig_in1 <= 1'b0;
    sig_out <= 1'b0;
  end
    else	begin
      sig_in1 <= sig_in;
      sig_out <= sig_in3;
    end  
end
endmodule






module dual_ff_tb;
    reg d_clk;
    reg d_rst_n;
    reg sig_in;
  	reg sig_in2;
    wire sig_out;

dual_ff  dut(
    .d_clk(d_clk),
    .d_rst_n(d_rst_n),
    .sig_in(sig_in),
 	  .sig_in2(sig_in2),
    .sig_out(sig_out)
);

initial begin
    d_clk = 0;
    forever #5 d_clk = ~ d_clk;
end

initial begin
    d_rst_n = 0;
    sig_in = 0 ;
    sig_in2 = 0;

  @(posedge d_clk) d_rst_n = 1'b1;

@(posedge d_clk) sig_in = 0 ; @(posedge d_clk)sig_in2 = 1;
@(posedge d_clk) sig_in = 1 ; @(posedge d_clk)sig_in2 = 0;
@(posedge d_clk) sig_in = 1 ; @(posedge d_clk)sig_in2 = 1;
#20 $finish;
end
initial begin
    $monitor("time = %t |clk= %d | reset = %d | sig_in = %d | sig_in2 = %d  | sig_out = %d ",$time , d_clk, d_rst_n, sig_in, sig_in2, sig_out);
end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule