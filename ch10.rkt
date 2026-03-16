#lang racket
(require (except-in racket apply))

(define (atom? x)
  (and (not (pair? x))
       (not (null? x))))

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

(define (first p)
  (car p))
(define (second p)
  (cadr p))
(define (third l)
  (caddr l))

;; An entry is a pair of lists whose first list is a set
;; Also, the two lists must be of equal length.
;; Make up some examples for entries
;; '((1 23 45) (21 21 32))
;; '((apple orange pear) ((c++ c) (racket clojure) (go zig)))
;; '((beverage dessert) ((food is) (number one with us)))

;; How can we build an entry from a set of names and a list of values?
(define new-entry build)

(new-entry '(1 23 45) '(21 21 32))
(new-entry '(apple orange pear) '((c++ c) (racket clojure) (go zig)))

;; What is (lookup-in-entry name entry) where name is entree and entry is
;; ((appetizer entree beverage) (food tastes good))
;; tastes

;; What if name is dessert
;; It is left to user, how to handle a missing name
;; Personally I would like to say #f.
;; After progressing through more of the chapter I realize this is not a right idea

;; How can we accomplish this?
;; lookup-in-entry takes an additional argument that is invoked when name is not found
;; in the first list of an entry.

;; How many arguments do you think this extra function should take?
;; I want to say 1

;; Here is our definition of lookup-in-entry
(define (lookup-in-entry name entry entry-f)
  (lookup-in-entry-help name
                        (first entry)
                        (second entry)
                        entry-f))

;; Finish the function lookup-in-entry-help
(define (lookup-in-entry-help name names values entry-f)
  (cond
    ((null? names) (entry-f name))
    ((eq? name (car names)) (car values))
    (else (lookup-in-entry-help name
                                (cdr names)
                                (cdr values)
                                entry-f))))

;; A table (also called an environment) is a list of entries
;; Here is one example: the empty table, represented by '() Make up some others
'(((1 23 45) (21 21 32))
  ((apple orange pear) ((c++ c) (racket clojure) (go zig)))
  ((beverage dessert) ((food is) (number one with us))))

;; Define the function extend-table which takes an entry and a table and
;; creates a new table by putting the new entry in front of the old table.
(define extend-table cons)

;; What is (lookup-in-table name table table-f) where name is entree table is
;; '(((entree dessert)
;;    (spaghetti spumoni))
;;   ((appetizer entree beverage)
;;    (food tastes good)))
;; table-f is (lambda (name) ...)
;; spaghetti because it comes first

;; Write lookup-in-table
(define (lookup-in-table name table table-f)
  (cond
    ((null? table) (table-f name))
    (else
     (lookup-in-entry name
                      (car table)
                      (lambda (name)
                        (lookup-in-table name (cdr table) table-f))))))

;; Can you describe what the following function represents
;; (lambda (name)
;;   (lookup-in-table name (cdr table) table-f))
;; When name isnt found in the first entry of the table, this function looks through the next entry

;; In the preface we mentioned that sans serif typeface would be used to represent atoms.
;; To this point it has not mattered. Henceforth, you must notice whether or not an atom is in sans serif.
;; Bruh...

;; Have we chosen a good representation for expressions?
;; Yes. They are all S-expressions so they can be data for functions

;; What kind of functions?
;; For example, value.

;; Do you remember value from chapter 6?
;; Recall that value is the function that returns the natural value of expressions.

