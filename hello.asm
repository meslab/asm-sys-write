section .text
	global _start

_start:
	mov	edx, 13
	mov	ecx, stars
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov	edx, 1
	mov	ecx, nl
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov	edx, len
	mov	ecx, msg
	mov	ebx, 1
	mov	eax, 4
	int	0x80
	mov	edx, 13
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
msg times 9 db 'Hello, world!', 0xa 
len equ $ - msg
stars times 13 db '*'
nl db 0xa
count db 10
