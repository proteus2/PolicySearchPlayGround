
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DMAIN__=main")

add_executable(csntoya csntoya.c toyfunction.c snfilewrapper.c)
target_link_libraries(csntoya snopt_c)

add_test(NAME csntoya COMMAND csntoya)

pods_install_headers(snopt.h DESTINATION snopt)



