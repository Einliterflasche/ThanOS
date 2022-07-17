;; Settings

; Emit 16 bit instructions
[BITS 16]
; Set base memory offset
[ORG 0x1000]

; Define a memory offset for the kernel
KERNEL_OFFSET equ 0x1e00

_start:
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

;; 16 bit code 
rm_main:    
    ; Initialize the stack pointers
    mov bp, 0x8000
    mov sp, bp

    ; Save boot drive
    ; mov [BOOT_DRIVE], dl 

    ; Print a message
    mov bx, RM_MSG
    call rm_println
	
    ;; Load the kernel from disk 
	; Into es:bx
	; Read 9 sectors
	; Start from sectors 9 (1 = first stage, 2-8 = second stage)
    mov bx, KERNEL_OFFSET
    mov dh, 10
	mov cl, 0x09
    call rm_disk_read

    ;; Switch to 32-bit protected mode
    ; This will jump straight to pm_main
    jmp switch_to_pm
        
%include "boot/rm/switch.asm"

; Generate 32 bit instructions
[BITS 32]

;; This is the entry point for protected mode
pm_main:
    ; Start the kernel
    call KERNEL_OFFSET
	; Infinite loop incase the kernel finishes (for whatever reason)
	jmp $

;; Set global variables
; This contains the first boot message
RM_MSG:
    db "Starting second stage in 16-bit real mode...", 0
; This contains the number of the boot drive and reserves a byte of memory for it
BOOT_DRIVE:
    db 0x00

; Fill the rest of the 7 sectors with zeros
times 3584-($-$$) db 0
