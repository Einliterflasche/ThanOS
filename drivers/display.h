// VGA constants
#define VGA_ADDRESS 0xb8000     
#define VGA_MAX_ROWS 25
#define VGA_MAX_COLS 80 
#define VGA_WHITE_ONE_BLACK 0x0f                             
                                                            
// Screen device I/O ports
#define VGA_REG_CTRL 0x3d4
#define VGA_REG_DATA 0x3d5

// Display function declerations
int vga_get_cursor();


