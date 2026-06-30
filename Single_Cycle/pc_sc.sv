module program_counter_sc (
    input logic clk,
    input logic rst_n,
    input logic [31:0] pc_next, // next address to jump to
    output logic [31:0] pc_out // current address output
);

always_ff @(posedge clk) begin
    if (!rst_n) begin
        pc_out <= 32'h0000_0000; // reset to 0 on startup
    end else begin
        pc_out <= pc_next; // update to next address on clock edge
    end
end

endmodule