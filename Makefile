name := $(shell basename $(shell pwd))

nasm:
	nasm -f elf64 *.asm

yasm:
	yasm -f elf64 *.asm

link:
	ld -m elf_x86_64 -s -o $(name) *.o

build: nasm link
	./$(name)

ybuild: clean yasm link
	./$(name)

clean:
	rm -f *.o *.txt $(name)

format:
	asm-format *.asm

fmt: format	

install:
	cp $(name) ~/.local/bin/$(name)

uninstall:
	rm -f ~/.local/bin/$(name)