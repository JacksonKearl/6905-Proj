;(cd "..")
;(load "load")
;(cd "Instructions")
;(load "inst_extraction")

(define new-recipe
  '(bake
   (mix
    (eggs 1 "egg")
    (milk 1.5 "cups")
    (sugar 1 "cups")
    (sift
     (flour 2 "cups")
     (baking-soda 1 "tsp"))
    (vanila 0.5 "tsp"))))

(reverse1 (split-instructions new-recipe))
