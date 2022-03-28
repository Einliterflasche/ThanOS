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

; Print the number stored in 'bx' in hexadecimal
rm_print_hex:
    ; Save register contents
    pusha

    ; Initialize counter
    mov cx, 0x0

    ; Begin looping
    jmp rm_print_hex_loop

rm_print_hex_loop:
    ; Check if we have already looped 4 times
    cmp cx, 4
    je rm_print_hex_end
    
    ; Calculate ASCII value
    jmp rm_print_hex_loop_calc

rm_print_hex_loop_calc:
    ; Copy number to 'ax'
    mov ax, bx

    ; Isolate last 4 bits
    and ax, 0x000f
    
    ; Add 0x30 for numbers
    ; 0-9 have an ASCII value of 0x30 + n
    add ax, 0x30

    ; For number we are done. 
    cmp ax, 0x39
    jle rm_print_hex_loop_write

    ; For letters (a-f) we have to add another 7 
    ; since (a-f) have an ASCII value of 0x37 + n
    add ax, 0x7

    ; Now continue to the second step
    jmp rm_print_hex_loop_write

rm_print_hex_loop_write:
    ; Get position of the current character
    ; HEX_OUT + 5 is the address of the last character
    mov dx, HEX_OUT
    add dx, 0x5
    
    ; cx is the counter
    ; dx - cx is the address of our current character
    sub dx, cx

    ; Write calculated ASCII value to the calculated position
    mov [dx], ax 

    ; Move to next 4 bits / next character
    ror bx, 0x4

    ; Increment counter and loop
    add cx, 0x1
    jmp rm_print_hex_end

rm_print_hex_end:
    ; Return saved register contents
    popa

    ; Done
    ret

; Print the number stored in 'bx' in hexadecimal followed by a new line
rm_print_hexln:
    ; Print the hex number
    call rm_print_hex
    
    ; Print the new line and carriage return
    call rm_print_nl

    ; Done
    ret

; Reserve memory for string that can be manipulated
HEX_OUT:
    db "0x0000", 0 
