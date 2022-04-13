SRC_DIR = src
TARGET_DIR = target

run: image
	qemu-system-x86_64 $(TARGET_DIR)/image

image: main.bin kernel.bin
	cat $(TARGET_DIR)/main.bin $(TARGET_DIR)/kernel/kernel.bin > $(TARGET_DIR)/$@

main.bin: force_recompile
	nasm -f bin $(SRC_DIR)/main.asm -o $(TARGET_DIR)/$@

kernel.bin: kernel.o kernel_entry.o
	ld -m elf_i386 -o $(TARGET_DIR)/kernel/$@ -Ttext 0x1000 $(TARGET_DIR)/kernel/entry.o $(TARGET_DIR)/kernel/kernel.o --oformat binary

kernel.o:
	gcc -fno-pie -m32 -ffreestanding -c $(SRC_DIR)/kernel/kernel.c -o $(TARGET_DIR)/kernel/$@

kernel_entry.o:
	nasm $(SRC_DIR)/kernel/entry.asm -f elf -o $(TARGET_DIR)/kernel/entry.o

force_recompile:
