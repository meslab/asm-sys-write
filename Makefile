.SILENT:

dst  := $(shell pwd)/dst
ndst := $(dst)/nasm
ydst := $(dst)/yasm
ddst := $(dst)/dbg

asms  := $(wildcard *.asm)
nobjs := $(patsubst %.asm,$(ndst)/%.o,$(asms))
yobjs := $(patsubst %.asm,$(ydst)/%.o,$(asms))
dobjs := $(patsubst %.asm,$(ddst)/%.o,$(asms))

name := $(shell basename $(shell pwd))
bin  := $(shell pwd)/bin
out  := $(shell pwd)/out

prep:
	mkdir -p $(ndst)
	mkdir -p $(ydst)
	mkdir -p $(ddst)
	mkdir -p $(out)
	mkdir -p $(bin)
	
nasm: prep $(nobjs)

yasm: prep $(yobjs)

dasm: prep $(dobjs)

$(ndst)/%.o: %.asm
	nasm -f elf64 $< -o$@

$(ydst)/%.o: %.asm
	yasm -f elf64 $< -o$@

$(ddst)/%.o: %.asm
	nasm -f elf64 -g $< -o$@

nlink:
	ld -m elf_x86_64 -o $(bin)/$(name) $(ndst)/*.o

ylink:
	ld -m elf_x86_64 -o $(bin)/$(name) $(ydst)/*.o

dlink:
	ld -m elf_x86_64 -o $(bin)/$(name) $(ddst)/*.o

nbuild: nasm nlink run
build: nbuild

ybuild: yasm ylink run

debug: dasm dlink drun

clean:
	rm -f *.o *.txt $(name) $(ddst)/* $(ndst)/* $(ydst)/* $(out)/* $(bin)/*

format:
	asm-format *.asm

fmt: format	

install: build
	cp $(bin)/$(name) ~/.local/bin/$(name)

uninstall: clean
	rm -f ~/.local/bin/$(name)

run: 
	$(bin)/$(name)

drun:
	gdb $(bin)/$(name)