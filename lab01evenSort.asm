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

_start:

    write sizeString, sizeStringSize
    call _sizein

    write vectorString, vectorStringSize
    call _vectorIn

    mov rbx, vectorData
    mov rcx, [size]
    call _vectorOut

    call _evenNumbers

    call _sort


    write resultString, resultStringSize
    mov rbx, resultVectorData
    mov rcx, [resSize]
    call _vectorOut

    mov eax, 1 
    mov ebx, 0 
    int 80h 



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

    mov rdx, vectorData
    mov [pointer], rdx

    mov rcx, resultVectorData
    mov [NDataPointer], rcx 

isEvenLoop:

    xor rdx, rdx
    xor rax, rax
    mov rbx, [pointer] ; текущий элемент вектора
    mov eax, [rbx]
    mov ebx, 2 
    div ebx ; остаток от деления на 2

    cmp edx, 0
    jne odd

    mov ebx, [pointer]
    mov ecx, [NDataPointer]
    mov eax, [ebx]
    mov [ecx], eax ; записать четный элеменет в верктор результата


    mov eax, [NDataPointer]
    add eax, 4
    mov [NDataPointer], eax ; итерация адреса в векторе результата

    mov eax, [resSize]
    inc eax
    mov [resSize], eax ; увеличить размер вектора четных чисел

odd:

    mov rax, [pointer]
    add eax, 4
    mov [pointer], eax ; итерация в векторе начальном

    mov rax, [size]
    dec eax
    mov [size], eax

    cmp eax, 0
    jg isEvenLoop

ret

; bubble sort?
_sort:

    mov ecx, [resSize]

    mov eax, resultVectorData
    mov [NDataPointer], eax
    dec ecx
bigLoop:
    push rcx

    mov ecx, [resSize]
    dec ecx
innerLoop:
    push rcx

    mov ecx, [NDataPointer]

    mov eax, [ecx] ; eax = vec[i]
    add ecx, 4
    mov ebx, [ecx] ; ebx = vec[i + 1]
    

    cmp eax, ebx
    jg swap

    jmp skip

swap:

    mov ecx, [NDataPointer]

    mov [ecx], ebx
    add ecx, 4
    mov [ecx], eax

skip:

    mov ecx, [NDataPointer]
    add ecx, 4
    mov [NDataPointer], ecx

    pop rcx
    dec rcx
    cmp rcx, 0
jne innerLoop

    mov ecx, resultVectorData
    mov [NDataPointer], ecx

    pop rcx
    dec rcx
    cmp rcx, 0
jne bigLoop

ret

; в ebx передается адрес на строку
; полученное число сохраняется в eax
_stringToNumber:

    mov ecx, numberData
    mov [pointer], ebx

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


_vectorIn:

    mov eax, [size]

    mov ebx, vectorData ;указатель на начало вектора

    
    loopIn:

    push rax
    push rbx

    ; считывает цифру из stdin
    read number, 4

    mov ebx, number
    call _stringToNumber

    pop rbx
    mov [rbx], eax
    add ebx, 4


    pop rax
    dec eax
    cmp eax, 0
    jg loopIn

ret

;rbx - адрес вектора
;rcx - размер вектора
_vectorOut:

    mov [pointer], rbx

    mov ebx, outputString
    mov [NDataPointer], ebx ; адрес символа в строке для вывода

    mov rax, 8
    mul rcx
    push rax

loopOut:
    ; т.к. число "разбирается" на цифры с лева на право
    ; а раписывать в строку нужно с права на лево
    ; с помощью стека "разворачиваем" число
    push rcx ; размер на стек

    mov ebx, [pointer]
    mov eax, [rbx]
    xor rbx, rbx
    xor rcx, rcx
    lastDigit:
    mov ebx, 10
    xor rdx, rdx ; в rdx сохраняется остаток от деления
    div ebx
    add edx, 0x30
    push rdx

    inc ecx

    cmp eax, 0
    jne lastDigit

fillString:

    pop rbx

    mov rax, [NDataPointer]
    mov [rax], rbx
    inc rax
    mov [NDataPointer], rax

    dec ecx

    cmp ecx, 0
    jg fillString

    mov ebx, 0x20
    mov rax, [NDataPointer]
    mov [rax], rbx
    inc rax
    mov [NDataPointer], rax

    mov eax, [pointer]
    add eax, 4
    mov [pointer], eax

    pop rcx
    dec rcx
    cmp rcx, 0
    jne loopOut

    mov edx, 0xA
    mov rax, [NDataPointer]
    mov [rax], edx

    pop rbx
    write outputString, rbx

ret