; Utility code that doesn't find anywhere else and has a portable
; implementation.

(library (util)
  (export fprintf
          char-symbolic?
          char-punctuation?
          current-seconds
          hashtable-for-each
          load)
  (import (rnrs)
          (rnrs eval)
          (prefix (srfi :19) srfi-19:)
          (srfi :48))
  

  (define (fprintf output-port format-string . rest)
    (display (apply format (cons format-string rest))
             output-port))

  ; returns #t if char's Unicode general category is Sm, Sc, Sk, or So, #f
  ; otherwise.
  (define (char-symbolic? . args) (raise 'unimplemented))
  (define (char-punctuation? . args) (raise 'unimplemented))

  ; return current UTC seconds since epoch
  (define (current-seconds)
    (srfi-19:time-second (srfi-19:current-time)))

  ; "applies the procedure proc to each element in hashtable (for the
  ; side-effects of proc) in an unspecified order and returns void. The
  ; procedure proc must take two arguments: a key and its value."
  (define (hashtable-for-each hashtable proc)
    (let-values (((keys values) (hashtable-entries hashtable)))
      (vector-for-each proc keys values)))

  (define (load file . import-spec)
    (eval (cons 'let (cons '() (read-forms file)))
          (apply environment import-spec)))

  (define (read-forms file)
    (with-input-from-file file
      (lambda ()
        (let loop ()
          (let ((form (read)))
            (if (not (eof-object? form))
                (cons form (loop))
                '()))))))
)
