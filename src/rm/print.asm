; Print the string which is referenced in 'bx'
; Print the character at the address in 'bx', repeat so for the nex characters 
; until a null character is found
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

; receiving the data in 'dx'
; For the examples we'll assume that we're called with dx=0x1234
rm_print_hex:
    pusha

    mov cx, 0 ; our index variable

; Strategy: get the last char of 'dx', then convert to ASCII
; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
; Then, move the ASCII byte to the correct position on the resulting string
hex_loop:
    cmp cx, 4 ; loop 4 times
    je end
    
    ; 1. convert last char of 'dx' to ascii
    mov ax, dx ; we will use 'ax' as our working register
    and ax, 0x000f ; 0x1234 -> 0x0004 by masking first three to zeros
    add al, 0x30 ; add 0x30 to N to convert it to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65-58=7
    jmp step2

step2:
    ; 2. get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx  ; our index variable
    mov [bx], al ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; increment index and loop
    add cx, 1
    jmp hex_loop

end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov bx, HEX_OUT
    call rm_print

    popa
    ret

HEX_OUT:
    db "0x0000", 0 ; reserve memory for our new string
