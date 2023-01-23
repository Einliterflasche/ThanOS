;; First check if CPUID is supported

check_cpuid:
    ; Check if CPUID is supported by attempting to flip the ID bit (bit 21) in
    ; the FLAGS register. If we can flip it, CPUID is available.
 
    ; Copy FLAGS in to EAX via stack
    pushfd
    pop eax
 
    ; Copy to ECX as well for comparing later on
    mov ecx, eax
 
    ; Flip the ID bit
    xor eax, 1 << 21
 
    ; Copy EAX to FLAGS via the stack
    push eax
    popfd
 
    ; Copy FLAGS back to EAX 
    pushfd
    pop eax
 
    ; Restore FLAGS from the old version
    push ecx
    popfd
 
    ; Compare EAX and ECX. 
    ; If the are equal CPUID is not supported
    xor eax, ecx
    jz _no_cpuid

    ret

check_long_mode:
    ;; Test if extended function is available
    ; Set A register to 0x80000001
    mov eax, 0x80000000
    cpuid
    ; And compare it after calling cpuid
    ; If it is less there is no long mode
    cmp eax, 0x80000001
    jb _no_long_mode

    ;; Test the LM bit
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz _no_long_mode

    ret

_no_cpuid:
    mov eax, 0xFACEFACE
    jmp $

_no_long_mode:
    mov eax, 0xBEEFBEEF
    jmp $
