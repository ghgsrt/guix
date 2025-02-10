(define-module (home services terminals)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (foot-services))

;; ~~ FOOT ~~

(define foot-service-type
  (bos-home-service-type 'bos-foot
	#:packages (list foot)))
	;#:env-vars `(("TERMINAL" . "foot"))))

(define foot-services
	(list (service foot-service-type)))
; (define-syntax foot-services
; 	(identifier-syntax (_foot-services)))
