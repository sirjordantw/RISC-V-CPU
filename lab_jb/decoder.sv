module decoder(
	input logic [31:0] A,
	output logic [6:0] op,
	output logic [4:0] rd,
	output logic [2:0] funct3,
	output logic [4:0] rs1,
	output logic [4:0] rs2,
	output logic [6:0] funct7,
	output logic [11:0] imm12,
	output logic [19:0] imm20
);

	assign op = A[6:0];
	assign rd = A[11:7];
	assign funct3 = A[14:12];
	assign rs1 = A[19:15];
	assign rs2 = A[24:20];
	assign funct7 = A[31:25];
	assign imm12 = A[31:20];
	assign imm20 = A[31:12];

endmodule
