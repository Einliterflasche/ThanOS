; set teletype mode for 0x10 screen interrupt
mov ah, 0x0e 

; set character which should be printed by 0x10 screen interrupt
mov al, 'H' 
; print set character
int 0x10

; set print another character
mov al, 'i'
int 0x10

; infinite loop
jmp $ 

; fill with zeros
times 510-($-$$) db 0

; magic number
dw 0xaa55
