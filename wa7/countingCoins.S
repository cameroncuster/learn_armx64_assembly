        .data // use .bss ( for uninitialized data ) with skips
quarters: .word 0
currPenn: .word 0
currNick: .word 0
currDime: .word 0
currQuar: .word 0

        .section .rodata
read_count: .asciz  "Enter the number of pennies, nickels, dimes, and quarters for week "
        .align  2

week:   .asciz  "%d: " // combine with above printf
        .align  2

collected: .asciz "Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters \n"
        .align  2

total:  .asciz  "This comes to $%d \n"
        .align  2

average: .asciz  "Your weekly average is $%d.%d \n"
        .align  2

savings:.asciz  "Your estimated yearly savings is $%d \n"

valuesin:.asciz "%d %d %d %d"

        .text

////////////////////////////////////////////////////////////////////////////////

        .type   main, %function
        .globl  main
main:   stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!
        stp     x21, x22, [sp, -16]!
        stp     x23, x24, [sp, -16]!

        mov     w21, 0                      // count of pennies
        mov     w22, 0                      // count of nickels
        mov     w23, 0                      // count of dimes
        mov     w24, 0                      // count of quarters

        // read input
        mov     w19, 4                      // i = 4
        mov     w20, 1
read_weeks:
        // print the input string
        adr     x0, read_count
        bl      printf

        // print the week #
        adr     x0, week
        mov     w1, w20
        bl      printf

        add     w20, w20, 1

        // read the counts
        adr     x0, valuesin
        adr     x1, currPenn
        adr     x2, currNick
        adr     x3, currDime
        adr     x4, currQuar
        bl      scanf

        ldr     w0, currPenn
        ldr     w1, currNick
        ldr     w2, currDime
        ldr     w3, currQuar

        // increment the sums with respect to the counts
        add     w21, w21, w0
        add     w22, w22, w1
        add     w23, w23, w2
        add     w24, w24, w3

        // for( ; i > 0 ; i-- )
        sub     w19, w19, 1
        cbnz    w19, read_weeks

        // output collected
        adr     x0, collected
        mov     w1, w21
        mov     w2, w22
        mov     w3, w23
        mov     w4, w24
        bl      printf

        // calculate total
        // r19 = 0
        add     w0, w22, w22, lsl 2
        add     w19, w21, w0                // r19 = # of pennies + 5 * # of nickels

        lsl     w0, w23, 3
        add     w0, w0, w23, lsl 1          // r0 += 10 * # number of dimes

        add     w1, w24, w24, lsl 3
        add     w1, w1, w24, lsl 4
        add     w1, w0, w1                  // r1 = r0 + 25 * # of quarters

        add     w19, w19, w1                // w19 += total

        // divide total by 100 for amount in USD
        // calculate quotient in r1
        ldr     x2, =0xA3D8
        mul     x3, x19, x2
        asr     x1, x3, 22
        sub     x1, x1, x3, asr 63

        // calculate remainder in r2
        mov     x2, 100
        mul     x2, x2, x1
        sub     x2, x19, x2

        adr     x0, average
        bl      printf                      // print the total

        // calculate average

        // calculate savings

        ldp     x23, x24, [sp], 16
        ldp     x21, x22, [sp], 16
        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     w0, 0
        ret
        .size   main, (. - main)
