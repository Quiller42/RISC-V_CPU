`timescale 1ns/1ps

module cpu_tb_sc;

    // ---------------------------------------------------------
    // Signal Declarations
    // ---------------------------------------------------------
    logic clk;
    logic rst_n;

    // ---------------------------------------------------------
    // Device Under Test (DUT) Instantiation
    // ---------------------------------------------------------
    cpu_top_sc uut (
        .clk   (clk),
        .rst_n (rst_n)
    );

    // ---------------------------------------------------------
    // Clock Generation (50MHz -> 20ns period)
    // ---------------------------------------------------------
    always begin
        #10 clk = ~clk;
    end

    // ---------------------------------------------------------
    // Simulation Control & Verification Log
    // ---------------------------------------------------------
    initial begin
        $dumpfile("cpu_waves.vcd"); // Creates the exact file GTKWave is looking for
        $dumpvars(0, cpu_tb_sc);       // Dumps every single signal in the design
        // 1. Initialize inputs cleanly at Time 0
        clk   = 0;
        rst_n = 0; // Assert reset actively

        // Continuous monitoring of execution state
        $monitor("Time=%0dns | PC=%0d | Instr=%h | ALU_Out=%0d | RegWriteEn=%b | WB_Data=%0d",
                 $time, uut.current_pc, uut.instruction, uut.alu_result, uut.reg_write_en, uut.write_data);

        // 2. Hold reset synchronously for exactly 2 clock cycles.
        // Because the hardware is synchronous, it samples rst_n on the posedge.
        @(posedge clk);
        @(posedge clk);
        
        // 3. De-assert reset synchronously right after the clock edge.
        // This ensures the hardware sees a clean rst_n = 1 well before the next rising edge.
        #1 rst_n = 1; 

        // 4. Let the program run for a fixed number of clock cycles
        // instead of guessing an absolute time delay.
        repeat (6) @(posedge clk);

        // 5. Final Register Verification
        $display("\n--- SIMULATION RESULTS ---");
        $display("Register x1 value: %0d (Expected: 5)",  uut.reg_file.reg_file[1]);
        $display("Register x2 value: %0d (Expected: 10)", uut.reg_file.reg_file[2]);
        $display("Register x3 value: %0d (Expected: 15)", uut.reg_file.reg_file[3]);
        $display("--------------------------\n");

        $finish;
    end

endmodule