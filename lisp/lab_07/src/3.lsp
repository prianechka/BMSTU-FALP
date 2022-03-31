(defun return-list (lst)
(if (listp (car lst)) (car lst) (return-list (rest lst))))