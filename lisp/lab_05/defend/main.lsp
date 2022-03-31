(asdf:oos 'asdf:load-op :FiveAM)
(defpackage :it.bese.FiveAM.example
(:use :common-lisp
	:it.bese.FiveAM))
(in-package :it.bese.FiveAM.example)

;; Транспонирование списка
(defun TransposeList (matrix)
    (apply #'mapcar #'list matrix))

(defun Concat (matrix1 matrix2)
(mapcar #'(lambda (x y) (append x y)) matrix1 matrix2))

(defun CreateRange (len &optional (res '()))
(if (eq (length res) len) res 
    (createRange len (append res (list (+ (length res) 1))))))

(defun CreatePairs (range)
(apply 'append 
    (mapcar #'(lambda (a) 
        (mapcar #'(lambda (b) 
            (if (not (eq a b)) 
                (list a b) Nil)) range)) range)))

(defun DeleteNils (array &optional (res '()))
(if (eq array Nil) res 
    (if (eq (car array) Nil) 
        (DeleteNils (cdr array) res) 
        (DeleteNils (cdr array) (append res (list (car array)))))
))

(defun CreateSeq (matrix)
(let* ((len (length matrix))
        (range (CreateRange len))
        (pairs (CreatePairs range))
        (arr (DeleteNils pairs)))
        arr))

(defun CreateNullMatrix (len) 
(make-list len :initial-element (make-list len :initial-element 0)))

;; Замена элементу по индексу
(defun ReplaceElByIndex (lst index toReplace &optional (res '()))
(if (eq lst Nil) res 
    (if (eq (length res) index) 
        (ReplaceElByIndex (cdr lst) index toReplace (append res (list toReplace)))
        (ReplaceElByIndex (cdr lst) index toReplace (append res (list (car lst)))))))

(defun CreateOnesMatrix (matrix)
    (apply 'list
        (mapcar #'(lambda (row n) (ReplaceElByIndex row (- n 1) 1)) matrix 
                                (CreateRange (length matrix)))))

(defun CreateMatrixToGauss (matrix)
(Concat matrix (CreateOnesMatrix (CreateNullMatrix (length matrix)))))

(defun FindCoef (matrix pair)
(let* ((first (nth (- (car pair) 1) (nth (- (cadr pair) 1) matrix)))
        (second (nth (- (car pair) 1) (nth (- (car pair) 1) matrix))))
(if (= second 0) 0 (/ first second))))

(defun subRows (row1 row2 koef)
(mapcar #'(lambda (a b) (- b (* a koef))) row1 row2))

(defun IterateOfSubs (matrix pair)
(let* ((firstRow (nth (- (car pair) 1) matrix))
        (secondRow (nth (- (cadr pair) 1) matrix)))
(ReplaceElByIndex matrix (- (cadr pair) 1) 
                        (subRows 
                            firstRow
                            secondRow
                            (FindCoef matrix pair)))))

(defun IterateSolve (matrix pairs)
(if (eq pairs Nil) matrix 
    (IterateSolve (IterateOfSubs matrix (car pairs)) (cdr pairs))
))

(defun LastSub (matrix range)
(if (eq range Nil) matrix
    (let* ((num (- (car range) 1))
            (row (nth num matrix))
            (el  (nth num row)))
    (LastSub (ReplaceElByIndex matrix num 
        (mapcar #'(lambda (a) (if (= el 0) a (/ a el))) row)) (cdr range))
    )
))

(defun BackRow (row len)
(if (eq len (length row)) row (BackRow (cdr row) len)))

(defun CheckRow (row bound)
(if (eq bound 0) Nil
    (if (eq (car row) 0) 
        (CheckRow (cdr row) (- bound 1))
        T
    )
))

(defun checkMatrix (matrix)
(let* ((N (length (car matrix)))
        (half (first (list (floor (/ N 2)))))
        (row (nth (- (length matrix) 1) matrix)))
(CheckRow row half)))

(defun FindBackMatrix (matrix)
(let* ( (N (length matrix))
        (range (CreateRange N))
        (pairs (DeleteNils (CreatePairs range)))
        (tmpMatrix (CreateMatrixToGauss matrix))
        (result (IterateSolve tmpMatrix pairs))
        (bigResult (LastSub result range)))
(if (checkMatrix bigResult)
    (mapcar #'(lambda (a) (BackRow a N)) bigResult) Nil)))


(defun DotMatrix (matrix1 matrix2)
  (mapcar #'(lambda (row)
              (apply #'mapcar #'(lambda (&rest column)
                    (apply #'+ (mapcar #'* row column))) matrix2)) matrix1))

(defun SumMatrix (matrix1 matrix2)
(mapcar #'(lambda (row1 row2) (mapcar #'(lambda (a b) (+ a b)) row1 row2)) matrix1 matrix2))

(defun FindSqrt (matrix)
(mapcar #'(lambda (row)
    (mapcar #'sqrt row)) matrix))

(defun FindErmitMatrix (matrix)
(let* ((Ermit (TransposeList matrix)))
(mapcar #'(lambda (row)
    (mapcar #'(lambda (a) 
        (if (complexp a) 
            (let* ((imag (imagpart a)))
                (complex (realpart a) (* -1 imag))) a)) row)) Ermit)))

(defun FindErmitGood (matrix)
(if (eq (FindBackMatrix matrix) Nil)
    (if (eq (FindBackMatrix (SumMatrix matrix (FindErmitMatrix matrix))) Nil)
        (SumMatrix (CreateOnesMatrix (CreateNullMatrix (length matrix))) (SumMatrix matrix (FindErmitMatrix matrix)))
        (SumMatrix matrix (FindErmitMatrix matrix)))
    (FindBackMatrix matrix)
    )
)

(defun FindPolar (matrix)
(let* ((Ermit (FindSqrt (DotMatrix matrix (FindErmitMatrix matrix)))))
    (if (eq (FindBackMatrix Ermit) Nil)
        (let* ((Ermit (FindErmitGood matrix))
                (Unit (DotMatrix (FindBackMatrix Ermit) matrix)))
        (list Ermit Unit))
        (let* ((Ermit (FindSqrt (DotMatrix matrix (FindErmitMatrix matrix))))
                (Unit (DotMatrix (FindBackMatrix Ermit) matrix)))
        (list Ermit Unit)))))

;; Тоже самое для array 

;; Создать NullMatrix с array (принимает на вход исходный массив)
(defun CreateNullMatrixArray (arr)
(make-array (array-dimensions arr) :initial-element 0))

;; Замена элемента в одномерном массиве
(defun ReplaceElByIndexArr (arr index toReplace)
(replace arr (make-array (array-dimensions arr) :initial-element toReplace) 
        :start1 index :end1 (+ index 1)))

;; Получить строку из массива
(defun arraySlice (arr i)
(let* ((dims (array-dimensions arr))
        (columns (cadr dims)))
    (make-array columns
      :displaced-to arr 
       :displaced-index-offset (* i columns))))

;; Замена элемента в двумерном массиве
(defun ReplaceIn (array row col toReplace)
(and (setf (aref array row col) toReplace) array))

(defun SwapElems (array row col)
(let* ((tmp (aref array row col)))
(ReplaceIn (ReplaceIn array row col (aref array col row)) col row tmp)
))

(defun IterateTranspose (arr pairs)
(if (eq pairs Nil) arr 
    (IterateTranspose 
        (SwapElems arr (- (car (car pairs)) 1) (- (cadr (car pairs)) 1))
        (cdr pairs)
)))

(defun CreatePairsArr (range)
(apply 'append 
    (mapcar #'(lambda (a) 
        (mapcar #'(lambda (b) 
            (if (not (>= a b)) 
                (list a b) Nil)) range)) range)))

;; Транспонирование array
(defun transposeArray (arr)
(let* ((size (array-dimensions arr))
    (rows (car size))
    (pairs (DeleteNils (CreatePairsArr (CreateRange rows)))))
(IterateTranspose arr pairs)
))

(defun MapArray (func array &optional (retval (make-array (array-dimensions array))))
  (dotimes (i (array-total-size array) retval)
    (setf (row-major-aref retval i)
          (funcall func (row-major-aref array i)))))

(defun MapTwoArray (func arr1 arr2 &optional (retval (make-array (array-dimensions arr1))))
  (dotimes (i (array-total-size arr1) retval)
    (setf (row-major-aref retval i)
          (funcall func (row-major-aref arr1 i) (row-major-aref arr2 i)))))

(defun ArrConcat (arr1 arr2)
(let* ((dims (array-dimensions arr1))
        (rows (car dims))
        (sq (* 2 rows rows))
        (retval (make-array (list rows (* 2 rows))))) 
    (dotimes (i sq)
            (if (< (mod i (* 2 rows)) rows)
                (setf (row-major-aref retval i) (aref arr1 
                    (first (list (floor (/ i (* 2 rows))))) (mod i rows)))
                (setf (row-major-aref retval i) (aref arr2 
                    (first (list (floor (/ i (* 2 rows))))) (mod i rows)))))
        retval
    )
)

(defun CreateOnesArray (array)
(let* ((dims (array-dimensions array))
        (rows (car dims))
        (retval (make-array (list rows rows)))) 
    (dotimes (i (array-total-size array) retval)
        (if (= (mod i rows) (floor i rows))
            (setf (row-major-aref retval i) 1) T))
    retval
))

(defun CreateGaussArray (array)
(ArrConcat array (CreateOnesArray array)))

(defun FindCoefArray (arr pair)
(let* ((first (aref arr (- (car pair) 1) (- (car pair) 1)))
       (second (aref arr (- (cadr pair) 1) (- (car pair) 1))))
(if (= first 0) 0 (/ second first))))

(defun SubRowsArray (row1 row2 koef)
(MapTwoArray #'(lambda (a b) (- b (* a koef))) row1 row2))

(defun hConcatRows (row1 row2)
(let* ((dims (array-dimensions row1))
        (cols (car dims))
        (sq (* 2 cols))
        (retval (make-array (list 2 cols))))
    
    (dotimes (i sq)
        (if (< i cols)
            (setf (row-major-aref retval i) (aref row1 (mod i cols)))
            (setf (row-major-aref retval i) (aref row2 (mod i cols)))))
    retval
    ) 
)

(defun hConcatArrRow (arr1 arr2)
(let* ((dims (array-dimensions arr1))
        (rows (car dims))
        (cols (cadr dims))
        (sq (* (+ rows 1) cols))
        (retval (make-array (list (+ 1 rows) cols)))) 
    (dotimes (i sq)
            (if (< i (* rows cols))
                (setf (row-major-aref retval i) (aref arr1 (first (list (floor (/ i cols)))) (mod i cols)))
                (setf (row-major-aref retval i) (aref arr2 (mod i cols)))))
        retval
    )    
)

(defun ReplaceRowInArray (array index toReplace)
(let* ((dims (array-dimensions array))
       (rows (car dims))
       (cols (cadr dims))
       (retval (make-array cols)))
    (dotimes (i rows)
        (if (= i 0)
            (if (= i index)
                (setq retval toReplace)
                (setq retval (arraySlice array i)))
        (if (= i 1)
            (if (= index i)
                (setq retval (hConcatRows retval toReplace))
                (setq retval (hConcatRows retval (arraySlice array i))))
            (if (= index i)
                (setq retval (hConcatArrRow retval toReplace))
                (setq retval (hConcatArrRow retval (arraySlice array i)))))))
    retval
    )
)

(defun IterateSubArray (array pair)
(let* ((firstIndex (- (car pair) 1))
       (secondIndex (- (cadr pair) 1))
       (firstRow (arraySlice array firstIndex))
       (secondRow (arraySlice array secondIndex))
       (koef (FindCoefArray array pair))
       (concatString (SubRowsArray firstRow secondRow koef))
       (dims (array-dimensions array))
       (columns (cadr dims))
       (retval (make-array columns)))

    (setq retval (ReplaceRowInArray array secondIndex concatString))
    retval
    )
)

(defun IterateSolveArray (array pairs)
(if (eq pairs Nil) array 
    (IterateSolveArray (IterateSubArray array (car pairs)) (cdr pairs))))


(defun LastDivArray (array)
(let* ((dims (array-dimensions array))
       (rows (car dims))
       (cols (cadr dims))
       (retval (make-array (list rows cols))))
    (dotimes (i rows)
        (if (= (aref array i i) 0)
            (setq retval (ReplaceRowInArray retval i (arraySlice array i)))
            (setq retval (ReplaceRowInArray retval i (MapTwoArray #'/ (arraySlice array i) 
                (make-array cols :initial-element (aref array i i)))))
        )
    )
    retval
))

(defun CreateBackArray (array)
(let* ((dims (array-dimensions array))
       (rows (car dims))
       (cols (cadr dims))
       (hcols (/ cols 2))
       (sq (* rows hcols))
       (retval (make-array (list rows hcols))))
    (dotimes (i sq)
        (setf (row-major-aref retval i) 
            (aref array (first (list (floor (/ i hcols)))) (+ hcols (mod i hcols))))
    )
    retval
))

(defun CreateBackRow (row)
(let* ((dims (array-dimensions row))
       (cols (car dims))
       (hcols (/ cols 2))
       (retval (make-array (list 1 hcols))))
    (dotimes (i hcols)
        (setf (row-major-aref retval i) 
            (aref row (+ hcols i))))
     retval 
    )
)

(defun CheckRowArray (row)
(let* ((dims (array-dimensions row))
       (cols (/ (car dims) 2))
       (result Nil))
    (dotimes (i cols)
        (if (= (aref row i) 0)
            T
            (setq result T)))
        result))

(defun CheckArray (array)
(let* (
       (rows (array-dimension array 0)))
(if (eq (array-rank array) 1)
    (CheckRowArray array)
    (CheckRowArray (arraySlice array (- rows 1)))
)))


(defun FindBackArray (array)
(let* ( (gauss (CreateGaussArray array))
        (pairs (DeleteNils (CreatePairs (CreateRange(car (array-dimensions array))))))
        (back (LastDivArray (IterateSolveArray gauss pairs))))
(if (CheckArray back)
    (if (eq (array-rank back) 1)
        (CreateBackRow back)
        (CreateBackArray back)) Nil)))

(defun DotArrays (arr1 arr2)
    (let* ((first (array-dimensions arr1))
            (second (array-dimensions arr2))
            (M (car first))
            (N (cadr first))
            (L (cadr second))
            (retval (make-array (list M L))))
        (dotimes (i M)
            (dotimes (k L)
                (setf (aref retval i k) 
                    (let* ((result 0))
                        (dotimes (j N)
                            (setq result (+ result (* (aref arr1 i j) (aref arr2 j k))))
                        )
                        result
                    )
                )    
            )
        ) retval
    )
)

(defun SumArrays (arr1 arr2)
    (let* ((first (array-dimensions arr1))
            (M (car first))
            (N (cadr first))
            (retval (make-array (list M N))))
        (dotimes (i M)
            (dotimes (j N)
                (setf (aref retval i j) (+ (aref arr1 i j) (aref arr2 i j))
                )    
            )
        ) retval
    )
)

(defun FindErmitArray (array)
(let* ((Ermit (transposeArray array))
       (Result (MapArray #'conjugate Ermit)))
Result))


(defun FindErmitGoodArray (array)
(if (eq (FindBackArray array) Nil)
    (if (eq (FindBackArray (SumArrays array (FindErmitArray array))) Nil)
        (SumArrays (CreateOnesArray array) (SumArrays array (FindErmitArray array)))
        (SumArrays array (FindErmitArray array)))
    (FindBackArray array)
    )
)

(defun FindSqrtArray (array)
(MapArray #'sqrt array))

(defun FindPolarArray (array)
(let* ((Ermit (FindSqrtArray (DotArrays array (FindErmitArray array)))))
    (if (equal Nil (FindBackArray Ermit))
        (let* ((Ermit (FindErmitGoodArray array))
                (Unit (DotArrays (FindBackArray Ermit) array)))
        (list Ermit Unit))
        (let* ((Ermit (FindSqrtArray (DotArrays array (FindErmitArray array))))
                (Unit (DotArrays (FindBackArray Ermit) array)))
        (list Ermit Unit)))))

(test myTest
    (is (equal '((1 2 3)(4 5 6)(7 8 9)) (TransposeList '((1 4 7)(2 5 8)(3 6 9))))) 
    (is (equal '((1 2 3 4)(4 5 6 7)(7 8 9 10)(11 12 13 14)) (TransposeList '((1 4 7 11)(2 5 8 12)(3 6 9 13)(4 7 10 14))))) 
    (is (equal '((1)) (TransposeList '((1)))))

    (is (equal '((1 2 3 4 5 6)(1 2 3 4 5 6)) (Concat '((1 2 3)(1 2 3)) '((4 5 6)(4 5 6)))))
    (is (equal '((1 2 5 6)(1 2 5 6)) (Concat '((1 2)(1 2)) '((5 6)(5 6)))))

    (is (equal '(1 2 3 4 5) (CreateRange 5)))
    (is (equal '(1 2 3) (CreateRange 3)))    
    (is (equal '(1 2 3 4 5 6 7) (CreateRange 7)))

    (is (equal '(NIL (1 2) (1 3) (2 1) NIL (2 3) (3 1) (3 2) NIL) (CreatePairs '(1 2 3))))
    (is (equal '(NIL (2 4) (2 7) (4 2) NIL (4 7) (7 2) (7 4) NIL) (CreatePairs '(2 4 7))))

    (is (equal '((1 2) (1 3) (2 1) (2 3) (3 1) (3 2)) (DeleteNils '(NIL (1 2) (1 3) (2 1) NIL (2 3) (3 1) (3 2) NIL))))
    (is (equal '((2 4) (2 7) (4 2) (4 7) (7 2) (7 4)) (DeleteNils '(NIL (2 4) (2 7) (4 2) NIL (4 7) (7 2) (7 4) NIL))))

    (is (equal '((1 2) (1 3) (2 1) (2 3) (3 1) (3 2)) (CreateSeq '((1 2 3)(4 5 6)(7 8 9)))))
    (is (equal '((1 2) (1 3) (2 1) (2 3) (3 1) (3 2)) (CreateSeq '((11 12 3)(41 53 63)(78 82 19)))))
    (is (equal '((1 2) (1 3) (1 4) (2 1) (2 3) (2 4) (3 1) (3 2) (3 4) (4 1) (4 2) (4 3)) 
        (CreateSeq '((1 2 3 4)(5 6 7 8)(9 10 11 12)(13 14 15 16)))))

    (is (equal '((0 0 0)(0 0 0)(0 0 0)) (CreateNullMatrix 3)))
    (is (equal '((0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)) (CreateNullMatrix 5)))
    (is (equal '((0)) (CreateNullMatrix 1)))

    (is (equal '(1 2 3 11 5)  (ReplaceElByIndex '(1 2 3 4 5) 3 11)))
    (is (equal '(1 2 3 11 12)  (ReplaceElByIndex '(1 2 3 11 5) 4 12)))
    (is (equal '(0 2 3 4 5)  (ReplaceElByIndex '(1 2 3 4 5) 0 0)))

    (is (equal '((1 0 0)(0 1 0)(0 0 1)) (CreateOnesMatrix '((0 0 0)(0 0 0)(0 0 0)))))
    (is (equal '((1 0 0 0 0)(0 1 0 0 0)(0 0 1 0 0)(0 0 0 1 0)(0 0 0 0 1)) 
            (CreateOnesMatrix '((0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)(0 0 0 0 0)))))
    (is (equal '((1)) (CreateOnesMatrix '((0)))))

    (is (equal '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) (CreateMatrixToGauss '((1 2 3)(4 5 6)(7 8 9)))))
    (is (equal '((1 2 3 4 1 0 0 0)(5 6 7 8 0 1 0 0)(9 10 11 12 0 0 1 0)(13 14 15 16 0 0 0 1)) 
                (CreateMatrixToGauss '((1 2 3 4)(5 6 7 8)(9 10 11 12)(13 14 15 16)))))
    (is (equal '((1 1)) (CreateMatrixToGauss '((1)))))

    (is (equal 4 (FindCoef '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(1 2))))
    (is (equal (/ 8 5) (FindCoef '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(2 3))))
    (is (equal 7 (FindCoef '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(1 3))))
    (is (equal (/ 2 5) (FindCoef '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(2 1))))

    (is (equal '(0 -3 -6) (subRows '(1 2 3) '(4 5 6) 4)))
    (is (equal '(2 1 0) (subRows '(1 2 3) '(4 5 6) 2)))
    (is (equal '(4 5 6) (subRows '(1 2 3) '(4 5 6) 0)))

    (is (equal '((1 2 3 1 0 0) (0 -3 -6 -4 1 0) (7 8 9 0 0 1)) (IterateOfSubs '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(1 2))))
    (is (equal '((-3/5 0 3/5 1 -2/5 0) (4 5 6 0 1 0) (7 8 9 0 0 1)) (IterateOfSubs '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(2 1))))
    (is (equal '((1 2 3 1 0 0) (-2/3 -1/3 0 0 1 -2/3) (7 8 9 0 0 1)) (IterateOfSubs '((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(3 2))))

    (is (equal '((1 0 0 -16 20 -9) (0 -1 0 -10 13 -6) (0 0 -1 1 -2 1)) 
        (IterateSolve '((1 2 3 1 0 0)(4 7 6 0 1 0)(7 12 8 0 0 1)) '((1 2) (1 3) (2 1) (2 3) (3 1) (3 2)))))
    (is (equal '((1 0 0 71/116 7/58 -27/116) (0 -5 0 405/116 -5/58 -105/116) (0 0 -116/5 -69/5 6/5 1))
        (IterateSolve '((1 2 3 1 0 0)(9 13 6 0 1 0)(3 12 11 0 0 1)) '((1 2) (1 3) (2 1) (2 3) (3 1) (3 2)))))
    
    (is (equal '((1 0 0 -16 20 -9)(0 1 0 10 -13 6)(0 0 1 -1 2 -1))
        (LastSub '((1 0 0 -16 20 -9) (0 -1 0 -10 13 -6) (0 0 -1 1 -2 1)) (CreateRange 3))))
    (is (equal '((1 0 0 71/116 7/58 -27/116) (0 1 0 -81/116 1/58 21/116) (0 0 1 69/116 -3/58 -5/116))
        (LastSub '((1 0 0 71/116 7/58 -27/116) (0 -5 0 405/116 -5/58 -105/116) (0 0 -116/5 -69/5 6/5 1)) (CreateRange 3))))

    (is (equal '(4 5 6) (BackRow '(1 2 3 4 5 6) 3)))
    (is (equal '(9) (BackRow '(7 8 9) 1)))

    (is (equal T (checkRow '(7 8 9) 3)))
    (is (equal T (checkRow '(7 0 9) 3)))
    (is (equal T (checkRow '(0 8 0) 3)))
    (is (equal Nil (checkRow '(0 0 0) 3)))
    (is (equal Nil (checkRow '(0 0 0) 1)))
    (is (equal T (checkRow '(0 0 1) 3)))
    (is (equal Nil (checkRow '(0 0 1) 1)))

    (is (equal T (checkMatrix '((1 2 3)(4 5 6)(7 8 9)))))
    (is (equal T (checkMatrix '((1 2 3)(0 0 0)(7 8 9)))))
    (is (equal Nil (checkMatrix '((1 2 3)(4 5 6)(0 0 0)))))

    (is (equal '((4/13 -9/13 5/13)
                (-24/13 15/13 -4/13)
                (19/13 -7/13 1/13)) (FindBackMatrix '((1 2 3)(4 7 8)(9 11 12)))))
    (is (equal '((1 0 0) (0 1 0) (0 0 1)) (FindBackMatrix '((1 0 0)(0 1 0)(0 0 1)))))
    (is (equal '((-7 2)(4 -1)) (FindBackMatrix '((1 2)(4 7)))))
    (is (equal '((1)) (FindBackMatrix '((1)))))
    (is (equal '((1/2)) (FindBackMatrix '((2)))))
    (is (equal Nil (FindBackMatrix '((1 2 3)(4 5 6)(7 8 9)))))

    (is (equal '((30 36 42) (66 81 96) (102 126 150)) (DotMatrix '((1 2 3)(4 5 6)(7 8 9)) '((1 2 3)(4 5 6)(7 8 9)))))
    (is (equal '((72 90 108 155) (110 145 180 282) (121 164 207 297) (148 194 240 359)) 
                (DotMatrix '((5 4 7 2)(11 13 6 5)(7 8 9 19)(13 12 11 10)) 
                           '((1 2 3 6)(4 5 6 10)(7 8 9 11)(1 2 3 4)))))
    (is (equal '((1 0 0) (0 1 0) (0 0 1)) (DotMatrix '((1 0 0)(0 1 0)(0 0 1)) '((1 0 0)(0 1 0)(0 0 1)))))
    (is (equal '((1 2 3) (4 5 6) (7 8 9)) (DotMatrix '((1 2 3)(4 5 6)(7 8 9)) '((1 0 0)(0 1 0)(0 0 1)))))
    (is (equal '((1 2 3) (4 5 6) (7 8 9)) (DotMatrix '((1 0 0)(0 1 0)(0 0 1)) '((1 2 3)(4 5 6)(7 8 9)))))
    (is (equal '((95 19)(275 81)) (DotMatrix '((1 3 5)(7 11 13)) '((2 5)(6 3)(15 1)))))
    (is (equal '((2)) (DotMatrix '((1)) '((2)))))

    (is (equal '((2 3 4)(6 7 8)(10 11 12)) (SumMatrix '((1 2 3)(4 5 6)(7 8 9)) '((1 1 1)(2 2 2)(3 3 3)))))
    (is (equal '((1 2 3)(4 5 6)(6 7 8)) (SumMatrix '((1 2 3)(4 5 6)(7 8 9)) '((0 0 0)(0 0 0)(-1 -1 -1)))))
    (is (equal '((0)) (SumMatrix '((0)) '((0)))))

    (is (equal '((1.0 2.0)(5.0 4.0)) (FindSqrt '((1 4)(25 16)))))
    (is (equal '((1.0 #C(0.0 2.0)) (1.4142135 #C(0.0 4.1231055))) (FindSqrt '((1 -4)(2 -17)))))

    (is (equal '((1 -4 #C(-7 -2)) (2 5 8) (#C(0 -3) #C(-6 2) -9)) (FindErmitMatrix '((1 #C(2 0) #C(0 3))(-4 5 #C(-6 -2))(#C(-7 2) 8 -9)))))
    (is (equal '((1 4 7)(2 5 8)(3 6 9)) (FindErmitMatrix '((1 2 3)(4 5 6)(7 8 9)))))

    (is (equal '(((5.0 0.0) (0.0 5.0)) ((#C(0.8 0.0) #C(0.0 -0.6)) (#C(0.0 -0.6) #C(0.8 0.0)))) (FindPolar '((4 #C(0 -3))(#C(0 -3) 4)))))
    (is (equal '(((7.071068 #C(0.0 7.071068)) (#C(0.0 7.071068) 7.071068)) ((#C(-0.07071068 -0.07071068) #C(-0.49497476 -0.49497476))
                (#C(0.07071068 0.07071068) #C(0.49497476 0.49497476)))) (FindPolar '((-1 -7)(1 7)))))
    (is (equal '(((0.0 0.0 0.0) (0.0 0.0 0.0) (0.0 0.0 0.0)) ((0 0 0) (0 0 0) (0 0 0))) (FindPolar '((0 0 0)(0 0 0)(0 0 0)))))
    (is (equal '(((1.0)) ((1.0))) (FindPolar '((1)))))
    (is (equal '(((2.0)) ((1.0))) (FindPolar '((2)))))

    ;; Тестирование для array
    (is (equalp #2A((0 0) (0 0)) (CreateNullMatrixArray #2A((0 0)(1 1)))))
    (is (equalp #2A((0 0 0) (0 0 0)(0 0 0)) (CreateNullMatrixArray #2A((1 2 3)(4 5 6)(7 8 9)))))

    (is (equalp #(1 2 3 11 5) (ReplaceElByIndexArr #(1 2 3 4 5) 3 11)))
    (is (equalp #(1 2 3 4 11) (ReplaceElByIndexArr #(1 2 3 4 5) 4 11)))
    (is (equalp #(11 2 3 4 5) (ReplaceElByIndexArr #(1 2 3 4 5) 0 11)))

    (is (equalp #(4 5 6) (arraySlice #2A((1 2 3)(4 5 6)(7 8 9)) 1)))
    (is (equalp #(1 2 3) (arraySlice #2A((1 2 3)(4 5 6)(7 8 9)) 0)))
    (is (equalp #(4 5 6 7) (arraySlice #2A((1 2 3 4)(4 5 6 7)(7 8 9 10)(1 1 1 1)) 1)))

    (is (equalp #2A((1 2 3)(4 5 11)(7 8 9)) (ReplaceIn #2A((1 2 3)(4 5 6)(7 8 9)) 1 2 11)))
    (is (equalp #2A((1 2 3)(4 5 6)(11 8 9)) (ReplaceIn #2A((1 2 3)(4 5 6)(7 8 9)) 2 0 11)))
    (is (equalp #2A((1 2 3)(4 11 6)(7 8 9)) (ReplaceIn #2A((1 2 3)(4 5 6)(7 8 9)) 1 1 11)))

    (is (equalp #2A((1 2 3)(4 5 8)(7 6 9)) (SwapElems #2A((1 2 3)(4 5 6)(7 8 9)) 1 2)))
    (is (equalp #2A((1 2 7)(4 5 6)(3 8 9)) (SwapElems #2A((1 2 3)(4 5 6)(7 8 9)) 2 0)))
    (is (equalp #2A((1 2 3)(4 5 6)(7 8 9)) (SwapElems #2A((1 2 3)(4 5 6)(7 8 9)) 1 1)))

    (is (equalp #2A((1 4 7)(2 5 8)(3 6 9)) (transposeArray #2A((1 2 3)(4 5 6)(7 8 9)))))
    (is (equalp #2A((1 5 9 13)(2 6 10 14)(3 7 11 15)(4 8 12 16)) (transposeArray #2A((1 2 3 4)(5 6 7 8)(9 10 11 12)(13 14 15 16)))))
    (is (equalp #2A((1)) (transposeArray #2A((1)))))

    (is (equalp #2A((1 2)(4 5)) (MapArray #'sqrt #2A((1 4)(16 25)))))
    (is (equalp #2A((2 8)(32 50)) (MapTwoArray  #'+ #2A((1 4)(16 25)) #2A((1 4)(16 25)))))
    (is (equalp #2A((0 0)(0 0)) (MapTwoArray  #'- #2A((1 4)(16 25)) #2A((1 4)(16 25)))))

    (is (equalp #2A((1 2 3 4)(3 5 5 6)) (ArrConcat #2A((1 2)(3 5)) #2A((3 4)(5 6)))))
    (is (equalp #2A((1 2 3 1 3 4)(3 5 3 1 5 6)(1 2 3 1 7 8)) 
        (ArrConcat #2A((1 2 3)(3 5 3)(1 2 3)) #2A((1 3 4)(1 5 6)(1 7 8)))))
    (is (equalp #2A((1 3)) (ArrConcat #2A((1)) #2A((3)))))

    (is (equalp #2A((1 0 0)(0 1 0)(0 0 1)) (CreateOnesArray #2A((1 2 3)(4 5 6)(7 8 9)))))
    (is (equalp #2A((1 0 0)(0 1 0)(0 0 1)) (CreateOnesArray #2A((0 0 0)(0 0 0)(0 0 0)))))
    (is (equalp #2A((1)) (CreateOnesArray #2A((2)))))

    (is (equalp #2A((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) (CreateGaussArray #2A((1 2 3)(4 5 6)(7 8 9)))))
    (is (equalp #2A((4 5 6 1 0 0)(1 1 1 0 1 0)(1 1 1 0 0 1)) (CreateGaussArray #2A((4 5 6)(1 1 1)(1 1 1)))))
    (is (equalp #2A((1 1)) (CreateGaussArray #2A((1)))))

    (is (equalp 4 (FindCoefArray #2A((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(1 2))))
    (is (equalp (/ 8 5) (FindCoefArray #2A((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(2 3))))
    (is (equalp 7 (FindCoefArray #2A((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(1 3))))
    (is (equalp (/ 2 5) (FindCoefArray #2A((1 2 3 1 0 0)(4 5 6 0 1 0)(7 8 9 0 0 1)) '(2 1))))

    (is (equalp #(0 -3 -6) (SubRowsArray #(1 2 3) #(4 5 6) 4)))
    (is (equalp #(2 1 0) (SubRowsArray #(1 2 3) #(4 5 6) 2)))
    (is (equalp #(4 5 6) (SubRowsArray #(1 2 3) #(4 5 6) 0)))

    (is (equalp #2A((1 2 3)(4 5 6)) (hConcatRows #(1 2 3) #(4 5 6))))
    (is (equalp #2A((1 2 3 1 1 1)(4 5 6 1 1 1)) (hConcatRows #(1 2 3 1 1 1) #(4 5 6 1 1 1))))
    (is (equalp #2A((1 2 3 0)(4 5 6 0)) (hConcatRows #(1 2 3 0) #(4 5 6 0))))

    (is (equalp #2A((1 2 3)(4 5 6)(7 8 9)(10 11 12)) (hConcatArrRow #2A((1 2 3)(4 5 6)(7 8 9)) #(10 11 12))))
    (is (equalp #2A((1 2 3)(0 0 0)) (hConcatArrRow #2A((1 2 3)) #(0 0 0))))

    (is (equalp #2A((1 2 3)(10 11 12)(7 8 9)) (ReplaceRowInArray #2A((1 2 3)(4 5 6)(7 8 9)) 1 #(10 11 12))))
    (is (equalp #2A((10 11 12)(4 5 6)(7 8 9)) (ReplaceRowInArray #2A((1 2 3)(4 5 6)(7 8 9)) 0 #(10 11 12))))

    (is (equalp #2A((1 2 3) (0 -3 -6) (7 8 9)) (IterateSubArray #2A((1 2 3)(4 5 6)(7 8 9)) '(1 2))))
    (is (equalp #2A((-3/5 0 3/5) (4 5 6) (7 8 9)) (IterateSubArray #2A((1 2 3)(4 5 6)(7 8 9)) '(2 1))))
    (is (equalp #2A((1 2 3)(10 11 12)(7 8 9)) (ReplaceRowInArray #2A((1 2 3)(4 5 6)(7 8 9)) 1 #(10 11 12))))
    (is (equalp #2A((10 11 12)(4 5 6)(7 8 9)) (ReplaceRowInArray #2A((1 2 3)(4 5 6)(7 8 9)) 0 #(10 11 12))))

    (is (equal T (CheckArray #2A((1 2 3 1 2 3)(4 5 6 1 2 3)(7 8 9 1 2 3)))))
    (is (equal T (CheckArray #2A((1 2 3 2)(0 1 0 1)))))
    (is (equal Nil (CheckArray #2A((1 2 3 1 1 1)(4 5 6 2 1 3)(0 0 0 1 1 2)))))

    (is (equal T (CheckRowArray #(7 8 9 1))))
    (is (equal T (CheckRowArray #(7 0 9 2))))
    (is (equal T (CheckRowArray #(0 8 0 2))))
    (is (equal Nil (CheckRowArray #(0 0 0 0))))
    (is (equal Nil (CheckRowArray #(0 0))))
    (is (equal T (CheckRowArray #(0 1 0 0))))

    (is (equalp #2A((1 0 0 -16 20 -9)(0 1 0 10 -13 6)(0 0 1 -1 2 -1))
        (LastDivArray #2A((1 0 0 -16 20 -9) (0 -1 0 -10 13 -6) (0 0 -1 1 -2 1)))))
    (is (equalp #2A((1 0 0 71/116 7/58 -27/116) (0 1 0 -81/116 1/58 21/116) (0 0 1 69/116 -3/58 -5/116))
        (LastDivArray #2A((1 0 0 71/116 7/58 -27/116) (0 -5 0 405/116 -5/58 -105/116) (0 0 -116/5 -69/5 6/5 1)))))

    (is (equalp #2A((4/13 -9/13 5/13)
                (-24/13 15/13 -4/13)
                (19/13 -7/13 1/13)) (FindBackArray #2A((1 2 3)(4 7 8)(9 11 12)))))
    (is (equalp #2A((1 0 0) (0 1 0) (0 0 1)) (FindBackArray #2A((1 0 0)(0 1 0)(0 0 1)))))
    (is (equalp #2A((-7 2)(4 -1)) (FindBackArray #2A((1 2)(4 7)))))
    (is (equalp #2A((1)) (FindBackArray #2A((1)))))
    (is (equalp #2A((1/2)) (FindBackArray #2A((2)))))
    (is (equal Nil (FindBackArray #2A((1 2 3)(4 5 6)(7 8 9)))))

    (is (equalp #2A((30 36 42) (66 81 96) (102 126 150)) (DotArrays #2A((1 2 3)(4 5 6)(7 8 9)) #2A((1 2 3)(4 5 6)(7 8 9)))))
    (is (equalp #2A((72 90 108 155) (110 145 180 282) (121 164 207 297) (148 194 240 359)) 
                (DotArrays #2A((5 4 7 2)(11 13 6 5)(7 8 9 19)(13 12 11 10)) 
                           #2A((1 2 3 6)(4 5 6 10)(7 8 9 11)(1 2 3 4)))))
    (is (equalp #2A((1 0 0) (0 1 0) (0 0 1)) (DotArrays #2A((1 0 0)(0 1 0)(0 0 1)) #2A((1 0 0)(0 1 0)(0 0 1)))))
    (is (equalp #2A((1 2 3) (4 5 6) (7 8 9)) (DotArrays #2a((1 2 3)(4 5 6)(7 8 9)) #2A((1 0 0)(0 1 0)(0 0 1)))))
    (is (equalp #2A((1 2 3) (4 5 6) (7 8 9)) (DotArrays #2A((1 0 0)(0 1 0)(0 0 1)) #2A((1 2 3)(4 5 6)(7 8 9)))))
    (is (equalp #2A((95 19)(275 81)) (DotArrays #2A((1 3 5)(7 11 13)) #2A((2 5)(6 3)(15 1)))))
    (is (equalp #2a((2)) (DotArrays #2A((1)) #2A((2)))))

    (is (equalp #2A((1 -4 #C(-7 -2)) (2 5 8) (#C(0 -3) #C(-6 2) -9)) (FindErmitArray #2A((1 #C(2 0) #C(0 3))(-4 5 #C(-6 -2))(#C(-7 2) 8 -9)))))
    (is (equalp #2A((1 4 7)(2 5 8)(3 6 9)) (FindErmitArray #2A((1 2 3)(4 5 6)(7 8 9)))))

    (is (equalp #2A((2 3 4)(6 7 8)(10 11 12)) (SumArrays #2A((1 2 3)(4 5 6)(7 8 9)) #2A((1 1 1)(2 2 2)(3 3 3)))))
    (is (equalp #2A((1 2 3)(4 5 6)(6 7 8)) (SumArrays #2A((1 2 3)(4 5 6)(7 8 9)) #2A((0 0 0)(0 0 0)(-1 -1 -1)))))
    (is (equalp #2A((0)) (SumArrays #2A((0)) #2A((0)))))

    (is (equalp #2A((5.0 0.0) (0.0 5.0)) (car (FindPolarArray #2A((4 #C(0 -3))(#C(0 -3) 4))))))
    (is (equalp #2A((#C(0.8 0.0) #C(0.0 -0.6)) (#C(0.0 -0.6) #C(0.8 0.0))) (cadr (FindPolarArray #2A((4 #C(0 -3))(#C(0 -3) 4))))))
    (is (equalp #2A((3.8729835 2.828427) (5.2915025 4.7958317)) (car (FindPolarArray #2A((1 2)(7 3))))))
    (is (equalp #2A((-4.158825 0.3066852) (6.0482593 0.28716063)) (cadr (FindPolarArray #2A((1 2)(7 3))))))
    (is (equalp #2A((1 0 0) (0 1 0) (0 0 1)) (car (FindPolarArray #2A((0 0 0)(0 0 0)(0 0 0))))))
    (is (equalp #2A((0 0 0) (0 0 0) (0 0 0)) (cadr (FindPolarArray #2A((0 0 0)(0 0 0)(0 0 0))))))
    (is (equalp #2A((1.0)) (car (FindPolarArray #2A((1))))))
    (is (equalp #2A((1.0)) (cadr (FindPolarArray #2A((1))))))
    (is (equalp #2A((2.0)) (car (FindPolarArray #2A((2))))))
    (is (equalp #2A((1.0)) (cadr (FindPolarArray #2A((2))))))
)
(run! 'myTest)

; sbcl --load "/home/prianechka/defend/lab5/main.lsp"
; (in-package :it.bese.FiveAM.example)