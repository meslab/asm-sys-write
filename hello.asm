SYS_EXIT      equ 60
SYS_CLOSE     equ 3
SYS_OPEN      equ 2
SYS_WRITE     equ 1
STDOUT        equ 1
NOERROR       equ 0
ERROR         equ 1

section .text
    global  _start

_start:
    call    open_file
    call    print_stars
    call    random_count
    
.loop:
    push    rcx
    call    print_hello
    call    print_to_file
    pop     rcx
    dec     rcx
    jnz     .loop

    call    print_stars

    call    close_file

    mov      di, NOERROR
    call    exit

print_hello:
    mov     rdi, STDOUT
    call    print_msg
    ret

print_to_file:
    mov     rdi, [fd]
    call    print_msg
    ret

print_msg:
    mov     rdx, len_msg
    mov     rsi, msg
    mov     rax, SYS_WRITE
    syscall
    ret

open_file:
    mov     rax, SYS_OPEN
    mov     rdi, filename
    mov     rsi, 1102o
    mov     rdx, 0644o
    syscall
    cmp     rax, -1
    je      file_error

    mov     [fd], rax
    ret

close_file:
    mov     rax, SYS_CLOSE
    mov     rdi, [fd]
    syscall
    ret

print_stars:
    mov     rdx, len_strs
    mov     rsi, stars
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall
    ret

random_count:
    rdrand  rax
    mov     rcx, 10
    xor     rdx, rdx
    idiv    rcx
    add     rdx, 1
    mov     rcx, rdx
    ret

file_error:
    mov     rdi, ERROR
    call    exit

exit:
    mov     rax, SYS_EXIT
    syscall

section .data
    msg     db 'Still learning!', 0xa
    len_msg equ $ - msg
    stars   times len_msg - 1 db '*'
    NL            db 10
    len_strs equ $ - stars
    filename db 'file.txt', 0

section .bss
    fd      resb 1