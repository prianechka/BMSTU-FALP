(defun mult (array koef) 
(mapcar #'(lambda (x) (* x koef)) array))

(defun mult (array koef)
(mapcar #'(lambda (x) (if (numberp x) (* x koef) x)) array))