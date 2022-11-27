; Задана матрица nхn элементов, необходимо ее транспонировать.

section .bss



    size: resd 1 ; размер матрицы
    tmp: resd 1 ; для временного хранения данных
    adr: resq 1 ; временно сохраняется адрес

    TmatData: resb 90 ; числовые данные транспонированной матрицы 
    matData: resb 90 ; числовые данные исходной матрицы
    printString: resb 90 ; строка для вывода
    matPtr: resb 8 ; указатель в данных матрицы

section .data
    line1: db "Enter size of matrix: "
    line1size: equ $-line1

    line2: db "Enter matrix elements:", 10
    line2size: equ $-line2

    line3: db "Entered matrix:",10
    line3size: equ $-line3

    line4: db "Transposed matrix:",10
    line4size: equ $-line4

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
    mov esi, %1 ; adr to message
    mov edx, %2 ; size message
    syscall
%endmacro

_start:

    call _matrixInput

    print line3, line3size
    mov rax, matData
    call _printMatrix

    print line4, line4size
    call _transpose
    mov rax, TmatData
    call _printMatrix

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



; из указателя в RAX читает данные матрицы
; в size хранить размер матрицы
_printMatrix:

    mov [matPtr], rax ; запомнить текущее положение в данных матрицы
    mov [adr], DWORD printString ; текущее положение в строке для печати
    mov ebx, [size] ; размер матрицы 

    ; проход по ebx для строк 
    ; проходимся по ecx для колонок в строке

loopRow:
    push rbx
    mov ecx, [size] ; размер матрицы

loopCol:
    push rcx

    ; 0x20 - space
    mov eax, [adr]
    mov [eax], BYTE 0x20
    inc eax
    mov [adr], eax 

    mov ecx, [matPtr]
    mov al, [ecx]
    add eax, 0x30  
    inc ecx
    mov [matPtr], ecx

    mov ebx, [adr]
    mov [ebx], eax 
    inc ebx
    mov [adr], ebx 

    pop rcx
    dec ecx
    cmp ecx, 0
    jg loopCol ; col loop

    ; 0xA - newline
    pop rbx
    mov eax, DWORD [adr]
    mov [eax], BYTE 0xA
    inc eax
    mov [adr], eax
    dec ebx
    cmp ebx, 0
    jg loopRow ; row loop

    print printString, 90

ret ; выход из _print matrix

; берет данные из matData
; записывает транспонированную матрицу в TmatData
_transpose:

    mov [matPtr], DWORD matData ; запомнить текущее положение в данных матрицы
    mov [adr], DWORD TmatData ; текущее положение в транспонированной матрице
    mov ebx, [size] ; размер матрицы 

    ; проход по ebx для строк 
    ; проходимся по ecx для колонок в строке

    ; т.к. данные матрицы записаны в строку
    ; можно по ней пройти n раз начиная с 1 элемента с шагом в n
    ; записывая эти элементы в новую матрицу, получится транспонированая матрица

TloopRow:
    push rbx
    mov ecx, [size] ; размер матрицы
    mov rbx, [matPtr]
    push rbx

TloopCol:

    mov eax, [matPtr] ; original
    mov ebx, [adr] ; transposed
    mov edx, [eax]
    mov [ebx], edx

    inc ebx
    mov [adr], ebx

    mov ebx, [size]
    add eax, ebx 
    mov [matPtr], eax

    dec ecx
    cmp ecx, 0
    jg TloopCol ; col loop


    pop rbx
    inc ebx
    mov [matPtr], ebx

    pop rbx
    dec ebx
    cmp ebx, 0
    jg TloopRow ; row loop

ret ; выход из _transpose


