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
	ld -m elf_i386 -s -o $@ -Ttext 0x1e00 $^ --oformat binary

%.o: %.c ${HEADERS} force_recompile
	i686-elf-gcc -m32 -Os -ffreestanding -fno-pie -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm 
	nasm $< -f bin -o $@

clean:
	find . -type f \( -name "*.bin" -or -name "*.o" -or -name "*.dis" -or -name "image" \) -delete

force_recompile:
