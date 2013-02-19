/* MailBox address details:
  4B Read @ 0x2000B880, 4B Poll @2000B890, 4B Sender, 4B Status, 4B Configuration, 4B Write

  The low 4 bits of a message are used for the mailbox channel */

.global GetMailBoxAddress
GetMailBoxAddress:
ldr r0,=0x2000B880
mov pc,lr


.global SendMailBoxMessage
SendMailBoxMessage:
/* r0 = Message, r1 = Mailbox */

msg .req r0
box .req r1

/* tst performs a logical AND and then compares with 0
   Check the message isn't using the low four bits */
tst msg,#0b1111
movne pc, lr

/* MailBox can be 0-6 */ 
cmp box,#15
movhi pc, lr

/* Have to wait for Status to have 0 in the top bit */
orr box,msg
.unreq msg
.unreq box
msg .req r1

push {lr}
bl GetMailBoxAddress
mbox .req r0
status .req r2

loop$:
ldr status,[mbox,#0x18]
tst status,#0x8000000
bne loop$

.unreq status

/* Write the message */
str msg,[mbox,#0x20]
.unreq mbox
pop {pc}


.global ReadMailBoxMessage
ReadMailBoxMessage:
/* r0 should be the mailbox to read */

tst r0,#15
movhi pc,lr

mov r2,r0
box .req r2

push {lr}
bl GetMailBoxAddress

mbox .req r0

/* 30th bit must be zero */
loop2$:
status .req r1
ldr status,[mbox,#0x18]
tst status,#0x4000000
bne loop2$

.unreq status
mail .req r1
/* read from the read field */
ldr mail,[mbox]

/* check the channel matches */
channel .req r3
and channel,mail,#0b1111
teq channel,box
bne loop2$

.unreq mbox
.unreq box
.unreq channel

and r0,mail,#0xfffffff0
.unreq mail

pop {pc}
