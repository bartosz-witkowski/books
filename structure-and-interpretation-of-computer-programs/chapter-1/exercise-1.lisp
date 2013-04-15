;; I've started the exercises with guile but ended with dr scheme.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.1
;; ------------

10 
; 10

(+ 5 3 4) 
12

(- 9 1)
8

(/ 6 2)
3

(+ (* 2 4) (- 4 6))
(+ 8 -2)
6

(define a 3)
a == 3

(define b (+ a 1))
b == 4

(+ a b (* a b))
(+ 3 4 (* 3 4))
(+ 3 4 12)
19

(if (and (> b a) (< b (* a b)))
    b
    a)
(if (and (> 4 3) (< 4 (* 3 4)))
    4
    3)
(if (and #t (< 4 12))
    4
    3)
(if (and #t #t)
    4
    3)
(if #t 4 3)
4

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(cond ((= 3 4) 6)
      ((= 4 4) (+ 6 7 3))
      (else 25))
(cond (#f 6)
      (#t (+ 6 7 3))
      (else 25))
(+ 6 7 3)
16

(+ 2 (if (> b a) b a))
(+ 2 (if (> 4 3) 4 3))
(+ 2 (if #t 4 3))
(+ 2 4)
6

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
(* (cond ((> 3 4) 3)
         ((< 3 4) 4)
         (else -1))
   (+ 3 1))
(* (cond (#f 3)
         (#t 4)
         (else -1))
   4)
(* 4 4)
16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.2
;; ------------

(/ 
   (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2)(- 2 7)))

; (5 + 4 + (2 - (3 - (6 + 4/5)))) / (3 * (6 - 2) * (2 - 7)) =-.24666666666666666666
; -37/150 =-.24666666666666666666

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.3
;; ------------
;; Don't yet know the syntax enough to make this elegant

(define (sum-of-squares a b) (+ (* a a) (* b b)))
(define (max2 a b) (if (> a b) a b))
(define (min2 a b) (if (< a b) a b))
(define (max3 a b c) (max2 (max2 a b) c))

(define (second a b c) (max2 (min2 a b) (min2 b c)))
   
(define (sum-of-squares-of-two-largest a b c)
   (sum-of-squares (max3 a b c) (second a b c)))

;; tests
(sum-of-squares 4 4)
(max2 5 4)
(max3 3 4 5)
(second 6 5 7)

(sum-of-squares-of-two-largest 4 5 6)
;; 5 * 5 =25
;; 6 * 6 =36
;; 25 + 36 =61


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.4
;; ------------
;; If `b > 0` then we add `a` and `b` if not we subtract it.
;; 
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.5
;; ------------
;;
;; Applicative-order evaluation will hang because of the recursive definition of p.
;;
;; Normal-order:
;;
;; (define (p) (p))
;; (define (test x y)
;;   (if (= x 0) 0 y))
;;
;;  Evaluation using normal order:

(test 0 (p))
(if (= 0 0) 0 (p))
(if #t 0 (p))
0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.6
;; ------------
;; 
;; Had to evaluate this to really see it... it crashes with a stack overflow. Why?
;; Again it's the difference between normal order and applicative order evaluation,
;; the arguments will be expanded ad-infinitum 

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
(define (p) (p))

(if (= 1 1) 1 (p))

; hangs
(new-if (= 1 1) 1 (p))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.7
;; ------------
;; 
;; Good enough is defined as:
;; 

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

;;
;; If we think about it guess can be written as:
;;
;; guess = sqrt(x) + error
;;
;; So (square guess) evaluates to:
;; 
;;  sqrt(x)^2 + 2 + 2 * error * sqrt(x) + error^2 
;;  
;; Let's call `2 * error * sqrt(x) + error^2 = E`
;;
;; `E` is the difference between the 'real value' and our current guess. And as we
;; can see it depends on x - the bigger the x the bigger the `E` term. So even
;; with a small error i.e in the range of `1.0e-6` the `E` term can get very big
;;


(define (square x) (* x x))

(good-enough? 20000000.0000001 20000000)

;
; Next part, define a better good-enough function
;

(define (average a b) (/ (+ a b) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define *epsilon* 0.001)

(define (good-enough? guess last-guess)
   (< (abs (- guess last-guess)) *epsilon*))

(define (sqrt-iter guess x last-guess)
  (if (good-enough? guess last-guess)
          guess
          (sqrt-iter (improve guess x) x guess)))

(define (sqrt x) (sqrt-iter 1.0 x x))
(sqrt 400000)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.8
;; ------------


(define (improve guess x)
   (/ (+ (/ x (square guess)) (* 2 guess)) 3))

(define (cube-root-iter guess x last-guess)
   (if (good-enough? guess last-guess)
           guess
           (cube-root-iter (improve guess x) x guess)))

(define (cube-root x) (cube-root-iter 1.0 x x))

(cube-root 27)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.9
;; ------------

; No tail recursion (we collect 'inc') so recursive:
(define (+ a b)
  (if (= a 0) b (inc (+ (dec a) b))))

(+ 4 5)
(if (= 4 0) 5 (inc (+ (dec 4) 5)))
(if #f 5 (inc (+ (dec 4) 5)))
(inc (+ 3 5))
(inc (if (= 3 0) 5 (inc (+ (dec 3) 5))))
(inc (if #f 5 (inc (+ (dec 3) 5))))
(inc (inc (+ (dec 3) 5)))
(inc (inc (+ 2 5)))
(inc (inc (if (= 2 0) 5 (inc (+ (dec 2) 5)))))
(inc (inc (if #f 5 (inc (+ (dec 2) 5)))))
(inc (inc (inc (+ (dec 2) 5))))
(inc (inc (inc (+  1 5))))
(inc (inc (inc (if (= 1 0) 5 (inc (+ (dec 1) 5))))))
(inc (inc (inc (if #f 5 (inc (+ (dec 1) 5))))))
(inc (inc (inc (inc (+ (dec 1) 5)))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc (if (= 0 0) 5 (inc (+ (dec 0) 5)))))))
(inc (inc (inc (inc (if #t 5 (inc (+ (dec 0) 5)))))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9

; Tail recursion - so iterative

(define (+ a b)
  (if (= a 0) b (+ (dec a) (inc b))))

(+ 4 5)
(if (= 4 0) 5 (+ (dec 4) (inc 5)))
(if #f 5 (+ (dec 4) (inc 5)))
(+ (dec 4) (inc 5))
(+ 3 6)
(if (= 3 0) 6 (+ (dec 3) (inc 6)))
(if #f 6 (+ (dec 3) (inc 6)))
(+ (dec 3) (inc 6))
(+ 2 7)
(if (= 2 0) 7 (+ (dec 2) (inc 7)))
(if #f 7 (+ (dec 2) (inc 7)))
(+ (dec 2) (inc 7))
(+ 1 8)
(if (= 1 0) 8 (+ (dec 1) (inc 8)))
(if #f 8 (+ (dec 1) (inc 8)))
(+ (dec 1) (inc 8))
(+ 0 9)
(if (= 0 0) 9 (+ (dec 0) (inc 9)))
(if #t 9 (+ (dec 0) (inc 9)))
9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.10
;; -------------

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

(A 1 10)
; 1024

(A 2 4)
; 65536

(A 3 3)
; 65536

; f(x) = 2x
(define (f n) (A 0 n))

; g(x) = 2^x
(define (g n) (A 1 n))

; h(1) = 2
; h(2) = 2^2
; h(3) = 2^2^2
; h(4) = 2^2^2^2
;  . . .
(define (h n) (A 2 n))

; 2
(h 1) 
; 4
(h 2)
; 16
(h 3)
; 65536
(h 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.11
;; -------------

;; Recursive:
(define (f n) 
   (if (< n 3) 
      n
      (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))


;; Iterative
(define (f-iter n)
   (define (f' a b c counter)
      (define sum (+ a (* 2 b) (* 3 c)))
      (if (= counter 0)
         sum
         (f' sum a b (- counter 1))))
   (if (< n 3)
      n
      (f' 2 1 0 (- n 3))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.12
;; -------------


(define (pascal row col)
   (cond ((= col 1) 1)
         ((= row col) 1)
         (else (+ 
                  (pascal (- row 1) (- col 1))
                  (pascal (- row 1) col)))))

; test
(pascal 1 1)
(pascal 2 1)
(pascal 2 2)
(pascal 3 2)
(pascal 4 2)
(pascal 4 3)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.13
;; -------------
;;
;; See exercise-1-13.{tex,pdf}
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.14
;; -------------
;;
;; 
;;

(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

; Ok doing it by hand was pointless, but whatever:
;
;  (11, 5)                              -> 4
;  |
;  +-( 11, 4)                           -> 4
;  | |
;  | +-( 11, 3)                         -> 4
;  | | |
;  | | +-(11, 2)                        -> 3
;  | | | |
;  | | | +-(11, 1)                      -> 1
;  | | | | |
;  | | | | +-(10, 1)                    -> 1
;  | | | | | |
;  | | | | | +-(9, 1)                   -> 1
;  | | | | | | |
;  | | | | | | +-(8, 1)                 -> 1
;  | | | | | | | |
;  | | | | | | | +-(7, 1)               -> 1
;  | | | | | | | | |
;  | | | | | | | | +-(6, 1)             -> 1
;  | | | | | | | | | |
;  | | | | | | | | | +-(5, 1)           -> 1
;  | | | | | | | | | | |
;  | | | | | | | | | | +-(4, 1)         -> 1
;  | | | | | | | | | | | |
;  | | | | | | | | | | | +-(3, 1)       -> 1
;  | | | | | | | | | | | | |
;  | | | | | | | | | | | | +-(2, 1)     -> 1
;  | | | | | | | | | | | | | |
;  | | | | | | | | | | | | | +-(1, 1)   -> 1
;  | | | | | | | | | | | | | | |
;  | | | | | | | | | | | | | | +-(0, 1) -> 1
;  | | | | | | | | | | | | | | |
;  | | | | | | | | | | | | | | +-(1, 0) -> 0
;  | | | | | | | | | | | | | +-(2, 0)   -> 0
;  | | | | | | | | | | | | +-(3, 0)     -> 0
;  | | | | | | | | | | | +-(4, 0)       -> 0
;  | | | | | | | | | | +-(5, 0)         -> 0
;  | | | | | | | | | +-(6, 0)           -> 0
;  | | | | | | | | +-(7, 0)             -> 0
;  | | | | | | | +-(8, 0)               -> 0
;  | | | | | | +-(9, 0)                 -> 0
;  | | | | | +-(10, 0)                  -> 0
;  | | | | +-(11, 0)                    -> 0
;  | | | +-(6, 2)                       -> 2
;  | | |   |
;  | | |   +-(6, 1)                     -> 1
;  | | |   | |
;  | | |   | +-(5, 1)                   -> 1
;  | | |   | | |
;  | | |   | | +-(4, 1)                 -> 1
;  | | |   | | | |
;  | | |   | | | +-(3, 1)               -> 1
;  | | |   | | | | |
;  | | |   | | | | +-(2, 1)             -> 1
;  | | |   | | | | | |
;  | | |   | | | | | +-(1, 1)           -> 1
;  | | |   | | | | | | |
;  | | |   | | | | | | +-(0, 1)         -> 1
;  | | |   | | | | | | |
;  | | |   | | | | | | +-(1, 0)         -> 0
;  | | |   | | | | | +-(2, 0)           -> 0
;  | | |   | | | | +-(3, 0)             -> 0
;  | | |   | | | +-(4, 0)               -> 0
;  | | |   | | +-(5, 0)                 -> 0
;  | | |   | +-(6, 0)
;  | | |   |
;  | | |   +-(1, 2)                     -> 1
;  | | |     |
;  | | |     +-(1, 1)                   -> 1
;  | | |     | |
;  | | |     | +-(1, 0)                 -> 1
;  | | |     | |
;  | | |     | +-(0, 1)                 -> 0
;  | | |     +-(-4, 2)                  -> 0
;  | | |
;  | | +-(1, 3)                         -> 1
;  | |   |
;  | |   +-(1, 2)                       -> 1
;  | |   | |
;  | |   | +-(1, 1)                     -> 1
;  | |   | | |
;  | |   | | +-(0, 1)                   -> 1
;  | |   | | |
;  | |   | | +-(1, 0)                   -> 0
;  | |   | +-(-4, 2)                    -> 0
;  | |   +-(-9, 3)                      -> 0
;  | | +-
;  | +-(-14, 4)                         -> 0
;  +-(-39, 5)                           -> 0
;
;
; The maximum space requirement is O(n) and depends on the smallest
; denomination.
;
; Time requirements:
;   cc(n, 1) is n/denominations(1) so O(n)
;   cc(n, 2) is cc(n, 1) times n/denominations(2) so O(n^2)
;   
;   cc(n, 5) is O(n^5)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.15
;; -------------
;;

(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

; So let's see:
;
;  12.15 / 3 = 4.05
;  4.05 / 3 = 1.35
;  1.35 / 3 = .45
;  0.45 / 3 =.15
;  0.15 / 3 =.05
;
; So p is evaluated 5 times
;
; In general p will be evaluated ceiling(log_3(angle / 0.1)) times, so the order
; of growth in both space and time is O(log n). The space complexity could be
; made O(1) by tail recursion.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.16
;; -------------
;;

(define (f-expt b n)
   (define (even? n)
      (= (remainder n 2) 0))
   (define (square n) (* n n))
   (define (f-expt' b n a)
      (cond ((= n 0) a)
            ((even? n) (f-expt' (square b) (/ n 2) a))
            (else      (f-expt' b (- n 1) (* a b)))))
   (f-expt' b n 1))

(f-expt 2 2)
(f-expt 2 3)
(f-expt 2 6)
(f-expt 2 60)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.17
;; -------------
;;

; a * b = (a / 2) * 2 * b           if a is even
; a * b =  b + ((a - 1) / 2) * b    if a is odd


(define (mul a b)
   (define (halve a)  (/ a 2))
   (define (double a) (+ a a))
   (define (even? n)
      (= (remainder n 2) 0))
   (cond ((or (= a 0) (= b 0)) 0)
         ((= a 1) b)
         ((even? a) (mul (halve a) (double b)))
         (else      (+ b (mul (halve (- a 1)) (double b))))))

(mul 2 3)
(mul 6 6)
(= (mul 1234 53245) (* 1234 53245))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.18
;; -------------
;;

; a * b = (a / 2) * 2 * b           if a is even
; a * b =  b + ((a - 1) / 2) * b    if a is odd


(define (f-mul a b)
   (define (halve a)  (/ a 2))
   (define (double a) (+ a a))
   (define (even? n)
      (= (remainder n 2) 0))
   (define (f-mul' a b acc)
      (cond ((= a 0) acc)
            ((even? a) (f-mul' (halve a) (double b) acc))
            (else      (f-mul' (- a 1) b (+ acc b)))))
    (f-mul' a b 0))

(f-mul 2 3)
(f-mul 7 6)
(= (f-mul 1234 53245) (* 1234 53245))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.19
;; -------------
;;
;; See exercise-1.19.tex


(define (fib-iter a b p q count)
  (define (square x) (* x x))
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (square p) (square q))
                   (+ (square q) (* 2 p q))
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))
(define (fib n)
  (fib-iter 1 0 0 1 n))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.20
;; -------------
;;

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

; Let's do normal order first because it's quicker:

(gcd 206 40)

(if (= 40 0)
  206
  (gcd 40 (remainder 206 40)))

(gcd 40 (remainder 206 40))

; + 1

(gcd 40 6)

(if (= 6 0)
  40
  (gcd 6 (remainder 40 6)))

(gcd 6 (remainder 40 6))

; + 1

(gcd 6 4)

(if (= 4 0)
  6
  (gcd 4 (remainder 6 4)))

(gcd 4 (remainder 6 4))

; + 1

(gcd 4 2)

(if (= 2 0)
  4
  (gcd 2 (remainder 4 2)))

(gcd 2 (remainder 4 2))

; + 1

(gcd 2 0)

(if (= 0 0)
  2
  (gcd 0 (remainder 2 0)))

2

; normal order

(gcd 206 40)

(if (= 40 0)
  206
  (gcd 40 (remainder 206 40)))

(gcd 40 (remainder 206 40))

(if (= (remainder 206 40) 0)
  40
  (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))

; + 1

(if (= 6 0)
  40
  (gcd (remainder 206 40) (remainder 40 (remainder 206 40))))

(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))

(if (= (remainder 40 (remainder 206 40)) 0)
  (remainder 206 40)
  (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

; + 2

(if (= 4 0)
  (remainder 206 40)
  (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

(gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))

(if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0)
  (remainder 40 (remainder 206 40))
  (gcd 
    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
    (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))

; + 4

(if (= 2 0)
  (remainder 40 (remainder 206 40))
  (gcd 
    (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
    (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))

(gcd 
  (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 
  (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

(if 
  (= (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 0)
  (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
  (gcd 
    (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 
    (remainder (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))

; + 7

(if 
  (= 0 0)
  (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
  (gcd 
    (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 
    (remainder (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))


; + 4
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))

2

; 18 in total.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.21
;; -------------
;;

(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(smallest-divisor 199)
(smallest-divisor 1999)
(smallest-divisor 19999)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.22
;; -------------
;;


(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(define (runtime) (tms:clock (times)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (start-prime-test n start-time)
  (if (prime? n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes a b)
	(define (next) 
		(timed-prime-test a) 
		(search-for-primes (+ a 2) b))
	(define (end)
		(newline)
		(display "Done.")
		(newline))
	(if (even? a) 
		(search-for-primes (+ a 1) b)
		(if (<= a b) 
			(next)
			(end))))

(define (search-for-primes-int int n) (search-for-primes n (+ n int)))

(search-for-primes-int 50 1000)
(search-for-primes-int 50 10000)
(search-for-primes-int 50 100000)
(search-for-primes-int 50 1000000)

; Processors have become so fast that data is inconclusive

(search-for-primes-int 120 10000000)
(search-for-primes-int 50  100000000)      ; avg 2 ms
(search-for-primes-int 50  1000000000)     ; avg 4.5 ms
(search-for-primes-int 65  10000000000)    ; avg 14.3 ms
(search-for-primes-int 65  100000000000)   ; avg 44.5 ms
(search-for-primes-int 65  1000000000000)  ; avg 134.3 ms

; We can definetly see a trend in the growth

(/ 134.3 44.5) ; 3.01
(/ 44.5 14.3)  ; 3.11
(/ 14.3 4.5)   ; 3.17
(sqrt 10)      ; 3.16


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.23
;; -------------
;;


(define (smallest-divisor n)
  (define (square x) (* x x))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (next n)
    (if (= 2 n) 
      3
      (+ 2 n)))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (next test-divisor)))))
  (find-divisor n 2))


(search-for-primes-int 65  1000000000)    ; avg 8.6 ms
(search-for-primes-int 65  10000000000)    ; avg 8.6 ms
(search-for-primes-int 65  100000000000)   ; avg 26.5 ms

(/ 14.3 8.6) ; 1.66
(/ 44.5 26.5) ; 1.67
(/ 134.3 83) ; 1.61

; The naive expectation was that we would gain a twofold speedup, the data shows
; that it's closer to ~1.65. This can be explained by the fact that the
; smallest-divisor's time doesn't depend only on the amount of the divisors to
; test, and that calling (next test-divisor) versus (+ 1 test-divisor) may be
; slower.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.24
;; -------------
;;

(define (runtime) (tms:clock (times)))

(define (expmod base exp m)
  (define (square x) (* x x))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                     m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (fermat-test n)
      (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (search-for-primes a b)
	(define (next) 
		(timed-prime-test a) 
		(search-for-primes (+ a 2) b))
	(define (end)
		(newline)
		(display "Done.")
		(newline))
	(if (even? a) 
		(search-for-primes (+ a 1) b)
		(if (<= a b) 
			(next)
			(end))))

; Ok I'm giving up on benchmarking - this tests are too fast for my computer for
; numbers < 1 * 10^13, and then guile dies on this: 

(random 10000000000000)

; Seams to be a bug. DrScheme's implementation of random doesn't work on numbers
; larger then 2^32, and this exercise isn't that much exciting to warrant
; spending more time on it.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.25
;; -------------
;;

(define (expmod base exp m)
  (define (square x) (* x x))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                     m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (fast-expt b n)
   (define (even? n)
      (= (remainder n 2) 0))
   (define (square n) (* n n))
   (define (f-expt' b n a)
      (cond ((= n 0) a)
            ((even? n) (f-expt' (square b) (/ n 2) a))
            (else      (f-expt' b (- n 1) (* a b)))))
   (f-expt' b n 1))

(define (slow-expmod base exp m)
  (remainder (fast-expt base exp) m))


; It works correctly:

(expmod 2 12341234 5)
(slow-expmod 2 12341234 5)

; It's just slow as it exponentiates naively and then takes the remainder not
; exploiting that we're dealing with modulo arithmetic.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.26
;; -------------
;;
;; Lisp doesn't do any memorization so using multiplication exmod be evaluated
;; twice at each step. 
;;
;; First "level" evaluates to two
;;  (exmod base (/ exp 2) m) 
;; and each of those evaluate two of their of own etc. 
;;
;; At the lowest level there will be 2^(log_2 n) nodes, and 2^(log_2 n) is just
;; n nodes. So this is now has O(n) space/time complexity.
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.27
;; -------------
;;

(define (carmichael n) 
  (cond 
    ((= n 1) 561)
    ((= n 2) 1105)
    ((= n 3) 1729)
    ((= n 4) 2465)
    ((= n 5) 2821)
    ((= n 6) 6601)))

(define (is-carmicheal-or-prime n) 
  (define (expmod base exp m)
     (define (square x) (* x x))
     (cond ((= exp 0) 1)
           ((even? exp)
            (remainder (square (expmod base (/ exp 2) m))
                        m))
           (else
            (remainder (* base (expmod base (- exp 1) m))
                        m))))
   (define (test a)
      (if (>= a n)
         #t
         (if (= (expmod a n n) a)
            (test (+ a 1))
            #f)))
   (test 1))

(is-carmicheal-or-prime (carmichael 1))
(is-carmicheal-or-prime (carmichael 2))
(is-carmicheal-or-prime (carmichael 3))
(is-carmicheal-or-prime (carmichael 4))
(is-carmicheal-or-prime (carmichael 5))
(is-carmicheal-or-prime (carmichael 6))
(is-carmicheal-or-prime 10039)
(is-carmicheal-or-prime 10040)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.28
;; -------------
;;

(define (mr-expmod base exp m)
  (define (square-or-zero-if-trivial x) 
    (define (trivial? x) (or (= x 1) (= (- m 1))))
    (if (or
            (trivial? x)
            (not (= (remainder (* x x) m) 1)))
      (* x x)
      0))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square-or-zero-if-trivial (mr-expmod base (/ exp 2) m))
                     m))
        (else
         (remainder (* base (mr-expmod base (- exp 1) m))
                     m))))
(define (miller-rabin-test n)
  (define (/= a b) (not (= a b)))
  (define (try-it a)
    (= (mr-expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else #f)))

(define (is-prime? n) (fast-prime? n 100))

(is-prime? (carmichael 1))
(is-prime? (carmichael 2))
(is-prime? (carmichael 3))
(is-prime? (carmichael 4))
(is-prime? (carmichael 5))
(is-prime? (carmichael 6))

; primes:
(is-prime? 3)
(is-prime? 5)
(is-prime? 7)
(is-prime? 11)
(is-prime? 10039)

; not primes
(is-prime? 4)
(is-prime? 8)
(is-prime? 10040)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.29
;; -------------
;;

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (simpsons-rule f a b n)
  (define h (/ (- b a) n))
  (define (inc x) (+ 1 x))
  (define (simpsons-term-multiplier k)
    (cond 
      ((or (= k 0) (= k n)) 1)
      ((odd? k)             4)
      (else                 2)))
  (define (simpsons-term k)
    (* (simpsons-term-multiplier k) (f (+ a (* k h)))))
  (* (/ h 3) (sum simpsons-term 0 inc n)))

(define (cube x) (* x x x))

(simpsons-rule cube 0 1 100)

; Guile is throwing stackoverflow exceptions... using plt-scheme from now.

(simpsons-rule cube 0 1 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.30
;; -------------
;;

(define (sum term a next b)
  (define (iter a result)
    (if (> a  b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.31
;; -------------
;;
;;


(define (product term a next b)
  (define (iter a result)
    (if (> a  b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

(define (factorial n) 
  (define (inc x) (+ x 1))
  (define (id x) x)
  (product id 1 inc n))

(factorial 1)
(factorial 2)
(factorial 3)
(factorial 4)
(factorial 5)

; i = 0 -> 3
; i = 1 -> 3
; i = 2 -> 5
; i = 3 -> 5
; i = 4 -> 7
; R = 3 + 2 * floor(i / 2)
 
; i = 0 -> 2
; i = 1 -> 4
; i = 2 -> 4
; i = 3 -> 6
; i = 4 -> 6
; R = 2 + 2 * floor(i + 1 / 2)


(define (pi-approx n)
  (define (/2-no-rem n)
    (if (odd? n) 
      (/ (- n 1) 2)
      (/ n 2)))
  (define (numerator i) 
    (+ 2 (* 2 (/2-no-rem (+ 1 i)))))
  (define (denominator i)
    (+ 3 (* 2 (/2-no-rem i))))
  ; force floating point
  (define (n/d i) (* 1.0 (/ (numerator i) (denominator i))))
  (define (inc x) (+ 1 x))
  (if (= n 0) 0
    (* 4 (product n/d 0 inc (- n 1)))))

(pi-approx 1)
(pi-approx 2)
(pi-approx 3)
(pi-approx 4)
(pi-approx 5)
(pi-approx 6)
(pi-approx 7)

; b

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.32
;; -------------
;;

(define (accumulate combiner zero term a next b)
  (define (iter a result)
    (if (> a  b)
        result
        (iter (next a) (combiner result (term a)))))
  (iter a zero))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(define (inc x) (+ 1 x))
(define (id x) x)

(sum id 1 inc 2)
(sum id 1 inc 3)
(sum id 1 inc 4)

(product id 1 inc 2)
(product id 1 inc 3)
(product id 1 inc 4)

; b

(define (accumulate combiner zero term a next b)
  (if (> a  b)
    zero
    (combiner 
      (term a)
      (accumulate combiner zero term (next a) next b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.33
;; -------------
;;

(define (filtered-accumulate predicate? combiner zero term a next b)
  (define (iter a result)
    (if (> a  b)
        result
        (if (predicate? a)
          (iter (next a) (combiner result (term a)))
          (iter (next a) result))))
  (iter a zero))

(define (square x) (* x x))

(define (prime? n)
  (define (smallest-divisor n)
    (find-divisor n 2))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (= n (smallest-divisor n)))

(define (sum-of-squares-of-prime-numbers-in a b)
  (define (inc x) (+ 1 x))
  (filtered-accumulate prime? + 0 square a inc b))

(sum-of-squares-of-prime-numbers-in 1 1)
(sum-of-squares-of-prime-numbers-in 1 2)
(sum-of-squares-of-prime-numbers-in 1 3)
(sum-of-squares-of-prime-numbers-in 1 4)
(sum-of-squares-of-prime-numbers-in 1 5)

; b

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

(define (product-of-relatively-prime n)
  (define (id x) x)
  (define (inc x) (+ 1 x))
  (define (relatively-prime? i) (= (gcd i n) 1))
  (if (<= n 1)
    0
    (filtered-accumulate relatively-prime? * 1 id 2 inc (- n 1))))


(product-of-relatively-prime 2)
(product-of-relatively-prime 3)
(product-of-relatively-prime 4)
(product-of-relatively-prime 5)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.34
;; -------------
;;


(define (f g)
  (g 2))

(f f) ; ->
(f 2) ; ->
(2 2)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.35
;; -------------
;;
;; See exercise-1.35.{tex,pdf} for the theoretical part.

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (f x) 
  (+ 1 (/ 1 x)))

(fixed-point f 1.0)
(fixed-point f 1000.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.36
;; -------------
;;

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (display guess)
      (newline)
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (no-damping first-guess) 
  (fixed-point 
    (lambda (y) 
      (/ (log 1000) (log y)))
    first-guess))


; x -> log(1000) / log(x)
; x + x = (log(1000) / log(x)) + x
; x = 0.5 * ((log(1000) / log(x)) + x)

(define (average-damping first-guess) 
  (fixed-point 
    (lambda (y) 
      (/ 
        (+ (/ (log 1000) (log y))
           y)
        2))
    first-guess))

(no-damping 10)
(average-damping 10)

(no-damping 100)
(average-damping 100)

(no-damping 5)
(average-damping 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.37
;; -------------
;;

(define (cont-frac n d k)
  (define (helper i)
    (if (> i k) 
      0
      (/ (n i) 
         (+ (d i) (helper (+ i 1))))))
  (helper 1))

(define (one-over-phi k)
  (cont-frac (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))

(one-over-phi 5)

; b

(define (cont-frac n d k)
  (define (helper i acc)
    (if (= i 0) 
      acc
      (helper 
        (- i 1)
          (/ (n i) 
             (+ (d i) acc)))))
  (helper k 0))

(define (one-over-phi k)
  (cont-frac (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))

(one-over-phi 5)


(define (cont-frac n d k)
  (define (helper i acc)
    (if (= i 0) 
      acc
      (helper 
        (- i 1)
          (/ (n i) 
             (+ (d i) acc)))))
  (helper k 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.38
;; -------------
;;

(define (Di i)
  (let ((i-2 (- i 2)))
    (if (= 0 (remainder i-2 3)) 
      (* (+ (/ i-2 3) 1) 2)
      1)))

(define (e-approx k)
  (+ 2 (cont-frac (lambda (i) 1.0)
             Di
             k)))

(Di 1)
(Di 2)
(Di 3)
(Di 4)
(Di 5)
(Di 6)
(Di 7)
(Di 8)
(Di 9)
(Di 10)
(Di 11)

(e-approx 1)
(e-approx 2)
(e-approx 3)
(e-approx 4)
(e-approx 5)
(e-approx 6)
(e-approx 60)
(e-approx 200)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.39
;; -------------
;;
;;


(define (tan-cf x k)
  (cont-frac 
    (lambda (i)
      (if (= i 1) x (- (* x x))))
    (lambda (i)
      (+ 1 (* (- i 1) 2)))
             k))

(tan-cf 3.14 1)
(tan-cf 3.14 5)
(tan-cf 3.14 100)
(tan 3.14)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.40
;; -------------
;;

(define (cubic a b c)
  (lambda (x)
    (+ (*   x x x)
       (* a x x)
       (* b x)
          c)))


(define (newtons-method g guess)
  (define (deriv g)
    (let ((dx 0.00001))
    (lambda (x)
      (/ (- (g (+ x dx)) (g x))
         dx))))
  (define (newton-transform g)
    (lambda (x)
      (- x (/ (g x) ((deriv g) x)))))
  (define (fixed-point f first-guess)
    (define (close-enough? v1 v2)
      (let ((tolerance 0.00001))
        (< (abs (- v1 v2)) tolerance)))
    (define (try guess)
      (let ((next (f guess)))
        (if (close-enough? guess next)
            next
            (try next))))
    (try first-guess))
  (fixed-point (newton-transform g) guess))

(newtons-method (cubic 1 1 1) 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.41
;; -------------
;;


(define (double f)
  (lambda (x)
    (f (f x))))

(define (inc x) (+ x 1))

((double inc) 1)

(define (square x) (* x x))

((double square) 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.42
;; -------------
;;

(define (compose f g)
  (lambda (x)
    (f (g x))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.43
;; -------------
;;

(define (repeated f n)
  (define (helper i acc)
    (cond 
      ((= i 0) (error "repeated undefined for n = 0"))
      ((= i 1) acc) 
      (else    (helper (- i 1) (compose f acc)))))
  (helper n f))

(define (square x) (* x x))

((repeated square 2) 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.44
;; -------------
;;

(define (smooth f)
  (lambda (x)
    (let ((dx 0.0000001))
      (/ 
        (+ (f (- x dx))
           (f x)
           (f (+ x dx)))
        3))))

(define (n-smooth f n)
  (repeated (smooth f) n))

((n-smooth (lambda (x) (* x x x)) 1) 1.0)
((n-smooth (lambda (x) (* x x x)) 2) 1.0)
((n-smooth (lambda (x) (* x x x)) 3) 1.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.45
;; -------------
;;

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average-damp f)
  (define (average x y) (/ (+ x y) 2))
  (lambda (x) (average x (f x))))

(define (cube-root x)
  (fixed-point 
    (average-damp (lambda (y) (/ x (square y))))
    1.0))


(define (f-expt b n)
   (define (even? n)
      (= (remainder n 2) 0))
   (define (square n) (* n n))
   (define (helper b n a)
      (cond ((= n 0) a)
            ((even? n) (helper (square b) (/ n 2) a))
            (else      (helper b (- n 1) (* a b)))))
   (helper b n 1))

(define (n-th-root-helper x n n-damp)
  (let (
    (damp-f (repeated average-damp n-damp))
    (n-1 (- n 1)))
    (fixed-point 
      (damp-f (lambda (y) (/ x (f-expt y n-1))))
      1000.0)))

(define (n-th-root-test n n-damp)
  (n-th-root-helper (f-expt 2.0 n) n n-damp))

(n-th-root-test 2 1)

(n-th-root-test 3 1)


; (n-th-root-test 4 1) doesn converge
(n-th-root-test 4 2) 

(n-th-root-test 5 2) 

(n-th-root-test 6 2) 

(n-th-root-test 7 2) 

; (n-th-root-test 8 2) doesn't converge
(n-th-root-test 8 3) 

; the pattern seems to be (log_2 n) let's test this:

(n-th-root-test 15 3) 
;(n-th-root-test 16 3) doesn't converge
(n-th-root-test 16 4) 

; so n-damp must be 

(define (log2 x)
  (/ (log x) (log 2)))

(floor (log2 2))
(floor (log2 3))
(floor (log2 4))

(define (n-th-root x n)
  (n-th-root-helper x n (floor (log2 n))))

(n-th-root 4.0 2)
(n-th-root 8.0 3)
(n-th-root 16.0 4)
(n-th-root 32.0 5)
(n-th-root 64.0 6)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exercise 1.46
;; -------------
;;

(define (iterative-improvement good-enough? improve-guess) 
  (lambda (x) 
    (define (iter x)
      (let ((next-x (improve-guess x)))
        (if (good-enough? next-x x)
          next-x
          (iter next-x))))
    (iter x)))

(define (sqrt x)
  (define (good-enough? guess last-guess)
    (define epsilon 0.0001)
    (< (abs (- guess last-guess)) epsilon))
  (define (improve guess)
    (define (average x y)
      (/ (+ x y) 2))
    (average guess (/ x guess)))
  ((iterative-improvement good-enough? improve) x))

(sqrt 4.0)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (define tolerance 0.00001)
    (< (abs (- v1 v2)) tolerance))
  ((iterative-improvement close-enough? f) first-guess))

(fixed-point cos 1.0)
