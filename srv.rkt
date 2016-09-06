#lang racket/base
; srv.rkt
; this is the command server that other (sub)processes take commands from
(require racket/contract data/queue)
(provide (contract-out
          [cnc-add-cmd! (-> symbol? (listof any/c) void?)]
          [cnc-add-proc! (-> symbol? procedure? void?)]))

; single queue of hashes
(define cnc-command-queue (make-queue))
; hash of process id's and thunks
(define cnc-procs (make-hash))

(define (cnc-srv . args)
  (for ([arg (in-list args)])
    (printf "~v~n" arg)))

; add a command to the queue
; tell cnc-srv to broadcast cmd to the right process
; takes a symbol and optional arguments
(define (cnc-add-cmd! cmd . args)
  (enqueue! cnc-command-queue (make-hash `(,cmd . args))))

; add a new process to be supervised by cnc-srv
; takes a symbol and a procedure thunk
(define (cnc-add-proc! id thunk)
  (enqueue! cnc-procs (make-hash `(,id . thunk))))
