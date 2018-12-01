#include "../drivers/screen.h"
#include "../drivers/ports.h"

#include "util.h"

void main() {
    clearScreen();

    for (int i = 0; i < 24; i++) {
        u8 str[255];
        intToAscii(i, str);
        kprintAtRowCol(str, i, 0);
    }

    kprintAtRowCol("This text forces the kernel to scroll. Row 0 will disappear. ", 24, 60);
    kprint("And with this text, the kernel will scroll again, and row 1 will dissapear too!");
}
