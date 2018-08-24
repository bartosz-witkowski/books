:- ensure_loaded(readatom).

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

% simplify(+List,-Result)
simplify(List, Result) :-
    sr(List, NewList),
    !,
    simplify(NewList, Result).

simplify([W|Words], [W|NewWords]) :-
    simplify(Words, NewWords).

simplify([], []).
 
% tr(?Input, ?Result).
% Translation rules
tr([quit], [quit]).
tr([list], [ls]).
tr([list, all, information | Dir], [ls, '-al' | Dir]).
tr([list, information, all | Dir], [ls, '-al' | Dir]).
tr([list, all | Dir], [ls, '-a' | Dir]).
tr([list | Dir], [ls | Dir]).
tr([cp, recursively, Source, Target], [cp, '-r', Source, Target]).
tr([cp, Source, Target], [cp, '-r', Source, Target]).

translate(Input, Result) :-
  tr(Input, Result),
  !.

translate(_, []) :-
  write('I do not understand.'),
  nl.

% make_string(+List_Of_Atoms, -String)
make_string([H|T], Result) :-
  name(H, Hstring),
  name(' ', Space),
  make_string(T, Tstring),
  append(Hstring, Space, First),
  append(First, Tstring, Result).

make_string([], []).

pass_to_os([quit]) :- !.
pass_to_os([]) :- !.
pass_to_os(Command) :-
  make_string(Command, S), 
  writef(S),
  nl,
  shell(S).

process_commands :-
  repeat,
    write('> '),
    read_atomics(Words),
    simplify(Words, Simplification),
    translate(Simplification, Command),
    pass_to_os(Command),
    Command == [quit],
  !.

/*
Sample session

?- process_commands.
> list all
ls -a 
.  ..  2.2.1.1  2.2.1.2  2.2.2.1.pl  2.2.3.1.pl  2.2.4.1.pl  2.2.4.2.pl  2.2.4.3.pl  .2.2.4.3.pl.swp  readatom.pl
> list all files
ls -a 
.  ..  2.2.1.1  2.2.1.2  2.2.2.1.pl  2.2.3.1.pl  2.2.4.1.pl  2.2.4.2.pl  2.2.4.3.pl  .2.2.4.3.pl.swp  readatom.pl
> list
ls 
2.2.1.1  2.2.1.2  2.2.2.1.pl  2.2.3.1.pl  2.2.4.1.pl  2.2.4.2.pl  2.2.4.3.pl  readatom.pl
> list all files starting with read
ls -a read* 
readatom.pl
> quit
true.
*/
