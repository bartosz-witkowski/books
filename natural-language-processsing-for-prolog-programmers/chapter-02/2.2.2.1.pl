/*
I've made a right mess out of this - I didn't understand how the simplification and translation rules will be applied in practice hence the one I've wrote for 2.2.2.1 and 2.2.1.2 are useless if I wanted to implement them the way the book suggests. 

On the other hand all we need is to recursively call simplify via simplify_top to get the desired behaviour

% simplification rules
% sr(T1,T2)
sr([list, list | X], [list| X]).
sr([for|X], X).
sr([them|X], X).
sr([and|X], X).
sr([in|X], X).
sr([into|X], X).
sr([to|X], X).
sr([show | X], [list | X]).
sr([list, all | X], [all, list | X]).
sr([all, information | X], [information, all | X]).
sr([list, information | X], [information, list | X]).
sr([list, files | X], [list | X]).
sr([list, directory | X], [list | X]).
sr([list, ending, Ending  | X], [list, Result | X]) :- atom_concat('*', Ending, Result).
sr([list, starting, Start | X], [list, Result | X]) :- atom_concat(Start, '*', Result).
sr([copy, recursively | X], [recursively, copy | X]).

simplify_top(List, Result) :-
  simplify(List, SomeResult),
  (  List = SomeResult
  -> Result = SomeResult
  ;  simplify(SomeResult, Result)).

The modified simplification rules are here:

*/

% simplification rules
% sr(T1,T2)
sr([files, ending, Word, Ending  | X], [Result | X]) :- 
    (Word = in; Word = with),
    atom_concat('*', Ending, Result).
sr([files, starting, Word, Start | X], [Result | X]) :- 
    (Word = in; Word = with),
    atom_concat(Start, '*', Result).
sr([and, list, information | X], [information | X]).
sr([and, show, information | X], [information | X]).
sr([into | X], X).
sr([to | X], X).
sr([and | X], X).
sr([for|X], X).
sr([them|X], X).
sr([in|X], X).
sr([files|X], X).
sr([file|X], X).
sr([directory|X], X).
sr([show, information | X], [list, information | X]).
sr([show | X], [list | X]).

/*

consult('2.2.2.1.pl').

simplify([list, all, and, show, information, for, files, starting, in, dmesg], Result).
simplify([list, files, in, directory, '/tmp'], Result).
simplify([show, files, in, directory, '/tmp'], Result).
simplify([list, directory, '/tmp'], Result).
simplify([list, '/tmp'], Result).
simplify([list, files], Result).
simplify([list], Result).
simplify([show, files], Result).
simplify([show, all, files, in, '/tmp'], Result).
simplify([show, information, for, all, files, in, '/tmp'], Result).
simplify([list, all, files, in, directory, '/tmp'], Result).
simplify([list, all, files, and, show, information, for, them, in, '/tmp'], Result).
simplify([list, all, files, and, show, information, in, '/tmp'], Result).
simplify([list, files, ending, in, '/tmp'], Result).
simplify([list, all, files, ending, in, '/tmp'], Result).
simplify([list, all, and, show, information, for, files, ending, in, '/tmp'], Result).
simplify([list, files, starting, in, '/tmp'], Result).
simplify([list, all, files, starting, in, '/tmp'], Result).
simplify([list, all, and, show, information, for, files, starting, in, '/tmp'], Result).
simplify([copy, recursively, '/etc', into, '/tmp'], Result).
simplify([copy, recursively, '/etc', to, '/tmp'], Result).

*/

% simplify(+List,-Result)
simplify(List, Result) :-
    sr(List, NewList),
    !,
    simplify(NewList, Result).

simplify([W|Words], [W|NewWords]) :-
    simplify(Words, NewWords).

simplify([], []).
