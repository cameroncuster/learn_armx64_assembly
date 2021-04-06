        .bss
lower:  .quad
        .align  3
upper:  .quad
        .align  3
rows:   .quad
        .align  3

        .section .rodata
description:
        .asciz  "\n This program will produce a table given a domain for x\n to evaluate the function f(x).\n\n f(x) = ( x^3 - x^2 -2x ) / ( ( ( x - 2 )^4 / 11 ) + 3 )\n\n"
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
        .asciz  "f(x)\tx\n"
        .align  2

quadval:
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
        stp     x19, x20, [sp, -16]!

        // brief description
        adr     x0, description
        bl      printf

        // get lower limit * update for non-integral values
        adr     x0, getLowerLimit
        bl      printf

        adr     x0, quadval
        adr     x1, lower
        bl      scanf

        adr     x0, newline
        bl      printf

        // get upper limit * update for non-integral values
        adr     x0, getUpperLimit
        bl      printf

        adr     x0, quadval
        adr     x1, upper
        bl      scanf

        adr     x0, newline
        bl      printf

        // get rows * update for non-integral values
        adr     x0, getRows
        bl      printf

        adr     x0, quadval
        adr     x1, rows
        bl      scanf

        adr     x0, newline
        bl      printf

        // calculate increment value = ( upper - lower ) / rows
        // * update increment value to handle non-integral value
        ldr     x19, lower                  // r19 = lower
        ldr     x20, upper                  // r20 = upper
        ldr     x29, rows
        sub     x0, x20, x19
        udiv    x29, x0, x29                // r29 contains increment value

        adr     x0, quadval
        mov     x1, x29
        bl      printf

        // print x and f(x) for table header
        adr     x0, tableHeader
        bl      printf

        //// loop table construction
        // loop over all values from lower to upper incrementing by the increment
        // value while outputting x and f(x) to fill the row at every iteration
        //// end loop table construction
buildTable:
        // print x
        adr     x0, quadval
        mov     x1, x19
        bl      printf

        // table column formatting
        adr     x0, tabchar
        bl      printf

        // calculate f(x)

        // print f(x)
        adr     x0, quadval
        mov     x1, x19
        bl      printf

        // table row formatting
        adr     x0, newline
        bl      printf

        cmp     x19, x20                    // oldlower = lower
        add     x19, x19, x29               // lower += increment value
        blt     buildTable                  // while( oldlower < upper )

        // exit & add BONUS features

        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)

////////////////////////////////////////////////////////////////////////////////
