gdt_start:

gdt_null:   ; the mandatory null descriptor
    dd 0x0  ; dd="define double word"
    dd 0x0  ; (i.e., 4 bytes)

gdt_code:   ; the code segment descriptor
    ; base=0x0, limit=0xfffff,
    ; 1st flags: present=1, privilege=00, descriptorType=1          -> 1001b
    ; 2nd flags: code=1, conforming=0, readable=1, accessed=0       -> 1010b
    ; 3rd flags: granularity=1, 32bitDefault=1, 64bitSeg=0, AVL=0   -> 1100b
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 0-15)
    db 0x0          ; base (bits 16-23)
    db 10011010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, limit (bits 16-19)
    db 0x0          ; Base (bits 24-31)

gdt_data:   ; the data segment descriptor
    ; same as code segment except for the type flags.
    ; type flags: code=0, expandDown=0, writable=1, accessed=0      -> 0010b
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 0-15)
    db 0x0          ; base (bits 16-23)
    db 10010010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, limit (bits 16-19)
    db 0x0          ; Base (bits 24-31)

gdt_end:    ; label used to calculate the size of the gdt


gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; size of the GDT
    dd gdt_start                ; start address of GDT

; Constants

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
