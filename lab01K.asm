; Задана матрица nхn элементов, необходимо ее транспонировать.

section .bss



    size: resd 1 ; размер матрицы
    tmp: resd 1 ; для временного хранения данных
    ptr: resq 1 ; временно сохраняется адрес

    TmatData: resb 90 ; числовые данные транспонированной матрицы 
    matData: resb 90 ; числовые данные исходной матрицы
    matPtr: resb 8 ; указатель в данных матрицы

section .data
    line1: db "Enter size of matrix: "
    line1size: equ $-line1

    line2: db "Enter matrix elements:", 10
    line2size: equ $-line2


section .text

global _start

%macro read 2
    mov eax, 0 ;sysread
    mov edi, 0 ;stdin
    mov esi, %1 ; write into reserved bytes
    mov edx, %2 ; size of input
    syscall
%endmacro

%macro print 2
    mov eax, 1 ;sysread
    mov edi, 1 ;stdin
    mov esi, %1 ; ptr to message
    mov edx, %2 ; size message
    syscall
%endmacro

_start:
    ;read size, 4
;
    ;mov al, [size]
    ;sub al, 0x30
    ;add eax, 1
    ;add eax, 0x30
    ;mov [size], eax
;
;
    ;print size, 1

    call _matrixInput

    ;завершение программы
    mov eax, 1 
    mov ebx, 0 
    int 80h 

; ввод матрицы
; размер матрицы от 1 до 9
; ввести n*n чисел с \n между ними
; 
_matrixInput:
    ;Ввести размер матрицы
    print line1, line1size
    read size, 4 ; ввод размера размер считывается как символ ascii + \n
    mov eax, [size]
    sub eax, 0xa30 ; ascii символ в число
    mov [size], eax ;размер матрицы сохраняется в size и eax

    mov ebx, eax ; n^2 - кол-во элементов матрицы
    mul ebx

    push rax ; кол-во элементов сохраняется на стаке

    print line2, line2size

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



_printMatrix:



ret ; выход из _print matrix


