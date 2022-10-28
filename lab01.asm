
SECTION .bss
    size resq 1
    temp resq 1
    min resq 1
    max resq 1

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
    global _start ; entry point??

    _start:
    ; input vector size
    ; size is strored in size (bruh)
    call _getSize 

    ; should print out size and prompt to input the array
    call _printSize
    
    ; input vector
    ; puts user input in stack?
    call _getVector

    ; comlete task
    ; temporarily - outputs array (in reverse?)
    ;should comlete task
    ;call _calculate  

    ; output result
    call _printRes 

    ; terminate program
    mov eax, 1 ; exit syscall
    mov ebx, 0 ; error code
    int 80h    ; call kernel

_getSize:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, SizePrompt ; message
    mov rdx, SizePromptLen; message len
    syscall

_input:
    mov rax, 0 ;sysread
    mov rdi, 0 ;stdin
    mov rsi, size ; write into reserved bytes
    mov rdx, 64 ; size of input
    syscall
    ret

_printSize:
    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, SizePrompt2 ; message
    mov rdx, SizePrompt2Len; message len
    syscall

    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, size ; message
    mov rdx, 64; message len
    syscall

    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, ElementPrompt ; message
    mov rdx, ElementPromptLen; message len
    syscall
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

    mov rax, 1 ; syswrite
    mov rdi, 1 ; stdout
    mov rsi, rcx ; message
    mov rdx, 64 ; message len
    syscall

    ; loop to input each element
    ;loopIn:
    ;mov rax, 0 ;sysread
    ;mov rdi, 0 ;stdin
    ;mov rsi, temp ; adress to write reserved bytes into 
    ;mov rdx, 16 ; size of input
    ;syscall
;
    ;mov rdx, [temp]
    ;push rdx
    ;dec rcx
    ;cmp rcx, 0
    ;jz loopIn
    ret


_calculate:

    mov rcx, size ; move store size of array for dec
    loopCalc:
    pop rdx ; pop into temp
    mov rax, 1 ;syswrite
    mov rdi, 1 ;stdout
    mov rsi, rdx ; write from reserved bytes
    mov rdx, 8 ; size of input
    syscall
    dec rcx
    cmp rcx, 0
    jz loopCalc
    ret