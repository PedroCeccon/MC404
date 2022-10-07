clean: executavel.x
	rm -f arquivo.o
	
executavel.x: arquivo.o
	ld.lld arquivo.o -o executavel.x
	
arquivo.o: arquivo.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arquivo.s -c -o arquivo.o
