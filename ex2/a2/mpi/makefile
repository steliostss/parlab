EXECS  = mpi_skeleton mpi_skeleton.o utils.o
MPICXX = mpiCC
MPIC   = mpicc
CFLAGS = -Wall -O3 -Wno-unused-variable
OFLAGS = -o

HDEPS += %.h

CC     = gcc

OBJS   = utils.o mpi_skeleton.o

all: ${EXECS}

.PHONY: clean all


utils.o: utils.c
	$(CC) -c $(CFLAGS) utils.c

mpi_skeleton.o: mpi_skeleton.c
	$(CC) -c $(CFLAGS) mpi_skeleton.c

mpi_skeleton: mpi_skeleton.c
	$(CC) -o $(OBJS) mpi_skeleton

#%.o: %.c $(HDEPS)
#	$(CC) $(CFLAGS) -c $< $(OFLAGS) $@

clean:
	rm -f *.o mpi_skeleton
