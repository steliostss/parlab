EXECS  = jacobi_mpi_conv jacobi_mpi_NO_conv
MPICXX = mpiCC
MPIC   = mpicc
CFLAGS = -Wall -O3 -Wno-unused-variable
CC     = gcc
OFLAGS = -o

HDEPS += %.h
OBJS   = utils.o

all: ${EXECS}

.PHONY: clean all

jacobi_mpi_conv: $(OBJS) jacobi_mpi_conv.c
	$(MPIC) $(OBJS) $(OFLAGS) jacobi_mpi_conv jacobi_mpi_conv.c $(CFLAGS)

jacobi_mpi_NO_conv: $(OBJS) jacobi_mpi_NO_conv.c
	$(MPIC) $(OBJS) $(OFLAGS) jacobi_mpi_NO_conv jacobi_mpi_NO_conv.c $(CFLAGS)

%.o: %.c $(HDEPS)
	$(CC) $(CFLAGS) -c $< $(OFLAGS) $@

clean:
	rm -f *.o jacobi_mpi_conv jacobi_mpi_NO_conv
