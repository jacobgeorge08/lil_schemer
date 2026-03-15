#lang racket

(define (atom? x)
  (and (not (pair? x))
       (not (null? x))))

(define (a-pair? x)
  (cond
    ((atom? x) #f)
    ((null? x) #f)
    ((null? (cdr x)) #f)
    ((null? (cdr (cdr x))) #t)
    (else #f)))

(define (first p)
  (car p))

(define (second p)
  (cadr p))

(define (build s1 s2)
  (cons s1 (cons s2 '())))

;; Are you in the mood for caviar
;; Not really. Still have to go looking for it apparently

;; What is (looking a lat) where a is caviar and lat is (6 2 4 caviar 5 7 3)
;; #t

;; (looking a lat) where a is caviar and lat is (6 2 grits caviar 5 7 3)
;; #f

;; Were you expecting something different?
;; Yeah caviar looks like its in lat

;; True enough, but what is the first number in the lat?
;; 6

;; And what is the sixth element of lat
;; 7

;; And what is the seventh element?
;; 3

;; So looking clearly can't find caviar
;; Ahh okay i got it now because the third element is grits, which is not caviar

;; Here is looking, write keep-looking
;; (define (looking a lat)
;;   (keep-looking a (pick 1 lat) lat))
;;
;; (define (keep-looking a f lat)
;;   (cond
;;     ((number? f)
;;      (keep-looking a (pick f lat) lat))
;;     (else (eq? f a))))
;; Naive attempt that was probably wrong since we were'nt expected to be able to do it yet

;; (looking a lat) where a is caviar and lat is (6 2 4 caviar 5 7 3)
;; #t

;; What is (pick 6 lat) where lat is (6 2 4 caviar 5 7 3)
;; 7

;; So what do we do?
;; (keep-looking a 7 lat) which gives us 3
;; (keep-looking a 3 lat) which gives us 4
;; (keep-looking a 4 lat) which gives us caviar
;; which is #t

;; Write keep-looking
;; (define (keep-looking a sorn lat)
;;   (cond
;;     ((number? sorn)
;;      (keep-looking a (pick sorn lat) lat))
;;     (else (eq? sorn a))))

;; Can you guess what sorn stands for?
;; Symbol or Number

;; What is unusual about keep-looking
;; It does not recur on a part of lat

;; We call this "unnatural" recursion.
;; It is truly unnatural.

;; Does keep-looking appear to get closer to its goal?
;; Uptil now, yes

;; Does it always get closer to its goal?
;; No. Sometimes the list may contain neither caviar nor grits.

;; That is correct. A list may be a tup
;; Yes, if we start looking in (7 2 4 7 5 6 3), we will never stop looking

;; What is (looking a lat) where a is caviar and lat is (7 1 2 caviar 5 6 3)
;; Infinite recursion

;; Functions like looking are called partial functions.
;; What do you think the functions we have seen so far are called?
;; Total functions

;; Total vs Partial Functions
;; A total function is defined for the total range of its inputs
;; A partial function is defined for only a part of its inputs

;; Can you define a shorter function that does not reach its goal for some of its arguments?
(define (eternity x)
  (eternity x))

;; For how many of its arguments does eternity reach its goal?
;; None. Very unnatural

;; Is eternity partial?
;; Yes. The most partial function

;; What is (shift x) where x is ((a b) c)
;; (a (b c))

;; What is (shift x) where x is ((a b) (c d))
;; (a (b (c d)))

;; Define shift
(define (my-shift l)
  (cons (car (car l))
        (cons (cons (cadr (car l)) (cdr l)) '())))

;; Book Version which is much nicer but i had totally forgoten about first, second and build
(define (shift pair)
  (build (first (first pair))
         (build (second (first pair))
                (second pair))))

;; Describe what shift does
;; Take the second element of the first pair and makes it the first element of the second pair.
;; All the while, we still have only two elements in the pair

;; Now look at this function. What does it have in common with keep-looking ?
(define (align pora)
  (cond
    ((atom? pora) pora)
    ((a-pair? (first pora))
     (align (shift pora)))
    (else (build (first pora)
                 (align (second pora))))))
;; Both functions change their arguments for their recursive uses but in neither case
;; is the change guaranteed to get us closer to the goal.

;; Why are we not guaranteed that align makes progress?
;; When you shift pora in the second cond-line, you are changing the structure of the
;; original pora. It is not the original pora that we are making the pora smaller while
;; recursing

;; Which commandment does that violate?
;; 7th Commandment

;; Is the new argument at least smaller than the original one?
;; No

;; Why not?
;; It has the same number of elements. Just with a rearranged structure

;; And?
;; Both the result and the argument of shift have the same number of atoms.

;; Can you write a function that counts the number of atoms in align's arguments?
;; Yeah thats just length right?
(define (length* pora)
  (cond
    ((atom? pora) 1)
    (else
     (+ (length* (first pora)) (length* (second pora))))))

;; Is align a partial function?
;; Unsure

;; Is there something else that changes about the arguments to align and its recursive uses
;; Yes. The first component of a pair becomes simpler and
;; the second component becomes more complicated.

;; In what way is the first component simpler?
;; It becomes an atom ie only a part of the original pairs first component

;; Doesn't this mean that length* is the wrong function for determining the length of the argument?
;; Can you find a better function?
;; A better function should pay more attention to the first component.

;; How much more attention should we pay to the first component?
;; At least twice as much.

;; Do you mean something like weight*
(define weight*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      (else
       (+ (* (weight* (first pora)) 2)
          (weight* (second pora)))))))
;; That looks right.
;; If you say so, book

;; What is (weight* x) where x is ((a b) c)
;; 7

;; And what is (weight* x) where x is (a (b c))
;; 5

;; Does this mean that the arguments get simpler?
;; Yes, the weight*'s of align's arguments become successively smaller.

;; Is align a partial function?
;; No, it yields a value for every argument. And we can see the weight* for the function
;; becomes successively smaller

;; Here is shuffle which is like align but uses revpair from chapter 7, instead of shift
(define revpair (lambda (pair)
                  (build (second pair) (first pair))))
(define shuffle
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora))
       (shuffle (revpair pora)))
      (else (build (first pora)
                   (shuffle (second pora)))))))
;; shuffle and revpair swap the components of pairs when the first component is a pair.
;; Does this mean that shuffle is total?
;; No shuffle is a partial function. It does work on inputs like '(1 2)
;; and '((1 2) 3) but when both the first and second elements are lists, we get infinite recursion
;; So we're calling it a partial function

;; Let's try it . What is the value of (shuffle x) where x is (a (b c))
;; '(a (b c))

;; (shuffle x) where x is (a b)
;; '(a b)

;; What is the value of (shuffle x) where x is ((a b) (c d))
;; Infinite recursion

;; Is this function total?
(define (one? n)
  (= n 1))

;; (define C
;;   (lambda (n)
;;     (cond
;;       ((one? n) 1)
;;       (else
;;        (cond
;;          ((even? n) (C (/ n 2 )))
;;          (else (C (add1 (* 3 n)))))))))
;; It doesn 't yield a value for 0, but otherwise nobody knows. Thank you, Lothar Collatz
;; Most deffo not beacuse we just get bigger and bigger argument values to C
;; and the function goes on indefinetly

;; What is the value of (A 1 0)
;; Idk what A is
;; Book says 2

;; (A 1 1)
;; 3 according to the book

(define A
  (lambda (n m)
    (cond
      ((zero? n) (add1 m))
      ((zero? m) (A (sub1 n) 1))
      (else (A (sub1 n)
               (A n (sub1 m)))))))
;; Thank you Wilhelm Ackermann

;; What does A have in common with shuffle and looking
;; A's arguments, shuffle's and looking's, do not necessarily decrease for the recursion

;; Does A always give an answer?
;; Yes it looks pretty total

;; Then what is (A 4 3)
;; For all practical purposes, there is no answer.

;; What does that mean?
;; Just a super large number of recursive calls

;; Wouldn't it be great if we could write a function that tells us whether
;; some function returns with a value for every argument ?
;; Yeah that sounds amazing. Now that we have seen functions that never
;; return a value or return a value so late that it is too late, we should
;; have some tool like this around.

;; Okay, let's write it
;; It sounds complicated. A function can work for many different arguments.

;; Then let's make it simpler. For a warm-up exercise, let's focus on a function that checks
;; whether some function stops for just the empty list, the simplest of all arguments.
;; That would simplify it a lot .

;; Here is the beginning of this function:
;; (define (will-stop? f)
;;   (....))

;; Does will-stop? return a value for all arguments?
;; Technically yes. Either #t or #f depending on whether the argument stops when applied to '()

;; Is will-stop? total then?
;; Yes. It has to return either #t or #f

;; Then let's make up some examples. Here is the first one. What is the value of
;; (will-stop? f) where f is length
;; #t. An empty list has a length 0 and it will stop

;; How about another example? What is the value of (will-stop? eternity)
;; ( eternity '()) doesn 't return a value.
;; #f because enternity just calls itself over and over and over

;; Do we need more examples?
;; Perhaps we should do one more example.

;; Okay, here is a function that could be an interesting argument for will-stop?
;; (define last-try
;;   (lambda (x)
;;     (and (will-stop? last-try)
;;          (eternity x))))

;; We need to test it on '()
;; If we want the value of (last-try '()), we must determine the value of
;; (and (will-stop? last-try)
;;      (eternity '()))

;; What is the value of
;; (and (will-stop? last-try)
;;      (eternity '()))
;; This depends on the value of (will-stop? last-try)

;; There are only two possibilities. Let's say (will-stop? last-try) is #f
;; Then (and #f (eternity '())), is #f, since (and #f ...) is always #f

;; So (last-try '()) stopped, right?
;; Yes

;; But didn't will-stop? predict just the opposite?
;; Yes, it did. We said that the value of (will-stop? last-try) was #f,
;; which really means that last-try will not stop.

;; So we must have been wrong about (will-stop? last-try)
;; That's correct. It must return #t, because will-stop? always gives an answer.
;; We said it was total.

;; Fine. If (will-stop? last-try) is #t, what is the value of (last-try '())
;; Now we just need to determine the value of (and #t (eternity '()))
;; which is the same as the value of (eternity '())

;; What is the value of (eternity '())
;; It doesn't have a value. We know that it doesn't stop.

;; But that means we were wrong again!
;; True, since this time we said that (will-stop? last-try) was #t .

;; What do you think this means?
;; "We took a really close look at the two possible cases. If we can define will-stop?,
;; then (will-stop? last-try) must yield either #t or #f. But it cannot-due to the very 
;; definition of what will-stop? is supposed to do. This must mean that will-stop? 
;; cannot be defined."

;; Is this unique?
;; Yes, it is. It makes will-stop? the first function that we can describe precisely but
;; cannot define in our language.

;; Is there any way around this problem?
;; No. Thank you, Alan Turing and Kurt Godel

;; What is (define ...)
;; This is an interesting question. We just saw that (define ...) doesn't work for will-stop?

;; So what are recursive definitions?
;; Hold tight, take a deep breath, and plunge forward when you're ready.
;; Oh boy here we go

;; Is this the function length
;; (define length
;;   (lambda (l)
;;     (cond
;;       ((null? l) 0)
;;       (else (add1 (length (cdr l)))))))
;; Looks like it

;; What if we didn't have (define ...) anymore? Could we still define length?
;; Dont think so because we wouldnt be able to make the recursive calls to length

;; What does this function do
;; (lambda (l)
;;   (cond
;;     ((null? l) 0)
;;     (else (add1 (eternity (cdr l))))))
;; If the list is null, we return 0 otherwise we
;; (add1 (eternity (cdr l))) which goes on forever
;; It determines the length of an empty list and nothing else.

;; What happens when we use it on a non-empty list?
;; We dont get an answer because eternity just keeps calling itself
;; If we give eternity an argument, it gives no answer.

;; What does it mean for this function that looks like length
;; It only works on empty lists

;; Suppose we could name this new function. What would be a good name?
;; length0

;; How would you write a function that determines the length of lists that contain
;; one or fewer items?
;; (lambda (l)
;;   (cond
;;     ((null? l) 0)
;;     (else
;;      (add1 (length0 (cdr l))))))

;; Almost, but (define ....) doesn't work for length0
;; So we replace length0 by its lambda
;; (lambda (l)
;;   (cond
;;     ((null? l) 0)
;;     (else
;;      (add1
;;       ((lambda (l)
;;          (cond
;;            ((null? l) 0)
;;            (else (add1
;;                   (eternity (cdr l))))))
;;        (cdr l))))))

;; And what's a good name for this function?
;; length<=1

;; Is this the function that would determine the lenghts of lists that contain two or fewer items?
;; (lambda (l)
;;   (cond
;;     ((null? l) 0)
;;     (else
;;      (add1
;;       ((lambda (l)
;;          (cond
;;            ((null? l) 0)
;;            (else
;;             (add1
;;              ((lambda (l)
;;                 (cond
;;                   ((null? l) 0)
;;                   (else
;;                    (add1 (eternity (cdr l))))))
;;               (cdr l))))))
;;        (cdr l))))))
;; This is length<=2, where we basically replace length0 with length<=1

;; Now, what do you think recursion is?
;; What do you mean?

;; Well, we have seen how to determine the length of a list with no items,
;; With no more than one item , with no more than two items, and so on.

;; How could we get the function length back?
;; If we could write an infinite function in the style of length0, length<1, length<2,...,
;; then we could write lengthINF, that would determine the length of all lists that we can make.

;; How long are the lists that we can make?
;; Well, a list is either empty, or it contains one element, or two or three, or four, ...,
;; or 1001, ...
;; Basically infinitely long

;; But we can't write an infinite function
;; True

;; And we still have all these repetitions and patterns in these functions
;; Yeah

;; What do these patterns look like?
;; All these programs contain a function that looks like length.
;; Perhaps we should abstract out this function.
;; Ninth Commandment: Abstract common patterns with a new function.

;; Let's do it !
;; We need a function that looks just like length but starts with (lambda (length) ...)

;; Do you mean this?
((lambda (length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))
 eternity)
;; This is length0

;; Rewrite length<=1 in the same style
;; ((lambda (f)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (f (cdr l)))))))
;;  ((lambda (g)
;;     (lambda (l)
;;       (cond
;;         ((null? l) 0)
;;         (else (add1 (g (cdr l)))))))
;;   eternity))

;; Do we have to use length to name the argument?
;; Not necessarily

;; How about length<=2?
;; ((lambda (f)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (f (cdr l)))))))
;;  ((lambda (g)
;;     (lambda (l)
;;       (cond
;;         ((null? l) 0)
;;         (else (add1 (g (cdr l )))))))
;;   ((lambda (h)
;;      (lambda (l)
;;        (cond
;;          ((null? l) 0)
;;          (else (add1 (h (cdr l )))))))
;;    eternity)))

;; Close, but there are still repetitions.
;; True. Let 's get rid of them .

;; Where should we start?
;; Name the function that takes length as an argument and that returns a function
;; that looks like length.

;; What's a good name for this function?
;; mk-length

;; Okay, do this to length0
;; ((lambda (mk-length)
;;    (mk-length eternity))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l))))))))

;; Is this length<=1
;; ((lambda (mk-length)
;;    (mk-length (mk-length eternity)))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l))))))))

