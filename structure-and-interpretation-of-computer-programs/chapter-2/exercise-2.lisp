;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.1
;; ------------

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

(define (numer rat)
  (car rat))

(define (denom rat)
  (cdr rat))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(define (make-rat n d)
  (let (
    (abs-n (abs n))
    (abs-d (abs d))
    (s (* (sgn n) (sgn d))))
    (let ((g (gcd abs-n abs-d)))
      (cons (* s (/ abs-n g)) (/ abs-d g)))))

(print-rat (make-rat  4  6))
(print-rat (make-rat -4  6))
(print-rat (make-rat  4 -6))
(print-rat (make-rat -4 -6))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.2
;; ------------

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-point x y)
  (cons x y))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (make-segment point-1 point-2)
  (cons point-1 point-2))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

(define (midpoint segment) 
  (define (average x y) 
    (/ (+ x y) 2))
  (let (
    (point-1 (start-segment segment))
    (point-2 (end-segment segment)))
    (make-point 
      (average (x-point point-1) (x-point point-2))
      (average (y-point point-1) (y-point point-2)))))

(print-point 
  (midpoint 
    (make-segment 
      (make-point 2 3)
      (make-point 4 5))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.3
;; ------------
;;

; procedures:

(define (rectangle-perimeter rectangle)
  (+
    (* 2 (rectangle-width  rectangle))
    (* 2 (rectangle-height rectangle))))

(define (rectangle-area rectangle)
  (*
    (rectangle-width  rectangle)
    (rectangle-height rectangle)))

; first representation:

(define (make-dimensions width height)
  (cons width height))

(define (make-point x y)
  (cons x y))

(define (dimensions-width dimensions)
  (car dimensions))

(define (dimensions-height dimensions)
  (cdr dimensions))

(define (make-rectangle upper-left-corner dimensions)
  (cons upper-left-corner dimensions))

(define (rectangle-dimensions rectangle)
  (cdr rectangle))

(define (rectangle-height rectangle)
  (dimensions-width (rectangle-dimensions rectangle)))

(define (rectangle-width rectangle)
  (dimensions-height (rectangle-dimensions rectangle)))

(rectangle-area 
  (make-rectangle 
    (make-point 0 0)
    (make-dimensions 4 2)))

(rectangle-perimeter 
  (make-rectangle 
    (make-point 0 0)
    (make-dimensions 4 2)))


; second:

(define (make-point x y)
  (cons x y))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (make-rectangle upper-left-corner lower-right-corner)
  (cons upper-left-corner lower-right-corner))

(define (rectangle-upper-left-corner rectangle)
  (car rectangle))

(define (rectangle-lower-right-corner rectangle)
  (cdr rectangle))

(define (rectangle-width rectangle)
  (- 
    (x-point (rectangle-lower-right-corner rectangle))
    (x-point (rectangle-upper-left-corner rectangle))))

(define (rectangle-height rectangle)
  (- 
    (y-point (rectangle-upper-left-corner rectangle))
    (y-point (rectangle-lower-right-corner rectangle))))

(rectangle-area 
  (make-rectangle 
    (make-point 0 0)
    (make-point 4 -2)))

(rectangle-perimeter 
  (make-rectangle 
    (make-point 0 0)
    (make-point 4 -2)))

; test

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.4
;; ------------

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(car (cons x y))
(car (lambda (m) (m x y)))
((lambda (m) (m x y)) (lambda (p q) p))
((lambda (p q) p) x y)
x

(define (cdr z)
  (z (lambda (p q) q)))

(cdr (cons 'x 'y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.5
;; ------------

(define (cons a b) 
  (* (expt 2 a) 
     (expt 3 b)))

(cons 4 5)

(define (dividable? a x)
  (= (remainder a x) 0))

(define (factor-count n f)
  (define (helper n acc)
    (if (dividable? n f)
      (helper (/ n f) (+ 1 acc))
      acc))
  (helper n 0))

(define (car z)
  (factor-count z 2))

(define (cdr z)
  (factor-count z 3))

(car (cons 4 5))
(cdr (cons 4 5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.6
;; ------------


(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))


(add-1 zero)
(lambda (f) (lambda (x) (f ((zero f) x))))
(lambda (f) (lambda (x) (f (((lambda (g) (lambda (y) y)) f) x))))
(lambda (f) (lambda (x) (f (((lambda (y) y)) x))))

(define one (lambda (f) (lambda (x) (f x))))

(add-1 one)
(lambda (f) (lambda (x) (f ((one f) x))))
(lambda (f) (lambda (x) (f (((lambda (g) (lambda (y) (g y))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (y) (f y)) x))))

(define two (lambda (f) (lambda (x) (f (f x)))))

; When we add two church numerals we need to replace the 'x' from the first
; number with f (f (...  ; (x)...))) from the second

(define (add a b)
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x)))))

