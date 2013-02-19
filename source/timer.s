.global Wait
Wait:
/* Argument: r0 - time to wait in micro-seconds */
pause .req r0
timer .req r1

ldr timer,=0x20003000
/* Read in the 8 byte timer value */
ldrd r2,r3,[timer,#4]

/* upper 4 bytes are in r3 so who only need worry about r2 */
add pause,r2

loop$:
ldrd r2,r3,[timer,#4]
cmp pause,r2
bhi loop$

.unreq pause
.unreq timer

mov pc,lr
