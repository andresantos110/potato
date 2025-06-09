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
#define NUM_ITERS 200000
#endif

static struct uart uart0;
static struct timer timer0;
 
void exception_handler(uint32_t mcause, uint32_t mepc, uint32_t sp)
{
	char mcause_c[11], mepc_c[11], sp_c[11];
	int2string(mcause, mcause_c);
	int2string(mepc, mepc_c);
	int2string(sp, sp_c);
	uart_tx_string(&uart0, "mcause: \n\r");
	uart_tx_string(&uart0, mcause_c);

	uart_tx_string(&uart0, "mepc: \n\r");
	uart_tx_string(&uart0, mepc_c);

	uart_tx_string(&uart0, "sp: \n\r");
	uart_tx_string(&uart0, sp_c);
}

int main(void)
{
    // Initialize Timer
    timer_initialize(&timer0, (volatile void *) PLATFORM_TIMER0_BASE);
    timer_reset(&timer0);

    // Initialize Potato UART
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));
	
	
    timer_start(&timer0);

    volatile int a = 0; // volatile to prevent optimization
    volatile int b = 1;
    volatile int c = 1;
    int time = 0;
    
    // This loop will always take the branch (until it exits)
    for (int i = 0; i < 1000; i++) {
        a += i;
    }
    
    // Nested loops with taken branches
    for (int j = 0; j < 500; j++) {
        for (int k = 0; k < 500; k++) {
            b += (j * k);
        }
    }
    
    // Conditional that will always be true
    if (b > 0) {
        c = b * 2;
    }
    
    // Another always-taken branch
    while (c > 0) {
        c--;
    }
    
    // Switch with fall-through cases
    switch (a % 4) {
        case 0: a += 1;  // Fall through
        case 1: a += 2;  // Fall through
        case 2: a += 3;  // Fall through
        default: a += 4;
    }
    
    timer_stop(&timer0);
    time = timer_get_count(&timer0);

    print_s(&uart0, "Clock cycles taken: ");
    print_i(&uart0, time);
    print_s(&uart0, "\n\r");
    
    print_s(&uart0, "A: ");
    print_i(&uart0, a);
    print_s(&uart0, "\n\r");
    
    print_s(&uart0, "B: ");
    print_i(&uart0, b);
    print_s(&uart0, "\n\r");
    
    print_s(&uart0, "C: ");
    print_i(&uart0, c);
    print_s(&uart0, "\n\r");

}

