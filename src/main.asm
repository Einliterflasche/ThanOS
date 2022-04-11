; Generate 16 bit instructions
[BITS 16]

; Set memory offset
[org 0x7c00]

jmp main

; Imports here (unreachable) so they don't get executed accidentally
; Paths must be specified relative to the root directory

; print.asm contains real mode printing routines
%include "src/rm/print.asm"

; disk.asm contains real mode disk routines
%include "src/rm/disk.asm"

main:    
    ; Set stack pointers
    mov bp, 0x8000
    mov sp, bp

    ; Save boot drive
    mov [BOOT_DRIVE], dl

    ; Print starting message
    mov bx, RM_BOOT_MSG
    call rm_println

    ; Infinite loop
    jmp $ 

; Set variables
RM_BOOT_MSG:
    db "Starting in real mode...", 0

BOOT_DRIVE:
    db 0x00

; Fill with zeros
times 510-($-$$) db 0

; Magic number
dw 0xaa55
