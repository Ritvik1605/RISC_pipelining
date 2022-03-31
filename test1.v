`timescale 1ns / 1ps
module test;

	// Inputs
	reg clk1;
	reg clk2;
	integer k;

	// Instantiate the Unit Under Test (UUT)
	MIPS_32 mips1 (clk1 , clk2);

	initial begin
		// Initialize Inputs
		clk1 = 0;
		clk2 = 0;

		repeat(50)    //Generating Two Phase Clock...
			begin
			 #5 clk1 = 1;
			 #5 clk1 = 0;
			 #5 clk2 = 1;
			 #5 clk2 = 0;
			end 
		end
		
		initial 
			begin
				for (k=0; k<31; k=k+1)
					mips1.Reg[k] = k;
					
				mips1.Mem[0] = 32'h28010078;// ADDI R1,R0,120
				mips1.Mem[1] = 32'h0C631800;// OR   R3,R3,R3--DUMMY INSTRUC
				mips1.Mem[2] = 32'h20220000;// LW   R2,0(R1)
				mips1.Mem[3] = 32'h0c631800;// OR R3,R3,R3--dummy instruc.
				mips1.Mem[4] = 32'h2842002d;// ADDI R2,R2,45
				mips1.Mem[5] = 32'h0c631800;// OR  R3,R3,R3--DUMMY INSRTU.
				mips1.Mem[6] = 32'h24220001;// SW R2,1(R1)
				mips1.Mem[7] = 32'hfc000000;// HLT
				
				mips1.Mem[120]=60;
				
				mips1.HALTED = 0;
				mips1.PC = 0;
				mips1.TAKEN_BRANCH = 0;
				
			#500;
			
			
				$display("Mem[120]: %4d \nMem[121: %4d",
							mips1.Mem[120], mips1.Mem[121]);
			end
			
			initial
				begin
					$dumpfile("mips.vcd");
					//$dumpvars(0,test);
					$dumpvars(0,mips1);
					#600 $finish;
					
			end
endmodule


