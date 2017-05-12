(load "load")

(define (acceptable-given-environment environment)
    (lambda (item)
      (if (eqv? (car item) 'resistor)
        (bool (memv (find-in-dict-list 'measure: (cadr item)) (cdr environment)))
        #t)))

(define (serial-parallel-amb environment)
  (lambda (possibility)
    (let ((substitution (car possibility))
          (target (cadr possibility)))
      (if (roughly-equal? (resistance (car possibility)) target (car environment))
        (car possibility)
        (amb)))))

 (define E24
   (shuffle (apply append
     (map (lambda (base)
       (map (lambda (x) (* base x))
        '(10 11 12 13 15 16 18 20 22 24 27 30 33 36 39 43 47 51 56 62 68 75 82 91)))
        '(10 100 1000)))))

(define (resistance net)
  (cond ((eqv? 'resistor (car net))  (find-in-dict-list 'measure: (cadr net) ))
        ((eqv? 'parallel (caar net)) (/ 1 (apply + (map (lambda (x) (/ 1 (resistance x))) (cdr net)))))
        ((eqv? 'series   (caar net)) (apply + (map (lambda (x) (resistance x)) (cdr net))))))

(define substitutions
  `(,(create-subtitution
      'resistor
      serial-parallel-amb
      (lambda (params)
        (amb
          `((resistor ((measure: ,(list-amb E24)))) ,(find-in-dict-list 'measure: params))
          `(((series ()) (resistor ((measure: ,(list-amb E24)))) (resistor ((measure: ,(list-amb E24))))) ,(find-in-dict-list 'measure: params))
          `(((parallel ()) (resistor ((measure: ,(list-amb E24)))) (resistor ((measure: ,(list-amb E24))))) ,(find-in-dict-list 'measure: params))
          `(((series ()) (resistor ((measure: ,(list-amb E24)))) ((parallel ()) (resistor ((measure: ,(list-amb E24)))) (resistor ((measure: ,(list-amb E24)))))) ,(find-in-dict-list 'measure: params)))))))

(define my-circuit
  '(resistor ((measure: 1752 ohms))))

(define (disp-circuit-with-resistance circuit)
  (display (exact->inexact (resistance circuit)))
  (display "0 Ohm:\n")
  (pretty-print  circuit)
  (display "\n\n"))

;(disp-circuit-with-resistance (reform-recipe my-circuit `(0.01 ,E24) substitutions))
(amb-possibility-list (disp-circuit-with-resistance (reform-recipe my-circuit `(0.001 ,E24) substitutions)))
