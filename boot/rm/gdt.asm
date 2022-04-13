; This GDT descriptor describes a 'flat' layout

; Label for calculating the GDT size later
gdt_start:

; Mandatory null descriptor: 8 bytes of zeros
gdt_desc_null:
    dd 0x0
    dd 0x0 

; Descriptor for the code segment
gdt_seg_code:
    ; Set bits 0-15 of the limit (size)
    dw 0xffff
    ; Set bits 0-15 of the base address
    dw 0x0
    ; Set bits 16-23 of the base address
    db 0x0
    ; Set the first flags and type flags (reference the os-dev.pdf for details)
    db 10011010b
    ; Set the next flags and bits 16-19 of the limit
    db 11001111b    
    ; Set bits 24-31 of the base address
    db 0x0

; Descriptor for the data segment
gdt_seg_data:
    ; This is the same as code segment, except for the type flags
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

; Label for calculating the GTD size
gdt_end:
    
gdt_descriptor:
    ; Set the size
    dw gdt_end - gdt_start - 1
    ; Set start address
    dd gdt_start

; Defining handy constants:
; When setting segment registers to 1 byte offsets the CPU will 
; use the offset defined in our GDT + said 1 byte offset
; For example: mov ds, 0x10 will use [gdt_start + 0x10] which is gdt_seg_data
CODE_SEG equ gdt_seg_code - gdt_start
DATA_SEG equ gdt_seg_data - gdt_start
