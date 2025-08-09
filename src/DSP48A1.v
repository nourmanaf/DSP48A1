module DSP48A1 #(
    parameter A0REG = 0,           
    parameter A1REG = 1,           
    parameter B0REG = 0,           
    parameter B1REG = 1,           
    parameter CREG = 1,            
    parameter DREG = 1,            
    parameter MREG = 1,            
    parameter PREG = 1,            
    parameter CARRYINREG = 1,      
    parameter CARRYOUTREG = 1,     
    parameter OPMODEREG = 1,       
    parameter CARRYINSEL = "OPMODE5", 
    parameter B_INPUT = "DIRECT" ,
    parameter RSTTYPE = "SYNC" 
)(
    input  [17:0] A,        
    input  [17:0] B,        
    input  [47:0] C,       
    input  [17:0] D,        
    input         CARRYIN,  
    output [35:0] M,        
    output [47:0] P,        
    output        CARRYOUT, 
    output        CARRYOUTF,
    input         CLK,      
    input  [7:0]  OPMODE,   
    input         CEA,      
    input         CEB,      
    input         CEC,      
    input         CECARRYIN,
    input         CED,      
    input         CEM,      
    input         CEOPMODE, 
    input         CEP,      
    input         RSTA,    
    input         RSTB,     
    input         RSTC,     
    input         RSTCARRYIN,
    input         RSTD,     
    input         RSTM,     
    input         RSTOPMODE,
    input         RSTP,
    input  [17:0] BCIN,
    input  [47:0] PCIN,
    output [17:0] BCOUT,
    output [47:0] PCOUT
);

    // Internal Wires
    wire [17:0] A0_out, A1_out, A0_reg_out, A1_reg_out;
    wire [17:0] B0_out, B1_out, B_mux_out, B0_reg_out, B1_reg_out;
    wire [47:0] C_out, C_reg_out;
    wire [17:0] D_out, D_reg_out;
    wire [7:0]  OPMODE_out, OPMODE_reg_out;
    wire CARRYIN_out, CARRYIN_reg_out, CARRYIN_mux_out;
    wire CARRYOUT_out, CARRYOUT_reg_out;
    wire [35:0] M_out, M_reg_out, Multiplier_out;
    wire [17:0] pre_adder_out, OPMODE4_MUX_out;
    wire [47:0] post_adder_out, Z_mux_out, X_mux_out, P_reg_out, Concatenate_wires;

    // ===== A Path =====
    REG #(.WIDTH(18), .RSTTYPE(RSTTYPE)) A0_reg (
        .clk(CLK), .CE(CEA), .rst(RSTA), .data_in(A), .data_out(A0_reg_out)
    );
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) A0_mux (
        .IN0(A), .IN1(A0_reg_out), .IN2(18'b0), .IN3(18'b0), .sel(A0REG), .data_out(A0_out)
    );
    REG #(.WIDTH(18), .RSTTYPE(RSTTYPE)) A1_reg (
        .clk(CLK), .CE(CEA), .rst(RSTA), .data_in(A0_out), .data_out(A1_reg_out)
    );
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) A1_mux (
        .IN0(A0_out), .IN1(A1_reg_out), .IN2(18'b0), .IN3(18'b0), .sel(A1REG), .data_out(A1_out)
    );

    // ===== B Path =====
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) B_mux (
        .IN0(B), .IN1(BCIN), .IN2(18'b0), .IN3(18'b0), .sel(B_INPUT == "CASCADE"), .data_out(B_mux_out)
    );
    REG #(.WIDTH(18), .RSTTYPE(RSTTYPE)) B0_reg (
        .clk(CLK), .CE(CEB), .rst(RSTB), .data_in(B_mux_out), .data_out(B0_reg_out)
    );
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) B0_mux (
        .IN0(B_mux_out), .IN1(B0_reg_out), .IN2(18'b0), .IN3(18'b0), .sel(B0REG), .data_out(B0_out)
    );
    REG #(.WIDTH(18), .RSTTYPE(RSTTYPE)) B1_reg (
        .clk(CLK), .CE(CEB), .rst(RSTB), .data_in(OPMODE4_MUX_out), .data_out(B1_reg_out)
    );
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) B1_mux (
        .IN0(OPMODE4_MUX_out), .IN1(B1_reg_out), .IN2(18'b0), .IN3(18'b0), .sel(B1REG), .data_out(B1_out)
    );
    assign BCOUT = B1_out;

    // ===== C Path =====
    REG #(.WIDTH(48), .RSTTYPE(RSTTYPE)) C_reg (
        .clk(CLK), .CE(CEC), .rst(RSTC), .data_in(C), .data_out(C_reg_out)
    );
    MUX #(.WIDTH(48), .NUM_INPUTS(2)) C_mux (
        .IN0(C), .IN1(C_reg_out), .IN2(48'b0), .IN3(48'b0), .sel(CREG), .data_out(C_out)
    );

    // ===== D Path =====
    REG #(.WIDTH(18), .RSTTYPE(RSTTYPE)) D_reg (
        .clk(CLK), .CE(CED), .rst(RSTD), .data_in(D), .data_out(D_reg_out)
    );
    MUX #(.WIDTH(18), .NUM_INPUTS(2)) D_mux (
        .IN0(D), .IN1(D_reg_out), .IN2(18'b0), .IN3(18'b0), .sel(DREG), .data_out(D_out)
    );

    // ===== OPMODE =====
    REG #(.WIDTH(8), .RSTTYPE(RSTTYPE)) OPMODE_reg (
        .clk(CLK), .CE(CEOPMODE), .rst(RSTOPMODE), .data_in(OPMODE), .data_out(OPMODE_reg_out)
    );
    MUX #(.WIDTH(8), .NUM_INPUTS(2)) OPMODE_mux (
        .IN0(OPMODE), .IN1(OPMODE_reg_out), .IN2(8'b0), .IN3(8'b0), .sel(OPMODEREG), .data_out(OPMODE_out)
    );

    // ===== Carry-in =====
    MUX #(.WIDTH(1), .NUM_INPUTS(2)) CARRYIN_mux (
        .IN0(CARRYIN), .IN1(OPMODE_out[5]), .IN2(1'b0), .IN3(1'b0), .sel(CARRYINSEL == "OPMODE5"), .data_out(CARRYIN_mux_out)
    );
    REG #(.WIDTH(1), .RSTTYPE(RSTTYPE)) CARRYIN_reg (
        .clk(CLK), .CE(CECARRYIN), .rst(RSTCARRYIN), .data_in(CARRYIN_mux_out), .data_out(CARRYIN_reg_out)
    );
    MUX #(.WIDTH(1), .NUM_INPUTS(2)) CARRYIN_final_mux (
        .IN0(CARRYIN_mux_out), .IN1(CARRYIN_reg_out), .IN2(1'b0), .IN3(1'b0), .sel(CARRYINREG), .data_out(CARRYIN_out)
    );

    // ===== Pre-adder/subtractor =====
    assign pre_adder_out = (OPMODE_out[6]) ? (D_out - B0_out) : (D_out + B0_out);

    // ===== OPMODE4 mux =====
    assign OPMODE4_MUX_out = (OPMODE_out[4]) ? pre_adder_out : B0_out;

    // ===== Multiplier =====
    assign Multiplier_out = A1_out * B1_out;
    REG #(.WIDTH(36), .RSTTYPE(RSTTYPE)) M_reg (
        .clk(CLK), .CE(CEM), .rst(RSTM), .data_in(Multiplier_out), .data_out(M_reg_out)
    );
    MUX #(.WIDTH(36), .NUM_INPUTS(2)) M_mux (
        .IN0(Multiplier_out), .IN1(M_reg_out), .IN2(36'b0), .IN3(36'b0), .sel(MREG), .data_out(M_out)
    );
    assign M = M_out;

    // ===== Concatenate wires =====
    assign Concatenate_wires = {D_out[11:0], A1_out, B1_out};

    // ===== X mux =====
    MUX #(.WIDTH(48), .NUM_INPUTS(4)) X_mux (
        .IN0(48'b0), 
        .IN1({12'b0, M_out}), 
        .IN2(P), 
        .IN3(Concatenate_wires),
        .sel(OPMODE_out[1:0]), .data_out(X_mux_out)
    );

    // ===== Z mux =====
    MUX #(.WIDTH(48), .NUM_INPUTS(4)) Z_mux (
        .IN0(48'b0), 
        .IN1(PCIN),
        .IN2(P),
        .IN3(C_out),
        .sel(OPMODE_out[3:2]), .data_out(Z_mux_out)
    );

    // ===== Post-adder/subtractor =====
    assign {CARRYOUT_out, post_adder_out} = (OPMODE_out[7]) ?
        (Z_mux_out - (X_mux_out + CARRYIN_out)) :
        (Z_mux_out + X_mux_out + CARRYIN_out);

    // ===== Carryout =====
    REG #(.WIDTH(1), .RSTTYPE(RSTTYPE)) CARRYOUT_reg (
        .clk(CLK), .CE(CECARRYIN), .rst(RSTCARRYIN), .data_in(CARRYOUT_out), .data_out(CARRYOUT_reg_out)
    );
    MUX #(.WIDTH(1), .NUM_INPUTS(2)) CARRYOUT_mux (
        .IN0(CARRYOUT_out), .IN1(CARRYOUT_reg_out), .IN2(1'b0), .IN3(1'b0), .sel(CARRYOUTREG), .data_out(CARRYOUT)
    );
    assign CARRYOUTF = CARRYOUT;

    // ===== P output =====
    REG #(.WIDTH(48), .RSTTYPE(RSTTYPE)) P_reg (
        .clk(CLK), .CE(CEP), .rst(RSTP), .data_in(post_adder_out), .data_out(P_reg_out)
    );
    MUX #(.WIDTH(48), .NUM_INPUTS(2)) P_mux (
        .IN0(post_adder_out), .IN1(P_reg_out), .IN2(48'b0), .IN3(48'b0), .sel(PREG), .data_out(P)
    );
    assign PCOUT = P;

endmodule
