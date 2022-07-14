;; Settings

; Emit 16 bit instructions
[BITS 16]
; Set base memory offset
[ORG 0x7c00]

; Define an offset for the second boot stage
SECOND_STAGE_OFFSET equ 0x1000

; Start of the actual code
_start:
	jmp _main

;; Imports
%include "boot/rm/print.asm"
%include "boot/rm/disk.asm"

; Actual code
_main:    
    ;; Print a message
    mov bx, FIRST_STAGE_MSG
    call rm_println

    ;; Read/load the second stage
	; Load into es:bx
	; Read 7 sectors (á 512 bytes)
	; Start at sector 2 (we are currently in the first sector)
    mov bx, SECOND_STAGE_OFFSET
    mov dh, 7
	mov cl, 0x02
    call rm_disk_read

	; Move control to the second stage
	call SECOND_STAGE_OFFSET

	; Infinite loop if something goes wrong and 
	; control is returned to the first stage
    jmp $

FIRST_STAGE_MSG:
	db "Starting first boot stage...", 0

; Fill the rest of the sector with zeros
times 510-($-$$) db 0

; Use the magic number to tell the BIOS that this is a bootloader
dw 0xaa55
