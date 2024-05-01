Acknowledgement: We appreciate your attention to our documentation.


Technical Overview: Our machine code is comprised of three opcode types and four registers, of which 'mem' is one, and the remaining three pertain to registers in use.



Below is a breakdown of the opcodes and registers utilized in our assembler to convert assembly code into machine code:



* Opcodes: { 'add' : '000', 'beq' : '001', 'sb' : '010', 'lbu' : '011', 'xor' : '100', 'or' : '101', 'and' : '110', 'srl' : '111', 'li' : '00000' }

* Registers: { 'mem' : '00', '$t1' : '01', '$t2' : '10', '$t3' : '11' }



For opcode representation, we have allocated 3 bits. Notably, a 5-bit code '00000' has been introduced for the 'li' operation. This decision was taken because we have ensured that '00000' will not be employed in any other machine code context. Thus, '00000' remains exclusively reserved for the 'li' operation.

Of particular importance are the operations 'beq' and 'li', which present complexities distinct from the other operations outlined.





######################### Block on li and beq #########################





li and beq have 2 flags.





li: li and ALUSrc

beq: beq and beqflag





Upon encountering the "li" opcode, the system sets the value of "li" to 1 and stores the designated register intended for immediate loading. The Verilog processing exclusively focuses on this instruction across all files and refrains from executing other actions. Once the system progresses to the subsequent instruction and detects that "li" has been set to 1, it reconfigures "li" to 0 and "ALUSrc" to 1. With "ALUSrc" set to 1, the system interprets the current instruction as a 7-bit integer and transfers it to the register, which was identified during the previous instruction's phase.

For context, after an opcode is identified, the ensuing 2 bits represent a register.

000000100    << li $t1

000000100    << 7 bit integer of value 4 to be stores in $t1





000000100, we know we are doing an li on $t1, so we set li = 1 and do nothing else

000000100, because li = 1 we know the previous instruction was li, so set ALUSrc = 1 and store '0000100' as a 7 bit integer into $t1





beq works in a similar way with 2 flags.









######################### Block on li and beq #########################













######################### Our Test Cases Block  #########################





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

endmodule













and the output:

# Error detect for case 1: 0

#

# Error detect for case 2: 0

#

# Error detect for case 3: 0

#

# Error detect for case 4: 0

#

# Error detect for case 5: 0

#

# Error detect for case 6: 0

#

# Error detect for case 7: 0

#

# Error detect for case 8: 0

#

# Error detect for case 9: 0

#

# Error detect for case 11: 0





In collaboration with our Technical Assistant, Janav, we dedicated efforts on Saturday evening to align our work with the instructional framework and ensure the functionality of our code in Verilog. A review of the preceding testbench code and its corresponding output indicates that our test cases were successful. However, it is worth noting that our machine code did not meet the criteria set by the provided grading scheme.







######################### Our Test Cases Block  #########################









######################### Known issues  #########################





We have identified a key issue wherein our assembly code does not function as expected. Specifically, Programs 1 and 2 fail to generate the intended output. The absence of a functional assembly program inhibits our ability to implement the corresponding Verilog code effectively. Consequently, our primary objective is to rectify the assembly code discrepancies.

Additionally, there is a potential risk associated with the 'beq' and 'li' operations in the Verilog code. These operations share a similar structure, and executing machine code with consecutive lines of 'beq' followed by 'li' may lead to interpretative errors. Our subsequent course of action involves testing for this potential issue and enhancing the Verilog code to mitigate such risks.





######################### Known issues  #########################
