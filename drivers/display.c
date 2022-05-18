#include "ports.h"
#include "display.h"

void print_char(char character, int row, int col, char attribute) {
    unsigned char * video_mem = (unsigned char*) VGA_ADDRESS;
    
    if (!attribute) {
        attribute = VGA_WHITE_ONE_BLACK;
    }

    int offset;
    if (col >= 0 && row >= 0) {
        offset = 0;
    } else {
        offset = vga_get_cursor();
    }
}

int vga_get_cursor() {
    // Reg 14 is the low byte of the cursor
    // Get the low byte
    port_send_byte(VGA_REG_CTRL, 14);
    int offset = port_recv_byte(VGA_REG_DATA) << 8;
    // Reg 15 is the high byte of the cursor
    // Get the high byte
    port_send_byte(VGA_REG_CTRL, 15);
    offset += port_recv_byte(VGA_REG_DATA);
    // Since the VGA need 2 bytes for every cell multiply by 2
    return offset*2;
}

void set_cursor(int offset) {
    // VGA needs 2 bytes per cell
    offset /= 2;
    // Set low byte
    port_send_byte(VGA_REG_CTRL, 14);
    // TODO
    // Set high byte
}
