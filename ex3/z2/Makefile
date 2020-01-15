CC = gcc
CFLAGS = -Wall -Wextra -pthread -O0

## Remove some warnings.
CFLAGS += -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function

all: nosync pthread tas ttas array

## Which lock to use?
LOCK_FILE = nosync_lock.c
LOCK_FILE = tas_lock.c
LOCK_FILE = pthread_lock.c
LOCK_FILE = ttas_lock.c
LOCK_FILE = array_lock.c

## Additional source files
SRC_FILES = ../common/aff.c

nosync: main.c nosync_lock.c $(SRC_FILES) 
	$(CC) $(CFLAGS) $^ -o $@

pthread: main.c pthread_lock.c $(SRC_FILES) 
	$(CC) $(CFLAGS) $^ -o $@

tas: main.c tas_lock.c $(SRC_FILES) 
	$(CC) $(CFLAGS) $^ -o $@

ttas: main.c ttas_lock.c $(SRC_FILES) 
	$(CC) $(CFLAGS) $^ -o $@

array: main.c array_lock.c $(SRC_FILES) 
	$(CC) $(CFLAGS) $^ -o $@

# test: test.c $(LOCK_FILE) $(SRC_FILES)
# 	$(CC) $(CFLAGS) $^ -o $@



clean:
	rm -f nosync pthread tas ttas array
