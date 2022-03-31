(defun recnth (lst n &optional (index 0))
(if (null lst) Nil 
    (if (= index n) 
    (car lst) 
    (recnth (cdr lst) n (+ 1 index))
)))