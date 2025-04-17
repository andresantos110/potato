// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"
#include "uart.h"

static struct uart uart0;

void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	while(uart_tx_fifo_full(&uart0));
	uart_tx(&uart0, 'E');
}

int main(void)
{
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));

	/* Print welcome message */
	uart_tx_string(&uart0, "\n\r** Before For **\n\r");

	/* Read application from UART and store it in RAM */
	for(int i = 0; i < 200; i++){
		uart_tx_string(&uart0, "\n\r** Inside For **\n\r");

		/* Print some dots */
		if(i > 100) uart_tx_string(&uart0, "\n\r** If **\n\r");
	}

	/* Print booting message */
	uart_tx_string(&uart0, "\n\rAfter For\n\r"); 

	return 0;
}

