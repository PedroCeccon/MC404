clean: executavel.x
	rm -f lab10.o

executavel.x: lab10.o
	ld.lld lab10.o -o executavel.x

lab10.o: lab10.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab10.s -g -c -o lab10.o


