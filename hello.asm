SYS_EXIT equ 1
SYS_WRITE equ 4
STDOUT equ 1
NL db 10

section .text
	global _start

_start:
	mov	rdx, len_msg
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

	mov	ebx, 0
	mov	eax, SYS_EXIT
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

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg db '*'
	len_stars equ $ - stars
section .bss
	res resb 1
