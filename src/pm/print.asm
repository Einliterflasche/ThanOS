[BITS 32]

; Defining VGA constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; Prints the null-terminated string referenced in 'ebx'
pm_print:
    ; Save register contents
    pusha 

    ; 'ecx' contains the current video memory address
    mov ecx, [VIDEO_MEMORY]

    ; Begin loop
    jmp pm_print_loop

pm_print_loop:
    ; Move current character into 'ax'
    mov al, [ecx]
    mov ah, WHITE_ON_BLACK
    
    ; Check for the end of the string
    cmp al, 0
    je pm_print_end

    ; Move the current character into video memory
    mov [ecx], ax

    ; Go to next char of the string and to the next video memory address
    add ebx, 1
    add ecx, 2 ; Every char takes 2 bytes in video memory

    ; Loop again
    jmp pm_print_loop

pm_print_end:
    ; Return saved register contents
    popa

    ; Done
    ret
