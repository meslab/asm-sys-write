section .text
	global _start

_start:
	mov	rdx, len_msg
	mov	rcx, stars
	mov	rbx, 1
	mov	rax, 4
	int	0x80
	mov	rdx, 1
	mov	rcx, nl
	mov	rbx, 1
	mov	rax, 4
	int	0x80
	mov rcx, 10
loop:
	push rcx
	call print_hello
	pop rcx
	dec	rcx
	jnz	loop

	mov	rdx, len_stars
	mov	rcx, stars
	mov	rbx, 1
	mov	rax, 4
	int	0x80
	mov	rdx, 1
	mov	rcx, nl
	mov	rbx, 1
	mov	rax, 4
	int	0x80

	mov	ebx, 0
	mov	eax, 1
	int	0x80

print_hello:
	mov	rdx, len_msg
	mov	rcx, msg
	mov	rbx, 1
	mov	rax, 4
	int	0x80
	ret

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg db '*'
	len_stars equ $ - stars
	nl db 0xa
section .bss
	res resb 1
