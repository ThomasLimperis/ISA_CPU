// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
  input[7:0] dat_in,		//first
  input      clk,
  input      wr_en,	sb,          // write enable
  input[7:0] addr,		      // address pointer	third
  output logic[7:0] dat_out);

  logic[7:0] core[256];       // 2-dim array  8 wide  256 deep

// reads are combinational; no enable or clock required
  assign dat_out = core[addr];	//third
  /*
  always @(addr) begin
    $write(" addr!! %b     ", addr);
    $write(" dat_out!! %b\n", dat_out);
end

always_comb begin
  dat_out = 'b00000000;
  dat_out = core[addr];
  end
 */
// writes are sequential (clocked) -- occur on stores or pushes 
  always_ff @(posedge clk) begin
    //$display("\nData!!!!!!!!!!!!!!!!!!!!!!!!!%d", core[0]);
    //$display("\nData read from, core[%0d] which is value of %d", addr, dat_out);
     //$display("addr %d dat_in %b", addr, dat_in);
    if(wr_en) begin
        core[addr] <= dat_in;
        $display("Data written to core[%0d] = %d", addr, dat_in);
    end
  end

endmodule