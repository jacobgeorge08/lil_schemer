#lang racket

(define (atom? x)
  (not (pair? x)))

;; Is 1 an arithmetic expression?
;; Yea

;; Is 3 an arithmetic expression?
;; Yes

;; Is 1 + 3 an arithmetic expression?
;; Yes

;; Is 1 + 3 * 4 an arithmetic expression?
;; Yes

;; Is cookie an arithmetic expression?
;; Maybe
;; Yes it is

;; And, what about 3 ^ y + 5
;; Yes

;; What is an arithmetic expression in your words?
;; An arithmetic expression is either an atom (including numbers), or two arithmetic
;; expressions combined by + , * , or ^

;; What is (quote a)
;; 'a

;; What is (quote +)
;; '+

;; What does (quote *) stand for?
;; '*

;; Is (eq? (quote a) y) true or false where y is a
;; #f

;; Is (eq? x y) true or false where x is a and y is a
;; #t

;; Is (n + 3) an arithmetic expression?
;; No because our definition of arithmetic expressions dont invole parens

;; Could we think of (n + 3) as an arithmetic expression?
;; If we ignore the parens, yeah

;; What would you call ( n + 3)
;; We call it a representation for n + 3.

;; Why is ( n + 3) a good representation?
;; Because it is an S-expression

;; True or false: (numbered? x) where x is 1
;; #t

;; How do you represent 3 + 4 * 5
;; (3 + 4 * 5)
;; Not entirely sure why the book does it like this but ig we'll see soon

;; True or false: (numbered? y) where y is (3 + (4 ^ 5))
;; #t

;; True or false: (numbered? z) where z is (2 * sausage)
;; False

;; What is numbered ?
;; It is a function that determines whether a representation of an arithmetic expression
;; contains only numbers besides the + , x , and ^

;; Now can you write a skeleton for numbered ?
;; cons through the expression and ask if its a number + or * or ^

;; What is the first question?
;; (atom? aexp)

;; What is (eq? (car (cdr aexp)) (quote +))
;; Is the 2nd element a +

;; What is the third question
;; (eq? (car (cdr aexp)) (quote *)) is perfect

;; And you must know the fourth one.
;; (eq? (car (cdr aexp)) (quote ^)) is perfect

;; Should we ask another question about aexp
;; That looks like its about it

;; Why do we ask four, instead of two, questions about arithmetic expressions?
;; After all, arithmetic expressions like (1 + 3) are lats.
;; Because we consider (1 + 3) as a representation of an arithmetic expression in
;; list form , not as a list itself. An arithmetic expression is either a number, or
;; two arithmetic expressions combined by + , x , or ^

;; Why do we ask (number? aexp) when we know that aexp is an atom?
;; Because arithmetic operation can only have numbers or + ^ * as their atoms

;; What do we need to know if the aexp consists of two arithmetic expressions combined by +
;; We need to find out whether the two subexpressions are numbered

;; In which position is the first subexpression?
;; (car aexp)

;; In which position is the second subexpression?
;; (car (cdr (cdr aexp)))

;; So what do we need to ask?
;; (numbered? (car aexp)) and (numbered? (car (cdr (cdr aexp))))

;; What is the second answer?
;; (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp)))))

;; Try numbered? again.
;; (define (numbered? aexp)
;;   (cond
;;     ((atom? aexp) (number? aexp))
;;     ((eq? (car (cdr aexp)) '+)
;;      (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp))))))
;;     ((eq? (car (cdr aexp)) '*)
;;      (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp))))))
;;     ((eq? (car (cdr aexp)) '^)
;;      (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp))))))))

;; Since aexp was already understood to be an arithmetic expression,
;; could we have written numbered? in a simpler way?
;; Yes
(define (numbered? aexp)
  (cond
    ((atom? (aexp)) (number? aexp))
    (else
     (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp))))))))

;; Why can we simplify?
;; Because we know we've got the function right .

;; What is (value u) where u is 13
;; 13

;; (value x) where x is (1 + 3)
;; 4

;; (value y) where y is (1 + (3 ^ 4) )
;; 82

;; (value z) where z is cookie
;; No answer

;; (value nexp) returns what we think is the natural value of a numbered arithmetic
;; expression.
;; Uhh okay


;; How many questions does value ask about nexp
;; Four

;; Now let's attempt to write value
;; (define value (lambda (nexp)
;;                 (cond
;;                   ((atom? nexp) ...)
;;                   ((eq? (car (cdr nexp))(quote +)) ...)
;;                   ((eq? (car (cdr nexp))(quote x )) ...)
;;                   (else ...))))

;; What is the natural value of an arithmetic expression that is a number?
;; The number itself

;; What is the natural value of an arithmetic expression that consists of two arithmetic
;; expressions combined by +
;; The sum

;; Can you think of a way to get the value of the two subexpressions in (1 + (3 x 4))
;; applying value to 1, and applying value to (3  4)

