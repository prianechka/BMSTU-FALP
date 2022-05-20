findFactorial(N, Result) :- recFact(N, Result, 1).
recFact(N, Result, Tmp) :- N > 1, !, NewTmp is Tmp * N, 
			  NewN is N - 1, 
			  recFact(NewN, Result, NewTmp).
recFact(_, Result, Tmp) :- Res is Tmp.

findFib(N, Result) :- recFib(N, 1, 1, Result).
recFib(N, F1, F2, Result) :- N > 2, !, NewF1 is F2, NewF2 is F1 + F2, 
			   NewN is N - 1, recFib(NewN, NewF1, NewF2, Result).
recFib(_, _, B, Result) :- Result is B.

%findFactorial(3, Res).
%findFib(2, Res).
