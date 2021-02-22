/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
// rgbpixel
		.equ	i_red,	0
		.equ	i_green,1
		.equ	i_blue, 2
		.equ	i_size,	3

// image ( rgb and gray structs )
		.equ	rows,	0 // pointer to array of pointers
		.equ	width,	8 // number of columns ( length of each row )
		.equ	height, 12 // number of rows ( length of array of pointers )
		.equ	size,	20

	.global	color_to_gray
color_to_gray:
	/* Fill in the code to allocate a new grayimage, then convert
	   each pixel from the given rgbimage from color to grayscale,
	   and store it in the grayimage. */

		mov		x3, [x0, #rows]			// get pointer to rgb rows
		mov		w1, [x0, #width]		// get width
		mov		w2, [x0, #height]		// get height
		mov		w0, w1					// params for alloc_gray
		mov		w1, w2
		bl		allocate_grayimage
		// x0 now contains the pointer to the gray image

		ldr		x4, x0					// get pointer to gray rows

		mov		w6, #0					// j = 0
loopi:	mov		w5, #0					// i = 0
		ldr		x7, [x6, w5 lsl #i_size]			// load the gray pixel array
		ldr		x8, [x3, w5 lsl #i_size]			// load the rgb pixel array
loopj:
		ldr		x9, x7, [w6, lsl #size]	// load the gray pixel
		ldr		x10, x8, [w6, lsl #size]// load the rgb pixel

		// load the rgb pixel values
		mov		x11, [x10, #i_red]
		mov		x12, [x10, #i_green]
		mov		x13, [x10, #i_blue]

		// calculate the gray pixel values based on the rgb pixel values
		mul		x11, x11, #54			// 54r
		madd	x12, x11, x12, #184		// 54r + 184g
		madd	x13, x12, x13, #18		// 54r + 184g + 18b

		lsr		x13, x13, #8			// divide the result by 256

		mov		x9, x13					// gray pixel value

		// while j < width
		add		w6, w6, #1
		cmp		w6, w1
		blt		loopj

		// while i < height
		add		w5, w5, #1
		cmp		w5, w2
		blt		loopi


		// x0 contains the gray image to return
		ret
