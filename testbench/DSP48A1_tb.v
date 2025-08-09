module DSP48A1_tb;

  // Parameters
    parameter A0REG = 0;          
    parameter A1REG = 1;           
    parameter B0REG = 0;           
    parameter B1REG = 1;           
    parameter CREG = 1;            
    parameter DREG = 1;            
    parameter MREG = 1;            
    parameter PREG = 1;            
    parameter CARRYINREG = 1;      
    parameter CARRYOUTREG = 1;     
    parameter OPMODEREG = 1;       
    parameter CARRYINSEL = "OPMODE5"; 
    parameter B_INPUT = "DIRECT";  
    parameter RSTTYPE = "SYNC";   

  // Data Ports
    reg  [17:0] A;        
    reg  [17:0] B;        
    reg  [47:0] C;       
    reg  [17:0] D;        
    reg         CARRYIN;  
    
    wire [35:0] M;        
    wire [47:0] P;        
    wire        CARRYOUT; 
    wire        CARRYOUTF;
    
    reg         CLK;     
    reg  [7:0]  OPMODE;   
    reg         CEA;      
    reg         CEB;      
    reg         CEC;      
    reg         CECARRYIN;
    reg         CED;      
    reg         CEM;      
    reg         CEOPMODE; 
    reg         CEP;      
    
    reg         RSTA;    
    reg         RSTB;     
    reg         RSTC;     
    reg         RSTCARRYIN; 
    reg         RSTD;     
    reg         RSTM;     
    reg         RSTOPMODE;  
    reg         RSTP;     
    
    reg  [17:0] BCIN;       
    reg  [47:0] PCIN; 
    wire [17:0] BCOUT;      
    wire [47:0] PCOUT;

  // Clock generation
  initial begin
    CLK = 0;
    forever #1 CLK = ~CLK; // 2 time units clock period
  end
  // Instantiate the DSP48A1 module
    DSP48A1 #(
        .A0REG(A0REG),
        .A1REG(A1REG),
        .B0REG(B0REG),
        .B1REG(B1REG),
        .CREG(CREG),
        .DREG(DREG),
        .MREG(MREG),
        .PREG(PREG),
        .CARRYINREG(CARRYINREG),
        .CARRYOUTREG(CARRYOUTREG),
        .OPMODEREG(OPMODEREG),
        .CARRYINSEL(CARRYINSEL),
        .B_INPUT(B_INPUT),
        .RSTTYPE(RSTTYPE)
    ) uut (
        .A(A), 
        .B(B), 
        .C(C), 
        .D(D), 
        .CARRYIN(CARRYIN), 
        .M(M), 
        .P(P), 
        .CARRYOUT(CARRYOUT), 
        .CARRYOUTF(CARRYOUTF), 
        .CLK(CLK), 
        .OPMODE(OPMODE), 
        .CEA(CEA), 
        .CEB(CEB), 
        .CEC(CEC), 
        .CECARRYIN(CECARRYIN), 
        .CED(CED), 
        .CEM(CEM), 
        .CEOPMODE(CEOPMODE), 
        .CEP(CEP), 
        .RSTA(RSTA), 
        .RSTB(RSTB), 
        .RSTC(RSTC), 
        .RSTCARRYIN(RSTCARRYIN), 
        .RSTD(RSTD), 
        .RSTM(RSTM), 
        .RSTOPMODE(RSTOPMODE), 
        .RSTP(RSTP), 
        .BCIN(BCIN), 
        .PCIN(PCIN), 
        .BCOUT(BCOUT), 
        .PCOUT(PCOUT)
    );

  //Stimulus Generation (Initial Block) 
    initial begin
      // Initialize all inputs
      A = 0; B = 0; C = 0; D = 0; CARRYIN = 0; OPMODE = 0; BCIN = 0; PCIN = 0;
      CLK = 0; CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0; CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
      //Verify Reset Operation 
      RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1; RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;

      A = $random; B = $random; C = $random; D = $random; CARRYIN = $random;
      OPMODE = $random;
      CEA = $random; CEB = $random; CEC = $random;
      CECARRYIN = $random; CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random;
      @ (negedge CLK);
      if (M == 0 && P == 0 && CARRYOUT == 0 && CARRYOUTF == 0 && BCOUT == 0 && PCOUT ==0) begin
        $display("Reset successful, outputs are zero.");
      end else begin
        $display("Reset failed, outputs are not zero./n M: %h, P: %h, CARRYOUT: %b, CARRYOUTF: %b, BCOUT: %h, PCOUT: %h", M, P, CARRYOUT, CARRYOUTF, BCOUT, PCOUT);
        $stop;
      end

      // Deassert reset
      RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0; 
      CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;

      // Verify DSP Path 1
      OPMODE = 8'b11011101;
      A = 20; B = 10; C = 350; D = 25;
      BCIN= $random; PCIN = $random; CARRYIN = $random;
      repeat(4) @(negedge CLK);
      if (BCOUT == 18'hf && M == 36'h12c && P == 48'h32 && PCOUT == 48'h32 && CARRYOUT == 0 && CARRYOUTF == 0) begin
          $display("DSP Path 1 successful");
      end else begin
          $display("DSP Path 1 failed");
          $stop;
      end

      // Verify DSP Path 2
      OPMODE = 8'b00010000;
      A = 20; B = 10; C = 350; D = 25;
      BCIN= $random; PCIN = $random; CARRYIN = $random;
      repeat(3) @(negedge CLK);
      if (BCOUT == 18'h23 && M == 36'h2bc && P == 0 && PCOUT == 0 && CARRYOUT == 0 && CARRYOUTF == 0) begin
          $display("DSP Path 2 successful");
      end else begin
          $display("DSP Path 2 failed");
          $stop;
      end

      // Verify DSP Path 3
      OPMODE = 8'b00001010;
      A = 20; B = 10; C = 350; D = 25;
      BCIN= $random; PCIN = $random; CARRYIN = $random;
      repeat(3) @(negedge CLK);
      if (BCOUT == 18'ha && M == 36'hc8 && P == P && PCOUT == P && CARRYOUT == CARRYOUT && CARRYOUTF == CARRYOUTF) begin
          $display("DSP Path 3 successful");
      end else begin
          $display("DSP Path 3 failed");
          $stop;
      end

      // Verify DSP Path 4
      OPMODE = 8'b10100111;
      A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
      BCIN= $random; CARRYIN = $random;
      repeat(3) @(negedge CLK);
      if (BCOUT == 18'h6 && M == 36'h1e && P == 48'hfe6fffec0bb1 && PCOUT == 48'hfe6fffec0bb1 && CARRYOUT == 1 && CARRYOUTF == 1) begin
          $display("DSP Path 4 successful");
      end else begin
          $display("DSP Path 4 failed");
          $stop;
      end
    
      $stop;
    end

endmodule