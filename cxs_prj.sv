module cxs_tx_256to512 (

    input  logic          cxs_clk,
    input  logic          cxs_rst_n,

    // -----------------------------
    // CXS TX-side 
    // -----------------------------
    input  logic          cxs_valid,
	input  logic          cxs_last,
	input  logic          cxs_activereq,
    input  logic          cxs_crdrtn,      
    input  logic [1:0]    pkt_send_sts,
    input  logic [2:0]    cxs_prcltype,
  	input  logic [13:0]	  cxs_cntl,	
	input  logic [255:0]  cxs_data,
	
    output logic          cxs_activeack,
    output logic          cxs_crdgnt,
    output logic          cxs_deacthint,

    // -----------------------------
    // TX → RX Interface
    // -----------------------------
    input  logic          rx_ready,

    output logic          tx_valid,
    output logic          tx_pkt_vld,
  	output logic [511:0]  tx_pkt_data
);

    // =========================================================
    // Internal signals
    // =========================================================
    logic        	tx_cxs_intf_rdy;
    logic [511:0]	data_buffer;
    logic [255:0] 	header;

    // =========================================================
    // Link Control
    // =========================================================

always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n)			tx_valid <= 1'b0;
  else if(cxs_activereq)	tx_valid <= 1'b1;
  else 						tx_valid <= 1'b0;

always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n)								cxs_activeack <= 1'b0;
  else if(cxs_activereq & tx_valid & rx_ready)	cxs_activeack <= 1'b1;
  else if(!cxs_activereq)						cxs_activeack <= 1'b0;

    
always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n)												tx_cxs_intf_rdy <= 1'b0;
  else if(cxs_activereq & tx_valid & rx_ready & cxs_activeack)	tx_cxs_intf_rdy <= 1'b1;
  else 															tx_cxs_intf_rdy <= 1'b0;

always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
    if (!cxs_rst_n) cxs_deacthint <= 1'b0;
	else			cxs_deacthint <= (cxs_activeack & (!cxs_activereq)); 
 
    // =========================================================
    // CREDIT GRANT 
    // =========================================================
always_ff @(posedge cxs_clk or negedge cxs_rst_n)
  if (!cxs_rst_n)	cxs_crdgnt <= 1'b0;
  else 				cxs_crdgnt <= tx_cxs_intf_rdy;
  

always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n) 										data_buffer <= 512'h0;
  else if (cxs_valid & tx_cxs_intf_rdy & cxs_crdgnt)	data_buffer <= {cxs_data, cxs_data};  
  else 													data_buffer <= 512'h0; //data_buffer to hold

  


// =========================================================
// Header Formation (256-bit)
// =========================================================

logic        dp;                     // 1 bit
logic        cp;                     // 1 bit
logic [1:0]  cxs_maxpktperflit;      // 2 bits
logic [1:0]  cxs_dataflitwidth;      // 2 bits
//logic        cxs_last;               // 1 bit
//logic [13:0] cxs_cntl;               // 44 bits
//logic [255:0] header;



assign header = {
    dp,                          // [255]
    cp,                          // [254]
    205'h0,                      // [253:49]  (253-49+1 = 205 bits)
    cxs_maxpktperflit,           // [48:47]   (2 bits)
    cxs_dataflitwidth,           // [46:45]   (2 bits)
    cxs_last,                    // [44]
    30'h0,                       // [43:14]   (30 bits)
    cxs_cntl                     // [13:0]    (14 bits)
};

logic pkt_ready;

assign #10 pkt_ready = cxs_valid & tx_cxs_intf_rdy & cxs_crdgnt & rx_ready;

always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n)          tx_pkt_vld <= 1'b0;
  else if (pkt_ready)      tx_pkt_vld <= 1'b1;
  else                     tx_pkt_vld <= 1'b0;
  
always_ff @(posedge cxs_clk or negedge cxs_rst_n) 
  if (!cxs_rst_n)                tx_pkt_data <= 512'h0;
  else if (pkt_ready)            tx_pkt_data <= {header, cxs_data};
  else                           tx_pkt_data <= tx_pkt_data;

endmodule

