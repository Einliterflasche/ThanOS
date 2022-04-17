void main() {
    volatile char* video_memory = (volatile char*) 0xb8000;
    const char* msg = "Hello, World!";
    const char single_char = 'X';
    
    while (*msg != 0) {
        *video_memory++ = *msg++;
        *video_memory++ = 0x0a;
    }

    video_memory += 2;
    *video_memory = single_char;
}
