// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"
#include "uart.h"

#include "md5.h"

#define APP_START (0x00000000)
#define APP_LEN   (0x20000)
#define APP_ENTRY (0x00000000)

static struct uart uart0;

static void int2string(int n, char * s)
{
	bool first = true;

	if(n == 0)
	{
		s[0] = '0';
		s[1] =  0;
		return;
	}

	if(n & (1u << 31))
	{
		n = ~n + 1;
		*(s++) = '-';
	}

	for(int i = 1000000000; i > 0; i /= 10)
	{
		if(n / i == 0 && !first)
			*(s++) = '0';
		else if(n / i != 0)
		{
			*(s++) = '0' + n / i;
			n %= i;
			first = false;
		}
	}
	*s = 0;
}

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
	uart_tx_string(&uart0, "\n\r** Potato Bootloader - waiting for application image **\n\r");

	int application_md5[16];
	char string_md5[11];
	MD5Context ctx;
	md5Init(&ctx);

	/* Read application from UART and store it in RAM */
	for(int i = 0; i < APP_LEN; i++){
		while(uart_rx_fifo_empty(&uart0));
		*((volatile uint8_t*)(APP_START + i)) = uart_rx(&uart0);
		md5Update(&ctx, (uint8_t *)(APP_START + i), 1);

		/* Print some dots */
		if(((i & 0x7ff) == 0) && !uart_tx_fifo_full(&uart0))
			uart_tx(&uart0, '.');
	}
	md5Finalize(&ctx);
	memcpy(application_md5, ctx.digest, 16);
	int2string(application_md5, string_md5);
	uart_tx_string(&uart0, "\n\rMD5: ");
	uart_tx_string(&uart0, string_md5);

	/* Print booting message */
	uart_tx_string(&uart0, "\n\rBooting\n\r");

	/* Jump in RAM */
	goto *APP_ENTRY;

	return 0;
}

