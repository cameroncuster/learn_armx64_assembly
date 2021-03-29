        .data
n:      .word   0

        .section .rodata
prompt: .asciz  "Enter a natural number: "
        .align  2

valin:  .asciz  "%d"
        .align  2

write:  .asciz  "The primes are: "
        .align  2

valout: .asciz  "%d\n"
        .align  2

        .text

////////////////////////////////////////////////////////////////////////////////

        .type   udiv64, %function
        .globl  udiv64
udiv64:
        cbnz    x1, endifl                  // if( divisor == 0 )
        mov     x0, 0                       //  return 0
        mov     x1, 0
        ret
endifl:
        clz     x2, x1                      // x2 = count
        lsl     x1, x1, x2                  // divisor <<= count
        mov     x3, 0                       // x3 = quotient
        add     x2, x2, 1                   // x2 = count + 1
divloop:
        lsl     x3, x3, 1                   // Shift 0 into quotient LSB
        cmp     x0, x1
        blo     endif2                      // if( dividend >= divisor )
        orr     x3, x3, 1                   // Set LSB of quotient
        sub     x0, x0, x1                  // divident -= divisor
endif2:
        sub     x2, x2, 1                   // Decrement count
        lsr     x1, x1, 1                   // Shift divisor right
        cbnz    x2, divloop                 // while( count+1 != 0 )
        mov     x1, x0                      // remainder is the dividend
        mov     x0, x3                      // return quotient
        ret
        .size   udiv64, (. - udiv64)

////////////////////////////////////////////////////////////////////////////////

        .type   isPrime, %function
        .globl  isPrime
isPrime:stp     x29, x30, [sp, -16]!

        ldp     x29, x30, [sp], 16
        ret
        .size   isPrime, (. - isPrime)

////////////////////////////////////////////////////////////////////////////////

        .type   main, %function
        .globl  main
main:
        stp     x29, x30, [sp, -16]!

        // prompt for n
        adr     x0, prompt
        bl      printf

        // set n
        adr     x0, valin
        adr     x1, n
        bl      scanf

        // print n
        adr     x0, valout
        ldr     x1, n
        bl      printf

        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)
