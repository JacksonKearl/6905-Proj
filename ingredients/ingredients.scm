(define (children node)
      (filter list? (cdr node)))

(define (leaf? node)
  (and (list? node)  (eq? (length (children node)) 0)))

(define (ingredient? node)
  (and (list? node) (leaf? node) (eq? (length node) 3)))

(define (split-ingredients-list nodelist)
  (if (and (list? nodelist) (not (null? nodelist)))
      (let ((curnode (car nodelist)))
	(if (ingredient? curnode)
	    (cons curnode (split-ingredients-list (cdr
							    nodelist)))
	    (if (list? curnode)
		(cons (split-ingredients-list (children curnode))
			(split-ingredients-list (cdr nodelist)))
		(split-ingredients-list (cdr nodelist)))))
      '()))

;Tests work, although need to document them with better cases

#|
 (split-ingredients-list '(bake (a 3 "sdf") (b 4 "sdf")))
;Value 13: ((a 3 "sdf") (b 4 "sdf"))

 (split-ingredients-list '(bake (a 3 "sdf") (a 4 "sdf")))
;Value 14: ((a 3 "sdf") (a 4 "sdf"))
|#

(cd "5pset")
(load "load.scm")
(cd "../")

(define ingredient-simplifier
  (rule-simplifier
   (list

    (rule `((?? x) ((? a) (? b ,number?) (? c)) (?? y)  ((? a) (? d
							    ,number?)
						   (? c))
	    (?? z))
	  `(,@x (,a ,(+ b d) ,c) ,@y ,@z))

    )))

#|

 (ingredient-simplifier '((a 3 g) (a 4 g)))
;Value 15: ((a 7 g))

 (ingredient-simplifier  '((a 3 "sdf") (b 4 "sdf") (a 4 "sdf")))
;Value 16: ((a 7 "sdf") (b 4 "sdf"))

 (ingredient-simplifier '((a 3 g) (a 4 h)))
;Value 17: ((a 3 g) (a 4 h))

|#
