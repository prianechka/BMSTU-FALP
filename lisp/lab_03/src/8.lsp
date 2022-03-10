(defun beetween-cond (a b c)
(cond ((or 
(and (< a b) (> a c))
(and (> a b) (< a c))) T) 
(T Nil)))

(defun beetween-andor (a b c)
(or 
(and (< a b) (> a c))
(and (> a b) (< a c))))