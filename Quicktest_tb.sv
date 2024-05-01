module milestone2_quicktest_tb();

bit clk, reset;
wire done;
  logic error[20];

top_level dut(
  .clk,
  .reset,
  .done);


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
  // Case 1: 1 + 3, result into register 3
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b000110110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[0] = (9'b000000001 + 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 1: %0d\n",dut.rf1.core[3]);
  
  // Case 2: store register 3 into memory 1
  dut.rf1.core[3] = 9'b000000111;
  dut.ir1.core[0] = 9'b010110001;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[1] = 9'b000000111 != dut.dm1.core[1];
  #10 $display("\nCore 2: %0d\n",dut.dm1.core[1]);
  
  // Case 3: Read register from memory 3 into register 1
  dut.rf1.core[3] = 9'b000000011;
  dut.dm1.core[3] = 9'b000000001;
  dut.ir1.core[0] = 9'b011010011;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[2] = 9'b000000001 != dut.rf1.core[1];
  #10 $display("\nCore 3: %0d\n",dut.rf1.core[1]);
  
  // Case 4: 3 XOR 1
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b100110110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[3] = (9'b000000001 ^ 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 4: %0d\n",dut.rf1.core[3]);
  
  // Case 5: 3 OR 1
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b101110110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[4] = (9'b000000001 | 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 5: %0d\n",dut.rf1.core[3]);
  
  // Case 6: 3 AND 1
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b110110110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[5] = (9'b000000001 & 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 6: %0d\n",dut.rf1.core[3]);
  
  // Case 7: 3 >> 1
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b111110110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[6] = (9'b000000001 >> 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 7: %0d\n",dut.rf1.core[3]);
  
  
  // Case 8: Store 3 into register 1 and store it into memory 3 and read it into register 2
  dut.rf1.core[1] = 9'b000000011;
  dut.ir1.core[0] = 9'b010010001;
  dut.ir1.core[1] = 9'b011100001;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[7] = 9'b000000011 != dut.rf1.core[2];
  #10 $display("\nCore 8: %0d\n",dut.rf1.core[2]);
  
  
  // Case 9: Store 3 into register 1 and 4 into register 2, then register 3 = ((reg1 + reg2) & reg2) ^ reg1
  dut.rf1.core[1] = 9'b000000011;
  dut.rf1.core[2] = 9'b000000100;
  dut.ir1.core[0] = 9'b000110110;
  dut.ir1.core[1] = 9'b110111110;
  dut.ir1.core[2] = 9'b100111101;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[8] = (((9'b000000011 + 9'b000000100) & 9'b000000100) ^ 9'b000000011) != dut.rf1.core[3];
  #10 $display("\nCore 9: %0d\n",dut.rf1.core[3]);
  
  
  // Case 11: Beq jump
  dut.rf1.core[1] = 9'b000000011;
  dut.rf1.core[2] = 9'b000000001;
  dut.ir1.core[0] = 9'b000010110;
  dut.ir1.core[1] = 9'b001010111;
  dut.ir1.core[2] = 9'b000000101;
  dut.ir1.core[3] = 9'b000010101;
  dut.ir1.core[4] = 9'b111111111;
  dut.ir1.core[5] = 9'b000010110;
  dut.ir1.core[6] = 9'b001010111;
  dut.ir1.core[7] = 9'b000001001;
  dut.ir1.core[8] = 9'b000010110;
  dut.ir1.core[9] = 9'b000010110;
  
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[10] = 9'b000000111 != dut.rf1.core[1];
  #10 $display("\nCore 11: %0d\n",dut.rf1.core[1]);
  #10 $display("\nCore 11 - B: %0d\n",dut.rf1.core[2]);
  
  
  #10 $display("\nError detect for case 1: ",error[0]);
   $display("\nError detect for case 2: ",error[1]);
   $display("\nError detect for case 3: ",error[2]);
   $display("\nError detect for case 4: ",error[3]);
   $display("\nError detect for case 5: ",error[4]);
   $display("\nError detect for case 6: ",error[5]);
   $display("\nError detect for case 7: ",error[6]);
   $display("\nError detect for case 8: ",error[7]);
   $display("\nError detect for case 9: ",error[8]);
  $display("\nError detect for case 10: ",error[9]);
  $display("\nError detect for case 11: ",error[10]);
  $stop;
end

  
  
/*
initial begin
  // case 1: 1+3, result into register 
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[0] = 9'b000110110;
  dut.dm1.core[100] = dut.rf1.core[3] // expect 4
  
  // case 2: store register 3 into memory 1
  dut.rf1.core[3] = 9'1111111111;
  dut.ir1.core[1] = 9'b010110001;
  dut.dm1.core[101] = dut.dm1.core[1]
  
  // case 3: Read register from memory 3 into register 1
  dut.dm1.core[3] = 9'000000001;
  dut.ir1.core[2] = 9'b011010011;
  dut.dm1.core[102] = dut.rf1.core[1];
  
  // case 4: 3 XOR 1
  dut.rf1.core[1] = 9'b000000001;
  dut.rf1.core[2] = 9'b000000011;
  dut.ir1.core[3] = 9'b100110110;
  dut.dm1.core[100] = dut.rf1.core[3] // expect 4
  
  
  //dut.dm1.core[3] =	8'b11000011;
  //dut.dm1.core[4] = 8'b01010101;
  reset = 0;
  #10 reset = 1;
  #10 reset = 0;
  //#10 //$display("\nReset signal in Testbench = %b", reset);
  #10 wait(done);
  #10 error[0] = (8'b11110000 + 8'b11001100) != dut.dm1.core[2];
  //#10 error[1] = (8'b11000011 & 8'b01010101) != dut.dm1.core[5];
  #10 $display("\nCore 2: %0d\n",dut.dm1.core[1]);
  #10 $display("\nError detect: ",error[0]);
  //$display("Instruction = %d", dut.dm1.core[0]);
  $stop;

end  
*/

endmodule