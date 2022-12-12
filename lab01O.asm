global _start

SECTION .bss

    vectorData resb: 100
    resultVectorData resb: 100
    


SECTION .data



SECTION .text

_start:

    call _vectorIn


    call _solve


    call _vectorOut

    mov eax, 1 
    mov ebx, 0 
    int 80h 

;===============
; МЕТОДЫ
;===============