(define (church->int church)
  ((church (lambda (x) (+ x 1))) 0))

(church->int two)

(add two two)

(church->int (add two two))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.7
;; ------------

(define (make-interval a b) 
  (cons a b))

(define (upper-bound interval)
  (cdr interval))

(define (lower-bound interval)
  (car interval))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.8
;; ------------

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.9
;; ------------
;;
;; See exercise-2.09.{tex,pdf}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.10
;; -------------

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))


(define (div-interval x y)
  (if (or (= (upper-bound y) 0) 
      (= (lower-bound y) 0))
    (error "dividing by interval that spans 0 is undefined")
    (mul-interval x
                  (make-interval (/ 1.0 (upper-bound y))
                                 (/ 1.0 (lower-bound y))))))

; happy path
(div-interval (make-interval 2 3) (make-interval 3 4))
(div-interval (make-interval 0 3) (make-interval 3 4))
(div-interval (make-interval 2 0) (make-interval 3 4))

; errors:
(div-interval (make-interval 2 0) (make-interval 0 4))
(div-interval (make-interval 2 0) (make-interval 3 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.11
;; -------------


(define (old-mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (mul-interval x y)
  (define both-positive-or-0  1)
  (define both-negative      -1)
  (define different           0)
  (define (interval-type i) 
    (let ((a (lower-bound i))
          (b (upper-bound i)))
      (cond ((and (>= a 0) (>= b 0)) both-positive-or-0)
            ((and (<  a 0) (<  b 0)) both-negative)
            (else                  different))))
  (let ((x-type (interval-type x))
        (y-type (interval-type y))
        (a (lower-bound x))
        (b (upper-bound x))
        (c (lower-bound y))
        (d (upper-bound y)))
    (cond 
          ((and (= x-type both-positive-or-0) (= y-type both-positive-or-0))  (make-interval (* a c) (* b d)))
          ((and (= x-type both-positive-or-0) (= y-type both-negative))      (make-interval (* b d) (* a c)))
          ((and (= x-type both-positive-or-0) (= y-type different))           (make-interval (* b c) (* b d)))
          ;
          ((and (= x-type both-negative) (= y-type both-positive-or-0))  (make-interval (* a d) (* b c)))
          ((and (= x-type both-negative) (= y-type both-negative))       (make-interval (* b d) (* a c)))
          ((and (= x-type both-negative) (= y-type different))           (make-interval (* a d) (* a c)))
          ;
          ((and (= x-type different) (= y-type both-positive-or-0)) (make-interval (* a d) (* b d)))
          ((and (= x-type different) (= y-type both-negative))      (make-interval (* b c) (* a d)))
          ((and (= x-type different) (= y-type different))
            (make-interval (min (* a d) (* b c)) (max (* a c) (* b d))))
          (else (error "assertion failed")))))

(define (check-mul a b c d)
  (let ((x (make-interval a b))
        (y (make-interval c d)))
    (let ((old-result (old-mul-interval x y))
          (new-result (mul-interval x y)))
    (and 
      (= (lower-bound old-result) (lower-bound new-result))
      (= (upper-bound old-result) (upper-bound new-result))))))

(and 
  (check-mul -1  -1  -1  -1)
  (check-mul -1  -1  -1   0)
  (check-mul -1  -1  -1   1)
  (check-mul -1  -1   0   0)
  (check-mul -1  -1   0   1)
  (check-mul -1  -1   1   1)
  (check-mul -1   0  -1  -1)
  (check-mul -1   0  -1   0)
  (check-mul -1   0  -1   1)
  (check-mul -1   0   0   0)
  (check-mul -1   0   0   1)
  (check-mul -1   0   1   1)
  (check-mul -1   1  -1  -1)
  (check-mul -1   1  -1   0)
  (check-mul -1   1  -1   1)
  (check-mul -1   1   0   0)
  (check-mul -1   1   0   1)
  (check-mul -1   1   1   1)
  (check-mul  0   0  -1  -1)
  (check-mul  0   0  -1   0)
  (check-mul  0   0  -1   1)
  (check-mul  0   0   0   0)
  (check-mul  0   0   0   1)
  (check-mul  0   0   1   1)
  (check-mul  0   1  -1  -1)
  (check-mul  0   1  -1   0)
  (check-mul  0   1  -1   1)
  (check-mul  0   1   0   0)
  (check-mul  0   1   0   1)
  (check-mul  0   1   1   1)
  (check-mul  1   1  -1  -1)
  (check-mul  1   1  -1   0)
  (check-mul  1   1  -1   1)
  (check-mul  1   1   0   0)
  (check-mul  1   1   0   1)
  (check-mul  1   1   1   1))


; Actually we could probably decrese the number of multiplications by analyzing all possible combinations .
; I started it as a proof of concept but got bored...
;
; interval x = [a, b]
; interval y = [c, d]
; sgn(A) = A ... 
;
;   +-------------------+ +----------------------------
;   |     sgn of        | | number of multiplications 
;   +-------------------+-+--------+----------+--------
;   |  a |  b | c  |  d | | 0      |    1     |
;   |----+----+----+----+-+-------------------+
;   | -1 | -1 | -1 | -1 | |        |          |
;   | -1 | -1 | -1 |  0 |X|        |          |
;   | -1 | -1 | -1 |  1 | |        |          |
;   | -1 | -1 |  0 |  0 |X| (0, 0) |          |
;   | -1 | -1 |  0 |  1 |X|        |          |
;   | -1 | -1 |  1 |  1 | |        |          |
;   | -1 |  0 | -1 | -1 |X|        |          |
;   | -1 |  0 | -1 |  0 |X|        |          |
;   | -1 |  0 | -1 |  1 |X|        |          |
;   | -1 |  0 |  0 |  0 |X| (0, 0) |          |
;   | -1 |  0 |  0 |  1 |X|        |          |
;   | -1 |  0 |  1 |  1 |X|        |          |
;   | -1 |  1 | -1 | -1 | |        |          |
;   | -1 |  1 | -1 |  0 |X|        |          |
;   | -1 |  1 | -1 |  1 | |        |          |
;   | -1 |  1 |  0 |  0 |X| (0, 0) |          |
;   | -1 |  1 |  0 |  1 | |        |          |
;   | -1 |  1 |  1 |  1 | |        |          |
;   |  0 |  0 | -1 | -1 |X| (0, 0) |          |
;   |  0 |  0 | -1 |  0 |X| (0, 0) |          |
;   |  0 |  0 | -1 |  1 |X| (0, 0) |          |
;   |  0 |  0 |  0 |  0 |X| (0, 0) |          |
;   |  0 |  0 |  0 |  1 |X| (0, 0) |          |
;   |  0 |  0 |  1 |  1 |X| (0, 0) |          |
;   |  0 |  1 | -1 | -1 |X|        |          |
;   |  0 |  1 | -1 |  0 |X|        |          |
;   |  0 |  1 | -1 |  1 |X|        |          |
;   |  0 |  1 |  0 |  0 |X| (0, 0) |          |
;   |  0 |  1 |  0 |  1 |X|        | (0, bd)  | 
;   |  0 |  1 |  1 |  1 |X|        | (0, bd)  |
;   |  1 |  1 | -1 | -1 | |        |          |
;   |  1 |  1 | -1 |  0 |X|        |          |
;   |  1 |  1 | -1 |  1 | |        |          |
;   |  1 |  1 |  0 |  0 |X| (0, 0) |          |
;   |  1 |  1 |  0 |  1 |X|        | (0, bd)  |
;   |  1 |  1 |  1 |  1 | |        |          | 
;   +-------------------+-+--------+----------+
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.12
;; -------------

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

; ratio = width / center
; width = ratio * center

(define (make-center-percent center %tolerance) 
  (let ((width (* center (/ %tolerance 100))))
    (make-center-width center width)))

(define (percent i)
  (* (/ (width i) (center i)) 100))

(make-center-percent 3.5 1)
(percent (make-center-percent 3.5 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.13
;; -------------
;; See exercise-2.13.{tex,pdf}
;;
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.14
;; -------------
;; 

(define A (make-center-percent 5 1))
(define B (make-center-percent 7 2))

(div-interval A B)

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
    (+ (upper-bound x) (upper-bound y))))


(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
  (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
      (add-interval (div-interval one r1)
      (div-interval one r2)))))


(par1 A B)
(par2 A B)

; Lem is of course right.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.15
;; -------------
;; 

; the interval A from 2.14 corresponds to some number with error bounds
; (uncertainty) using that interval multiple times willl introduce the
; uncertainty once again:
;

(define A/A (div-interval A A))

A/A
(div-interval A/A A/A)
(div-interval (div-interval A/A A/A) (div-interval A/A A/A))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.16
;; -------------
;; 

;
; The algebra that we use in interval arithmetic isn't the same as in Nat or
; Real for example repeated addition isn't the same as multiplication, some
; expressions for example A/A above should be equal to 1 without error bounds.
;
; I think we could improve the interval system by symbol manipulation (for
; example A/A should be always 1) and `smart` reductions by reordering.
;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.17
;; -------------
;; 

(define (last-pair xs)
  (cond ((null? xs) (error "last-pair undefined on empty list"))
        ((null? (cdr xs)) xs)
        (else (last-pair (cdr xs)))))

(last-pair (list 23 72 149 34))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.18
;; -------------
;; 

(define (reverse xs)
  (if (null? xs) 
    xs
    (append (reverse (cdr xs)) (list (car xs)))))

(reverse '())
(reverse (list 1))
(reverse (list 1 2))
(reverse (list 1 2 3 4 5 6))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.19
;; -------------
;; 

(define (first-denomination denoms) (car denoms)) 
(define (except-first-denomination denoms) (cdr denoms)) 
(define (no-more? denoms) (null? denoms))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                 (except-first-denomination
                   coin-values))
             (cc (- amount
                    (first-denomination coin-values))
                 coin-values)))))

