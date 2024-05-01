module PC #(parameter D=12)(
  input reset,                 // synchronous reset
        clk,
        reljump_en,             // rel. jump enable
        absjump_en,             // abs. jump enable
  input       [8:0] target,  // how far/where to jump //was D -1
  output logic[8:0] prog_ctr,  //was D - 1,
  output logic jump_executed
);

  always_ff @(posedge clk) begin
    if (reset) begin
      prog_ctr <= '0;
	jump_executed = 'b0;

end    else if(absjump_en) begin

	//$display("success!!!!!!!!!!!!");
	 prog_ctr <= target;
	jump_executed = 'b1;
	end
    else
    	prog_ctr <= prog_ctr + 'b1;
      
    // Display the program counter value
    //$display("Program Counter = %d", prog_ctr);

  /*always_ff @(posedge clk)
    if(reset)
	  prog_ctr <= '0;
	else if(reljump_en)
	  prog_ctr <= prog_ctr + target;
    else if(absjump_en)
	  prog_ctr <= target;
	else
	  prog_ctr <= prog_ctr + 'b1;*/
  end

endmodule