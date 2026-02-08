module pe #(
parameter int DW = 8,
parameter int PW = 32
)(
input logic clk,
input logic rst,
input logic [DW-1:0] a_in,
input logic [DW-1:0] b_in,
output logic [DW-1:0] a_out,
output logic [DW-1:0] b_out,
output logic [PW-1:0] psum
);

always_ff @(posedge clk) begin
    if (rst) begin
        a_out <= '0;
        b_out <= '0;
        psum  <= '0;
    end else begin
        a_out <= a_in;
        b_out <= b_in;
        psum  <= psum + (a_in * b_in);
    end
end

endmodule
