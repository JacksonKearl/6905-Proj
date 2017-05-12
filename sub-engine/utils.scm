(require 'pretty-print)

;;; yield the k-v list 'dict', but each k which matches a k in factor is is
;;;    scaled by the corresponding factors value
(define (scale dict factors)
  (map (lambda (k-v-pair)
    (let ((key (car k-v-pair))
          (value (cadr k-v-pair))
          (rest (cddr k-v-pair)))
      (cons key
            (cons (if (in-dict-list? key factors)
                      (* value (find-in-dict-list key factors))
                      value)
                  rest))))
    dict))


(define (in-dict-list? key dict-list)
  (cond ((null? dict-list) #f)
        ((eqv? key (caar dict-list)) #t)
        (else (in-dict-list? key (cdr dict-list)))))

(define (del-from-dict-list key dict-list)
  (cond ((null? dict-list) '())
        ((eqv? key (caar dict-list)) (del-from-dict-list key (cdr dict-list)))
        (else (cons (car dict-list) (del-from-dict-list key (cdr dict-list))))))

(define (find-in-dict-list key dict-list)
  (cond ((null? dict-list) (amb))
        ((eqv? key (caar dict-list)) (cadar dict-list))
        (else (find-in-dict-list key (cdr dict-list)))))

(define (find-in-dict-list-or-default key dict-list default)
  (cond ((null? dict-list) default)
        ((eqv? key (caar dict-list)) (cadar dict-list))
        (else (find-in-dict-list-or-default key (cdr dict-list) default))))

(define (bool x) (not (not x)))

(define (print-recipe recipe)
  (display "\n")
  (pretty-print recipe)
  (display "\n"))

(define (roughly-equal? actual target error)
  (let ((%error (/ (- actual target) target)))
    (< (abs %error) error)))

(define (shuffle x)
  (do ((v (list->vector x)) (n (length x) (- n 1)))
      ((zero? n) (vector->list v))
    (let* ((r (random n)) (t (vector-ref v r)))
      (vector-set! v r (vector-ref v (- n 1)))
      (vector-set! v (- n 1) t))))
