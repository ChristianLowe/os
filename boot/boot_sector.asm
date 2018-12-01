; This simple bootloader enables 32-bit protected mode and starts a C-written kernel.

[org 0x7c00]

KERNEL_OFFSET equ 0x1000     ; we load the kernel in this memory offset

mov bp, 0x9000               ; move stack safely away
mov sp, bp

mov bx, MSG_REAL_MODE        ; announce that we are starting
call print                   ; booting from 16-bit real mode
call print_nl

call load_kernel             ; load our kernel into memory

call switch_to_pm            ; switch to protected mode,
                             ; which we won't return from

jmp $                        ; hang, never executed

%include "boot/boot_sector_gdt.asm"
%include "boot/boot_sector_print.asm"
%include "boot/boot_sector_print_hex.asm"
%include "boot/boot_sector_disk.asm"
%include "boot/boot_sector_print32.asm"
%include "boot/boot_sector_switch32.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL  ; announce that we are
    call print               ; loading the kernel
    call print_nl

    mov bx, KERNEL_OFFSET    ; set up parameters for the disk_load routine
    mov dh, 15               ; we load the first 15 sectors (except
    mov dl, [BOOT_DRIVE]     ; for the boot sector) from our
    call disk_load           ; boot disk into KERNEL_OFFSET

    ret

[bits 32]
; Arrived to after the switch to 32-bit protected mode
BEGIN_PM:
    mov ebx, MSG_PROT_MODE   ; print that we are now in protected
    call print_string_pm     ; mode to VGA.

    call KERNEL_OFFSET       ; jump to our kernel.c entrypoint

    jmp $                    ; hang

                             ; Data
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
