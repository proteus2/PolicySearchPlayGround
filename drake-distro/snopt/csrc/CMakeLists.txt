
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

add_library(snopt_c
          snfilewrapper.c snfilewrapper.f
          sn15blas.c
	        sn03prnt.c
          sqopt.c    snopta.c   snoptb.c   snoptc.c   snoptq.c   npopt.c
          sq02lib.c  sn02lib.c  np02lib.c
          sn05wrpa.c sn05wrpb.c sn05wrpc.c sn05wrpn.c
          sn10mach.c sn12ampl.c sn17util.c sn20amat.c sn25bfac.c sn27lu.c
          sn30spec.c sn35mps.c  sn37wrap.c sn40bfil.c sn50lp.c   sn55qp.c
          sn56qncg.c sn57qopt.c sn60srch.c sn65rmod.c sn70nobj.c sn80ncon.c
          sn85hess.c sn87sopt.c sn90lmqn.c sn95fmqn.c dummy.c )
target_link_libraries(snopt_c ${F2C_LIBRARY} -lm)

pods_install_headers(snopt.hh snfilewrapper.hh DESTINATION snopt)

pods_install_libraries(snopt_c)

pods_install_pkg_config_file(snopt_c
    CFLAGS -I${CMAKE_INSTALL_PREFIX}/include/snopt
    LIBS -L${CMAKE_INSTALL_PREFIX}/lib -lsnopt_c ${F2C_LIBRARY_FLAG}
    REQUIRES
    VERSION 0.0.1)
