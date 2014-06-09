Sexy
====

**((real 'languages) have.curves)**

Sexy is an object-based dialect of Lisp inspired by Scheme, Self, and Perl.

```scheme

(def foo (fn (x y) (* x y)))

(stdout.print (foo 3 4)) 

(fun bar (x y) 
    (if opt.snazz
        (list x y opt.snazz opt.snarf rest)
        (list x y rest)))

(def baz
    (list
        (bar 2 3)
        (bar 2 3 4 5)
        (bar 2 snazz: true 3 4 5)
        (bar 2 snazz: true snarf: "Yarr!" 3 4 5)))

(baz.map show)

(def fibby
    (fn (x)
        (if (< x 3)
            1
            (+ (fibby (- x 2)) (fibby (- x 1))))))

(def things '(1 2 3 4 5 6 7))

(show (things.map fibby))


```

Output:

```scheme

12
(2 3 null)
(2 3 (4 5))
(2 3 true null (4 5))
(2 3 true "Yarr!" (4 5))
(1 1 2 3 5 8 13)

```


