(defun isPalindrom (lst) 
(if (= (length lst) 1) T
(if (= (length lst) 2) (= (second lst) (first lst))
    (and (= (car (last lst)) (car lst)) (isPalindrom (butlast (cdr lst)))))))