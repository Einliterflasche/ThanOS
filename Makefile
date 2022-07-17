ROOT_DIR = $(shell pwd)

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ_FILES = ${C_SOURCES:.c=.o}
	
run: image
	qemu-system-x86_64 -drive file=image,format=raw -display curses
	make clean

image: boot/bootloader.bin kernel/main.bin
	cat $^ > $@

boot/bootloader.bin: boot/entry.bin boot/main.bin
	cat $^ > $@

kernel/main.bin: boot/kernel_entry.o ${OBJ_FILES}
	i686-elf-ld -s -o $@ -Ttext 0x1e00 $^ --oformat binary

%.o: %.c ${HEADERS} force_recompile
	i686-elf-gcc -I$(ROOT_DIR) -L$(ROOT_DIR) -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm 
	nasm $< -f bin -o $@

clean:
	rm -rf **/*.bin **/*.o image

force_recompile:
