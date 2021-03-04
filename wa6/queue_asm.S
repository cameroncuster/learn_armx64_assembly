		.text
		.type _ZN5queue5enqueEi, %function				// int enque(int item)
		.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
		stp		x29, x30, [sp, #-16]!

		mov		x29, x0						// the integer to enque

		bl		_ZN5queue6isfullEv			// if the queue is full return 0
		cmp		x0, #0
		bne		ret0en

ret1en:	mov		x0, #1
		ldp		x29, x30, [sp], #16
		ret
ret0en:	mov		x0, #0
		ldp		x29, x30, [sp], #16
		ret
		.size	_ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)

		.type _ZN5queue5dequeERi, %function				// int deque(int &item)
		.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
		stp		x29, x30, [sp, #-16]!


		mov		x29, x0						// the integer on top of the queue

		bl		_ZN5queue7isemptyEv			// if the queue is empty return 0
		cmp		x0, #0
		bne		ret0de

ret1de:	mov		x0, #1
		ldp		x29, x30, [sp], #16
		ret
ret0de:	mov		x0, #0
		ldp		x29, x30, [sp], #16
		ret
		.size	_ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
