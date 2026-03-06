#lang racket

;; Remember what we did in rember and insertL at the end of chapter 5?
;; We replaced eq? with equal?

;; Can you write a function rember-f that would use either eq? or equal?
;; I dont even know what rember-f is

;; How can you make rember remove the first a from (b c a)
;; (rember x l) where x is a and l is '(b c a)

;; How can you make rember remove the first c from (b c a)
;; (rember x l) where x is c and l is '(b c a)

;; How can you make rember-f use equal? instead of eq?
;; By passing equal? as an argument to rember-f

;; What is (rember-f test? a l) where test? is = a is 5 and l is (6 2 5 3)
;; (6 2 3)

;; (rember-t test? a l) where test? is eq? a is jelly and l is (jelly beans are good) ?
;; (beans are good)

;; (rember-f test? a l) where test? is equal? a is (pop corn) and l is
;; (lemonade (pop corn) and (cake))
;; (lemonade and (cake))

;; Try to write rember-f
;; (define (rember-f test? a l)
;;   (cond
;;     ((null? l)'())
;;     ((test? a (car l)) (cdr l))
;;     (else (cons (car l)
;;                 (rember-f test? a (cdr l))))))

;; How does (rember-f test? a l) act where test? is eq?
;; Acts just like rember

;; And what about (rember-f test? a l) where test? is equal?
;; This is just rember with eq? replaced by equal?

;; Now we have four functions that do almost the same thing
;; rember with =
;; rember with equal ?
;; rember with eq ?
;; rember-f

;; And rember-f can behave like all the others
;; Yessir

;; What kind of values can functions return?
;; So far just lists and atoms

;; What about functions themselves?
;; I've seen functions return functions in SICP

;; Can you say what (lambda (a l) ...) is?
;; Its a function that takes an atom and a list but not sure what it does/returns

;; Now what is
;; (lambda (a)
;;   (lambda (x)
;;     (eq? x a)))
;; Its a function that takes an atom, returns another function which takes another
;; atom x and checks if x and a are equal

;; Is this called "Curry-ing?"
;; Shoutout Moses Schonfinkel

;; It is not called Schonfinkel-ing
;; Shoutout Haskell Curry

;; Using (define ...) give the preceding function a name
(define (eq?-c a)
  (lambda (x)
    (eq? x a)))

;; What is (eq?-c k) where k is salad
;; (lambda (x)
;;   (eq? x 'salad))

;; Lets give it a name using define
;; (define eq-salad?
;;   (eq?-c k))

;; What is (eq?-salad y) where y is salad
;; #t

;; And what is (eq ?-salad y) where y is tuna
;; #f

;; Do we need to give a name to eq?-salad
;; No, we may just as well ask ((eq?-c x) y) where x is salad and y is tuna

;; Now rewrite rember-f as a function of one argument test?
;; that returns an argument like rember with eq? replaced by test?
(define (rember-f test?)
  (lambda (a l)
    (cond
      ((null? l) '())
      ((test? (car l) a) (cdr l))
      (else
       (cons (car l)
             ((rember-f test?) a (cdr l)))))))

;; Describe in your own words the result of (rember-f test ?) where test? is eq?
;; It returns a fucntion that takes s and l and removes
;; the first s-expr from l that matches eq?

;; Give a name to the function returned by (rember-f test?) where test? is eq?
;; (define rember-eq? (rember-f test?))

;; What is (rember-eq? a l) where a is tuna and l is (tuna salad is good)
;; (salad is good)

;; Did we need to give the name rember-eq? to the function (rember-f test?) where test? is eq?
;; No it feels like unecessary abstraction
;; We could have written ((rember-f test?) a l)
;; where test? is eq? a is tuna and l is (tuna salad is good)

;; Now, complete the line (cons (car l) ...) in rember-f so that rember-f works.
;; (cons (car l) ((rember-f test?) a (cdr l)))))))

;; What is ((rember-f eq?) a l) where a is tuna and l is (shrimp salad and tuna salad)
;; (shrimp salad and salad)

