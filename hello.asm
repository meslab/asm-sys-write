SYS_EXIT equ 1
SYS_OPEN equ 5
SYS_CLOSE equ 6
SYS_CREATE equ 8
SYS_WRITE equ 4
STDOUT equ 1
_NOERRORS equ 0
_ERRORS equ 1
NL db 10

section .text
	global _start

_start:
	call open_file
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
	mov rax, rdx
	rdrand rax
	mov rcx , rax
	shr rdx, 64
	mov rcx, 10
	idiv rcx
	add rdx, 1
	mov rcx, rdx
	;mov rcx, 3

loop:
	call print_hello
	call print_to_file
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

	call close_file
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

print_to_file:
	push rdx
	push rcx
	push rbx
	push rax
	mov	rdx, len_msg
	mov	rcx, msg
	mov rbx, [fd]
	mov	rax, SYS_WRITE
	int	0x80
	pop rax
	pop rbx
	pop rcx
	pop rdx
	ret

open_file:
	push rax
	push rbx
	push rcx
	mov	rax, SYS_CREATE
	mov rbx, filename
	mov rcx, 0o0644
	int	0x80
	cmp rax, -1
    je file_error

	mov	[fd], rax
	
	pop rcx
	pop rbx
	pop rax
	ret

close_file:	
	;push rax
	mov	rax, SYS_CLOSE
	mov	rbx, [fd]
	int	0x80
	;pop rax
	ret

file_error:
    mov rax, _ERRORS
    mov rbx, SYS_EXIT
    int 0x80

section .data
	msg db 'Hello, world!', 0xa 
	len_msg equ $ - msg
	stars times len_msg  db '*', 0
	len_stars equ $ - stars - 2
	filename db 'file.txt', 0

section .bss
	fd resb 1
