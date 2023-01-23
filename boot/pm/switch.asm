enter_long_mode:
    ;; Clear the 4 KiB above the bootloader in memory
    ; Start at 0x1e00
    mov edi, 0x1e00
    mov cr3, edi
    ; Fill with zeros
    xor eax, eax
    ; Fill 4KiB
    mov ecx, 4096
    rep stosd
    mov edi, cr3

    ;; Setup the tables
    mov DWORD [edi], 0x2e03     ; PLM4T at 0x1e00
    add edi, 0x1000
    mov DWORD [edi], 0x3e03     ; PDPT  at 0x2e00
    add edi, 0x1000
    mov DWORD [edi], 0x4e03     ; PDT   at 0x3e00
    add edi, 0x1000

    ;; Identity map the first to MiB
    mov ebx, 0x00000003         ; Start at 0x00000003
    mov ecx, 512                ; Map 512 * 4KiB = 2MiB

_identity_map:
    mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
    add ebx, 0x1000              ; Add 0x1000 to the B-register.
    add edi, 8  
    loop _identity_map

    mov eax, cr4                 ; Set the A-register to control register 4.
    or eax, 1 << 5               ; Set the PAE-bit, which is the 6th bit (bit 5).
    mov cr4, eax 

    ;; Set the long mode bit 
    ; in the extended function model-specific register
    mov ecx, 0xC0000080          ; Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                        ; Read from the model-specific register.
    or eax, 1 << 8               ; Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                        ; Write to the model-specific register.

    ;; Set the paging bit
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ;; Now we're in 32 bit compatibility sub mode
    ret