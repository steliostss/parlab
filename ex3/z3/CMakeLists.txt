project(z3)

set(CMAKE_C_FLAGS "-Wall -Wextra -pthread -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function")

set(FGL ll_fgl.c)
set(LAZY ll_lazy.c)
set(NB ll_nb.c)
set(OPT ll_opt.c)
set(SERIAL ll_serial.c)

set(SRC_FILES  ../common/aff.c)

add_executable(fgl main.c ${FGL} ${SRC_FILES})
add_executable(nb main.c ${NB} ${SRC_FILES})
add_executable(opt main.c ${OPT} ${SRC_FILES})
add_executable(serial main.c ${SERIAL} ${SRC_FILES})
add_executable(lazy main.c ${LAZY} ${SRC_FILES})
