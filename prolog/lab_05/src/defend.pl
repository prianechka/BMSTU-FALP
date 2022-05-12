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
  
min3opt(X1, X2, X3, X3) :- X3 =< X2, X3 =< X1, !.
min3opt(X1, X2, _, X1) :- X1 =< X2, !.
min3opt(_, X2, _, X2).
  
min3NoOpt(X1, X2, X3, X3) :- X3 =< X2, X3 =< X1.
min3NoOpt(X1, X2, _, X1) :- X1 =< X2.
min3NoOpt(_, X2, _, X2).
