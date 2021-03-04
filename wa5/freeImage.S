		.equ	rows, 0
		.equ	width, 8
		.equ	height, 12
		.global freeImage // freeImage( rgbimage *image )->void
freeImage:
		stp		x29, x30, [sp, #-32]!
		stp		x19, x20, [sp, #16]

		ldr		x19, [x0, #rows]
		ldr		w20, [x0, #height]

		bl		free

loop:
		cmp		x20, #0
		beq		end
		sub		x20, x20, #1
		ldr		x0, [x19, x20, lsl #3]
		bl		free
		b		loop

end:
		mov		x0, x19
		bl		free
		ldp		x19, x20, [sp, #16]
		ldp		x29, x30, [sp], #32
		mov		x19, x0
		ret
		.size freeImage, (. - freeImage)
