module alu_control (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic       funct7_bit5,
    output logic [3:0] alu_control
);

    always_comb begin
        alu_control = 4'b0010;  // add by default
        case (alu_op)
            2'b00: alu_control = 4'b0010;  // add
            2'b01: alu_control = 4'b0110;  // sub
            2'b10: begin
                case (funct3)
                    3'b000: alu_control = funct7_bit5 ? 4'b0110 : 4'b0010;  // subtract or add
                    3'b111: alu_control = 4'b0000;  // AND (and, andi)
                    3'b110: alu_control = 4'b0001;  // OR (or, ori)
                    default: alu_control = 4'b0010;  // add by default
                endcase
            end
            default: alu_control = 4'b0010;  // add by default
        endcase
    end
    
endmodule