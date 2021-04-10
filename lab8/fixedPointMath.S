        .set    MAX_DECIMAL_DIGITS, 16

        .bss
quadval:.quad   0
        .align  3
strin:  .byte   0
        .skip   64
        .align  0

        .section .rodata
description:
        .asciz  "\nThis program will produce a table given a domain for x\n to evaluate the function f(x).\n\n f(x) = ( x^3 - x^2 -2x ) / ( ( ( x - 2 )^4 / 11 ) + 3 )\n\n"
        .align  2

getLowerLimit:
        .asciz  "Lower limit: "
        .align  2

getUpperLimit:
        .asciz  "Upper limit: "
        .align  2

getRows:.asciz  "Rows: "
        .align  2

tableHeader:
        .asciz  "x\tf(x)\n"
        .align  2

string: .asciz  "%s"
        .align  2

quadvalIO:
        .asciz  "%ld"
        .align  2

tabchar:.asciz  "\t"
        .align  2

newline:.asciz  "\n"
        .align  2

        .text

////////////////////////////////////////////////////////////////////////////////

        .type   main, %function
        .globl  main
main:   stp     x29, x30, [sp, -16]!
        stp     x21, x22, [sp, -16]!
        stp     x19, x20, [sp, -16]!

        // brief description
        adr     x0, description
        bl      printf

        // get lower limit
        adr     x0, getLowerLimit
        bl      printf

        adr     x0, string
        adr     x1, strin
        bl      scanf

        adr     x0, strin
        mov     x1, MAX_DECIMAL_DIGITS
        bl      strtoSfixed

        mov     x19, x0                     // r19 = lowerL = S( 47, 16 )

        adr     x0, newline
        bl      printf

        // get upper limit
        adr     x0, getUpperLimit
        bl      printf

        adr     x0, string
        adr     x1, strin
        bl      scanf

        adr     x0, strin
        mov     x1, MAX_DECIMAL_DIGITS
        bl      strtoSfixed

        mov     x20, x0                     // r20 = upperL = S( 47, 16 )

        adr     x0, newline
        bl      printf

        // get rows
        adr     x0, getRows
        bl      printf

        adr     x0, quadvalIO
        adr     x1, quadval
        bl      scanf

        ldr     x29, quadval
        lsl     x29, x29, 16                // r29 = rows = S( 47, 16 )

        adr     x0, newline
        bl      printf

        // calculate increment value = ( upper - lower ) / rows
        mov     x0, 1
        lsl     x0, x0, 16
        sub     x29, x29, x0                // rows -= 1
        sub     x0, x20, x19                // r0 = upper - lower
        udiv    x29, x0, x29                // r29 contains increment value
        lsl     x29, x29, 16                // r29 = S( 47, 16 ) formatted for division operation


        // ***** fix for no rounding
        // *** test
        mov     x0, x29
        mov     x1, MAX_DECIMAL_DIGITS
        bl      printS

        // newline for output
        adr     x0, newline
        bl      printf
        // *** endtest


        // print x and f(x) for table header
        adr     x0, tableHeader
        bl      printf

        // loop table construction
        // loop over all values from lower to upper incrementing by the increment
        // value while outputting x and f(x) to fill the row at every iteration
buildTable:
        // print x
        mov     x0, x19
        mov     x1, MAX_DECIMAL_DIGITS
        bl      printS

        // table column formatting
        adr     x0, tabchar
        bl      printf

        // calculate f(x) * keep everything in fixed format S( 47, 16 )

        // numerator
        mul     x1, x19, x19                // r1 = x^2
        lsr     x1, x1, MAX_DECIMAL_DIGITS  // r1 = S( 47, 16 )
        mul     x0, x19, x1                 // r0 = x^3
        lsr     x0, x0, MAX_DECIMAL_DIGITS  // r0 = S( 47, 16 )
        mov     x2, 2
        lsl     x3, x3, 16                  // 2 in r3 = S( 47, 16 )
        mul     x2, x19, x3                 // r2 = 2x
        lsr     x2, x2, MAX_DECIMAL_DIGITS  // r2 = S( 47, 16 )
        sub     x0, x0, x1                  // r0 -= r1
        sub     x0, x0, x2                  // r0 -= r2

        // denominator
        sub     x1, x19, x3                 // r1 = ( x - 2 )
        mul     x1, x1, x1
        lsr     x1, x1, MAX_DECIMAL_DIGITS  // r1 = S( 47, 16 )
        mul     x1, x1, x1                  // r1 = ( x - 2 )^4
        lsr     x1, x1, MAX_DECIMAL_DIGITS  // r1 = S( 47, 16 )

        // divide r1 by 11
        mov     x2, 11
        lsl     x2, x2, 16                  // 11 in r1 = S( 47, 16 )
        sdiv    x1, x1, x2
        lsl     x1, x1, 16                  // r1 = S( 47, 16 )
        // add 3 to r1
        mov     x2, 3
        lsl     x2, x2, 16
        // use add     x1, x1, 3, lsl 16
        add     x1, x1, x2

        // divide the numerator by the denominator
        sdiv    x0, x0, x1
        lsl     x0, x0, 16                  // r0 = S( 47, 16 )

        // print f(x)
        mov     x1, MAX_DECIMAL_DIGITS
        bl      printS

        adr     x0, newline
        bl      printf

        // table row formatting
        adr     x0, newline
        bl      printf

        cmp     x19, x20                    // oldlower = lower
        add     x19, x19, x29               // lower += increment value
        blt     buildTable                  // while( oldlower < upper )

        // exit & add BONUS features

        ldp     x19, x20, [sp], 16
        stp     x21, x22, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)

////////////////////////////////////////////////////////////////////////////////
