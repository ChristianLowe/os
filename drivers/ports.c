
#include "ostypes.h"

u8 portByteIn(u16 port) {
    u8 result;
    asm("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void portByteOut(u16 port, u8 data) {
    asm("out %%al, %%dx" : : "a" (data), "d" (port));
}

u16 portWordIn(u16 port) {
    u16 result;
    asm("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void portWordOut(u16 port, u16 data) {
    asm("out %%ax, %%dx" : : "a" (data), "d" (port));
}
