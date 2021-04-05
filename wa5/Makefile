C_OBJECTS = makegray.o  netpbm.o
ASM_OBJECTS = colortogray.o freeImage.o

makegray: $(C_OBJECTS) $(ASM_OBJECTS)
	gcc -g -o makegray $(C_OBJECTS) $(ASM_OBJECTS)

.c.o:
	gcc -Wall -I. -g -c $<

.S.o:
	gcc -Wall -I. -g -c $<

clean:
	rm -f *.o makegray *~ *.pgm
