.section .init
.global _start
_start:

/* branch to main */

b main

/* text section is placed at 0x8000, so we can set the stack pointer to that address */
.section .text
main:

mov sp,#0x8000
/*
bl LEDInit
bl LEDOff

bl LEDOnWait
bl LEDOff
*/

bl InitFrameBuffer

loop$:
bl Render
b loop$

