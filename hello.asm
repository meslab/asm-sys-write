SYS_EXIT equ 60
SYS_CLOSE equ 3
SYS_OPEN equ 2
SYS_WRITE equ 1
STDOUT equ 1
_NOERRORS equ 0
_ERRORS equ 1
NL db 10

%macro pushall 0
    push rax
    push rcx
    push rdx
    push rbx
    push rbp
    push rsi
    push rdi
%endmacro

%macro popall 0
    pop rdi
    pop rsi
    pop rbp
    pop rbx
    pop rdx
    pop rcx
    pop rax
%endmacro
section .text
	global _start

_start:
	call open_file

	call print_stars

	call random_count
	;mov rcx, 3

_loop:
	call print_hello
	call print_to_file
	dec	rcx
	jnz	_loop

	call print_stars

	call close_file
	mov	rdi, _NOERRORS
	mov	rax, SYS_EXIT
	syscall

print_hello:
	pushall
	mov	rdx, len_msg
	mov	rsi, msg
	mov	rdi, STDOUT
	mov	rax, SYS_WRITE
	syscall
	popall
	ret

print_to_file:
	;mov [count], rcx
	pushall
	mov rdx, 3
	mov rsi, count
	mov rdi, [fd]
	mov rax, SYS_WRITE
	syscall
	mov	rdx, len_msg
	mov	rsi, msg
	mov rdi, [fd]
	mov	rax, SYS_WRITE
	syscall
	popall
	ret

open_file:
	pushall
	mov	rax, SYS_OPEN
	mov rdi, filename
	mov rsi, 1102o
	mov rdx, 0644o
	syscall
	cmp rax, -1
    je file_error

	mov	[fd], rax
	
	popall
	ret

close_file:	
	pushall
	mov	rax, SYS_CLOSE
	mov	rdi, [fd]
	syscall
	popall
	ret

print_stars:
	pushall
	mov	rdx, len_stars
	mov	rsi, stars
	mov	rdi, STDOUT
	mov	rax, SYS_WRITE
	syscall
	mov	rdx, 1
	mov	rsi, NL
	mov	rdi, STDOUT
	mov	rax, SYS_WRITE
	syscall
	popall
	ret

random_count:
	rdrand rax
	mov rcx , rax
	shr rdx, 64
	mov rcx, 10
	idiv rcx
	add rdx, 1
	mov rcx, rdx
	ret	

file_error:
    mov rdi, _ERRORS
    mov rax, SYS_EXIT
    syscall

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg  db '*', 0
	len_stars equ $ - stars - 2
	filename db 'file.txt', 0
	count db 1, 0

section .bss
	fd resb 1
