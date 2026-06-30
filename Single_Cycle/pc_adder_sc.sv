module pc_adder_sc (
    input logic [31:0] pc_in,
    output logic [31:0] pc_plus_4
);

    assign pc_plus_4 = pc_in + 4; // Current PC plus 4
    
endmodule