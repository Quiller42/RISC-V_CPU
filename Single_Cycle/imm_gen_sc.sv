module imm_gen_sc (
    input  logic [31:0] instruction,
    output logic [31:0] imm_value
);

    always_comb begin
        case (instruction[6:0])
            // I-type (addi, lw): Slice 12 bits, cast to signed, extend to 32 bits
            7'b0010011: imm_value = 32'(signed'(instruction[31:20]));
            
            // S-type (sw): Piece together 12 bits, cast to signed, extend to 32 bits
            7'b0100011: imm_value = 32'(signed'({instruction[31:25], instruction[11:7]}));
            
            // B-type (beq, bne): Piece together 13 bits (with 0 on LSB), cast to signed, extend to 32 bits
            7'b1100011: imm_value = 32'(signed'({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}));
            
            // U-type (lui, auipc): Unsigned upper immediate values
            7'b0110111, 
            7'b0010111: imm_value = {instruction[31:12], 12'b0};
            
            // J-type (jal): Piece together 21 bits (with 0 on LSB), cast to signed, extend to 32 bits
            7'b1101111: imm_value = 32'(signed'({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}));
            
            default:    imm_value = 32'b0;
        endcase
    end

endmodule