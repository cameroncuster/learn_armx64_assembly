
CPP_OBJS=main.o queue.o
ASM_OBJS=queue_asm.S

ASM_SRC= $(patsubst %.o,%.S,$(ASM_OBJS))
C_SRC= $(patsubst %.o,%.cc,$(CPP_OBJS))


# The following line allows you to add link-time flags
LFLAGS=-Wall -g

# The following line allows you to add compiler flags for C++ code
CPPFLAGS=-Wall -g -I.

# The following line allows you to add compiler flags for assembly code
ASMFLAGS=-Wall -g -I.

queuetest: ${CPP_OBJS} ${ASM_OBJS}
	g++ ${LFLAGS} -o queuetest ${CPP_OBJS} ${ASM_OBJS}

%.o: %.cc 
	g++ ${CPPFLAGS} -c $<

%.o: %.S
	gcc ${ASMFLAGS} -c $<


clean:
	rm -f queuetest *.o *~
