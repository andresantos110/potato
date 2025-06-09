# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean
include ../common.mk

LINKER_SCRIPT := ../potato.ld
TARGET_LDFLAGS += -Wl,-T$(LINKER_SCRIPT) -Wl,--Map,branch_1.map

OBJECTS := branch_1.o start.o

all: branch_1.elf branch_1.bin branch_1.coe

branch_1.elf: $(OBJECTS)
	$(TARGET_LD) -o branch_1.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) branch_1.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) branch_1.elf branch_1.bin branch_1.coe

# Object file rules:

branch_1.o: branch_1.c ../../platform.h ../../potato.h ../../libsoc/timer.h ../../libsoc/uart.h ../../libsoc/icerror.h ../../libsoc/gpio.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S ../../platform.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

