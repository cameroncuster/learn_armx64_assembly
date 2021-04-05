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

quadvalin:  .asciz  "%ld"
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

        // get lower limit
        adr     x0, getLowerLimit
        bl      printf

        adr     x0, quadvalin
        adr     x1, lower
        bl      scanf

        adr     x0, newline
        bl      printf

        // get upper limit
        adr     x0, getUpperLimit
        bl      printf

        adr     x0, quadvalin
        adr     x1, upper
        bl      scanf

        adr     x0, newline
        bl      printf

        // get rows
        adr     x0, getRows
        bl      printf

        adr     x0, quadvalin
        adr     x1, rows
        bl      scanf

        adr     x0, newline
        bl      printf

        // calculate increment value = ( upper - lower ) / rows

        // print x and f(x) for table header

        //// loop table construction
        // loop over all values from lower to upper incrementing by the increment
        // value while outputting x and f(x) to fill the row at every iteration
        //// end loop table construction

        // exit & add BONUS features

        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)

////////////////////////////////////////////////////////////////////////////////
