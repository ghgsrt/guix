(define-module (features desktop)
  #:use-module (features desktop base)
  #:use-module (features desktop qt)
;  #:use-module (features desktop kvantum)
  #:use-module (features desktop wayland))

(display "Loading DESKTOP features")
(newline)

(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
      (macroexpand `(re-export ,@lst)))))
(re-export-list
        (apply append (map
                                        (lambda (inter)
                                        (module-map (lambda (sym var) sym) inter))
                                        (module-uses (current-module)))))

