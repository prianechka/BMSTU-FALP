operation(A, +, B, R) :- R is A + B.
operation(A, -, B, R) :- R is A - B.
operation(A, *, B, R) :- R is A * B.
operation(A, div, B, R) :- (B =:= 0 -> R is 0; R is div(A, B)).
operation(A, mod, B, R) :- (B =:= 0 -> R is 0; R is mod(A, B)).
operation(A, ^, B, R) :- R is A ** B.

findWithout(Op1, Op2, Op3) :- operation(5, Op1, 2, R1), 
                              operation(R1, Op2, 3, R2), 
                              operation(R2, Op3, 4, 7), write("Решение! \n").

min3opt(X1, X2, X3, X1) :- X1 =< X2, X1 =< X3, !.
min3opt(_, X2, X3, X2) :- X2 =< X3, !.
min3opt(_, _, X3, X3).

findFirst(L, El, Count) :- append(Left, [El|_], L), length(Left, Count), !.

solveResult(L, El, Result) :- member(El, L), append(Left, [El|Other], L), last(Left, X), nth0(0, Other, Y),
                            operation(X, El, Y, R), append(LeftWithout, [X], Left), append([Y], RigthWithout, Other), append(LeftWithout, [R], Tmp),
                            append(Tmp, RigthWithout, Result).

solve(L, V) :- member(^, L), solveResult(L, ^, Result), !, solve(Result, V).

solve(L, V) :- member(*, L), member(div, L), member(mod, L),
            findFirst(L, *, I1), findFirst(L, div, I2), findFirst(L, mod, I3),
            min3opt(I1, I2, I3, MinimalIndex), I3 =:= MinimalIndex, solveResult(L, mod, Result), !, solve(Result, V). 
solve(L, V) :- member(*, L), member(div, L), member(mod, L),
            findFirst(L, *, I1), findFirst(L, div, I2), findFirst(L, mod, I3),
            min3opt(I1, I2, I3, MinimalIndex), I2 =:= MinimalIndex, solveResult(L, div, Result), !, solve(Result, V). 
solve(L, V) :- member(*, L), member(div, L), member(mod, L),
            findFirst(L, *, I1), findFirst(L, div, I2), findFirst(L, mod, I3),
            min3opt(I1, I2, I3, MinimalIndex), I1 =:= MinimalIndex, solveResult(L, *, Result), !, solve(Result, V). 

solve(L, V) :- member(*, L), member(div, L), findFirst(L, *, I1), findFirst(L, div, I2), I1 > I2, solveResult(L, div, Result), !, solve(Result, V). 
solve(L, V) :- member(*, L), member(div, L), findFirst(L, *, I1), findFirst(L, div, I2), I1 < I2, solveResult(L, *, Result), !, solve(Result, V). 

solve(L, V) :- member(*, L), member(mod, L), findFirst(L, *, I1), findFirst(L, mod, I2), I1 > I2, solveResult(L, mod, Result), !, solve(Result, V). 
solve(L, V) :- member(*, L), member(mod, L), findFirst(L, *, I1), findFirst(L, mod, I2), I1 < I2, solveResult(L, *, Result), !, solve(Result, V). 

solve(L, V) :- member(div, L), member(mod, L), findFirst(L, div, I1), findFirst(L, mod, I2), I1 > I2, solveResult(L, mod, Result), !, solve(Result, V). 
solve(L, V) :- member(div, L), member(mod, L), findFirst(L, div, I1), findFirst(L, mod, I2), I1 < I2, solveResult(L, div, Result), !, solve(Result, V). 

solve(L, V) :- member(*, L), solveResult(L, *, Result), !, solve(Result, V).
solve(L, V) :- member(div, L), solveResult(L, div, Result), !, solve(Result, V).
solve(L, V) :- member(mod, L), solveResult(L, mod, Result), !, solve(Result, V).
solve(L, V) :- member(+, L), member(-, L), findFirst(L, +, I1), findFirst(L, -, I2), I1 > I2, solveResult(L, -, Result), !, solve(Result, V). 
solve(L, V) :- member(+, L), member(-, L), findFirst(L, +, I1), findFirst(L, -, I2), I1 < I2, solveResult(L, +, Result), !, solve(Result, V). 
solve(L, V) :- member(+, L), solveResult(L, +, Result), !, solve(Result, V).
solve(L, V) :- member(-, L), solveResult(L, -, Result), !, solve(Result, V).
solve(L, V) :- nth0(0, L, V), !.

createArr(L, Res) :- length(L, 1), nth0(0, L, Elem), append([], [Elem], Res),!.
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, +], Res1, Res).
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, -], Res1, Res).
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, *], Res1, Res).
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, div], Res1, Res).
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, mod], Res1, Res).
createArr(L, Res) :- append([A|_], Rigth, L), createArr(Rigth, Res1), append([A, ^], Res1, Res).

solveEq(L, FindedResult, A) :- length(L, N), createArr(L, CreatedArr), Tmp is 2 * N - 1, length(CreatedArr, Tmp), 
                                solve(CreatedArr, V), V =:= FindedResult, atomics_to_string(CreatedArr, A).
% solveEq([5, 2, 3, 4], 7, A).