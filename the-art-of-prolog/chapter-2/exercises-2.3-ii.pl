% 2.3 (ii)

%% I don't know how to *add* recursive rules without breaking left_of so I'll
%  add a rule is_left(Object1, Object2) which is recursive
%
%  XXX: I may come back to this later.

% given earlier:
left_of(butterfly, fish).
left_of(hourglass, butterfly).
left_of(pencil, hourglass).

above(bicycle, pencil).
above(camera, butterfly).

%
% recursive
%
is_left(X, Y) :- left_of(X, Y).
is_left(X, Y) :- left_of(X, Z), is_left(Z, Y).

is_above(X, Y) :- above(X, Y).
is_above(X, Y) :- above(X, Z), is_above(Z, Y).

is_right(X, Y) :- is_left(Y, X).

on_the_same_level(X, Y) :- is_left(X, Y).
on_the_same_level(X, Y) :- is_right(X, Y).

higher(X, Y) :-
    above(X, Y).

higher(X, Y) :-
    on_the_same_level(Y, Z),
    above(X, Z).

/*
 ['exercises-2.3-ii'].

 higher(bicycle, pencil).
 higher(bicycle, fish).

 */