; The order of the denominations shouldn't matter because cc searches
; exhaustivly (using every combination).

(cc 56 (list 1 2 5 10 20 50 100 200))
(cc 56 (reverse (list 1 2 5 10 20 50 100 200)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.20
;; -------------
;; 

(define (same-parity x . elems)
  (define same?
      (if (odd? x) odd?
          even?))
  (define (iter ys)
    (if (null? ys) 
      ys
      (let ((y (car ys))
        (rest (cdr ys)))
        (if (same? y) 
          (cons y (iter rest))
          (iter rest)))))
  (iter elems))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.21
;; -------------
;; 

(define (map proc items)
  (if (null? items)
    nil
    (cons (proc (car items))
          (map proc (cdr items)))))


(define (square x) (* x x))
(define nil '())

(define (square-list items)
  (if (null? items)
    nil
    (cons (square (car items)) (square-list (cdr items)))))

(square-list (list 1 2 3 4 5 6 7 8 9))

(define (square-list items)
  (map square items))

(square-list (list 1 2 3 4 5 6 7 8 9))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.22
;; -------------
;; 

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons (square (car things))
                  answer))))
  (iter items nil))

; 
; The above doesn't work beause we accumulate on the answer by consing to it 
; when we evaluate: 
; 
; (square-list (list 1 2 3 4 5 6 7 8 9))
;
; we cons (square 1) to an empty list then cons (square 2) to (1) giving 
; (4 1) etc.


