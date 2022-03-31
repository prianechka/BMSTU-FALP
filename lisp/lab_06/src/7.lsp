(defun decart (lst1 lst2)
 (apply 'append (mapcar #'(lambda (a) (mapcar #'(lambda (b) (list a b)) lst2)) lst1))) 
