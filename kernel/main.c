#include "../drivers/display.h"

void main() {
    char* msg = "Hello, Kernel! {}";
	int num = 0x123B5678;
	print_hex(msg, num);
}
