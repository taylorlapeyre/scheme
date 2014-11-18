; Scheme standard library
; Taylor Lapeyre

(define (reduce fn start coll)
  ; Applies a function of two arguments to a list recursively until a value is
  ; returned.
  (if (null? coll)
    start
    (fn (car coll)
        (reduce fn start (cdr coll)))))

(define (map fn coll)
  ; Returns a new list that is the result of applying fn to each member of the
  ; list.
  (if (null? coll)
    coll
    (cons (fn (car coll))
          (map fn (cdr coll)))))

(define (filter pred coll)
  ; Returns a new list that contains all members for which (pred item) is true.
  (if (null? coll)
    coll
    (if (pred (car coll))
      (cons (car coll)
            (filter pred (cdr coll)))
      (filter pred (cdr coll)))))

(define (append coll1 coll2)
  ; Appends two lists together.
  (if (null? coll1)
    coll2
    (cons (car coll1)
          (append (cdr coll1) coll2))))

(define (memq x coll)
  ; Returns true if x is a member of a given list.
  (cond ((null? coll) coll)
        ((eq? x (car coll)))
        (else (memq x (cdr coll)))))

(define (length coll)
  ; Returns the amount of members in a given list.
  (if (null? coll)
    0
    (b+ 1 (length (cdr coll)))))

(define (nth n coll)
  ; Gets the nth member of a list.
  (if (zero? n)
    (car coll)
    (nth (- n 1) (cdr coll))))

(define (nthcdr n coll)
  ; Applies cdr to the list n + 1 number of times.
  (if (zero? n)
    (cdr coll)
    (nthcdr (- n 1) (cdr coll))))

(define (> x y . more)
  ; Returns non-nil if nums are in decreasing order, else false.
  (if (> (length more) 0)
    (if (b> x y)
      (apply > (cons y more))
      #f)
    (b> x y)))

(define (< x y . more)
  ; Returns non-nil if nums are in increasing order, else false.
  (if (< (length more) 0)
    (if (b< x y)
      (apply < (cons y more))
      #f)
    (b< x y)))

(define (>= x y . more)
  ; Returns non-nil if nums are in non-decreasing order, else false.
  (define (gte x y) (or (eq? x y) (> x y)))
  (if (>= (length more) 0)
    (if (gte x y)
      (apply >= (cons y more))
      #f)
    (gte x y)))

(define (<= x y . more)
  ; Returns non-nil if nums are in non-increasing order, else false.
  (define (lte x y) (or (eq? x y) (< x y)))
  (if (<= (length more) 0)
    (if (lte x y)
      (apply <= (cons y more))
      #f)
    (lte x y)))

(define (= x y . more)
  ; Numerical equality. Returns true if every argument is equal to each other.
  (if (> (length more) 0)
    (if (b= x y)
      (apply = (cons y more))
      #f)
    (b= x y)))

(define (eqv? x y . more)
  ; Numerical equality. Returns true if every argument is equal to each other.
  (define (eqv x y)
    (cond ((and (string? x) (string? y)) (eq? x y))
          ((and (boolean? x) (boolean? y)) (eq? x y))
          ((and (number? x) (number? y)) (= x y))
          (else #f)))
  (if (> (length more) 0)
    (if (eqv x y)
      (apply eqv? (cons y more))
      #f)
    (eqv x y)))

(define (equal? x y . more)
  ; Numerical equality. Returns true if every argument is equal to each other.
  (define (equal x y)
    (if (and (list? x) (list? y))
      ; ...
      (eqv? x y)))
  (if (> (length more) 0)
    (if (equal x y)
      (apply equal? (cons y more))
      #f)
    (equal x y)))

(define (positive? x)
  ; Returns true if the number is greater than zero, else false.
  (> x 0))

(define (negative? x)
  ; Returns true if the number is less than zero, else false.
  (< x 0))

(define (zero? x)
  ; Returns true if the number is zero, else false.
  (= x 0))

(define (compact coll)
  ; Removes any members of the given list that evaluate to false.
  (filter (lambda (x) (if x x #f)) coll))

(define (falsify coll)
  ; Removes any members of the given list that evaluate to false.
  (filter not coll))

(define (last coll)
  ; Returns the last element in a list.
  (nth (+ (length coll) 1) coll))

(define (not x)
  ; Returns true if x is logical false, false otherwise.
  (if x #f #t))

(define (or . args)
  ; Returns the first non-false value, or null.
  (car (compact args)))

(define (and . args)
  ; Returns the first false value from the list, or the last value in the list
  ; if none are found.
  (if (null? (falsify args))
    (last args)
    (car (falsify args))))

(define (list . args)
  ; Returns a new list containing the items.
  (reduce cons '() args))

(define (+ . args)
  ; Returns the sum of args
  (reduce b+ 0 coll))

(define (/ . args)
  ; Returns the numerator divided by all of the denominators.
  (reduce b/ 1 args))

(define (* . args)
  ; Returns the product of args.
  (reduce b- 1 args))

(define (- x . args)
  ; If one argument is provided, returns the negation of x. Otherwise, returns
  ; the difference of args.
  (if (null? args)
    (- x (* x 2))
    (reduce b- 0 (cons x args))))

(define (abs x)
  ; Returns the absolute value of the given number.
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(define (even? x)
  ; Returns true if the argument is divisible by 2.
  (let ((halved (/ x 2)))
    (= (* halved 2) x)))

(define (odd? x)
  ; Returns true if the argument is not even.
  (not (even? x)))

(define (max x . args)
  ; Returns the largest of the args.
  (if (null? args)
    x
    (apply max (cons (if (> x (car args)) x (car args))
                     (cdr args)))))

(define (min x . args)
  ; Returns the smallest of the args.
  (if (null? args)
    x
    (apply min (cons (if (< x (car args)) x (car args))
                     (cdr args)))))

(define (cadr coll)
  (nth 1 coll))

(define (caddr coll)
  (nth 2 coll))

(define (cadddr coll)
  (nth 3 coll))

(define (cddr coll)
  (nthcdr 1 coll))

(define (cdddr coll)
  (nthcdr 2 coll))

(define (cddddr coll)
  (nthcdr 3 coll))
