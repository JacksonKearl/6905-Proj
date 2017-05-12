;Instruction Extraction



(define (instruction? node)
  (not (ingredient? node)))

#|
(instruction? '(bake (a 2 "cups") (b 3 "tsp")))
;Value: #t

(instruction? '(b 3 "tsp"))
;Value: #f
|#


;represents order of instructions in reverse
(define instructions-stack '())


(define (push-onto-instructions-stack node)
  (set! instructions-stack (append instructions-stack (list node)))
  instructions-stack)
#|
instructions-stack
;Value ()

(push-onto-instructions-stack '(bake (a 2 "cups")))
;Value : ((bake (a 2 "cups")))

(push-onto-instructions-stack '(mix (b 1 "tsp") (c 3 "tbsp")))
;Value : ((bake (a 2 "cups")) (mix (b 1 "tsp") (c 3 "tbsp")))
|#


(define (instruction-as-ingredient instruction)
  `((,(string->symbol (string-append "ingredients that were " (symbol->string instruction) "ed") )    )) )

#|
(instruction-as-ingredient 'bake)
;Value: |ingredients that were bake|
|#


(define (split-instructions recipe)
  (if (ingredient? recipe)
      recipe
      (let loop ((instr (list (car recipe)))
		 (node-children (cdr recipe)))
	(if (eq? (length node-children) 0)
	    (push-onto-instructions-stack instr)
	    (if (ingredient? (car node-children))
		(loop (append instr (list (car node-children)))
		      (cdr node-children))
		(begin (loop (append instr
				     (instruction-as-ingredient (caar node-children)))
			     (cdr node-children))
		       (split-instructions (car node-children))))))))


(define (instructions-in-order instructions)
  (if (eq? (length instructions) 1)
      (list (car instructions))
      (append (instructions-in-order (cdr instructions))
	      (list (car instructions)))))

(define (extract-instructions recipe)
  (instructions-in-order
   (split-instructions (recipe))))


#|
(instructions-in-order '((a) (b) (c)))
;Value : ((c) (b) (a))
|#
