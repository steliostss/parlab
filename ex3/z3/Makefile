CC = gcc
CFLAGS = -Wall -Wextra -pthread

## Remove some warnings.
CFLAGS += -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function

all: fgl lazy nb opt serial

## Additional source files
SRC_FILES = ../common/aff.c

fgl: main.c ll_fgl.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

lazy: main.c ll_lazy.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

nb: main.c ll_nb.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

opt: main.c ll_opt.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

serial: main.c ll_serial.c ${SRC_FILES}
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f fgl lazy nb opt serial
