module cpu_top (
    input logic clk,
    input logic rst_n    
);

    // Block linkers
    logic [31:0] current_pc;
    logic [31:0] pc_next;
    logic [31:0] instruction;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic        reg_write_en;
    logic [31:0] write_data;
    logic [31:0] imm_value;
    logic [3:0]  alu_control;
    logic [31:0] alu_result;
    logic [1:0]  alu_op;
    logic        alu_src;
    logic        zero;
    logic [31:0] pc_branch_target;
    logic [31:0] pc_plus_4;
    logic        branch;
    logic        jump;
    logic        mem_write;
    logic        mem_read;
    logic [1:0]  matrix_to_reg;
    logic [31:0] read_data;

    // Hardware routing equations
    assign pc_branch_target = current_pc + imm_value;
    assign pc_next = ((branch && zero) || jump) ? pc_branch_target : pc_plus_4;

    // Write-Back Multiplexer (Replaced the duplicated assign line)
    always_comb begin
        case (matrix_to_reg)
            2'b00:   write_data = alu_result;
            2'b01:   write_data = read_data;
            2'b10:   write_data = pc_plus_4;
            2'b11:   write_data = alu_result;
            default: write_data = alu_result;
        endcase
    end

    // Instantiate program register
    program_counter pc_reg (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc_out(current_pc)
    );

    // Instantiate pc adder
    pc_adder pc_adder (
        .pc_in(current_pc),
        .pc_plus_4(pc_plus_4)
    );

    // Instantiate instruction memory
    instruction_memory instr_mem (
        .pc(current_pc),
        .instruction(instruction)
    );

    // Instantiate register file
    register_file reg_file (
        .clk(clk),
        .rst_n(rst_n),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .reg_write_en(reg_write_en),
        .write_data(write_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Instantiate immediate value generator
    imm_gen imm_gen (
        .instruction(instruction),
        .imm_value(imm_value)
    );

    // Instantiate control unit (Connected empty ports)
    control_unit control_unit (
        .opcode(instruction[6:0]),
        .reg_write(reg_write_en),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .matrix_to_reg(matrix_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    // Instantiate alu control
    alu_control alu_ctrl (
        .funct3(instruction[14:12]),
        .funct7_bit5(instruction[30]),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    // Instantiate alu
    alu alu (
        .a(rs1_data),
        .rs2(rs2_data),
        .imm_value(imm_value),
        .alu_src(alu_src),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    // Instantiate data memory (Swapped write_data to rs2_data)
    data_mem data_mem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(read_data)
    );

endmodule