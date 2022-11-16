clean: executavel.x
	rm -f lab8.o

executavel.x: lab8.o
	ld.lld lab8.o -o executavel.x

lab8.o: lab8.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab8.s -g -c -o lab8.o


