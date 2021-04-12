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

fmt:    .asciz  "%f"
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

        //// *** DEBUG *** ////
        adr     x0, newline
        bl      printf

        adr     x0, fmt
        fmov    d1, d8                      // use x or d register for printf floating point arguements?
        bl      printf
        //// *** END DEBUG *** ////

        adr     x0, newline
        bl      printf


        // get upper limit
        adr     x0, getUpperLimit
        bl      printf

        adr     x0, fmt
        adr     x1, doubleval
        bl      scanf

        ldr     d9, doubleval

        //// *** DEBUG *** ////
        adr     x0, newline
        bl      printf

        adr     x0, fmt
        fmov    d1, d9
        bl      printf
        //// *** END DEBUG *** ////

        adr     x0, newline
        bl      printf


        // get rows
        adr     x0, getRows
        bl      printf

        adr     x0, fmt
        adr     x1, doubleval
        bl      scanf

        ldr     d10, doubleval

        //// *** DEBUG *** ////
        adr     x0, newline
        bl      printf

        adr     x0, fmt
        fmov    d1, d10
        bl      printf
        //// *** END DEBUG *** ////

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
        fmov    d1, d8                      // use f1 for floating point arg
        bl      printf

        // table column formatting
        adr     x0, tabchar
        bl      printf

        // calculate f(x)

        // numerator

        // denominator

        // divide the numerator by the denominator

        // print f(x) * currently x for skeleton code
        adr     x0, fmt
        fmov    d1, d8                      // use f1 for floating point arg
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
