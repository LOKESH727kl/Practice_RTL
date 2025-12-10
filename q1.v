module ff(
    input ff_clk_A,
    input ff_clk_B,
    input ff_rst_n,
    input pin,
    output reg qout,
);

reg p1_reg;
reg p2_reg;
reg p3_reg;
reg p4_reg;


always @ (posedge ff_clk_A or negedge ff_rst_n)
  if(ff_rst_n)  p1_reg <= 1'b0;
  else          p1_reg <= pin;



always @ (posedge ff_clk_B or negedge ff_rst_n) 
  if(ff_rst_n)  p2_reg <= 1'b0;
  else          p2_reg <= p1_reg;


  always @ (posedge ff_clk_B or negedge ff_rst_n)
  if(ff_rst_n)  p3_reg <=1'b0;
  else          p3_reg <= p2_reg;

  always @ (posedge ff_clk_B or negedge ff_rst_n)
  if(ff_rst_n)  p4_reg <= 1'b0;
  else          p4_reg <= p3_reg ;

assign qout = p4_reg ^ p3_reg ;


endmodule



module ff(
    input ff_clk_A,
    input ff_clk_B,
    input ff_rst_n,
    input pin,
    output reg qout
);

reg p1_reg;

 always @ (posedge ff_clk_A or negedge ff_rst_n)
    if(!ff_rst_n)  p1_reg <= 1'b0;
  	else          p1_reg <= pin;

reg [2:0] p4_reg;

 always @ (posedge ff_clk_B or negedge ff_rst_n)
    if(!ff_rst_n)  p4_reg <= 3'h0;
    else p4_reg <= {p4_reg[1:0],p1_reg};

  assign qout = p4_reg[0] ^ p4_reg[1] ;
endmodule









module ff_tb;
  reg ff_clk_A;
    reg ff_clk_B;
    reg ff_rst_n;
    reg pin;
    wire qout;

    
ff dut(
  .ff_clk_A(ff_clk_A),
  .ff_clk_B(ff_clk_B),
  .ff_rst_n(ff_rst_n),
  .pin(pin),
  .qout(qout)
);
  
 always #5 ff_clk_A = ~ ff_clk_A; 
 always #5 ff_clk_B = ~ ff_clk_B;

  initial begin
ff_clk_A = 0;
ff_clk_B = 0;
ff_rst_n = 0; 
pin = 0;
end

initial begin 
  @(posedge ff_clk_A); ff_rst_n = 1'b1;
  @(posedge ff_clk_A) ; pin = 0;
  @(posedge ff_clk_A) ; pin = 1;
#100 $finish;
end
initial begin
  $monitor("time = %0t |clk_A = %d | |clk_B = %d | reset = %d | pin =  %d  | qout = %d  ",$time , ff_clk_A, ff_clk_B,ff_rst_n,pin,qout);
end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule