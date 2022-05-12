domains
  val = integer

predicates
  nondeterm max2(val, val, val)
  nondeterm max3(val, val, val, val)

  nondeterm max2opt(val, val, val)
  nondeterm max3opt(val, val, val, val)

clauses
  max2(X1, X2, X2) :- X2 >= X1.
  max2(X1, X2, X1) :- X1 >= X2.

  max3(X1, X2, X3, X3) :- X3 >= X1, X3 >= X2.
  max3(X1, X2, X3, X2) :- X2 >= X1, X2 >= X3.
  max3(X1, X2, X3, X1) :- X1 >= X2, X1 >= X3.

  max2opt(X1, X2, X2) :- X2 >= X1, !.
  max2opt(X1, _, X1).

  max3opt(X1, X2, X3, X3) :- X3 >= X2, X3 >= X1, !.
  max3opt(X1, X2, _, X1) :- X1 >= X2, !.
  max3opt(_, X2, _, X2).
  
  min3opt(X1, X2, X3, X3) :- X1 <= X2, X1 <= X3, !.
  min3opt(_, X2, X3, X2) :- X2 <= X3, !.
  min3opt(_, _, _, X3).
  
  min3NoOpt(X1, X2, X3, X3) :- X1 <= X2, X1 <= X3, !.
  min3NoOpt(_, X2, X3, X2) :- X2 <= X3, !.
  min3NoOpt(_, _, _, X3).

goal
  % max2(1, 2, Max).
  % max3(1, 5, 2, Max).
  % max2opt(6, 3, Max).
  max3opt(1, 2, 3, Max).