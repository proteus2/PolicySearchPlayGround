
include_directories( ${CMAKE_SOURCE_DIR}/cppsrc ${CMAKE_SOURCE_DIR}/csrc)

add_executable(ccsntoya sntoya.cc toyfunction.cc)
target_link_libraries(ccsntoya snopt_cpp)
add_test(NAME ccsntoya COMMAND ccsntoya)
