#lang racket

;; Is 14 an atom?
;; Ya

;; Is (atom? n) true or false where n is 14
;; #t

;; Is -3 a number?
;; Ya

;;Is 3.14159 a number?
;; Ya

;; What is (add1 1 n) where n is 67
;; 68

;; (sub1 n) where n is 5
;; 4

;; What is (sub1 0)
;; -1. But in the book we're only considering positive integers

;; Is (zero ? 0) true or false?
;; #t

;; What is (+ 46 12)
;; 58

(define (++ a b)
  (cond
    ((zero? b) a)
    (else (++ (add1 a) (sub1 b)))))
(++ 5 6)

(define (+ n m)
  (cond
    ((zero? m) n)
    (else (add1 (+ n (sub1 m))))))
(+ 5 6)

;; The second version is from the book and follows the commandments
;; more closely, zero? is like checking null? for numbers
;; and add1 is like consing onto a list

;; What is (- 14 3)
;; 11

;; What is (- 17 9)
;; 8

;; What is (- 18 25)
;; We arent considering negative numbers in the book

(define (- x y)
  (cond
    ((zero? y) x)
    (else (sub1 (- x (sub1 y))))))
(- 10 2)

(define (-- x y)
  (cond
    ((zero? y) x)
    (else (-- (sub1 x) (sub1 y)))))
(-- 10 2)

;; Is this a tup? (2 11 3 79 47 6)
;; Yuh

;; Is this a tup? (8 55 5 555)
;; Mmmhmm

;; Is this a tup? (1 2 8 apple 4 3)
;; No. Becuase it contains more than just numbers

;; Is this a tup? (3 (7 4) 13 9)
;; No because it is not a list of numbers

;; Is this a tup? ()
;; Yes becuase it is a list of 0 numbers

;; What is (addtup tup) where tup is (3 5 2 8)
;; 18

;; What is (addtup tup) where tup is (15 6 7 12 3)
;; 43

;; What does addtup do ?
;; Takes a tuple as an argument and adds up the numbers returning an atom

;; What is the natural way to build numbers from a list?
;; Using + instead of cons. cons builds lists and + builds numbers

;; When building with cons the value of the terminal condition is ()
;; What should be the value of the terminal condition when building
;; numbers with +
;; 0

;; What is the natural terminal condition for a list?
;; (null? l)

;; What is the natural terminal condition for a tup?
;; I initially said (zero? tup) but this doesnt make sense
;; because clearly the last atom of a tup need not be 0 hence the ans is
;; (null? tup)

;; When we build a number from a list of numbers,
;; what should the terminal condition line look like?
;; ((null? tup) 0)

;; What is the terminal condition line of addtup
;; ((null? tup) 0)

;; How is a lat defined?
;; It is either an empty list or it contains an
;; atom (car lat) and a rest (cdr lat), that is
;; also a lat

;; How is tup defined
;; It is either an empty list, or it contains a
;; number and a rest that is also a tup.

;; What is used in the natural recursion on a list?
;; (cdr lat)

;; What is used in the natural recursion on a tup?
;; (cdr tup)

;; How many questions do we need to ask about a list?
;; Two

;; How many questions do we need to ask about a tup?
;; Two

;; How is a number defined?
;; 0 or 1 added to the rest where rest is also a number

;; What is the natural terminal condition for numbers?
;; (zero? x)

;; What is the natural recursion on a number?
;; (sub1 x)

;; How many questions do we need to ask about a number?
;; Two

;; What does cons do?
;; Builds lists

;; What does addtup do?
;; Adds the numbers in a tuple and gives you a result

;; What is the terminal condition line of addtup
;; ((null? tup) 0)

;; What does addtup use to build a number?
;; +

;; Fill in the dots
;; (define addtup
;;   (lambda (tup)
;;     (cond
;;       ((null? tup) 0)
;;       (else (+ (car tup) (addtup (cdr tup)))))))

;; What is (* 5 3)
;; 15

;; What is (* 13 4)
;; 52

;; What does (* m n) do
;; Builds numbers by adding n up m times

