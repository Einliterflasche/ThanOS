; Generate 16 bit instructions
[BITS 16]

; Set memory offset
[org 0x7c00]

; Set screen interrupt mode
mov ah, 0x0e

; Set stack pointers
mov bp, 0x8000
mov sp, bp

; Print a hex value
mov bx, 0x9fb3
call rm_print_hex

; Set variables
RM_BOOT_MSG:
    db "Starting in real mode...", 0

; Infinite loop
jmp $ 

; Imports after infinite loop so that they don't get executed on load
; print.asm contains rm_print, rm_println and rm_print_hex routines
%include "src/rm/print.asm"

; Fill with zeros
times 510-($-$$) db 0

; Magic number
dw 0xaa55
