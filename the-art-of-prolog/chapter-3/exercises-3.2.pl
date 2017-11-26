%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (i)

/*
 * subsequence(Sub, List) :- 
 *      Description below
 */

subsequence([X|Xs], [X|Ys]) :- subsequence(Xs, Ys).
subsequence(Xs, [_Y|Ys]) :- subsequence(Xs, Ys).
subsequence([], _Ys).

/*
  subsequence is defined that it will unify if all of the elements in Sub 
  are in List but they don't have to be consequitve. For example

['exercises-3.2'].

subsequence([1, 2, 3], [1, 9, 2, 9, 3, 9]).

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (ii)
%

adjacent(X, Y, [X,Y|_Tail]).
adjacent(X, Y, [_A,B|Tail]) :- 
    adjacent(X, Y, [B|Tail]).

last(X, [X]).
last(X, [_Y|Ys]) :- last(X, Ys).

/*
  
['exercises-3.2'].

% true:
adjacent(1, 2, [1, 2, 3, 4 , 5]).
adjacent(1, 2, [5, 1, 2, 3 , 4]).
adjacent(1, 2, [4, 5, 1, 2 , 3]).
adjacent(1, 2, [3, 4, 5, 1 , 2]).

% false:
adjacent(1, 2, [9, 9, 1, 9 , 2]).
adjacent(1, 2, [1, 1, 1, 9 , 2]).
adjacent(1, 2, [1, 0, 0, 0 , 2]).

% true:
last(1, [1]).
last(1, [0,1]).
last(1, [0,0,1]).

% false:
last(1, [1,0,0]).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iii)
%

double([X], [X,X]).
double([X|Xs], [X,X|Ys]) :- double(Xs, Ys).

/*
  
['exercises-3.2'].

double([1, 2, 3], [1, 1, 2, 2, 3, 3]).
double([1, 2, 2, 3], [1, 1, 2, 2, 2, 2, 3, 3]).
double([1], [1]).

double([1, 2, 3], [1, 1, 2, 2, 3, 3]).

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iv)

/*
Using the proof tree is in figure 3.5 we see that the length reverse([], []) is
1. Length of reverse is sum of reverse of a list on shorter and append([], [_],
[_]). And so on.

so:
*/

len_naive(0, 1).
len_naive(N, Len) :- 
    PredN is N - 1,
    len_naive(PredN, LenOneLess),
    Len is N + LenOneLess.

/*
  
For more see the lazy caterers sequence.
  
 */

/*
 
The reverse with accumulate has n+2 steps.

*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (v)
%
% I am going to cheat a little and use prologs built in numbers not
% the representation used in the book for the first part. No that it matters
% it's just easier to test.
%

sum([], 0).
sum([X|Rest], Sum) :-
    plus(X, Diff, Sum),
    sum(Rest, Diff).

%
% Second using Peano
% 
    
sum_peano([], 0).
sum_peano([0|Xs], Sum) :- sum_peano(Xs, Sum).
sum_peano([s(X)|Xs], s(Rest)) :- sum_peano([X|Xs], Rest).

/*
  
['exercises-3.2'].

% true
sum([], 0).
sum([0], 0).
sum([1], 1).
sum([1, 2], 3).
sum([1, 2, 3], 6).

% false
sum([1], 6).

% Peano

sum_peano([0], X).
sum_peano([s(0)], X).
sum_peano([s(s(0))], X).
sum_peano([s(s(0)), s(s(0)), s(0)], X).

*/
