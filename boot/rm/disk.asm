; Read dh disk sectors to es:bx
rm_disk_read:
    ; Save all register contents
    pusha
    ; Save dx contents seperately
    push dx

    ;; Prepare settings
	; al = number of sectors
	; ah = interruption type (read disk)
	; cl = sector number
	; ch = track/cylinder
	; dl = drive number
	; dh = head number
	; es:bx = buffer address 
    mov ah, 0x02
    mov ch, 0x00
    mov al, dh
    mov dh, 0x00
    ; Read from disk
    int 0x13    

    ;; Checking for errors
    ; An error occured if the carry bit is set
    ; jc rm_disk_error_carry
     
    ; Now we need the old dh value
    pop dx

    ; Check if the error code is 0 (= no error occured)
    cmp ah, 0
    jne rm_disk_error

    ; Return saved register contents
    popa

    ; Done
    ret

rm_disk_error_carry:
    ; Print carry error msg
    mov bx, RM_DISK_ERR_CARRY_MSG
    call rm_print

    ; Stop execution
    jmp $

rm_disk_error:
    ; Print an error message
    mov bx, RM_DISK_ERR_MSG
    call rm_print

    mov bx, 0x0000

    mov bl, ah
    call rm_println_hex

    ret

    ; Inifite loop / stop execution
    jmp $

; Set messages
RM_DISK_ERR_CARRY_MSG:
    db "An error occured while reading the disk (carry bit set)...", 0
RM_DISK_ERR_MSG:
    db "An error occured while reading the disk. Error code: ", 0
