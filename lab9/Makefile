clean: executavel.x
	rm -f lab9.o
	rm -f lab9.s
	rm -f lib.o

executavel.x: lib.o lab9.o 
	ld.lld lab9.o lib.o -o executavel.x

lib.o: lib.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lib.s -g -c -o lib.o

lab9.o: lab9.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab9.s -g -c -o lab9.o

lab9.s: lab9.c
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab9.c -g -S -o lab9.s