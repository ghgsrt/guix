(define-module (features dev)
  #:use-module (features dev guile))

(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
     (macroexpand `(re-export ,@lst)))))
(re-export-list
        (apply append (map
                                        (lambda (inter)
                                        (module-map (lambda (sym var) sym) inter))
                                        (module-uses (current-module)))))

