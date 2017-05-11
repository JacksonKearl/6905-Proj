(load "load")

(define substitutions
  `(,(create-subtitution
      'WHISK
      iter-amb
      (lambda (params)
        `((BEAT ,(scale params '((time: 1/2))))
          (MIX  ,params))))
    ,(create-subtitution
      'EGG
      iter-amb
      (lambda (params)
        `((EGG-WHITE ,(scale params '((amount: 2)))))))))

(define my-recipe
  '((WHISK ((time: 4 minutes)))
      (EGG   ((amount: 3 units) (description: "free range")))
      (SUGAR ((amount: 4 cups)))))

(define pantry '(() (WHISK EGG)))

(print-recipe (reform-recipe my-recipe pantry substitutions))
