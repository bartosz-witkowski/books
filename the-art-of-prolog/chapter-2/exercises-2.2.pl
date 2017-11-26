%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exercise 2.2 (i)

course(software_engineering_sem,       time(thursday,  14, 16),  lecturer(p, k), location(c3, 1177)).
course(methods_of_ai_lecture,          time(wednesday, 10, 12), lecturer(i, p),  location(c3, 1177)).
course(methods_of_ai,                  time(wednesday, 12, 14), lecturer(i, p),  location(c3, 0056)).
course(finite_elements_method_lecture, time(wednesday, 14, 16), lecturer(k, b),  location(c3, 1177)).
course(finite_elements_method,         time(wednesday, 16, 18), lecturer(k, b),  location(c3, 0086)).
course(entropy_and_compresion,         time(thursday,  12, 14), lecturer(p, s),  location(c3, 0053)).
course(entropy_and_compresion_lecture, time(friday,     8, 10), lecturer(j, t),  location(c3, 0174)).


location(Course, Building) :-
    course(Course, _, _, location(Building, _)).

busy(Lecturer, Time) :-
    course(_, Time, Lecturer, _).

%
% I don't understand what would the cannot_meet predicate calculate - at this
% point we havent't seen recursive rules which would be needed to test if all
% hours are indeed taken. I'm going to skip this.
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exercise 2.2 (ii)

course(conflicting_course, time(wednesday, 12, 14), lecturer(z, z),  location(c3, 0056)).

schedule_conflict(Time, Place, Course1, Course2) :-
    course(Course1, Time, _, Place),
    course(Course2, Time, _, Place),
    Course1 \= Course2.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exercise 2.2 (iii)

% Straight 5's
course_taken(john, course1, 5.0).
course_taken(john, course2, 5.0).
course_taken(john, course3, 5.0).
course_taken(john, course4, 5.0).
course_taken(john, course5, 5.0).
course_taken(john, course6, 5.0).

% one course failed
course_taken(jake, course1, 5.0).
course_taken(jake, course2, 5.0).
course_taken(jake, course3, 5.0).
course_taken(jake, course4, 5.0).
course_taken(jake, course5, 2.0).
course_taken(jake, course6, 5.0).

% one course not taken
course_taken(jim, course1, 5.0).
course_taken(jim, course2, 5.0).
course_taken(jim, course3, 5.0).
course_taken(jim, course4, 5.0).
course_taken(jim, course5, 2.0).

passed_course(Student, Course) :-
    course_taken(Student, Course, Mark),
    Mark >= 3.0.

requirements_met(Student) :-
    passed_course(Student, course1),
    passed_course(Student, course2),
    passed_course(Student, course3),
    passed_course(Student, course4),
    passed_course(Student, course5),
    passed_course(Student, course6).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exercise 2.2 (iv)

product(banana, 89, 22.84, 0.33,  1.09).
product(onion, 40, 7.64,  0.10,  1.10).
product(apple, 52, 13.81, 0.17,  0.26).
product(chicken_breast, 100, 0, 1.3, 21.5).

kcal(Name, Kcal) :-
    product(Name, Kcal, _, _, _).

carbohydrates(Name, Carbo) :-
    product(Name, _, Carbo, _, _).

fat(Name, Fat) :-
    product(Name, _, _, Fat, _).

protein(Name, Protein) :-
    product(Name, _, _, _, Protein).

lots_of_gains(Name) :-
    protein(Name, Protein),
    Protein >= 15.

low_calories(Name) :-
    kcal(Name, Kcal),
    Kcal < 50.

/*
 ['exercises-2.2']. 

 Testing:
    (i)
    location(software_engineering_sem, X).
    busy(lecturer(i, p), X).

    (ii)
    schedule_conflict(Time, Place, C1, C2).
    
    (iii)
    requirements_met(jim).

    (iv)
    kcal(Name, Kcal).
    carbohydrates(onion, C).
    fat(Name, F).
    lots_of_gains(X).
    low_calories(X).
 */
