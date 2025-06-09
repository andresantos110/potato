/*
 ****************************************************************************
 *
 *                   "DHRYSTONE" Benchmark Program
 *                   -----------------------------
 *                                                                            
 *  Version:    C, Version 2.1
 *                                                                            
 *  File:       dhrystone.c
 *
 *  Date:       May 25, 1988
 *
 *  Author:     Reinhold P. Weicker
 * 
 *  Modified for the Potato RISC-V CPU
 *
 ****************************************************************************
 */
#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "potato.h"
#include "icerror.h"
#include "uart.h"
#include "timer.h"
#include "p_prints.h"

#include "dhry.h"

#ifndef DHRY_ITERS
#define DHRY_ITERS 200000
#endif

/* Global Variables: */

Rec_Pointer     Ptr_Glob,
                Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob,
                Ch_2_Glob;
int             Arr_1_Glob [50];
int             Arr_2_Glob [50] [50];

extern char     *malloc ();
Enumeration     Func_1 ();
  /* forward declaration necessary since Enumeration may not simply be int */

#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#endif

/* variables for time measurement: */

#ifdef TIMES
static struct timer timer0;

#define Too_Small_Time (2*HZ)
                /* Measurements should last at least about 2 seconds */
#endif
#ifdef TIME
extern long     time();
                /* see library function "time"  */
#define Too_Small_Time 2
                /* Measurements should last at least 2 seconds */
#endif
#ifdef MSC_CLOCK
extern clock_t	clock();
#define Too_Small_Time (2*HZ)
#endif

long            Begin_Time,
                End_Time,
                User_Time;
float           Microseconds,
                Dhrystones_Per_Second;

/* end of variables for time measurement */

extern char* strcpy(char*, const char*);

extern int strcmp( char* s1, char* s2);

Boolean Func_2 (Str_30, Str_30);
void Proc_7 (One_Fifty Int_1_Par_Val, One_Fifty Int_2_Par_Val,
                    One_Fifty *Int_Par_Ref);

void Proc_8 (Arr_1_Dim Arr_1_Par_Ref, Arr_2_Dim Arr_2_Par_Ref,
                    int Int_1_Par_Val, int Int_2_Par_Val);

void Proc_6 (Enumeration Enum_Val_Par,
                    Enumeration *Enum_Ref_Par);

void Proc_5();
void Proc_4();

void Proc_1(Rec_Pointer Ptr_Val_Par);
void Proc_2(One_Fifty *Int_Par_Ref);
void Proc_3(Rec_Pointer *Ptr_Ref_Par);


extern int cyc_beg, cyc_end;
extern int instr_beg, instr_end;
extern int LdSt_beg, LdSt_end;
extern int Inst_beg, Inst_end;

static struct uart uart0;

void exception_handler()
{
	// Not used in this application
}

int
main ()
/*****/

  /* main program, corresponds to procedures        */
  /* Main and Proc_0 in the Ada version             */
{
        One_Fifty       Int_1_Loc;
  REG   One_Fifty       Int_2_Loc;
        One_Fifty       Int_3_Loc;
  REG   char            Ch_Index;
        Enumeration     Enum_Loc;
        Str_30          Str_1_Loc;
        Str_30          Str_2_Loc;
  REG   int             Run_Index;
  REG   int             Number_Of_Runs;

  /* Initializations */

  //Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
  //Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));

  // Initialize Timer
  timer_initialize(&timer0, (volatile void *) PLATFORM_TIMER0_BASE);
  timer_reset(&timer0);

  //Initialize Potato UART
  uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));

  Rec_Type rec0;
  Rec_Type rec1;

  Next_Ptr_Glob = &rec0;
  Ptr_Glob = &rec1;

  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
  Ptr_Glob->Discr                       = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
        /* Was missing in published program. Without this statement,    */
        /* Arr_2_Glob [8][7] would have an undefined value.             */
        /* Warning: With 16-Bit processors and Number_Of_Runs > 32000,  */
        /* overflow may occur for this array element.                   */

  print_s (&uart0, "\n\r");
  print_s (&uart0, "Dhrystone Benchmark, Version 2.1 (Language: C)\n\r");
  print_s(&uart0, "\n\r");
  if (Reg)
  {
    print_s (&uart0,"Program compiled with 'register' attribute\n\r");
    print_s (&uart0,"\n\r");
  }
  else
  {
    print_s (&uart0, "Program compiled without 'register' attribute\n\r");
    print_s (&uart0, "\n\r");
  }