;; It sure is. And this is length<=2
;; ((lambda (mk-length)
;;    (mk-length (mk-length (mk-length eternity))))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l))))))))

;; Can you write length<=3 in this style?
;; ((lambda (mk-length)
;;    (mk-length (mk-length (mk-length (mk-length eternity)))))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l))))))))

;; What is recursion like?
;; It is like an infinite tower of applications of mk-length to an arbitrary function.

;; Do we really need an infinite tower?
;; Not really. Everytime we use length we only need a finite number but we never know how many.

;; Could we guess how many we need?
;; Sure, but we may not guess a large enough number.

;; When do we find out that we didn't guess a large enough number?
;; When we apply the function eternity that is passed to the innermost mk-length .

;; What if we could create another application of mk-length to eternity at this point?
;; That would only postpone the problem by one, and besides, how could we do that ?

;; Since nobody cares what function we pass to mk-length could we pass it mk-length initially?
;; That's the right idea.
;; And then we invoke mk-length on eternity and the result of this on
;; the cdr so that we get one more piece of the tower.

;; Then is this still length0
;; ((lambda (mk-length)
;;    (mk-length mk-length))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1
;;               (length (cdr l))))))))

;; Yes, we could even use mk-length instead of length .
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1
              (mk-length (cdr l))))))))
