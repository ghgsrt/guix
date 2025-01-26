(define-module (utils)
  #:use-module (utils path))

(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
      (macroexpand `(re-export ,@lst)))))
(re-export-list
        (apply append (map
                                        (lambda (inter)
                                                (module-map (lambda (sym var) sym) >
                                        (module-uses (current-module)))))


;(load "./utils/path.scm")
;(load-utils)
