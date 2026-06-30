module register_file (
    input logic clk,
    input logic rst_n,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic reg_write_en,
    input logic [31:0] write_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] reg_file [31:0];
    int i;

    always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Use standard integers for the loop index boundaries
            for (i = 0; i < 32; i = i + 1) begin
                reg_file[i] <= 32'd0;
            end
        end else if (reg_write_en && (rd != 5'd0)) begin
            reg_file[rd] <= write_data;
        end
    end

    assign rs1_data = (rs1 == 5'd0) ? 32'd0 : reg_file[rs1];
    assign rs2_data = (rs2 == 5'd0) ? 32'd0 : reg_file[rs2];

endmodule