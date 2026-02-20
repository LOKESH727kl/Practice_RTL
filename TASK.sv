
module task_1(
    input clkA,				// Source clock domain clock A
    input clkB,				// Destination clock domain clock B
    input rst_n,			//  Active-low reset
	input sigA,				// Incoming pulse
    output logic out 		//output pulse single cycle
);
    logic q1_out;
    logic d_in;
	
    assign d_in = sigA ^ q1_out;  // xor operation for  Toggle logic

	//////block1_flipflop_1/////////
always_ff @(posedge clkA or negedge rst_n)
    if(!rst_n)  q1_out <= 0;
    else        q1_out <= d_in;
	
	//////block_2_flipflops/////////
	
logic [2:0] q2_out;
always_ff @(posedge clkB or negedge rst_n)
	if (!rst_n) 	q2_out <= 3'h0;
	else  			q2_out <= {q2_out[1:0], q1_out};   //concatenation for synchronization
	
	assign out = q2_out[2] ^ q2_out[1]; //Edge detection using XOR
	
endmodule

/*
module task_1(
    input clkA,
    input clkB,
    input rst_n,
	input sigA,
    output logic out
);
    logic q1_out;
    logic q2_out;
    logic q3_out;
    logic q4_out;
    logic d_in;

	assign d_in = sigA ^ q1_out;

	
always_ff @(posedge clkA or negedge rst_n)
    if(!rst_n)  q1_out <= 1'b0;
    else        q1_out <= d_in;
  
always_ff @(posedge clkB or negedge rst_n)
    if(!rst_n)  q2_out <= 1'b0;
    else        q2_out <= q1_out;

always_ff @(posedge clkB or negedge rst_n)
    if(!rst_n)  q3_out <= 1'b0;
    else        q3_out <= q2_out; 

always_ff @(posedge clkB or negedge rst_n)
    if(!rst_n)  q4_out <= 1'b0;
    else        q4_out <= q3_out;    

assign out = q4_out ^ q3_out;

endmodule




	// =========================================================
    // 						TEST_BENCH
    // =========================================================

module task_1_tb;
  logic clkA;
  logic clkB;
  logic rst_n;
  logic sigA;
  wire out;

    
task_1 dut(
  .clkA(clkA),
  .clkB(clkB),
  .rst_n(rst_n),
  .sigA(sigA),
  .out(out)
);
  
 always #5 clkA = ~ clkA; 
 always #7 clkB = ~ clkB;

  initial begin
	clkA = 0;
	clkB = 0;
	rst_n = 0; 
	sigA = 0;
end

initial begin 
  @(posedge clkA); 	rst_n = 1'b1;
  @(posedge clkA) ; sigA = 0;
  @(posedge clkA) ; sigA = 1;
#100 $finish;
end
initial begin
  $monitor("time = %0t |clk_A = %d | |clk_B = %d | reset = %d | sigA =  %d  | out = %d  ",$time ,clkA, clkB,rst_n,sigA,out);
end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
*/