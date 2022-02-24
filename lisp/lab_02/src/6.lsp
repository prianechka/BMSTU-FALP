;;
(cons 3 (list 5 6))                             ; (3 5 6)          
(list 3 'from 9 'gives (- 9 3))                 ; (3 from 9 gives 6)
(+ (length '(1 foo 2 too)) (car '(21 22 23)))   ; 25
(cdr '(cons is short for ans))                  ; (is short for ans)
(car (list one two))                            ; unbound variable : 'one                           
(cons 3 '(list 5 6))                            ; (3 list 5 6))
(car (list 'one 'two))                          ; one