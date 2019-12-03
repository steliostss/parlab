EXECS  = mpi_skeleton
MPICXX = mpiCC
MPIC   = mpicc
CFLAGS = -Wall -O3 -Wno-unused-variable
CC     = gcc
OFLAGS = -o

HDEPS += %.h
OBJS   = utils.o

all: ${EXECS}

.PHONY: clean all

mpi_skeleton: $(OBJS) mpi_skeleton.c
	$(MPIC) $(OBJS) $(OFLAGS) mpi_skeleton.c $(CFLAGS)

%.o: %.c $(HDEPS)
	$(CC) $(CFLAGS) -c $< $(OFLAGS) $@

clean:
	rm -f *.o mpi_skeleton
