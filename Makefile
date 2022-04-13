SRC_DIR = src
TARGET_DIR = target

main.bin: force_recompile
	nasm -f bin $(SRC_DIR)/main.asm -o $(TARGET_DIR)/main.bin

run: main.bin
	qemu-system-x86_64 $(TARGET_DIR)/main.bin

ru:
	echo "countries["russia"].annex(unpack(ex_soviet_countries));"

force_recompile:
