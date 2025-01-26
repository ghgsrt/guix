(define-module (features))
 ; #:use-module (features core)
 ; #:use-module (features desktop)
 ; #:use-module (features manifest)
 ; #:use-module (features dev)
 ; #:use-module (features shell)
 ; #:use-module (features terminal)
 ; #:use-module (features virtualization)
 ; #:use-module (features git)
 ; #:use-module (features ssh)
 ; #:use-module (features archive))

(use-modules (features core)
   (features desktop)
   (features manifest)
   (features dev)
   (features shell)
   (features terminal)
   (features virtualization)
   (features git)
   (features ssh)
   (features archive))



;(define to-re-export '((features core)
;   (features desktop)
;   (features manifest)
;   (features dev)
;   (features shell)
;   (features terminal)
;   (features virtualization)
;   (features git)
;   (features ssh)
;   (features archive)))
;(display "interesting")(newline)
;(eval (macroexpand `(use-modules ,@to-re-export)))
;(display "bro")
;(newline)
;(load "./features/desktop.scm")
;(display "huh")
;(newline)
;(load "./features/desktop/wayland.scm")
;(display "balls")
;(newline)

(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
	(begin      
;		(display lst)
		;(macroexpand `(use-modules ,@lst))
		(macroexpand `(re-export ,@lst))))))
;(re-export-list to-re-export)
(re-export-list
        (apply append (map
                                       (lambda (inter)
                                        (module-map (lambda (sym var) sym) inter))
                                        (module-uses (current-module)))))

;(display "for sure")(newline)


;; Load all scheme files from the directories
;(load-features)

;; Re-export all public bindings from any (env features) modules
;(let ((all-bindings
 ;      (module-map (lambda (sym var) sym)
   ;               (resolve-module '(features)))))
  ;(module-re-export! (current-module) all-bindings))

; (define (scm-files directory)
;   (filter (lambda (file)
;             (string-suffix? ".scm" file))
;           (scandir directory)))

; (define (feature-modules directory)
;   (let loop ((dir directory)
;              (prefix '(env features)))
;     (append-map
;      (lambda (file)
;        (let ((full-path (string-append dir "/" file)))
;          (if (directory? full-path)
;              (loop full-path
;                    (append prefix (list (string->symbol file))))
;              (if (string-suffix? ".scm" file)
;                  (list (append prefix
;                         (list (string->symbol
;                                (string-drop-right file 4)))))
;                  '()))))
;      (scandir dir))))

; (define all-features
;   (append-map
;     (lambda (module-name)
;       (let ((mod (resolve-module module-name)))
;         (if mod
;             (module-map (lambda (sym var) var)
;                        (resolve-module module-name))
;             '())))
;     (feature-modules "/config/env/features")))
