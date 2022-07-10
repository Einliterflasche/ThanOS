#include "../drivers/display.h"

#if defined(__linux__)
#warning "`__linux__` is defined; not using cross compiler"
#endif

void main() {
    char* msg = "Hello, Kernel! {}";
	int num = 0x123B5678;
	print_hex(msg, num);
}
