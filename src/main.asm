; Generate 16 bit instructions
[BITS 16]

; Set memory offset
[org 0x7c00]

jmp rm_main

; Imports here (unreachable) so they don't get executed accidentally
; Paths must be specified relative to the root directory

; print.asm contains real mode printing routines
%include "src/rm/print.asm"

; disk.asm contains real mode disk routines
; %include "src/rm/disk.asm"

; gdt.asm containts the gdt descriptor
%include "src/rm/gdt.asm"
rm_main:    
    ; Set stack pointers
    mov bp, 0x8000
    mov sp, bp

    ; Save boot drive
    mov [BOOT_DRIVE], dl

    ; Print starting message
    mov bx, RM_BOOT_MSG
    call rm_println
    
    ; Switch to 32-bit protected mode
    ; This will jump straight to pm_main
    jmp switch_to_pm
        
%include "src/rm/switch.asm"

[BITS 32]

%include "src/pm/print.asm"

pm_main:
    ; Print boot message
    mov ebx, PM_BOOT_MSG
    call pm_print

    ; Ininite loop
    jmp $

; Set global variables
RM_BOOT_MSG:
    db "Starting in 16-bit real mode...", 0
LOG_MSG:
    db "[Log]...", 0
PM_BOOT_MSG:
    db "Switched to 32-bit protected mode...", 0
BOOT_DRIVE:
    ; Reserver byte for the boot drive index
    db 0x00

; Fill with zeros
times 510-($-$$) db 0

; Magic number
dw 0xaa55
