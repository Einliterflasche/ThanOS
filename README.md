# SauceOS
This project is not supposed to be any good, I am just experimenting with OS development.

## Progress
 - Bootloader which 
     - switches to 32-bit protected mode 
	 - loads the kernel
 - Very basic VGA display driver

## Build it yourself

### Requirements
 - `nasm` for compiling the assembly code
 - `build-essentials` for linking
 - `i686-elf-gcc` for compiling the C code. This is a GCC cross compiler configured for the `i686-elf` target. If you have not already, you will need to [build it yourself](wiki.osdev.org/GCC_Cross-Compiler)
 - `qemu-system-x86_64` for emulating the OS (optional)

### Steps
 - First run `make image` which will output the full os image into the root directory
 - You can run this image on an emulator of your choice. If you chose QEMU you may run `make run` to start the emulation. This also automatically (re-)builds the image.

