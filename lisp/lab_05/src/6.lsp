(defun swap-to-left (lst) 
(reverse (cons (car lst) (reverse (cdr lst)))))

(defun swap-to-right (lst) 
(reverse (cdr (reverse (cons (car (last lst)) lst)))))