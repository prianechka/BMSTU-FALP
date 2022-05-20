import sys
import os
from PyQt5 import QtWidgets, uic
from PyQt5.QtWidgets import QMessageBox

class MyWindow(QtWidgets.QMainWindow):
    def __init__(self):
        QtWidgets.QWidget.__init__(self)
        self.main()

    def main(self):
        uic.loadUi("main.ui", self)
        self.findButton.clicked.connect(lambda: self.find())
    
    def find(self):
        nose = self.nose.selectedItems()[0].text()
        tension = self.tension.selectedItems()[0].text()
        iris = self.iris.selectedItems()[0].text()
        lips = self.lips.selectedItems()[0].text()
        lefthead = self.lefthead.selectedItems()[0].text()
        leftcurve = self.leftcurve.selectedItems()[0].text()
        righthead = self.righthead.selectedItems()[0].text()
        rightcurve = self.rightcurve.selectedItems()[0].text()
        head = self.head.selectedItems()[0].text()
        mouth = self.mouth.selectedItems()[0].text()
        eyes = self.eyes.selectedItems()[0].text()

        findedStr = 'findEmote(Emote, "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}")'.format(lefthead, \
            leftcurve, righthead, rightcurve, eyes, iris, lips, mouth, head, nose, tension)
        
        f = open("result.txt", "w")
        f.close()
        os.system("swipl -f defend.pl -g '{}.' -t 'halt.'".format(findedStr))
        f = open("result.txt", "r")
        res = f.read()
        f.close()
        print(res)

        QMessageBox.about(self, "Результат", "Эмоция на введенном выражении лица: \n" + res)

app = QtWidgets.QApplication(sys.argv)
window = MyWindow()
window.show()
sys.exit(app.exec_())