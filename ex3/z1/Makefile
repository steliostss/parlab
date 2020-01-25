CC = gcc
CFLAGS = -Wall -Wextra -pthread -O0

all: accounts accounts_faster

SRC_FILES= accounts.c ../common/aff.c
SRC_FAST_FILES= accounts_faster.c ../common/aff.c

accounts: $(SRC_FILES)
	$(CC) $(CFLAGS) $^ -o $@

accounts_faster: $(SRC_FAST_FILES)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f accounts accounts_faster
