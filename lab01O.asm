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


    call _evenNumbers

    call _sort


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

_evenNumbers:
    
    mov edx, vectorData
    mov [pointer], edx

    mov ecx, resultVectorData
    mov [NDataPointer], ecx 

isEvenLoop:

    mov eax, [pointer] ; текущий элемент вектора
    mov ebx, 2 
    div ebx ; остаток от деления на 2

    cmp edx, 0
    jne odd


    mov eax, [pointer]
    mov [NDataPointer], eax


    mov eax, NDataPointer
    inc eax
    mov [NDataPointer], eax

    mov eax, [resSize]
    inc eax
    mov [resSize], eax

odd:

    mov eax, [size]
    dec eax
    mov [size], eax

    mov eax, pointer
    inc eax
    mov [pointer], eax

    cmp eax, 0
    jg evenLoop

ret

_sort:

ret

; в ebx передается адрес на строку
; полученное число сохраняется в eax
_stringToNumber:

    mov [pointer], ebx
    mov ecx, numberData

stringLoop:
    mov al, BYTE [ebx]
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
    dec ecx
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

    ; увеличить степень 10-ки
    mov eax, ebx
    mov ebx, 10
    mul ebx
    mov ebx, eax

    dec ecx
    mov [NDataPointer], ecx
    cmp rcx, numberData
    jge makeNumber

    pop rax

ret

; берет число, посимвольно записывает его в стек, так чтобы старший символ был сверху
; число берет из rax
; кол-во чисел в rcx
_numberToChars:
lastDigit:
    mov ebx, 10
    xor rdx, rdx ; в rdx сохраняется остаток от деления
    div ebx
    add edx, 0x30
    push rdx

    inc ecx

    cmp eax, 0
    jne lastDigit
ret

_vectorIn:

    mov eax, [size]

    mov ebx, vectorData

    
    loopIn:

    push rax
    push rbx

    ; считывает цифру из stdin
    read number, 8

    mov ebx, number
    call _stringToNumber

    pop rbx
    mov [rbx], eax
    inc ebx


    pop rax
    dec eax
    cmp eax, 0
    jg loopIn

ret

_vectorOut:
 
    mov rbx, vectorData ; в ebx записывается адрес первого элемента вектора
    mov [pointer], rbx

    mov ebx, outputString
    mov [NDataPointer], ebx ; адрес символа в строке для вывода

loopOut:

    dec eax
    mov [size], eax
    
    mov eax, [pointer]
    call _numberToChars

fillString:

    pop rbx

    mov [NDataPointer], rbx

    dec ecx

    cmp ecx, 0
    jle fillString
    mov edx, 0x20
    mov [NDataPointer], edx ; добавить пробел между числами
    mov ebx, NDataPointer
    inc ebx
    mov [NDataPointer], ebx

    mov [size], eax

    cmp eax, 0
    jg loopOut

    mov edx, 0xA
    mov [NDataPointer], edx

    write outputString, 100

ret