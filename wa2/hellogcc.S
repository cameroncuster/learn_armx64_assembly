	.data

msg:	.ascii "Hello World!\n"
len		= . - msg

	.text

.globl main

main:
	str		lr, [sp, #-16]!
	ldr		x0, =msg
	bl		printf
	mov		x0, #0
	ldr		lr, [sp], #16
	ret
.end
