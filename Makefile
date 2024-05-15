.SILENT:

DST  := dst
NDST := $(DST)/nasm
YDST := $(DST)/yasm
DDST := $(DST)/dbg

ASMS  := $(wildcard *.asm)
NOBJS := $(patsubst %.asm,$(NDST)/%.o,$(ASMS))
YOBJS := $(patsubst %.asm,$(YDST)/%.o,$(ASMS))
DOBJS := $(patsubst %.asm,$(DDST)/%.o,$(ASMS))

PROGRAM := $(shell basename $(PWD))
BIN  := bin
OUT  := out

prep:
	mkdir -p $(NDST)
	mkdir -p $(YDST)
	mkdir -p $(DDST)
	mkdir -p $(OUT)
	mkdir -p $(BIN)
	
nasm: prep $(NOBJS)

yasm: prep $(YOBJS)

dasm: prep $(DOBJS)

$(NDST)/%.o: %.asm
	nasm -f elf64 $< -o$@

$(YDST)/%.o: %.asm
	yasm -f elf64 $< -o$@

$(DDST)/%.o: %.asm
	nasm -f elf64 -g $< -o$@

nlink:
	ld -m elf_x86_64 -o $(BIN)/$(PROGRAM) $(NDST)/*.o

ylink:
	ld -m elf_x86_64 -o $(BIN)/$(PROGRAM) $(YDST)/*.o

dlink:
	ld -m elf_x86_64 -o $(BIN)/$(PROGRAM) $(DDST)/*.o

nbuild: nasm nlink 
build: nbuild

ybuild: yasm ylink

debug: dasm dlink drun

clean:
	rm -f *.o *.txt $(PROGRAM) $(DDST)/* $(NDST)/* $(YDST)/* $(OUT)/* $(BIN)/*

format:
	asm-format *.asm

fmt: format	

install: build
	@echo "Installing $(PROGRAM) to ~/.local/bin/$(PROGRAM)"
	cp $(BIN)/$(PROGRAM) ~/.local/bin/$(PROGRAM)

uninstall: clean
	echo "Uninstalling $(PROGRAM) from ~/.local/bin/$(PROGRAM)"
	rm -f ~/.local/bin/$(PROGRAM)

run: build
	$(BIN)/$(PROGRAM)

drun:
	gdb $(BIN)/$(PROGRAM)

nrun: nbuild
	$(BIN)/$(PROGRAM)

yrun: ybuild
	$(BIN)/$(PROGRAM)

nrun: nbuild nrun
yrun: ybuild yrun

.PHONY: prep clean run build nbuild ybuild debug dasm dlink drun install uninstall fmt format nasm yasm nlink ylink nrun yrun