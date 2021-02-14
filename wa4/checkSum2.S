		.data
buffer:	.byte	0
		.skip	4096
		.align	2 // required on the pi
i:		.word	0
		.align	2
sum:	.word	0

		.section .rodata
str1:	.asciz  "Enter text (ctrl-D to end): "
		.align 2

str2:	.asciz "%s\n"
		.align 2

str3:	.asciz "\nThe checksum is %08X\n"
		.align 2
		
		.text
		.type	checkSum, %function
checksum:
		// values
		mov		w3, #0 // sum
loopsum:
		// sum += buffer[i++]
		ldrb	w2, [x0] // set buffer[i]
		add		w3, w3, w2 // sum += buffer[i]
		add		x0, x0, #1 // i++
		cmp		w2, #0 // buffer[i] == 0
		bne		loopsum // loop

		mov		w0, w3 // ret val
		ret
		.size	checksum, (. - checksum)

		.type	main, %function
		.global main
main:
		// allocate some non-volatile registers to use from the stack
		stp		x29, x30, [sp, #-16]!
		stp		x19, x20, [sp, #-16]!
		stp		x21, x22, [sp, #-16]!
		stp		x23, x24, [sp, #-16]!

		// load values i and address of buffer
		ldr		x19, i
		adr		x20, buffer
		ldr		x21, [x20]

		// print instructions
		adr		x0, str1
		bl		printf

loop:
		// getchar until -1
		bl		getchar
		str		x0, [x20, x19]
		cmp		w0, #-1
		add		x19, x19, #1
		bne		loop

		// buffer[i] = 0
		str		xzr, [x20, x19]

		// print buffer
		adr		x0, str2
		mov		x1, x20
		bl		printf

		// sum of buffer
		mov		x0, x20
		bl		checksum

		// print the sum of checksum
		mov		x1, x0
		adr		x0, str3
		bl		printf

		// call and print again and the value of sum will be double -> intentional error
		// sum of buffer
		mov		x0, x20
		bl		checksum

		// print the sum of checksum
		mov		x1, x0
		adr		x0, str3
		bl		printf
		
		// return 0 and restore the non-volatile registers
		mov		w0, #0
		ldp		x23, x24, [sp], #16
		ldp		x21, x22, [sp], #16
		ldp		x19, x20, [sp], #16
		ldp		x29, x30, [sp], #16
		ret
		.size	main, (. - main)
