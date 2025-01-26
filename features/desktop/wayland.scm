(define-module (features desktop wayland)
  #:use-module (features desktop wayland base)
  #:use-module (features desktop wayland sway))

(display "Loading WAYLAND features")
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

