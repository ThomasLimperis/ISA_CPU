// combinational -- no clock
// sample -- change as desired
// combinational -- no clock
// combinational -- no clock
// combinational -- no clock
// sample -- change as desired
// combinational -- no clock
// sample -- change as desired
// combinational -- no clock
// combinational -- no clock
// combinational -- no clock
// sample -- change as desired
module alu(
  input[6:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB, inReg2,	 // 8-bit wide data path  // inB is actually C over here the first register
  input [8:0]inBB,
  input [0:0] in_beq,
  input [0:0] jumped,
  input      sc_i, li,beqflag,  ALUSrc ,    // shift_carry in //if ALUSrc we know we are doing li
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero,     // NOR (output)
  output logic [0:0]regOpt,
  output logic [8:0]target,
  output logic jump,
  output logic [0:0] out_beq
);

always_comb begin
  //out_beq='b0;
  rslt = 'b0;
  sc_o = 'b0;
  regOpt = 'b0;
  zero = !rslt;
  pari = ^rslt;
//$display("in_beq %d   out_beq  %d ", in_beq,out_beq);    
if (in_beq == 'b1) begin
	// this line doesnt execute but is needed to check if inA == inB
	//do a check if the registers are equal, if not set beq to 0
	//out_beq ='b0;
	//$display("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
	//$display("InA= %d   inB=%d   inReg2 = %d ", inA, inB, inReg2);
	$display("%d ?= %d ",inB,inReg2);
	if (inB != inReg2) begin
		//in_beq = 'b0;
		out_beq = 'b0;
		//$display("%d != %d (no jump do nothing)",inB,inReg2);
	end 
	if (inB == inReg2) begin
		out_beq = 'b1;
		//$display("out_beq is now 1");
	end
		
end else begin
  if (beqflag =='b1 && jumped == 'b0) begin
	$display("jumping to target %d ",inBB); //this happens in top level with the assign statement
  
  $display("In ALU: ALUop %d ",alu_cmd[6:4]); 
	//absjump_en = 'b1;
	//absjump = 'b1;
end else begin
if (ALUSrc == 'b1) begin
	rslt = inB;
end else begin
  //$display("hahahahahhahahah ",alu_cmd[6:4]); 
 if (li =='b0 ) begin
  case(alu_cmd[6:4])
	'b000:
		if (alu_cmd[3:2] == 'b00) begin
			rslt = inB;
          $write("li trigger!!!!", inB, inB);
		end
		else begin
			rslt = inA + inReg2;
    		regOpt = 'b1;
          $display("In Add: ALUop %d ",alu_cmd[6:4]); 
          $write(" the result is   %b or %d", rslt, rslt, inA, inReg2); // inA is the second, inReg2 is the third
          //$write("happend!!!!!!!!!!!!!!!!!!!!!!!!", inA, inReg2);
        end
    3'b010: begin// sb
      rslt = inA;	
    end
    3'b011: begin// lbu
      rslt = inA;   
    end
    3'b100: begin// bitwise XOR
      rslt = inA ^ inReg2;
    regOpt = 'b1;
      end
    3'b101: begin// bitwise OR
      rslt = inA | inReg2;
    regOpt = 'b1;
       end
    3'b110: begin // bitwise AND
      rslt = inA & inReg2;
    regOpt = 'b1;
    end
    3'b111: begin // srl (shift right logical)
      rslt = inReg2 >> inA;
    regOpt = 'b1;
    end
    default:
      rslt = 8'b00000000;

  endcase
end
end
end
end
//$write (" result = %d", rslt);
//$write(" inA = %b", inA);
//$write(" inB = %b\n", inB);

 

end

  
endmodule
/*case(alu_cmd)
    3'b000: // add 2 8-bit
      {sc_o,rslt} = inA + inB + sc_i;
    3'b001: // beq (branch if equal)
      rslt = (inA == inB) ? 8'b0000_0001 : 8'b0000_0000;
    3'b010: // sb (store byte) - pass through A for simplicity
      rslt = inA;	//TODO
    3'b011: // lbu (load byte unsigned) - pass through A ensuring it's treated as unsigned
      rslt = inA;   //TODO
    3'b100: // bitwise XOR
      rslt = inA ^ inB;
    3'b101: // bitwise OR
      rslt = inA | inB;
    3'b110: // bitwise AND
      rslt = inA & inB;
    3'b111: // srl (shift right logical)
      {rslt,sc_o} = {sc_i,inA};
    default:
      rslt = 8'b0000_0000;
  endcase*/