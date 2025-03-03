/*
 ****************************************************************************
 *
 * This file contains a simple program with heavy data dependecies to analyze
 * the effect of forwarding.
 *
 ****************************************************************************
 */

 #include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "potato.h"
#include "icerror.h"
#include "uart.h"
#include "timer.h"
#include "p_prints.h"

static struct uart uart0;
static struct timer timer0;
 
void exception_handler()
{
// Not used in this application
}

int main(void)
{
    // Initialize Timer
    timer_initialize(&timer0, (volatile void *) PLATFORM_TIMER0_BASE);
    timer_reset(&timer0);

    // Initialize Potato UART
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));

    int a, b, c, d, time;

    a = 10;
    b = 20;

    timer_start(&timer0);

    c = a + b;

    a = c + b; // Read after write on c
    b = c + c; // Read after write on c
    d = a + b; // Read after write on a and b
    d = d + d; // Read after write on d

    timer_stop(&timer0);
    time = timer_get_count(&timer0);

    print_s(&uart0, "Clock cycles taken: ");
    print_i(&uart0, time);
    print_s(&uart0, "\n\r");

	return 0;
}