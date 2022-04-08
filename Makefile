SRC_DIR = src
TARGET_DIR = target

main.bin: force
	nasm -f bin $(SRC_DIR)/main.asm -o $(TARGET_DIR)/main.bin

run: main.bin
	qemu-system-x86_64 $(TARGET_DIR)/main.bin

force:
