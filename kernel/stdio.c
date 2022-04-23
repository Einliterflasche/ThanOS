volatile char* VIDEO_MEMORY = (volatile char*) 0xb8000;

void print(char* string) {
    *VIDEO_MEMORY = 'X';
    while (*string != 0) {
        *VIDEO_MEMORY++ = *string++;
        *VIDEO_MEMORY++ = 0x0f;
    }
}