(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons answer
                  (square (car things))))))
  (iter items nil))

(square-list (list 1 2 3 4 5 6 7 8 9))

; The above doesn't work because we cons an empty list with an element givin (()
; . 1) and then cons to it.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.23
;; -------------
;; 

(define (for-each f xs)
  (cond ((null? xs) #t)
        (else (f (car xs))
              (for-each f (cdr xs)))))

(for-each (lambda (x) (newline) (display x)) (list 1 2 3 4))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.24
;; -------------
;; 


(list 1 (list 2 (list 3 4)))
; (1 (2 (3 4)))

  
;  [* | *] --> [* | \]
;   |           |
;   v           v
;   1          [* | *] --> [* | /] 
;               |           |
;               v           v
;               2          [* | *] --> [* | /]
;                           |           |
;                           v           v
;                           3           4
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.25
;; -------------
;; 

(car (cdr (car (cdr (cdr (list 1 3 (list 5 7) 9))))))

(car (car (list (list 7))))

(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7))))))))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.26
;; -------------
;; 

(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y)
; (1 2 3 4 5 6)

(cons x y)
; ((1 2 3) 4 5 6)

(list x y)
; ((1 2 3) (4 5 6))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.27
;; -------------
;; 


(define (reverse xs)
  (if (null? xs) 
    xs
    (append (reverse (cdr xs)) (list (car xs)))))

