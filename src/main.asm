[BITS 16]
; set memory offset
[org 0x7c00]

; set screen interrupt mode
mov ah, 0x0e

; set stack pointers
mov bp, 0x8000
mov sp, bp

mov bx, RM_BOOT_MSG
call rm_print

; set variables
RM_BOOT_MSG:
    db "Starting in real mode...", 0

; infinite loop
jmp $ 

; imports after infinite loop so that they don't get executed on load
%include "src/rm/print.asm"

; fill with zeros
times 510-($-$$) db 0

; magic number
dw 0xaa55
