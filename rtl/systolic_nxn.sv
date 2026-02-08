module systolic_nxn #(
parameter int N  = 4,
parameter int DW = 8,
parameter int PW = 32
)(
input logic clk,
input logic rst,

// Inputs
input logic [DW-1:0] A_in [N],
input logic [DW-1:0] B_in [N],

// Output matrix
output logic [PW-1:0] C [N][N]
);

// Internal systolic connections
logic [DW-1:0] a_wire [N][N];
logic [DW-1:0] b_wire [N][N];

genvar i, j;
generate
    for (i = 0; i < N; i++) begin : ROW
        for (j = 0; j < N; j++) begin : COL

            pe pe_inst (
                .clk(clk),
                .rst(rst),

                // A flows from left to right
                .a_in( (j == 0) ? A_in[i] : a_wire[i][j-1] ),

                // B flows from top to bottom
                .b_in( (i == 0) ? B_in[j] : b_wire[i-1][j] ),

                .a_out(a_wire[i][j]),
                .b_out(b_wire[i][j]),
                .psum (C[i][j])
            );

        end
    end
endgenerate

endmodule
