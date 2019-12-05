EXECS  = jacobi_mpi
MPICXX = mpiCC
MPIC   = mpicc
CFLAGS = -Wall -O3 -Wno-unused-variable
CC     = gcc
OFLAGS = -o

HDEPS += %.h
OBJS   = utils.o

all: ${EXECS}

.PHONY: clean all

jacobi_mpi: $(OBJS) jacobi_mpi.c
	$(MPIC) $(OBJS) $(OFLAGS) jacobi_mpi jacobi_mpi.c $(CFLAGS)

%.o: %.c $(HDEPS)
	$(CC) $(CFLAGS) -c $< $(OFLAGS) $@

clean:
	rm -f *.o jacobi_mpi
