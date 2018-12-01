# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
C_HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os-image.bin

run: os-image.bin
	qemu-system-i386 -fda $<

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -S -fda os-image.bin &
	i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

clean:
	rm -rf *.bin *.o *.dis os-image.bin
	rm -rf kernel/*.o boot/*.bin drivers/*.o

os-image.bin: boot/boot_sector.bin kernel.bin
	cat $^ > os-image.bin

kernel.bin: kernel/entrypoint.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: kernel/entrypoint.o ${OBJ}
	i386-elf-ld -g -o $@ -Ttext 0x1000 $^

%.o: %.c ${C_HEADERS}
	i386-elf-gcc -g -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@
