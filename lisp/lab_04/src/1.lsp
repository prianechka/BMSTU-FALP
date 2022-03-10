(setf lst1 '(a b))
(setf lst2 '(c d))

(cons lst1 lst2)   ; (a b) . (c d) ->  ((a b) c d)
(list lst1 lst2)   ; ((a b) (c d))
(append lst1 lst2) ; (a b c d)