(define (deep-reverse xs)
  (if (null? xs)
    xs
    (let (
        (x (car xs))
        (tail (cdr xs)))
      (if (list? x)
        (append (deep-reverse tail) (list (deep-reverse x)))
        (append (deep-reverse tail) (list x))))))

(define x (list (list 1 2) (list 3 4)))

(reverse x)
(deep-reverse x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.28
;; -------------
;; 

(define (fringe tree)
  (if (null? tree)
    tree
    (let (
        (branch (car tree))
        (rest   (cdr tree)))
      (if (list? branch)
        (append (fringe branch) (fringe rest))
        (cons branch (fringe (cdr tree)))))))
    
(define x (list (list 1 2) (list 3 4)))

(fringe x)

(fringe (list x x))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.29
;; -------------
;; 


;; a

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cadr mobile))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cadr branch))

(left-branch (make-mobile (make-branch 1 2) (make-branch 3 4)))
(right-branch (make-mobile (make-branch 1 2) (make-branch 3 4)))
(branch-length (make-branch 1 2)) 
(branch-structure (make-branch 1 2)) 

;; b

(define (is-mobile? m) 
  (list? m))

(define (branch-weight branch)
  (let (
      (structure (branch-structure branch)))
    (if (is-mobile? structure)
      (total-weight structure)
      structure)))

(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile)) 
     (branch-weight (right-branch mobile))))

(define x 
  (make-mobile 
    (make-branch 1 1)
    (make-branch 1 2)))

(total-weight x)
(total-weight 
  (make-mobile 
    (make-branch 1 x)
    (make-branch 2 x)))

;; c


(define (balanced? mobile)
  (define (torque branch)
    (* (branch-length branch)
       (branch-weight branch)))
  (define (branch-submodules-balanced branch)
    (let (
        (structure (branch-structure branch)))
      (if (is-mobile? structure)
        (balanced? structure)
        #t)))
  (let (
      (left (left-branch mobile))
      (right (right-branch mobile)))
    (and
      (= (torque left) (torque right))
      (branch-submodules-balanced left)
      (branch-submodules-balanced right))))
       
(define x 
  (make-mobile 
    (make-branch 1 2)
    (make-branch 2 1)))

(define x-x
  (make-mobile
    (make-branch 4 x)
    (make-branch 4 x)))

(define x<x
  (make-mobile
    (make-branch 2 x)
    (make-branch 4 x)))

(define y
  (make-mobile
    (make-branch 2 x<x)
    (make-branch 2 x-x)))
    

(balanced? x)
(balanced? x-x)
(balanced? x<x)
(balanced? y)


;; d

; not-same :
(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))
 
(define (right-branch mobile)
  (cdr mobile))

(define (branch-length branch)
  (car branch))

(define (is-mobile? x)
  (pair? x))

; stays same:


(define (left-branch mobile)
  (car mobile))

(define (branch-structure branch)
  (cdr branch))

(left-branch (make-mobile (make-branch 1 2) (make-branch 3 4)))
(right-branch (make-mobile (make-branch 1 2) (make-branch 3 4)))
(branch-length (make-branch 1 2)) 
(branch-structure (make-branch 1 2)) 

(define (branch-weight branch)
  (let (
      (structure (branch-structure branch)))
    (if (is-mobile? structure)
      (total-weight structure)
      structure)))

(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile)) 
     (branch-weight (right-branch mobile))))

