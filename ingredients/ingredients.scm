(define (children node)
      (filter list? (cdr node)))

(define (leaf? node)
  (and (list? node)  (eq? (length (children node)) 0)))

(define (ingredient? node)
  (and (list? node) (leaf? node) (eq? (length node) 3)))

(define (fold1 kons knil lst)
  (if (null? lst)
      knil
      (fold1 kons (kons (car lst) knil) (cdr lst))))

(define (flatten lists)
  (fold1 (lambda (right left)
           (append left (flatten right)))
         '()
         lists))

(define (split-ingredients-list nodelist)
  (if (and (list? nodelist) (not (null? nodelist)))
      (let ((curnode (car nodelist)))
	(if (ingredient? curnode)
	    (cons curnode (split-ingredients-list (cdr
							    nodelist)))
	    (if (list? curnode)
		(flatten
		 (cons (split-ingredients-list (children curnode))
		       (split-ingredients-list (cdr nodelist))))
		(split-ingredients-list (cdr nodelist)))))
      '()))

;Tests work, although need to document them with better cases

#|
 (split-ingredients-list '(bake (a 3 "sdf") (b 4 "sdf")))
;Value 13: ((a 3 "sdf") (b 4 "sdf"))

 (split-ingredients-list '(bake (a 3 "sdf") (a 4 "sdf")))
;Value 14: ((a 3 "sdf") (a 4 "sdf"))
|#

;abstract into a single load function in top level
(cd "5pset")
(load "load.scm")
(cd "../")

(define (ingredient<? x y)
  (if (and (ingredient? x) (ingredient? y))
      (if (expr<? (car x) (car y))
	  #t
	  (if (eqv? (car x) (car y))
	      (expr<? (caddr x) (caddr y))
	      #f))
      #f))

#|
 (ingredient<? '(a 4 c) '(b 3 b))
;Value: #t

 (ingredient<? '(a 4 c) '(a 5 b))
;Value: #f
|#

(define ingredient-simplifier
  (rule-simplifier
   (list
    
    (rule `((?? y) (((?? x))) (?? z))
	  `(,@y (,@x) ,@z))

    (rule `((?? x) (? a) (? b) (?? y))
	  (and (ingredient<? b a)
	       `(,@x ,b ,a ,@y)))

    (rule `((?? x) ((? a) (? b ,number?) (? c)) ((? a) (? d
							    ,number?)
						   (? c))
	    (?? z))
	  `(,@x (,a ,(+ b d) ,c) ,@z))

    (rule `((?? x) ((? a) 0 (? c)) (?? y))
	  `(,@x ,@y))

    (rule `((?? x) ((? a) (? b ,number?) tbsp) ((? a) (? c ,number?) tsp) (?? y))
	  `(,@x (,a ,(+ b (/ c 3)) tbsp) ,@y))

    )))

#|

 (ingredient-simplifier '((a 3 g) (a 4 g)))
;Value 38: ((a 7 g))

 (ingredient-simplifier  '((a 3 sdf) (b 4 sdf) (a 4 sdf)))
;Value 39: ((a 7 sdf) (b 4 sdf))

 (ingredient-simplifier '((a 3 h) (a 4 g)))
;Value 40: ((a 4 g) (a 3 h))

 (ingredient-simplifier '((honey 5 tsp) (honey 3 tbsp)))
;Value 45: ((honey 14/3 tbsp))

|#

(define (get-ingredients recipe)
  (ingredient-simplifier (split-ingredients-list recipe)))

#|Using top level extract ingredients (which glues get-ingredients to
a translator of the description supporting recipe language):

 (extract-ingredients '((deep-fry ((temp: 350 F) (time: 4 min) (name: final-product!)))
    ((let-rest ((time: 2 hour) (name: rested-dough)))
      ((food-process ((time: 5 min) (description: "scraping occasionally") (name: processed-ingredients)))
        ((soak ((time: 12 hour) (name: soaked-beans)))
          (garbonzo-bean ((amount: 1/2 cup) (description: "cannot be
canned!")))
	  (lemon-juice ((amount: 1 tsp))))
        ((dice ((description: "coarse") (name: diced-onions)))
          (yellow-onion ((amount: 1/4 unit))))
        ((chop ((description: "coarse") (name: chopped-parsley)))
          (parsley ((amount: 1/4 cup))))
        (garlic ((amount: 2 unit)))
        (lemon-juice ((amount: 2 tbsp)))))))
;Value 37: ((garbonzo-bean 1/2 cup) (garlic 2 unit) (lemon-juice 7/3
tbsp) (parsley 1/4 cup) (yellow-onion 1/4 unit))

|#
