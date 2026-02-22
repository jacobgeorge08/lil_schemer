#lang racket

;; Is it true that this is an atom?
atom1
;; yes

;; Is it true that this is an atom?
turkey
;; yes

;; Is it true that this is an atom?
1492
;; yes

;; Is it true that this is an atom?
u
;; yes

;; Is it true that this is an atom?
*abc$
;; yes

;; Is it true that this is a list?
(atom)
;;yes

;; Is it true that this is a list?
(atom turkey or)
;; yes

;; Is it true that this is a list?
(atom turkey) or
;; no

;; Is it true that this is a list?
((atom turkey) or)
;; yes

;; Is it true that this is an S-expression?
xyz
;; yes

;; Is it true that this is an S-expression?
(x y z)
;; yes

;; Is it true that this is an S-expression?
((x y) z)
;; yes

;; Is it true that this is a list?
(how are you doing so far)
;; yes

;; How many S-expressions are in the list and what are they?
(how are you doing so far)
;; 6

;; Is it true that this is a list?
(((how) are) ((you) (doing so)) far)
;; yes

;; How many S-expressions are in the list and what are they?
(((how) are) ((you) (doing so)) far)
;; 3

;; Is it true that this is a list?
()
;; yes

;; Is it true that this is an atom?
()
;; no

;; Is it true that this is a list?
(() () () ())
;; yes

;; What is the car of l where l is the argument
(a b c)
;; a

;; What is the car of l where l is
((a b c) x y z)
;; (a b c)

;; What is the car of l where l is
hotdog
;; nothing. l is an atom

;; What is the car of l where l is
()
;; nothing. l is an empty list

;; What is the car of l where l is
(((hotdogs)) (and) (pickle) relish)
;; ((hotdogs))

;; What is (car l) where l is
(((hotdogs)) (and) (pickle) relish)
;; ((hotdogs))

;; What is (car (car l)) where l is
(((hotdogs)) (and))
;; (hotdogs)

;; What is the cdr of l where l is
(a b c)
;; (b c)

;; What is the cdr of l where l is
((a b c) x y z)
;; (x y z)

;; What is the cdr of l where l is
(hamburger)
;; ()

;; What is (cdr l) where l is
((x) t r)
;; (t r)

;; What is (cdr a) where a is
hotdogs
;; Nothing because a is an atom

;; What is (cdr l) where l is
()
;; Nothing. The empty list doesnt have a car or a cdr

;; What is (car (cdr l)) where l is
((b) (x y) ((c)))
;; (x y)

;; What is (cdr (cdr l)) where l is
((b) (x y) ((c)))
;; (((c)))
;; Its not ((c)) coz we are dropping the first element when we cdr not pulling out the sub-list

;; What is (cdr (car l)) where l is
(a (b (c)) d)
;; Nothing because there is no sublist for a

;; What does car take as an argument?
;; A non empty list

;; What does cdr take as an argument?
;; A non empty list

;; What is the cons of the atom a and the list l where a is peanut and l is (butter and jelly)
(cons a l)
;; (peanut butter and jelly)

;; What is the cons of s and l where s is (banana and) and l is (peanut butter and jelly)
((banana and) peanut butter and jelly)

;; What is (cons s l) where s is ((help) this) and l is (is very ((hard) to learn))
(((help) this) is very ((hard) to learn))

;; What does cons take as its arguments?
;; Any S-Expressions and a list

;; What is (cons s l) where s is (a b (c)) and l is ()
;; ((a b (c)))

;; What is (cons s l) where s is a and l is ()
;; (a)

;; What is (cons s l) where s is ((a b c)) and l is b
;; Nothing because b is not a list

;; What is (cons s l) where s is a and l is b
;; No answer because l must be a list

;; What is (cons s (car l)) where s is a and l is ((b) c d)
;; (a b)

;; What is (cons s (cdr l)) where s is a and l is ((b) c d )
;; (a c d)

;; Is it true that the list l is the null list where l is ()
;; Ya

;; What is (null? (quote ()))
;; #t

;; Is (null? l) true or false where l is (a b c)
;; #f

;; Is (null? a) true or false where a is spaghetti
;; No answer because null is only defined on lists

;; Is it true or false that s is an atom where s is Harry
;; #t

;; Is (atom? s) true or false where s is Harry
;; #t

;; Is (atom ? s) true or false where s is (Harry had a heap of apples)
;; #f

;; How many arguments does atom? take and what are they?
;; Takes one argument ie an S-Expression

;; Is (atom? (car l)) true or false where l is (Harry had a heap of apples)
;; #t

;; Is (atom? (cdr l)) true or false where l is (Harry had a heap of apples)
;; #f

;; Is (atom? (cdr l)) true or false where l is (Harry)
;; #f

;; Is (atom? (car (cdr l))) true or false where l is (swing low sweet cherry oat)
;; #t

;; Is (atom? (car (cdr l))) true or false where l is (swing (low sweet) cherry oat)
;; #f

;; True or false: a1 and a2 are the same atom where a1 is Harry and a2 is Harry
;; #t

;; Is (eq? a1 a2) true or false where a1 is Harry and a2 is Harry
;; #t

;; Is (eq? a1 a2) true or false where a1 is margarine and a2 is butter
;; #f

;; How many arguments does eq? take and what are they?
;; Two. Both Non Numberic Atoms

;; Is (eq? l1 l2) true or false where l1 is () and l2 is (strawberry)
;; No Answer. eq? only takes non numeric atoms

;; Is (eq? n1 n2) true or false where n1 is 6 and n2 is 7
;; No Answer. eq? only takes non numeric atoms

;; Is (eq? (car l) a) true or false where l is (Mary had a little lamb chop) and a is Mary
;; #t

;; Is (eq? (cdr l) a) true or false where l is (soured milk) and a is milk
;; No answer since cdr l is a list

;; Is (eq? (car l) (car (cdr l))) true or false where l is (beans beans we need jelly beans)
;; #t
