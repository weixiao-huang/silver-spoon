hello: hello.s
	@gcc -m32 -c hello.s -o hello.o
	@ld hello.o -m elf_i386 -o hello
	@./hello

clean:
	rm hello hello.o