(defun select-between (a b lst)
(sort 
(mapcan #'(lambda (x) (and (>= x a) (<= x b) (list x))) lst) 
#'<))