#include "ports.h"
#include "display.h"

/* Declare local functions */
int calc_offset(int, int);
int calc_row(int);
int calc_col(int);
int print_char_at(char, int, int, char);
void replace_hex(char*, int);

/* Public kernel functions */
void print_at(char* message, int row, int col) {
	for(int i = 0; message[i] != 0; i++) {
		int offset = print_char_at(message[i], row, col, VGA_WHITE_ONE_BLACK);
		row = calc_row(offset);
		col = calc_col(offset);
	}
}

void print(char* message) {
	print_at(message, -1, -1);
}

void print_char(char c) {
	print_char_at(c, -1, -1, VGA_WHITE_ONE_BLACK);
}

/**
 * Print a string but replace the empty curly braces with a number
 */
void print_hex(char* message, int num) {
	for(int i = 0; message[i] != 0; i++) {
		// Check for curly braces
		if (message[i] == '{' && message[i + 1] == '}') {
			// Print the number
			char* temp = "0x00000000";
			replace_hex(temp, num);
			print(temp);
			continue;
		}
		if (message[i] == '}' && message[i - 1] == '{') {
			continue;
		}
		// Otherwise simply print the current character
		print_char(message[i]);
	}
}

/* Local functions */
void replace_hex(char* dest, int num) {
	for(int i = 2; i < 10; i++) {
		char curr = (char) num && 0x00000001;
		curr += '0';
		if (curr <= '9') {
			curr += ('A' - '0');
		}
		dest[i] = curr;
		num = num >> 4;
	}
}

int print_char_at(char character, int row, int col, char attribute) {
    unsigned char * video_mem = (unsigned char*) VGA_ADDRESS;
    
    if (!attribute) {
        attribute = VGA_WHITE_ONE_BLACK;
    }

    int offset;
    if (col >= 0 && row >= 0) {
        offset = calc_offset(row, col);
    } else {
        offset = get_cursor_offset();
		col = calc_col(offset);
		row = calc_row(offset);
    }

	// Check for '\n'
	if (character == 0xA) {
		row = calc_row(offset) + 1;
		offset = calc_offset(0, row);
	} else {
		*(video_mem + offset) = character;
		*(video_mem + offset + 1) = attribute;
		offset += 2;
	}

	set_cursor_offset(offset);
	return offset;
}

int get_cursor_offset() {
    // The cursor is stored in VGA Data 14 and 15
   
    // Get the low byte
    port_send_byte(VGA_REG_CTRL, 14);
    int offset = port_recv_byte(VGA_REG_DATA) << 8;

    // Get the high byte
    port_send_byte(VGA_REG_CTRL, 15);
    offset += port_recv_byte(VGA_REG_DATA);

    // Since the VGA need 2 bytes for every cell multiply by 2
    return offset*2;
}

void set_cursor_offset(int offset) {
    // VGA needs 2 bytes per cell
    offset /= 2;

    // Set low byte
    port_send_byte(VGA_REG_CTRL, 14);
    port_send_byte(VGA_REG_DATA, (unsigned char)(offset >> 8));

    // Set high byte
    port_send_byte(VGA_REG_CTRL, 15);
    port_send_byte(VGA_REG_DATA, (unsigned char)(offset & 0xff));
}

int calc_offset(int row, int col) {
	return 2 * (row * VGA_MAX_COLS + col);
}

int calc_row(int offset) {
	return offset / (2 * VGA_MAX_COLS);
}

int calc_col(int offset) {
	return (offset - (calc_row(offset) * 2 * VGA_MAX_COLS)) / 2;
}
