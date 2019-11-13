.phony = all clean

EXECS = exec/parallel exec/serial
CC = gcc
CFLAGS = -Wall -O3 -fopenmp -Wno-unused-variable
OFLAGS = -o 
src?=src/
exec?=exec/

all: ${EXECS}

.PHONY: clean all 

exec/parallel: ${src}Game_Of_Life_Parallel.c
	@echo
	@echo
	@echo "Compiling Game_Of_Life_Parallel.c -Parallel Execution..."
	$(CC) $(CFLAGS) ${src}Game_Of_Life_Parallel.c ${OFLAGS} ${exec}parallel
	@echo
	@echo

exec/serial: ${src}Game_Of_Life_Serial.c
	@echo "Compiling Game_Of_Life_Serial.c - Serial Execution..."
	$(CC) $(CFLAGS) ${src}Game_Of_Life_Serial.c ${OFLAGS} ${exec}serial
	@echo
	@echo

clean:
	@echo "Deleting Files..."
	rm exec/*

clean_out: 
	@echo "Deleting output..."
	rm out/*
	rm err/*
