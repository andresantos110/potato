# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean
include ../common.mk

TARGET_LDFLAGS += -Wl,-Tbootloader.ld -Wl,--Map,bootloader.map

OBJECTS := main.o md5.o start.o

all: bootloader.elf bootloader.bin bootloader.coe

bootloader.elf: $(OBJECTS)
	$(TARGET_LD) -o bootloader.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) bootloader.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) bootloader.elf bootloader.bin bootloader.coe

# Object file rules:

main.o: main.c md5.h ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

md5.o: md5.c md5.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<
	
start.o: ../start.S
	$(TARGET_CC) -DCOPY_DATA_TO_RAM -c -o $@ $(TARGET_CFLAGS) $<

