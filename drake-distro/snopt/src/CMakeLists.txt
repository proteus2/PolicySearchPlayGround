
add_library(snblas sn15blas.f)

add_library(snprint sn03prnt.f)

add_library(snopt 
          sqopt.f    snopta.f   snoptb.f   snoptc.f   snoptq.f   npopt.f    
          sq02lib.f  sn02lib.f  np02lib.f                             
          sn05wrpa.f sn05wrpb.f sn05wrpc.f sn05wrpn.f                   
          sn10mach.f sn12ampl.f sn17util.f sn20amat.f sn25bfac.f sn27lu.f   
          sn30spec.f sn35mps.f  sn37wrap.f sn40bfil.f sn50lp.f   sn55qp.f   
          sn56qncg.f sn57qopt.f sn60srch.f sn65rmod.f sn70nobj.f sn80ncon.f 
          sn85hess.f sn87sopt.f sn90lmqn.f sn95fmqn.f )


pods_install_libraries(snopt snblas snprint)

pods_install_pkg_config_file(snopt
    LIBS -L${CMAKE_INSTALL_PREFIX}/lib -lsnopt -lsnblas -lsnprint
    REQUIRES  
    VERSION 0.0.1)



