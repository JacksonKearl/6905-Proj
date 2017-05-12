;Instruction Extraction

(define (instruction? node)
  (not (ingredient? node)))

(define instructions-stack '())

(define (push-onto-instructions-stack node)
  (set! instruction-stack (append instruction-stack (list node)))
  instruction-stack)

(define (instruction-as-ingredient instruction)
  (string-append "ingredients that were " instruction))

(define (split-instructions recipe)
  (if (ingredient? recipe)
      recipe
      (let loop ((instr (list (car recipe)))
		 (node-children (cdr recipe)))
	(if (eq? (length node-children) 0)
	    (push-onto-instructions-stack instr)
	    (if (ingredient? (car node-children))
		(loop (append instr (car node-children))
		      (cdr node-children))
		(begin (loop (append instr 
				     (instruction-as-ingredient (caar node-children)))
			     (cdr node-children))
		       (split-instruction (car node-children))))))))


(define (instructions-in-order instructions)
  (if (eq? (length instructions) 1)
      (car instructions)
      (append (instructions-in-order (cdr instructions))
	      (list (car instructions)))))

(define (extract-instructions recipe) 
  (instructions-in-order 
   (split-instruction (recipe))))

