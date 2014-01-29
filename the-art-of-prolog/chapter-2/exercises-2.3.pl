% 2.3 (i)

above(Book1, Book2) :- 
	on(Book1, Book2).
	
above(Book1, Book2) :-
    above(Book1, Middle),
    on(Middle, Book2).
    
on(taop, sicp).
on(sicp, tapl).
on(tapl, trs).

% 2.3 (ii) see exercises-2.3-ii.pl

% 2.3 (iii)
%
% given:

edge(a,b).	edge(a,c).	edge(b,d).
edge(c,d).	edge(d,e).	edge(f,g).

%	Program 2.6: A directed graph

/*
	connected(Node1,Node2) :-
		Node1 is connected to Node2 in the graph
		defined by the edge/2 relation.
*/
	connected(Node,Node).
	connected(Node1,Node2) :- edge(Node1,Link), connected(Link,Node2).

% connected(a, e) ->
%                 -> edge(a, b), connected(b, e).
%                 -> edge(a, b), edge(b, d), connected(d, e).
%                 -> edge(a, b), edge(b, d), connected(d, e).
%                 -> edge(a, b), edge(b, d), edge(d, e), connected(e, e).
%
% Assuming there exists a path between node `x` and `y` the proof tree will have
% the same amount of nodes as path_len(x, y) + 1.

/*
 ['exercises-2.3'].

 above(taop, trs).


 */
