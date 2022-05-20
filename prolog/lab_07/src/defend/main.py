import sys
import os
from PyQt5 import QtWidgets, uic, QtGui
from PyQt5.QtCore import Qt

class MyWindow(QtWidgets.QMainWindow):
    def __init__(self):
        QtWidgets.QWidget.__init__(self)

        self.teachers = self.readFrom("teacher.txt")
        self.students = self.readFrom("students.txt")

        self.main()

    def main(self):
        uic.loadUi("MainMenu.ui", self)
        self.interestTable.setSelectionMode(QtWidgets.QAbstractItemView.ExtendedSelection)
        self.addStudentButton.clicked.connect(lambda: self.addStudent())
        self.addTeacherButton.clicked.connect(lambda: self.addTeacher())
        self.matchButton.clicked.connect(lambda: self.match())

        for el in self.teachers:
            tmp = el[:el.find("\n")]
            self.teachTable.addItem(tmp)

        for el in self.students:
            tmp = el[:el.find("\n")]
            self.studentTable.addItem(tmp)
    
    def readFrom(self, filename):
        f = open(filename, "r")
        result = []
        Lines = f.readlines()
        for line in Lines:
            result.append(line)
        
        return result

    def addInformationStudent(self, studentName, interests, loveTeacher, status):
        f = open("base.pl", "a")
        f.write('\nstudent("{}", "{}").\n'.format(studentName, status))
        for el in interests:
            f.write('studentInterests("{}", "{}").\n'.format(studentName, el))
        
        for el in loveTeacher:
            f.write('studentsLove("{}", "{}").\n'.format(studentName, el))
        f.close()

        f = open("students.txt", "a")
        f.write(studentName + " \n")
        f.close()

        self.studentTable.addItem(studentName)

    def addInformationTeacher(self, teachName, budgetVal, paidVal, interests, loveTeacher):
        f = open("base.pl", "a")
        f.write("\n")
        f.write('teacher("{}", "Бюджет", {}).\n'.format(teachName, budgetVal))
        f.write('teacher("{}", "Платка", {}).\n'.format(teachName, paidVal))
        
        for el in interests:
            f.write('teacherInterests("{}", "{}").\n'.format(teachName, el))
        
        for el in loveTeacher:
            f.write('teacherLove("{}", "{}").\n'.format(teachName, el))

        f.close()

        f = open("teacher.txt", "a")
        f.write(teachName + " \n")
        f.close()

        self.teachTable.addItem(teachName)

    def addStudent(self):
        surname = self.studentEdit.text()

        if self.budgetRadio.isChecked():
            status = "Бюджет"
        elif self.paidRadio.isChecked():
            status = "Платка"
        else:
            return
        
        if surname in self.students:
            return
        else:
            self.students.append(surname)
        
        interests = []
        loveTeacher = []
        
        for el in self.interestTable.selectedItems():
            interests.append(el.text())
        
        for el in self.teachTable.selectedItems():
            loveTeacher.append(el.text())
        
        self.addInformationStudent(surname, interests, loveTeacher, status)

    def addTeacher(self):
        surname = self.surnameEdit.text()

        budgetVal = self.budgetSpin.value()
        paidVal = self.paidSpin.value() 

        if surname in self.teachers:
            return
        else:
            self.teachers.append(surname)
        
        interests = []
        loveStudents = []
        
        for el in self.interestTable.selectedItems():
            interests.append(el.text())
        
        for el in self.studentTable.selectedItems():
            loveStudents.append(el.text())
        
        self.addInformationTeacher(surname, budgetVal, paidVal, interests, loveStudents)

    def match(self):
        uic.loadUi("match.ui", self)
        self.table.setColumnWidth(0, 350)
        self.table.setColumnWidth(1, 350)

        f1 = open("insert.pl", "r")
        ins = f1.read()
        f1.close()

        f1 = open("base.pl", "r")
        base = f1.read()
        f1.close()

        f1 = open("actions.pl", "r")
        acts = f1.read()
        f1.close()

        f = open("def.pl", "w")
        f.write(ins + "\n")
        f.write(base + "\n")
        f.write(acts)
        f.close()

        f = open("result.txt", "w")
        f.close()
        self.backButton.clicked.connect(lambda: self.main())
        os.system('swipl -f def.pl -t "work()." -g "work()."')
        f = open("result.txt", "r")
        Lines = f.readlines()
        i = 0
        for line in Lines:
            self.table.setRowCount(i + 1)
            arr = line.split(':')
            teach = arr[0].rstrip()
            student = arr[1].rstrip()
            self.table.setItem(i, 0, QtWidgets.QTableWidgetItem(teach))
            self.table.setItem(i, 1, QtWidgets.QTableWidgetItem(student))
            i += 1
        f.close()
        


app = QtWidgets.QApplication(sys.argv)
window = MyWindow()
window.show()
sys.exit(app.exec_())