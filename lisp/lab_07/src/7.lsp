(defun mult (lst koef &optional (result nil))
(if (null lst) (my-reverse result) 
(mult (cdr lst) koef 
    (if (numberp (car lst)) 
        (cons (* (car lst) koef) result) 
        (cons (car lst) result) ))))