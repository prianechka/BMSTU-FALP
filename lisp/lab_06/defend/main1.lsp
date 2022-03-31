(asdf:oos 'asdf:load-op :FiveAM)
(defpackage :it.bese.FiveAM.example
(:use :common-lisp
	:it.bese.FiveAM))
(in-package :it.bese.FiveAM.example)

(declaim (sb-ext:muffle-conditions cl:warning))

; Объявление собственных типов
(defclass MyInt()((value :initarg :value :accessor value)))
(defclass MyFloat()((value :initarg :value :accessor value)))
(defclass MyStr()((value :initarg :value :accessor value)))
(defclass MyRing10()((value :initarg :value :accessor value)))
(defclass MyList()((value :initarg :value :accessor value)))

;; Объявление мультиметодов
(defgeneric MyBinary (a b)) ; Бинарная операция для двух объектов какого-то типа
(defgeneric translate (a b)) ; Функция для перевода значения в нужный тип
(defgeneric Binary (M a b)) ; Вызов функции в моноиде для двух значений

;; Бинарный мультиметод, который используется в моноидах
(defmethod MyBinary ((n1 MyInt)(n2 MyInt)) (+ (value n1) (value n2)))
(defmethod MyBinary ((n1 MyFloat)(n2 MyFloat)) (- (value n1) (value n2)))
(defmethod MyBinary ((s1 MyStr)(s2 MyStr)) (concatenate 'string (value s1) (value s2)))
(defmethod MyBinary ((n1 MyRing10)(n2 MyRing10)) (mod (+ (value n1) (value n2)) 10))
(defmethod MyBinary ((s1 MyList)(s2 MyList)) (append (value s1) (value s2)))

(defmethod translate ((n1 integer) (s1 symbol)) 
    (if (eq s1 'MyStr) 
        (make-instance 'MyStr :value (write-to-string n1))
    (if (eq s1 'MyFloat)
        (make-instance 'MyFloat :value n1)
    (if (eq s1 'MyInt)
        (make-instance 'MyInt :value n1)
    (if (eq s1 'MyRing10)
        (make-instance 'MyRing10 :value n1)
    (if (eq s1 'MyList)
        (make-instance 'MyList :value (list n1)))
    )))))

(defmethod translate ((lst cons) (s1 symbol)) 
    (if (eq s1 'MyList) 
        (make-instance 'MyList :value lst)))

(defmethod translate ((t1 simple-array) (s1 symbol))
    (if (eq s1 'MyStr)
        (make-instance 'MyStr :value t1)
    (if (eq s1 'MyList)
        (make-instance 'MyList :value (list t1)))))

;; Объявление классов

;; Класс значение - хранит значение любого типа
(defclass Value() ((value :initarg :value :accessor value)))
;; Класс моноида - хранит тип, для которого он определён
(defclass Monoid () ((typename :initarg :typename :accessor typename)))

;; Реализация метода для функции в моноиде
(defmethod Binary ((M Monoid) (a Value) (b Value)) 
    (funcall 'MyBinary (translate (value a) (typename M)) (translate (value b) (typename M))))

(setf a1 (make-instance 'Value :value 8))
(setf a2 (make-instance 'Value :value 9))
(setf a3 (make-instance 'Value :value "Hello world!"))
(setf a4 (make-instance 'Value :value '(1 2)))
(setf m1 (make-instance 'Monoid :typename 'MyInt))
(setf m2 (make-instance 'Monoid :typename 'MyFloat))
(setf m3 (make-instance 'Monoid :typename 'MyStr))
(setf m4 (make-instance 'Monoid :typename 'MyRing10))
(setf m5 (make-instance 'Monoid :typename 'MyList))


(test myTest
    (is (equal 17 (Binary m1 a1 a2)))
    (is (equal 18 (Binary m1 a2 a2)))
    (is (equal -1 (Binary m2 a1 a2)))
    (is (equal "89" (Binary m3 a1 a2)))
    (is (equal 7 (Binary m4 a1 a2)))
    (is (equal '(8 9) (Binary m5 a1 a2)))
    (is (equal "Hello world!8" (Binary m3 a3 a1)))
    (is (equal "9Hello world!" (Binary m3 a2 a3)))
    (is (equal '("Hello world!" 8) (Binary m5 a3 a1)))
    (is (equal '("Hello world!" 1 2) (Binary m5 a3 a4))))

(run! 'myTest)

; sbcl --load "/home/prianechka/defend/lab6/main1.lsp"
; (in-package :it.bese.FiveAM.example)