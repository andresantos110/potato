
#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "potato.h"
#include "icerror.h"
#include "uart.h"
#include "p_prints.h"

#define APP_START (0x00000000)
#define APP_LEN   (0x20000)
#define APP_ENTRY (0x00000000)


#ifndef NUM_ITERS
#define NUM_ITERS 200000
#endif

static struct uart uart0;

void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	while(uart_tx_fifo_full(&uart0));
	uart_tx(&uart0, 'E');
}

int main(void)
{
    // Initialize Potato UART
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));
    
    for(int i = 0; i < 10; i++)
    {
    	uart_tx(&uart0, 'a');
    }
}
