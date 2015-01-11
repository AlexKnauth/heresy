#lang racket/base

(provide test
         check-expect
         (all-from-out rackunit)
         )

(require rackunit
         (for-syntax racket/base
                     syntax/parse
                     syntax/stx
                     ))

(begin-for-syntax
  (define within-test 'within-test)
  (define (syntax-within-test stx)
    (syntax-property stx within-test #t))
  (define (syntax-within-test? stx)
    (syntax-property stx within-test))
  (define (test-context?)
    (member (syntax-local-context) '(module)))
  )
  

(define-syntax test
  (lambda (stx)
    (syntax-parse stx
      [(test form ...)
       #:fail-unless (test-context?) "must be used at the top level of a module"
       #:with (new-form ...) (stx-map syntax-within-test #'(form ...))
       (syntax/loc stx (module+ test new-form ...))])))

(define-syntax check-expect
  (lambda (stx)
    (syntax-parse stx
      [(check-expect actual expected)
       #:fail-when (syntax-within-test? stx) "use check-equal? instead within a test form"
       #:fail-unless (test-context?) "must be used at the top level of a module"
       #:with chk (syntax/loc stx (check-equal? actual expected))
       (syntax/loc stx (test chk))])))

