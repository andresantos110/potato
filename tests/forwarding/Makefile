# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean
include ../common.mk

LINKER_SCRIPT := ../potato.ld
TARGET_LDFLAGS += -Wl,-T$(LINKER_SCRIPT) -Wl,--Map,forward_1.map

OBJECTS := forward_1.o start.o

all: forward_1.elf forward_1.bin forward_1.coe

forward_1.elf: $(OBJECTS)
	$(TARGET_LD) -o forward_1.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) forward_1.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) forward_1.elf forward_1.bin forward_1.coe

# Object file rules:

forward_1.o: forward_1.c ../../platform.h ../../potato.h ../../libsoc/timer.h ../../libsoc/uart.h ../../libsoc/icerror.h ../../libsoc/gpio.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S ../../platform.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

