`timescale 1ns/1ps

module tb_systolic_nxn;

parameter int N  = 3;
parameter int DW = 8;
parameter int PW = 32;

logic clk;
logic rst;

logic [DW-1:0] A_in [N];
logic [DW-1:0] B_in [N];
logic [PW-1:0] C    [N][N];

// DUT
systolic_nxn #(
    .N(N),
    .DW(DW),
    .PW(PW)
) dut (
    .clk(clk),
    .rst(rst),
    .A_in(A_in),
    .B_in(B_in),
    .C(C)
);

// Clock: 10ns period
always #5 clk = ~clk;

// Matrices
int A [N][N] = '{ '{1,2,3},
                  '{4,5,6},
                  '{7,8,9} };

int B [N][N] = '{ '{1,2,3},
                  '{4,5,6},
                  '{7,8,9} };

int t;

initial begin
    clk = 0;
    rst = 1;

    // Init inputs
    for (int i = 0; i < N; i++) begin
        A_in[i] = 0;
        B_in[i] = 0;
    end

    #20 rst = 0;

    // -------- SYSTOLIC INPUT SKEWING --------
    // Total cycles = 2*N - 1
    for (t = 0; t < 2*N-1; t++) begin

        // A skew: row i starts at cycle i
        for (int i = 0; i < N; i++) begin
            if ((t - i) >= 0 && (t - i) < N)
                A_in[i] = A[i][t - i];
            else
                A_in[i] = 0;
        end

        // B skew: column j starts at cycle j
        for (int j = 0; j < N; j++) begin
            if ((t - j) >= 0 && (t - j) < N)
                B_in[j] = B[t - j][j];
            else
                B_in[j] = 0;
        end

        #10;
    end

    // Flush
    for (int i = 0; i < N; i++) begin
        A_in[i] = 0;
        B_in[i] = 0;
    end

    #50;

    // -------- DISPLAY RESULTS --------
    $display("Result Matrix C:");
    for (int i = 0; i < N; i++) begin
        for (int j = 0; j < N; j++) begin
            $display("C[%0d][%0d] = %0d", i, j, C[i][j]);
        end
    end

    $finish;
end

endmodule
