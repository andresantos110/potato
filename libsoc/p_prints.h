#include <stdio.h>
#include <stdint.h>

#include "uart.h"

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

static inline void print_s (struct uart * module, const char * string)
{
	uart_tx_string(module, string);
}

static inline void print_i (struct uart * module, int n)
{
    char string[11];
	int2string(n, &string);
	uart_tx_string(module, string);
}

static inline void print_d (struct uart * module, double d)
{
	int n = (int) d;
	print_i (module, n);
}

static inline void print_c (struct uart * module, char c)
{
	while(uart_tx_fifo_full(module));
	uart_tx (module, c);
}