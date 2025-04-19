// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"

void exception_handler(uint32_t cause, void * epc, void * regbase)
{

}

int main(void)
{
	int i = 0;
	int a = 0;

	/* Read application from UART and store it in RAM */
	for(i = 0; i < 200; i++){
		while(a<100){
			a++;
		}	
	}

	return 0;
}

