(defun translate (val)
	(if (numberp val)
		(if (complexp val)
			(if (plusp (imagpart val))
				(format nil "~,2f+~,2fi" (realpart val) (imagpart val))
				(format nil "~,2f~,2fi" (realpart val) (imagpart val)))
			(format nil "~,2f" val))
		val))

(defun print_value (value format-string output-file)
	(with-open-file (stream output-file :direction :output 
										:if-exists :RENAME-AND-DELETE
										:if-does-not-exist :create)
			(format stream format-string (translate value))))

(defun print_second_value (value format-string output-file)
	(with-open-file (stream output-file :direction :output :if-exists :append 
															:if-does-not-exist :create)
			(format stream format-string (translate value))))

(defun solve (a b c file)
	(or (and (and (not (zerop a)) (not (zerop c)))
		(let* 
				((D (- (* b b) (* 4 a c)))
				(root1 (/ (+ b (sqrt D)) (* -2 a)))
				(root2 (/ (- b (sqrt D)) (* -2 a))))
            (or 
                (and (zerop D) 
                    (not (print_value (/ (- b) (* 2 a) ) "Решение уравнения: x = ~a" file)))
            (not (or (print_value root1 "Корни уравнения: x1 = ~a" file) (print_second_value root2 ", x2 = ~a" file))))))
		(and (zerop a) 
            (or 
                (and (not (zerop b)) 
                    (not (print_value (/ (- c) b) "Корень уравнения: x0=~a" file)))
                (and (not (zerop c))
                    (not (print_value nil "У уравнения корней нет" file)))
                (not (print_value nil "Бесконечное количество корней" file))))
	(not (or (print_value 0 "Корни уравнения: x1 = ~a" file) (print_second_value (/ (- b) a) ", x2 = ~a" file)))))

; (solve 1 2 3 "/home/prianechka/defend/result.txt")
; (solve 0 0 0 "/home/prianechka/defend/res.txt")
; (solve 0 0 1 "/home/prianechka/defend/result.txt")
; (solve 0 1 2 "/home/prianechka/defend/result.txt")
; (solve 1 0 -1 "/home/prianechka/defend/result.txt")
; (solve 1 0 0 "/home/prianechka/defend/result.txt")
; (solve 1 2 1 "/home/prianechka/defend/result.txt")
; (solve 1 -2 -3 "/home/prianechka/defend/result.txt")