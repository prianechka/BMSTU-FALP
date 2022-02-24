(defun mystery (x) 
    (list (second x) (first x)))

(mystery '(one two))        ; (TWO ONE)
(mystery (last 'one 'two))  ; The value ONE is not of type LIST when binding LIST
(mystery 'one 'two)         ; INVALID NUMBER OF ARGUMENTS: 2
(mystery 'free)             ; The value FREE is not of type LIST