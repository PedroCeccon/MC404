clean: gps.x
	rm -f gps.o

gps.x: gps.o
	ld.lld gps.o -o gps.x
	
gps.o: gps.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax gps.s -g -c -o gps.o