; Read dh disk sectors to es:bx
rm_disk_read:
    ; Save register contents
    pusha
   
    ; Save dx contents seperately
    push dx

    ; Set BIOS 0x13 mode to read disk
    mov ah, 0x02

    ; Select the 1st cylinder
    mov ch, 0
    ; Select the 1st side
    mov dh, 0
    ; Select the 1s sector
    mov cl, 2
    
    ; Go on for 5 sectors
    mov al, 5

    ; Read from disk
    int 0x13    

    ; Check if an error happend (if the carry bit is set)
    ; Is triggered even though everything seems to be OK
    jc rm_disk_error_carry
     
    ; Now we need the old dh value
    pop dx

    ; Check if the correct number of sectors were read
    cmp dh, al
    je rm_disk_error
    
    ; Return saved register contents
    popa

    ; Done
    ret

rm_disk_error_carry:
    ; Print carry error msg
    mov bx, RM_DISK_ERR_CARRY_MSG
    call rm_println

    ret

    ; Stop execution
    jmp $

rm_disk_error:
    ; Print an error message
    mov bx, RM_DISK_ERR_MSG
    call rm_println

    ; Inifite loop / stop execution
    jmp $

; Set messages
RM_DISK_ERR_CARRY_MSG:
    db "An error occured while reading the disk (carry bit set)...", 0
RM_DISK_ERR_MSG:
    db "An error occured reading the disk...", 0
