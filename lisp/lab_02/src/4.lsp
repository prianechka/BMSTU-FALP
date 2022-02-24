(list 'a c)                     ; unbound variable : 'c
(cons 'a (b c))                 ; unbound variable : '(b c)
(cons 'a '(b c))                ; (A B C)
(caddy (1 2 3 4 5))             ; illegal funtion call
(cons 'a 'b' c)                 ; invalid number of arguments 3
(list 'a (b c))                 ; unbound variable : 'b
(list a '(b c))                 ; unbound variable : 'a
(list (+ 1 '(length '(1 2 3)))) ; The value (LENGTH '(1 2 3)) is not of type NUMBER


(list 'a 'c)                    ; (A C)
(cons 'a '(b c))                ; (A (B C))
(cons 'a '(b c))                ; (A B C)
(length '(1 2 3 4 5))           ; 5
(cons 'a '(b c))                ; (A (B C))
(list 'a '(b c))                ; (A (B C))
(list 'a '(b c))                ; (A (B C))
(list (+ 1 (length '(1 2 3))))  ; (4)