;; It makes sense to me but my face is still ;_;

;; Why would we want to do that?
;; All names are equal, but some names are more equal than others

;; True: as long as we use the names consistently, we are just fine.
;; And mk-length is a far more equal name than length.
;; If we use a name like mk-length, it is a constant reminder
;; that the first argument to mk-length is mk-length.

;; Now that mk-length is passed to mk-length can we use the argument to create an
;; additional recursive use?
;; Yes, when we apply mk-length once, we get length<=1
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1
              ((mk-length eternity)
               (cdr l))))))))

;; What is the value of
(((lambda (mk-length)
    (mk-length mk-length))
  (lambda (mk-length)
    (lambda (l)
      (cond
        ((null? l) 0)
        (else (add1
               ((mk-length eternity)
                (cdr l)))))))) '(apples))
;; 1

;; Could we do this more than once?
;; Yes, just keep passing mk-length to itself, and we can do this as often as we need to!

;; What would you call this function?
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1
              ((mk-length mk-length)
               (cdr l))))))))
;; This is the length function

;; How does it work?
;; Just as mk-length is about to expire, it recursively calls mk-length on itself

;; One problem is left: it no longer contains the function that looks like length
;; ((lambda (mk-length)
;;    (mk-length mk-length))
;;  (lambda (mk-length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1
;;               ((mk-length mk-length) ;; Highlighted Line
;;                (cdr l))))))))
;; Can you fix that?
;; Could extract this new application of mk-length to itself and call it length

