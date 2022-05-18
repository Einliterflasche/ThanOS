unsigned char port_recv_byte(unsigned short port) {
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_send_byte(unsigned short port, unsigned char data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

unsigned char port_recv_word(unsigned short port) {
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void port_send_word(unsigned short port, unsigned char data) {
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
