#include <stdio.h>
#include <string.h>
//#include <iostream>

#include "toyfunction.hh"
#include "snfilewrapper.hh"
#include "snopt.hh"
#include "snoptProblem.hh"

using namespace std;

int main( int argc, char **argv)
{
  printf("\nSolving toy0 problem with no derivatives...\n");

  snoptProblem ToyProb;
  // Allocate and initialize;
  integer n     =  2;
  integer neF   =  3;
  integer lenA  = 10;

  integer *iAfun = new integer[lenA];
  integer *jAvar = new integer[lenA];
  doublereal *A  = new doublereal[lenA];

  integer lenG   = 10;
  integer *iGfun = new integer[lenG];
  integer *jGvar = new integer[lenG];

  doublereal *x      = new doublereal[n];
  doublereal *xlow   = new doublereal[n];
  doublereal *xupp   = new doublereal[n];
  doublereal *xmul   = new doublereal[n];
  integer    *xstate = new    integer[n];

  doublereal *F      = new doublereal[neF];
  doublereal *Flow   = new doublereal[neF];
  doublereal *Fupp   = new doublereal[neF];
  doublereal *Fmul   = new doublereal[neF];
  integer    *Fstate = new integer[neF];

  integer nxnames = 1;
  integer nFnames = 1;
  char *xnames = new char[nxnames*8];
  char *Fnames = new char[nFnames*8];

  integer    ObjRow = 0;
  doublereal ObjAdd = 0;

  // Set the upper and lower bounds.
  xlow[0]   =  0.0;  xlow[1]   = -1e20;
  xupp[0]   = 1e20;  xupp[1]   =  1e20;
  xstate[0] =    0;  xstate[1] =  0;

  Flow[0] = -1e20; Flow[1] = -1e20; Flow[2] = -1e20;
  Fupp[0] =  1e20; Fupp[1] =   4.0; Fupp[2] =  5.0;

  x[0]    = 1.0;
  x[1]    = 1.0;

  // Load the data for ToyProb ...
  ToyProb.setPrintFile  ( "Toy0.out" );
  ToyProb.setProblemSize( n, neF );
  ToyProb.setObjective  ( ObjRow, ObjAdd );
  ToyProb.setA          ( lenA, iAfun, jAvar, A );
  ToyProb.setG          ( lenG, iGfun, jGvar );
  ToyProb.setX          ( x, xlow, xupp, xmul, xstate );
  ToyProb.setF          ( F, Flow, Fupp, Fmul, Fstate );
  ToyProb.setXNames     ( xnames, nxnames );
  ToyProb.setFNames     ( Fnames, nFnames );
  ToyProb.setProbName   ( "Toy0" );
  ToyProb.setUserFun    ( toyusrf_ );
  // snopta will compute the Jacobian by finite-differences.
  // The user has the option of calling  snJac  to define the
  // coordinate arrays (iAfun,jAvar,A) and (iGfun, jGvar).
  ToyProb.computeJac    ();
  ToyProb.setIntParameter( "Derivative option", 0 );

  integer Cold = 0, Basis = 1, Warm = 2;

  ToyProb.solve( Cold );

  printf("\nSolving toy1 problem using derivatives...\n");

  // Reset the variables and solve ...
  integer neA, neG; // neA and neG must be defined when using dervatives
  xstate[0] =   0;  xstate[1] = 0;
  Fmul[0]   =   0;  Fmul[0]   = 0; Fmul[0] =    0;
  x[0]      = 1.0;
  x[1]      = 1.0;

  neG        = 0;
  iGfun[neG] = 0;
  jGvar[neG] = 0;

  neG++;
  iGfun[neG] = 0;
  jGvar[neG] = 1;

  neG++;
  iGfun[neG] = 1;
  jGvar[neG] = 0;

  neG++;
  iGfun[neG] = 1;
  jGvar[neG] = 1;

  neG++;
  iGfun[neG] = 2;
  jGvar[neG] = 0;

  neG++;
  iGfun[neG] = 2;
  jGvar[neG] = 1;

  neG++;   // *neG = 6

  neA = 0;

  // As snoptProblem::computeJac() is not used to compute the
  // derivatives,  neA and neG must be set here to match the
  // arrays  A, iAfun, jAvar, iGfun, jGvar.
  ToyProb.setNeA         ( neA );
  ToyProb.setNeG         ( neG );
  ToyProb.setUserFun     ( toyusrfg_ );      // Sets the usrfun that supplies G and F.
  ToyProb.setProbName    ( "Toy1" );         // Give the problem a new name for Snopt.
  ToyProb.setPrintFile   ( "Toy1.out" );
  ToyProb.setSpecsFile   ( "sntoya.spc" );
  ToyProb.setIntParameter( "Derivative option", 1 );
  ToyProb.setIntParameter( "Major Iteration limit", 250 );
  ToyProb.solve          ( Cold );

  delete []iAfun;  delete []jAvar;  delete []A;
  delete []iGfun;  delete []jGvar;

  delete []x;      delete []xlow;   delete []xupp;
  delete []xmul;   delete []xstate;

  delete []F;      delete []Flow;   delete []Fupp;
  delete []Fmul;   delete []Fstate;

  delete []xnames; delete []Fnames;
}
