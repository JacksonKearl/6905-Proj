;;; return a function which, when given a list of possible substitutions, returns
;;;  an amb which may be any of the valid solutions w.r.t the enviormnet among that list.
(define (iter-amb environment)
  (let ((acceptable? (lambda (item) ((acceptable-given-environment-recursive environment)  item))))
    (lambda (possibilities)
      (list-amb (filter acceptable? possibilities)))))

;;; return a function which when given a symbol of an item will return true iff that symbol is valid wrt the environment
(define (acceptable-given-environment environment)
  (let ((acceptable (car environment))
        (rejectable (cadr environment)))
    (lambda (symbol)
        ;(display "\n      checking if the symbol: ");
        ;(display symbol);
        ;(display " is acceptable... ");
        ;(cond
        ;  ((and (null? acceptable) (null? rejectable)) (display "y"));
        ;  ((null? rejectable) (display (bool (memv symbol acceptable))));
        ;  ((null? acceptable) (display (not  (memv symbol rejectable))));
        ;  (else (error "Can not supply both accptable and rejectable items")));
        ;(display "\n");
        (cond
          ((and (null? acceptable) (null? rejectable)) #t)
          ((null? rejectable) (bool (memv symbol acceptable)))
          ((null? acceptable) (not  (memv symbol rejectable)))
          (else (error "Can not supply both accptable and rejectable items"))))))

;;; return a function which when given a recpie return true iff that recpie is valid wrt the environment
(define (acceptable-given-environment-recursive enviornment)
  (let ((acceptable (car enviornment))
        (rejectable (cadr enviornment)))
    (lambda (recipe)
      (if (base-component? recipe)
        ((acceptable-given-environment enviornment) (car recipe))
        (if (not  ((acceptable-given-environment enviornment) (caar recipe)))
            #f
            (apply boolean/and
              (map
                (lambda (component) ((acceptable-given-environment-recursive enviornment) component))
                (cdr recipe))))))))



;;; return (symbol, lambda) pair such that the lambda, when passed an environment and a (sym (args ...)) list
;;;   will return a (sym ((args... )) (amb) list-item which is valid a substitution for the provided (sym (args ...)) value,
;;;   subject to the restrictions put in place by the environment.
;;;
;;; possibilities-generator should be a function specific to theis symbol, which, when given an arg list,
;;;   returns an object which, when passed to sub-generator-system (called up the enviornment),
;;;   yields some item which may replace this symbol.
(define (create-subtitution sym sub-generator-system possibilities-generator)
  (list
    sym
    (lambda (environment item)
      (if (null? (cdr item))
        ((sub-generator-system environment) (possibilities-generator '()))
        ((sub-generator-system environment) (possibilities-generator (cadr item)))))))

(define (base-component? x) (symbol? (car x)))

(define (reform-recipe recipe environment substitutions)
  ;(display "\n\nAttempting to find substitutions for: ");
  ;(display recipe);
  ;(display "\n");
  (let ((acceptable (acceptable-given-environment environment)))
    (if (base-component? recipe)
      (if (not (acceptable (car recipe)))
          (sub-base-component recipe environment substitutions)
          recipe)
      (if (not  (acceptable (caar recipe)))
          (cons (sub-means-of-combination (car recipe) environment substitutions)
                (map (lambda (component) (reform-recipe component environment substitutions)) (cdr recipe)))
          (cons (car recipe)
                (map (lambda (component) (reform-recipe component environment substitutions)) (cdr recipe)))))))


(define (sub-means-of-combination means-of-combination environment substitutions)
  ((find-in-dict-list (car means-of-combination) substitutions) environment means-of-combination))

(define (sub-base-component base-component environment substitutions)
  ((find-in-dict-list (car base-component) substitutions) environment base-component))
