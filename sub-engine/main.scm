(load "load")

(define falafel
  '((deep-fry ((temp: 350 F) (time: 4 min)))
    ((let-rest ((time: 2 hour)))
      ((food-process ((time: 5 min)
                      (description: "scrape occasionally")))
        ((soak ((time: 12 hour)))
          (garbonzo-bean ((amount: 1/2 cup)
                          (description: "cannot be canned!"))))
        ((dice ((description: "coarse")))
          (yellow-onion ((amount: 1/4 unit))))
        ((chop ((description: "coarse")))
          (parsley ((amount: 1/4 cup))))
        (garlic ((amount: 2 unit)))
        (lemon-juice ((amount: 2 tablespoons)))))))

(define pantry '(() (deep-fry lemon-juice parsley)))

(amb-possibility-list (print-recipe
  (customize-recipe falafel pantry)))
