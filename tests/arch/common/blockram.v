`default_nettype none
module sync_ram_sp #(parameter DATA_WIDTH=8, ADDRESS_WIDTH=10)
   (input  wire                      write_enable, clk,
    input  wire  [DATA_WIDTH-1:0]    data_in,
    input  wire  [ADDRESS_WIDTH-1:0] address_in,
    output wire  [DATA_WIDTH-1:0]    data_out);

  localparam WORD  = (DATA_WIDTH-1);
  localparam DEPTH = (2**ADDRESS_WIDTH-1);

  reg [WORD:0] data_out_r;
  reg [WORD:0] memory [0:DEPTH];

  always @(posedge clk) begin
    if (write_enable)
      memory[address_in] <= data_in;
    data_out_r <= memory[address_in];
  end

  assign data_out = data_out_r;

endmodule // sync_ram_sp


`default_nettype none
module sync_ram_sdp #(parameter DATA_WIDTH=8, ADDRESS_WIDTH=10)
   (input  wire                      clk, write_enable,
    input  wire  [DATA_WIDTH-1:0]    data_in,
    input  wire  [ADDRESS_WIDTH-1:0] address_in_r, address_in_w,
    output wire  [DATA_WIDTH-1:0]    data_out);

  localparam WORD  = (DATA_WIDTH-1);
  localparam DEPTH = (2**ADDRESS_WIDTH-1);

  reg [WORD:0] data_out_r;
  reg [WORD:0] memory [0:DEPTH];

  always @(posedge clk) begin
    if (write_enable)
      memory[address_in_w] <= data_in;
    data_out_r <= memory[address_in_r];
  end

  assign data_out = data_out_r;

endmodule // sync_ram_sdp


`default_nettype none
module sync_ram_mixed #(parameter WD_WIDTH=9, WA_WIDTH=8, RA_WIDTH=7, RD_WIDTH=18)
   (input  wire                 clk, write_enable,
    input  wire  [WD_WIDTH-1:0] data_in,
    input  wire  [WA_WIDTH-1:0] address_in_w,
    input  wire  [RA_WIDTH-1:0] address_in_r,
    output wire  [RD_WIDTH-1:0] data_out);

  localparam USE_WRITE_SIZE = WD_WIDTH >= RD_WIDTH;
  localparam DEPTH  = USE_WRITE_SIZE  ?
                      (2**WA_WIDTH -1) :
                      (2**RA_WIDTH -1) ;

  localparam OFFS = USE_WRITE_SIZE ?
                    (RA_WIDTH - WA_WIDTH) :
                    (WA_WIDTH - RA_WIDTH) ;
  localparam MASK = (2**OFFS -1);


  reg [RD_WIDTH-1:0] data_out_r;

  (* syn_ramstyle = "block_ram" *)
  reg [WD_WIDTH-1:0] memory [0:DEPTH];

  integer i;
  localparam initval = 2**WD_WIDTH-1;
  initial
    for (i=0; i<DEPTH; i = i+1) begin
      memory[i] = initval;
    end

  always @(posedge clk)
    if (write_enable)
      if (USE_WRITE_SIZE)
        memory[address_in_w] <= data_in;
      else
        memory[address_in_w>>OFFS][address_in_w&MASK *WD_WIDTH+:WD_WIDTH] <= data_in;

  always @(posedge clk)
    if (USE_WRITE_SIZE)
      data_out_r <= memory[address_in_r>>OFFS][address_in_r&MASK *RD_WIDTH+:RD_WIDTH];
    else
      data_out_r <= memory[address_in_r];

  assign data_out = data_out_r;

endmodule // sync_ram_mixed

