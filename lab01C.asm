SECTION .bss

    vectorData: resb 40
    matData: resb 100

    chars: resb 100
    outputString: resb 100

    matPtr: resq 1
    charsPtr: resq 1
    pointer: resq 1

    matSize: resd 1
    vecSize: resq 1

    number: resq 1
    resSize: resq 1

    negative: resb 1

SECTION .data

    sizeString: db "Matrix size: "
    sizeStringSize: equ $-sizeString

    string2: db "Enter matrix elements:", 0xA
    string2size: equ $-string2

    vectorString: db "Result vector:", 0xA
    vectorStringSize: equ $-vectorString

SECTION .text

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

    global _start 

_start:

    call _matrixInput

    call _printMatrix

    call _getVector

    ; call _sort

    ; call _printVector

    mov eax, 1 
    mov ebx, 0 
    int 80h 




_matrixInput:

    ;Ввести размер матрицы
    write sizeString, sizeStringSize
    read matSize, 8 ; ввод размера размер считывается как символ ascii + \n
    mov eax, [matSize]
    sub eax, 0xa30 ; ascii символ в число
    mov [matSize], eax ;размер матрицы сохраняется в size и eax

    mov ebx, eax ; n^2 - кол-во элементов матрицы
    mul ebx

    push rax ; кол-во элементов сохраняется на стаке

    write string2, string2size

    mov ebx, matData
    pop rcx

matLoop:

    push rcx ; кол-во элементов
    push rbx ; адрес к элементу

    read number, 8 ; читает 8 байт 
    mov ebx, number ; 
    call _charsToInt


    pop rbx ; вытаскиваем текущий указатель в массиве из стека
    mov [rbx], eax
    add rbx, 8 ; инкрементируем указатель

    pop rcx ; вытаскиваем кол-во элементов
    dec rcx

    cmp ecx, 0
    jne matLoop


ret ; выход из _matrixInput



_charsToInt:

    mov ecx, 1
    mov [negative], ecx
    mov ecx, chars
    mov [pointer], ebx
    
stringLoop:
    mov al, BYTE [ebx]
    cmp al, 10 ; \n 
    je done

    cmp al, 0x2d
    jne positive

    push rbx
    mov rbx, -1
    mov [negative], rbx
    pop rbx
    dec ecx
    jmp skip

positive:
    sub eax, 0x30
    mov [ecx], eax
skip:
    inc ebx
    mov [pointer], ebx

    inc ecx
    mov [charsPtr], ecx
    jmp stringLoop

done:
    dec ecx
    mov [charsPtr], ecx
    mov ebx, 1 ; запоминаем 10 в степени n
    mov eax, 0
    push rax

makeNumber:
    mov ecx, [charsPtr]
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
    mov [charsPtr], ecx
    cmp rcx, chars
    jge makeNumber

    pop rax
    mov rbx, [negative]
    imul ebx

ret

_getVector:
    
ret


_printMatrix:

ret

_vectorOut:


ret