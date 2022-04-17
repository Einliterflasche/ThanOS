void main() {
    char* video_memory = (char*) 0xb8000;
    const char* msg = "Hello, World!";
    for (int i = 0; msg[i] != 0; i++) {
        *video_memory = msg[i];
        video_memory += 2;
    }
    video_memory += 2;
    *video_memory = 'X';
}
