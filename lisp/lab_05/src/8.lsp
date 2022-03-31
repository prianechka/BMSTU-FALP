(defun multiply-first (array koef)
(and (setf (car array) (* (car array) koef)) array))

(defun multiply-first (array koef) 
(if (numberp (first array)) (and (setf (car array) (* (car array) koef) )array) 
(if (numberp (second array)) (and (setf (cadr array) (* (cadr array) koef) ) array)
(if (numberp (third array)) (and (setf (caddr array) (* (caddr array) koef)) array)))))