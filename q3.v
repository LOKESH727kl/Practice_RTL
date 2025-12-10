module mux(
    input P,
    input Q,
    input R,
    input S,
    input T,
    output reg Y
);
  
  reg p1_out;
  reg QR_out;
  reg RS_out;
  reg mux1_out0;
  reg and_out;
  
always @(*)begin
      p1_out = P & Q;
      QR_out = Q ^ R;
      RS_out = R & S;
      mux1_out0 = T ? RS_out : QR_out;
      and_out = p1_out & mux1_out0;
      Y = T ? and_out : p1_out;
  end
endmodule

  



  
module mux_tb;
    reg P;
    reg Q;
    reg R;
    reg S;
    reg T;
    wire Y;

mux dut(
    .P(P),
    .Q(Q),
    .R(R),
    .S(S),
    .T(T),
    .Y(Y)
);

initial begin
          
  P = 0; Q = 0; R = 0; S = 0; T = 0;
  
	#10 P = 0; Q = 1; R = 0; S = 1; T = 0;
	#10 P = 1; Q = 1; R = 0; S = 1; T = 0;
	#10 P = 1; Q = 1; R = 0; S = 1; T = 1;
	#10 P = 1; Q = 0; R = 1; S = 1; T = 1;
	#10 P = 1; Q = 1; R = 1; S = 0; T = 1;
  
#20 $finish;
end

initial begin
  $monitor("time = %0t |T = %d | P = %d  |Q = %d | R = %d  | S = %d  | Y = %d  |",$time , T,P,Q,R,S,Y);
end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule