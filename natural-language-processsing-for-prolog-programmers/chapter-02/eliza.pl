%
% eliza
% adapted from http://web.stanford.edu/class/cs124/p36-weizenabaum.pdf

:- ensure_loaded(readatom).
:- dynamic current_action_aux/3, memory/1.

% debugging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tag_check(Predicate, Variable, Expected_Tag) :-
  (  Expected_Tag = list(Type)
  -> (  is_list(Variable)
     -> tag_check_list(Predicate, Variable, Type)
     ;  tag_check_error(Predicate, Variable, Expected_Tag)
     ), !
  ; (  call(Expected_Tag, Variable)
    -> true
    ;  tag_check_error(Predicate, Variable, Expected_Tag)
    ), !
  ).

dwrite(Predicate, Words) :-
  (  debug_enabled(Predicate)
  -> write(Predicate), write(': '), dwrite_aux(Words)
  ;  true).

dwrite_aux([]).
dwrite_aux([W | Words]) :-
  (  W = nl
  -> nl
  ;  write(W)
  ),
  dwrite_aux(Words).

% debug_enabled(response).
% debug_enabled(response_from_list).
% debug_enabled(response_from_scripts).
% debug_enabled(execute).
% debug_enabled(flatten_response).
% debug_enabled(find_matching_pattern).
% debug_enabled(assert_current_action_to_next_action).
debug_enabled(nothing).

% debug_enabled(find_rest_and_ground_aux).

tag_check_list(_, [], _).
tag_check_list(Predicate, [H | T], Expected_Tag) :-
  tag_check(Predicate, H, Expected_Tag),
  tag_check_list(Predicate, T, Expected_Tag).

tag_check_error(Predicate, Variable, Expected_Tag) :-
  write('ERROR in '), write(Predicate), write(': '), 
  write('expected `'), write(Expected_Tag), write('` is: '), write(Variable), nl, fail.

% start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eliza_prompt :-
  start(Start),
  show(Start),
  repeat,
    write('> '),
    read_atomics(Words),
    (  ( Words == [quit] ; Words = [quit, '.'])
    -> true
    ; (  Words = [] 
      -> fail
      ;  response(Words), 
         fail
      )
    ),
  !.

response(Words) :-
  dwrite(response, [response_words, ': ', Words, nl]),
  translate(Words, Translated),
  split_to_sentences(Translated, Sentences),
  dwrite(response, [translated, ': ', Translated, nl]),
  find_sentence_with_keywords(Sentences, Sentence, Sorted),
  dwrite(response, [sorted, ': ', Sorted, nl]),
  response_from_scripts(Sentence, Sorted),
  !.

find_sentence_with_keywords(Sentences, Sentence, Sorted_Scripts) :-
  ( find_sentence_with_keywords_aux(Sentences, Sentence, Sorted_Scripts), !
  ; [Sentence | _] = Sentences, Sorted_Scripts = []
  ).
  
non_empty([_ | _]).

find_sentence_with_keywords_aux([X | Xs], Sentence, Sorted_Scripts) :-
  (  sorted_all_with_keyword_matching(X, Sorted_Scripts), non_empty(Sorted_Scripts)
  -> X = Sentence
  ;  find_sentence_with_keywords_aux(Xs, Sentence, Sorted_Scripts)
  ).

punctuation(',').
punctuation('.').
punctuation(';').
punctuation('?').
punctuation('!').

sentence_separator(X) :- punctuation(X).
sentence_separator(but).
sentence_separator(yet).

split_to_sentences(Words, Sentences) :- 
  split_to_sentences_aux(Words, Sentences, [], []).

split_to_sentences_aux([], Sentences, Sentence_Acc, Sentences_Acc) :-
  (  Sentence_Acc = []
  -> reverse(Sentences_Acc, Sentences)
  ;  reverse(Sentence_Acc, Sentence),
     reverse([Sentence | Sentences_Acc], Sentences)
  ).

split_to_sentences_aux([X | Xs], Sentences, Sentence_Acc, Sentences_Acc) :-
  (  sentence_separator(X)
  -> reverse(Sentence_Acc, Sentence),
     split_to_sentences_aux(Xs, Sentences, [],                 [Sentence | Sentences_Acc])
  ;  split_to_sentences_aux(Xs, Sentences, [X | Sentence_Acc], Sentences_Acc)
  ).

% tr(Input, Output, Rest)
% XXX: ordering matters
tr([alike | X],         dit,       X).
tr([am | X],            are,       X).
tr([cant | X],          cannot,    X).
tr([can, '\'', t | X],  cannot,    X).
tr([certainly | X],     yes,       X).
tr([computers | X],     computer,  X).
tr([deutsch | X],       xfremd,    X).
tr([dont | X],          'don\'t',  X).
tr([don, '\'', t | X],  'don\'t',  X).
tr([dreamed | X],       dreamt,    X).
tr([dreams | X],        dream,     X).
tr([espanol | X],       xfremd,    X).
tr([francais | X],      xfremd,    X).
tr([français | X],      xfremd,    X).
tr([how | X],           what,      X).
tr([im | X],            'you\'re', X).
tr([i, '\'', m | X],    'you\'re', X).
tr([i, am | X],         'you\'re', X).
tr([i | X],             you,       X).
tr([machine | X],       computer,  X).
tr([machines | X],      computer,  X).
tr([maybe | X],         perhaps,   X).
tr([me | X],            you,       X).
tr([myself | X],        yourself,  X).
tr([my | X],            your,      X).
tr([no, one | X],       'no one',  X).
tr([noone | X],         'no one',  X).
tr([same | X],          dit,       X).
tr([were | X],          was,       X).
tr([when | X],          what,      X).
tr([wont | X],          'won\'t',  X).
tr([youre | X],         'i\'m',    X).
tr([you, '\'', re | X], 'i\'m',    X).
tr([you, are | X],      'i\'m',    X).
tr([you | X],           i,         X).
tr([your | X],          my,        X).
tr([yourself | X],      myself,    X).

% simplify(+List,-Result)
translate(List, Result) :-
    tr(List, T, Rest),
    !,
    translate(Rest, Rest_Translated),
    append([T], Rest_Translated, Result).

translate([W | Words], [W | New_Words]) :-
    translate(Words, New_Words).

translate([], []).

response_from_scripts(Words, Scripts) :-
  Predicate = response_from_scripts,
  tag_check(Predicate, Words, list(atom)),
  tag_check(Predicate, Scripts, list(is_script)),
  % 
  best_so_far_initial(Best_So_Far),
  response_from_list(Words, Scripts, Best_So_Far, Response), !,
  dwrite(Predicate, ['Response: ', Response, nl]),
  execute(Words, Response).

execute(Words, (Action, Keyword, Pattern_Index)) :-
  Predicate = execute,
  tag_check(Predicate, Action, is_response),
  tag_check(Predicate, Keyword, atom),
  tag_check(Predicate, Pattern_Index, number),
  %
  (  Keyword = your
  -> handle_memory(Words)
  ;  true
  ),
  print_response(Action),
  dwrite(Predicate, ['execute 1', nl]),
  assert_next_state(Keyword, Pattern_Index),
  dwrite(Predicate, ['execute 2', nl]),
  !.
  
handle_memory(Words) :-
  Predicate = handle_memory,
  tag_check(Predicate, Words, list(atom)),
  %
  random_memory_pattern(Pattern),
  Pattern = memory_pattern(matched(Match), Response),
  match(Words, Match),
  assert_append_memory_list(Response).

assert_append_memory_list(Response) :-
  memory(Old_List),
  append(Old_List, [Response], New_List),
  retract(memory(Old_List)),
  asserta(memory(New_List)).

retract_head_memory_list :-
  memory(Old_List),
  Old_List = [_ | New_List],
  retract(memory(Old_List)),
  asserta(memory(New_List)).

% dynamically modified
memory([]).
  
random_memory_pattern(Pattern) :-
  memory_patterns(Patterns),
  length(Patterns, Length),
  Upper is Length - 1,
  random_between(0, Upper, Index),
  nth0(Index, Patterns, Pattern).


print_response(response(Words)) :- 
  show(Words), !.

show(Words) :- show_aux(Words, first).

show_aux([], _) :- nl.
show_aux([Word | Words], First) :-
  ( First = first
  ; ( punctuation(Word)
    ; write(' ')
    )
  ),
  upcase_atom(Word, Upper),
  write(Upper), 
  show_aux(Words, next).

% best_so_far(response, keyword_priority, pattern_score)
best_so_far_response(best_so_far(X, _, _), X).
best_so_far_keyword_priority(best_so_far(_, X, _), X).
best_so_far_pattern_score(best_so_far(_, _, X), X).

is_best_so_far(best_so_far(_, _,_ )).

best_so_far_initial(Best_So_Far) :-
  (  response_memory(Response)
  -> true
  ;  response_none(Response)
  ),
  Best_So_Far = best_so_far(Response, -1, 0).

best_so_far_max(Best_So_Far, Response, New_Best) :-
  Response = (_, Keyword, Pattern_Index),
  best_so_far_keyword_priority(Best_So_Far, Best_Priority),
  script_by_keyword(Keyword, Script),
  script_priority(Script, Priority),
  pattern_score_by_index(Script, Pattern_Index, Pattern_Score),
  Candidate = best_so_far(Response, Priority, Pattern_Score),
  (  Priority > Best_Priority
  -> New_Best = Candidate 
  ;  (  Priority = Best_Priority
     -> best_so_far_pattern_score(Best_So_Far, Best_Pattern_Score),
        (  Pattern_Score > Best_Pattern_Score
        -> New_Best = Candidate
        ;  New_Best = Best_So_Far
        )
     ;  New_Best = Best_So_Far
     )
  ).

% response_from_list(+Words, +Script, -Response).
% Response = (response, keyword, pattern_index)
response_from_list(_, [], Best_So_Far, Response) :-
  best_so_far_response(Best_So_Far, Response).

