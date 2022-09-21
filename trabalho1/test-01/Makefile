test-01.x: test-01.o
	ld.lld test-01.o -o test-01.x
	
test-01.o: test-01.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax test-01.s -c -o test-01.o