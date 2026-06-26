module cpu_top (
    input logic clk,
    input logic rst_n,    
);

    // Block linkers
    logic [31:0] current_pc;
    logic [31:0] pc_next;
    logic [31:0] instruction;

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
        .pc_plus_4(pc_next)
    );

    // Instantiate instruction memory
    instruction_memory instr_mem (
        .pc(current_pc),
        .instruction(instruction)
    );

endmodule