;; Give value another try
;; (define value
;;   (lambda (nexp)
;;     (cond
;;       ((atom? nexp) nexp)
;;       ((eq? (car (cdr nexp)) '+)
;;        (+ (value (car nexp))
;;           (value (car (cdr (cdr nexp))))))
;;       ((eq? (car (cdr nexp)) '*)
;;        (* (value (car nexp))
;;           (value (car (cdr (cdr nexp))))))
;;       (else
;;        (expt (value (car nexp))
;;              (value
;;               (car (cdr (cdr nexp)))))))))

;; Can you think of a different representation of arithmetic expressions?
;; Prefix. Postfix

;; Could (3 4 +) represent 3 + 4
;; Yah

;; Could (+ 3 4)
;; Yah

;; Or (plus 3 4 )
;; Also yes

;; Is (+ (* 3 6) (^ 8 2)) a representation of an arithmetic expression?
;; Yes

;; Try to write the function value for a new kind of arithmetic expression that is either
;; - a number
;; - a list of the atom + followed by two arithmetic expressions
;; - a list of the atom * followed by two arithmetic expressions
;; - a list of the atom ^ followed by two arithmetic expressions
;; (define (value nexp)
;;   (cond
;;     ((atom? nexp) nexp)
;;     ((eq? (car nexp) '+)
;;      (+ (value (cdr nexp))
;;         (value (cddr nexp))))
;;     ((eq? (car nexp) '*)
;;      (* (value (cdr nexp))
;;         (value (cddr nexp))))
;;     (else
;;      (expt (value (cdr nexp))
;;            (value
;;             (cddr nexp))))))
;; This is wrong apparently

;; Let 's try an example.
;; (+ 1 3)

;; (atom? nexp) where nexp is (+ 1 3)
;; No

;; (eq? (car nexp) (quote +)) where nexp is (+ 1 3)
;; Yah

;; What is (cdr nexp) where nexp is (+ 1 3)
;; (1 3)

;; (1 3) is not our representation of an arithmetic expression.

;; How can we get the first subexpression of a representation of an arithmetic expression?
;; cadr nexp

;; Is (cdr (cdr nexp)) an arithmetic expression where nexp is (+ 1 3)
;; No. Its (3) which is again not an arithemetic expression

;; Again, we were thinking of the list (+ 1 3) instead of the representation of an arithmetic
;; expression.
;; Need to take the caddr

;; What do we mean if we say the car of the cdr of nexp
;; The first subexpression of the representation of an arithmetic expression.

;; Let's write a function 1st-sub-exp for arithmetic expressions.
;; (define 1st-sub-exp
;;   (lambda (aexp)
;;     (cond
;;       (else (car (cdr aexp))))))

;; Why do we ask else
;; Because the first question i s also the last question .

;; Can we get by without (cond ...) if we don't need to ask questions?
;; Yes
(define (1st-sub-exp aexp)
  (car (cdr aexp)))

;; Write 2nd-sub-exp for arithmetic expressions
(define (2nd-sub-exp aexp)
  (caddr aexp))

;; Finally, let's replace (car nexp) by (operator nexp)
(define (operator aexp)
  (car aexp))

;; Rewrite Value
(define (value nexp)
  (cond
    ((atom? nexp) nexp)
    ((eq? (operator nexp) '+)
     (+ (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))
    ((eq? (operator nexp) '*)
     (* (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))
    (else
     (expt (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))))

;; Can we use this value function for the first representation of arithmetic expressions in
;; this chapter?

;; Yes, by changing 1st-sub-exp and operator
;; (define (1st-sub-exp aexp)
;;   (car aexp))
;; (define (operator aexp)
;;   (car (cdr aexp)))

;; Have we seen representations before?
;; Numbers etc

;; For what entities have we used representations?
;; Truth-values! Numbers!

;; What else could we have used?
;; four

;; Do you remember how many primitives we need for numbers?
;;  Four. number?, zero?, add1, and sub1

;; Let's try another representation for numbers. How shall we represent zero now?
;; ()

;; How is one represented?
;; (())

;; How is two represented?
;; (() ())

;; What about three?
;; (() () ())

;; Write a function to test for zero.
;; (define (zero? n)
;;   (null? n))

;; Can you write a function that is like add1
;; (define (add1 n)
;;   (cons '() n))

;; What about sub1
;; (define (sub1 n)
;;   (cdr n))

;; Is this correct?
;; I think so

;; What is (sub1 n) where n is '()
;; No answer

;; Rewrite + using this representation
;; (define (+ x y)
;;   (cond
;;     ((zero? y) x)
;;     (else (add1 (+ x (sub1 y))))))

;; Recall lat ?
;; Yah
(define (lat? l)
  (cond
    ((null? l) #t)
    ((atom? (car l))(lat? (cdr l)))
    (else #f )))

;; Do you remember what the value of (lat ? ls ) is where ls is (1 2 3)
;; #t

;; What is (1 2 3) with our new numbers?
;; ((()) (() ()) (() () ()))
;; ((()) (() ()) (() () ()))

;; What is (lat? ls) where ls is  ((()) (() ()) (() () ()))
;; #f because atom? for car fails

;; Is that bad?
;; You must beware of shadows // Line from the book. Idk what that means lol


