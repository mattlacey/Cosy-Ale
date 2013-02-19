.global Render
Render:


x .req r1
y .req r2
colour .req r3
fb .req r4

push {lr}

mov colour,#0

loopMain$:
	ldr fb,[r0,#32]
	mov x,#1024

	loopx$:
		mov y,#768
		loopy$:
			strh colour,[fb]
			add fb,#2

			sub y,#1
			cmp y,#0
			bhi loopy$

		sub x,#1
		cmp x,#0
	bhi loopx$

	add colour,#1

b loopMain$

.unreq x
.unreq y
.unreq colour
.unreq fb

pop {pc}
