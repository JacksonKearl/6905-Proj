(load "load")

(define falafel
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

(pretty-print-recipe 'falfel falafel)

(define pantry '(() (deep-fry lemon-juice parsley)))

(pretty-print-recipe 'falfel  (customize-recipe falafel pantry))
