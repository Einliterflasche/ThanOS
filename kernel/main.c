#include "../drivers/display.h"

#if defined(__linux__)
#warn "`__linux__` is defined, not using a cross compiler. Proceed with caution"
#endif

void main() {
	print("Hello, Kernel!\n");
}

