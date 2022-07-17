#include <cmn/typedef.h>
#include <drivers/display.h>

#ifdef __linux__
#warn "`__linux__` is defined, not using a cross compiler. Proceed with caution"
#endif

void main() {
	print("Hello, Kernel!\n");
}

