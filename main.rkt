#lang racket/base
; main.rkt
; cnc is the command and control library for sending events to a command process
; that takes arbitrary thunks and controls other (sub)processes.
(require "srv.rkt")
(provide (all-from-out "srv.rkt"))