// #ifdef DHRY_ITERS
//   Number_Of_Runs = DHRY_ITERS;
// #else
//   printf ("Please give the number of runs through the benchmark: ");
//   {
//     int n;
//     scanf ("%d", &n);
//     Number_Of_Runs = n;
//   }
//   printf ("\n\r");
// #endif

Number_Of_Runs = DHRY_ITERS;

  print_s (&uart0,"Execution starts, ");
  print_i (&uart0, Number_Of_Runs);
  print_s (&uart0," runs through Dhrystone\n\r");

  /***************/
  /* Start timer */
  /***************/
 
#ifdef TIMES
 timer_start(&timer0);
#endif
#ifdef TIME
  Begin_Time = time ( (long *) 0);
#endif
#ifdef MSC_CLOCK
  Begin_Time = clock();
#endif

  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
  {

    Proc_5();
    Proc_4();
      /* Ch_1_Glob == 'A', Ch_2_Glob == 'B', Bool_Glob == true */
    Int_1_Loc = 2;
    Int_2_Loc = 3;
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
    Enum_Loc = Ident_2;
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
      /* Bool_Glob == 1 */
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
    {
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
        /* Int_3_Loc == 7 */
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
        /* Int_3_Loc == 7 */
      Int_1_Loc += 1;
    } /* while */
      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
      /* Int_Glob == 5 */
    Proc_1 (Ptr_Glob);
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
                             /* loop body executed twice */
    {
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
          /* then, not executed */
        {
        Proc_6 (Ident_1, &Enum_Loc);
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
        Int_2_Loc = Run_Index;
        Int_Glob = Run_Index;
        }
    }
      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
      /* Int_1_Loc == 1, Int_2_Loc == 13, Int_3_Loc == 7 */
    Proc_2 (&Int_1_Loc);
      /* Int_1_Loc == 5 */

  } /* loop "for Run_Index" */

  /**************/
  /* Stop timer */
  /**************/
  
#ifdef TIMES
  timer_stop(&timer0);
  End_Time = timer_get_count(&timer0);
#endif
#ifdef TIME
  End_Time = time ( (long *) 0);
#endif
#ifdef MSC_CLOCK
  End_Time = clock();
