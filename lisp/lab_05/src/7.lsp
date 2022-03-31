(defun check (lst1 addlst)
(if (equal (cdr lst1) Nil) T 
(if (equal (car lst1) addlst) Nil (add-list (cdr lst1) addlst))))

(defun add-list (lst1 addlst)
(if (check lst1 addlst) (and (setf (cdr (last lst1)) addlst) lst1) lst1))