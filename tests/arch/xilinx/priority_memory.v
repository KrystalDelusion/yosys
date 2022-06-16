module priority_memory (
	clk, wren_a, rden_a, addr_a, wdata_a, rdata_a,
	wren_b, rden_b, addr_b, wdata_b, rdata_b
	);
	
	parameter ABITS = 12;
	parameter WIDTH = 72;

	input clk;
	input wren_a, rden_a, wren_b, rden_b;
	input [ABITS-1:0] addr_a, addr_b;
	input [WIDTH-1:0] wdata_a, wdata_b;
	output reg [WIDTH-1:0] rdata_a, rdata_b;

	`ifdef USE_HUGE
	(* ram_style = "huge" *)
	`endif
	reg [WIDTH-1:0] mem [0:2**ABITS-1];

	integer i;
	initial begin
	// 	for (i = 0; i < 2**ABITS; i = i+1)
	// 		mem[i] <= 'h0;
		rdata_a <= 'h0;
		rdata_b <= 'h0;
	end


	always @(posedge clk) begin
		if (addr_a != addr_b) begin
			// A port
			if (wren_a)
				mem[addr_a] <= wdata_a;
			else if (rden_a) 
				rdata_a <= mem[addr_a];

			// B port
			if (wren_b)
				mem[addr_b] <= wdata_b;
			else if (rden_b) 
				rdata_b <= mem[addr_b];
		end else begin
			// B has write priority
			if (wren_b) begin
				if (rden_a)
					// A reads old
					rdata_a <= mem[addr_a];
				mem[addr_b] <= wdata_b;
			end else if (wren_a) begin
				mem[addr_a] <= wdata_a;
				if (rden_b)
					// B reads new
					rdata_b <= wdata_a;
			end
		end
	end
endmodule

module sp_write_first (clk, wren_a, rden_a, addr_a, wdata_a, rdata_a);

	parameter ABITS = 12;
	parameter WIDTH = 72;

	input clk;
	input wren_a, rden_a;
	input [ABITS-1:0] addr_a;
	input [WIDTH-1:0] wdata_a;
	output reg [WIDTH-1:0] rdata_a;

	(* ram_style = "huge" *)
	reg [WIDTH-1:0] mem [0:2**ABITS-1];

	integer i;
	initial begin
		rdata_a <= 'h0;
	end


	always @(posedge clk) begin
		// A port
		if (wren_a)
			mem[addr_a] <= wdata_a;
		if (rden_a) 
			if (wren_a)
				rdata_a <= wdata_a;
			else
				rdata_a <= mem[addr_a];
	end
endmodule

module sp_read_first (clk, wren_a, rden_a, addr_a, wdata_a, rdata_a);

	parameter ABITS = 12;
	parameter WIDTH = 72;

	input clk;
	input wren_a, rden_a;
	input [ABITS-1:0] addr_a;
	input [WIDTH-1:0] wdata_a;
	output reg [WIDTH-1:0] rdata_a;

	(* ram_style = "huge" *)
	reg [WIDTH-1:0] mem [0:2**ABITS-1];

	integer i;
	initial begin
		rdata_a <= 'h0;
	end


	always @(posedge clk) begin
		// A port
		if (wren_a)
			mem[addr_a] <= wdata_a;
		if (rden_a) 
			rdata_a <= mem[addr_a];
	end
endmodule
