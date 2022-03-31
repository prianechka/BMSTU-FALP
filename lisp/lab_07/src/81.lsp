(defun rec-add (lst &optional (result 0))
  (if (null lst) result (rec-add (cdr lst) (+ result (car lst)))))

(defun rec-add (lst &optional (result 0))
  (if (null lst) 
    result 
  (if (listp (car lst))
        (rec-add (cdr lst) (+ result (rec-add (car lst))))
        (rec-add (cdr lst) (+ result (car lst)))
)))