(defun select-between (a b lst &optional (result nil)) 
(if (null lst) (sort result #'<) 
    (if (and (>= (car lst) a) (<= (car lst) b)) 
        (get-between a b (cdr lst) (cons (first lst) result)) 
        (get-between a b (cdr lst) result)
)))