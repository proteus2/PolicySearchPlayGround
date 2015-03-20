#include <stdio.h>
#include <string.h>
#include "snopt.hh"
#include "toyfunction.hh"
#include "snoptProblem.hh"

int toyusrf_(integer    *Status, integer *n,    doublereal x[],
	     integer    *needF,  integer *neF,  doublereal F[],
	     integer    *needG,  integer *neG,  doublereal G[],
	     char       *cu,     integer *lencu,
	     integer    iu[],    integer *leniu,
	     doublereal ru[],    integer *lenru )
{
  //==================================================================
  // Computes the nonlinear objective and constraint terms for the toy
  // problem featured in the SnoptA users guide.
  // neF = 3, n = 2.
  //
  //   Minimize     x(2)
  //
  //   subject to   x(1)**2      + 4 x(2)**2  <= 4,
  //               (x(1) - 2)**2 +   x(2)**2  <= 5,
  //                x(1) >= 0.
  //
  //==================================================================

  F[0] =  x[1];
  F[1] =  x[0]*x[0] + 4*x[1]*x[1];
  F[2] = (x[0] - 2)*(x[0] - 2) + x[1]*x[1];
  return 0;
}

int toyusrfg_( integer    *Status, integer *n,    doublereal x[],
	       integer    *needF,  integer *neF,  doublereal F[],
	       integer    *needG,  integer *neG,  doublereal G[],
	       char       *cu,     integer *lencu,
	       integer    iu[],    integer *leniu,
	       doublereal ru[],    integer *lenru )
{
  //==================================================================
  // Computes the nonlinear objective and constraint terms for the toy
  // problem featured in the SnoptA users guide.
  // neF = 3, n = 2.
  //
  //   Minimize     x(2)
  //
  //   subject to   x(1)**2      + 4 x(2)**2  <= 4,
  //               (x(1) - 2)**2 +   x(2)**2  <= 5,
  //                x(1) >= 0.
  //
  // The triples (g(k),iGfun(k),jGvar(k)), k = 1:neG, define
  // the sparsity pattern and values of the nonlinear elements
  // of the Jacobian.
  //==================================================================

  if ( *needF > 0 ) {
    F[0] =  x[1]; //  Objective row
    F[1] =  x[0]*x[0] + 4*x[1]*x[1];
    F[2] = (x[0] - 2)*(x[0] - 2) + x[1]*x[1];
  }

  if ( *needG > 0 ) {
    // iGfun[*neG] = 1
    // jGvar[*neG] = 1
    *neG    = 0;
    G[*neG] = 0;

    // iGfun[*neG] = 1
    // jGvar[*neG] = 2
    *neG    = *neG + 1;
    G[*neG] = 1.0;

    // iGfun[*neG] = 2
    // jGvar[*neG] = 1
    *neG    = *neG + 1;
    G[*neG] = 2*x[0];

    // iGfun[*neG] = 2
    // jGvar[*neG] = 2
    *neG    = *neG + 1;
    G[*neG] = 8*x[1];

    // iGfun[*neG] = 3
    // jGvar[*neG] = 1
    *neG    = *neG + 1;
    G[*neG] = 2*(x[0] - 2);

    // iGfun[*neG] = 3
    // jGvar[*neG] = 2
    *neG    = *neG + 1;
    G[*neG] = 2*x[1];
    *neG    = *neG + 1;
  }
  return 0;
}
