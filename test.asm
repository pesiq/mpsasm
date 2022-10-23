
SECTION .bss

SECTION .data
    SizePrompt: db "Enter size of array", 10
    SizePromptLen: equ $-SizePrompt

    ElementPrompt: db "Enter items of array", 10
    ElementPromptLen: equ $-ElementPrompt

SECTION .text
    global _start ; entry point??

    _start:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, SizePrompt ; message
    mov rdx, SizePromptLen ; message len
    syscall

    

    ; terminate program
    mov eax, 1 ; exit syscall
    mov ebx, 0 ; error code
    int 80h    ; call kernel
