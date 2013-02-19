.global Pause
Pause:
cmp r0,#0
moveq pc,lr

loop$:
sub r0,#1
cmp r0,#0
bne loop$

mov pc,lr

.global LEDInit
LEDInit:
push {lr}
mov r0,#16
mov r1,#1
bl SetGPIOFunction
pop {pc}

.global LEDOn
LEDOn:
push {lr}
mov r0,#16
mov r1,#0
bl SetGPIOPin
pop {pc}

.global LEDOnWait
LEDOnWait:
push {LR}
ldr r0,=0x0007A120 
bl Wait 
bl LEDOn 
ldr r0,=0x0007A120 
bl Wait 
pop {pc}


.global LEDOff
LEDOff:
push {lr}
mov r0,#16
mov r1,#1
bl SetGPIOPin
pop {pc}

