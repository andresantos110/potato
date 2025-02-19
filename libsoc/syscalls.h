// Implementation of system calls for use in bare metal applications

#include <stdio.h>
#include <stdint.h>

#include "uart.h"

/**
 * Transmits a byte over the UART.
 * This function does not check if the UART buffer is full; use the @ref uart_tx_ready()
 * function to check if the UART can accept more data. ONLY SUPPORTS ONE VARIABLE.
 * @param module Instance object.
 * @param string   Pointer to the string to send.
 */
static inline void printf_potato (struct uart * module, const char * string, )
{
    for(uint32_t i = 0; string[i] != 0; ++i)
	{
        if(string[i] != '%')
        {
            while(uart_tx_fifo_full(module));
		    uart_tx(module, string[i]);
            continue;
        }
		switch(string[++i])
        {
            case 'd':

            case 's':

            case 'f':

            case 'c':
        }
	}


}