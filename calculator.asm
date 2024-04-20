    global  _main
    extern _system
    extern  _scanf, _printf
    section .data
;Promts
input_promt_one: db "Geben sie die Erste Zahl ein: ", 0
input_promt_two: db "Geben sie die Zweite Zahl ein: ", 0
input_promt_operator: db "Geben sie die gewuenschte Operation ein (+, -, *, /): ", 0
;Variablen
number_one: dd 0
number_two: dd 0
operator: dd 0
;formation für ausgabe
format_char: db '%c', 0
format_str: db '%s', 0
format_decimal: db '%d', 0
;andere Konstanten
cls: db 'cls', 0

    section .text
_main:
    ;print erstes prompt
    mov ebx, input_promt_one
    call print_str

    ;erste nummer einlesen
    mov ebx, number_one
    mov ecx, format_decimal
    call get_input
    call clear_console

    ;print operator promt
    mov ebx, input_promt_operator
    call print_str

    ;operator einlesen
    mov ebx, operator
    mov ecx, format_str
    call get_input
    call clear_console

    ;print zweites prompt
    mov ebx, input_promt_two
    call print_str

    ;zweite nummer einlesen
    mov ebx, number_two
    mov ecx, format_decimal
    call get_input
    call clear_console

    ;ergebnis berechnen
    call calculate_result

    ;ergebnis aus calculate result ausgeben
    push    eax
    push    format_decimal
    call    _printf
    add     esp, 8

    call print_new_line
    ret

;return value => eax (decimal, dd)
;operator auswerten und dementsprechend rechnen
calculate_result:
    push ebp
    mov ebp, esp

    mov eax, dword[number_one]
    mov ebx, dword[number_two]

    mov ecx, dword[operator]
    cmp ecx, 43
    je add
    cmp ecx, 45
    je subtract
    cmp ecx, 42
    je multiply
    cmp ecx, 47
    je divide
    jmp end

    add:
        add eax, ebx
        jmp end
    subtract:
        sub eax, ebx
        jmp end
    multiply:
        imul ebx
        jmp end
    divide:
        xor edx, edx
        div ebx
        jmp end
    end:
        mov esp, ebp
        pop ebp
        ret

; parameter (ebx) 1 => value
; parameter (ecx) 2 => format
get_input:
    ; stackframe beginn
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    call _scanf

    ;Ende Stackframe
    mov esp, ebp
    pop ebp
    ret

; parameter (ebx) 1 => value
print_str:
    push ebp
    mov ebp, esp

    push    ebx
    push    format_str
    call    _printf

    mov esp, ebp
    pop ebp
    ret

; keine parameter
print_new_line:
    push ebp
    mov ebp, esp

    push 0xA
    push format_char
    call _printf

    mov esp, ebp
    pop ebp
    ret

clear_console:
    push ebp
    mov ebp, esp

    push cls
    call _system

    mov esp, ebp
    pop ebp
    ret
