CC=gcc
CFLAGS=-O3 -Wall
RES=-DPRINT_RESULTS
CONV=-DTEST_CONV

all: jacobi seidelsor redblacksor jacobi_NO_conv seidelsor_NO_conv redblacksor_NO_conv

jacobi: Jacobi_serial.c utils.c
	$(CC) $(CFLAGS) Jacobi_serial.c utils.c -o jacobi

seidelsor: GaussSeidelSOR_serial.c utils.c
	$(CC) $(CFLAGS) GaussSeidelSOR_serial.c utils.c -o seidelsor -lm

redblacksor: RedBlackSOR_serial.c utils.c
	$(CC) $(CFLAGS) RedBlackSOR_serial.c utils.c -o redblacksor -lm

jacobi_NO_conv: Jacobi_serial_NO_conv.c utils.c
	$(CC) $(CFLAGS) Jacobi_serial_NO_conv.c utils.c -o jacobi_NO_conv

seidelsor_NO_conv: GaussSeidelSOR_serial_NO_conv.c utils.c
	$(CC) $(CFLAGS) GaussSeidelSOR_serial_NO_conv.c utils.c -o seidelsor_NO_conv -lm

redblacksor_NO_conv: RedBlackSOR_serial_NO_conv.c utils.c
	$(CC) $(CFLAGS) RedBlackSOR_serial_NO_conv.c utils.c -o redblacksor_NO_conv -lm

clean:
	rm jacobi seidelsor redblacksor jacobi_NO_conv seidelsor_NO_conv redblacksor_NO_conv
