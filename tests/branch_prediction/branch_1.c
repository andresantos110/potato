/*
****************************************************************************
*
* This file contains a simple program with several branch instructions to
* analyze the effect of branch prediction.
*
* Compile using -O0 to avoid compiler optimizations.
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

#ifndef NUM_ITERS
#define NUM_ITERS 20000
#endif

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

    int a, time;

    a = 0;

    timer_start(&timer0);

    for(int i = 0; i<NUM_ITERS; i++)
        a++;

    timer_stop(&timer0);
    time = timer_get_count(&timer0);

    print_s(&uart0, "Clock cycles taken: ");
    print_i(&uart0, time);
    print_s(&uart0, "\n\r");

}

