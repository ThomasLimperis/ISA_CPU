// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 12,             // program counter width
   //changing A from 3 to 5 for 00000 opcode test
    A = 3;             		  // ALU command bit width 
  wire[8:0] target, 			  // jump //was D - 1
              prog_ctr;
  wire RegWrite = 'b1;
  wire [1:0] regDst;
  wire [0:0] lbuWrite, regOpt;
  wire li = 'b0,sb = 'b0,absjump_en ='b0,jump ='b0, jump_executed = 'b0;



   wire m ;

  //wire ALUSrc = 'b0;
  wire[7:0]   datA,datB,
  dat_in, datA_out, datB_out,		  // from RegFile
              muxB,			  rslt, dataOutFromMemory;               // alu output
  wire [8:0] muxBB;
       wire[6:0]       immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en;
       wire MemWrite = 'b1;
  wire ALUSrc,beqflag;
        	              // immediate switch
  wire[7:0] i,val;
  logic memWrite_wire;
  wire reg_file = 'b1;
  //alu cmd  changing was A - 1
  wire[7-1:0] alu_cmd;
  wire[8:0]   mach_code,jump_target;          // machine code
  //wire[8:0]   mach_code2;          // machine code
  wire[1:0] rd_addrA, rd_addrB, rd_addrC;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target (jump_target)          ,
		 .prog_ctr    ,.jump_executed      );

  

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);
		//.//mach_code2);
  //$display("Machine Code in Top Level = %b", mach_code);


assign alu_cmd  = mach_code[8:2];

// control decoder
  Control ctl1(.instr(alu_cmd), .control_beq_in(beq_alu),
  .Branch  (relj)  , 
               .MemWrite (memWrite_wire) ,
  .RegWrite   , 
  .li,.sb, .beqflag,   
   .ALUSrc,
  .MemtoReg(lbuWrite),
  .ALUOp(),
   .regDst,.control_beq_out(beq_alu2));
  


//for add instruction
/*addrC = addrA + addrB
wr_en = 1
write_address = addrC
what is datA,datB, regfile_dat

*/
assign rd_addrA = mach_code[1:0]; //2bit   //addr
  assign rd_addrB = mach_code[3:2];  //2bit 
  assign rd_addrC = mach_code[5:4];  //2bit
  assign immed = mach_code[6:0];
assign jump_target = mach_code[8:0];
 // assign alu_cmd  = mach_code[8:6];  //3bit
  //wr_en regwrite 1 bit

  logic [1:0] muxC;
	assign muxC = memWrite_wire? rd_addrC : rd_addrB; /////////////////
	
  reg_file #(.pw(4)) rf1(
              .dat_in(rslt),
    .lbu_take(dataOutFromMemory),
	      .regDst,	   // loads, most ops //regfile_dat doesnt exist
    	.regOpt,
              .clk   ,
    .wr_en   (RegWrite),.mem_en(lbuWrite), .mem_write(memWrite_wire),
    			.sb,
    .wr_addr (rd_addrC),	// first
              .rd_addrA,   // third
    .rd_addrB(muxC),	// second
                    // in place operation
    .datA_out(datA),	//third	
    .datB_out(datB),	//first
    .datC_out(datReg2)); 	//second

  //$display("rd_addrA from Machine Code = %b", rd_addrA);
	//$display("rd_addrB from Machine Code = %b", rd_addrB);


  //$display("Write address ------------------", rf1.core[rd_addrC]);
  //datB <= rf1.core[rd_addrC];

  
  assign muxB = ALUSrc? immed : datB;//datReg2; // datB;
  //assign muxBB = beqflag? jump_target: datB;
  assign absj = beqflag? 'b1 : 'b0;
  assign absj = jump_executed? 'b0 : 'b1;

  alu alu1(.alu_cmd(alu_cmd),
         .inA    (datA),
		 .inB    (muxB),
           .inBB(muxBB), .in_beq(beq_alu2), .jumped(jump_executed),
           //.inReg2 (datReg2),
           .inReg2 (datB),
		 .sc_i   (sc),
           .regOpt,
		 .li,.beqflag,   // output from sc register
		 .ALUSrc,
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
		 .pari ,
		.zero ,
		.target(target) ,
		.jump,.out_beq(beq_alu));  


  dat_mem dm1(.dat_in(datB) ,  // from reg_file	first
             .clk           ,
              .wr_en  (memWrite_wire),.sb, // stores
              .addr(datA),	//third
              .dat_out(dataOutFromMemory));
 // assign absj = beqflag? 'b0 : 'b0;
// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end
  assign done = prog_ctr == 12; //was 128
 
endmodule