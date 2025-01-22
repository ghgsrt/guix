(define-module (features)
  #:use-module (lib path)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex))

;; Load all scheme files from the directories
(load-features)

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
