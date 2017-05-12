;(cd "..")
;(load "load")
;(cd "extract-instructions")

(define (all-base-components? recipe)
  (if (null? recipe)
      #t
      (and (base-component? (car recipe)) (all-base-components? (cdr recipe)))))

(define (remove-name recipe)
  `((,(caar recipe) ,(del-from-dict-list 'name: (cadar recipe))) ,@(cdr recipe)))

(define (execute-extract-deepest recipe append-to)
  (cond ((base-component? recipe)
            recipe)
        ((all-base-components? recipe)
            (append! append-to `(,(remove-name recipe)))
            `( ,(find-in-dict-list 'name: (cadar recipe))
                (from-step: ,(- (length append-to) 1))))
        (else
            (execute-extract-deepest (map (lambda (x)
              (execute-extract-deepest x append-to)) recipe) append-to)
            `( ,(find-in-dict-list 'name: (cadar recipe))
                (from-step: ,(- (length append-to) 1))))))

(define (recipe->instructions recipe)
  (let ((instructions '(*null*)))
    (set-cdr! instructions '())
    (execute-extract-deepest recipe instructions)
    (cdr instructions)))

(define (reverse1 l)
  (if (null? l)
     '()
     (append (reverse1 (cdr l)) (list (car l)))
  )
)


(define (pretty-print-instructions recipe)
  (let ((instructions (reverse1 (recipe->instructions recipe)))
        (counter 1))
    (map (lambda (instruction)
        (display "\nStep ")
        (display counter)
        (display ":\n")
        (pretty-print instruction)
        (display "\n")
        (set! counter (+ 1 counter)))
      instructions)))

#|
(pretty-print-instructions
  '((WHISK ((time: 4 minutes) (name: whisked-shit)))
      ((MIX ((name: mixed-eggs)))
        (EGG   ((amount: 3 units) (description: "free range")))
        (SUGAR ((amount: 4 cups))))))

Step 1: ((mix ())
          (egg ((amount: 3 units) (description: "free range")))
          (sugar ((amount: 4 cups))))

Step 2: ((whisk ((time: 4 minutes)))
          (mixed-eggs (from-step: 1)))
|#

#|
(pretty-print-instructions
  '((deep-fry ((temp: 350 F) (time: 4 min) (name: final-product!)))
    ((let-rest ((time: 2 hour) (name: rested-dough)))
      ((food-process ((time: 5 min) (description: "scraping occasionally") (name: processed-ingredients)))
        ((soak ((time: 12 hour) (name: soaked-beans)))
          (garbonzo-bean ((amount: 1/2 cup) (description: "cannot be canned!"))))
        ((dice ((description: "coarse") (name: diced-onions)))
          (yellow-onion ((amount: 1/4 unit))))
        ((chop ((description: "coarse") (name: chopped-parsley)))
          (parsley ((amount: 1/4 cup))))
        (garlic ((amount: 2 unit)))
        (lemon-juice ((amount: 2 tablespoons)))))))

Step 1: ((soak ((time: 12 hour)))
            (garbonzo-bean ((amount: 1/2 cup) (description: "cannot be canned!"))))

Step 2: ((dice ((description: "coarse")))
            (yellow-onion ((amount: 1/4 unit))))

Step 3: ((chop ((description: "coarse")))
            (parsley ((amount: 1/4 cup))))

Step 4: ((food-process ((time: 5 min) (description: "scraping occasionally")))
            (soaked-beans (from-step: 1))
            (diced-onions (from-step: 2))
            (chopped-parsley (from-step: 3))
            (garlic ((amount: 2 unit)))
            (lemon-juice ((amount: 2 tablespoons))))

Step 5: ((let-rest ((time: 2 hour)))
            (processed-ingredients (from-step: 4)))

Step 6: ((deep-fry ((temp: 350 f) (time: 4 min)))
            (rested-dough (from-step: 5)))
|#
