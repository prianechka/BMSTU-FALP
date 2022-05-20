rec_length(Res, Len, [_ | Tail]) :- NewLen is Len + 1, !, rec_length(Res, NewLen, Tail).
rec_length(Res, Len, []) :- Res is Len.
length(Res, List) :- rec_length(Res, 0, List).

rec_sum(Res, Sum, [Head | Tail]) :- NewSum is Sum + Head, !, rec_sum(Res, NewSum, Tail).
rec_sum(Res, Sum, []) :- Res is Sum.
sum(Res, List) :- rec_sum(Res, 0, List).

rec_oddsum(Res, Sum, [_, Head | Tail]) :- NewSum is Sum + Head, !, rec_oddsum(Res, NewSum, Tail).
rec_oddsum(Res, Sum, []) :- Res is Sum.
oddsum(Res, List) :- rec_oddsum(Res, 0, List).

%length(Res, [1, 2, 3, 4]).
%sum(Res, [1, 2, 3, 4]).
%oddsum(Res, [1, 2, 3, 4]).
