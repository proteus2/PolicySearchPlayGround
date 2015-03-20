/* Mike Gertz - 2-Aug-98 */

#ifndef SNFILEWRAPPER
#define SNFILEWRAPPER

#pragma once

extern int snopenappend_
( integer *iunit, char *name, integer *inform, ftnlen name_len);

extern int snfilewrapper_
( char *name__, integer *ispec, integer *
  inform__, char *cw, integer *lencw, integer *iw,
  integer *leniw, doublereal *rw, integer *lenrw,
  ftnlen name_len, ftnlen cw_len);

extern int snclose_
( integer *iunit);

extern int snopen_
( integer *iunit);

#endif
