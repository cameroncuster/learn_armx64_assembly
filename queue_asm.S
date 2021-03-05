// int_ZN5queue5enqueEi(int item)
// {
//    if(isfull())
//       return 0;

//    array[endindex] = item;
//    if(++endindex >= MAX_QUEUE_SIZE)
//      endindex = 0;
//    nitems++;
//    return 1;
// }

// int _ZN5queue5dequeERi(int &item)
// {
//    if(isempty())
//       return 0;

//    item = array[frontindex];
//    if(++frontindex >= MAX_QUEUE_SIZE)
//      frontindex = 0;
//    nitems--;
//    return item;
// }

// int _ZN5queue7isemptyEv()
// {
//    if(nitems == 0)
//       return 1;
//    return 0;
// }

// int  _ZN5queue6isfullEv()
// {
//    if(nitems == MAX_QUEUE_SIZE)
//       return 1;
//    return 0;
// }

        .equ    MAX_QUEUE_SIZE,  208
        .equ    frontindex,      208
        .equ    endindex,        212
        .equ    nitems,          216
        .text
        .global _ZN5queue5enqueEi
        // int_ZN5queue5enqueEi(int item)
_ZN5queue5enqueEi:
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!

        mov     x19, x0                 // x19 will be our queue ADT
        mov     x20, x1                // x20 = int item

        //    if(isfull())
        //       return 0;
        bl      _ZN5queue6isfullEv
        cmp     x0, #1
        mov     x0, #0
        beq     end

        //    array[endindex] = item;
        ldr     w2, [x19, endindex]         // x2 = endIndex
        add     x3, x19, #0                 // x3 = address of array[0]
        str     w20, [x3, x2]               // array[endindex] = item

        //    if(++endindex >= MAX_QUEUE_SIZE)
        //      endindex = 0;
        add     x2, x2, #1                  // ++endindex
        cmp     x2, MAX_QUEUE_SIZE          //    if(++endindex >= MAX_QUEUE_SIZE)
        blt     cont
        mov     x2, xzr                 // endIndex = 0

cont:  
        str     w2, [x19, endindex]     // store our endindex
        //    nitems++;
        //    return 1;
        ldr     x4, [x19, nitems]       // x4 = nitems
        add     x4, x4, #1              // nitems++
        str     w4, [x19, nitems]


        mov     x0, #1                  // return 1
end:
        ldp     x19, x20, [sp], #16     // restore sp, lr
        ldp     x29, x30, [sp], #16
        ret
    
        .global _ZN5queue5dequeERi



_ZN5queue5dequeERi:
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!

        mov     x19, x0                 // x19 will be our queue ADT
        mov     x20, x1                // x20 = int item

        //    if(isempty())
        //       return 0;
        bl      _ZN5queue7isemptyEv
        cmp     x0, #1                  // if 1 then queue is empty
        mov     x0, #0
        beq     end2

        // item = array[frontindex];

        add     x3, x19, #0                 // x3 = address of array[0]
        ldr     w2, [x19, frontindex]         // x2 = frontindex
        add     x4, x3, x2                     // x4 = array[frontindex]
        ldr     w5, [x4]
        str     w5, [x20]                          // item = array[frontindex];

        // if(++frontindex >= MAX_QUEUE_SIZE)

        add     x2, x2, #1
        cmp     x2, MAX_QUEUE_SIZE
        blt     cont2
        mov     x2, xzr                 // frontIndex = 0

cont2:
        str     w2, [x19, frontindex]     // store our frontIndex

        // nitems--;
        ldr     x6, [x19, nitems]       // x4 = nitems
        sub     x6, x6, #1              // nitems--
        str     w6, [x19, nitems]

        mov     x0, x5
        bl      end2

end2:
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret



