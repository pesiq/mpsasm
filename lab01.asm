
SECTION .bss
    size: resd 1
    temp: resd 1
    min: resq 1
    max: resq 1

    digits: resb 100
    digitsIndex: resb 8

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

%macro charToInt 1

%endmacro


    global _start ; entry point??

    _start:
    ; input vector size
    ; size is strored in size (bruh)
    ;call _getSize 

    ; should print out size and prompt to input the array
    ;call _printSize
    
    ; input vector
    ; puts user input in stack?
    ;call _getVector

    ; comlete task
    ; temporarily - outputs array (in reverse?)
    ;should comlete task
    ;call _calculate  

    ; output result
    ;call _printRes 

    mov rax, 31242
    call _printInt

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

    writeline size, 8
    ret



_getVector:

    pop r9 ; save return adress definatly can juggle it in the stack aswell

    mov rcx, [size] ; store size of array for dec
    sub rcx, 0xa30 ; remove newline and ascii offset
    
 

    ; loop to input each element
    loopIn:

    push rcx ; save index to stack

    read temp, 32 ;read byte from stdin

    pop rcx

    mov rax, [temp]
    sub rax, 0xa30
    push rax

    dec rcx
    cmp rcx, 0
    jnz loopIn

    push r9 ; push return adress back

    ret

    ; uses RAX RBX RCX RDX
; should print contents of RAX, nullifies rax
_printInt:

    mov rcx, digits ; save adress to digit buffer
    
    ; break down number by dividing by 10, and saving remainder
    ; write them to [digits] (going to be written in reverse order)
    ; write contents of [digits] in reverse order
    ; whould output the number in ascii in correct order with newline an the end
    ; no need for stack
    mov rbx, 10
    mov [rcx], rbx ; add newline to buffer
    inc rcx ; increment pointer to buffer
    mov [digitsIndex], rcx ; save pointer to current pos in buffer

_intBreakdownLoop:
    mov rdx, 0 ; rdx saves remainder after division
    mov rbx, 10 
    div rbx ; divide rax by 10

    push rax ; store value of rax in case rax is used
    add rdx, 0x30 ; align with ascii code

    mov rcx, [digitsIndex] ; update pos is changed
    mov [rcx], dl ; write remainder to pos
    inc rcx ; increment position 
    mov [digitsIndex], rcx ; update index

    pop rax ; get value of rax
    cmp rax, 0 ; if rax != 0 => continue
    jne _intBreakdownLoop

_intPrintLoop:

    mov rcx, [digitsIndex] ; get current pos

    writeline rcx, 1 ; write one char

    mov rcx, [digitsIndex]
    dec rcx ; go back one char in buffer
    mov [digitsIndex], rcx ; update pos

    cmp rcx, digits ; check if current pos >= starting pos
    jge _intPrintLoop

    ret