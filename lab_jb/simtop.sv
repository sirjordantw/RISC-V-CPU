/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(KEY),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);

	// pulse reset (active low)
	initial begin
		KEY <= 4'he;
		#10;
		KEY <= 4'hf;
	end
	
	// drive clock
	always begin
		clk <= 1'b0; #5;
		clk <= 1'b1; #5;
	end
	
	// assign simulated switch values
	assign SW = 18'd4;
	
	// Test Bench CPU
	logic [31:0] display;
	cpu mycpu(.clk(clk), .rst_n(KEY[0]), .io0_in({14'b0, SW}), .io2_out(display));
	
	integer i;
	
	initial begin
		$display("====================================================");
		$display("|Cycle | PC  | Instruction | Input     | Display   |");
		$display("|------|-----|-------------|-----------|-----------|");
		for(i=0; i<200; i++)begin
			clk <= 1'b0; #5;
			clk <= 1'b1; #5;
			$display("|%5d | %h | 0x%h  |     %d|   %h|", i, mycpu.PC_FETCH, mycpu.instruction_EX, SW, display);
		end
		$display("====================================================");
	end

	initial begin
		#5000;
		$display("Square Root of %d = %03h.%05h", SW, display[31:20], display[19:0]);
		$display("====================================================");
	end
endmodule

