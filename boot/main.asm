; Generate 16 bit instructions
[BITS 16]

; Set memory offset
[org 0x7c00]

KERNEL_OFFSET equ 0x1000

jmp rm_main

; Imports here (unreachable) so they don't get executed accidentally
; Paths must be specified relative to the root directory

; print.asm contains real mode printing routines
%include "boot/rm/print.asm"

; disk.asm contains real mode disk routines
%include "boot/rm/disk.asm"

; gdt.asm contains the gdt descriptor
%include "boot/rm/gdt.asm"

rm_main:    
    ; Set stack pointers
    mov bp, 0x8000
    mov sp, bp

    ; Save boot drive
    mov [BOOT_DRIVE], dl

    ; Print starting message
    mov bx, RM_BOOT_MSG
    call rm_println
    
    ; Load the kernel from disk while we can still use BIOS interrupts
    mov bx, KERNEL_OFFSET
    mov dh, 9
    mov dl, [BOOT_DRIVE]
    call rm_disk_read

    ; Switch to 32-bit protected mode
    ; This will jump straight to pm_main
    jmp switch_to_pm
        
%include "boot/rm/switch.asm"

[BITS 32]

pm_main:
    ; Start the kernel
    call KERNEL_OFFSET

    ; Ininite loop
    jmp $

; Set global variables
RM_BOOT_MSG:
    db "Starting in 16-bit real mode...", 0
BOOT_DRIVE:
    ; Reserve byte for the boot drive index
    db 0x00
COMMA:
    db ", ", 0

; Fill with zeros
times 510-($-$$) db 0

; Magic number
dw 0xaa55
