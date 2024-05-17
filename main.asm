; syscalls
SYS_WRITE   equ 1
SYS_OPEN    equ 2
SYS_CLOSE   equ 3
SYS_EXIT    equ 60

; file descriptors
STDOUT      equ 1
STDERR      equ 2

; error codes
NOERROR     equ 0
ERROR       equ 1

section .text
    global  _start

_start:
    call    open_file
    call    print_sep
    call    random_count

.loop:
    call    prnt_msg_to_stdout
    call    prnt_msg_to_file
    dec     rbx
    jnz     .loop

    call    print_sep

    call    close_file

    mov     rdi, NOERROR
    call    exit

prnt_msg_to_stdout:
    mov     rdi, STDOUT
    call    print_msg
    ret

prnt_msg_to_file:
    mov     rdi, r9
    call    print_msg
    ret

print_msg:
    mov     rdx, len_msg
    mov     rsi, msg
    mov     rax, SYS_WRITE
    syscall
    test    rdi, rdi
    jl      file_error
    ret

open_file:
    mov     rax, SYS_OPEN
    mov     rdi, output
    mov     rsi, 1102o
    mov     rdx, 0644o
    syscall
    test    rax, rax
    jl      file_error
    mov     r9, rax
    ret

close_file:
    mov     rax, SYS_CLOSE
    mov     rdi, r9
    syscall
    ret

print_sep:
    mov     rdx, len_sep
    mov     rsi, sep
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall
    ret

random_count:
    rdrand  rax
    mov     rcx, 10
    xor     rdx, rdx
    idiv    rcx
    inc     rdx
    mov     rbx, rdx
    ret

file_error:
    mov     rdx, len_fe
    mov     rsi, fe_msg
    mov     rdi, STDERR
    mov     rax, SYS_WRITE
    syscall

    mov     rdi, ERROR
    call    exit

exit:
    mov     rax, SYS_EXIT
    syscall

section .rodata
    msg     db 'Still learning x86-64 assembly language on linux!', 0xa
    len_msg equ $ - msg
    sep     times len_msg - 1 db '='
    _nl     db 0xa
    len_sep equ $ - sep
    output  db 'out/file.txt', 0
    fe_msg  db 'Error writing to file!', 0xa
    len_fe  equ $ - fe_msg
