#lang racket/base
; srv.rkt
; this is the command server that other (sub)processes take commands from
(require racket/contract data/queue)
(provide (contract-out
          [struct cnc ((locked? boolean?) (queue queue?))]
          [cnc-command cnc?]
          [cnc-procs hash-eq?]
          [cnc-srv! (-> void?)]
          [cnc-add-cmd! (-> symbol? any/c ... void?)]
          [cnc-add-proc! (-> symbol? procedure? void?)]))

; queue of pairs
(struct cnc (locked? queue) #:transparent #:mutable)
(define cnc-command (cnc #f (make-queue)))
; hash of process id's and thunks
(define cnc-procs (make-hasheq))

; run all the commands from the command queue
; dequeue as we loop
(define (cnc-srv!)
  (for ([len (queue-length (cnc-queue cnc-command))])
    (let loop ()
      (cond
        [(cnc-locked? cnc-command)
         (eprintf "cnc-srv!: command queue is locked, trying again...\n")
         (sleep .5)
         (loop)]
        [else
         ; lock the queue
         (set-cnc-locked?! cnc-command #t)
         (define cmd-pair (dequeue! (cnc-queue cnc-command)))
         ; name of the procedure
         (define id (car cmd-pair))
         ; may be a list
         (define cmd (cdr cmd-pair))
         (define proc (hash-ref cnc-procs id))
         (apply proc cmd)
         ; unlock the queue
         (set-cnc-locked?! cnc-command #f)]))))

; add a command to the queue
; tell cnc-srv to broadcast cmd to the right process
; takes an id symbol and optional arguments
; id symbol must be a key in cnc-procs
(define (cnc-add-cmd! id . args)
  (if (hash-has-key? cnc-procs id)
      (let loop ()
        (cond
          [(cnc-locked? cnc-command)
           (eprintf "cnc-add-cmd!: command queue is locked, trying again...\n")
           (sleep .5)
           (loop)]
          [else
           (set-cnc-locked?! cnc-command #t)
           (enqueue! (cnc-queue cnc-command) (cons id args))
           (set-cnc-locked?! cnc-command #f)]))
      (raise-argument-error 'cnc-add-cmd! "id as a key in cnc-procs" id)))

; add a new process to be supervised by cnc-srv
; takes a symbol and a procedure thunk
(define (cnc-add-proc! id thunk)
  (hash-set! cnc-procs id thunk))

; just in case we no longer want to track a procedure
(define (cnc-del-proc! id)
  (hash-remove! cnc-procs id))
