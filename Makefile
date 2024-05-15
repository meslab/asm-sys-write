.SILENT:

DST  := DST
NDST := $(DST)/nasm
YDST := $(DST)/yasm
DDIST := $(DST)/dbg

ASMS  := $(wildcard *.asm)
NOBJS := $(patsubst %.asm,$(NDST)/%.o,$(ASMS))
YOBJS := $(patsubst %.asm,$(YDST)/%.o,$(ASMS))
DOBJS := $(patsubst %.asm,$(DDIST)/%.o,$(ASMS))

NAME := $(shell basename $(PWD))
BIN  := BIN
OUT  := OUT

prep:
	mkdir -p $(NDST)
	mkdir -p $(YDST)
	mkdir -p $(DDIST)
	mkdir -p $(OUT)
	mkdir -p $(BIN)
	
nasm: prep $(NOBJS)

yasm: prep $(YOBJS)

dasm: prep $(DOBJS)

$(NDST)/%.o: %.asm
	nasm -f elf64 $< -o$@

$(YDST)/%.o: %.asm
	yasm -f elf64 $< -o$@

$(DDIST)/%.o: %.asm
	nasm -f elf64 -g $< -o$@

nlink:
	ld -m elf_x86_64 -o $(BIN)/$(NAME) $(NDST)/*.o

ylink:
	ld -m elf_x86_64 -o $(BIN)/$(NAME) $(YDST)/*.o

dlink:
	ld -m elf_x86_64 -o $(BIN)/$(NAME) $(DDIST)/*.o

nbuild: nasm nlink run
build: nbuild

ybuild: yasm ylink run

debug: dasm dlink drun

clean:
	rm -f *.o *.txt $(NAME) $(DDIST)/* $(NDST)/* $(YDST)/* $(OUT)/* $(BIN)/*

format:
	asm-format *.asm

fmt: format	

install: build
	cp $(BIN)/$(NAME) ~/.local/BIN/$(NAME)

uninstall: clean
	rm -f ~/.local/BIN/$(NAME)

run: 
	$(BIN)/$(NAME)

drun:
	gdb $(BIN)/$(NAME)

.PHONY: prep clean run build nbuild ybuild debug dasm dlink drun install uninstall fmt format