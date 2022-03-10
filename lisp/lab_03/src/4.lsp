(defun beetween (a b c)
(if (or 
(and (> a b) (< a c))
(and (> a c) (< a b)))
T Nil))

(defun beetween (a b c)
(or 
(and (> a b) (< a c))
(and (> a c) (< a b))))