;; What is the value of
;; (cons rep-a
;;       (cons rep-b
;;             (cons rep-c
;;                   ('()))))
;; where rep-a is a, rep-b is b and rep-c is c
;; '(a b c)

;; What is the value of
;; (cons rep-car
;;       (cons (cons rep-quote
;;                   (cons
;;                    (cons rep-a
;;                          (cons rep-b
;;                                (cons rep-c
;;                                      '())))
;;                    '()))
;;             '()))
;; where rep-car is car, rep-quote is quote, rep-a is a, rep-b is b, rep-c is c
;; (car (quote (a b c)))

;; What is the value of
;; (car (quote (a b c)))
;; a

;; What is (value e) where e is
;; (car (quote (a b c)))
;; a

;; What is (value e) where e is
;; (quote (car (quote (a b c))))
;; '(car (quote (a b c)))

;; What is (value e) where e is
;; (add1 6)
;; 7

;; What is (value e) where e is 6
;; 6

;; What is (value e) where e is (quote nothing)
;; 'nothing

;; What is (value e) where e is nothing
;; nothing has no value

;; What is (value e)
;; where e is
;; ((lambda (nothing)
;;    (cons nothing (quote ())))
;;  (quote
;;   (from nothing comes something)))
;; ((from nothing comes something))

;; What is (value e)
;; where e is
;; ((lambda (nothing)
;;    (cond
;;      (nothing (quote something))
;;      (else (quote nothing))))
;;  #t)
;; 'something

;; What is the type of e where e is 6
;; *const

;; What is the type of e where e is #f
;; *const

;; What is (value e) where e is #f
;; #f

;; What is the type of e where e is cons
;; *const

;; What is (value e) where e is car
;; (primitive car)

;; What is the type of e where e is (quote nothing)
;; *quote

;; What is the type of e where e is nothing
;; *identifier

;; What is the type of e where e is
;; (lambda (x y) (cons x y))
;; *lambda

;; What is the type of e where e is
;; ((lambda (nothing)
;;    (cond
;;      (nothing (quote something))
;;      (else (quote nothing))))
;;  #t)
;; *application

;; What is the type of e where e is
;; (cond
;;   (nothing (quote something))
;;   (else (quote nothing)))
;; *cond

;; How many types do you think there are?
;; We found six: *const, *quote, *identifier, *lambda, *cond, *application.

;; How do you think we should represent types?
;; With functions. We call these functions "actions."

;; If actions are functions that do "the right thing" when applied to the appropriate type of expression
;; What should value do?
;; It would have to find out the type of expression it was passed and then use the associated action

;; Do you remember atom-to-function from chapter 8?
;; Ya
;; Was useful when we rewrote value for numbered expresssions

;; Below is a function that produces the correct action (or function) for each possible S-expression:
(define (expression-to-action e)
  (cond
    ((atom? e) (atom-to-action e))
    (else (list-to-action e))))

;; Define the function atom-to-action
(define (atom-to-action e)
  (cond
    ((number? e) *const)
    ((eq? e #t) *const)
    ((eq? e #f) *const)
    ((eq? e 'cons) *const)
    ((eq? e 'car) *const)
    ((eq? e 'cdr) *const)
    ((eq? e 'null?) *const)
    ((eq? e 'eq?) *const)
    ((eq? e 'atom?) *const)
    ((eq? e 'zero?) *const)
    ((eq? e 'add1) *const)
    ((eq? e 'sub1) *const)
    ((eq? e 'number?) *const)
    (else *identifier)))

;; Now define the help function list-to-action
(define (list-to-action e)
  (cond
    ((atom? (car e))
     (cond
       ((eq? (car e) 'quote) *quote)
       ((eq? (car e) 'lambda) *lambda)
       ((eq? (car e) 'cond) *cond)
       (else *application)))
    (else *application)))

;; Assuming that expression-to-action works, we can use it to define value and meaning
(define (meaning e table)
  ((expression-to-action e) e table))

(define (value e)
  (meaning e '()))

;; What is ('()) in the definition of value
;; It is the table ie currently empty

;; ACTIONS DO SPEAK LOUDER THAN WORDS

;; How many arguments should actions take according to the above?
;; Two, the expression e and a table.

;; Here is the action for constants. Is it correct?
(define *const
  (lambda (e table)
    (cond
      ((number? e) e)
      ((eq? e #t) #t)
      ((eq? e #f) #f)
      (else (build (quote primitive) e)))))
;; Yes, for numbers, it just returns the expression, and this is all we have to do for 0, 1, 2,...
;; For #t , it returns true.
;; For #f , it returns false.
;; And all other atoms of constant type represent primitives.

;; Here is the action for *quote
(define *quote
  (lambda (e table)
    (text-of e)))
;; Define the help function text-of
(define text-of second)

;; Have we used the table yet?
;; Not yet

;; Why do we need the table?
;; To remember the values of identifiers.

;; Given that the table contains the values of identifiers, write the action *identifier
(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table)))

(define initial-table
  (lambda (name)
    (car (quote ()))))

;; When is it used?
;; Let's hope never because you cant really car a '()

;; What is the value of (lambda (x) x)
;; We don't know yet, but we know that it must be the representation of a non-primitive function.

;; How are non-primitive functions different from primitives?
;; We know what primitives do
;; Non-primitives are defined by their arguments and their function bodies.

;; So when we want to use a non-primitive we need to remember its formal arguments and its function body
;; At least. Fortunately this is just the cdr of a lambda expression.

;; And what else do we need to remember?
;; We will also put the table in, just in case we might need it later.

;; And how do we represent this?
;; In a list

;; Here is the action *lambda
(define *lambda
  (lambda (e table)
    (build (quote non-primitive)
           (cons table (cdr e)))))

;; What is (meaning e table) where e is
;; (lambda (x) (cons x y))
;; and table is
;; (((y z) ((8) 9)))

;; (non-primitive
;;  ((((y z) ((8) 9))) (x) (cons x y)))

;; It is probably a good idea to define some help functions for getting back the parts in
;; this three element list (i.e., the table, the formal arguments, and the body).
;; Write table-of, formals-of and body-of

(define table-of first)
(define formals-of second)
(define body-of third)

;; Describe (cond ...) in your own words
;; It is a special form that takes any number of cond-lines. It considers each line in turn.
;; If the question part on the left is false, it looks at the rest of the lines.
;; Otherwise it proceeds to answer the right part.
;; If it sees an else-line, it treats that cond-line as if its question part were true.

;; Here is the function evcon that does what we described
;; Write else? and the help functions question-of and answer-of
(define evcon
  (lambda (lines table)
    (cond
      ((else? (question-of (car lines)))
       (meaning (answer-of (car lines))
                table))
      ((meaning (question-of (car lines))
                table)
       (meaning (answer-of (car lines))
                table))
      (else (evcon (cdr lines) table)))))

(define question-of first)
(define answer-of second)

(define else?
  (lambda (x)
    (cond
      ((atom? x) (eq? x (quote else)))
      (else #f))))

;; Didn't we violate the first commandment?
;; Yes, we don't ask (null? lines), so one of the questions in every cond better be true

;; Now use the function evcon to write the *cond action
(define *cond
  (lambda (e table)
    (evcon (cond-lines-of e) table)))

(define cond-lines-of cdr)

;; Aren't these help functions useful?
;; Honestly my mind is blown

;; Do you understand *cond now?
;; Sort of

;; How can you become familiar with it?
;; The best way is to try an example. A good one is:
;; (*cond e table)
;; where e is
;; (cond (coffee klatsch) (else party))
;; and table is
;; (((coffee) (#t))
;;  ((klatsch party) (5 (6))))

;; Have we seen how the table gets used?
;; Yes, *lambda and *identifier use it

;; But how do the identifiers get into the table?
;; In the only action we have not defined: *application

;; How is an application represented?
;; An application is a list of expressions whose car position contains an expression whose value is a function

;; How does an application differ from a special form, like (and ...) (or ...) or (cond ...)
;; An application must always determine the meaning of all its arguments.

;; Before we can apply a function, do we have to get the meaning of all of its arguments?
;; Yah

;; Write a function evlis that takes a list of (representations of) arguments and a table,
;; and returns a list composed of the meaning of each argument
(define (evlis args table)
  (cond
    ((null? args) '())
    (else
     (cons (meaning (car args) table)
           (evlis (cdr args) table)))))

;; What else do we need before we can determine the meaning of an application?
;; We need to find out what its function-of means

;; And what then?
;; Then we apply the meaning of the function to the meaning of the arguments.

;; Here is *application
(define *application
  (lambda (e table)
    (apply
     (meaning (function-of e) table)
     (evlis (arguments-of e) table))))

;; Of course. We just have to define apply, function-of, and arguments-of correctly
(define function-of car)
(define arguments-of cdr)

;; How many different kinds of functions are there?
;; Two. Primitive / Non-Primitive

;; What are the two representations of functions?
'(primitive primitive-name)
;; and
'(non-primitive (table formals body))
;; The list (table formals body) is called a closure record.

;; Write primitive? and non-primitive?
(define (primitive? l)
  (eq? (first l) (quote primitive)))

(define (non-primitive? l)
  (eq? (first l) (quote non-primitive)))

;; Now we can write the function apply
(define apply
  (lambda (fun vals)
    (cond
      ((primitive? fun)
       (apply-primitive (second fun) vals))
      ((non-primitive? fun)
       (apply-closure (second fun) vals)))))

;; This is the definition of apply-primitive. Fill in the blanks
(define apply-primitive
  (lambda (name vals)
    (cond
      ((eq? name 'cons)
       (cons (first vals)(second vals)))
      ((eq? name 'car)
       (car (first vals)))
      ((eq? name 'cdr)
       (cdr (first vals)))
      ((eq? name 'null?)
       (null? (first vals)))
      ((eq? name 'eq?)
       (eq? (first vals) (second vals)))
      ((eq? name 'atom?)
       (:atom? (first vals)))
      ((eq? name 'zero?)
       (zero? (first vals)))
      ((eq? name 'add1)
       (add1 (first vals)))
      ((eq? name 'sub1)
       (sub1 (first vals)))
      ((eq? name 'number?)
       (number? (first vals))))))

(define (:atom? x)
  (cond
    ((atom? x) #t)
    ((null? x) #f)
    ((eq? (car x) 'primitive) #t)
    ((eq? (car x) 'non-primitive) #t)
    (else #f)))

;; Is apply-closure the only function left ?
;; Yes, and apply-closure must extend the table.

;; How could we find the result of (f a b) where f is
;; (lambda (x y) (cons x y))
;; a is 1 and b is (2)
;; That 's tricky. But we know what to do to find the meaning of (cons x y)
;; where table is
;; (((x y)
;;   (1 (2))))

;; Why can we do this?
;; Here, we don't need apply-closure

;; Can you generalize the last two steps?
;; Applying a non-primitive function ie a closure to a list of values is the same as
;; finding the meaning of the closure's body with its table extended by an entry of the form
;; (formals values)
;; In this entry, formals is the formals of the closure and values is the result of evlis

;; Have you followed all this?
;; I think ;_;
;; Thank you book for the definiton of apply-closure
(define (apply-closure closure vals)
  (meaning (body-of closure)
           (extend-table
            (new-entry
             (formals-of closure)
             vals)
            (table-of closure))))

;; This is a complicated function and it deserves an example.
;; I agree
;; In the following, closure is
;; ((((u v w)
;;    (1 2 3))
;;   ((x y z)
;;    (4 5 6)))
;;  (x y)
;;  (cons z x))
;; and
;; vals is ((a b c) (d e f))

;; What will be the new arguments of meaning
;; The new e for meaning will be (cons z x) and
;; the new table for meaning will be
;; (((x y)
;;   ((a b c)(d e f)))
;;  ((u v w)
;;   (1 2 3))
;;  ((x y z)
;;   (4 5 6)))

;; What is the meaning of (cons z x) where z is 6 and x is (a b c)
;; The same as (meaning e table) where e is (cons z x) and table is
;; (((x y)
;;   ((a b c) (d e f)))
;;  (( u v w )
;;   (1 2 3))
;;  ((x y z)
;;   (4 5 6)))

;; Let's find the meaning of all the arguments.
;; What is (evlis args table) where args is (z x) and table is
;; (((x y)
;;   ((a b c) (d e f)))
;;  ((u v w)
;;   (1 2 3))
;;  ((x y z)
;;   (4 5 6)))

;; In order to do this, we must find both (meaning e table) where e is z and
;; (meaning e table) where e is x.

;; What is the (meaning e table) where e is z
;; 6, by using *identifier which does lookup-in-table

;; What is (meaning e table) where e is x
;; (a b c) by using *identifier

;; So, what is the result of evlis
;; (6 (a b c))
;; because evlis returns a list of the meanings.

;; What is (meaning e table) where e is cons
;; (primitive cons)  by using *const

;; We are now ready to (apply fun vals) where fun is (primitive cons) and
;; vals is (6 (a b c ))
;; Which path should we take?
;; The apply primitive path

;; Which cond-line is chosen for (apply-primitive name vals) where name is cons and vals is (6 (a b c))
;; ((eq? name (quote cons))
;;  (cons (first vals) (second vals)))

;; Are we finished now?
;; Finally ;_;

;; But what about (define ...)
;; It isn't needed because recursion can be obtained from the Y combinator.
;; lol

;; Does that mean we can run the interpreter on the interpreter
;; if we do the transformation with the Y combinator?
;; Yes

;; What makes value unusual?
;; It sees representations of expressions

;; Should will-stop? see representations of expressions?
;; That may help a lot .

;; Does it help?
;; No not really

;; else
;; ggwp
