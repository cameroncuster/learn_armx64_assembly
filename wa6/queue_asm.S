		.text
		.type _ZN5queue5enqueEi, %function				// int enque(int item)
		.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	_ZN5queue5enqueEi, (. - _ZN5queue5enqueEi)

/*
		.type _ZN5queue5dequeERi, %function				// int deque(int &item)
		.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	_ZN5queue5dequeERi, (. - _ZN5queue5dequeERi)
*/
