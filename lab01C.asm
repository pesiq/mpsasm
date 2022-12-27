SECTION .bss

    vectorData: resb 40
    matData: resb 100

    numberData: resb 100
    outputString: resb 100

    matPtr: resq 1
    NDataPointer: resq 1

    matSize: resd 1
    vecSize: resq 1

    number: resq 1
    resSize: resq 1

SECTION .data

    sizeString: db "Matrix size: "
    sizeStringSize: equ $-sizeString

    string2: db "Enter matrix elements:", 0xA
    vectorStringSize: equ $-vectorString

    resultString: db "Result vector:", 0xA
    resultStringSize: equ $-resultString

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

    call _matrixInput

    call _printMatrix

    call _getVector

    call _sort

    call _printVector

    mov eax, 1 
    mov ebx, 0 
    int 80h 


_matrixInput:

    ;Ввести размер матрицы
    print sizeString, sizeStringSize
    read size, 2 ; ввод размера размер считывается как символ ascii + \n
    mov eax, [size]
    sub eax, 0xa30 ; ascii символ в число
    mov [size], eax ;размер матрицы сохраняется в size и eax

    mov ebx, eax ; n^2 - кол-во элементов матрицы
    mul ebx

    push rax ; кол-во элементов сохраняется на стаке

    print string2, string2size

    mov ebx, matData
    pop rcx

matLoop:

    push rcx ; кол-во элементов
    push rbx ; адрес к элементу

    read tmp, 4 ; читает 4 байта 
    mov eax, [tmp] ; 
    sub eax, 0xa30 ;


    pop rbx ; вытаскиваем текущий указатель в массиве из стека
    mov [rbx], eax
    inc rbx ; инкрементируем указатель

    pop rcx ; вытаскиваем кол-во элементов
    dec rcx



    cmp ecx, 0
    jne matLoop

    ; ввод самой матрицы 
    ; числа вводятся по одному на одной строке
debug:

ret ; выход из _matrixInput