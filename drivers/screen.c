#include "../kernel/util.h"

#include "screen.h"


// PRIVATE functions
static inline int getOffset(int row, int col) { return 2 * (row * MAX_COLS + col); }
static inline int getOffsetRow(int offset) { return offset / (2 * MAX_COLS); }
static inline int getOffsetCol(int offset) { return (offset - (getOffsetRow(offset)*2*MAX_COLS))/2; }

static u16 getCursorOffset() {
    u16 offset;

    portByteOut(REG_SCREEN_CTRL_PORT, 14);
    offset = portByteIn(REG_SCREEN_DATA_PORT) << 8;

    portByteOut(REG_SCREEN_CTRL_PORT, 15);
    offset += portByteIn(REG_SCREEN_DATA_PORT);

    return offset * 2;
}

static void setCursorOffset(u16 offset) {
    offset /= 2;
    portByteOut(REG_SCREEN_CTRL_PORT, 14);
    portByteOut(REG_SCREEN_DATA_PORT, (u8)(offset >> 8));
    portByteOut(REG_SCREEN_CTRL_PORT, 15);
    portByteOut(REG_SCREEN_DATA_PORT, (u8)(offset & 0xff));
}

static int printByte(u8 characterByte, u8 attributeByte, u8 row, u8 col) {
    u16 offset;

    if (characterByte == '\n') {
        offset = getOffset(row + 1, 0);
    } else {
        offset = getOffset(row, col) + 2;

        u8 *vidmem = (u8*) VIDEO_ADDRESS;
        vidmem[offset-2] = characterByte;
        vidmem[offset-1] = attributeByte;
    }

    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        // Push text rows up by one
        for (int i = 1; i < MAX_ROWS; i++) {
            u8 *source = (u8*)(getOffset(i, 0) + VIDEO_ADDRESS);
            u8 *dest = (u8*)(getOffset(i-1, 0) + VIDEO_ADDRESS);
            memoryCopy(source, dest, MAX_COLS * 2);
        }

        // Blank out the final row
        u8 *finalRow = (u8*)(getOffset(MAX_ROWS-1, 0) + VIDEO_ADDRESS);
        for (int i = 0; i < MAX_COLS * 2; i++) {
            finalRow[i] = 0;
        }

        offset -= 2 * MAX_COLS;
    }

    setCursorOffset(offset);
    return offset;
}

// PUBLIC functions
void clearScreen() {
    u16 screenSize = MAX_COLS * MAX_ROWS * 2;
    u8 *vidmem = (u8*) VIDEO_ADDRESS;

    for (u16 i = 0; i < screenSize; i += 2) {
        vidmem[i] = ' ';
        vidmem[i+1] = WHITE_ON_BLACK;
    }

    setCursorOffset(getOffset(0,0));
}

void kprintAtOffset(u8 *message, u16 offset) {
    u8 row, col;

    for (u32 i = 0; message[i] != 0; i++) {
        row = getOffsetRow(offset);
        col = getOffsetCol(offset);
        offset = printByte(message[i], WHITE_ON_BLACK, row, col);
    }
}

void kprintAtRowCol(u8 *message, u8 row, u8 col) {
    u16 offset;

    for (u32 i = 0; message[i] != 0; i++) {
        offset = printByte(message[i], WHITE_ON_BLACK, row, col);
        row = getOffsetRow(offset);
        col = getOffsetCol(offset);
    }
}

void kprint(u8 *message) {
    kprintAtOffset(message, getCursorOffset());
}