;; What is the terminal condition line for x
;; ((zero? m ) 0)

;; Since (zero? m) is the terminal condition, m must eventually be
;; reduced to zero. What function is used to do this?
;; sub1

;; What is another name for (* n (sub1 m)) in this case?
;; recurring condition for *

;; Try to write the function *
(define (* a b)
  (cond
    ((zero? b) 0)
    (else (+ a (* a (sub1 b))))))
(* 5 4)

;; What is  (* 12 3)
;; 36

;; Again, why is 0 the value for the terminal condition line in x
;; Becuase 0 will not affect +

;; What is ( tup+ tup1 tup2) where tup1 is (3 6 9 1 11 4 ) and tup2 is (8 5 2 0 7)
;; (11 11 11 11 11)

;; What is (tup+ tup1 tup2) where tup1 is (2 3) and tup2 is (4 6)
;; (6 9)

;; What does (tup+ tup1 tup2) do?
;; Takes two tuples that adds the corresponding elements to return a tuple with
;; the same number of elements

;; What is unusual about tup+
;; recurs on two tuples instead of one

;; If you recur on one tup how many questions do you have to ask?
;; Two

;; When recurring on two tups, how many questions need to be asked about the tups?
;; Four ie is the first tuple null or else, is the second tuple null or else

;; Do you mean the questions
;; (and (null? tup1) (null? tup2))
;; (null? tup1) (null? tup2) and else

;; Can the first tup be () at the same time as the second is ()
;; Ideally yes

;; Does this mean (and (null? tup1) (null? tup2 )) and else are the only questions ?
;; Yeah

