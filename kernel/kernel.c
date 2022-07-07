#include "../drivers/display.h"

int main() {
    char* msg = "Hello, Kernel! {}";
	int num = 0x12345678;
	print_hex(msg, num);
	return 0;
}
