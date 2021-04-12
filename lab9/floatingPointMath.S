        .data
doubleval:
        .double 0
        .align  3

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

fmt:    .asciz  "%lf"
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
        stp     d10, d11, [sp, -16]!
        stp     d8, d9, [sp, -16]!

        // brief description
        adr     x0, description
        bl      printf

        // get lower limit
        adr     x0, getLowerLimit
        bl      printf

        adr     x0, fmt
        adr     x1, doubleval
        bl      scanf

        ldr     d8, doubleval

        adr     x0, newline
        bl      printf

        // get upper limit
        adr     x0, getUpperLimit
        bl      printf

        adr     x0, fmt
        adr     x1, doubleval
        bl      scanf

        ldr     d9, doubleval

        adr     x0, newline
        bl      printf

        // get rows
        adr     x0, getRows
        bl      printf

        adr     x0, fmt
        adr     x1, doubleval
        bl      scanf

        ldr     d10, doubleval
        fmov    d0, 1.0
        fsub    d10, d10, d0                // rows--

        adr     x0, newline
        bl      printf

        // calculate increment value = ( upper - lower ) / rows
        fsub    d0, d9, d8                  // f0 = upper - lower
        fdiv    d11, d0, d10                // f11 = ( upper - lower ) / rows

        // print x and f(x) for table header
        adr     x0, tableHeader
        bl      printf

        // loop table construction
        // loop over all values from lower to upper incrementing by the increment
        // value while outputting x and f(x) to fill the row at every iteration
buildTable:
        // print x
        adr     x0, fmt
        fmov    d0, d8
        bl      printf

        // table column formatting
        adr     x0, tabchar
        bl      printf

        // calculate f(x)

        // numerator
        fmul    d0, d8, d8                  // f0 = x^2
        fnmsub  d0, d0, d8, d0              // f0 = - ( x^2 - x^3 ) = x^3 - x^2
        fmov    d1, 2.0                     // f1 = 2
        fmsub   d0, d8, d1, d0              // f0 = ( x^3 - x^2 ) - 2x

        // denominator
        fmov    d1, 2.0
        fsub    d1, d8, d1                  // f1 = x - 2
        // logical shift left for floating point?
        fmul    d1, d1, d1
        fmul    d1, d1, d1                  // f1 = ( x - 2 )^4
        fmov    d2, 11.0
        fdiv    d1, d1, d2                  // f1 = ( x - 2 )^4 / 11
        fmov    d2, 3.0
        fadd    d1, d1, d2                  // f1 = ( x - 2 )^4 / 11 + 3

        // divide the numerator by the denominator
        adr     x0, fmt
        fdiv    d0, d0, d1
        bl      printf

        adr     x0, newline
        bl      printf

        // table row formatting
        adr     x0, newline
        bl      printf

        fcmp    d8, d9                      // oldlower = lower
        fadd    d8, d8, d11                 // increment lower
        blt     buildTable                  // while( lower < upper )

        ldp     d8, d9, [sp], 16
        ldp     d10, d11, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)

////////////////////////////////////////////////////////////////////////////////
