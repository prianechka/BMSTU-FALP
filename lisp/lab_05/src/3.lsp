(defun find-country (map findedCity) 
(if (equal (car map) Nil) Nil 
(if (equal (cadar map) findedCity) 
    (caar map) 
    (find-capital (cdr map) findedCity))))

(defun find-capital (map findedCountry) 
(if (equal (car map) Nil) Nil 
(if (equal (caar map) findedCountry) 
    (cadar map) (find-capital (cdr map) findedCountry))))
