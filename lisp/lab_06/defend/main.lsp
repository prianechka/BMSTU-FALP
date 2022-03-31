(asdf:oos 'asdf:load-op :FiveAM)
(defpackage :it.bese.FiveAM.example
(:use :common-lisp
	:it.bese.FiveAM))
(in-package :it.bese.FiveAM.example)

(defun sum-sok (number1 number2 basis)
(mapcar #'(lambda (x y z) 
            (mod (+ x y) z)) 
            number1 number2 basis))

(defun sub-sok (number1 number2 basis)
(mapcar #'(lambda (x y z) 
            (mod (- x y) z)) 
            number1 number2 basis))

(defun mul-sok (number1 number2 basis)
(mapcar #'(lambda (x y z) 
            (mod (* x y) z)) 
            number1 number2 basis))

(defun my-expt (x koef s &optional (res 1))
(if (= (- s 2) res) x 
        (my-expt (mod (* (mod x s) (mod koef s)) s) koef s (+ res 1))))

(defun div-sok (number1 number2 basis)
(mapcar #'(lambda (x y z) (mod (* x (my-expt y y z)) z))
                             number1 number2 basis))

(defun translate-to-sok (number10 basis)
(mapcar #'(lambda (y) (mod number10 y)) basis))

(defun mult-basis (basis) 
(reduce #'* basis))

(defun find-weight (el coef &optional (tmp 0)) 
(if (= (mod tmp el) 1) 
        tmp 
        (find-weight el coef (+ tmp coef))))

(defun make-weights (basis)
(mapcar #'(lambda (y) 
        (find-weight y (mult-basis (remove y basis)))) basis))

(defun translate-to-10 (num-sok basis)
(mod (reduce #'+ (mapcar #'* num-sok (make-weights basis))) (mult-basis basis)))

(defun sum-numbers (num1 num2 basis)
(translate-to-10 (sum-sok (translate-to-sok num1 basis) 
                      (translate-to-sok num2 basis) basis) basis))

(defun sub-numbers (num1 num2 basis)
(translate-to-10 (sub-sok (translate-to-sok num1 basis) 
                            (translate-to-sok num2 basis) basis) basis))

(defun mul-numbers (num1 num2 basis)
(translate-to-10 (mul-sok (translate-to-sok num1 basis) 
                            (translate-to-sok num2 basis) basis) basis))

(defun div-numbers (num1 num2 basis)
(translate-to-10 (div-sok (translate-to-sok num1 basis) 
                            (translate-to-sok num2 basis) basis) basis))

(defun check-to-sum (num1 num2 basis)
(let* ((mult (mult-basis basis)))
(and (>= num1 0) (>= num2 0) (< num1 mult) (< num2 mult) (< (+ num1 num2) mult))))

(defun check-to-mul (num1 num2 basis)
(let* ((mult (mult-basis basis)))
(and (>= num1 0) (>= num2 0) (< num1 mult) (< num2 mult) (< (* num1 num2) mult))))

(defun check-to-sub (num1 num2)
(and (>= num1 0) (>= num2 0) (>= num1 num2)))

(defun check-basis (num basis)
(if (= (length basis) 0) T 
    (if (= 0 (mod num (car basis))) Nil (check-basis num (cdr basis)))))

(defun check-to-divide (num1 num2 basis)
(and (>= num1 0) (> num2 0) (>= num1 num2) (= (mod num1 num2) 0) (check-basis num2 basis)))

(defun sum (num1 num2 basis)
(if (check-to-sum num1 num2 basis)
    (sum-numbers num1 num2 basis) Nil))

(defun sub (num1 num2 basis)
(if (check-to-sub num1 num2)
    (sub-numbers num1 num2 basis) Nil))

(defun mul (num1 num2 basis)
(if (check-to-mul num1 num2 basis) 
    (mul-numbers num1 num2 basis) Nil))

(defun divide (num1 num2 basis)
(if (check-to-divide num1 num2 basis)
    (div-numbers num1 num2 basis) Nil))

(test myTest
    (is (= 21 (sum 12 9 '(3 5 7))))
    (is (= 21 (sum 12 9 '(3 5 7 13))))
    (is (= 12 (sum 12 0 '(3 5 7))))
    (is (= 50 (sum 29 21 '(3 5 7))))
    (is (= 104 (sum 103 1 '(3 5 7))))
    (is (= 0 (sum 0 0 '(3 5 7))))
    (is (equal Nil (sum 104 2 '(3 5 7))))
    
    (is (= 3 (sub 12 9 '(3 5 7))))
    (is (= 3 (sub 12 9 '(3 5 7 13))))
    (is (= 3 (sub 12 9 '(3 5))))
    (is (= 12 (sub 12 0 '(3 5 7))))
    (is (= 8 (sub 29 21 '(3 5 7))))
    (is (= 66 (sub 103 37 '(3 5 7))))
    (is (= 0 (sub 0 0 '(3 5 7))))
    (is (equal Nil (sub -2 2 '(3 5 7))))
    (is (equal Nil (sub 2 -2 '(3 5 7))))
    (is (equal Nil (sub 5 12 '(3 5 7))))

    (is (= 51 (mul 17 3 '(3 5 7))))
    (is (= 17 (mul 17 1 '(5 7))))
    (is (= 51 (mul 17 3 '(3 5 7 13))))
    (is (= 888 (mul 24 37 '(3 5 7 11 13))))
    (is (= 0 (mul 17 0 '(3 5 7))))

    (is (equal Nil (mul 5 12 '(3 5))))

    (is (= 6 (divide 18 3 '(5 7))))
    (is (= 17 (divide 17 1 '(3 5 7))))
    (is (= 208 (divide 1872 9 '(29 31 32))))
    (is (= 20 (divide 240 12 '(5 7 11 13))))

    (is (equal Nil (divide 5 12 '(3 5))))
    (is (equal Nil (divide -2 12 '(3 5 7))))
    (is (equal Nil (divide 5 -2 '(3 5 7))))
    (is (equal Nil (divide 5 15 '(3 5 7))))
    (is (equal Nil (divide 15 4 '(3 5 7))))
    (is (equal Nil (divide 6 3 '(3 5 7))))

    (is (equal T (check-to-sum 5 12 '(3 5 7))))
    (is (equal Nil (check-to-sum 5 120 '(3 5 7))))
    (is (equal Nil (check-to-sum 5 104 '(3 5 7))))
    (is (equal Nil (check-to-sum -5 12 '(3 5 7))))
    (is (equal Nil (check-to-sum 5 -104 '(3 5 7))))

    (is (equal T (check-to-sub 12 5)))
    (is (equal Nil (check-to-sub 5 -2)))
    (is (equal Nil (check-to-sub -5 104)))
    (is (equal Nil (check-to-sub 12 104)))

    (is (equal T (check-to-mul 5 12 '(3 5 7))))
    (is (equal Nil (check-to-mul 5 120 '(3 5 7))))
    (is (equal Nil (check-to-mul 5 104 '(3 5 7))))

    (is (equal Nil (check-to-divide 5 12 '(3 5 7))))
    (is (equal Nil (check-to-divide 5 120 '(3 5 7))))
    (is (equal Nil (check-to-divide 5 104 '(3 5 7))))
    (is (equal Nil (check-to-divide -5 12 '(3 5 7))))
    (is (equal Nil (check-to-divide 5 -104 '(3 5 7))))
    (is (equal T (check-to-divide 12 6 '(11 5 7))))
    (is (equal Nil (check-to-divide 12 6 '(3 5 7))))



    (is (equal '(2 2 5) (sum-sok '(0 1 2) '(2 1 3) '(13 5 11))))
    (is (equal '(0 2 1) (sum-sok '(1 1 5) '(2 1 3) '(3 5 7))))

    (is (equal '(1 1 5) (sub-sok '(3 2 1) '(2 1 3) '(9 5 7))))
    (is (equal '(2 0 2) (sub-sok '(1 1 5) '(2 1 3) '(3 5 7))))

    (is (equal '(0 1 6) (mul-sok '(0 1 2) '(2 1 3) '(3 5 7))))
    (is (equal '(2 1 4) (mul-sok '(1 1 5) '(2 1 3) '(3 5 11))))

    (is (equal '(0 3 0) (div-sok '(2 4 0) '(0 3 2) '(3 5 7))))
    (is (equal '(0 1 4) (div-sok '(0 1 7) '(2 1 10) '(13 5 11))))

    (is (equal 4 (my-expt 9 9 5)))
    (is (equal 5 (my-expt 3 3 7)))

    (is (equal 105 (mult-basis '(3 5 7))))
    (is (equal 1155 (mult-basis '(3 5 7 11))))

    (is (equal '(495 286 650) (make-weights '(13 5 11))))
    (is (equal '(16380 20020 15015 6006 25740 6930) (make-weights '(11 3 2 5 7 13))))

    (is (equal '(0 0 1) (translate-to-sok 15 '(3 5 7))))
    (is (equal '(0 0 0) (translate-to-sok 0 '(3 5 7))))
    (is (equal '(2 0 3 4 6) (translate-to-sok 123 '(11 3 5 7 13))))
    (is (equal '(2 4 4 17 6) (translate-to-sok 74 '(3 5 7 19 17))))
    (is (equal '(1 1) (translate-to-sok 1 '(3 5))))

    (is (equal 52 (translate-to-10 '(1 2 3) '(3 5 7))))
    (is (equal 497 (translate-to-10 '(3 2 0 14) '(13 11 7 23))))
    (is (equal 0 (translate-to-10 '(0 0 0) '(3 5 7))))
    (is (equal 1 (translate-to-10 '(1 1 1) '(13 5 7))))
    (is (equal 4798 (translate-to-10 '(1 2 3 4) '(13 11 7 17))))

)

(run! 'myTest)

; sbcl --load "/home/prianechka/defend/lab6/main.lsp"
; (in-package :it.bese.FiveAM.example)
