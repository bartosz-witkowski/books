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
    (map (lambda (row) (matrix-*-vector cols row)) m)))

(define I 
  (list (list 1 0 0)
        (list 0 1 0)
        (list 0 0 1)))
  
(matrix-*-matrix I X)
(matrix-*-matrix X I)
(matrix-*-matrix X X)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.38
;; -------------
;; 

(fold-right / 1 (list 1 2 3))
(/ 1 (/ 2 (/ 3 1)))

(fold-left / 1 (list 1 2 3)) 
(/ (/ (/ 1 1) 2) 3)


;
; \forall x, y \in X x `op` y = y `op` x
;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.39
;; -------------
;; 

(define (fold-right op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (fold-right op initial (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
      result
      (iter (op result (car rest))
            (cdr rest))))
  (iter initial sequence))


(define nil '())

;;

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(reverse (list 1 2 3 4 5))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

(reverse (list 1 2 3 4 5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.40
;; -------------
;; 

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (fold-right op initial (cdr sequence)))))


(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (unique-pairs n)
  (define (pred pair)
    (let (
        (i (car pair))
        (j (cadr pair)))
      (<  j i)))
  (let (
      (interval (enumerate-interval 1 n)))
    (filter pred 
            (flatmap 
              (lambda (i)
                (map (lambda (j) (list i j)) interval))
              interval))))

(unique-pairs 3)

(define (prime? n)
  (define (square x) (* x x))
  (define (smallest-divisor n)
    (find-divisor n 2))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (= n (smallest-divisor n)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
 (filter prime-sum? (unique-pairs n)))
        
(prime-sum-pairs 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.41
;; -------------
;; 

(define (distinct-ordered-triples n)
  (define (pred triple)
    (let (
        (i (car triple))
        (j (cadr triple))
        (k (caddr triple)))
      (and (<  i j)
           (<  j k))))
  (let (
      (interval (enumerate-interval 1 n)))
    (filter pred 
            (flatmap 
              (lambda (i)
                (flatmap 
                  (lambda (j) 
                    (map (lambda (k) (list i j k)) interval))
                  interval))
              interval))))

(distinct-ordered-triples 3)

(define (distinct-ordered-triples-summing-to n sum)
  (filter 
    (lambda (triple) (= sum (accumulate + 0 triple)))
    (distinct-ordered-triples n)))

(distinct-ordered-triples-summing-to 100 100)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.42
;; -------------
;; 

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))


(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))

(define nil '())

;                        
 
(define (adjoin-position new-row k rest-of-queens)
  (cons (new-position new-row k) rest-of-queens))

(define (new-position row column)
  (list row column))

(define (position-row position)
  (car position))

(define (position-column position)
  (cadr position))

(define empty-board '())

(define this-position (list 2 3))
(define that-position (list 3 2))
(safe-by-diagonals this-position that-position)

(define (safe-helper this-position others)
  (define (safe-by-row p1 p2)
    (not (= (position-row p1) (position-row p2))))
  (define (safe-by-column p1 p2)
    (not (= (position-column p1) (position-column p2))))
  (define (safe-by-diagonals p1 p2)
    (let (
      (delta-column (- (position-column p1) (position-column p2)))
      (delta-row    (- (position-row p1) (position-row p2))))
  (not (= (abs delta-row) (abs delta-column)))))
  (if (null? others)
    #t
    (let (
        (that-position (car others)))
      (and 
         (safe-by-row this-position that-position)
         (safe-by-column this-position that-position)
         (safe-by-diagonals this-position that-position)
         (safe-helper this-position (cdr others))))))

(safe-helper (new-position 4 2) (list (new-position 1 1)))
(safe-helper (list 4 4) (list (list 4 3) (list 4 2) (list 4 1)))

(safe-helper (list 2 3) (list (list 3 2) (list 1 1)))

(define (safe? k positions)
  (define (this-column? p)
    (= (position-column p) k))
  (let (
      (this-position (car (filter this-column? positions)))
      (other-positions (filter (lambda (p) (not (this-column? p))) positions)))
    (safe-helper this-position other-positions)))


(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? k positions))
        (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row
                                    k
                                    rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))


; checking solutions manualy
(queens 4)

;   1 2 3 4
; 1   #
; 2       #
; 3 #  
; 4     #
;

;   1 2 3 4
; 1     #
; 2 #      
; 3       #
; 4   #  
 
; checking by sizes:
; http://en.wikipedia.org/wiki/Eight_queens_puzzle#Counting_solutions
(= (length (queens 8)) 92)
(= (length (queens 9)) 352)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.43
;; -------------
;; 


;  "Our version"
(flatmap
  (lambda (rest-of-queens)
    (map (lambda (new-row)
           (adjoin-position new-row
                            k
                            rest-of-queens))
         (enumerate-interval 1 board-size)))
  (queen-cols (- k 1)))

; "Luises version"
(flatmap
  (lambda (new-row)
    (map (lambda (rest-of-queens)
           (adjoin-position new-row 
                            k 
                            rest-of-queens))
         (queen-cols (- k 1))))
  (enumerate-interval 1 board-size))

