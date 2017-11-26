%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (i)

/*
  
GIVEN:

*/  

natural_number(0).
natural_number(s(X)) :- natural_number(X).



/*
	X lesseq Y :-  X and Y are natural numbers,
	  		  such that X is less than or equal to Y.

We use lesseq to represent the operator rather than cause problems
with an error message from Prolog about redefining an operator!
*/


:- op(40, xfx, lesseq).

0 lesseq X :- natural_number(X).
s(X) lesseq s(Y) :- X lesseq Y.


:- op(40, xfx, less).

0 less s(X) :- natural_number(X).
s(X) less s(Y) :- X less Y.

:- op(40, xfx, greatereq).

X greatereq 0 :- natural_number(X).
s(X) greatereq s(Y) :- X greatereq Y.

:- op(40, xfx, greater).

s(X) greater 0 :- natural_number(X).
s(X) greater s(Y) :- X greater Y.


/*
 ['exercises-3.1'].
 
%

% 0 <= 1
0 lesseq s(0).

% 1 <= 0
s(0) lesseq 0.

% 0 <= 0
0 lesseq 0.
 

% 0 < 0 
0 less 0.

% 0 < 1
0 less s(0).

% 1 < 0
s(0) less 0.

% 1 < 1 
s(0) less s(0).



% 0 > 0 
0 greater 0.

% 0 > 1
0 greater s(0).

% 1 > 0
s(0) greater 0.

% 1 > 1 
s(0) greater s(0).



% 0 > 0 
0 greatereq 0.

% 0 > 1
0 greatereq s(0).

% 1 > 0
s(0) greatereq 0.

% 1 > 1 
s(0) greatereq s(0).


*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (ii)
%
% See exerice-3.1-ii.tex
%

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iii)
%
% See exerice-3.1-iii.tex
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iv)
%
 
% 0 is neither even or odd

odd(s(0)).
odd(s(s(X))) :- odd(X).

even(s(s(0))).
even(s(s(X))) :- even(X).


/*
 ['exercises-3.1'].

odd(X).
even(X).

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (v)
%
%


% Given:
plus(0,X,X) :- natural_number(X).
plus(s(X),Y,s(Z)):- plus(X,Y,Z).

pred(s(X), X).

fib(0, 0).
fib(s(0), s(0)).

fib(N, F) :-
    pred(N, PredN),
    pred(PredN, PredPredN),
    fib(PredN, F1),
    fib(PredPredN, F2),
    plus(F1, F2, F).

/*
  
['exercises-3.1'].

fib(N, F).
  
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (vi)
%
%

divide(X, Divisor, 0) :- X less Divisor.
%divide(X, X, s(0)).
divide(X, Divisor, R) :- 
    plus(Divisor, Difference, X),
    divide(Difference, Divisor, ResultMinusOne),
    R = s(ResultMinusOne).
/*
  
['exercises-3.1'].

divide(s(s((0))), s(s(s(0))), R).
divide(s(0), s(0), R).
divide(s(s(s(s(0)))), s(s(0)), R).
  
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (vii)
%
%

gcd(X, X, X).
gcd(X, Y, Gcd) :- 
    X greater Y,
    plus(Y, Diff, X),
    gcd(Y, Diff, Gcd).        
gcd(X, Y, Gcd) :- 
    Y greater X,
    plus(X, Diff, Y),
    gcd(X, Diff, Gcd).        

/*
  
['exercises-3.1'].

gcd(s(s(s(s(0)))), s(s(0)), Gcd).
gcd(s(s(0)), s(s(s(s(s(s(0)))))), Gcd).
  
gcd(X, Y, Gcd).
  
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (viii)
%
% Boring and mechanical skipped.