response_from_list(Words, [Script | Rest], Best_So_Far, Response) :-
  Predicate = response_from_list,
  tag_check(Predicate, Words, list(atom)),
  tag_check(Predicate, Script, is_script),
  tag_check(Predicate, Rest, list(is_script)),
  tag_check(Predicate, Best_So_Far, is_best_so_far),
  %
  dwrite(Predicate, ['response_from_list', nl]),
  dwrite(Predicate, ['Script = ', Script, nl]),
  dwrite(Predicate, ['Rest = ', Rest, nl]),
  dwrite(Predicate, ['Best_So_Far = ', Best_So_Far, nl]),
  %
  script_priority(Script, Priority),
  best_so_far_keyword_priority(Best_So_Far, Best_Priority),
  (   Best_Priority > Priority
  ->  % nothing to do we already found our best
      best_so_far_response(Best_So_Far, Response)
  ;
      (  find_matching_pattern(Words, Script, Pattern_Index)
      -> dwrite(Predicate, ['Found matching pattern: ', Pattern_Index, nl]),
         script_keyword(Script, Keyword), 
         dwrite(Predicate, ['Keyword: ', Keyword, nl]),
         current_action(Keyword, Pattern_Index, Action_Index),
         dwrite(Predicate, ['Action_Index: ', Action_Index, nl]),
         script_action_by_indeces(Script, Pattern_Index, Action_Index, An_Action),
         ( An_Action = newkey,
           response_from_list(Words, Rest, Best_So_Far, Response)
         ; An_Action = equivalence(Other_Keyword),
           assert_next_state(Keyword, Pattern_Index),
           scripts(Other_Script), script_keyword(Other_Script, Other_Keyword),
           response_from_list(Words, [Other_Script | Rest], Best_So_Far, Response)
         ; is_response(An_Action), 
           flatten_response(An_Action, Response_Flattened),
           Potential_Response = (Response_Flattened, Keyword, Pattern_Index),
           best_so_far_max(Best_So_Far, Potential_Response, New_Best_So_Far),
           response_from_list(Words, Rest, New_Best_So_Far, Response)
         ; write('Unhandled action: `'), write(An_Action), write('`!'), nl,
           fail
         )
      ;  
         dwrite(Predicate, ['Trying next', nl]),
         response_from_list(Words, Rest, Best_So_Far, Response)
      )
  ).


response_memory(Response) :-
  memory(List),
  List = [Action | _],
  flatten_response(Action, Flat),
  Response = (Flat, memory, 0).

response_none(Response) :-
  Pattern_Index = 0,
  current_action(none, Pattern_Index, Action_Index),
  none_script(None_Script),
  script_action_by_indeces(None_Script, Pattern_Index, Action_Index, An_Action),
  Response = (An_Action, none, Pattern_Index).
  

flatten_response(response(List), response(Flat)) :-
  dwrite(flatten_response, ['Wait, what?', nl]),
  flatten_response_aux(List, Reversed, []),
  reverse(Reversed, Flat),
  dwrite(flatten_response, ['List = ', List, nl, 'Flat = ', Flat, nl]).

flatten_response_aux([], Flat, Flat).

flatten_response_aux([X | Xs], Flat, Acc) :-
  (  is_list(X)
  -> flatten_response_aux(X, New_Acc, Acc)
  ;  New_Acc = [X | Acc]
  ),
  flatten_response_aux(Xs, Flat, New_Acc).


% match(+Input_List, -Pattern)
match(Input_List, Pattern) :-
  Pattern = [Head | Tail],
  (  var(Head)
  -> % we must find the rest of the pattern and ground Head to the rest
     find_rest_and_ground(Input_List, Tail, Head, Unmatched_Input, Unmatched_Pattern),
     match(Unmatched_Input, Unmatched_Pattern)
  ; [I_Head | I_Tail] = Input_List,
    match_not_var(I_Head, Head),
    match(I_Tail, Tail)
  ).

match([], []).

match_not_var(Input, Pattern) :-
  (  Pattern = class(Predicate, Input)
  -> call(Predicate, Input)
  ;  Input = Pattern
  ).

find_rest_and_ground(Input_List, Rest_Of_Pattern, Variable, Unmatched_Input, Unmatched_Pattern) :-
  (  [RHead | _] = Rest_Of_Pattern
  ->  not(var(RHead)),
      find_rest_and_ground_aux(Input_List, Rest_Of_Pattern, Variable, Unmatched_Input, Unmatched_Pattern, [])
  ;   find_rest_and_ground_aux(Input_List, Rest_Of_Pattern, Variable, Unmatched_Input, Unmatched_Pattern, [])
  ).

find_rest_and_ground_aux(
  [Input_Head | Input_Tail], 
  [Pattern_Head | Pattern_Tail],
  Variable,
  Unmatched_Input,
  Unmatched_Pattern,
  Acc) :-
    dwrite(find_rest_and_ground_aux, [
      'Input_Head: ', Input_Head, ', Input_Tail: ', Input_Tail, nl,
      'Pattern_Head: ', Pattern_Head, ', Pattern_Tail: ', Pattern_Tail, nl,
      'Acc: ', Acc, nl]
    ),
    (  var(Pattern_Head)
    -> reverse(Acc, Variable),
       Unmatched_Input   = [Input_Head   | Input_Tail],
       Unmatched_Pattern = [Pattern_Head | Pattern_Tail]
    ; (  match_not_var(Input_Head, Pattern_Head)
      -> consume_until_var(Input_Tail, Pattern_Tail, Unmatched_Input, Unmatched_Pattern),
         reverse(Acc, Variable)
      ;  NewAcc = [Input_Head | Acc],
         find_rest_and_ground_aux(Input_Tail, [Pattern_Head | Pattern_Tail], Variable, Unmatched_Input, Unmatched_Pattern, NewAcc)
      )
    ).
  
