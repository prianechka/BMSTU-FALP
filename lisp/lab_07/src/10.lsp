(defun allodd (lst) 
(if (null lst) T 
    (if (oddp (car lst)) 
        (allodd (cdr lst)) 
        Nil)))