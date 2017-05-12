(define substitutions `(

    ,(create-subtitution
      'deep-fry
      iter-amb
      (lambda (params)
        (let ((temp (find-in-dict-list-or-default 'temp: params 350))
              (params (del-from-dict-list 'temp: params)))

          `(,(cond ((< temp 250) `(pan-fry ,(cons '(temp: low) params)))
                   ((> temp 400) `(pan-fry ,(cons '(temp: high) params)))
                   (else         `(pan-fry ,(cons '(temp: med) params))))))))

    ,(create-subtitution
      'parsley
      iter-amb
      (lambda (params)
        `((italian-parsley ,params))))

    ,(create-subtitution
      'lemon-juice
      iter-amb
      (lambda (params)
        `(((combine (name: diluted-lime-juice))
            (lime-juice ,(scale params '((amount: 1/2))))
            (water      ,(scale params '((amount: 1/2)))))
          ((boil ((time: 5 min) (name: concentrated-orange-juice)))
            (orange-juice ,(scale params '((amount: 2))))))))))
