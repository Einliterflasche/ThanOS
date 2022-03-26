SRC_DIR = src
TARGET_DIR = target

main.bin:
	nasm -f bin $(SRC_DIR)/main.asm -o $(TARGET_DIR)/main.bin

run:
	qemu-system-x86_64 $(TARGET_DIR)/main.bin
