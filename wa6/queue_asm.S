		//.text
		.equ	array,		0
		.equ	frontindex,	8
		.equ	endindex,	12
		.equ	nitems,		16
		//.type _ZN5queue5enqueEi, %function	// int enque(int)
		.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
		stp		x29, x30, [sp, #-32]!
		str		x19, [sp, #16]

		mov		x19, x0				// the pointer to the current queue object
		mov		x29, x1				// the integer to enque

		bl		_ZN5queue6isfullEv	// if the queue is full return 0
		cmp		x0, #0
		bne		ret0en

ret1en:	mov		x0, #1				// return 1
		b		enque_exit
ret0en:	mov		x0, #0				// return 0
enque_exit:
		ldr		x19, [sp, #16]
		ldp		x29, x30, [sp], #32
		ret
		.size	_ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)

		//.type _ZN5queue5dequeERi, %function	// int deque(int &)
		.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
		stp		x29, x30, [sp, #-32]!
		str		x19, [sp, #16]

		mov		x19, x0				// the pointer to the current queue object
		mov		x29, x1				// the integer on top of the queue

		bl		_ZN5queue7isemptyEv	// if the queue is empty return 0
		cmp		x0, #0
		bne		ret0de

ret1de:	mov		x0, #1				// return 1
		b		deque_exit
ret0de:	mov		x0, #0				// return 0
deque_exit:
		ldr		x19, [sp, #16]
		ldp		x29, x30, [sp], #32
		ret
		.size	_ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
