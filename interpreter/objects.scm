
(define (sexy-gensym #!optional (name "gensym"))
    (string->symbol
        (string-append name "-" (uuid-v4))))

(define (sexy-record . args)
    (define this (mkht))
    (define vars (mkht))
    (hts! this 'type 'record)
    (for-pairs
        (lambda (k v)
            (hts! vars k v))
        args)
    (hts! this 'vars vars)
    this)

(define (sexy-environment mama)
    (define this (mkht))
    (define vars (sexy-record))
    (hts! this 'type 'env)
    (hts! this 'vars vars)
    (hts! this 'mama (if mama mama 'null))
    this)

(define (sexy-proc code env compiled)
    (define this (mkht))
    (define (tset! k v) (hts! this k v))
    (tset! 'type 'proc)
    (tset! 'env env)
    (tset! 'code code)
    (tset! 'exec compiled)
    (if (pair? code)
        (let ((formals ((if (eq? (car code) 'macro) caddr cadr) code)))
            (tset! 'formals formals)
            (tset! 'arity (length formals)))
        (begin
            (tset! 'formals 'null)
            (tset! 'arity 0)))
    this)

(define (sexy-object args autos resends initial)
    (define this (mkht))
    (define fields (mkht))
    (define delegates (mkht))
    (define autoexec (mkht))
    (define (tset! k v)
        (hts! this k v))
    (define (fset! k v)
        (hts! fields k v))
    (define (aset! k)
        (hts! autoexec k #t))
    (define (rset! k v)
        (hts! delegates k v))
    (define (set-resend! rlist)
        (let ((delegate (car rlist)) (msgs (cdr rlist)))
            (map (lambda (msg) (rset! msg delegate)) msgs)))
    (for-pairs fset! args)
    (if resends
        (map set-resend! resends)
        #f)
    (if autos
        (map aset! autos))
    (tset! 'type 'object)
    (tset! 'fields fields)
    (tset! 'autos autoexec)
    (tset! 'resends delegates)
    (tset! 'default
        (or initial
            (sexy-proc
                primitive-type
                'object
                (lambda (args opts cont err)
                    (idk this (car args) cont err)))))
    this)

(define (sexy-fs-listener path)
    (define l (unix-listen path))
    (sexy-object
        (list
            'type   'fs-listener
            'view   (list 'fs-listener path)
            'to-bool #t
            'path   path
            'ready? (lambda () (unix-accept-ready? l))
            'accept (lambda ()
                        (let-values (((in out) (unix-accept l)))
                            (sexy-fs-socket path in out)))
            'close  (lambda () (unix-close l) 'null)
        )
        '(ready? accept close)
        #f
        #f))

(define (sexy-fs-socket path in out)
    (sexy-object
        (list
            'type   'fs-socket
            'view   (list 'socket path)
            'to-bool #t
            'path path
            'close (lambda ()
                       (close-input-port in)
                       (close-output-port out)
                       'null)
        )
        '(read read-rune read-line nl close)
        (list
            (list in 'read 'read-rune 'peek-rune 'assert-rune 'read-line 'ready?
                     'skip 'skip-while 'skip-until 'read-token 'read-token-while
                     'read-token-until 'read-token-if)
            (list out 'write 'print 'say 'nl))
        #f))

(define (sexy-tcp-listener host port)
    (define l (tcp-listen port 100 host))
    (sexy-object
        (list
            'type   'tcp-listener
            'view   (list 'tcp-listener host port)
            'to-bool #t
            'port   (tcp-listener-port l)
            'ready? (lambda () (tcp-accept-ready? l))
            'accept (lambda ()
                        (let-values (((in out) (tcp-accept l)))
                            (sexy-tcp-socket in out)))
            'close  (lambda () (tcp-close l) 'null)
        )
        '(ready? accept close)
        #f
        #f))

(define (sexy-tcp-socket in out)
    (define-values (l-addr r-addr) (tcp-addresses in))
    (define-values (l-port r-port) (tcp-port-numbers in))
    (sexy-object
        (list
            'type   'tcp-socket
            'view   (list 'socket l-addr l-port '-> r-addr r-port)
            'to-bool #t
            'local-addr l-addr
            'local-port l-port
            'remote-addr r-addr
            'remote-port r-port
            'close (lambda ()
                       (close-input-port in)
                       (close-output-port out)
                       'null)
        )
        '(read read-rune read-line nl close)
        (list
            (list in 'read 'read-rune 'peek-rune 'assert-rune 'read-line 'ready?
                     'skip 'skip-while 'skip-until 'read-token 'read-token-while
                     'read-token-until 'read-token-if)
            (list out 'write 'print 'say 'nl))
        #f))


