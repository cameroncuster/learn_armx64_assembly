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

        // test
        mov     x1, MAX_DECIMAL_DIGITS
        bl      printS
        // endtest

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

        // test
        mov     x1, MAX_DECIMAL_DIGITS
        bl      printS
        // endtest

        adr     x0, newline
        bl      printf

        // get rows
        adr     x0, getRows
        bl      printf

        adr     x0, quadvalIO
        adr     x1, quadval
        bl      scanf

        ldr     x29, quadval                // r29 = rows

        adr     x0, newline
        bl      printf

        // calculate increment value = ( upper - lower ) / rows
        // * update increment value to handle non-integral value
        sub     x29, x29, 1
        sub     x0, x20, x19
        udiv    x29, x0, x29                // r29 contains increment value

        // print x and f(x) for table header
        adr     x0, tableHeader
        bl      printf

        //// loop table construction
        // loop over all values from lower to upper incrementing by the increment
        // value while outputting x and f(x) to fill the row at every iteration
        //// end loop table construction
buildTable:
        // print x
        adr     x0, quadvalIO
        mov     x1, x19
        bl      printf

        // table column formatting
        adr     x0, tabchar
        bl      printf

        // calculate f(x) * update for non-integral values

        // numerator
        mul     x1, x19, x19                // r1 = x^2
        mul     x0, x19, x1                 // r0 = x^3
        mov     x2, 2
        mul     x2, x19, x2                 // r2 = 2x
        sub     x0, x0, x1                  // r0 -= r1
        sub     x0, x0, x2                  // r0 -= r2

        // denominator
        sub     x1, x19, 2                  // r1 = ( x - 2 )
        mul     x1, x1, x1
        mul     x1, x1, x1                  // r1 = ( x - 2 )^4
        // divide r1 by 11
        mov     x2, 11
        sdiv    x1, x1, x2
        // add 3 to r1
        add     x1, x1, 3

        // divide the numerator by the denominator
        sdiv    x1, x0, x1

        // print f(x)
        adr     x0, quadvalIO
        bl      printf

        adr     x0, newline
        bl      printf

        // table row formatting
        adr     x0, newline
        bl      printf

        cmp     x19, x20                    // oldlower = lower
        add     x19, x19, x29               // lower += increment value
        //blt     buildTable                  // while( oldlower < upper )

        // exit & add BONUS features

        ldp     x19, x20, [sp], 16
        stp     x21, x22, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)

////////////////////////////////////////////////////////////////////////////////
