print:
    pusha
    mov ah, 0x0E

print_start_loop:
    mov al, [bx]
    cmp al, 0
    je print_done

    int 0x10

    add bx, 1
    jmp print_start_loop

print_done:
    popa
    ret


print_nl:
    pusha

    mov ah, 0x0E
    mov al, 0x0A
    int 0x10
    mov al, 0x0D
    int 0x10

    popa
    ret
