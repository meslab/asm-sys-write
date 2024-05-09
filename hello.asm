section .text
	global _start

_start:
	mov	edx, len_msg
	mov	ecx, stars
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov	edx, 1
	mov	ecx, nl
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov ecx, 10
loop:
	mov [res], ecx
	mov	edx, len_msg
	mov	ecx, msg
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov ecx, [res]
	dec	ecx
	jnz	loop

	mov	edx, len_stars
	mov	ecx, stars
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov	edx, 1
	mov	ecx, nl
	mov	ebx, 1
	mov	eax, 4
	int	0x80

	mov	ebx, 0
	mov	eax, 1
	int	0x80

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg db '*'
	len_stars equ $ - stars
	nl db 0xa
section .bss
	res resb 1
