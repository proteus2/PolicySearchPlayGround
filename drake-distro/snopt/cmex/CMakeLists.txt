
add_mex(snoptcmex snoptcmex.c mexUtility.c snoptprobdef.c snoptprint.c sncmexlog.c)
target_link_libraries(snoptcmex snopt_c)

set(mexdir "${CMAKE_SOURCE_DIR}/matlab/")
c_compiler_path(mexdir)

set_target_properties(snoptcmex PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${mexdir}"
  LIBRARY_OUTPUT_DIRECTORY "${mexdir}" )

foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
  string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
  set_target_properties(snoptcmex PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${mexdir}"
    LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} "${mexdir}" )
endforeach()




