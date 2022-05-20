bigger_than([Head | Tail], N, [Head | ResTail]) :- Head > N, !, bigger_than(Tail, N, ResTail).
bigger_than([_ | Tail], N, Result) :- bigger_than(Tail, N, Result).
bigger_than([], _, []).

odd_list([_, Head | Tail], [Head | ResTail]) :- !, odd_list(Tail, ResTail).
odd_list([], []).

single_del([Head | Tail], N, Tail) :- Head is N, !.
single_del([Head | Tail], N, [Head | ResTail]) :- single_del(Tail, N, ResTail), !.
single_del([], _, []).

full_del([Head | Tail], N, [Head | ResTail]) :- Head <> N, !, full_del(Tail, N, ResTail).
full_del([_ | Tail], N, Result) :- full_del(Tail, N, Result), !.
full_del([], _, []).

set([Head | Tail], [Head | Result]) :- full_del(Tail, Head, Nt), !, set(Nt, Result).
set([], []).

%bigger_than([1, 7, 3, 4, 5, 6], 3, Result).
%odd_list([1, 2, 3, 4, 5, 6, 7, 8], Result).

%single_del([1, 2, 3, 1, 2, 3, 1, 2, 3], 1, Result).
%full_del([1, 2, 3, 1, 2, 3, 1, 2, 3], 1, Result).

%set([1, 2, 3, 1, 2, 3, 1, 2, 3], Result).