;; ((rember-f eq ?) a l) where a is eq? and l is (equal? eq? eqan? eqlist? eqpair?)
;; (equal? eqan? eqlist? eqpair?)

;; Transform insertL to insertL-f the same way we have transformed rember into rember-f
(define (insertL-f test?)
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((test? old (car lat))
       (cons new lat))
      (else (cons (car lat) ((insertL-f test?) new old (cdr lat)))))))

;; And, just for the exercise, do it to insertR
(define (insertR-f test?)
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((test? old (car lat))
       (cons old (cons new (cdr lat))))
      (else (cons (car lat) ((insertR-f test?) new old (cdr lat)))))))

;; Are insertR and insertL similar?
;; Yeah almost

;; Can you write a function insert-g that inserts either at the left or at the right?
;; --- WRONG INITIAL ATTEMPT ---
;; (define (insert-g test? dir)
;;   (cond
;;     ((equal? dir 'left) insertL-f test?)
;;     ((equal? dir 'right) insertR-f test?)))

;; Which pieces differ?
;; The second lines differ from each other. In insertL it is:
;; ((eq? (car l) old)
;;  (cons new (cons old (cdr l))))
;; but in insertR it is:
;; ((eq? (car l) old)
;;  (cons old (cons new (cdr l))))

;; Put the difference in words!
;; The two functions cons old and new in a different order onto the cdr of the list l

;; So how can we get rid of the difference?
;; By passing in a function that expresses the appropriate consing.

;; Define a function seqL that takes three arguments, and conses the first argument
;; onto the result of consing the second argument onto the third argument.
(define (seqL new old l)
  (cons new (cons old l)))

;; What is
(define seqR (lambda (new old l)
               (cons old (cons new l))))
;; Returns a new list that conses the 2nd argument onto the result
;; of consing the first and third argument

;; Do you know why we wrote these functions?
;; They express what the two differing lines in insertL and insertR express

;; Try to write the function insert-g of one argument seq
;; which returns insertL where seq is seqL and
;; which returns insertR where seq is seqR
(define (insert-g seq)
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((eq? (car l) old)
       (seq new old (cdr l)))
      (else
       (cons (car l) ((insert-g seq) new old (cdr l)))))))
;; This is genuinely so damn beautiful. Its art. Its a goddamn masterpiece

;; Now define insertL with insert-g
(define insertL
  (insert-g seqL))

;; Now define insertR with insert-g
(define insertR
  (insert-g seqR))

;; Is there something unusual about these two definitions?
;; Yes. Earlier we would probably have written
;; (define insertL (insert-g seq)) where seq is seqL and
;; (define insertR (insert-g seq)) where seq is seqR.
;; But, using "where" is unnecessary when you pass functions as arguments.

;; Is it necessary to give names to seqL and seqR
;; Nope. Could be lambdas ig

;; Define insertL again with insert-g. Do not pass in seqL this time.
;; (define insertL
;;   (insert-g (lambda (new old l)
;;               (cons (new (cons old l))))))

;; Is this better?
;; To me: Not really. I like the prev version better
;; But according to the book: Yes, because you do not need to remember as many names.
;; You can (rember func-name "your-mind") where func-name is seqL.

;; Do you remember the definition of subst
;; (define (subst new old lat)
;;   (cond
;;     ((null? lat) '())
;;     ((eq? old (car lat))
;;      (cons new (cdr lat)))
;;     (else (cons (car lat) (subst new old (cdr lat))))))

;; Does this look familiar?
;; This looks like insertL or insertR

;; Define a function like seqL or seqR for subst
(define seqS
  (lambda (new old l)
    (cons new l)))

;; And now define subst using insert-g
(define subst
  (insert-g seqS))

;; What do you think yyy is
(define seqrem
  (lambda (new old l) l))

(define yyy
  (lambda (a l)
    ((insert-g seqrem) #f a l)))
;; It is our old friend rember
;; Step through the evaluation of (yyy a l) where a is sausage and
;; l is (pizza with sausage and bacon)
;; What role does #f play?
;; Its just a placeholder, because as soon as we hit (eq? (car l) old) we return (cdr l)
;; dropping the first element aka the matching old

;; Have we seen similar functions before?
;; Yes lots of fucntions have similar lines

;; Do you remember value from chapter 6?
(define (atom? x)
  (and (not (pair? x))
       (not (null? x))))
(define (1st-sub-exp aexp)
  (car (cdr aexp)))
(define (2nd-sub-exp aexp)
  (caddr aexp))
(define (operator aexp)
  (car aexp))

;; (define (value nexp)
;;   (cond
;;     ((atom? nexp) nexp)
;;     ((eq? (operator nexp) '+)
;;      (+ (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))
;;     ((eq? (operator nexp) '*)
;;      (* (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))
;;     (else
;;      (expt (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))))

;; Do you see the similarities?
;; The last three answers are the same except for the + , * and expt

;; Can you write the function atom-to-function which takes one argument x and
;; returns the function + if (eq? x '+ )
;; returns the function * if (eq? x '*)
;; returns the function expt otherwise?
(define (atom-to-function x)
  (cond
    ((eq? x '+) +)
    ((eq? x '*) *)
    (else expt)))

;; What is (atom-to-function (operator nexp)) where nexp is (+ 5 3)
;; The function +, not the atom +
;; Because operator picks out the + atom from nexp and then atom to fucntion returns the
;; procedure +

;; Can you use atom-to-function to rewrite value with only two cond-lines?
;; Mmmhmm
(define (value nexp)
  (cond
    ((atom? nexp) nexp)
    (else
     ((atom-to-function (operator nexp)) (value (1st-sub-exp nexp))
                                         (value (2nd-sub-exp nexp))))))

;; Is this quite a bit shorter than the first version?
;; Its gorgeous

;; Time for an apple?
;; Ill take it

;; Here is multirember again.
(define (multirember a lat)
  (cond
    ((null? lat) '())
    ((eq? a (car lat))
     (multirember a (cdr lat)))
    (else (cons (car lat) (multirember a (cdr lat))))))

;; Write multirember-f
(define (multirember-f test?)
  (lambda (a l)
    (cond
      ((null? l) '())
      ((test? a (car l))
       ((multirember-f test?) a (cdr l)))
      (else (cons (car l) ((multirember-f test?) a (cdr l)))))))

;; What is ((multirember-f test?) a lat) where test? is eq? a is tuna and
;; lat is (shrimp salad tuna salad and tuna)
;; '(shrimp salad salad and)

;; Wasn't that easy?
;; Yeah not too bad

;; Define multirember-eq? using multirember-f
;; (define multirember-eq?
;;   (multirember-f eq?))

;; Do we really need to tell multirember-f about tuna
;; Yeah because what will it remove otherwise

;; Does test? change as multirember-f goes through lat
;; No.

;; Can we combine a and test?
;; test? could be a function of just one argument and could compare that argument to tuna.

;; This is one way
;; (define (eq?-c a)
;;   (lambda (x)
;;     (eq? x a)))
;; (define eq?-tuna
;;   (eq?-c a))
;; where a is tuna

;; Can you think of a different way of writing this function?
(define eq?-tuna
  (eq?-c 'tuna))

;; Have you ever seen definitions that contain atoms?
;; Yah plenty of times like (quote +) for example

;; Perhaps we should now write multiremberT which is similar to multirember-f
;; Instead of taking test? and returning a function, multiremberT takes a function like
;; eq?-tuna and a lat and then does its work.
(define (multiremberT test? l)
  (cond
    ((null? l) '())
    ((test? (car l))
     (multiremberT test? (cdr l)))
    (else (cons (car l) (multiremberT test? (cdr l))))))

;; Is this easy?
;; Wasnt too bad

;; What about this
(define multirember&co
  (lambda (a lat col)
    (cond
      ((null? lat)
       (col '() '()))
      ((eq? (car lat) a)
       (multirember&co a
                       (cdr lat)
                       (lambda (newlat seen)
                         (col newlat
                              (cons (car lat) seen)))))
      (else
       (multirember&co a
                       (cdr lat)
                       (lambda (newlat seen)
                         (col (cons (car lat) newlat)
                              seen)))))))
;; Yeah no clue whats happening :D

;; Heres something simpler
(define a-friend
  (lambda (x y)
    (null? y)))
;; Yeah this is just a function that takes two arguments and asks if the 2nd argument is null

;; Value of (multirember&co a lat col) where a is tuna, lat is (strawberries tuna and swordfish)
;; and col is a-friend ?
;; Lowkey a little hard to trace through the function even with pen and paper

;; Let's try a friendlier example. What is the value of (multirember&co a lat col)
;; where a is tuna lat is '() and col is a-friend
;; Much easier to workout. Its #t

;; And what is (multirember&co a lat col) where a is tuna lat is (tuna) and col is a-friend
;; multirember&co asks (eq? (car lat) 'tuna) where lat is (tuna). Then it recurs on ()

;; What are the other arguments that multirember&co uses for the natural recursion?
;; a => 'tuna
;; lat => '()
;; col => (lambda (newlat seen)
;;          (a-friend newlat (cons 'tuna seen))

;; What is the name of the third argument
;; col

;; Do we know what col stands for?
;; Apparently it stands for collector or continuation

;; And now?
;; multirember&co finds out that (null? lat) is true, which means that it uses the
;; collector on two empty lists

;; Which collector is this
;; It is the new-friend

;; How does a-friend differ from the new-friend
;; new-friend uses a-friend on the empty list and the value of (cons 'tuna '())

;; And what does the old collector do with such arguments?
;; It answers #f, because its second argument is (tuna), which is not the empty list

;; What is the value of (multirember&co a lat a-friend) where a is tuna and lat is (and tuna)
;; #f
;; I traced it out

;; And what is the value of this recursive use of multirember&co
;; #f, since (a-friend ls1 ls2) where ls1 is (and) and ls2 is (tuna) is #f.

;; What is the value of (multirember&co (quote tuna) ls col) where
;; ls is (strawberries tuna and swordfish) and col is
;; (define last-friend
;;   (lambda (x y)
;;     (length x)))

;; 3
;; Again had to trace it out to get it to work properly

;; Do you remember multiinsertL
(define multiinsertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new
             (cons old
                   (multiinsertL new old
                                 (cdr lat)))))
      (else (cons (car lat)
                  (multiinsertL new old
                                (cdr lat)))))))

;; Do you also remember multiinsertR
(define multiinsertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons old
             (cons new
                   (multiinsertR new old
                                 (cdr lat)))))
      (else (cons (car lat)
                  (multiinsertL new old
                                (cdr lat)))))))

;; Now try multiinsertLR
;; multiinsertLR inserts new to the left of oldL and to the right of oldR in lat
;; if oldL are oldR are different
(define (multiinsertLR new oldL oldR lat)
  (cond
    ((null? lat) '())
    ((eq? oldL (car lat))
     (cons new (cons (car lat) (multiinsertLR new oldL oldR (cdr lat)))))
    ((eq? oldR (car lat))
     (cons oldR (cons new (multiinsertLR new oldL oldR (cdr lat)))))
    (else (cons (car lat) (multiinsertLR new oldL oldR (cdr lat))))))

;; The function multiinsertLR&co is to multiinsertLR what multirember&co is to multirember
;; Does this mean that multiinsertLR&co takes one more argument than multiinsertLR?
;; Yeah the collector or continuation fuction

;; When multiinsertLR&co is done, it will use col on
;; the new lat, on the number of left insertions, and the number of right insertions.
;; Can you write an outline of multiinsertLR&co
;; (define (multiinsertLR&co new oldL oldR lat col)
;;   (cond
;;     ((null? lat)
;;      (col '() 0 0))
;;     ((eq? oldL (car lat))
;;      (multiinsertLR&co new oldL oldR (cdr lat)
;;                        (lambda (newlat left right)
;;                          (.....))))
;;     ((eq? oldR (car lat))
;;      (multiinsertLR&co new oldL oldR (cdr lat)
;;                        (lambda (newlat left right)
;;                          (.....))))
;;     (else
;;      (multiinsertLR&co new oldL oldR (cdr lat)
;;                        (lambda (newlat left right)
;;                          (.....))))))

;; Why is col used on '() 0 and 0 when (null? lat) is true?
;; We are counting the number of insertions on the left and right.
;; If the list is empty, newlat will be empty as well
;; and the number of insertions on the left and the right will be 0

;; So what is the value of (multiinsertLR&co 'cranberries 'fish 'chips '() col)
;; (col '() 0 0)

;; Is it true that multiinsertLR&co will use the new collector on three arguments
;; when (car lat) is equal to neither oldL nor oldR
;; Yes in all three cases, a new collector is used post null? lat
;; Here, the first arg newlat will be the lat produced by multiinsert (cdr lat), oldL, oldR
;; The 2nd and 3rd args are the number of insertions and deletions that have happened
;; to L and R respectively

;; Is it true that multiinsertLR&co then uses the function col on (cons (car lat) newlat)
;; because it copies the list unless an oldL or an oldR appears?
;; Sounds kinda right. So we know what the new collector for the last case is:
;; (lambda (newlat L R)
;;   (col (cons (car lat) newlat) L R))

;; Why are col's second and third arguments just L and R
;; Because no insertions take place in the case where oldR or oldL match

;; Here is what we have so far. And we have even thrown in an extra collector
;; (define multiinsertLR&co
;;   (lambda (new oldL oldR lat col)
;;     (cond
;;       ((null? lat)
;;        (col (quote ()) 0 0))
;;       ((eq? (car lat) oldL)
;;        (multiinsertLR&co new oldL oldR (cdr lat)
;;                          (lambda (newlat L R)
;;                            (col (cons new
;;                                       (cons oldL newlat))
;;                                 (add1 L) R))))
;;       ((eq? (car lat) oldR)
;;        (multiinsertLR&co new oldL oldR (cdr lat)
;;                          (lambda (newlat L R)
;;                            ....)))
;;       (else
;;        (multiinsertLR&co new oldL oldR (cdr lat)
;;                          (lambda (newlat L R)
;;                            (col (cons (car lat)newlat)
;;                                 L R)))))))
;; Can you fill in the dots?
(define (multiinsertLR&co new oldL oldR lat col)
  (cond
    ((null? lat)
     (col '() 0 0))
    ((eq? (car lat) oldL)
     (multiinsertLR&co new oldL oldR (cdr lat)
                       (lambda (newlat L R)
                         (col (cons new
                                    (cons oldL newlat))
                              (add1 L) R))))
    ((eq? (car lat) oldR)
     (multiinsertLR&co new oldL oldR (cdr lat)
                       (lambda (newlat L R)
                         (col (cons oldR (cons new newlat)) L (add1 R)))))
    (else
     (multiinsertLR&co new oldL oldR (cdr lat)
                       (lambda (newlat L R)
                         (col (cons (car lat) newlat)
                              L R))))))
;; So can you fill in the dots?
;; When you helped so much, how could I not

;; What is the value of (multiinsertLR&co new oldL oldR lat col)
;; where new is salty, oldL is fish, oldR is chips and lat is (chips and fish or fish and chips)
;; (col '(chips salty and salty fish or salty fish and chips salty) 2 2)

;; Is this healthy?
;; Im not answering that

;; Do you remember what *-functions are?
;; Yes, all *-functions work on lists that are either
;; empty,
;; an atom consed onto a list,
;; a list consed onto a list

;; Now write the function evens-only* which removes all odd numbers from a list of nested lists.
;; The book had a definition for even? but Im just using the racket std lib one
(define (evens-only* l)
  (cond
    ((null? l) '())
    ((atom? (car l))
     (cond
       ((even? (car l))
        (cons (car l) (evens-only* (cdr l))))
       (else (evens-only* (cdr l)))))
    (else (cons (evens-only* (car l)) (evens-only* (cdr l))))))

;; What is the value of (evens-only* l) where l is ((9 1 2 8) 3 10 ((9 9) 7 6) 2)
;; ((2 8) 10 (() 6) 2)

;; What is the sum of the odd numbers in l where l is ((9 1 2 8) 3 10 ((9 9) 7 6) 2)
;; 38

;; What is the product of the even numbers in l where l is ((9 1 2 8) 3 10 ((9 9) 7 6) 2)
;; 1920

;; Can you write the function evens-only*&co It builds a nested list of even numbers by
;; removing the odd ones from its argument and simultaneously multiplies the even
;; numbers and sums up the odd numbers that occur in its argument.
;; I think so

;; Can you explain what (evens-only*&co (car l) ....) accomplishes?
;; (define (evens-only*&co l col)
;;   (cond
;;     ((null? l)
;;      (col '() 1 0))
;;     ((atom? (car l))
;;      (cond
;;        ((even? (car l))
;;         (evens-only*&co (cdr l)
;;                         (lambda (newl p s)
;;                           (col (cons (car l) newl)
;;                                (* (car l) p) s))))
;;        (else (evens-only*&co (cdr l)
;;                              (lambda (newl p s)
;;                                (col newl
;;                                     p (+ (car l) s)))))))
;;     (else (evens-only*&co (car l) ....)))))
;; It visits every element in the car of l and returns  a list of
;; just even numbers, the product of even numbers and the sum of odd numbers

;; What does the function evens-only*&co do after visiting all the numbers in (car l)
;; It uses the col part of the definition

;; And what does the collector do?
;; It uses evens-only*&co to visit the cdr of l and to collect the list that is like (cdr l),
;; without the odd numbers of course, as well as the product of the even numbers and the
;; sum of the odd numbers.

;; Does this mean the unknown collector looks roughly like this:
;; (lambda (al ap as)
;;   (evens-only*&co (cdr l)
;;                   ...))
;; Yes

;; And when (evens-only*&co (cdr l) ...) is done with its job, what happens then?
;; The collector to this is then called

;; What does the collector for (evens-only*&co (cdr l) ...) do?
;; It conses together the results for the lists in the car and the cdr and multiplies and adds
;; the respective products and sums. Then it passes these values to the old collector
;; (lambda (al ap as)
;;   (evens-only*&co (cdr l)
;;                (lambda (dl dp ds)
;;                  (col (cons al dl)
;;                        (* ap dp)
;;                        (+ as ds )))))

;; Final evens-only*&co
(define (evens-only*&co l col)
  (cond
    ((null? l)
     (col '() 1 0))
    ((atom? (car l))
     (cond
       ((even? (car l))
        (evens-only*&co (cdr l)
                        (lambda (newl p s)
                          (col (cons (car l) newl)
                               (* (car l) p) s))))
       (else (evens-only*&co (cdr l)
                             (lambda (newl p s)
                               (col newl
                                    p (+ (car l) s)))))))
    (else (evens-only*&co (car l)
                          (lambda (al ap as)
                            (evens-only*&co (cdr l)
                                            (lambda (dl dp ds)
                                              (col (cons al dl)
                                                   (* ap dp)
                                                   (+ as ds)))))))))

;; What is the value of (evens-only*&co l the-last-friend) where l is ((9 1 2 8) 3 10 ((9 9) 7 6) 2)
;; and the-last-friend is defined as follows:
;; (define the-last-friend
;;   (lambda (newl product sum)
;;     (cons sum (cons product newl))))
;; '(38 1920 ((2 8) 10 (6) 2))
