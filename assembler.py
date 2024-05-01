def convert(inFile, outFile1, outFile2):
	assembly_file = open(inFile, 'r')
	machine_file = open(outFile1, 'w')
	lut_file = open(outFile2, 'w')
	assembly = list(assembly_file.read().split('\n'))

	#keep track of index and file line number
	lineNum = 0;
	labelsNum = 0;

	#dictionaries to ease conversion of opcodes/operands to binary
	opcodes = {'add' : '000', 'beq' : '001', 'sb' : '010', 'lbu' : '011',
	'xor' : '100', 'or' : '101', 'and' : '110', 'srl' : '111', 'li' : '00000'}
	registers = {'mem' : '00', '$t1' : '01', '$t2' : '10', '$t3' : '11'}
	#branches = {'
	#reads through file to convert instructions to machine code
	for line in assembly:
		print(line)
		output = ""
		instr = line.split();
		if not instr:
			continue
		#split to get instruction and different operands
		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			output += opcodes[instr[0]]
			del instr[0]
			if output == '00000':
				#li
				instr[0] = instr[0].replace(',', '');
				if instr[0] in registers:
					imm = registers[instr[0]]
					output += imm + '00'
				else:
					machine_file.write('There is an invalid register.')
					break
				machine_file.write(str(output) + '\n')
				if instr[1].isdigit():
					newoutput = bin(int(instr[1]))[2:].zfill(9)
					machine_file.write(str(newoutput) + '\n')
				else:
					machine_file.write('li is used incorrectly, the immediate is not an integer, please fix.')
					break
				continue
			elif output == '001':
				#beq
				instr[0] = instr[0].replace(',', '');
				instr[1] = instr[1].replace(',', '');
				if instr[0] in registers:
					imm = registers[instr[0]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				if instr[1] in registers:
					imm = registers[instr[1]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				output += '00'
				machine_file.write(str(output))
				machine_file.write('   ' + str(instr[2]) + '\n')
				continue
			elif output == '010' or output == '011':
				#sb and lbu
				#remove commas from register operand names and check
				instr[0] = instr[0].replace(',', '');
				nextreg = instr[1].split('(');
				nextreg[1] = nextreg[1].replace(')', '');
				if instr[0] in registers:
					imm = registers[instr[0]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				if nextreg[0] in registers:
					imm = registers[nextreg[0]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				if nextreg[1] in registers:
					imm = registers[nextreg[1]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
			else:
				#every other opcode (and, or, add, srl, xor)
				#remove commas from register operand names and check
				instr[0] = instr[0].replace(',', '');
				instr[1] = instr[1].replace(',', '');
				if instr[0] in registers:
					imm = registers[instr[0]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				if instr[1] in registers:
					imm = registers[instr[1]]
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
				if instr[2] in registers:
					imm = registers[instr[2]]
					output += imm
				elif instr[2].isdigit():
					imm = bin(int(instr[2]))[2:].zfill(2)
					output += imm
				else:
					machine_file.write('There is an invalid register.')
					break
			#write binary to machine code output file
			machine_file.write(str(output) + '\n')
		else:
			if ':' in line:
				machine_file.write(line + '\n')
			else:
				continue
	assembly_file.close()
	machine_file.close()

#convert("assembly.txt", "machine.txt", "lut.txt")
convert("input.txt", "output.txt", "sm_lut.txt")
#convert("cordic.txt", "c_machine.txt", "c_lut.txt")
#convert("division.txt", "d_machine.txt", "d_lut.txt")
