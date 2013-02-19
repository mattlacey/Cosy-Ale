.global GetGPIOAddress
GetGPIOAddress:
ldr r0,=0x20200000
mov pc,lr

.global SetGPIOFunction
SetGPIOFunction:
/* r0 is the PIN,0-53
   r1 is the function,0-7
*/
cmp r0,#53
cmpls r1,#7
movhi pc,lr

/* store lr so we can call another funciton */
push {r4,lr}

/* save r0 into r2,since GetGPIOAddress doesn't use r2 but overwrites r0 */
mov r2,r0
bl GetGPIOAddress

/* There are 54 GPIO pins,function select uses 4 bytes for each group of 10. 3 bits per pin,10 per group
   So we have to add 4 bytes onto the GPIO address for the second bank of 10 (10-19) etc.
   r2 now holds the pin number */

loop$:
  cmp r2,#9
  subhi r2,#10
  addhi r0,#4
  bhi loop$

/* r2 now has a number from 0-9 indicating the pin in the bank,3 bits per pin so we need to multiply 3 for a shift */
add r2,r2,lsl #1

/* shift the function by the number of bits */
lsl r1,r2

/* need to store the 3 bits we're interested without blazing the others away */
mov r3,#0x00000007
lsl r3,r2
mvn r4,r3
orr r1,r4
str r1,[r0]

/* pop the top of the stack back into the program counter (return address was stored above) */
pop {r4,pc}


.global SetGPIOPin
SetGPIOPin:
/* set some aliases */
pin .req r0
val .req r1

cmp pin,#53
movhi pc,lr

push {lr}

/* move pin to r2 and swap the alias */
mov r2,pin
.unreq pin
pin .req r2

/* get the GPIO address */
bl GetGPIOAddress
gpio .req r0

/* there are two sets for four bytes used for turning pins on and off, so if pin number is > 31 we're in the second bank */
cmp pin,#32
addhi gpio,#4

/* pin number mod 32 is the bit to modify */
and pin,#31
mov r3,#1
lsl r3,pin

/* see if the value is zero or not */
teq val,#0
streq r3,[gpio,#40]
strne r3,[gpio,#28]
.unreq pin
.unreq val

pop {pc}


