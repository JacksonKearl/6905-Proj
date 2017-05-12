;(load "load")

(define (sub-lang-base-component->matcher-lang-leaf base-component)
  (if (in-dict-list? 'amount: (cadr base-component))
       `(,(car base-component) ,@(find-in-dict-list-full 'amount: (cadr base-component)))
       (car base-component)))

(define (sub-lang->matcher-lang recpie)
  (cond ((base-component? recpie) (sub-lang-base-component->matcher-lang-leaf recpie))
        (else  (map sub-lang->matcher-lang recpie))))

#|
(sub-lang->matcher-lang
  '((WHISK ((time: 4 minutes)))
      (EGG   ((amount: 3 units) (description: "free range")))
      (SUGAR ((amount: 4 cups)))))
;Value 3: (whisk (egg 3 units) (sugar 4 cups))

(sub-lang->matcher-lang
  '((deep-fry ((temp: 350 F) (time: 4 min)))
    ((let-rest ((time: 2 hour)))
      ((food-process ((time: 5 min) (description: "scraping occasionally")))
        ((soak ((time: 12 hour)))
          (garbonzo-bean ((amount: 1/2 cup) (description: "cannot be canned!"))))
        ((dice ((description: "coarse")))
          (yellow-onion ((amount: 1/4 unit))))
        ((chop ((description: "coarse")))
          (parsley ((amount: 1/4 cup))))
        (garlic ((amount: 2 unit)))
        (lemon-juice ((amount: 2 tablespoons)))))))

;Value 3: (deep-fry (let-rest (food-process (soak (garbonzo-bean 1/2 cup)) (dice (yellow-onion 1/4 unit)) (chop (parsley 1/4 cup)) (garlic 2 unit) (lemon-juice 2 tablespoons))))
|#

(define ingredient-name car)
(define ingredient-unit caddr)
(define ingredient-quantity cadr)

(define (flatten x)
  (cond ((null? x) '())
        ((and (pair? x) (not (symbol? (car x)))) (append (flatten (car x)) (flatten (cdr x))))
        (else (list x))))

(define (extract-ingredients recipe)
  (get-ingredients (sub-lang->matcher-lang recipe)))

(define (pretty-print-ingredients recipe)
  (let ((ingredients (flatten (extract-ingredients recipe))))
      (map (lambda (x)
        (display " - ")
        (display (ingredient-quantity x))
        (display " ")
        (display (ingredient-unit x))
        (display " of ")
        (display (ingredient-name x))
        (display "\n")) ingredients)))


#|
(extract-ingredients
  '((WHISK ((time: 4 minutes)))
      (EGG   ((amount: 3 units) (description: "free range")))
      (SUGAR ((amount: 4 cups)))))
;Value 3: ((egg 3 units) (sugar 4 cups))

(extract-ingredients
  '((deep-fry ((temp: 350 F) (time: 4 min)))
    ((let-rest ((time: 2 hour)))
      ((food-process ((time: 5 min) (description: "scraping occasionally")))
        ((soak ((time: 12 hour)))
          (garbonzo-bean ((amount: 1/2 cup) (description: "cannot be canned!"))))
        ((dice ((description: "coarse")))
          (yellow-onion ((amount: 1/4 unit))))
        ((chop ((description: "coarse")))
          (parsley ((amount: 1/4 cup))))
        (garlic ((amount: 2 unit)))
        (lemon-juice ((amount: 2 tablespoons)))))))
;Value 4: (((((garbonzo-bean 1/2 cup)) ((yellow-onion 1/4 unit)) ((parsley 1/4 cup)) (garlic 2 unit) (lemon-juice 2 tablespoons))))
|#

(define (pretty-print-recipe name recipe)
  (display "\n\n")
  (display name)
  (display "\n-------------------\n\n")
  (display "Ingredients:\n")
  (pretty-print-ingredients recipe)
  (display "\n\n")
  (display "Instructions:\n")
  (pretty-print-instructions recipe)
  (display "\n\n"))
