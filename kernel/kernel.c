void print(char* msg) {
    int** cursor = (int**) 0xb7f0;
    *cursor = 0xb8000;
    int* current = *current;
    *current = 'X';
}

void main() {
    char* msg = "Hello World from kernel!";
    print(msg);
}
