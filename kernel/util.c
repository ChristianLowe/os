#include "util.h"

void memoryCopy(u8* source, u8* dest, u32 byteCount) {
    for (u32 i = 0; i < byteCount; i++) {
        dest[i] = source[i];
    }
}

void intToAscii(int n, u8 *str) {
    int sign = n;

    if (sign < 0) {
        n = -n;
    }

    u32 i;
    for (i = 0; n > 0; i++) {
        str[i] = n % 10 + '0';
        n /= 10;
    }

    if (sign < 0) {
        str[i++] = '-';
    }
    
    str[i] = 0;
}
