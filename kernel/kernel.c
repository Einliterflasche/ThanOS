void main() {
    char* video_memory = (char*) 0xb809e;
    *video_memory = 'H';
    video_memory += 2;
    *video_memory = 'i';
}
