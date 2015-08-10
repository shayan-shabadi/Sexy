Sexy
====

**((real 'programs) have.curves)**

Sexy is an object-oriented dialect of Lisp inspired by Scheme, Self, and Perl.

Features:

    * Lisp-1
    * tail-call optimization
    * immutable global environment
    * classless object machinery for easy composition and delegation
    * delimited lexical scope
    * first-class environments
    * first-class delimited continuations
    * object capability security on operating system interfaces
    * restartable exceptions
    * dirty Common-Lisp-style macros
    * lexically scoped module import via HTTP
    * parameterized, recursive modules
    * generic functions with predicate dispatch
    * reader literals for text construction and variable interpolation

Detailed documentation lives in the [wiki](https://github.com/TurtleKitty/Sexy/wiki).

There's a [TL;DR](https://github.com/TurtleKitty/Sexy/wiki/tldr) for those who want a broad overview.

For those who want examples, there are over 1500 lines of Sexy code in the tests directory.

```scheme

(def foo
    (fn (x y)
        (* x y)))

(sys.stdout.say (foo 3 4))

; -> 12

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

(let loop (x baz.head xs baz.tail)
    (when x
        (seq
            (sys.say x)
            (loop xs.head xs.tail))))

; ->
; (2 3 ())
; (2 3 (4 5))
; (2 3 true null (4 5))
; (2 3 true Yarr! (4 5))

(def fibby
    (fn (x)
        (if (< x 3)
            1
            (+ (fibby (- x 2)) (fibby (- x 1))))))

(def things (range 1 20))

(sys.say (things.map fibby))

; -> (1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765)

(def r (: x (+ 1 1) y (+ 1 2)))

; -> (record: x 2 y 3)

(object
    'type 'new-guy
    'view (list 'new-guy things r)
    'square foo
    'fibonacci fibby
    'info (thunk (sys.say "Still alive!"))
    auto:
        '(info)
    resend:
        (list
            (list things 'map 'filter 'sort)
            (list r 'x 'y))
    default:
        (fn (msg)
            (sys.say (cat "What means " msg $?))))

(object
    'type 'new-guy
    'view (list 'new-guy things r.view)
    'square foo
    'fibonacci fibby
    'info (thunk (sys.say "Still alive!"))
    auto:
        '(info)
    resend:
        (list
            (list things 'map 'filter 'sort)
            (list r 'x 'y))
    default:
        (fn (msg)
            (sys.say (cat "What means " msg $?))))

; -> (new-guy (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) (record: y 3 x 2))

```

