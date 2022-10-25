clean: lib.x
	rm -f lib.o

lib.x: lib.o
	ld.lld lib.o -o lib.x
	
lib.o: lib.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lib.s -g -c -o lib.o