find_rest_and_ground_aux(
  Input_List, 
  [],
  Variable,
  [],
  [],
  Acc) :-
    dwrite(find_rest_and_ground_aux, ['Acc: ', Acc, nl]),
    reverse(Acc, AccReversed),
    append(AccReversed, Input_List, Variable).

consume_until_var([], [], [], []).
consume_until_var(Input_List, [Pattern_Head | Pattern_Tail], Unmatched_Input, Unmatched_Pattern) :-
  (  var(Pattern_Head)
  -> Unmatched_Input   = Input_List,
     Unmatched_Pattern = [Pattern_Head | Pattern_Tail]
  ;  Input_List = [Input_Head | Input_Tail],
     match_not_var(Input_Head, Pattern_Head),
     consume_until_var(Input_Tail, Pattern_Tail, Unmatched_Input, Unmatched_Pattern)
  ).


% find_matching_pattern(+Input_List, +Script, -Keyword)
find_matching_pattern(Input_List, Script, Index) :-
  Predicate = find_matching_pattern,
  tag_check(Predicate, Input_List, list(atom)),
  tag_check(Predicate, Script, is_script),
  %
  dwrite(Predicate, ['Input_List: ', Input_List, nl]),
  script_patterns(Script, Patterns),
  find_matching_pattern_aux(Input_List, Patterns, Index, 0).

find_matching_pattern_aux(Input_List, [Pattern | Rest], Index, Current) :-
  pattern_matched(Pattern, matched(Match)),
  (  match(Input_List, Match) 
  -> Index = Current
  ;  New_Current is Current + 1,
     find_matching_pattern_aux(Input_List, Rest, Index, New_Current)
  ).

% last_action(+Keyword, +Pattern_Index, -Action_Index).
% dynamically modified
current_action_aux(_Keyword, _Pattern_Index, 0).

current_action(Keyword, Pattern_Index, Action_Index) :-
  (  current_action_aux(Keyword, Pattern_Index, A)
  -> Action_Index = A
  ;  Action_Index = 0,
     asserta_current_action(Keyword, Pattern_Index, 0)
  ).

retract_current_action(Keyword, Pattern_Index, Action_Index) :-
  Predicate = maybe_retract_current_action,
  tag_check(Predicate, Keyword, atom),
  tag_check(Predicate, Pattern_Index, number),
  tag_check(Predicate, Action_Index, number),
  %
  retract(current_action_aux(Keyword, Pattern_Index, Action_Index)).

asserta_current_action(Keyword, Pattern_Index, Action_Index) :-
  Predicate = maybe_asserta_current_action,
  tag_check(Predicate, Keyword, atom),
  tag_check(Predicate, Pattern_Index, number),
  tag_check(Predicate, Action_Index, number),
  % 
  asserta(current_action_aux(Keyword, Pattern_Index, Action_Index)).


assert_next_state(Keyword, Pattern_Index) :-
  Predicate = assert_next_state,
  tag_check(Predicate, Keyword, atom),
  tag_check(Predicate, Pattern_Index, number),
  %
  dwrite(Predicate, [assert_next_state, ' keyword: ', Keyword, ' Pattern_Index: ', Pattern_Index, nl]),
  (  Keyword = memory
  -> retract_head_memory_list
  ;  assert_current_action_to_next_action(Keyword, Pattern_Index)
  ).

% assert_current_action_to_next_action(+Script, +Pattern_Index) modifies state
assert_current_action_to_next_action(Keyword, Pattern_Index) :-
  Predicate = assert_current_action_to_next_action,
  tag_check(Predicate, Keyword, atom),
  tag_check(Predicate, Pattern_Index, number),
  %
  dwrite(Predicate, ['Keyword = ', Keyword, nl]),
  (  Keyword = none
  -> none_script(Script)
  ;  script_by_keyword(Keyword, Script)
  ),
  dwrite(Predicate, ['Script = ', Script, nl]),
  script_patterns(Script, Patterns),
  dwrite(Predicate, ['Patterns = ', Patterns, nl]),
  nth0(Pattern_Index, Patterns, Pattern),
  dwrite(Predicate, ['Pattern = ', Pattern, nl]),
  pattern_actions(Pattern, actions(Actions)),
  dwrite(Predicate, ['Action = ', Pattern, nl]),
  length(Actions, Length),
  dwrite(Predicate, ['Length = ', Length, nl]),
  current_action(Keyword, Pattern_Index, Action_Index),
  dwrite(Predicate, ['Action_Index = ', Action_Index, nl]),
  New_Action_Index is (Action_Index + 1) mod Length,
  dwrite(Predicate, ['New_Action_Index = ', Action_Index, nl]),
  retract_current_action(Keyword, Pattern_Index, Action_Index),
  dwrite(Predicate, ['Retract.', nl]),
  asserta_current_action(Keyword, Pattern_Index, New_Action_Index),
  dwrite(Predicate, ['Assert.', nl]).


