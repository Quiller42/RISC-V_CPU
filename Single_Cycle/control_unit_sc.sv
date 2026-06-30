module control_unit_sc (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,       // Fixed hyphen to underscore
    output logic       mem_write,
    output logic       mem_read,
    output logic [1:0] matrix_to_reg,
    output logic       branch,
    output logic       jump,
    output logic [1:0] alu_op
);

always_comb begin
    // 1. Establish default safe states (Prevents latches!)
    reg_write     = 1'b0;
    alu_src       = 1'b0;
    mem_write     = 1'b0;
    mem_read      = 1'b0;
    matrix_to_reg = 2'b00;
    branch        = 1'b0;
    jump          = 1'b0;
    alu_op        = 2'b00;
    
    case (opcode)
        // R-type Math (add, sub, and, or)
        7'b0110011: begin
            reg_write = 1'b1;
            alu_op    = 2'b10;
        end
        
        // I-type Math (addi, andi)
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b10;
        end
        
        // Load Word (lw)
        7'b0000011: begin
            reg_write     = 1'b1;
            alu_src       = 1'b1;
            mem_read      = 1'b1;
            matrix_to_reg = 2'b01;
        end        
        
        // Store Word (sw)
        7'b0100011: begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
        end
        
        // Branch instructions (beq, bne)
        7'b1100011: begin
            branch = 1'b1;
            alu_op = 2'b01;
        end
        
        // Jump and Link (jal)
        7'b1101111: begin
            reg_write     = 1'b1;
            alu_src       = 1'b1;
            jump          = 1'b1;
            matrix_to_reg = 2'b10;
        end
        
        default: begin
            // Intentionally empty: if opcode is unknown, defaults stand.
        end
    endcase
end

endmodule