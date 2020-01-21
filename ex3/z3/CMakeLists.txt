project(z3)

set(CMAKE_C_FLAGS "-Wall -Wextra -pthread -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function")

#set(LL_FILE ll_fgl.c)
#set(LL_FILE ll_lazy.c)
set(LL_FILE ll_nb.c)
#set(LL_FILE ll_opt.c)
#set(LL_FILE ll_serial.c)

set(SRC_FILES  ../common/aff.c)

add_executable(main main.c ${LL_FILE} ${SRC_FILES})
#add_executable(test test.c ${LOCK_FILE} ${SRC_FILES}) 
