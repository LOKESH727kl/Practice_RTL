module comb_Q3(
  input a_in,
  input b_in,
  input c_in,
  output logic y_out
);

  logic and1_out;
  logic and2_out;
  logic and3_out;
  logic or_out;
  
always_ff @(*)begin
  and1_out = a_in & b_in;
  and2_out = b_in & c_in;
  or_out = b_in | c_in;
  and3_out = or_out & and2_out;
  y_out = and1_out | and3_out;
end
endmodule


module comb_Q3_tb;
    logic a_in;
    logic b_in;
    logic c_in;
    logic y_out;

comb_Q3 dut(
  .a_in(a_in),
  .b_in(b_in),
  .c_in(c_in),
  .y_out(y_out)
);
initial begin
  a_in = 0; b_in = 0; c_in = 0;
  #10 a_in = 0; b_in = 0; c_in = 1;
  #10 a_in = 0; b_in = 1; c_in = 1;
  #10 a_in = 1; b_in = 0; c_in = 1;
  #10 a_in = 1; b_in = 1; c_in = 1;
  #10 a_in = 1; b_in = 1; c_in = 0;

  #10 $finish;
end

  initial begin
    $monitor("time = %d, a_in = %d, b_in = % d, c_in = %d, y_out = %d",$time,a_in,b_in,c_in,y_out);
  end

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule