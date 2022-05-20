:- dynamic student/2.
:- dynamic studentInterests/2.
:- dynamic studentsLove/2.

:- dynamic teacher/3.
:- dynamic teacherInterests/2.
:- dynamic teacherLove/2.
% Студент, тип обучения
student("Прянишников", "Бюджет").
student("Богаченко", "Бюджет").
student("Серова", "Бюджет").
student("Шелия", "Бюджет").
student("Межеровский", "Платка").

% Студент, интерес
studentInterests("Прянишников", "Компьютерная графика").
studentInterests("Прянишников", "Моделирование").
studentInterests("Богаченко", "LMS").
studentInterests("Серова", "Компьютерная графика").
studentInterests("Серова", "Моделирование").
studentInterests("Шелия", "БД").

% Предпочтения студента
studentsLove("Прянишников", "Кузнецова").
studentsLove("Богаченко", "Строганов").
studentsLove("Серова", "Строганов").

% Преподаватель, каких берёт, сколько
teacher("Строганов", "Бюджет", 1).
teacher("Строганов", "Платка", 1).
teacher("Кузнецова", "Бюджет", 2).
teacher("Гаврилова", "Бюджет", 1).

% Преподаватель, интерес
teacherInterests("Строганов", "LMS").
teacherInterests("Гаврилова", "БД").

% Предпочтения препода
teacherLove("Строганов", "Богаченко").
teacherLove("Строганов", "Серова").

teacherLove("Кузнецова", "Прянишников").

student("Трошкин", "Бюджет").
studentInterests("Трошкин", "Компьютерная графика").
studentInterests("Трошкин", "Криптография").
studentsLove("Трошкин", "Кузнецова").

teacher("Кузнецов", "Бюджет", 2).
teacher("Кузнецов", "Платка", 0).
teacherInterests("Кузнецов", "Операционные системы").
teacherInterests("Кузнецов", "Анализ данных").
teacherLove("Кузнецов", "Прянишников").

student("Солнцева", "Бюджет").
studentInterests("Солнцева", "Чилл").
studentsLove("Солнцева", "Кузнецова").

teacher("Куров", "Бюджет", 1).
teacher("Куров", "Платка", 0).
teacherInterests("Куров", "Компьютерная графика").

student("Малышев", "Бюджет").
studentInterests("Малышев", "Компьютерная графика").

teacher("Толпинская", "Бюджет", 1).
teacher("Толпинская", "Платка", 1).
teacherInterests("Толпинская", "Компьютерные сети").
teacherInterests("Толпинская", "Блокчейн").

student("Кузьмин", "Бюджет").

teacher("Борисов", "Бюджет", 1).
teacher("Борисов", "Платка", 1).

teacher("Тассов", "Бюджет", 1).
teacher("Тассов", "Платка", 0).
teacherInterests("Тассов", "Компьютерные сети").

writefacts(Text):- open('result.txt', append, Out), write(Out, Text), close(Out).

outputStudent(TeacherName, StudentName) :- writefacts(TeacherName), writefacts(":"), writefacts(StudentName), writefacts("\n").

updateTable(TeacherName, StudentName, Status) :- retract(student(StudentName, Status)), teacher(TeacherName, Status, I), Next is I - 1,
                                                retract(teacher(TeacherName, Status, I)), assert(teacher(TeacherName, Status, Next)).

doAfter(TeacherName, StudentName, Status) :- outputStudent(TeacherName, StudentName), updateTable(TeacherName, StudentName, Status).

findMostMatch(TeacherName, StudentName, Status) :- student(StudentName, Status), teacher(TeacherName, Status, I), I > 0,
                                                   studentsLove(StudentName, TeacherName),
                                                   teacherLove(TeacherName, StudentName).
                                    
findMatchByInterest(TeacherName, StudentName, Status) :- student(StudentName, Status), studentInterests(StudentName, Interes),
                                                        teacherInterests(TeacherName, Interes), teacher(TeacherName, Status, I), I > 0.

findOtherMatch(TeacherName, StudentName, Status) :- student(StudentName, Status), teacher(TeacherName, Status, I), I > 0.

workMost() :- teacher(TeacherName, _, _), findMostMatch(TeacherName, StudentName, "Бюджет"), doAfter(TeacherName, StudentName, "Бюджет").
workMostPaid() :- teacher(TeacherName, _, _), findMostMatch(TeacherName, StudentName, "Платка"), doAfter(TeacherName, StudentName, "Платка").

workInterests() :- teacher(TeacherName, _, _), findMatchByInterest(TeacherName, StudentName,  "Бюджет"), doAfter(TeacherName, StudentName, "Бюджет").
workInterestsPaid() :- teacher(TeacherName, _, _), findMatchByInterest(TeacherName, StudentName,  "Платка"), doAfter(TeacherName, StudentName, "Платка").

workOther() :- teacher(TeacherName, _, _), findOtherMatch(TeacherName, StudentName, "Бюджет"), doAfter(TeacherName, StudentName, "Бюджет").
workOtherPaid() :- teacher(TeacherName, _, _), findOtherMatch(TeacherName, StudentName, "Платка"), doAfter(TeacherName, StudentName, "Платка").

work() :- workMost(), workMostPaid(), workInterests(), workInterestsPaid(), workOther(), workOtherPaid().
work() :- workMostPaid(), workInterests(), workInterestsPaid(), workOther(), workOtherPaid().
work() :- workInterests(), workInterestsPaid(), workOther(), workOtherPaid().
work() :- workInterestsPaid(), workOther(), workOtherPaid().
work() :- workOther(), workOtherPaid().
work() :- workOtherPaid().