% sorted_all_with_keyword_matching(+Input_List, -Keyword)
% Input_List - a list of words to match
% Sorted - a sorted (by priority) list of scripts that match 
sorted_all_with_keyword_matching(Input_List, Sorted) :-
  findall(Script, (scripts(Script), script_keyword(Script, Keyword), member(Keyword, Input_List)), AllScripts),
  sort_scripts(AllScripts, Sorted).
  
sort_scripts(Scripts, Sorted) :-
  sort_scripts_acc(Scripts, Sorted, []).

sort_scripts_acc([], Acc, Acc).
sort_scripts_acc([H | T], Sorted, Acc) :- 
    insert_script(H, Acc, New_Acc),
    sort_scripts_acc(T, Sorted, New_Acc).

insert_script(Script, [Current_Best| Rest], [Current_Best | Rest_Inserted]) :-
  script_priority(Script, Script_Priority),
  script_priority(Current_Best, Best_Priority),
  Best_Priority >= Script_Priority,
  insert_script(Script, Rest, Rest_Inserted).

insert_script(Script, [Current_Worse | Rest], [Script, Current_Worse| Rest]) :-
  script_priority(Script, Script_Priority),
  script_priority(Current_Worse, Worse_Priority),
  Worse_Priority =< Script_Priority.

insert_script(Script, [], [Script]).
  
% word classes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

family(mother).
family(mom).
family(dad).
family(father).
family(sister).
family(sisters).
family(brother).
family(brothers).
family(wife).
family(husband).

belief(feel).
belief(think).
belief(believe).
belief(wish).

want(want).
want(need).

sad(sad).
sad(unhappy).
sad(depressed).
sad(sick).

happy(happy).
happy(elated).
happy(glad).
happy(better).

everyone(everyone).
everyone(everybody).
everyone(nobody).
everyone('no one').

