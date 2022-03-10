(defun how_alike_new (x y)
(if (or (= x y) (equal x y)) 'the_same
    (if (and (oddp x) (oddp y)) 'both_odd
    (if (and (evenp x) (evenp y)) 
    'both_even 'difference))))

; Only If
(defun how_alike_if (x y)
  (if (if (= x y) (equal x y)) 'the_same
      (if (if (oddp x) (oddp y)) 'both_odd
      (if (if (evenp x) (evenp y))
      'both_even 'difference))))


; Only OR
(defun how_alike_and_or (x y)
(or (and (or (= x y) (equal x y)) 'the_same)
    (and (and (oddp x) (oddp y)) 'both_odd)
    (and (and (evenp x) (evenp y) 'both_even))
    'difference))