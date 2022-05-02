void print(char* msg) {
    // This the address in memory where the cursor is stored
    const char** CURSOR_LOC = (const char**) 0xb7f0;

    // Init cursor at top left corner if it has not been inited yet
    if (*CURSOR_LOC <= (char*) 0xb8000) 
        *CURSOR_LOC = (char*) 0xb8000;
   
    // Get current cursor
    char* cursor = (char*) *CURSOR_LOC;

    // Write the string with the current cursor
    while (*msg != 0) {
        *cursor++ = *msg++;
        *cursor++ = 0x0f;
    } 

    // Store the new cursor in memory
    *CURSOR_LOC = cursor;
}

void main() {
    char* msg = "Hello, kernel!";
    print(msg);
}
