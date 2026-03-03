#lang racket

;; --- COOKIE RECIPIE ---
;; (define cookies
;;   (bake
;;    ('(350 degrees))
;;    ('(12 minutes))
;;    (mix
;;     ('(walnuts 1 cup))
;;     ('(chocolate-chips 16 ounces))
;;     (mix
;;      (mix
;;       ('(flour 2 cups))
;;       ('(oatmeal 2 cups) )
;;       ('(salt .5 teaspoon) )
;;       ('(baking-powder 1 teaspoon))
;;       ('(baking-soda 1 teaspoon) ) )
;;      (mix
;;       ('(eggs 2 large))
;;       ('(vanilla 1 teaspoon))
;;       (cream
;;        ('(butter 1 cup))
;;        ('(sugar 2 cups))))))))
;; Personally oatmeal in cookies sounds terrible but thats just me

(define (atom? x)
  (not (pair? x)))

(define (member? a lat)
  (cond
    ((null? lat) #f)
    (else (or (eq? a (car lat))
              (member? a (cdr lat))))))

(define (multirember a lat)
  (cond
    ((null? lat) '())
    ((eq? a (car lat))
     (multirember a (cdr lat)))
    (else (cons (car lat) (multirember a (cdr lat))))))

;; Is this a set? (apple peaches apple plum)
;; No. Coz apple twice

;; True or false: (set? lat) where lat is (apples peaches pears plums)
;; #t

;; How about (set? lat) where lat is ()
;; #t

;; Try to write set?
;; (define (set? lat)
;;   (cond
;;     ((null? lat) #t)
;;     (else
;;      (cond
;;        ((member? (car lat) (cdr lat)) #f)
;;        (else (set? (cdr lat)))))))

;; Simplify
(define (set? lat)
  (cond
    ((null? lat) #t)
    ((member? (car lat) (cdr lat)) #f)
    (else (set? (cdr lat)))))

;; Does this work for the example (apple 3 pear 4 9 apple 3 4)
;; ya

;; Were you surprised to see the function member? appear in the definition of set?
;; Not really

;; What is (makeset lat) where lat is (apple peach pear peach plum apple lemon peach)
;; (apple peach pear plum lemon)

;; Try to write makeset using member ?
;; (define (makeset lat)
;;   (cond
;;     ((null? lat) '())
;;     ((member? (car lat) (cdr lat)) (makeset (cdr lat)))
;;     (else (cons (car lat) (makeset (cdr lat))))))

;; Are you surprised to see how short this is?
;; Not really

;; (makeset lat) where lat is (apple peach pear peach plum apple lemon peach)
;; (pear plum apple lemon peach)

;; Try to write makeset using multirember
(define (makeset lat)
  (cond
    ((null? lat) '())
    (else (cons (car lat) (makeset (multirember (car lat) (cdr lat)))))))

;; What is the result of (makeset lat) using this second definition
;; where lat is (apple peach pear peach plum apple lemon peach)
;; (apple peach pear plum lemon)

;; Describe in your own words how the second definition of makeset works
;; We first take the car of the list and then we use multirember
;; to remove other instances of the car from the cdr of the list,
;; we then call makeset on this cdr

;; Does the second makeset work for the example (apple 3 pear 4 9 apple 3 4)
;; Yes but only if multirember is written with equal? isntead of eq?

;; What is (subset? set1 set2) where set1 is (5 chicken wings)
;; and set2 is (5 hamburgers 2 pieces fried chicken and light duckling wings)
;; #t because all elements of set1 are in set2

;; What is (subset? set1 set2) where set1 is (4 pounds of horseradish) and
;; set2 is (four pounds chicken and 5 ounces horseradish)
;; #f

;; Write subset?
(define (subset? s1 s2)
  (cond
    ((null? s1) #t)
    ((member? (car s1) s2)
     (subset? (cdr s1) s2))
    (else #f)))

;; Try to write subset? with (and ...)
(define (subset-and? s1 s2)
  (cond
    ((null? s1) #t)
    (else (and (member? (car s1) s2) (subset-and? (cdr s1) s2)))))

;; What is (eqset? set1 set2) where set1 is (6 large chickens with wings)
;; and set2 is (6 chickens with large wings)
;; #t

;; Write eqset?
(define (rember a lat)
  (cond
    ((null? lat)'())
    ((eq? a (car lat)) (cdr lat))
    (else (cons (car lat)
                (rember a (cdr lat))))))

(define (eqset? s1 s2)
  (cond
    ((and (null? s1) (null? s2)) #t)
    ((or (null? s1) (null? s2)) #f)
    ((member? (car s1) s2)
     (eqset? (rember (car s1) s1) (rember (car s1) s2)))
    (else #f)))

;; (define (book-eqset? s1 s2)
;;   (cond
;;     ((subset? s1 s2) (subset? s2 s1))
;;     (else #f)))

;; Can you write eqset ? with only one cond-line?
(define (book-eqset? s1 s2)
  (and (subset? s1 s2) (subset? s2 s1)))

;; What is (intersect? set1 set2) where
;; set1 is (stewed tomatoes and macaroni) and
;; set2 is (macaroni and cheese)
;; #t because at least one element of s1 is in s2

;; Define the function intersect
;; (define (intersect? s1 s2)
;;   (cond
;;     ((null? s1) #f)
;;     ((member? (car s1) s2) #t)
;;     (else (intersect? (cdr s1) s2))))

;; Try writing intersect? with (or ...)
(define (intersect? s1 s2)
  (cond
    ((null? s1) #f)
    ((or (member? (car s1) s2)
         (intersect? (cdr s1) s2)))))

;; What is (intersect set1 set2) where
;; set1 is (stewed tomatoes and macaroni)
;; set2 is (macaroni and cheese)
;; (and macaroni)

;; Now you can write the short version of intersect
(define (intersect set1 set2)
  (cond
    ((null? set1) '())
    ((member? (car set1) set2)
     (cons (car set1) (intersect (cdr set1) set2)))
    (else (intersect (cdr set1) set2))))

;; What is (union set1 set2) where
;; set1 is (stewed tomatoes and macaroni casserole)
;; set2 is (macaroni and cheese)
;; (stewed tomatoes casserole macaroni and cheese)

;; Write union
(define (union s1 s2)
  (cond
    ((null? s1) s2)
    (else (makeset (cons (car s1) (union (cdr s1) s2))))))

(define book-union (lambda (set1 set2)
                     (cond
                       ((null? set1 ) set2 )
                       ((member? (car set1) set2) (book-union (cdr set1) set2))
                       (else (cons (car set1) (book-union (cdr set1) set2))))))

;; What is this function
(define xxx (lambda (set1 set2)
              (cond
                ((null? set1) '())
                ((member? (car set1) set2)
                 (xxx (cdr set1) set2))
                (else (cons (car set1)
                            (xxx (cdr set1) set2))))))
;; Difference aka atoms that are in set1 but not in set2

;; What is (intersectall l-set) where l-set is ((a b c) (c a d e) (e f g h a b))
;; (a)

;; What is (intersectall l-set) where l-set is
;; ((6 pears and)
;;  (3 peaches and 6 peppers)
;;  (8 pears and 6 plums)
;;  (and 6 prunes with some apples))
;; (6 and)

;; Write intersectall assuming that the list of sets is non-empty.

(define (intersectall l)
  (cond
    ((null? (cdr l)) (car l))
    (else (intersect (car l) (intersectall (cdr l))))))

;; Is this a pair? (pear pear)
;; Yes

;; Is this a pair? ((2) (pair))
;; Yes because it is a list of two S-expressions or atoms

;; (a-pair? l) where l is (full (house))
;; Yes because again it is a list of two S-expressions.

;; Define a-pair?
(define (a-pair? x)
  (cond
    ((atom? x) #f)
    ((null? x) #f)
    ((null? (cdr x)) #f)
    ((null? (cdr (cdr x))) #t)
    (else #f)))

;; How can you refer to the first S-expression of a pair?
;; (car x)

;; How can you refer to the second S-expression of a pair?
;; (cadr x)

;; How can you build a pair with two atoms?
;; (cons atom1 (cons atom2 '()))

;; How can you build a pair with two S-expressions?
;; You cons the first one onto the cons of the second one onto () ie
;; (cons x1 (cons x2 '()))

;; Did you notice the differences between the last two answers?
;; No :P

;; Rewrite first, second and build as one liners
;; (define first (lambda (p)
;;                 (cond
;;                   (else (car p)))))
;; (define second
;;   (lambda (p)
;;     (cond
;;       (else (car (cdr p))))))
;; (define build
;;   (lambda (s1 s2)
;;     (cond
;;       (else (cons s1
;;                   (cons s2 '()))))))
;; Used to improve readbility
(define (first p)
  (car p))
(define (second p)
  (cadr p))
(define (build s1 s2)
  (cons s1 (cons s2 '())))

;; Can you write third as a one-liner?
(define (third l)
  (caddr l))

;; Is l a rel where l is (apples peaches pumpkin pie)
;; No, since l is not a list of pairs. We use rel to stand for relation .

;; Is l a rel where l is
;; ((apples peaches)
;;  (pumpkin pie)
;;  (apples peaches))
;; No because although it is a list of pairs, it is not a set of pairs

;; Is l a rel where l is ((apples peaches) (pumpkin pie))
;; I think so coz it is a list of pairs that are sets

;; Is l a rel where l is ((4 3) (4 2) (7 6) (6 2) (3 4))
;; Yes

;; Is rel a fun where rel is ((4 3) (4 2) (7 6) (6 2) (3 4))
;; No we use fun to stand for function.
;; Functions are one to mappings of inputs and outputs and we have two pairs
;; that have the first element 4 with different second elements

;; What is (fun? rel) where rel is ((8 3) (4 2) (7 6) (6 2) (3 4))
;; #t because (firsts rel) is a set

;; What is (fun? rel) where rel is ((d 4) (b 0) (b 9) (e 5) (g 4) )
;; #f since b is repeated

;; Write fun? with set? and firsts
(define (firsts l)
  (cond
    ((null? l) '())
    (else (cons (car (car l)) (firsts (cdr l))))))

(define (fun? rel)
  (set? (firsts rel)))

;; How do we represent a finite function?
;; For us, a finite function is a list of pairs in which no first element
;; of any pair is the same as any other first element .

;; What is (revrel rel) where
;; rel is ((8 a) (pumpkin pie) (got sick))
;; ((a 8) (pie pumpking) (got sick))

;; What is actually the diff between rel and fun
;; Both are a list pairs that are sets.
;; The difference is fun cannot have the same first input repeated twice.
;; We would just get the same output(2nd element) and it wouldnt be a set.

;; You can now write revrel
;; (define (revrel l)
;;   (cond
;;     ((null? l) '())
;;     (else
;;      (cons (build (second (car l)) (first (car l))) (revrel (cdr l))))))

;; Would this be correct?
;; (define revrel (lambda (rel)
;;                  (cond
;;                    ((null? rel) '())
;;                    (else (cons (cons
;;                                 (car (cdr (car rel)))
;;                                 (cons (car (car rel))
;;                                       (quote ())))
;;                                (revrel (cdr rel)))))))
;; Yeah. Its the same fucntion as ours without the helpers build, first and second.
;; Also yes I see how readability really helps


;; Suppose we had the function revpair that reversed the two components of a pair like
(define revpair (lambda (pair)
                  (build (second pair) (first pair))))

(define (revrel l)
  (cond
    ((null? l) '())
    (else
     (cons (revpair (car l)) (revrel (cdr l))))))

;; Can you guess why fun is not a fullfun where fun is ((8 3) (4 2) (7 6) (6 2) (3 4))
;; b) Both 4 and 6 have the output 2

;; Why is #t the value of (fullfun? fun) where fun is ((8 3) (4 8) (7 6) (6 2) (3 4))
;; Distinct first and second elements

;; What is (fullfun? fun) where fun is
;; ((grape raisin)
;;  (plum prune)
;;  (stewed prune))
;; #f

;; What is (fullfun? fun) where fun is
;; ((grape raisin)
;;  (plum prune)
;;  (stewed grape))
;; #t

;; Define fullfun?
(define (seconds l)
  (cond
    ((null? l) '())
    (else (cons (second (car l)) (seconds (cdr l))))))

(define (fullfun? l)
  ((set? (seconds l))))

;; What is another name for fullfun?
;; one-to-one?

;; Can you think of a second way to write one-to-one ?
;; (define one-to-one? (lambda (fun)
;;                       (fun? (revrel fun))))

;; Is ((chocolate chip) (doughy cookie)) a one-to-one function?
;; Yah

