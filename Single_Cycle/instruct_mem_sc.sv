module instruction_memory_sc (
    input logic [31:0] pc,
    output logic [31:0] instruction
);

    logic [31:0] rom_array [0:1023];

    // Load program from program.hex at simulation start
    initial begin
        $readmemh("program_sc.hex", rom_array);
    end

    // Assign instruction to the current PC value (pc[11:2] is equivalent to dividing by 4 to match the pc)
    assign instruction = rom_array[pc[11:2]];
    
endmodule