;; Why
;; Because it really makes the function length

;; How about this
;; ((lambda (mk-length)
;;    (mk-length mk-length))
;;  (lambda (mk-length)
;;    ((lambda (length)
;;       (lambda (l)
;;         (cond
;;           ((null? l) 0)
;;           (else (add1 (length (cdr l)))))))
;;     (mk-length mk-length))))
;; It looks like it should work. I think ;_;

;; Let's see whether it works
;; Ok ;_;

;; What is the value of
;; (((lambda (mk-length)
;;    (mk-length mk-length))
;;  (lambda (mk-length)
;;    ((lambda (length)
;;       (lambda (l)
;;         (cond
;;           ((null? l) 0)
;;           (else (add1 (length (cdr l)))))))
;;     (mk-length mk-length)))) '(apples))
;; It should be 1

;; First we need the value of
;; ((lambda (mk-length)
;;   (mk-length mk-length))
;; (lambda (mk-length)
;;   ((lambda (length)
;;      (lambda (l)
;;        (cond
;;          ((null? l) 0)
;;          (else (add1 (length (cdr l)))))))
;;    (mk-length mk-length))))
;; True because the value of this expression is the function that we need to apply '(apples)


;; So we really need the value of
;; ((lambda (mk-length)
;;    ((lambda (length)
;;       (lambda (l)
;;         (cond
;;           ((null? l) 0)
;;           (else (add1 (length (cdr l)))))))
;;     (mk-length mk-length)))
;;  (lambda (mk-length)
;;    ((lambda (length)
;;       (lambda (l)
;;         (cond
;;           ((null? l) 0)
;;           (else (add1 (length (cdr l)))))))
;;     (mk-length mk-length))))
;; Fair

;; But then we need the value of
;; ((lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l)))))))
;;  ((lambda (mk-length)
;;     ((lambda (length)
;;        (lambda (l)
;;          (cond
;;            ((null? l) 0)
;;            (else (add1 (length (cdr l)))))))
;;      (mk-length mk-length)))
;;   (lambda (mk-length)
;;     ((lambda (length)
;;        (lambda (l)
;;          (cond
;;            ((null? l) 0)
;;            (else (add1 (length (cdr l)))))))
;;      (mk-length mk-length)))))