;; Write the fucntion tup+
;; (define (tup+ tup1 tup2)
;;   (cond
;;     ((and (null? tup1) (null? tup2)) '())
;;     (else (cons (+ (car tup1) (car tup2))
;;                 (tup+ (cdr tup1) (cdr tup2))))))
;; (tup+ '(1 2 3) '(1 2 3))

;; What are the arguments of + in the last line?
;; (car tup1) (car tup2)

;; What are the arguments of cons in the last line?
;; (+ (car tup1) (car tup2)) and (tup+ (cdr tup1) (cdr tup2))

;; What is (tup+ tup1 tup2) where tup1 is (3 7) and tup2 is (4 6)
;; (7 13)

;; Simplify
;; (define tup++ (lambda (tup1 tup2)
;;                 (cond
;;                   ((and (null? tup1) (null? tup2)) '())
;;                   ((null? tup1) tup2)
;;                   ((null? tup2) tup1)
;;                   (else
;;                    (cons (+ (car tup1) (car tup2))
;;                          (tup++ (cdr tup1) (cdr tup2)))))))

(define tup++ (lambda (tup1 tup2)
                (cond
                  ((null? tup1) tup2)
                  ((null? tup2) tup1)
                  (else
                   (cons (+ (car tup1) (car tup2))
                         (tup++ (cdr tup1) (cdr tup2)))))))

;; Does the order of the two terminal conditions matter?
;; Nah

;; Is else the last question?
;; Yah

;; What is (> 12 133)
;; #f

;; What is (> 120 11)
;; #t

;; On how many numbers do we have to recur?
;; Two

;; How do we recur?
;; sub1 on m and n

;; When do we recur?
;; Until one number is 0

;; How many questions do we have to ask about n and m
;; 3

;; Can you write the function > now using zero? and sub1

(define (> x y)
  (cond
    ((zero? x) #f)
    ((zero? y) #t)
    (else (> (sub1 x) (sub1 y)))))

;; Does the order of the terminal conditions matter?
;; Yes because if we check (zero? y) before (zero? x)
;; The check fails when both numbers are equal

;; What is (< 4 6)
;; #t

;; (< 8 3)
;; #f

;; (< 6 6)
;; #f

;; Define <
(define (< x y)
  (cond
    ((zero? y) #f)
    ((zero? x) #t)
    (else (< (sub1 x) (sub1 y)))))
(< 6 6)

;; Define = using < and >
(define (= x y)
  (cond
    ((or (< x y) (> x y)) #f)
    (else #t)))

;; Does this mean we have two different functions for testing equality of atoms?
;; = for numbers and eq? for other atoms

;; (^ 1 1)
;; 1

;; (^ 2 3)
;; 8

;; (^ 5 3)
;; 125


;; Define ^
(define (^ a b)
  (cond
    ((zero? b) 1)
    (else (* a (^ a (sub1 b))))))

;; Whats a good name for this function
;; (define ??? (lambda (n m)
;; (cond
;; ((< n m) 0)
;; (else (add1 (??? (- n m) m))))))
;; div

;; What is  (/ 15 4 )
;; 3

;; What is the value of (length lat) where lat is
;; (hotdogs with mustard sauerkraut and pickles )
;; 6

;; What is (length lat) where lat is (ham and cheese on rye)
;; 5

;; Now try to write the function length
(define (length lat)
  (cond
    ((null? lat) 0)
    (else (add1 (length (cdr lat))))))

;; What is (pick n lat) where n is 4 and
;; lat is (lasagna spaghetti ravioli macaroni meatball)
;; macaroni

;; What is (pick 0 lat) where lat is (a)
;; No answer

;; Write the function pick
(define (pick a lat)
  (cond
    ((zero? (sub1 a)) (car lat))
    (else (pick (sub1 a) (cdr lat)))))

;; What is (rempick n lat) where n is 3 and lat is (hotdogs with hot mustard)
;; (hotdogs with mustard)

;; Now try to write rempick
;; (define (rempick n lat)
;;   (cond
;;     ((zero? (sub1 n)) (cdr lat))
;;     (else (cons (car lat) (rempick (sub1 n) (cdr lat))))))

;; Is (number? a) true or false where a is tomato
;; #f

;; Is (number? 76) true or false?
;; #t

;; Can you write number? which is #t if its is a numeric atom and #f if it is
;; anything else?
;; Cant. Its a primitive function

;; Now using number? Write the function no-nums which gives as a final value
;; a lat obtained by removing all the numbers from the lat
(define (no-nums lat)
  (cond
    ((null? lat) '())
    ((number? (car lat)) (no-nums (cdr lat)))
    (else (cons (car lat) (no-nums (cdr lat))))))
(no-nums '(5 pears 6 prunes 9 dates))

;; Now write all-nums which extracts a tup from a lat using all the
;; numbers in the lat
(define (all-nums lat)
  (cond
    ((null? lat) '())
    ((number? (car lat)) (cons (car lat) (all-nums (cdr lat))))
    (else (all-nums (cdr lat)))))
(all-nums '(5 pears 6 prunes 9 dates))

;; Write eqan? ie is true if its arguments a1 and a2 are the same atom.
;; Remember to use = for numbers and eq? for all other atoms.
(define (eqan? a1 a2)
  (cond
    ((and (number? a1) (number? a2)) (= a1 a2))
    ((or (number? a1) (number? a2)) #f)
    (else (eq? a1 a2))))


;; Can we assume that all functions written using eq?
;; can be generalized by replacing eq? by eqan?
;; Yeah

;; Now write the function occur which counts the number of times an atom a
;; appears in a lat
(define (occur a lat)
  (cond
    ((null? lat) 0)
    ((eqan? a (car lat)) (add1 (occur a (cdr lat))))
    (else (occur a (cdr lat)))))
(occur 1 '(1 1 3 4 1 1 11))

;; Write the function one? where (one? n) is #t if n is 1 else #f
(define (myone? n)
  (cond
    ((zero? n) #f)
    (else (zero? (sub1 n)))))

(define (one? n)
  (= n 1))

;; Now rewrite the function rempick that removes the nth atom from a lat.
;; For example, where n is 3 and lat is (lemon meringue salty pie)
;; the value of (rempick n lat) is (lemon meringue pie)
;; Use the function one? in your answer.

(define (rempick n lat)
  (cond
    ((one? n) (cdr lat))
    (else (cons (car lat) (rempick (sub1 n) (cdr lat))))))

(rempick 3 '(lemon meringue salt pie))
