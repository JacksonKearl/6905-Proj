# 6905-Proj

(make-recipe (bread 2)
  ((bake 45 minutes 450 F)
    (mix
      ((let-rest 15 minutes)
        (mix
          (yeast 1 packet)
          (warm-water 1 cup)
          (sugar 1 tablespoon)))
      (flour 3 cup))))

(gluten-free? bread)
=> #f

(define ->gluten-free
  (make-preference-message
    (all-ingridients)  ; set of ingridients to pull from
    (gluten)           ; force to not contain
    ()))               ; optional cost function

(->gluten-free bread)
=> ((bake 45 minutes 450 F)
..   (mix
..     ((let-rest 15 minutes)
..       (mix
..         (yeast 1 packet)
..         (warm-water 1 cup)
..         (sugar 1 tablespoon)))
..     (almond-flour 3 cup)))

(faster bread)
=> ((bake 30 minutes 500 F)
..   (mix
..     ((let-rest 10 minutes)
..       (mix
..         (yeast 1 packet)
..         (hot-water 1 cup)
..         (sugar 1 tablespoon)))
..     (flour 3 cup)))

(faster (->gluten-free bread))
=> ((bake 30 minutes 500 F)
..   (mix
..     ((let-rest 10 minutes)
..       (mix
..         (yeast 1 packet)
..         (hot-water 1 cup)
..         (sugar 1 tablespoon)))
..     (almond-flour 3 cup)))

((for 4) bread)
=> ((bake 45 minutes 450 F)
..   (mix
..     ((let-rest 15 minutes)
..       (mix
..         (yeast 2 packet)
..         (warm-water 2 cup)
..         (sugar 2 tablespoon)))
..     (flour 6 cup)))
