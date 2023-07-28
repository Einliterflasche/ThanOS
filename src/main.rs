#![no_std]
#![no_main]

pub mod vga;

use core::panic::PanicInfo;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    const VGA_BUFFER: *mut u8 = 0xb8000 as *mut u8;
    const COLOR: u8 = 0x0b;

    for (i, byte) in "Hello, Kernel!".chars().enumerate() {
        unsafe {
            *VGA_BUFFER.offset(i as isize * 2) = byte as u8;
            *VGA_BUFFER.offset(i as isize * 2 + 1) = COLOR;
        }
    }

    loop {}
}

#[panic_handler]
fn panic_handler(_info: &PanicInfo) -> ! {
    loop {}
}