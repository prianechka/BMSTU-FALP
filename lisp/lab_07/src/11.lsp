(defun find-first-odd (lst) 
(if (null lst) Nil 
    (if (listp (car lst))
        (let ((res (find-first-odd (car lst))))
            (if (equal res Nil) 
                (find-first-odd (cdr lst))
                res))
        (if (oddp (car lst))
            (car lst)
            (find-first-odd (cdr lst)))
    )
))