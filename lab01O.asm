global _start

SECTION .bss

    vectorData: resb 100
    resultVectorData: resb 100

    pointer: resq 1
    
    number: resq 1
    size: resq 1
    resSize: resq 1

SECTION .data

    sizeString: db "Vector size: "
    sizeStringSize: equ $-sizeString

    vectorString: db "Enter vector elements:", 0xA
    vectorStringSize: equ $-vectorString

    resultString: db "Result vector:", 0xA
    resultStringSize: equ $-resultString

SECTION .text

_start:

    call _sizein

    call _vectorIn


    ;call _solve


    ;call _vectorOut

    mov eax, 1 
    mov ebx, 0 
    int 80h 

;==============
; Macros
;==============

%macro in 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro out 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

;===============
; МЕТОДЫ
;===============

_sizein:

    mov eax, 0
    mov edi, 0
    mov esi, size
    mov edx, 8
    syscall

    mov eax, [size]
    sub eax, 0xA30
    mov [size], eax

ret

_vectorIn:

    mov eax, [size]

    mov ebx, vectorData

    
    loopIn:

    push rax
    push rbx

    mov eax, 0
    mov edi, 0
    mov esi, number
    mov edx, 8
    syscall

    mov eax, [number]
    sub eax, 0xA30

    pop rbx
    mov [rbx], eax
    inc ebx


    pop rax
    dec eax
    cmp eax, 0
    jg loopIn

ret