am('i\'m').
am(am).
am(is).
am(are).
am(was).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% script(
%   keyword(Word, Priority),
%   [
%     pattern(
%       matched(Pattern),
%       actions(
%         response(List), % or
%         equivalence(Keyword) % or
%         newkey
%   ...
%   ]
%
 
 
% getters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

script_keyword(Script, Keyword) :-
  tag_check('script_keyword', Script, is_script),
  %
  Script = script(keyword(Keyword, _), _).

script_priority(Script, Priority) :-
  tag_check('script_priority', Script, is_script),
  %
  Script = script(keyword(_, Priority), _).

script_patterns(Script, Patterns) :-
  tag_check('script_patterns', Script, is_script),
  %
  Script = script(keyword(_, _), Patterns).

pattern_matched(Pattern, Matched) :-
  tag_check('pattern_matched', Pattern, is_pattern),
  %
  Pattern = pattern(Matched, _).

pattern_actions(Pattern, Actions) :-
  tag_check('pattern_actions', Pattern, is_pattern),
  %
  Pattern = pattern(_, Actions).
  
pattern_score_by_index(Script, Pattern_Index, Score) :-
  script_pattern_by_index(Script, Pattern_Index, Pattern),
  pattern_matched(Pattern, Matched),
  matched_score(Matched, Score).

matched_score(matched(List), Score) :-
  matched_score_aux(List, Score, 0).

matched_score_aux([], Score, Score).
matched_score_aux([X | Xs], Score, Acc) :-
  (  var(X)
  -> matched_score_aux(Xs, Score, Acc)
  ;  New_Acc is Acc + 1, 
     matched_score_aux(Xs, Score, New_Acc)
  ).

script_pattern_by_index(Script, Pattern_Index, Pattern) :-
  Predicate = 'script_pattern_by_index',
  tag_check(Predicate, Script, is_script),
  tag_check(Predicate, Pattern_Index, number),
  %
  script_patterns(Script, Patterns),
  nth0(Pattern_Index, Patterns, Pattern).

script_action_by_indeces(Script, Pattern_Index, Action_Index, Action) :-
  Predicate = 'script_action_by_indeces',
  tag_check(Predicate, Script, is_script),
  tag_check(Predicate, Pattern_Index, number),
  tag_check(Predicate, Action_Index, number),
  %
  script_pattern_by_index(Script, Pattern_Index, Pattern),
  pattern_actions(Pattern, actions(Actions)),
  nth0(Action_Index, Actions, Action).

% lookup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% script_keyword(+Keyword, -Script)
script_by_keyword(Keyword, Script) :-
  scripts(Script),
  script_keyword(Script, Keyword).

/*
actions can be:

  response([some, response, [possibly, with, bindings]])
  newkey - switches to another found pattern
  equivalence(Treat_Like_This_Key)
*/

% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
is_response(response(_)).
is_script(script(_, _)).
is_pattern(pattern(_, _)).

% scripts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scripts(
  script(
    keyword(if, 3),
    [
      pattern(
        matched([_, if, Y]),
        actions([
          response([do, you, think, it, is, likely, that, Y, ?]) ,
          response([do, you, wish, that, Y, ?]),
          response([what, do, you, think, about, Y, ?]),
          response([really, ',', if, Y, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(dreamt, 4),
    pattern(
      matched([_, you, dreamt, X]),
      actions([
        response([really, X, ?]),
        response([have, you, ever, fantasied, X, while, you, were, awake, ?]),
        response([have, you, dreamt, X, before, ?]),
        equivalence(dream),
        newkey
      ])
    )
  )
).

scripts(
  script(
    keyword(dream, 3),
    pattern(
      matched([_]),
      actions([
        response([what, does, that, dream, suggest, to, you, ?]),
        response([do, you, dream, often, ?]),
        response([what, persons, appear, in, your, dreams, ?]),
        equivalence(dream),
        response(['don\'t', you, believe, that, dream, has, something, to, do, with, your, problem, ?]),
        newkey
      ])
    )
  )
).

scripts(
  script(
    keyword(remember, 5),
    [
      pattern(
        matched([_, you, remember, X]),
        actions([
          response([do, you, often, think, of, X, ?]),
          response([does, thinking, of, X, bring, anything, else, to, mind, ?]),
          response([what, else, do, you, remember, ?]),
          response([why, do, you, remember, X, just, now, ?]),
          response([what, in, the, present, situation, reminds, you, of, X, ?]),
          response([what, is, the, connection, between, me, and, X, ?])
        ])
      ),
      pattern(
         matched([X, do, i, remember, Y]),
         actions([
           response([did, you, think, i, would, forget, Y, ?]),
           response([why, do, you, think, i, should, recall, Y, now, ?]),
           response([what, about, Y, ?]),
           equivalence(what),
           response([you, mentioned, Y, ?])
         ])
      ),
      pattern(
        matched([_]),
        actions([
          newkey
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(sorry, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([please, do, not, apologize]),
          response([apologies, are, not, necessary]),
          response([what, feelings, do, you, have, when, you, apologize, ?]),
          response([i, have, told, you, that, apologies, are, not, required])
        ])
      )
    ]
  )
).


scripts(
  script(
    keyword(what, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([why, do, you, ask, ?]),
          response([does, that, question, interest, you, ?]),
          response([what, is, it, you, really, want, to, know, ?]) ,
          response([are, such, questions, much, on, your, mind, ?]),
          response([what, answer, would, please, you, most, ?]),
          response([what, do, you, think, ?]),
          response([what, comes, to, your, mind, when, you, ask, that, ?]),
          response([have, you, asked, such, question, before, ?]),
          response([have, you, asked, anyone, else, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(your, 2),
    [
      pattern(
        matched([_, your, _, class(family, F), X]),
        actions([
          response([tell, me, more,about, your, family]),
          response([who, else, in, your, family, X, ?]),
          response([your, F, ?]),
          response([what, else, comes, to, mind, when, you, think, of, your, F, ?])
        ])
      ),
      pattern(
        matched([_, your, X]),
        actions([
          response([your, X, ?]),
          response([why, do, you, say, your, X, ?]),
          response([does, that, suggest, anything, else, which, belongs, to, you, ?]),
          response([is, it, important, to, you, that, your, X, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(perhaps, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([you, 'don\'t', seem, quite, certain, '.']),
          response([why, the, uncertain, tone, ?]),
          response(['can\'t', you, be, more, positive, ?]),
          response([you, 'aren\'t', sure]),
          response(['don\'t', you, know, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(name, 15),
    [
      pattern(
        matched([_]),
        actions([
          response([i, am, not, interested, in, names]),
          response(['i\'ve', told, you, before, ',', i, 'don\'t', care, about, names, -, please, continue])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(xfremd, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([i, am, sorry, i, speak, only, english])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(hello, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([how, do, you, do, please, state, your, problem])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(computer, 50),
    [
      pattern(
        matched([_]),
        actions([
          response([do, computers, worry, you, ?]),
          response([why, do, you, mention, computers, ?]),
          response([what, do, you, think, machines, have, to, do, with, your, problem, ?]),
          response(['don\'t', you, think, computers, can, help, people, ?]),
          response([what, about, machines, worries, you, ?]),
          response([what, do, you, think, about, machines, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(are, 0),
    [
      pattern(
        matched([_, are, you, X]),
        actions([
          response([do, you, believe, you, are, X, ?]),
          response([would, you, want, to, be, X, ?]),
          response([you, wish, i, would, tell, you, you, are, X]),
          response([what, would, it, mean, if, you, were, X]),
          equivalence(what)
        ])
      ),
      pattern(
        matched([_, are, i, X]),
        actions([
          response([why, are, you, interested, in, whether, i, am, X, or, not, ?]),
          response([would, you, prefer, if, i, 'weren\'t', X]),
          response([perhaps, i, am, X, in, your, fantasies, ?]),
          response([do, you, sometimes, think, i, am, X, ?]),
          equivalence(what)
        ])
      ),
      pattern(
        matched([_, are, X]),
        actions([
          response([did, you, think, they, might, not, be, X, ?]) ,
          response([would, you, like, it, if, they, were, not, X, ?]) ,
          response([what, if, they, were, not, X, ?]),
          response([possibly, they, are, X])
        ])
      ),
      pattern(
        matched([_]),
        actions([
          response([why, do, you,say, '\'am\'', ?]),
          response([i, 'don\'t', understand, that])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(my, 0),
    [
      pattern(
        matched([_, my, X]),
        actions([
          response([why, are, you, concerned, over, my, X, ?]),
          response([what, about, your, own, X, ?]),
          response([are, you, worried, about, someone, 'else\'s', X, ?]),
          response([really, my, X, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(was, 2),
    [
      pattern(
        matched([_, was, you, X]),
        actions([
          response([what, if, you, were, X, ?]),
          response([do, you, think, you, were, X, ?]),
          response([were, you, X, ?]),
          response([what, would, it, mean, if, you, were, X, ?]),
          response([what, does, '\'', X, '\'', suggest, to, you, ?]),
          equivalence(what)
        ])
      ),
      pattern(
        matched([_, you, was, X]),
        actions([
          response([were, you, really, ?]),
          response([why, do, you, tell, me, you, were, X, now, ?]),
          response([perhaps, i, already, knew, you, were, X, ?])
        ])
      ),
      pattern(
        matched([_, was, i, X]),
        actions([
          response([would, you, like, to, believe, i, was, X, ?]),
          response([what, suggests, that, i, was, X, ?]),
          response([what, do, you, think, ?]),
          response([perhaps, i, was, X, ?]),
          response([what, if, i, had, been, X, ?])
        ])
      ),
      pattern(
        matched([_]),
        actions([
          newkey
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword('i\'m', 0),
    [
      pattern(
        matched([_, 'i\'m', _]),
        actions([
          equivalence(i)
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword('you\'re', 0),
    [
      pattern(
        matched([_, 'you\'re', _]),
        actions([
          equivalence(you)
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(you, 0),
    [
      pattern(
        matched([_, you, class(want, _), X]),
        actions([
          response([what, would, it, mean, to, you, if, you, got, X, ?]),
          response([why, do, you, want, X, ?]),
          response([suppose, you, got, X, soon, ?]), 
          response([what, if, you, never, got, X, ?]),
          response([what, would, getting, X, mean, to, you, ?]),
          response([what, does, wanting, X, have, to, do, with, this, discussion, ?])
        ])
      ),
      pattern(
        matched([_, 'you\'re', _, class(sad, F), _]),
        actions([
          response([i, am, sorry, to, hear, you, are, F]),
          response([do, you, think, coming, here, will, help, you, not, be, F, ?]),
          response(['i\'m', sure, 'it\'s', not, pleasant, to, be, F]), 
          response([can, you, explain, what, made, you, F, ?])
        ])
      ),
      pattern(
        matched([_, 'you\'re', _, class(happy, F), _]),
        actions([
          response([how, have, i, helped, you, to, be, F, ?]),
          response([has, your, treatment, made, you, F, ?]),
          response([what, makes, you, F, just, now, ?]), 
          response([can, you, explain, why, are, you, suddenly, F, ?])
        ])
      ),
      pattern(
        matched([_, you, was, _]),
        actions([
          equivalence(was)
        ])
      ),
      pattern(
        matched([_, you, _, class(belief, _), _, i, _]),
        actions([
          equivalence(you)
        ])
      ),
      pattern(
        matched([_, 'you\'re', X]),
        actions([
          response([is, it, because, you, are, X, that, you, came, to, me, ?]),
          response([how, long, have, you, been, X, ?]),
          response([do, you, believe, it, normal, to, be, X, ?]),
          response([do, you, enjoy, being, X, ?])
        ])
      ),
      pattern(
        matched([_, you, cannot, X]),
        actions([
          response([how, do, you, know, you, 'can\'t', X, ?]),
          response([have, you, tried, ?]),
          response([perhaps, you, could, X, now, ?]),
          response([do, you, really, want, to, be, able, to, X, ?])
        ])
      ),
      pattern(
        matched([_, you, 'don\'t', X]),
        actions([
          response(['don\'t', you, really,  X, ?]),
          response([why, 'don\'t', you, X, ?]),
          response([do, you, wish, to, be, able, to, X, ?]),
          response([does, that, trouble, you, ?])
        ])
      ),
      pattern(
        matched([_, you, feel, X]),
        actions([
          response([tell, me, more, about, such, feelings]),
          response([do, you, often, feel, X, ?]),
          response([do, you, enjoy, feeling, X, ?]),
          response([of, what, does, feeling, X, remind, you, ?])
        ])
      ),
      pattern(
        matched([_, you, X, i, _]),
        actions([
          response([perhaps, in, your, fantasy, we, X, each, other, ?]),
          response([do, you, wish, to, X, me, ?]),
          response([you, seem, to, need, to, X, me]),
          response([do, you, X, anyone, else, ?])
        ])
      ),
      pattern(
        matched([X]),
        actions([
          response([you, say, X]),
          response([can, you, elaborate, on, that, ?]),
          response([do, you, say, X, for, some, specific, reason, ?]),
          response(['that\'s', quite, interesting])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(i, 0),
    [
      pattern(
        matched([_, i, remind, you, of, _]),
        actions([
          equivalence(dit)
        ])
      ),
      pattern(
        matched([_, 'i\'m', X]),
        actions([
          response([what, makes, you, think, i, am, X, ?]), 
          response([does, it, please, you, to, believe, i, am, X, ?]),
          response([do, you, sometimes, wish, you, were, X, ?]),
          response([perhaps, you, would, like, to, be, X, ?])
        ])
      ),
      pattern(
        matched([_, i, X, you]),
        actions([
          response([why, do, you, think, i, X, you, ?]),
          response([you, like, to, think, i, X, you, -, 'don\'t', you, ?]),
          response([what, makes, you, think, i,  X, you, ?]),
          response([really, i, X, you, ?]),
          response([do, you, wish, to, believe, i, X, you, ?]),
          response([suppose, i, did, X, you, -, what, would, that, mean, ?]),
          response([does, someone, else, believe, i, X, you, ?])
        ])
      ),
      pattern(
        matched([_, i, X]),
        actions([
          response([we, were, discussing, you, -, not, me]),
          response([oh, ',', i, X]),
          response(['you\re', not, really, talking, about, me, -, are, you, ?]),
          response([what, are, your, feelings, now, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(yes, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([you, seem, quite, positive]), 
          response([you, are, sure]),
          response([i, see]),
          response([i, understand])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(no, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([are, you, saying, '\'no\'', just, to, be, negative, ?]), 
          response([you, are, being, a, bit, negative]),
          response([why, not]),
          response([why, '\'no\''])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(can, 0),
    [
      pattern(
        matched([_, can, i, X]),
        actions([
          response([you, belive, i, can, X, 'don\'t', you, ?]), 
          equivalence(what),
          response([you, want, me, to, be, able, to, X]),
          response([perhaps, you, would, like, to, be, able, to, X, yourself])
        ])
      ),
      pattern(
        matched([_, can, you, X]),
        actions([
          response([whether, or, not, you, can, depends, on, you, more, than, on, me]), 
          response([do, you, want, to, be, able, to, X]),
          response([perhaps, you, 'don\'t', want, to]),
          equivalence(what)
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(because, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([is, that, the, real, reason, ?]), 
          response(['don\'t', any, other, reasons, come, to, mind, ?]), 
          response([does, that, reason, seem, to, explain, anything, else, ?]),
          response([what, other, reasons, might, there, be, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(why, 0),
    [
      pattern(
        matched([_, why, 'don\'t', i, X]),
        actions([
          response([do, you, belive, i, 'don\'t', X, ?]), 
          response([perhaps, i, will, X, in, good, time, ?]),
          response([should, you, X, yourself, ?]),
          response([you, want, me, to, X]),
          equivalence(what)
        ])
      ),
      pattern(
        matched([_, why, cannot, you, X]),
        actions([
          response([do, you, think, you, should, be, able, to, X]),
          response([do, you, want, to, be, able, to, X]),
          response([do, you, believe, this, will, help, you, to, X]),
          response([have, you, any, idea, why, you, 'can\'t', X]),
          equivalence(what)
        ])
      )
    ]
  )
).

scripts(Script) :-
  everyone(Everyone),
  Script = script(
    keyword(Everyone, 2),
    [
      pattern(
        matched([_, Everyone, _]),
        actions([
          response([really, Everyone, ?]), 
          response([surely, not, Everyone, ?]), 
          response([can, you, think, of, anyone, in, particular, ?]),
          response([who, ',', for, example, ?]),
          response([you, are, thinking, of, a, very, special, person]),
          response([who, ',', may, i, ask, ?]),
          response([someone, special, perhaps, ?]),
          response([you, have, a, particular, person, in, mind, 'don\'t', you, ?]),
          response([who, do, you, think, 'you\'re', talking, about, ?])
        ])
      )
    ]
  ).

scripts(
  script(
    keyword(always, 1),
    [
      pattern(
        matched([_]),
        actions([
          response([can, you, think, of, a, specific, example, ?]),
          response([when, ?]), 
          response([what, incident, are, you, thinking, of, ?]),
          response([really, always, ?])
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(like, 10),
    [
      pattern(
        matched([_, class(am, _), _, like, _]),
        actions([
          equivalence(dit)
        ])
      ),
      pattern(
        matched([_]),
        actions([
          newkey
        ])
      )
    ]
  )
).

scripts(
  script(
    keyword(dit, 10),
    [
      pattern(
        matched([_]),
        actions([
          response([in, what, way, ?]),
          response([what, resemblance, do, you, see, ?]),
          response([what, does, that, similarity, suggests, to, you, ?]),
          response([what, other, connection, do, you, see, ?]),
          response([what, do, you, suppose, that, resemblance, means, ?]),
          response([what, is, the, connection, ',', do, you, suppose, ?]),
          response([could, there, really, be, some, connection, ?]),
          response([how, ?])
        ])
      )
    ]
  )
).


% special
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

none_script(
  script(
    keyword(none, 0),
    [
      pattern(
        matched([_]),
        actions([
          response([i, am, not, sure, i, understand, you, fully]),
          response([please, go, on]),
          response([what, does, that, suggest, to, you]),
          response([do, you, feel, strongly, about, discussing, such, things])
        ])
      )
    ]
  )
).

memory_patterns([
  memory_pattern(matched([_, your, X]), response(['let\'s',  discuss, further, why, your, X, ?])),
  memory_pattern(matched([_, your, X]), response([earlier, you, said, your, X, ?])),
  memory_pattern(matched([_, your, X]), response([but, your, X, ?])),
  memory_pattern(matched([_, your, X]), response([does, that, have, anything, to, do, with, the, fact, that, your, X, ?]))
]).


start([how, do, you, do, ., please, tell, me, your, problem]).
