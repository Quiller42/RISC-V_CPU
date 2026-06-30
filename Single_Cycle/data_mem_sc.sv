module data_mem_sc (
    input logic clk,
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic mem_write,
    input logic mem_read,
    output logic [31:0] read_data
);

    logic [31:0] mem [0:63];

    always_ff @(posedge clk) begin
        if (mem_write) begin
            mem[address[7:2]] <= write_data;
        end
    end

    assign read_data = (mem_read) ? mem[address[7:2]] : 32'b0;

endmodule