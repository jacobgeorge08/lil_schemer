#lang racket

(define (atom? x)
  (and(not (pair? x))
      (not (null? x))))

;; What is (rember* a l) where a is cup and
;; l is ((coffee) cup ((tea) cup) (and (hick)) cup)
;; ((coffee) ((tea)) (and (hick)))

;; What is (rember* a l) where a is sauce and
;; l is (((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))
;; (((tomato)) ((bean)) (and ((flying))))

(define (rember a lat)
  (cond
    ((null? lat)'())
    ((eq? a (car lat)) (cdr lat))
    (else (cons (car lat)
                (rember a (cdr lat))))))

;; Now write rember*
(define (rember* a l)
  (cond
    ((null? l) '())
    ((atom? (car l))
     (cond
       ((eq? a (car l)) (rember* a (cdr l)))
       (else (cons (car l) (rember* a (cdr l))))))
    (else (cons (rember* a (car l)) (rember* a (cdr l))))))

(rember* 'sauce '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce)))

;; (lat? l) where l is (((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))
;; #f

;; Is (car l) an atom
;; where l is (((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))
;; #f because car l is ((tomato sauce))

;; What is (insertR* new old l) where new is roast old is chuck and
;; l is
;; ((how much (wood))
;;  could ((a (wood) chuck))
;;  (((chuck)))
;;  (if (a) ((wood chuck)))
;;  could chuck wood)

;; ((how much (wood))
;;  could ((a (wood) chuck roast))
;;  (((chuck roast)))
;;  (if (a) ((wood chuck roast)))
;;  could chuck roast wood)

;; Now write the function insertR* which inserts the
;; atom new to the right of old regardless of where old occurs
(define (insertR* new old l)
  (cond
    ((null? l) '())
    ((atom? (car l))
     (cond
       ((eq? old (car l)) (cons old (cons new (insertR* new old (cdr l)))))
       (else (cons (car l) (insertR* new old (cdr l))))))
    (else (cons (insertR* new old (car l)) (insertR* new old (cdr l))))))

;; How are insertR * and rember* similar?
;; The both ask 3 questions
;; Is the list null?, is (car list) an atom, else

;; How are insertR * and rember* similar?
;; Each function recurs on the car of its argument when it finds out that the argument's car is a list .

;; How are rember* and multirember different?
;; Works on nested lists vs flat lists

;; How are insertR * and rember* similar?
;; They both recur with the car, whenever the car is a list, as well as with the cdr

;; How are all *-functions similar?
;; They all ask three questions and recur with the car as well as with the cdr, whenever the car is a list.
;; Because all *-functions work on lists that are
;; either empty, an atom consed onto a list , or a list consed onto a list .

;; (occursomething a l)
;; where a is banana
;; and l is
;; ((banana)
;;  (split ((((banana ice)))
;;          (cream (banana))
;;          sherbet))
;;  (banana)
;;  (bread)
;;  (banana brandy))
;; 5

;; What would be a better name for the fucntion above
;; occur*

;; Write occur*
(define (occur* a l)
  (cond
    ((null? l) 0)
    ((atom? (car l))
     (cond
       ((eq? a (car l)) (add1 (occur* a (cdr l))))
       (else (occur* a (cdr l)))))
    (else (+ (occur* a (car l)) (occur* a (cdr l))))))

;; (subst* new old l) where new is orange, old is banana and l is
;; '((banana)
;;   (split ((((banana ice)))
;;           (cream (banana))
;;           sherbet))
;;   (banana)
;;   (bread)
;;   (banana brandy))
;;
;; '((orange)
;;   (split ((((orange ice)))
;;           (cream (orange))
;;           sherbet))
;;   (orange)
;;   (bread)
;;   (orange brandy))

;; Define subst*
(define (subst* new old l)
  (cond
    ((null? l) '())
    ((atom? (car l))
     (cond
       ((eq? old (car l)) (cons new (subst* new old (cdr l))))
       (else (cons (car l) (subst* new old (cdr l))))))
    (else (cons (subst* new old (car l)) (subst* new old (cdr l))))))

;; What is (insertL* new old l) where new is pecker old is chuck and l is
;; '((how much (wood))
;;  could
;;  ((a (wood) chuck))
;;  (((chuck)))
;;  (if (a) ((wood chuck)))
;;  could chuck wood)

;; '((how much (wood))
;;  could
;;  ((a (wood) pecker chuck))
;;  (((pecker chuck)))
;;  (if (a) ((wood pecker chuck)))
;;  could pecker chuck wood)

;; Write insertL*
(define (insertL* new old l)
  (cond
    ((null? l) '())
    ((atom? (car l))
     (cond
       ((eq? old (car l)) (cons new (cons old (insertL* new old (cdr l)))))
       (else (cons (car l) (insertL* new old (cdr l))))))
    (else (cons (insertL* new old (car l)) (insertL* new old (cdr l))))))

;; (member* a l) where a is chips and l is ((potato) (chips ((with) fish) (chips)))
;; #t

;; (member* a l) where a is chips and l is ((potato) (chips ((with) fish) (chips)))
;; #t

;; Write the function (member* a l)
(define (member* a l)
  (cond
    ((null? l) #f)
    ((atom? (car l))
     (or (eq? a (car l)) (member* a (cdr l))))
    (else (or (member* a (car l)) (member* a (cdr l))))))

;; Which chips did it find?
;; First chips ins second list

;; Write member*

;; What is (leftmost l) where l is ((potato) (chips ((with) fish) (chips)))
;; potato

;; What is (leftmost l) where l is (((hot) (tuna (and))) cheese)
;; hot

;; What is (leftmost l) where l is (((() four)) 17 (seventeen))
;; No answer

;; What is (leftmost (quote ()))
;; No answer

;; Can you describe what leftmost does?
;; Picks the leftmost element in a non-empty list of S-expressions

;; Is leftmost a *-function?
;; No because even though it works through nested levels of S-expressions it only operates on the car

;; Does leftmost need to ask questions about all three possible cases?
;; No, it only needs to ask two questions. We agreed that leftmost works on non-empty lists
;; that don't contain empty lists.

;; Write the function leftmost
(define (leftmost l)
  (cond
    ((atom? (car l)) (car l))
    (else (leftmost (car l)))))

;; Do you remember what (or ...) does?
;; Ya. It returns #t if one of the the expressions is #t else #f

;; What is
;; (and (atom? (car l))
;;      (eq? (car l) x))
;; where x is pizza and l is (mozzarella pizza)
;; #f

;; Why is it false?
;; because (eq? (car l) x)) is #f

;; What is
;; (and (atom? (car l))
;;      (eq? (car l) x))
;; where x is pizza and l is ((mozzarella mushroom) pizza)
;; #f

;; Why is it false?
;; Short circuits with the first predicate itself (atom? (car l))

;; Give an example for x and l where
;; (and (atom? (car l))
;;      (eq? (car l) x))
;; is true
;; (define l '(pizza (donuts kebabs)))
;; (define x 'pizza)

;; Put in your own words what (and ...) does
;; Returns true if every clause is true else it stops with the first #f

;; True or false: it is possible that one of the arguments of (and ...) and (or ...) is not considered?
;; Yep. (or  ...) stops with the first #t
;;      (and ...) stops with the first #f


;; (cond ...) also has the property of not considering all of its arguments.
;; Because of this property, however, neither (and ...) nor (or ...) can be defined as functions in terms
;; of (cond ...) , though both (and ...) and (or ...) can be expressed as abbreviations of (cond ...)-expressions:
;; (and alpha beta) = (cond (alpha beta) (else #f))
;; (or alpha beta) =  (cond (alpha #t) (else beta))
;; For (and): If alpha is true, it evals beta and returns the answer
;;            If alpha is false, we return false
;; For (or):  If alpha is true, we return true
;;            Else we eval beta

;; (eqlist? l1 l2) where l1 is (strawberry ice cream) and l2 is (strawberry ice cream)
;; #t

;; (eqlist? l1 l2) where l1 is (strawberry ice cream) and l2 is (strawberry cream ice)
;; #f

;; (eqlist? l1 l2) where l1 is (banana ((split))) and l2 is ((banana) (split))
;; #f

;; (eqlist? l1 l2) where l1 is (beef ((sausage)) (and (soda))) and l2 is (beef ((salami)) (and (soda)))
;; #f

;; (eqlist? l1 l2) where l1 is (beef ((sausage)) (and (soda))) and l2 is (beef ((sausage)) (and (soda)))
;; #t

;; What is eqlist?
;; Takes two S-expressions as arguments, iterates through them and checks if every element for l1 matches l2

;; How many questions will eqlist? have to ask about its arguments?
;; 9

;; Why are there 9 questions
;; (L1 is empty, L1 is atom, L1 is list)
;; multiplied by
;; (L2 is empty, L2 is atom, L2 is list)

;; Write eqlist? using eqan?
(define (eqan? a1 a2)
  (cond
    ((and (number? a1) (number? a2)) (= a1 a2))
    ((or (number? a1) (number? a2)) #f)
    (else (eq? a1 a2))))

(define (my_eqlist? l1 l2)
  (cond
    ((null? l1) (null? l2))
    ((atom? (car l1))
     (cond
       ((null? l2) #f)
       ((atom? (car l2))
        (and (eqan? (car l1) (car l2))
             (my_eqlist? (cdr l1) (cdr l2))))
       (else #f)))
    (else
     (cond
       ((null? l2) #f)
       ((atom? (car l2)) #f)
       (else (and
              (my_eqlist? (car l1) (car l2))
              (my_eqlist? (cdr l1) (cdr l2))))))))

(define book_eqlist? (lambda (l1 l2)
                       (cond
                         ((and (null? l1) (null? l2)) #t)
                         ((and (null? l1) (atom? (car l2))) #f)
                         ((null? l1) #f)
                         ((and (atom? (car l1)) (null? l2)) #f)
                         ((and (atom? (car l1))
                               (atom? (car l2)))
                          (and (eqan? (car l1) (car l2))
                               (book_eqlist? (cdr l1) (cdr l2))))
                         ((atom? (car l1)) #f)
                         ((null? l2) #f)
                         ((atom? (car l2)) #f)
                         (else
                          (and (book_eqlist? (car l1) (car l2))
                               (book_eqlist? (cdr l1) (cdr l2)))))))

;; Is it okay to ask (atom? (car l2)) in the second question?
;; Yes because its not null so we do need to check

;; And why is the third question (null? l1)
;; The other two conditions were checked when (null? l1) which means
;; this last check is to see if l1 is null and l2 is a nested list

;; True or false: if the first argument is '() eqlist? responds with #t in only one case.
;; True

;; Does this mean that the questions (and (null? l1) (null? l2)) and (or (null? l1) (null? l2))
;; suffice to determine the answer in the first three cases?
;; Yes


;; Rewrite eqlist
(define book_eqlist2? (lambda (l1 l2)
                        (cond
                          ((and (null? l1) (null? l2)) #t)
                          ((or (null? l1) (null? l2)) #f)
                          ((and (atom? (car l1)) (null? l2)) #f)
                          ((and (atom? (car l1)) (atom? (car l2)))
                           (and (eqan? (car l1) (car l2))
                                (book_eqlist2? (cdr l1) (cdr l2))))
                          ((atom? (car l1)) #f)
                          ((null? l2) #f)
                          ((atom? (car l2)) #f)
                          (else
                           (and (book_eqlist2? (car l1) (car l2))
                                (book_eqlist2? (cdr l1) (cdr l2)))))))

;; What is an S-expression
;; An S-expression is either an atom or a (even empty) list of S-expressions

;; How many questions does equal? ask to determine whether two S-expressions are the same?
;; Four. The first argument may be an atom or a list of S-expressions at the same time as
;; the second argument may be an atom or a list of S-expresssions.

;; Write equal?
(define (equal? s1 s2)
  (cond
    ((and (atom? s1) (atom? s2)) (eqan? s1 s2))
    ((or (atom? s1) (atom? s2)) #f)
    (else (book_eqlist2? s1 s2))))

;; Why is the second question (atom? s1)
;; Because BOTH s1 and s2 are not atoms

;; And why is the third question (atom? s2)
;; Same as above

;; Can we summarize the second question and the third question as (or (atom? s1) (atom? s2))
;; Yes. Thats how I did it

;; Does equal? ask enough questions?
;; I think so

;; Now rewrite eqlist? using equal?
(define (eqlist? l1 l2)
  (cond
    ((and (null? l1) (null? l2)) #t)
    ((or (null? l1) (null? l2)) #f)
    (else
     (and (equal? (car l1) (car l2))
          (eqlist? (cdr l1) (cdr l2))))))

;; Here is rember after we replace lat by a list l of S-expressions and a by any S-expression
;; (define (rember s l)
;;   (cond
;;     ((null? l) '())
;;     ((atom? (car l))
;;      (cond
;;        ((equal? (car l) s) (cdr l))
;;        (else (cons (car l)
;;                    (rember s (cdr l))))))
;;     (else (cond
;;             ((equal? (car l) s) (cdr l))
;;             (else (cons (car l)
;;                         (rember s
;;                                 (cdr l))))))))
;; Can we simplify it ?
;; Yup
;; (define (remberS s l)
;;   (cond
;;     ((null? l) '())
;;     (else
;;      (cond
;;        ((equal? (car l) s) (cdr l))
;;        (else (cons (car l)
;;                    (remberS s (cdr l))))))))

;; And how does that differ?
;; If the list isnt null, we use equal to check if the S-expressions are the same

;; Is rember a "star" function now?
;; Because rember recurs with the cdr of l only.

;; Can rember be further simplified?
;; If the book is asking, it must be true

;; Do it
(define (remberS s l)
  (cond
    ((null? l) '())
    ((equal? (car l) s) (cdr l))
    (else (cons (car l) (remberS s (cdr l))))))

;; Does it look simpler
;; Yes

;; And does it work just as well?
;; I think so

;; Simplify insertL*
;; Not doable

;; Can all functions that use eq? and = be generalized by replacing eq? and =
;; by the function equal?

;; Yes. Although the book mentions it doesnt work for eqan. If we define eqan in
;; terms of equal they will just keep calling each other infinitely. Works for
;; every other case though

;; (define (equal? s1 s2)
;;   (cond
;;     ((and (atom? s1) (atom? s2)) (eqan? s1 s2))
;;     ((or (atom? s1) (atom? s2)) #f)
;;     (else (book_eqlist2? s1 s2))))

;; (define (eqan? a1 a2)
;;   (cond
;;     ((and (number? a1) (number? a2)) (= a1 a2))
;;     ((or (number? a1) (number? a2)) #f)
;;     (else (eq? a1 a2))))
