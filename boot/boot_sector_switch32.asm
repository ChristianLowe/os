[bits 16]
switch_to_pm:
    cli                     ; disable interrupts
    lgdt [gdt_descriptor]   ; load the GDT descriptor
    mov eax, cr0
    or eax, 0x1             ; set 32-bit mode CPU flag
    mov cr0, eax
    jmp CODE_SEG:init_pm    ; far jump to reset CPU pipeline

[bits 32]
init_pm:                    ; 32-bit mode starts here
    mov ax, DATA_SEG        ; update segment registers with new offset
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; update stack to be right on top of the free space
    mov esp, ebp
    call BEGIN_PM
    