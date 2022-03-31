(defun square (lst)
(mapcar #'(lambda (x) (* x x)) lst))