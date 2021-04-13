/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
        // rgbpixel
        .equ    i_red,  0
        .equ    i_green,1
        .equ    i_blue, 2
        .equ    i_size, 3

        // image ( rgb and gray structs )
        .equ    rows,   0                   // pointer to array of pointers
        .equ    width,  8                   // number of columns ( length of each row )
        .equ    height, 12                  // number of rows ( length of array of pointers )
        .equ    size,   16

    .global color_to_gray                   // grayimage *color_to_gray(rgbimage *)
color_to_gray:
    /* Fill in the code to allocate a new grayimage, then convert
       each pixel from the given rgbimage from color to grayscale,
       and store it in the grayimage. */
        stp     x19, x30, [sp, -16]!

        mov     x19, x0                     // pointer to rbgimage
        ldr     w0, [x19, width]            // get width
        ldr     w1, [x19, height]           // get height
        bl      allocate_grayimage

        ldr     x4, [x0, rows]              // load the gray rows
                                            // width and height are set

        ldr     x3, [x19, rows]             // get rows
        ldr     w1, [x19, width]            // get width
        ldr     w2, [x19, height]           // get height

        mov     x5, 0                       // i = 0
loopi:  mov     x6, 0                       // j = 0
        ldr     x7, [x4, x5, lsl 3]         // load the gray pixel array
        ldr     x8, [x3, x5, lsl 3]         // load the rgb pixel array
loopj:
        ld3     {v0.8h-v2.8h}, [x8], 48     // load 8|16 copies r - v0, g - v1, b - v2

        /* shift by 8, invalid */
        // use shll and shll2
        // shrn - shift right narrow

        // check if more than 8 pixels remain in the row
            // if not compute the rest manually
        sub     w9, w1, w6
        cmp     w9, 8
        ble     single_pixel_loopj

        // calculate the gray pixel values based on the rgb pixel values
        shl     v3.8h, v0.8h, 6
        shl     v4.8h, v0.8h, 3
        shl     v5.8h, v0.8h, 1
        sub     v3.8h, v3.8h, v4.8h
        sub     v0.8h, v3.8h, v5.8h         // 54r

        shl     v3.8h, v1.8h, 7
        shl     v3.8h, v1.8h, 1

        shl     v4.8h, v1.8h, 6
        shl     v5.8h, v1.8h, 3
        sub     v3.8h, v3.8h, v4.8h
        sub     v1.8h, v3.8h, v5.8h         // 184g

        shl     v3.8h, v2.8h, 4
        shl     v4.8h, v2.8h, 1
        add     v2.8h, v3.8h, v4.8h         // 18b

        add     v3.8h, v0.8h, v1.8h
        add     v0.8h, v3.8h, v2.8h         // 54r + 184g + 18b

        ushr    v0.8h, v0.8h, 8             // ( 54r + 184g + 18b ) / 256

        // store the gray pixel value
        st3     {v0.8h-v2.8h}, [x8], 48

        // while j < width
        add     w6, w6, 8
        cmp     w6, w1
        blt     loopj

single_pixel_loopj:
        ldrb    w11, [x8], 1                // load the rgb pixel red
        ldrb    w12, [x8], 1                // load the rgb pixel green
        ldrb    w13, [x8], 1                // load the rgb pixel blue

        // calculate the gray pixel values based on the rgb pixel values
        mov     x14, 54
        mul     x11, x11, x14               // 54r
        mov     x14, 184
        madd    x11, x14, x12, x11          // 54r + 184g
        mov     x14, 18
        madd    x11, x14, x13, x11          // 54r + 184g + 18b

        lsr     w11, w11, 8                 // divide the result by 256

        strb    w11, [x7, x6]               // store gray pixel value

        // while j < width
        add     w6, w6, 1
        cmp     w6, w1
        blt     single_pixel_loopj


        // while i < height
        add     w5, w5, 1
        cmp     w5, w2
        blt     loopi

        ldp     x19, x30, [sp], 16
        // x0 contains the gray image to return
        ret
        .size   color_to_gray, (. - color_to_gray)
