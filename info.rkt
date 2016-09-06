#lang setup/infotab

(define name "cnc")
(define scribblings '(("doc/cnc.scrbl" ())))

(define blurb '("Command and Control is a library for sending events to (sub)processes."))
(define primary-file "main.rkt")
(define homepage "https://github.com/lehitoskin/cnc/")

(define version "0.1")
(define release-notes '("Initial release."))

(define required-core-version "6.3")

(define deps '("base"
               "scribble-lib"))
(define build-deps '("racket-doc"))
