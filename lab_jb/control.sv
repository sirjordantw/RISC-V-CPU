module control(
	input logic stall,
	input logic [31:0] R,
	input logic [6:0] op,
	input logic [2:0] funct3,
	input logic [6:0] funct7,
	input logic [11:0] imm12,
	output logic [3:0] aluop,
	output logic [1:0] regsel,
	output logic regwrite,
	output logic GPIO_we,
	output logic alusrc,
	output logic [1:0] pcsrc,
	output logic stall_fetch
);

/*
	(op == 4'b0000) ? A & B : AND
	(op == 4'b0001) ? A | B : OR
	(op == 4'b0010) ? A ^ B : XOR
	(op == 4'b0011) ? A + B : ADD
	(op == 4'b0100) ? A - B : SUB
	(op == 4'b0101) ? mulls : MUL
	(op == 4'b0110) ? mulhs : MULH Signed
	(op == 4'b0111) ? mulhu : MULH Unsigned
	(op == 4'b1000) ? A << shamt : SLL
	(op == 4'b1001) ? A >> shamt : SRL
	(op == 4'b1010) ? shifted : Arth Shifts
	(op == 4'b1011) ? shifted : Arth Shifts
	(op == 4'b1100) ? ($signed(A) < $signed(B)) : slt
	(op == 4'b1101) ? (A < B) : sltu
	(op == 4'b1110) ? (A < B) : (A < B); sltu
*/

	always_comb begin
		aluop = 4'b0000;
		regsel = 2'b00;
		regwrite = 1'b0;
		GPIO_we = 1'b0;
		alusrc = 1'b0;
		pcsrc = 2'b00;
		stall_fetch = 1'b0;
		
		if (~stall) begin
			if (op==7'b0110011) begin //R
				regwrite = 1'b1;
				GPIO_we = 1'b0;
				regsel = 2'b10;
				alusrc = 1'b0;
				pcsrc = 2'b00;
				
				if (funct7==7'h0) begin
					if (funct3==3'b000) aluop = 4'b0011; //add
					else if (funct3==3'b010) aluop = 4'b1100; //slt
					else if (funct3==3'b111) aluop = 4'b0000; //and
					else if (funct3==3'b001) aluop = 4'b1000; //sll
					else if (funct3==3'b110) aluop = 4'b0001; //or
					else if (funct3==3'b100) aluop = 4'b0010; //xor
					else if (funct3==3'b101) aluop = 4'b1001; //srl
					else if (funct3==3'b011) aluop = 4'b1110; //sltu
					else aluop = 4'b0000;
				end else if (funct7==7'h20) begin
					if (funct3==3'b000) aluop = 4'b0100; //sub
					else if (funct3==3'b101) aluop = 4'b1010; //sra
					else aluop = 4'b0000;
				end else if (funct7==7'h1) begin
					if (funct3==3'b000) aluop = 4'b0101; //mul
					else if (funct3==3'b001) aluop = 4'b0110; //mulh
					else if (funct3==3'b011) aluop = 4'b0111; //mulhu
					else aluop = 4'b0000;
				end
			end else if (op==7'b0010011) begin //I
				regwrite = 1'b1;
				GPIO_we = 1'b0;
				regsel = 2'b10;
				alusrc = 1'b1;
				pcsrc = 2'b00;
				if (funct3==3'b001 && funct7==7'h0) aluop = 4'b1000; //slli
				else if (funct3==3'b101 && funct7==7'h0) aluop = 4'b1001; //srli
				else if (funct3==3'b101 && funct7==7'h20) aluop = 4'b1011; //srai
				else if (funct3==3'b000) aluop = 4'b0011; //addi
				else if (funct3==3'b110) aluop = 4'b0001; //ori
				else if (funct3==3'b100) aluop = 4'b0010; //xori
				else if (funct3==3'b111) aluop = 4'b0000; //andi
				else aluop = 4'b0000;
			end else if (op==7'b0110111) begin //U (lui)
				regwrite = 1'b1;
				GPIO_we = 1'b0;
				regsel = 2'b01;
				alusrc = 1'b0;
				aluop = 4'b0000;
				pcsrc = 2'b00;
			end else if (op==7'b1110011) begin //CSRRW
				regsel = 2'b00;
				alusrc = 1'b0;
				aluop = 4'b0000;
				pcsrc = 2'b00;
				
				if (imm12==12'hf00) begin //SW
					regwrite = 1'b1;
					GPIO_we = 1'b0;
				end else if (imm12==12'hf02) begin //HEX
					regwrite = 1'b0;
					GPIO_we = 1'b1;
				end else begin
					regwrite = 1'b0;
					GPIO_we = 1'b0;
				end
			end else if (op==7'b1100011) begin //B
				regwrite = 1'b0;
				GPIO_we = 1'b0;
				regsel = 2'b00;
				alusrc = 1'b0;
				
				if (funct3==3'b000) begin //beq
					aluop = 4'b0100;
					if (R == 32'b0) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else if (funct3==3'b101) begin //bge
					aluop = 4'b1100;
					if (R == 32'b0) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else if (funct3==3'b111) begin //bgeu
					aluop = 4'b1110;
					if (R == 32'b0) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else if (funct3==3'b100) begin //blt
					aluop = 4'b1100;
					if (R == 32'b1) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else if (funct3==3'b110) begin //bltu
					aluop = 4'b1110;
					if (R == 32'b1) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else if (funct3==3'b001) begin //bne
					aluop = 4'b0100;
					if (R != 32'b0) begin
						stall_fetch = 1'b1;
						pcsrc = 2'b01;
					end else begin
						stall_fetch = 1'b0;
						pcsrc = 2'b00;
					end
				end else aluop = 4'b0000;
			end else if (op==7'b1101111) begin //jal
				regwrite = 1'b1;
				GPIO_we = 1'b0;
				regsel = 2'b11;
				alusrc = 1'b0;
				aluop = 4'b0000;
				pcsrc = 2'b10;
				stall_fetch = 1'b1;
			end else if (op==7'b1100111) begin //jalr
				regwrite = 1'b1;
				GPIO_we = 1'b0;
				regsel = 2'b11;
				alusrc = 1'b0;
				aluop = 4'b0000;
				pcsrc = 2'b11;
				stall_fetch = 1'b1;
			end
		end
	end
endmodule
