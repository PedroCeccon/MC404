clean: executavel.x
	rm -f teste.o
	rm -f lib.o

executavel.x: teste.o lib.o
	ld.lld lib.o teste.o -o executavel.x

lib.o: lib.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lib.s -g -c -o lib.o

teste.x: teste.o
	ld.lld teste.o -o teste.x
teste.o: teste.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax teste.s -g -c -o teste.o

