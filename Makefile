TARGET_DIR = target

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ_FILES = ${C_SOURCES:.c=.o}
	
run: image
	qemu-system-x86_64 image
	make clean

image: boot/main.bin kernel.bin
	cat $^ > $@

main.bin: force_recompile
	nasm -f bin $(SRC_DIR)/main.asm -o $(TARGET_DIR)/$@

kernel.bin: kernel/kernel_entry.o ${OBJ_FILES}
	ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS} force_recompile
	gcc -m32 -fno-pie -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm 
	nasm $< -f bin -o $@

force_recompile:

clean:
	rm -fr *.bin *.dis *.o image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
