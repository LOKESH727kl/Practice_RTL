module d3_ff(
    input d_clk,
    input d_rst_n,
    input data_in,
    output reg Q2
);
   reg Q0;
   reg Q1;

always @ (posedge d_clk or negedge d_rst_n) begin 
  if(!d_rst_n)  begin
    Q0 <= 0;
    Q1 <= 0;
    Q2 <= 0;
  end
    else  begin
      Q0 <= data_in ^ (Q1 ^ Q2);
      Q1 <= Q0;
      Q2 <= Q1;
    end
end
endmodule



module d3_ff_tb;
  reg d_clk;
  reg d_rst_n;
  reg data_in;
  wire Q0;
  wire Q1;
  wire Q2;

d3_ff dut(
  .d_clk(d_clk),
  .d_rst_n(d_rst_n),
  .data_in(data_in),
  .Q0(Q0),
  .Q1(Q1),
  .Q2(Q2)
);

initial begin
    d_clk = 0;
    forever #5 d_clk = ~ d_clk;
end

initial begin
    d_rst_n = 0;
    data_in = 0;

#10 d_rst_n = 1'b1;

#10 data_in = 1;
#10 data_in = 0;
#20 $finish;
end
initial begin
  $monitor("time = %0t |clk= %d | reset = %d | data_in =  %d  | Q0 = %d | Q1 = %d | Q2 = %d  ",$time , d_clk, d_rst_n, data_in,Q0,Q1,Q2);
end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
