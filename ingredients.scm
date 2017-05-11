(define (children node)
  (filter list? (cdr node)))

(define (leaf? node)
  (eq? (length (children node)) 0))

(define (ingredient? node)
  (and (leaf? node) (eq? (length node) 3)))

(define (split-ingredients-list nodelist)
  (let ((curnode (car nodelist)))
    (if (ingredient? curnode)
	(append (list curnode) (split-ingredients-list (cdr nodelist)))
	(begin
	  (append (split-ingredients-list (children node))
		  (split-ingredients-list (cdr nodelist)))))))

;Think this is more or less right but need to test and think about it
;more, pushing atm so y'all have it
