		.data
n:		.word   0
m:		.dword  0
i:		.word   0
j:		.dword  0

		.section .rodata
str1:	.asciz  "%d"
		.align 2

str2:	.asciz "The sum is: %d\n"
		.align 2

str3:	.asciz "%ld"
		.align 2

		.text
		.globl main

main:
	str lr, [sp, #-16]!

	adr x0, str1
	adr x1, n
	bl scanf

	ldr w19, n

	adr x0, str1
	adr x1, i
	bl scanf

	ldr w20, i

	adr x0, str2
	add w1, w19, w20
	bl printf

	adr x0, str3
	adr x1, m
	bl scanf

	ldr x19, m

	adr x0, str3
	adr x1, j
	bl scanf

	ldr x20, j

	adr x0, str2
	add x1, x19, x20
	bl printf

	ldr lr, [sp], #16
	mov x0, #0
	ret
	.end
