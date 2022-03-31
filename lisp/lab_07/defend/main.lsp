(asdf:oos 'asdf:load-op :FiveAM)
(defpackage :it.bese.FiveAM.example
(:use :common-lisp
	:it.bese.FiveAM))
(in-package :it.bese.FiveAM.example)

;; Проверка на простоту числа
(defun CheckSimpleIterate (value &optional (i 11))
(if (> (* i i) value) T 
    (if (eq (mod value i) 0) Nil (CheckSimpleIterate value (+ i 2)))))

(defun CheckSimple (value)
(if (or (eq value 2) (eq value 3) (eq value 5) (eq value 7)) T 
(if (or (eq (mod value 2) 0) (eq (mod value 3) 0) (eq (mod value 5) 0) (eq (mod value 7) 0)) 
    Nil (CheckSimpleIterate value))))

;; Генерация случайного числа
(defun GenerateRandomSimple (limit delta)
(let* ((tmp (+ (random limit) delta)))
(if (CheckSimple tmp) tmp (GenerateRandomSimple limit delta))))

;; Проверка на взаимную простоту двух чисел
(defun CheckMutualSimpleIterate (a b)
(if (eq a b) a 
    (if (> a b) (CheckMutualSimpleIterate (- a b) b) 
                (CheckMutualSimpleIterate a (- b a)))))

(defun CheckMutualSimple (a b)
(eq (CheckMutualSimpleIterate a b) 1))

;; Генерация открытой экспоненты 
(defun GenerateOpenExp (f)
(let* ((tmp (GenerateRandomSimple f 1)))
    (if (CheckMutualSimple f tmp) tmp (GenerateOpenExp f))))

;; Генерация секретной экспоненты
(defun GenerateSecretExp (openExp f &optional (k 1))
(if (eq (mod (* k openExp) f) 1) k (GenerateSecretExp openExp f (+ k 1))))

;; Генерация всех необходимых ключей
(defun GenerateKeys ()
(let* ((firstSimple (GenerateRandomSimple 8999 1000))
       (secondSimple (GenerateRandomSimple 8999 1000))
       (N (* firstSimple secondSimple))
       (f (* (- firstSimple 1) (- secondSimple 1)))
       (openExp (GenerateOpenExp f))
       (secretExp (GenerateSecretExp openExp f)))
       (list (list openExp N) (list secretExp N))))

;; Функция возведения в степень
(defun myExpt (message koef e n &optional (res 1))
(if (eq e res) message 
        (myExpt (mod (* message koef) n) koef e n (+ res 1))))

(defun Encrypt (openKey message)
(if (> message (cadr openKey)) Nil 
    (myExpt message message (car openKey) (cadr openKey))))

(defun Decrypt (secretKey message)
(myExpt message message (car secretKey) (cadr secretKey)))

(defun RSA (message)
(let* ((keys (GenerateKeys))
       (encryptMessage (Encrypt (car keys) message))
       (decryptMessage (Decrypt (cadr keys) encryptMessage)))
(print (format nil "Сообщение для передачи: ~,d" message))
(print (format nil "Открытый ключ: (~d, ~d)" (caar keys) (cadar keys)))
(print (format nil "Скрытый ключ: (~d, ~d)" (caadr keys) (cadadr keys)))
(print (format nil "Зашифрованное сообщение: ~,d" encryptMessage))
(print (format nil "Расшифрованное сообщение: ~,d" decryptMessage))
T))

(test myTest
    (is (equal T (CheckSimple 2)))
    (is (equal T (CheckSimple 5)))
    (is (equal Nil (CheckSimple 6)))
    (is (equal T (CheckSimple 11)))
    (is (equal Nil (CheckSimple 24)))
    
    (is (equal T (CheckMutualSimple 2 5)))
    (is (equal Nil (CheckMutualSimple 2 4)))
    (is (equal Nil (CheckMutualSimple 7 21)))
    (is (equal Nil (CheckMutualSimple 27 15)))
    (is (equal T (CheckMutualSimple 200 27)))

    (is (equal 9 (myExpt 9 9 5 12)))
    (is (equal 3 (myExpt 3 3 7 21)))
    (is (equal 21 (myExpt 4 4 3 43)))
    (is (equal 6 (myExpt 12 12 11 17)))
    (is (equal 7 (myExpt 13 13 5 9)))

    (is (equal 6111579 (GenerateSecretExp 3 9167368)))
    (is (equal 5 (GenerateSecretExp 5 12)))
    
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 10 (Encrypt '(5 21) 19)))
    
    (is (= 10 (Encrypt '(5 21) 19)))
    (is (= 19 (Decrypt '(17 21) 10)))
    (is (= 197 (Encrypt '(5 323) 11)))
    (is (= 11 (Decrypt '(173 323) 197)))
    (is (= 272 (Encrypt '(5 323) 17)))
    (is (= 17 (Decrypt '(173 323) 272)))
    (is (= 2 (Encrypt '(5 323) 15)))
    (is (= 15 (Decrypt '(173 323) 2)))
    (is (= 304 (Encrypt '(5 323) 19)))
    (is (= 19 (Decrypt '(173 323) 304)))
    (is (= 4051753 (Encrypt '(3 9173503) 111111)))
    (is (= 111111 (Decrypt '(6111579 9173503) 4051753)))
)

(run! 'myTest)


; sbcl --load "/home/prianechka/defend/lab7/main.lsp"
; (in-package :it.bese.FiveAM.example)
