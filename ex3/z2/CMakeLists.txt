project(z2)
set(CMAKE_C_FLAGS "-Wall -Wextra -pthread -O0 -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function")

#set(LOCK_FILE nosync_lock.c)
#set(LOCK_FILE ttas_lock.c)
#set(LOCK_FILE tas_lock.c)
#set(LOCK_FILE pthread_lock.c)
set(LOCK_FILE array_lock.c)

set(SRC_FILES  ../common/aff.c)

add_executable(main main.c ${LOCK_FILE} ${SRC_FILES})
add_executable(test test.c ${LOCK_FILE} ${SRC_FILES})