; The queen-cols call is done needlesly in the inner map for 
; k = 8 we do 8 * n-calls(queen-cols(k-1)) calls. 
; this expands to k! calls of queen-cols 
; 
; This doesn't tell the whole story because the time characteristics of one call
; to queen-cols will be different between those two versions we can
; approximately say that Luises version will take about (7! * T) more time.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The picture language
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.44
;; -------------
;; 

(define (up-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (up-split painter (- n 1))))
      (below painter (beside smaller smaller)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.45
;; -------------
;; 

(define (split split-1 split-2)
  (if (= n 0)
    painter
    (let ((smaller (split painter (- n 1))))
      (split-1 painter (split-2 smaller smaller)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.46
;; -------------
;; 

(define (make-vect x y)
  (cons x y))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect)
  (cdr vect))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect v s)
  (make-vect (* s (xcor-vect v)) 
             (* s (ycor-vect v))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.47
;; -------------
;; 

(define origin 1)
(define edge1  2)
(define edge2  3)

;; 1

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (frame-origin frame)
  (car frame))

(define (frame-edge1 frame)
  (cadr frame))

(define (frame-edge2 frame)
  (caddr frame))

(define frame (make-frame origin edge1 edge2))

(= (frame-origin frame) origin)
(= (frame-edge1 frame) edge1)
(= (frame-edge2 frame) edge2)

;; 2

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (frame-origin frame)
  (car frame))

(define (frame-edge1 frame)
  (cadr frame))

(define (frame-edge2 frame)
  (cddr frame))

(define frame (make-frame origin edge1 edge2))

(= (frame-origin frame) origin)
(= (frame-edge1 frame) edge1)
(= (frame-edge2 frame) edge2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.48
;; -------------
;;

(define (make-segment v1 v2)
  (cons v1 v2))

(define (start-segment s)
  (car s))

(define (end-segment s)
  (cdr s))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.49
;; -------------
;;


(define (opposed-to-origin frame)
  (add-vect (frame-origin frame)
            (add-vect (frame-edge1 frame)
                      (frame-edge2 frame))))

(define (midpoint v1 v2)
  (define (average a b)
    (/ (+ a b) 2))
  (make-vect
    (average (xcor-vect v1) (xcor-vect v2))
    (average (ycor-vect v1) (ycor-vect v2))))

(define (segment-list-from-point-list point-list)
  (if (< (length point-list) 2)
      (error "The point list must be at least 2 in size")
      (let (
          (first-segment (make-segment (car point-list) (cadr point-list)))
          (other-points  (cddr point-list)))
        (fold-left 
                (lambda (acc point) 
                  (cons (make-segment (end-segment (car acc)) point) acc))
                (list first-segment)
                other-points))))


(define x (segment-list-from-point-list 
  (list
    (make-vect 0 0)
    (make-vect 1 1)
    (make-vect 2 2)
    (make-vect 3 3))))
  

(define (outline-painter frame)
  (define segment-list
    (let (
        (origin (frame-origin frame))
        (edge1  (frame-edge1 frame))
        (edge2  (frame-edge2 frame)))
        (opposed (opposed-to-origin frame))
      (segment-list-from-point-list 
        (list origin edge1 opposed edge2 origin))))
  (segments->painter segment-list))

(define (x-painter frame)
  (define segment-list
    (list 
      (make-segment (frame-origin frame) (opposed-to-origin frame))
      (make-segment (frame-edge1 frame) (frame-edge2 frame))))
  (segments->painter segment-list))


(define (diamond-painter frame)
  (define segment-list
    (let (
        (origin (frame-origin frame))
        (edge1  (frame-edge1 frame))
        (edge2  (frame-edge2 frame)))
        (opposed (opposed-to-origin frame))
      (let (
          (a (midpoint origin edge1))
          (b (midpoint edge1 opposed))
          (c (midpoint opposed edge2))
          (d (midpoint edge2 origin)))
        (segment-list-from-point-list 
          (list a b c d)))))
  (segments->painter segment-list))

;;

(require graphics/graphics)

(define vp (open-viewport "A Picture Language" 500 500))

(define draw (draw-viewport vp))
(define (clear) ((clear-viewport vp)))
(define line (draw-line vp))

;need a wrapper function so that the graphics library works with my code...
(define (vector-to-posn v)
  (make-posn (car v) (car (cdr v))))

(define (segments->painter segment-list)   
  (lambda (frame)     
   (for-each     
     (lambda (segment)        
      (line         
        (vector-to-posn ((frame-coord-map frame) (start-segment segment)))         
        (vector-to-posn ((frame-coord-map frame) (end-segment segment)))))      
      segment-list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 2.50
;; -------------
;;

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1 0)
                     (make-vect 0 0)
                     (make-vect 1 1)))


(define (rotate-180 painter)
  (transform-painter painter
                     (make-vect 1 1)
                     (make-vect 0 1)
                     (make-vect 1 0)))

(define (rotate-270 painter)
  (transform-painter painter
                     (make-vect 0 1)
                     (make-vect 0 0)
                     (make-vect 1 0)))
