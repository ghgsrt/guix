(define-module (utils)
  #:use-module (utils path))


(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
        (begin
;               (display lst)
                ;(macroexpand `(use-modules ,@lst))
                (macroexpand `(re-export ,@lst))))))
;(re-export-list to-re-export)
(re-export-list
        (apply append (map
                                       (lambda (inter)
                                        (module-map (lambda (sym var) sym) inter))
                                        (module-uses (current-module)))))

;(load "./utils/path.scm")
;(load-utils)