#endif

  print_s (&uart0,"Execution ends\n\r");
  print_s (&uart0,"\n\r");
  print_s (&uart0,"Final values of the variables used in the benchmark:\n\r");
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Int_Glob:            ");
  print_i (&uart0, Int_Glob);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 5);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Bool_Glob:           ");
  print_i (&uart0, Bool_Glob);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 1);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Ch_1_Glob:           ");
  print_c (&uart0, Ch_1_Glob);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_c (&uart0, 'A');
  print_s (&uart0,"\n\r");

  print_s (&uart0, "Ch_2_Glob:           ");
  print_c (&uart0, Ch_2_Glob);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_c (&uart0, 'B');
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Arr_1_Glob[8]:       ");
  print_i (&uart0, Arr_1_Glob[8]);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 7);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Arr_2_Glob[8][7]:    ");
  print_i (&uart0, Arr_2_Glob[8][7]);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   Number_Of_Runs + 10\n\r");
  print_s (&uart0,"Ptr_Glob->\n\r");

  print_s (&uart0,"  Ptr_Comp:          ");
  print_i (&uart0, (int) Ptr_Glob->Ptr_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   (implementation-dependent)\n\r");

  print_s (&uart0,"  Discr:             ");
  print_i (&uart0, Ptr_Glob->Discr);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 0);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"  Enum_Comp:         ");
  print_i (&uart0, Ptr_Glob->variant.var_1.Enum_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 2);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "  Int_Comp:          ");
  print_i (&uart0, Ptr_Glob->variant.var_1.Int_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_i (&uart0, 17);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "  Str_Comp:          ");
  print_s (&uart0, Ptr_Glob->variant.var_1.Str_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   DHRYSTONE PROGRAM, SOME STRING\n\r");
  print_s (&uart0,"Next_Ptr_Glob->\n\r");

  print_s (&uart0,"  Ptr_Comp:          ");
  print_i (&uart0, (int) Next_Ptr_Glob->Ptr_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   (implementation-dependent), same as above\n\r");

  print_s (&uart0, "  Discr:             ");
  print_i (&uart0, Next_Ptr_Glob->Discr);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_i (&uart0, 0);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "  Enum_Comp:         ");
  print_i (&uart0, Next_Ptr_Glob->variant.var_1.Enum_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 1);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "  Int_Comp:          ");
  print_i (&uart0, Next_Ptr_Glob->variant.var_1.Int_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 18);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "  Str_Comp:          ");
  print_s (&uart0, Next_Ptr_Glob->variant.var_1.Str_Comp);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   DHRYSTONE PROGRAM, SOME STRING\n\r");

  print_s (&uart0,"Int_1_Loc:           ");
  print_i (&uart0, Int_1_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 5);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "Int_2_Loc:           ");
  print_i (&uart0, Int_2_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_i (&uart0, 13);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "Int_3_Loc:           ");
  print_i (&uart0, Int_3_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   ");
  print_i (&uart0, 7);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "Enum_Loc:            ");
  print_i (&uart0, Enum_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0, "        should be:   ");
  print_i (&uart0, 1);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"Str_1_Loc:           ");
  print_s (&uart0, Str_1_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n\r");

  print_s (&uart0, "Str_2_Loc:           ");
  print_s (&uart0, Str_2_Loc);
  print_s (&uart0,"\n\r");

  print_s (&uart0,"        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n\r");
  print_s (&uart0,"\n\r");

  User_Time = End_Time - Begin_Time;

  print_s(&uart0, "Usertime: ");
  print_i(&uart0, (int) User_Time);
  print_s (&uart0,"\n\r");

  print_s(&uart0, "Clock Frequency: ");
  print_i(&uart0, (int) HZ);
  print_s(&uart0, " MHz.");
  print_s (&uart0,"\n\r");


  if (User_Time < Too_Small_Time)
  {
    print_s (&uart0,"Measured time too small to obtain meaningful results\n\r");
    print_s (&uart0,"Please increase number of runs\n\r");
    print_s (&uart0,"\n\r");
  }
  else
  {

/*
#ifdef TIME
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
                        / (float) Number_Of_Runs;
    Dhrystones_Per_Second = (float) Number_Of_Runs / (float) User_Time;
#else
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
                        / ((float) HZ * ((float) Number_Of_Runs));
    Dhrystones_Per_Second = ((float) HZ * (float) Number_Of_Runs)
                        / (float) User_Time;
#endif
*/
    Microseconds = User_Time / (HZ * Number_Of_Runs);

    int step1 = (HZ * 1000000) / User_Time;
    Dhrystones_Per_Second = step1 * Number_Of_Runs;

    print_s (&uart0,"Microseconds for one run through Dhrystone: ");
    //printf ("%6.1f \n\r", Microseconds);
    print_i (&uart0, Microseconds);
    print_s (&uart0,"\n\r");
    print_s (&uart0,"Dhrystones per Second:                      ");
    //printf ("%6.1f \n\r", Dhrystones_Per_Second);
    print_i (&uart0,Dhrystones_Per_Second);
    print_s (&uart0,"\n\r");
  }
  
}

void
Proc_1 (Ptr_Val_Par)
/******************/

REG Rec_Pointer Ptr_Val_Par;
    /* executed once */
{
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
                                        /* == Ptr_Glob_Next */
  /* Local variable, initialized with Ptr_Val_Par->Ptr_Comp,    */
  /* corresponds to "rename" in Ada, "with" in Pascal           */
  
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
  Next_Record->variant.var_1.Int_Comp 
        = Ptr_Val_Par->variant.var_1.Int_Comp;
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
  Proc_3 (&Next_Record->Ptr_Comp);
    /* Ptr_Val_Par->Ptr_Comp->Ptr_Comp 
                        == Ptr_Glob->Ptr_Comp */
  if (Next_Record->Discr == Ident_1)
    /* then, executed */
  {
    Next_Record->variant.var_1.Int_Comp = 6;
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
           &Next_Record->variant.var_1.Enum_Comp);
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
           &Next_Record->variant.var_1.Int_Comp);
  }
  else /* not executed */
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
} /* Proc_1 */

void
Proc_2 (Int_Par_Ref)
/******************/
    /* executed once */
    /* *Int_Par_Ref == 1, becomes 4 */

One_Fifty   *Int_Par_Ref;
{
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
      /* then, executed */
    {
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */

void
Proc_3 (Ptr_Ref_Par)
/******************/
    /* executed once */
    /* Ptr_Ref_Par becomes Ptr_Glob */

Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != Null)
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
} /* Proc_3 */

void
Proc_4 () /* without parameters */
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
  Bool_Glob = Bool_Loc | Bool_Glob;
  Ch_2_Glob = 'B';
} /* Proc_4 */

void
Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
  Bool_Glob = false;
} /* Proc_5 */


        /* Procedure for the assignment of structures,          */
        /* if the C compiler doesn't support this feature       */
