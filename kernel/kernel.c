#include "stdio.h"

void main() {
    volatile char* VIDEO_MEM = (volatile char*) 0xb8000;
    char* msg = "Hello World from kernel!";

    while (*msg != 0) {
        *VIDEO_MEM++ = *msg++;
        *VIDEO_MEM++ = 0x0a;
    }
}
