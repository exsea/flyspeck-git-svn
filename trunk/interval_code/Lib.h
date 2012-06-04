/* ========================================================================== */
/* FLYSPECK - CODE FORMALIZATION                                              */
/*                                                                            */
/* Chapter: nonlinear inequalities                                           */
/* Author:  Thomas Hales     */
/* Date: 1997, 2010-09-04                                                    */
/* Date: Moved from taylorData 2012-6-1                                      */
/* ========================================================================= */


/*
CLASS
	Lib

	A library of static Functions of six variables.

OVERVIEW TEXT

	This class contains the most important Functions for
	sphere packings.  Much more general functions can be built
	up by taking linear combinations of these, using the operator
	overloading on addition and scalar multiplication for
	Functions.

AUTHOR
	
	Thomas C. Hales
*/


class Lib
{
 public:

  static const univariate i_ghi,i_lfun,i_rho;

  static const Function promote1_to_6(const univariate&);

  static const Function constant6(const interval&);

  static const Function unit,x1,x2,x3,x4,x5,x6,y1,y2,y3,y4,y5,y6;

	//////////
	// reorder args f(x2,x3,x1,x5,x6,x2); etc.
	//
 static Function rotate2(const Function&);
 static Function rotate3(const Function&);
 static Function rotate4(const Function&);
 static Function rotate5(const Function&);
 static Function rotate6(const Function&);

 static Function uni(const univariate&,const Function&);


	//////////
	// unit is the constant function taking value 1.
	// x1,..,x6 are the squares of the edge lengths.
	// y1,...y6 are the edge lengths.
	// dih,dih2,dih3, are the dihedral angles along the first
	// three edges.
	// sol is the solid angle of a simplex
        // all of these are expressed in terms of the variables xi.
	//
 static const Function delta_x,dih_x,sol_x,rad2_x;

   // autogenerated.
static const Function   
   
   delta_x4,x1_delta_x,delta4_squared_x,vol_x,
   dih2_x,dih3_x,dih4_x,dih5_x,dih6_x,
  rhazim_x,rhazim2_x,rhazim3_x,
   ldih_x,ldih2_x,ldih3_x,ldih5_x,ldih6_x,
  halfbump_x1,halfbump_x4,
  gchi1_x,
   eulerA_x;
	//
#ifdef skip

#endif
static void selfTest();

};