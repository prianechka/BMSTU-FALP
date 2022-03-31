(defun swap-first-last (lst) 
(setf (cdr (last lst)) (car lst))
(cdr lst))