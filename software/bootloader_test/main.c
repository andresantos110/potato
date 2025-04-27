// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"
#include "uart.h"

#define APP_START (0x00000000)
#define APP_LEN   (0x20000)
#define APP_ENTRY (0x00000000)

static struct uart uart0;

void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	// Not used in this application
}

int main(void)
{

	int a = 0;
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));
teste:
	uart_tx_string(&uart0, "Hello world\n\r");
		
		
	while (a<10){
		a++;
		goto teste;
	}
	
	return 0;
}
