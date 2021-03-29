        .data // use .bss ( for uninitialized data ) with skips
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

        .type   udiv64, %function// unsigned udiv64( unsigned dividend, unsigned divisor )
        .globl  udiv64
udiv64:
        cbnz    w1, endifl                  // if( divisor == 0 )
        mov     w0, 0                       //  return 0
        mov     w1, 0
        ret
endifl:
        clz     w2, w1                      // x2 = count
        lsl     w1, w1, w2                  // divisor <<= count
        mov     w3, 0                       // x3 = quotient
        add     w2, w2, 1                   // x2 = count + 1
divloop:
        lsl     w3, w3, 1                   // Shift 0 into quotient LSB
        cmp     w0, w1
        blo     endif2                      // if( dividend >= divisor )
        orr     w3, w3, 1                   // Set LSB of quotient
        sub     w0, w0, w1                  // divident -= divisor
endif2:
        sub     w2, w2, 1                   // Decrement count
        lsr     w1, w1, 1                   // Shift divisor right
        cbnz    w2, divloop                 // while( count+1 != 0 )
        // return remainder
        ret
        .size   udiv64, (. - udiv64)

////////////////////////////////////////////////////////////////////////////////

        .type   isPrime, %function// bool isPrime( unsigned n ) non_natural numbers will result in undefined behavior
        .globl  isPrime
isPrime:stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!

        mov     w19, w0                     // w19 = n
        cmp     w19, 3                      // if( n <= 3 )
        ble     ret_1                       //  return 1

        mov     w20, 2                      // i = 2
loop_n_times:                               // could be done in O( sqroot( n ) )
        mov     w0, w19
        mov     w1, w20
        bl      udiv64
        cbz     w0, ret_0                   // if( n % i == 0 ) return 0
        add     w20, w20, 1                 // i++
        cmp     w20, w19
        blt     loop_n_times                // while( i < n )

ret_1:  mov     w0, 1
        b       exit_isPrime
ret_0:  mov     w0, 0
exit_isPrime:
        ldp     x19, x20, [sp], 16
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

        // test n is prime
        ldr     w0, n
        bl      isPrime

        // print primality of n
        mov     w1, w0
        adr     x0, valout
        bl      printf

        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)
