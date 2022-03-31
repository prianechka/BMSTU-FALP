(asdf:oos 'asdf:load-op :FiveAM)
(defpackage :it.bese.FiveAM.example
(:use :common-lisp
	:it.bese.FiveAM))
(in-package :it.bese.FiveAM.example)

(defun create-speed-array (array)
(map 'list #'cadr array))

(defun sort-speed-array (array)
(sort array #'<))

(defun find-max (array)
(car (last array)))

(defun delete_last_array (array)
(butlast array))

(defun divide-array (array N`)
(map 'list #'(lambda (x y) (/ y x)) array (make-array (length array) :initial-element N))
)

(defun sum-array (array S)
(reduce #'+ (divide-array array S)))

(defun solve (S array)
(let* ((speed (sort-speed-array (create-speed-array array)))
    (max-speed (find-max speed))
    (N (length speed))
    (other-array (delete_last_array speed)))
    (if (= N 1) (/ S max-speed)
    (+ (sum-array other-array S) (/ (* (- N 2) S) max-speed)))
))

(test myTests
 (is (= 1 (solve 20 '((Andrew 20)))))
 (is (= 5 (solve 100 '((Andrew 20)))))
 (is (= 1 (solve 20 '((Andrew 20) (Henry 30)))))
 (is (= 2 (solve 20 '((Andrew 20) (Tennis 10)))))
 (is (= 17 (solve 50 '((Andrew 10) (Thomas 25) (Alex 5)))))
 (is (= 14 (solve 16 '((Andrew 8) (Thomas 4) (Alex 2)))))
 (is (= 13 (solve 20 '((Andrew 20) (Tanya 5) (Alex 4) (Artem 10)))))
 (is (= (/ 391261 71610) (solve 20 '((Andrew 24) (Tanya 31) (Alex 50) (Artem 20) (Yura 42) (Natasha 22)))))
 (is (= (/ 10207 2310) (solve 20 '((Andrew 24) (Alex 50) (Artem 20) (Yura 42) (Natasha 22)))))
)

(run! 'myTests)

;; sbcl --load "/home/prianechka/defend/lab4/main.lsp"
