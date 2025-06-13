// Matthew McCaughan
// Implementation of Bisection Method for solutions to polynomial functions
// Fall 2022

.data

// user set data 
coeff:  // coefficients of polynomial (double precision)
.double 0.2,3.1,-0.3,1.9,0.2

N:      // degree of the function (double word)
.dword 4

a:      // a (lower) bound (double precision)
.double -1

b:      // b (upper) bound (double precision)
.double 1

tau:    // tolerance (double precision)
.double 0.01



// addtional points of data
dtwo:
.double 2.0
str:
.ascii "Value of function at root: %lf\n\0"
str2:
.ascii "Root occurs at x = %lf\n\0"

.text
.global _start
.extern printf


_start:

main:   
ADR X8,dtwo     // placeholder 2 for floating point precision
ADR X9,coeff    // address of coeff array
ADR X10,N       // address of N (exp)
ADR X11,a       // address of a
ADR X12,b       // address of b
ADR X13,tau     // address of tau
ADR X25,str     // addressing printing strings
ADR X26,str2

LDR D11,[X8]    // placeholder for 2 in floating point precision
LDR D8,[X13]    // tau loaded into D0 with double precision

LDR D1,[X11]    // a into D1
LDR D2,[X12]    // b into D2
FMOV D18,D1
FMOV D19,D2
mainloop:
FSUB D10,D10,D10  // clearing sum
FADD D13,D18,D19  // c = a+b
FDIV D13,D13,D11  // c = a+b/2
FMOV D6,D13
BL value          // value gets f(c)
FMOV D7,D10       // f(c) stored into d7

FSUB D10,D10,D10  // clearing sum
FMOV D6,D18       // a passed as parameter for value
BL value          // value gets f(a)
FMOV D3,D10       // f(a) stored into d3

FSUB D10,D10,D10  // clearing sum
FMOV D6,D19       // b passed as parameter for value
BL value          // value gets f(b)
FMOV D4,D10       // f(b) stored into d4

MOV X20,0
SCVTF D20,X20
FSUB D19,D20,D8   // D19 is negative tau
FCMP D7,D8        // first two comparisons check for first condition of within tau
B.LT compa
FCMP D19,D7
B.GT compb

B compc           // f(c) is not within tau, must do another iteration

compa:             // compa and compb check second conditions of within tau
FCMP D7,D19
B.GT programterm

compb:
FCMP D8,D7
B.LT programterm

compc:
FCMP D7,D20      // compare f(c) and 0, if f(c) is greater than 0, [a,c] root bracket
B.GT outoflabels
// else [c,b] is the root bracket
FMOV D18,D13
B loopend

outoflabels:
FMOV D19,D13       // right side of bracket is now value of c

loopend:
FSUB D13,D13,D13  // clear D13
B mainloop

programterm:
MOV X0,X26
FMOV D0,D13
BL printf
FMOV D0,D7
MOV X0,X25
BL printf

MOV     X0, 0        // last three lines terminate the program correctly
MOV     X8, 93       // terminate
SVC     0            // terminate





value:
LDR X14,[X10]       // X14 is N
MOV X15,X14         // X15 is iterating through N

loop:

LSL X15,X15,3       // lsl for offset
LDR D5,[X9,X15]     // arr[N]
LSR X15,X15,3       // lsr to reset X15

exponentiation:     // exponentiates x
FMOV D16,D6          //X16 is x
MOV X17,X15         //X16 is N
exponentiationloop:
CMP X17,1           // X17 equal to 1 or 0, done exponentiating
B.EQ coef
CMP X17,0
B.EQ coef
FMUL D16,D6,D16      // a = X6*a
SUB X17,X17,1       // sub 1 from n
B exponentiationloop

coef: 
CMP X15,0           // last term of degree zero? just add term
B.EQ zerdeg         
//SCVTF D16,X16       // convert x^n to a real n
FMUL D5,D5,D16      // coeff*x^n
zerdeg:
FADD D10,D10,D5     // add term to sum (D10)

CMP X15,0           // X15 = 0? Done with all terms, exit
B.EQ exit
SUB X15,X15,1
B loop

exit:
RET

