disk_load:
    pusha
    push dx

    mov ah, 0x02
    mov al, dh      ; al = number of sectors to read
    mov cl, 0x02    ; cl = sector (0x01 .. 0x11)
    mov ch, 0x00    ; ch = cylinder (0x0 .. 0x3FF)
                    ; dl = drive number. Our caller sets it
    mov dh, 0x00    ; dh = head number (0x0 .. 0xF)

    ; [es:bx] = pointer to buffer where data is stored
    ; caller sets it up for us
    int 0x13
    jc disk_error

    pop dx
    cmp al, dh  ; al = number of sectors read
    jne sectors_error

    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah      ; ah = error code, dl = disk with error
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error ", 0
SECTORS_ERROR: db "Incorrect number of sectors read ", 0
