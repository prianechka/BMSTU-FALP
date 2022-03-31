(defun len (arr)
  (reduce #'(lambda (current x) (+ current (length x))) (cons 0 arr)))