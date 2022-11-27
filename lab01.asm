SECTION .bss


    digits: resb 20
    temp: resb 20
    size: resb 20

    adr: resb 8
    digitsIndex: resb 8
    tmpPtr: resb 8

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

    global _start ; entry point

_start:
    ; input vector size
    ; size is strored in size (bruh)
    call _getSize

    ; should print out size and prompt to input the array
    call _printSize

    ; input vector
    ; puts user input in stack
    call _getVector

    ; comlete task
    ; should calculate min and max, write their sum to RAX
    call _calculate  

    ; output result
    ; result should be in RAX
    push rax
    writeline ResultPrompt, ResultPromptLen
    pop rax
    call _printInt

    ; terminate program
    mov eax, 1 ; exit syscall
    mov ebx, 0 ; error code
    int 80h    ; call kernel

;=================================================
; methods

_getSize:
    writeline SizePrompt, SizePromptLen
    read size, 10
ret



_printSize:
    writeline SizePrompt2, SizePrompt2Len
    writeline size, 10
    writeline ElementPrompt, ElementPromptLen
ret



; calculates min and max of vector values
; writes them to RAX
; affects RAX, RBX, RCX, RDX 
_calculate:

    pop rax ; save return adress
    mov [adr], rax
    ; rax contains current intem of vec
    ; rbx contains max
    ; rcx size
    ; rdx min
    mov rdx, 1000000000 ; init min
    mov rbx, 0 ; init max
    pop rcx

calcLoop:
    cmp rcx, 0 ; check if vector end
    jle calculateSum
    dec rcx ; dicrement size
    pop rax ; get new item
    cmp rax, rbx ; compare item to max
    jl notMax
    mov rbx, rax
notMax:
    cmp rax, rdx ; compare item to min
    jg notMin
    mov rdx, rax
notMin:
    jmp calcLoop

calculateSum:
    xor rax, rax ; clear rax
    mov rax, rbx
    add rax, rdx


    mov rbx, [adr]
    push rbx ; push return adress back to stack

ret


; inputs vector fron stdin
; converts string to int and puts int to stack
; converted to integer length of vector will be put on top of stack
_getVector:

    pop rax ; save return adress
    mov [adr], rax

    mov rbx, size ; store size of array for dec
    call _charsToInt
    mov rcx, rax ; write size of array to rcx
    mov [size], rax
    
    ; loop to input each element
loopIn:

    push rcx ; save index to stack from being eatem by read

    read temp, 10 ;read bytes from stdin
    mov rbx, temp ; save temp adress to rbx (input for _charsToInt)
    call _charsToInt ; convert chars to integer

    pop rcx ; get size from top of stack
    push rax ; put vector item onto stack

    dec rcx ; decrease size
    cmp rcx, 0 
    jg loopIn

endIn:
    mov rcx, [size] 
    push rcx    ; save size on stack; on top of the vector
    mov rax, [adr]
    push rax ; push return adress back to stack

ret


; should take number chars from PTR [RBX] convert them to numeric int
; uses RAX RBX RCX RDX
; then put them in RAX
; 0x0A (newline) used as terminating symbol
_charsToInt:
    mov rcx, digits ; save adress to number integer buffer (destination)
    mov [tmpPtr], rbx ; save adress to char integer buffer (source)

_stringBreakdownLoop:
    mov al, BYTE [rbx] ; move to rax val of first char digit
    cmp al, 0x0A
    je skip
    sub eax, 0x30 ; char -> integer
    mov [rcx], rax ; add int to 

    ; upd source index
    inc rbx
    mov [tmpPtr], rbx

    ; upd dest index
    inc rcx
    mov [digitsIndex], rcx
    jmp _stringBreakdownLoop

skip:
    dec rcx
    mov [digitsIndex], rcx
    mov rbx, 1 ; rax stores offset
    xor rax, rax
    push rax ; save current int

    ; computes final integer using digits
_intAssembly:
    mov rcx, [digitsIndex] ; get pos in buffer
    xor rax, rax ; zero out rax in case offset >100
    mov al, BYTE [rcx] ; read current digit value to rax
    mul rbx ; multiply value by offset
    mov rdx, rax
    pop rax ; get current int
    add rax, rdx ; add value w/ correecet offset to rax 
    push rax ;save new int again
    
    ; increase offset
    mov rax, rbx
    mov rdx, 10
    mul rdx 
    mov rbx, rax

    ; move ptr
    dec rcx
    mov [digitsIndex], rcx
    cmp rcx, digits
    jge _intAssembly ; jump if not at begining of buffer 

    pop rax
ret

; uses RAX RBX RCX RDX
; should print contents of RAX, obliterates RAX to 0
_printInt:
    ; break down number by dividing by 10, and saving remainder
    ; write them to [digits] (going to be written in reverse order)
    ; write contents of [digits] in reverse order
    ; whould output the number in ascii in correct order with newline an the end
    ; no need for stack
    mov rcx, digits ; save adress to digit buffer
    mov rbx, 10
    mov [rcx], rbx ; add newline to buffer
    inc rcx ; increment pointer to buffer
    mov [digitsIndex], rcx ; save pointer to current pos in buffer

    ; breaks down integer into digits, converts to char and puts them into [digits]
_intBreakdownLoop:
    mov rdx, 0 ; rdx saves remainder after division
    mov rbx, 10 
    div rbx ; divide rax by 10

    push rax ; store value of rax in case is overriden
    add rdx, 0x30 ; align with ascii code

    mov rcx, [digitsIndex] ; update pos is changed
    mov [rcx], dl ; write remainder to pos
    inc rcx ; increment position 
    mov [digitsIndex], rcx ; update index

    pop rax ; get value of rax
    cmp rax, 0 ; if rax != 0 => continue
    jne _intBreakdownLoop

    ; prints chars stored in [digits]
_intPrintLoop:

    mov rcx, [digitsIndex] ; get current pos

    writeline rcx, 1 ; write one char

    mov rcx, [digitsIndex]
    dec rcx ; go back one char in buffer
    mov [digitsIndex], rcx ; update pos

    cmp rcx, digits ; check if current pos >= starting pos
    jge _intPrintLoop

ret