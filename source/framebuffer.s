.global InitFrameBuffer
InitFrameBuffer:
push {lr}

fbInfo .req r5
ldr fbInfo,=FrameBufferInfo
mov r0,fbInfo
mov r1,#1
bl SendMailBoxMessage

/*bl LEDOnWait
bl LEDOff*/

mov r0,#1
bl ReadMailBoxMessage

/* if we didn't get 0 back then there's been a problem */
teq r0,#0
movne r0,#0
popne {pc}

/* loop until we have a non-zero pointer */
loop$:
/*
bl LEDOnWait
bl LEDOff
*/
ldr r0,[fbInfo,#32]
teq r0,#0

beq loop$

/* We've got a pointer!" */
mov r0,fbInfo
pop {pc}

.section .data
.align 12
.global FrameBufferInfo
FrameBufferInfo:
.int 1024
.int 768
.int 1024
.int 768
.int 0 /* pitch */
.int 16 /* bit depth */
.int 0 /* x offset */
.int 0 /* y offset */
.int 0 /* framebuffer pointer */
.int 0 /* framebuffer size */
