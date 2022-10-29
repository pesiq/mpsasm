
SECTION .bss
    size: resb 1
    temp: resq 1
    min: resq 1
    max: resq 1

SECTION .data
    SizePrompt: db "Enter size of array: "
    SizePromptLen: equ $-SizePrompt

    SizePrompt2: db "Size of array is: "
    SizePrompt2Len: equ $-SizePrompt2

    ElementPrompt: db "Enter items of array: ", 10
    ElementPromptLen: equ $-ElementPrompt

    ResultPrompt: db "The sum of biggest and smallest of the elements is: "
    ResultPromptLen: equ $-ResultPrompt



SECTION .text

%macro read 2
    mov rax, 0 ;sysread
    mov rdi, 0 ;stdin
    mov rsi, %1 ; write into reserved bytes
    mov rdx, %2 ; size of input
    syscall
%endmacro

%macro writeline 2
    mov rax, 1 ;sysread
    mov rdi, 1 ;stdin
    mov rsi, %1 ; ptr to message
    mov rdx, %2 ; size message
    syscall
%endmacro


    global _start ; entry point??

    _start:
    ; input vector size
    ; size is strored in size (bruh)
    call _getSize 

    ; should print out size and prompt to input the array
    call _printSize
    
    ; input vector
    ; puts user input in stack?
    ;call _getVector

    ; comlete task
    ; temporarily - outputs array (in reverse?)
    ;should comlete task
    ;call _calculate  

    ; output result
    ;call _printRes 


    ; terminate program
    mov eax, 1 ; exit syscall
    mov ebx, 0 ; error code
    int 80h    ; call kernel

_getSize:
    writeline SizePrompt, SizePromptLen
    read size, 8
    ret

_printSize:

    writeline SizePrompt2, SizePrompt2Len

    writeline size, 8

    writeline ElementPrompt, ElementPromptLen

    ret

_printRes:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, size ; message
    mov rdx, 64 ; message len
    syscall
    ret



_getVector:
    mov rcx, size ; move store size of array for dec

    ;использую 64 битные регистры, чтобы сохранить адрес.
    ;если машина <64 бит, то наверное можно использовать секции .bss или .data 

    pop r8 ; save return adress
check:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, rcx ; message
    mov rdx, 64 ; message len
    syscall

    ; loop to input each element
    loopIn:
    mov rax, 0 ;sysread
    mov rdi, 0 ;stdin
    mov rsi, r9 ; write to register 
    mov rdx, 64 ; size of input
    syscall

    push r11
    dec rcx
    cmp rcx, 0
    jnz loopIn

    push r8 ; push return adress back

    ret