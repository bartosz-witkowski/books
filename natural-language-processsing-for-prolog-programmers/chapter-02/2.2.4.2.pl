% make_string(+List_Of_Atoms, -String)
make_string([H|T], Result) :-
  name(H, Hstring),
  make_string(T, Tstring),
  append(Hstring, Tstring, Result).

make_string([], []).

pass_to_os([quit]) :- !.
pass_to_os([]) :- !.
pass_to_os(Command) :-
  make_string(Command, S), 
  writef(S),
  nl,
  shell(S).
