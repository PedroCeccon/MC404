clean: lab5.x
	rm -f lab5.o

lab5.x: lab5.o
	ld.lld lab5.o -o lab5.x
	
lab5.o: lab5.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab5.s -g -c -o lab5.o
