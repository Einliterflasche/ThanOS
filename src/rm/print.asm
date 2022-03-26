rm_print:
    pusha 
    mov ah, 0x0e
    jmp rm_print_loop

rm_print_loop:
    ; check for the end of the string
    mov cl, [bx]
    cmp cl, 0
    je rm_print_end

    ; print current char
    mov al, cl 
    int 0x10
    
    ; move on to next char
    add bx, 0x1
    jmp rm_print_loop
 
rm_print_end:
    popa
    ret
   
rm_println:
    ; first print normally
    call rm_print

    ; print new line
    call rm_print_nl

    ; done
    ret

rm_print_nl:
    ; then save ax register
    push ax

    ; set tele-type mode
    mov ah, 0x0e

    ; print newline and carriage return characters
    mov al, 0x0d
    int 0x10
    
    mov al, 0x0a
    int 0x10

    ; get ax register back
    pop ax
    ret
    
