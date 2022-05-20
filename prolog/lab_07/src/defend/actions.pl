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