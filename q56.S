		.section .rodata
str:	.string	"Hi!\n"
		.text
		.type	main, %function
		.global	main
main:	stp		x29, x30, [sp, #-16]!
		mov		x29, #0
loop:	adr		x0, str
		bl		printf
		add		x29, x29, #1
		cmp		x29, #10
		blt		loop
		ldp		x29, x30, [sp], #16
		ret
		.size	main, (. - main)
