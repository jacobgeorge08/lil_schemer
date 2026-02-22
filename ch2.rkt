#lang racket

;; True or false: (lat? l) where l is (Jack Sprat could eat no chicken fat)
;; #t

;; True or false: where (lat? l) l is ((Jack) Sprat could eat no chicken fat)
;; #f

;; True or false: (lat? l) where l is (Jack (Sprat could) eat no chicken fat)
;; #f

;; True or false: (lat? l) where l is ()
;; True because it doesnt contain any sublists

;; True or false: a lat is a list of atoms.
;; True

;; Write the function lat? using some of the following functions:
;; car cdr cons null? atom? and eq?
;; (define (lat? l)
;;   (cond
;;     ((null? l) #t)
;;     ((atom? (car l))
;;      (lat? (cdr l)))
;;     (else #f)))

;; What is the value of (lat? l) where l is the argument (bacon and eggs)
;; #t

;; How do we determine the answer #t for the application (lat? l)
;; Cond takes a predicate and what to do if true and works step by step
;; First we check if its a null list, it it is we return true
;; If its false we check if the car of l is an atom,
;; if it is we recursively all lat? on (cdr l)
;; Else we return false

;; What is the meaning of the cond-line ((null? l) #t) where l is (bacon and eggs)
;; checks if the list is null and returns true if it is

;; What is the next question?
;; Is (car l) an atom

;; What is the meaning of the line ((atom? (car l)) (lat? (cdr l)))
;; where l is (bacon and eggs)
;; If (car l) is an atom, call lat? recursively on the (cdr l)

;; What is the meaning of (lat? (cdr l))
;; (lat? (cdr l)) finds out if the rest of the list l is composed only of atoms

;; Now what is the argument l for lat ?
;; Now the argument l is (cdr l), which is (and eggs)

;; What is the next question?
;; (null? l)

;; What is the meaning of the line ((null? l) #t) where l is now (and eggs)
;; If l is now a null list, return true

;; What is the next question?
;; (atom? (car l))

;; What is the meaning of the line ((atom? (car l)) (lat? (cdr l))) where l is (and eggs)
;; If (car l) is an atom ie "and", call lat? on (cdr l) ie (eggs)

;; What is the meaning of the line ((null? l) #t) where l is now (eggs)
;; (null? l) asks if the argument l is null. If it is, the value of the application is #t
;; If it is not, move to the next question

;; What is the next question?
;; (atom? (car l))

;; What is the meaning of the line ((atom? (car l)) (lat? (cdr l))) where l is now (eggs)
;; Evals to true and we cdr the empty list

;; Now, what is the argument for lat ?
;; ()

;; What is the meaning of the line ((null ? l) #t) where l is now ()
;; #t

;; Do you remember the question about (lat? l)
;; #t or #f depending on if l is a list of atoms or not

;; Can you describe what the function lat? does in your own words?
;; Recursively checks whether a list is just made up of atoms or not. Does this by checking
;; the car and the cdr of the list

;; Defining atom? since we're using #lang racket
(define (atom? x)
  (not (pair? x)))

(define lat?
  (lambda (l)
    (cond
      ((null? l) #t )
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))

;; What is the value of (lat? l) where l is now (bacon (and eggs))
;; #f

;; What is the first question?
;; (null? l)

;; What is the meaning of the line ((null? l) #t) where l is (bacon (and eggs))
;; Is l the list null? It isnt so we move on to the next question

;; What is the next question?
;; Is (atom? (car l))

;; What is the meaning of the line ((atom? (car l)) (lat? (cdr l))) where
;; l is (bacon (and eggs))
;; Is bacon an atom. If it is eval (lat? (cdr l)) else move on to the next cond question

;; What is the meaning of (lat? (cdr l))
;; call lat? on the cdr of l ie ((and eggs))

;; What is the meaning of the line ((null? l) #t) where l is now ((and eggs))
;; (null? l) asks if l is the null list. If it is null, the value is #t.
;; If it is not null, we ask the next question. In this case, l is not null, so
;; move to the next question.

;; What is the next question?
;; (atom? (car l))

;; What is the meaning of the line ((atom? (car l)) (lat? (cdr l)))
;; where l is now ((and eggs))
;; We check if l is an atom or not. It isnt because it is is a list so we move onto the
;; next question

;; What is the next question?
;; else

;; Is else true?
;; Ya

;; What is the meaning of the line (else #f )
;; Eval to #f

;; What is )))
;; Closing parens for the rest of the program

;; Can you describe how we determined the value #f for (lat? l) where l is (bacon (and eggs))
;; (lat? l) looks at each item in its argument to see if it is an atom. If it runs out of
;; items before it finds a list, the value of (lat? l) is #t. If it finds a list, as it did in
;; the example (bacon (and eggs)), the value of (lat? l) is #f.

;; Is (or (null? Ll) (atom? L2)) true or false where L1 is () and L2 is (d e f g)
;; #t

;; Is (or (null? l1) (null? l2)) true or false where l1 is (a b c) and l2 is ()
;; #t

;; Is (or (null? l1) (null? l2)) true or false where l1 is (a b c) and l2 is (atom)
;; #f

;; What does (or ...) do?
;; Takes two values and returns true if one of them is true else false

;; Is it true or false that a is a member of lat where a is tea and lat is (coffee tea or milk)
;; #t

;; Is (member? a lat) true or false where a is poached and lat is (fried eggs and scrambled eggs)
;; #f

(define (member? a lat)
  (cond
    ((null? lat) #f)
    (else (or (eq? (car lat) a)
              (member? a (cdr lat))))))
;; What is the value of (member? a lat) where a is meat and lat is (mashed potatoes and meat gravy)
;; #t

;; What is the first question asked by (member? a lat)
;; (null? lat)

;; What is the meaning of the line ((null? lat) #f) where lat is (mashed potatoes and meat gravy)
;; Is the list null, if it is return false

;; What is the next question?
;; else

;; Is else really a question?
;; Yes. Its value is always true

;; What is the meaning of the line
(else (or (eq? (car lat) a)
          (member? a (cdr lat))))
;; Is (car lat) the same as a OR is member? a the same as (cdr lat)

;; True or false:
(or (eq? (car lat) a)
    (member? a (cdr lat)))
;; where a is meat and lat is (mashed potatoes and meat gravy)
;; #t

;; Is (eq? (car lat) a) true or false where a is meat and lat is
;; (mashed potatoes and meat gravy)
;; false

;; What is the second question of (or ...)
;; (member? a (cdr lat))

;; Now what are the arguments of member?
;; a ie meat and (potatoes and meat gravy)

;; What is the next question?
;; (null? lat)

;; Is (null? lat) true or false where lat is (potatoes and meat gravy)
;; #f

;; What do we do now?
;; Next question

;; What is the next question?
;; else

;; What is the meaning of
(or (eq? (car lat) a)
    (member? a (cdr lat)))
;; Same as last time, is meat == potatoes else is (member? meat (and meat gravy))

;; Is a eq? to the car of lat
;; Nah

;; So what do we do next?
We ask (member? a (cdr lat))

;; Now, what are the arguments of member?
;; a is meat, and lat is (and meat gravy)

;; What is the next question?
;; (null? lat)

;; What is the next question?
;; else

;; What is the value of
(or (eq? (car lat) a)
    (member? a (cdr lat)))
;; (member? a (cdr lat)))

;; What are the new arguments?
;; a is meat, and lat is (meat gravy)

;; What is the next question?
;; (null? lat)

;; What do we do now?
;; else

;; What is the value of
(or (eq? (car lat) a)
    (member? a (cdr lat)))
;; #t

;; What is the value of the application (member? a lat) where a is meat and lat is (meat gravy)
;; #t

;; What is the value of the application (member? a lat) where a is meat and lat is (and meat gravy)
;; Also #t

;; What is the value of the application (member? a lat) where a is meat and
;; lat is (potatoes and meat gravy)
;; Also #t

;; What is the value of the application (member? a lat ) where a is meat
;; and lat is (mashed potatoes and meat gravy)
;; Finally also #t

;; Just to make sure you have it right , let's quickly run through it again.
;; What is the value of (member? a lat) where a is meat and lat is (mashed potatoes and meat gravy)
;; #t

(define (member? a lat)
  (cond
    ((null? lat) #f)
    (else (or (eq? a (car lat))
              (member? a (cdr lat))))))

;; What is the value of (member? a lat) where a is liver and lat is (bagels and lox)
;; #f

;; Let's work out why it is #f. What's the first question member? asks?
;; null?

;; (null? lat)
;; No

;; What is the value of (member? a lat) where a is liver and lat is ()
;; #f

;; What is the value of
(or (eq? (car lat) a)
    (member? a (cdr lat)))
;; #f

;; What is the value of (member? a lat) where a is liver and lat is (lox)
;; #f

;; What is the value of
(or (eq ? (car lat) a)
    (member? a (cdr lat)))
;; where a is liver and lat is (and lox)
;; #f

;; What is the value of (member? a lat) where a is liver and lat is (and lox)
;; #f

;; What is the value of
(or (eq? (car lat) a)
    (member? a ( cdr lat)))
;; where a is liver and lat is (bagels and lox)
;; #f

;; What is the value of (member? a lat) where a is liver and lat is (bagels and lox)
;; #f
