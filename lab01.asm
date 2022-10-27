
SECTION .bss
    size resb 8

SECTION .data
    SizePrompt: db "Enter size of array", 10
    SizePromptLen: equ $-SizePrompt

    ElementPrompt: db "Enter items of array", 10
    ElementPromptLen: equ $-ElementPrompt

SECTION .text
    global _start ; entry point??

    _start:
    ; input vector size
    call _getSize 
    
    ; input vector
    ;call _getVector

    ; comlete task
    ;call _calculate 

    ; output result
    call _printRes 


    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, SizePrompt ; message
    mov rdx, SizePromptLen ; message len
    syscall

    



    ; terminate program
    mov eax, 1 ; exit syscall
    mov ebx, 0 ; error code
    int 80h    ; call kernel

_getSize:
    mov rax, 0 ;sysread
    mov rdi, 0 ;stdin
    mov rsi, size ; write into reserved bytes
    mov rdx, 8 ; size of input
    syscall
    ret

_printRes:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, size ; message
    mov rdx, 8 ; message len
    syscall