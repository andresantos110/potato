# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015-2023 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean
include ../common.mk

LINKER_SCRIPT := ../potato.ld
TARGET_LDFLAGS += -Wl,-T$(LINKER_SCRIPT) -Wl,--Map,dhrystone.map

OBJECTS := main.o start.o

all: dhrystone.elf dhrystone.bin dhrystone.coe

dhrystone.elf: $(OBJECTS) $(LINKER_SCRIPT)
	$(TARGET_LD) -o dhrystone.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) dhrystone.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) dhrystone.elf dhrystone.bin dhrystone.coe dhrystone.map

# Object file rules:

main.o: dhry_1.c dhry.h ../../platform.h ../../potato.h ../../libsoc/timer.h ../../libsoc/uart.h ../../libsoc/icerror.h ../../libsoc/gpio.h
	riscv32-unknown-elf-gcc -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S ../../platform.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

