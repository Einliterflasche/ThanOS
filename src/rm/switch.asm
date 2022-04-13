 [BITS 16]

 switch_to_pm:
    ; Switch of interrupts for now
    cli

    ; Load the global descriptor table
    lgdt [gdt_descriptor]

    ; Set first bit in special register to 1
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to flush the CPU pipeline
    jmp CODE_SEG:init_pm

 [BITS 32]

; Initialise registers and stack
init_pm:
    ; Update segments to point to the new data segment
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Update stack position
    mov ebp, 0x900000
    mov esp, ebp
    
    mov ebx, PM_INIT_MSG
    call pm_print

    ; Continue in protected mode
    jmp pm_main

PM_INIT_MSG:
    db "Initialised 32-bit protected mode...", 0
