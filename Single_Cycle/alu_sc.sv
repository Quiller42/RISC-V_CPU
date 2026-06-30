module alu_sc (
    input  logic [31:0] a,
    input  logic [31:0] rs2,
    input  logic [31:0] imm_value,
    input  logic [3:0]  alu_control,
    input  logic        alu_src,
    output logic [31:0] result,
    output logic        zero
);

logic [31:0] b;
// Select b based on alu_src
assign b = alu_src ? imm_value : rs2;

always_comb begin
    result = 32'b0; // Default to 0
    
    case (alu_control)
        4'b0010: result = a + b;  // ADD
        4'b0110: result = a - b;  // SUBTRACT
        4'b0000: result = a & b;  // Bitwise AND
        4'b0001: result = a | b;  // Bitwise OR
        default: result = 32'b0;  // Safe fallback
    endcase

    // High if result is 0 for branch logic
    zero = (result == 32'b0);
end

endmodule