;; Yes, there is no end to it. Why?
;; Because we just keep applying mk-length to itself again and again and again ...

;; Is this strange?
;; It is because mk-length used to return a function when we applied it to an argument.
;; Indeed, it didn't matter what we applied it to.

;; But now that we have extracted
;; (mk-length mk-length)
;; from the function that makes length it does not return a function anymore.
;; So what now?

;; Turn the application of mk-length to itself in our last correct version of length into a function
;; ((lambda (mk-length)
;;    (mk-length mk-length))
;;  (lambda (mk-length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1
;;               ((mk-length mk-length) ;; Highlighted Line
;;                (cdr l))))))))
;; How?
;; Yeah Ive been wondering too lolz

;; Here is a different way. If f is a function of one argument,
;; Is (lambda (x) (f x)) a function of one argument?
;; Yes!

;; If (mk-length mk-length) returns a function of one argument, does
;; (lambda (x)
;;   ((mk-length mk-length) x))
;; return a function of one argument?
;; Actually,
;; (lambda (x)
;;   ((mk-length mk-length) x))
;; is a function

;; Okay, let's do this to the application of mk-length to itself
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
        (add1
         ((lambda (x)
            ((mk-length mk-length) x))
          (cdr l))))))))

;; Move out the new function so that we get length back.
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
          ((null? l) 0)
          (else
           (add1 (length (cdr l)))))))
    (lambda (x)
      ((mk-length mk-length) x)))))

;; Is it okay to move out the function?
;; Yes, we just always did the opposite by replacing a name with its value. 
;; Here we extract a value and give it a name.

;; Can we extract the function in the box that looks like length and give it a name?
;; Yes, it does not depend on mk-length at all
;; ((lambda (le)
;;    ((lambda (mk-length)
;;       (mk-length mk-length))
;;     (lambda (mk-length)
;;       (le (lambda (x)
;;             ((mk-length mk-length) x))))))
;;  (lambda (length)
;;    (lambda (l)
;;      (cond
;;        ((null? l) 0)
;;        (else (add1 (length (cdr l))))))))
;; We extracted the original function mk-length.
;; This is actually insane

;; Let's separate the function that makes length from the function that looks like length
(lambda (le)
  ((lambda (mk-length)
     (mk-length mk-length))
   (lambda (mk-length)
     (le (lambda (x)
            ((mk-length mk-length) x))))))

;; Does this function have a name?
;; Yes, it is called the applicative-order Y-combinator.
(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))

;; Does your hat still fit?
;; Perhaps not after such a mind stretcher.
