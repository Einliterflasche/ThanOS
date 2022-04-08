; Print the string which is referenced in 'bx'
rm_print:
    ; Save register contents
    pusha

    ; Set 0x10 interruption mode to tele-type
    mov ah, 0x0e

    ; Begin loop
    jmp rm_print_loop

; This prints each character of the string
rm_print_loop:
    ; Store current character
    mov al, [bx]

    ; Check for end of string
    cmp al, 0x0
    je rm_print_end

    ; Print current character
    int 0x10
    
    ; Go to next character
    add bx, 0x1

    ; Loop again
    jmp rm_print_loop

; Finish up the print function
rm_print_end:
    ; Return saved register contents
    popa

    ; Done
    ret

; Print just a new line
rm_print_nl:
    ; Save register contents
    pusha

    ; Set 0x10 interruption mode to tele-type
    mov ah, 0x0e

    ; Print new line
    mov al, 0x0a
    int 0x10

    ; Print carriage return
    mov al, 0x0d
    int 0x10

    ; Return saved register contents
    popa

    ; Done
    ret

; Print the contents of the string referenced in 'bx' followed by a new line
rm_println:
    ; Print the string
    call rm_print

    ; Printe new line and carraige return characters
    call rm_print_nl

    ; Done
    ret

; Print the number stored in 'bx' in hexadecimal notation
rm_print_hex:
    ; Save all register contents
    pusha

    ; Initiate the counter
    mov cx, 0x0000

    ; Start looping
    jmp rm_print_hex_loop

rm_print_hex_loop:
    ; Check looping condition / end loop after 4 iterations
    cmp cx, 4
    jge rm_print_hex_end

    ; Copy number
    mov ax, bx

    ; Isolate last 4 bits / last char
    and ax, 0x000f
    
    ; Calculate the ASCII value then write it to the string
    jmp rm_print_hex_loop_calc
    
rm_print_hex_loop_calc:
    ; Convert numbers to ASCII numbers
    add ax, 0x30

    ; If it is a ASCII number go on
    cmp ax, 0x39
    jle rm_print_hex_loop_write

    ; Else add another 7 as 'a-Z' are 7 places behind numbers
    add ax, 0x7

    ; Write the char to the string
    jmp rm_print_hex_loop_write
    
rm_print_hex_loop_write:
    ; Make place in 'bx'
    push bx

    ; Calculate address
    mov bx, HEX_OUT
    add bx, 0x5
    sub bx, cx
    
    ; Move ASCII value to address
    mov [bx], al

    ; Pull back previous 'bx' value
    pop bx

    ; Go to next 4 bits / char
    ror bx, 0x4

    ; Increment counter and loop again
    add cx, 0x1
    jmp rm_print_hex_loop

rm_print_hex_end:
    ; Print the manipulated string
    mov bx, HEX_OUT
    call rm_println

    ; Return saved register contents
    popa

    ; Done
    ret

; Print the number in 'bx' in hexadecimal and a new line
rm_println_hex:
    ; Print the hex number
    call rm_print_hex

    ; Print new line and carriage return characters
    call rm_print_nl
    
    ; Done
    ret

; Reserve memory for the new string
HEX_OUT:
    db "0x0000", 0 
