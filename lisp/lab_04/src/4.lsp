(defun delete_last (a) 
(reverse (cdr (reverse a))))

(defun delete_last_2 (a)
(butlast a))

(defun delete_last_3(a)                      
  (cond 
    ((null (cdr a)) nil)                        
    (t (cons (car a) (reduce_list_3 (cdr a)))
    ))
)