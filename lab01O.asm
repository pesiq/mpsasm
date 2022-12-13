global _start

SECTION .bss

    vectorData: resb 80
    resultVectorData: resb 80

    numberData: resb 100
    outputString: resb 100

    pointer: resq 1

    NDataPointer: resq 1
    
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

%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro write 2
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

; в ebx передается адрес на строку
; полученное число сохраняется в eax
_stringToNumber:
    mov [pointer], ebx
    mov ecx, numberData

stringLoop:
    mov al, BYTE [eax]
    cmp al, 10 ; \n 
    je done

    sub eax, 0x30
    mov [ecx], eax

    inc ebx
    mov [pointer], ebx

    inc ecx
    mov [NDataPointer], ecx
    jmp stringLoop

done:
    dex ecx
    mov [NDataPointer], ecx
    mov ebx, 1 ; запоминаем 10 в степени n
    mov eax, 0
    push rax

makeNumber:

    mov ecx, [NDataPointer]
    mov eax, 0
    mov al, BYTE [ecx]
    mul ebx ; умножаем eax на 10 в степени 
    mov edx, eax
    pop rax
    add eax, edx
    push rax

    ; увеличить степень 10
    mov eax, ebx
    mov ebx, 10
    mul ebx
    mov ebx, eax

    dex ecx
    mov [NDataPointer], ecx
    cmp rcx, numberData
    jge makeNumber

    pop rax

ret


_numberToString:

ret

_vectorIn:

    mov eax, [size]

    mov ebx, vectorData

    
    loopIn:

    push rax
    push rbx

    ; считывает цифру из stdin
    read number 4

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

_vectorOut:
 
    mov eax, [size] ; размер вектора
    mov ebx, vectorData ; в ebx записывается адрес на первый элемент вектора

loopOut:
    
    write number, 1

    cmp eax, 0
    jg loopOut

    mov eax, 1
    mov edi, 1
    mov esi, 0x30
    mov edx, 1
    syscall

ret