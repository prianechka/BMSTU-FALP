(defun my-reverse (lst &optional (result nil)) 
(if (null lst) result (my-reverse (rest lst) (cons (first lst) result))))