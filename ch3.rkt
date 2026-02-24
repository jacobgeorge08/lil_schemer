#lang racket

;; What is (rember a lat) where a is mint and lat is (lamb chops and mint jelly)
;; (lamb chops and jelly)

;; (rember a lat) where a is mint and lat is (lamb chops and mint flavored mint jelly)
;; (lamb chops and flavored mint jelly)

;; (rember a lat) where a is toast and lat is (bacon lettuce and tomato)
;; (bacon lettuce and tomato)

;; (rember a lat) where a is cup and lat is (coffee cup tea cup and hick cup)
;; (coffee tea cup and hick cup)

;; What does (rember a lat) do?
;; Find takes two arguments an atom and a lat and removes the first matching atom from the list

;; What steps should we use to do this?
;; Check if the list is null? and if it is return '()

;; How do we ask if a is the same as (car lat)
;; (eq? (car lat) a)

;; What would be the value of (rember a lat) if a were the same as (car lat)
;; (cdr lat)

;; What do we do if a is not the same as (car lat )
;; We want to keep (car lat), but also find out if a is somewhere in the rest of the lat .

;; How do we remove the first occurrence of a in the rest of lat
;; (rember a (cdr lat))

;; My version of rember without the nested conds
(define (rember a lat)
  (cond
    ((null? lat)'())
    ((eq? a (car lat)) (cdr lat))
    (else (cons (car lat)
                (rember a (cdr lat))))))

;; What is (firsts l) where
;; l is ((apple peach pumpkin) (plum pear cherry) (grape raisin pea) (bean carrot eggplant))
;; (apple plum grape bean)

;; What is (firsts l) where l is ((a b) (c d) (e f))
;; (a c e)

;; What is (firsts l) where l is ()
;; ()

;; What is (firsts l) where l is ((five plums) (four) (eleven green oranges))
;; (five four eleven)

;; What is (firsts l) where l is (((five plums) four) (eleven green oranges) ((no) more))
;; ((five plums) eleven (no))

;; In your own words, what does (firsts l) do?
;; It takes as an argument a list of lists and returns the a list of the first S-Expr of
;; the sublists from the argument

(define (firsts l)
  (cond
    ((null? l) '())
    (else (cons (car (car l)) (firsts (cdr l))))))

;; What is (insertR new old lat) where new is topping old is fudge and
;; lat is (ice cream with fudge for dessert)
;; (ice cream with fudge topping for dessert)

;; (insertR new old lat) where new is jalapeno old is and and lat is (tacos tamales and salsa)
;; (tacos tamales and jalapeno salsa)

;; (insertR new old lat) where new is e old is d and lat is (a b c d f g d h)
;; (a b c d e f g d h)

;; In your own words, what does  (insertR new old lat) do?
;; insertR takes a two atoms and a list of atoms and adds the new add atom after the first
;; occurence of old

(define (insertR new old lat)
  (cond
    ((null? lat) '())
    ((eq? old (car lat))
     (cons old (cons new (cdr lat))))
    (else (cons (car lat) (insertR new old (cdr lat))))))

;; Now try insertL
(define (insertL new old lat)
  (cond
    ((null? lat) '())
    ((eq? old (car lat))
     (cons new lat))
    (else (cons (car lat) (insertL new old (cdr lat))))))

;; Now try subst (subst new old lat) replaces the first occurrence of old in the lat with new

(define (subst new old lat)
  (cond
    ((null? lat) '())
    ((eq? old (car lat))
     (cons new (cdr lat)))
    (else (cons (car lat) (subst new old (cdr lat))))))


;; (subst2 new o1 o2 lat) replaces either the first o1 or the first o2 by new
;; For example, where new is vanilla o1 is chocolate o2 is banana and
;; lat is (banana ice cream with chocolate topping)
;; the value is (vanilla ice cream with chocolate topping)

(define (subst2 new o1 o2 lat)
  (cond
    ((null? lat) '())
    ((or (eq? o1 (car lat)) (eq? o2 (car lat)))
     (cons new (cdr lat)))
    (else (cons (car lat) (subst2 new o1 o2 (cdr lat))))))

;; Write the function multirember which returns the lat with all occurrences of a removed
;; (define (rember a lat)
;;   (cond
;;     ((null? lat) '())
;;     ((eq? a (car lat)) (cdr lat))
;;     (else (cons (car lat) (rember a (cdr lat))))))

(define (multirember a lat)
  (cond
    ((null? lat) '())
    ((eq? a (car lat))
     (multirember a (cdr lat)))
    (else (cons (car lat)
                (multirember a (cdr lat))))))

;; Now write the function multiinsertR
;; Every time you come across an old, you insert a new to the right of it

(define (multiinsertR new old lat)
  (cond
    ((null? lat) '())
    ((eq? old (car lat))
     (cons old (cons new (multiinsertR new old (cdr lat)))))
    (else (cons (car lat) multiinsertR new old (cdr lat)))))

;; Is this wrong? Why
;; (define (multiinsertL new old lat)
;;   (cond
;;     ((null? lat) (quote ()))
;;     (else
;;      (cond
;;        ((eq? (car lat) old)
;;         (cons new (cons old (multiinsertL new old lat))))
;;        (else (cons (car lat) (multiinsertL new old (cdr lat))))))))
;; Yes because we get infinite recursion by repeatedly calling multiinsert on the same lat

(define (multiinsertL new old lat)
  (cond
    ((null? lat) (quote ()))
    (else
     (cond
       ((eq? (car lat) old)
        (cons new (cons old (multiinsertL new old (cdr lat)))))
       (else (cons (car lat) (multiinsertL new old (cdr lat))))))))
(multiinsertL 'fried 'fish '(chips and fish or fish and fried))

;; Now write the function multisubst
(define (multisubst new old lat)
  (cond
    ((null? lat) '())
    ((eq? old (car lat))
     (cons new (multisubst new old (cdr lat))))
    (else (cons (car lat) (multisubst new old (cdr lat))))))
