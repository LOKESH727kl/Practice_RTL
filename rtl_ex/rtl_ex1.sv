module rtl_ex(
  input clk,
  input rst_n,
  input a_in,
  input sel,
  output logic out_c
);
logic a_reg;
logic mux_c;
always_ff @(posedge clk or negedge rst_n)
if (!rst_n)  a_reg <= 1'b0;
else         a_reg <= a_in;
assign mux_c =  sel ? a_reg : 1'b0 ; 
assign out_c = mux_c & a_reg ;
endmodule 
