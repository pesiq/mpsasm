global _start

SECTION .bss

    vectorData resb: 100
    resultVectorData resb: 100
    
    size resq: 1
    resSize resq: 1

SECTION .data

    sizeString: db "Vector size: "
    sizeStringSize: equ $-sizeString

    vectorString: db "Enter vector elements:", 0xA
    vectorStringSize: equ $-vectorString

    resultString: db "Result vector:".0xA
    resultStringSize: equ $-resultString

SECTION .text

_start:

    call _sizein

    call _vectorIn


    call _solve


    call _vectorOut

    mov eax, 1 
    mov ebx, 0 
    int 80h 

;===============
; МЕТОДЫ
;===============

_sizein:

    mov eax, 1
    mov edi, 1
    mov esi, size
    mov edx, 8

    mov eax, [size]
    sub eax, 0xA30
    mov [size], eax

ret