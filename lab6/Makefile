clean: lab6a.x
	rm -f lab6a.o

lab6a.x: lab6a.o
	ld.lld lab6a.o -o lab6a.x
	
lab6a.o: lab6a.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab6a.s -g -c -o lab6a.o