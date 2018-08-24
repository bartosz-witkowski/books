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

/*

consult('2.2.3.1.pl').

*/

translate(Input, Result) :-
  tr(Input, Result),
  !.

translate(_, []) :-
  write('I do not understand.'),
  nl.
