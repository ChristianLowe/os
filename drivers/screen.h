#pragma once

#include "ostypes.h"
#include "ports.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL_PORT 0x3d4
#define REG_SCREEN_DATA_PORT 0x3d5

// Exported functions
void clearScreen();
void kprintAtOffset(u8 *message, u16 offset);
void kprintAtRowCol(u8 *message, u8 row, u8 col);
void kprint(u8 *message);
