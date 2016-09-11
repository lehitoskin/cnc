#lang racket/base
; test-srv.rkt
; test file for the srv definitions
(require data/queue "../srv.rkt")

#| Test for locked queue - (might not happen anyway) |#
(cnc-add-proc! 'foo (λ (x) (displayln x)))
(cnc-add-proc! 'bar (λ (y) (displayln (+ y 5))))
(cnc-add-cmd! 'foo 50)
(cnc-add-cmd! 'foo "foo")
(cnc-add-cmd! 'foo "bar")
(cnc-add-cmd! 'foo 'baz)
(cnc-add-cmd! 'foo 'bin)
(cnc-add-cmd! 'bar 10)
(cnc-add-cmd! 'bar 11)
(cnc-add-cmd! 'bar 12)
(cnc-add-cmd! 'bar 13)
(cnc-add-cmd! 'bar 14)
(cnc-add-cmd! 'bar 15)
(cnc-add-cmd! 'bar 16)
(cnc-add-cmd! 'bar 17)
(cnc-add-cmd! 'bar 18)
(cnc-add-cmd! 'bar 19)
(cnc-add-cmd! 'bar 20)

(printf "Queue length: ~a\n" (queue-length (cnc-queue cnc-command)))
(thread cnc-srv!)

(cnc-add-cmd! 'bar 21)
(cnc-add-cmd! 'bar 22)
(cnc-add-cmd! 'bar 23)

(cnc-srv!)
#| End test for locked queue |#

(let ([baz (λ (z) (displayln (sqrt z)))])
  (cnc-add-proc! 'baz baz))
(cnc-add-cmd! 'baz 16)
(newline)
(cnc-srv!)
