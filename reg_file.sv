// cache memory/register file
// default address pointer width = 4, for 16 registers
// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
  input [7:0] dat_in,
  input [7:0] lbu_take,
  input [1:0] regDst,
  input regOpt,mem_write,
  input      clk,
  input      wr_en,sb , mem_en ,      // write enable
  input[1:0] wr_addr,		//t01  // write address pointer //first
  input [1:0]            rd_addrA,	//t00	  // read address pointers	//third
  input [1:0]		  rd_addrB,//tt01	//second

  output logic[7:0] datA_out, // read data	third
  datB_out, datC_out);	//first

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
 // if (mem_write) begin
    //$write(" wr_addr %b", wr_addr);
  //  assign datB_out =  core[wr_addr];	// first
  //end //else begin
  //  assign datC_out =  core[rd_addrB];	// first
  //end  assign muxB = ALUSrc? immed : datReg2; // datB;
  assign datA_out = core[rd_addrA];	// third
  assign datB_out = core[rd_addrB];	// first
  //assign datC_out =  core[rd_addrB];	// second

always @(wr_addr) begin
  //assign datB_out =  core[wr_addr];
    $write(" wr_addr %b", wr_addr);
 	$write(" dat_in %b", dat_in);
  $write(" wr_en %b", wr_en);
  $display(" (regDst)%b\n",regDst[1:0]);
  
  
   // $write(" addrA %b", datA_out);
  //  $write(" addrB %b", datB_out);
end

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if(wr_en)				   // anything but stores or no ops
	begin
      if (regOpt) begin
      	core[wr_addr] <= dat_in;
        $display(" Overwriting the false address... dat_in  %d   T (wr_addr)%b\n", dat_in,wr_addr[1:0]);
      end else if (regDst[1:0] == 'b00) begin
      core[wr_addr] <= dat_in; 
        $display(" dat_in  %d   T (wr_addr)%b\n", dat_in,wr_addr[1:0]);
      end else begin
      core[regDst] <= dat_in; 
        $display(" dat_in  %b   T (regDst)%0d\n", dat_in,regDst[1:0]);
      //wr_addr = regDst;
      end
      
  	end
    if (mem_en) begin
      //$display(" mem_en %b\n", mem_en);
      core[wr_addr] <= lbu_take;
      $display(" Writing LBU core[%b] with %b\n", wr_addr,lbu_take);
    end
    
  end


endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/