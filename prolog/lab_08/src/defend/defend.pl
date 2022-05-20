leftEyeBrownHead(X, State) :- X == State.
leftEyeBrownHead("Расслаблена").
leftEyeBrownHead("Поднята").
leftEyeBrownHead("Опущена").

leftEyeBrownCurve(X, State) :- X == State.
leftEyeBrownCurve("Расслаблена").
leftEyeBrownCurve("Поднята").
leftEyeBrownCurve("Опущена").

rightEyeBrownHead(X, State) :- X == State.
rightEyeBrownHead("Расслаблена").
rightEyeBrownHead("Поднята").
rightEyeBrownHead("Опущена").

rightEyeBrownCurve(X, State) :- X == State.
rightEyeBrownCurve("Расслаблена").
rightEyeBrownCurve("Поднята").
rightEyeBrownCurve("Опущена").

eyes(X, State) :- X == State.
eyes("Сонные").
eyes("Расслаблены").
eyes("Тревожные").
eyes("Широко раскрыты").
eyes("Закрыты").

iris(X, State) :- X == State.
iris("Обычные").
iris("Расширены").
iris("Сужены").

lips(X, State) :- X == State.
lips("Обе подняты").
lips("Верхняя поднята").
lips("Обе опущены").
lips("Верхняя опущена").
lips("Сужены").

mouth(X, State) :- X == State.
mouth("Обычный").
mouth("Улыбка").
mouth("Открыт").
mouth("Огорчение").
mouth("Согнут вниз").
mouth("Опущен").

head(X, State) :- X == State.
head("Поднята").
head("Опущена").

nose(X, State) :- X == State.
nose("Сморщенный").

tension(X, State) :- X == State.
tension("Есть").

emotions("Скептик", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :- 
    leftEyeBrownHead(LeftEBH, "Поднята"), leftEyeBrownCurve(LeftEBC, "Поднята"), 
    rightEyeBrownHead(RightEBH, "Поднята"), rightEyeBrownCurve(LeftEBC, "Поднята"),
    eyes(Eyes, "Сонные"),  mouth(Mouth, "Опущен"), !.

emotions("Боль", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Закрыты"), head(Head, "Поднята"), nose(Nose, "Сморщенный"), !.

emotions("Плач", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Закрыты"), leftEyeBrownHead(LeftEBH, "Опущена"), leftEyeBrownCurve(LeftEBC, "Расслаблена"), 
    rightEyeBrownHead(RightEBH, "Опущена"), rightEyeBrownCurve(LeftEBC, "Расслаблена"),
    mouth("Огорчение"), tension(Tensions, "Есть"), !.

emotions("Огорчен", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes( "Широко раскрыты"),  leftEyeBrownHead(LeftEBH, "Поднята"), leftEyeBrownCurve(LeftEBC, "Опущена"), 
    rightEyeBrownHead(RightEBH, "Поднята"), rightEyeBrownCurve(LeftEBC, "Опущена"),
    mouth("Огорчение"), tension(Tensions, "Есть"), !.

emotions("Грустный", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Тревожные"), mouth("Огорчение"), tension(Tensions, "Есть"), !.

emotions("Испуганный", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Широко раскрыты"),  leftEyeBrownHead(LeftEBH, "Поднята"), leftEyeBrownCurve(LeftEBC, "Поднята"), 
    rightEyeBrownHead(RightEBH, "Поднята"), rightEyeBrownCurve(LeftEBC, "Поднята"), !.

emotions("Взволнованный", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Тревожные"), mouth("Огорчение"), tension(Tensions, "Есть"),
    leftEyeBrownCurve(LeftEBC, "Поднята"), rightEyeBrownCurve(RightEBC, "Поднята"), !.

emotions("Любопытный", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Тревожные"), mouth(Mouth, "Открыт"), rightEyeBrownHead("Поднята"),
    leftEyeBrownHead("Поднята"), rightEyeBrownCurve("Поднята"),
    leftEyeBrownCurve("Поднята"), !.

emotions("Впечатлен", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    eyes(Eyes, "Широко раскрыты"), mouth("Открыт"), iris(Iris, "Сужены"), !.

emotions("Улыбка", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions) :-
    mouth(Mouth, "Улыбка"), !.

emotions("Обычный/не определён", LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tensions).

writefacts(Text):- open('result.txt', append, Out), write(Out, Text), close(Out).

findEmote(Emote, LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tension) :- 
    emotions(Emote, LeftEBH, LeftEBC, RightEBH, RightEBC, Eyes, Iris, Lips, Mouth, Head, Nose, Tension), writefacts(Emote).

% findEmote(Emote, "Расслаблена", "Расслаблена", "Расслаблена", "Расслаблена", "Расслаблены", "Обычные", "Обе опущены", "Улыбка", "Поднята", "Ok", "No").
