;; Settings

; Tell the compiler to generate 16 bit instructions
[BITS 16]
; Tell the compiler to apply a general memory offset unless specified otherwise
[org 0x7c00]
; Define a constant offset for the kernel in memory for easier use
KERNEL_OFFSET equ 0x1000

;; Start of the actual code
_main:
	; Execute the 16 bit instructions
	jmp rm_main

;; Imports

; Since we jump to rm_main these will not get executed on load 
; but are still available for later use
; Paths must be specified relative to the root directory

; print.asm contains real mode printing routines
%include "boot/rm/print.asm"

; disk.asm contains real mode disk routines
%include "boot/rm/disk.asm"

; gdt.asm contains the gdt descriptor
%include "boot/rm/gdt.asm"

;; 16 bit main
rm_main:    
    ; Initialize the stack pointers
    mov bp, 0x8000
    mov sp, bp

    ; Save boot drive
    mov [BOOT_DRIVE], dl

    ; Print the first message
    mov bx, RM_BOOT_MSG
    call rm_println

	; Print the boot drive index
	mov bx, RM_BOOT_DRIVE_MSG
	call rm_print
	mov bx, [BOOT_DRIVE]
	call rm_println_hex

    ; Load the kernel from disk while we can still use BIOS interrupts
    mov bx, KERNEL_OFFSET
    mov dh, 9
    mov dl, [BOOT_DRIVE]
    call rm_disk_read

    ;; Switch to 32-bit protected mode
    ; This will jump straight to pm_main
    jmp switch_to_pm
        
%include "boot/rm/switch.asm"

; Tell the compiler to generate 32 bit instructions
[BITS 32]

;; This is the entry point for protected mode
pm_main:
    ; Start the kernel
    call KERNEL_OFFSET
	; Infinite loop incase the kernel finishes (for whatever reason)
	jmp $

;; Set global variables

; This contains the first boot message
RM_BOOT_MSG:
    db "Starting in 16-bit real mode...", 0
; This contains the message used to print the boot drive number
RM_BOOT_DRIVE_MSG:
    db "Detected boot drive: ", 0
; This contains the number of the boot drive and reserves a byte of memory for it
BOOT_DRIVE:
    db 0x00

; Fill the rest of the sector with zeros
times 510-($-$$) db 0

; Use the magic number to tell the BIOS that this is a bootloader
dw 0xaa55