(define x 
  (make-mobile 
    (make-branch 1 1)
    (make-branch 1 2)))

(total-weight x)
(total-weight 
  (make-mobile 
    (make-branch 1 x)
    (make-branch 2 x)))

(define (balanced? mobile)
  (define (torque branch)
    (* (branch-length branch)
       (branch-weight branch)))
  (define (branch-submodules-balanced branch)
    (let (
        (structure (branch-structure branch)))
      (if (is-mobile? structure)
        (balanced? structure)
        #t)))
  (let (
      (left (left-branch mobile))
      (right (right-branch mobile)))
    (and
      (= (torque left) (torque right))
      (branch-submodules-balanced left)
      (branch-submodules-balanced right))))
       
(define x 
  (make-mobile 
    (make-branch 1 2)
    (make-branch 2 1)))

(define x-x
  (make-mobile
    (make-branch 4 x)
    (make-branch 4 x)))

(define x<x
  (make-mobile
    (make-branch 2 x)
    (make-branch 4 x)))

(define y
  (make-mobile
    (make-branch 2 x<x)
    (make-branch 2 x-x)))
    

(balanced? x)
(balanced? x-x)
(balanced? x<x)
(balanced? y)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.30
;; -------------
;; 

(define (square x) 
  (* x x))

(define nil '())

(define (square-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (square tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

(square-tree
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

; the task is meh - let's define a tree map instead 

(define (square-tree tree)
  (map (lambda (sub-tree)
          (if (pair? sub-tree)
              (square-tree sub-tree)
              (square sub-tree)))
       tree))
  
(square-tree
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.31
;; -------------
;; 

(define (map-tree f tree)
  (map (lambda (sub-tree)
          (if (pair? sub-tree)
              (map-tree f sub-tree)
              (f sub-tree)))
       tree))
  
(define (square-tree tree)
  (map-tree square tree))

(square-tree
  (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.32
;; -------------
;; 

(define (subsets s)
  (define (add-head xs)
    (cons s xs))
  (if (null? s)
    (list nil)
    (let ((rest (subsets (cdr s))))
      (append rest (map add-head rest)))))

(subsets (list 1 2 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.33
;; -------------
;; 

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))


(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(map (lambda (x) (+ x 1)) (list 1 2 3 4))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(append (list 1 2 3 4) (list 5 6 7 8))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(length (list 1 2 3 4 5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.34
;; -------------
;; 

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) 
                (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.35
;; -------------
;; 

(define (count-leaves tree)
  (accumulate 
    + 
    0 
    (map 
      (lambda (x)
        (if (pair? x)
          (count-leaves x)
          1))
       tree)))

(define x (cons (list 1 2) (list 3 4)))

(count-leaves x)

(count-leaves (list x x))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.36
;; -------------
;; 

(define (accumulate-n op init seqs)
  (define nil '())
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))


(define xs (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(accumulate-n + 0 xs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.37
;; -------------
;; 

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (matrix-*-vector m v)
  (define (row-and-vector-combine r v)
    (accumulate + 0 (accumulate-n * 1 (list r v))))
  (map (lambda (x) (row-and-vector-combine x v)) m))

(define X 
  (list (list 1 2 3)
        (list 4 5 6)
        (list 7 8 9)))

(define v (list 1 2 3))

(matrix-*-vector X v)

;;

(define (transpose mat)
  (accumulate-n cons '() mat))

(transpose X)

;;

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map 
      (lambda (x) 
        (accumulate-n matrix-*-vector '() cols)) 
      m)))

(define I 
  (list (list 1 0 0)
        (list 0 1 0)
        (list 0 0 1)))
  
(matrix-*-matrix I X)
