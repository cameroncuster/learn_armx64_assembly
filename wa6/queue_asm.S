		// constant max size of queue
		.equ	MAX_QUEUE_SIZE, 52

		// queue private member data
		.equ	array,		0
		.equ	frontindex,	208
		.equ	endindex,	212
		.equ	nitems,		216

		.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
		stp		x29, x30, [sp, #-32]!
		str		x19, [sp, #16]

		mov		x19, x0				// the pointer to the current queue object
		mov		x29, x1				// the integer to enque

		bl		_ZN5queue6isfullEv	// if the queue is full return 0
		cmp		x0, #0
		bne		ret0en

		ldr		w0, [x19, #endindex]// the endindex

		mov		w1, w0
		lsl		w1, w1, #2
		str		x29, [x19, x1]		// array[endindex] = item

		add		w0, w0, #1			// endindex++
		
		mov		w1, #0
		cmp		w0, #MAX_QUEUE_SIZE
		csel	w0, w1, w0, ge		// if( endindex >= MAX_QUEUE_SIZE )
		str		w0, [x19, #endindex]//	endindex = 0

		ldr		w0, [x19, #nitems]
		add		w0, w0, #1			// nitems++
		str		w0, [x19, #nitems]

ret1en:	mov		x0, #1				// return 1
		b		enque_exit
ret0en:	mov		x0, #0				// return 0
enque_exit:
		ldr		x19, [sp, #16]
		ldp		x29, x30, [sp], #32
		ret
		.size	_ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)

		.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
		stp		x29, x30, [sp, #-32]!
		str		x19, [sp, #16]

		ldr		x19, [x0]			// the pointer to the current queue object
		mov		x29, x1				// the address for the dequed item

		bl		_ZN5queue7isemptyEv	// if the queue is empty return 0
		cmp		x0, #0
		bne		ret0de

		ldr		w0, [x19, #frontindex]

		mov		w1, w0
		lsl		w1, w1, #2
		ldr		x1, [x19, x1]

		str		w1, [x29]			// item = array[frontindex]

		add		w0, w0 ,#1			// frontindex++

		mov		w2, #0
		cmp		w0, #MAX_QUEUE_SIZE
		csel	w0, w2, w0, ge		// if( frontindex >= MAX_QUEUE_SIZE )
		str		w0, [x19, #frontindex]//	frontindex = 0

		ldr		w0, [x19, #nitems]
		sub		w0, w0, #1			// nitems--
		str		w0, [x19, #nitems]

ret1de:	mov		w0, w1				// return item
		b		deque_exit
ret0de:	mov		x0, #0				// return 0
deque_exit:
		ldr		x19, [sp, #16]
		ldp		x29, x30, [sp], #32
		ret
		.size	_ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
