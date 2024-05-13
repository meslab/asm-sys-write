nasm:
	nasm -f elf64 hello.asm

yasm:
	yasm -f elf64 hello.asm

link:
	ld -m elf_x86_64 -s -o hello hello.o

build: nasm link
	./hello

ybuild: clean yasm link
	./hello

clean:
	rm -f hello hello.o file.txt

format:
	asm-format hello.asm