#ifdef  NOSTRUCTASSIGN
memcpy (d, s, l)
register char   *d;
register char   *s;
register int    l;
{
        while (l--) *d++ = *s++;
}
#endif

Boolean Func_3 (Enumeration Enum_Par_Val);

void
Proc_6 (Enum_Val_Par, Enum_Ref_Par)
/*********************************/
    /* executed once */
    /* Enum_Val_Par == Ident_3, Enum_Ref_Par becomes Ident_2 */

Enumeration  Enum_Val_Par;
Enumeration *Enum_Ref_Par;
{
  *Enum_Ref_Par = Enum_Val_Par;
  if (! Func_3 (Enum_Val_Par))
    /* then, not executed */
    *Enum_Ref_Par = Ident_4;
  switch (Enum_Val_Par)
  {
    case Ident_1: 
      *Enum_Ref_Par = Ident_1;
      break;
    case Ident_2: 
      if (Int_Glob > 100)
        /* then */
      *Enum_Ref_Par = Ident_1;
      else *Enum_Ref_Par = Ident_4;
      break;
    case Ident_3: /* executed */
      *Enum_Ref_Par = Ident_2;
      break;
    case Ident_4: break;
    case Ident_5: 
      *Enum_Ref_Par = Ident_3;
      break;
  } /* switch */
} /* Proc_6 */

void
Proc_7 (Int_1_Par_Val, Int_2_Par_Val, Int_Par_Ref)
/**********************************************/
    /* executed three times                                      */ 
    /* first call:      Int_1_Par_Val == 2, Int_2_Par_Val == 3,  */
    /*                  Int_Par_Ref becomes 7                    */
    /* second call:     Int_1_Par_Val == 10, Int_2_Par_Val == 5, */
    /*                  Int_Par_Ref becomes 17                   */
    /* third call:      Int_1_Par_Val == 6, Int_2_Par_Val == 10, */
    /*                  Int_Par_Ref becomes 18                   */
One_Fifty       Int_1_Par_Val;
One_Fifty       Int_2_Par_Val;
One_Fifty      *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
} /* Proc_7 */

void
Proc_8 (Arr_1_Par_Ref, Arr_2_Par_Ref, Int_1_Par_Val, Int_2_Par_Val)
/*********************************************************************/
    /* executed once      */
    /* Int_Par_Val_1 == 3 */
    /* Int_Par_Val_2 == 7 */
Arr_1_Dim       Arr_1_Par_Ref;
Arr_2_Dim       Arr_2_Par_Ref;
int             Int_1_Par_Val;
int             Int_2_Par_Val;
{
  REG One_Fifty Int_Index;
  REG One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
  Int_Glob = 5;
} /* Proc_8 */


Enumeration Func_1 (Ch_1_Par_Val, Ch_2_Par_Val)
/*************************************************/
    /* executed three times                                         */
    /* first call:      Ch_1_Par_Val == 'H', Ch_2_Par_Val == 'R'    */
    /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
    /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

Capital_Letter   Ch_1_Par_Val;
Capital_Letter   Ch_2_Par_Val;
{
  Capital_Letter        Ch_1_Loc;
  Capital_Letter        Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)
    /* then, executed */
    return (Ident_1);
  else  /* not executed */
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
} /* Func_1 */


Boolean Func_2 (Str_1_Par_Ref, Str_2_Par_Ref)
/*************************************************/
    /* executed once */
    /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
    /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

Str_30  Str_1_Par_Ref;
Str_30  Str_2_Par_Ref;
{
  REG One_Thirty        Int_Loc;
      Capital_Letter    Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2) /* loop body executed once */
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
                Str_2_Par_Ref[Int_Loc+1]) == Ident_1)
      /* then, executed */
    {
      Ch_Loc = 'A';
      Int_Loc += 1;
    } /* if, while */
  if (Ch_Loc >= 'W' && Ch_Loc < 'Z')
    /* then, not executed */
    Int_Loc = 7;
  if (Ch_Loc == 'R')
    /* then, not executed */
    return (true);
  else /* executed */
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
      /* then, not executed */
    {
      Int_Loc += 7;
      Int_Glob = Int_Loc;
      return (true);
    }
    else /* executed */
      return (false);
  } /* if Ch_Loc */
} /* Func_2 */


Boolean Func_3 (Enum_Par_Val)
/***************************/
    /* executed once        */
    /* Enum_Par_Val == Ident_3 */
Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)
    /* then, executed */
    return (true);
  else /* not executed */
    return (false);
} /* Func_3 */
