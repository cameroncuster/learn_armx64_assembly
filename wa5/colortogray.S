/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
		.equ	i_red,	0
		.equ	i_green,1
		.equ	i_blue, 2
		.equ	i_size,	3
		.equ	width,	100
		.equ	height,	100

	.global	color_to_gray
color_to_gray:
	/* Fill in the code to allocate a new grayimage, then convert
	   each pixel from the given rgbimage from color to grayscale,
	   and store it in the grayimage. */

		mov		x3, [x0] // get pointer to rows
		mov		w1, [x0, #8] // get width
		mov		w2, [x0, #12] // get height
		mov		w0, w1 // params for alloc_gray
		mov		w1, w2
		bl		allocate_grayimage
		// x0 now contains the pointer to the gray image
		mov		w5, #0 // j = 0
loopi:	mov		w4, #0 // i = 0
loopj:
		// perform the operations here

		ret
