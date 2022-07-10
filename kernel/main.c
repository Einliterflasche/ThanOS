#include "../drivers/display.h"

#if defined(__linux__)
#warning "`__linux__` is defined: not using a cross compiler"
#endif

void main() {
	char* msg = "Hello, Kernel! Here is a number: {}";
	unsigned int num = 0x1234abcd;
	print_hex(msg, num);
}

