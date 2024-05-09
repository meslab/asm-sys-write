SYS_EXIT equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3
SYS_WRITE equ 4
STDOUT equ 1
_NOERRORS equ 0
_ERRORS equ 1
NL db 10

section .text
	global _start

_start:
	;call open_file
	mov	rdx, len_stars
	mov	rcx, stars
	mov	rbx, STDOUT
	mov	rax, SYS_WRITE
	int	0x80
	mov	rdx, 1
	mov	rcx, NL
	mov	rbx, STDOUT
	mov	rax, SYS_WRITE
	int	0x80
	mov rcx, 10

loop:
	call print_hello
	dec	rcx
	jnz	loop

	mov	rdx, len_stars
	mov	rcx, stars
	mov	rbx, 1
	mov	rax, 4
	int	0x80
	mov	rdx, 1
	mov	rcx, NL
	mov	rbx, STDOUT
	mov	rax, SYS_WRITE
	int	0x80

	;call close_file
	mov	rbx, _NOERRORS
	mov	rax, SYS_EXIT
	int	0x80

print_hello:
	push rcx
	mov	rdx, len_msg
	mov	rcx, msg
	mov	rbx, STDOUT
	mov	rax, SYS_WRITE
	int	0x80
	pop rcx
	ret

open_file:
	push rax
	push rdx
	push rdi
	push rsi
	mov	rax, SYS_OPEN
	mov rdi, filename
	mov rsi, 0x201
	mov rdx, 0644
	int	0x80
	pop rsi
	pop rdi
	pop rdx
	pop rax
	ret

close_file:	
	push rax
	mov	rax, SYS_CLOSE
	mov	rdi, rax
	int	0x80
	pop rax
	ret

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg  db '*', 0
	len_stars equ $ - stars - 2
	filename db 'file.txt', 0

section .bss
	res resb 1
