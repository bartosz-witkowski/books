%

father(terach, abraham).
father(terach, nachor).
father(haran, lot).
father(haran, milcah).
father(haran, yilscah).

mother(sarah, isaac).

male(terach).
male(abraham).
male(nachor).
male(haran).
male(isaac).
male(lot).

female(sarah).
female(milcah).
female(yiscah).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

brother(Brother, Sib) :-
    parent(Parent, Brother),
    parent(Parent, Sib),
    male(Brother),
    Brother \= Sib.
    

parent(X, Y) :- father(X, Y).
parent(X, Y) :- mother(X, Y).

uncle(Uncle, Person) :-
    brother(Uncle, Parent), 
    parent(Parent, Person).

old_sibling(Sib1, Sib2) :-
    parent(Parent, Sib1), 
    parent(Parent, Sib2).

% exercise 2.1 (i)

sister(Sister, Sib) :-
    parent(Parent, Sister),
    parent(Parent, Sib),
    female(Sister),
    Sister \= Sib.

niece(Niece, Person) :-
    parent(Parent, Niece),
    brother(Person, Parent),
    female(Niece).

sibling(Sib1, Sib2) :-
    mother(Mother, Sib1),
    mother(Mother, Sib2),
    father(Father, Sib1),
    father(Father, Sib2),
    Sib1 \= Sib2.

% execise 2.1 (ii)

spouse(Husband, Wife) :- married_couple(Wife, Husband).
spouse(Wife, Husband) :- married_couple(Wife, Husband).

mother_in_law(MotherInLaw, Person) :-
    spouse(Spouse, Person),
    mother(MotherInLaw, Spouse).

brother_in_law(BrotherInLaw, Person) :-
    married_couple(Person, Spouse),
    brother(BrotherInLaw, Spouse).

son_in_law(SonInLaw, Person) :-
    mother(Person, Daughter),
    married_couple(Daughter, SonInLaw).

% exercise 2.1 (iii)

left_of(butterfly, fish).
left_of(hourglass, butterfly).
left_of(pencil, hourglass).
above(bicycle, pencil).
above(camera, butterfly).

right_of(X, Y) :- left_of(Y, X).
below(X, Y) :- above(Y, X).
